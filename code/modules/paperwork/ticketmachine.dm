//Bureaucracy machine!
//Simply set this up in the hopline and you can serve people based on ticket numbers

/obj/machinery/ticket_machine
	name = "ticket machine"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "ticketmachine"
	base_icon_state = "ticketmachine"
	desc = "A marvel of bureaucratic engineering encased in an efficient plastic shell. It can be refilled with a hand labeler refill roll and linked to buttons with a multitool."
	density = FALSE
	maptext_height = 26
	maptext_width = 32
	maptext_x = 7
	maptext_y = 10
	layer = HIGH_OBJ_LAYER
	var/ticket_number = 0 //Increment the ticket number whenever the HOP presses his button
	var/current_number = 0 //What ticket number are we currently serving?
	var/max_number = 100 //At this point, you need to refill it.
	var/cooldown = 50
	var/ready = TRUE
	var/id = "ticket_machine_default" //For buttons

/obj/machinery/ticket_machine/Initialize(mapload)
	. = ..()
	update_appearance()

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/ticket_machine, 32)

/obj/machinery/ticket_machine/multitool_act(mob/living/user, obj/item/I)
	if(!multitool_check_buffer(user, I)) //make sure it has a data buffer
		return
	var/obj/item/multitool/M = I
	M.buffer = src
	to_chat(user, span_notice("You store linkage information in [I]'s buffer."))
	return TRUE

/obj/machinery/ticket_machine/emag_act(mob/user) //Emag the ticket machine to dispense burning tickets, as well as randomize its number to destroy the HoP's mind.
	if(obj_flags & EMAGGED)
		return
	to_chat(user, span_warning("You overload [src]'s bureaucratic logic circuitry to its MAXIMUM setting."))
	ticket_number = rand(0,max_number)
	current_number = ticket_number
	obj_flags |= EMAGGED
	update_appearance()

/obj/machinery/ticket_machine/proc/increment()
	if(current_number > ticket_number)
		return
	if(current_number < ticket_number)
		current_number ++ //Increment the one we're serving.
		playsound(src, 'sound/misc/announce_dig.ogg', 50, FALSE)
		say("Now serving ticket #[current_number]!")
		update_appearance()

/obj/machinery/button/ticket_machine
	name = "increment ticket counter"
	desc = "Use this button after you've served someone to tell the next person to come forward."
	device_type = /obj/item/assembly/control/ticket_machine
	req_access = list()
	id = "ticket_machine_default"

/obj/machinery/button/ticket_machine/Initialize(mapload)
	. = ..()
	if(device)
		var/obj/item/assembly/control/ticket_machine/ours = device
		ours.id = id

/obj/machinery/button/ticket_machine/multitool_act(mob/living/user, obj/item/I)
	. = ..()
	if(I.tool_behaviour == TOOL_MULTITOOL)
		var/obj/item/multitool/M = I
		if(M.buffer && !istype(M.buffer, /obj/machinery/ticket_machine))
			return
		var/obj/item/assembly/control/ticket_machine/controller = device
		controller.linked = WEAKREF(M.buffer)
		id = null
		controller.id = null
		to_chat(user, span_warning("You've linked [src] to [M.buffer]."))

/obj/item/assembly/control/ticket_machine
	name = "ticket machine controller"
	desc = "A remote controller for the HoP's ticket machine."
	var/datum/weakref/linked //To whom are we linked?

/obj/item/assembly/control/ticket_machine/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/assembly/control/ticket_machine/LateInitialize()
	find_machine()

/obj/item/assembly/control/ticket_machine/proc/find_machine() //Locate the one to which we're linked
	for(var/obj/machinery/ticket_machine/ticketsplease in GLOB.machines)
		if(ticketsplease.id == id)
			linked = WEAKREF(ticketsplease)
	if(linked)
		return TRUE
	else
		return FALSE

/obj/item/assembly/control/ticket_machine/activate()
	if(cooldown)
		return
	if(!linked)
		return
	var/obj/machinery/ticket_machine/machine = linked.resolve()
	if(!machine)
		return
	cooldown = TRUE
	machine.increment()
	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 10)

/obj/machinery/ticket_machine/update_icon()
	. = ..()
	handle_maptext()

/obj/machinery/ticket_machine/update_icon_state()
	switch(ticket_number) //Gives you an idea of how many tickets are left
		if(0 to 49)
			icon_state = "[base_icon_state]_100"
		if(50 to 99)
			icon_state = "[base_icon_state]_50"
		if(100)
			icon_state = "[base_icon_state]_0"
	return ..()

/obj/machinery/ticket_machine/proc/handle_maptext()
	switch(current_number) //This is here to handle maptext offsets so that the numbers align.
		if(0 to 9)
			maptext_x = 13
		if(10 to 99)
			maptext_x = 10
		if(100)
			maptext_x = 8
	maptext = MAPTEXT(current_number) //Finally, apply the maptext

/obj/machinery/ticket_machine/attackby(obj/item/I, mob/user, params)
	..()
	if(istype(I, /obj/item/hand_labeler_refill))
		if(!(ticket_number >= max_number))
			if(tgui_alert(user, "[src] still has [max_number-ticket_number] ticket[max_number-ticket_number==1 ? null : "s"] left, are you sure you want to refill it?", "Tactical Refill", list("Refill", "Cancel")) != "Refill")
				return //If the user still wants to refill it...
		to_chat(user, span_notice("You start to refill [src]'s ticket holder."))
		if(do_after(user, src, 30))
			to_chat(user, span_notice("You insert [I] into [src] as it whirs nondescriptly."))
			qdel(I)
			ticket_number = 0
			current_number = 0
			update_appearance()
			return

/obj/machinery/ticket_machine/proc/reset_cooldown()
	ready = TRUE

/obj/machinery/ticket_machine/attack_hand(mob/living/carbon/user, list/modifiers)
	. = ..()
	if(!ready)
		to_chat(user,span_warning("You press the button, but nothing happens..."))
		return
	if(ticket_number >= max_number)
		to_chat(user,span_warning("Ticket supply depleted, please refill this unit with a hand labeller refill cartridge!"))
		return
	playsound(src, 'sound/machines/terminal_insert_disc.ogg', 100, FALSE)
	ticket_number++
	to_chat(user, span_notice("You take a ticket from [src], looks like you're ticket number #[ticket_number]..."))
	var/obj/item/ticket_machine_ticket/theirticket = new /obj/item/ticket_machine_ticket(get_turf(src))
	theirticket.name = "Ticket #[ticket_number]"
	theirticket.maptext = MAPTEXT(ticket_number)
	theirticket.saved_maptext = MAPTEXT(ticket_number)
	user.put_in_hands(theirticket)
	update_appearance()
	if(obj_flags & EMAGGED) //Emag the machine to destroy the HOP's life.
		ready = FALSE
		addtimer(CALLBACK(src, PROC_REF(reset_cooldown)), cooldown)//Small cooldown to prevent piles of flaming tickets
		theirticket.fire_act()
		user.dropItemToGround(theirticket)
		user.adjust_fire_stacks(1)
		user.ignite_mob()
		return

/obj/item/ticket_machine_ticket
	name = "Ticket"
	desc = "A ticket which shows your place in the Head of Personnel's line. Made from Nanotrasen patented NanoPaper®. Though solid, its form seems to shimmer slightly. Feels (and burns) just like the real thing."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "ticket"
	maptext_x = 7
	maptext_y = 10
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	max_integrity = 50
	var/saved_maptext = null

/obj/item/ticket_machine_ticket/attack_hand(mob/user, list/modifiers)
	. = ..()
	maptext = saved_maptext //For some reason, storage code removes all maptext off objs, this stops its number from being wiped off when taken out of storage.

/obj/item/ticket_machine_ticket/attackby(obj/item/P, mob/living/carbon/human/user, params) //Stolen from papercode
	if(burn_paper_product_attackby_check(P, user))
		return
	return ..()
