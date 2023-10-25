
#define CUMULATIVE_BURN_DAMAGE	0.5
#define FAKEDEATH_HEAL_TIME	4 SECONDS
#define ARM_SWING_RANGE_HUNTER	3

/mob/living/carbon/human/necromorph/hunter
	class = /datum/necro_class/hunter
	necro_species = /datum/species/necromorph/hunter

/mob/living/carbon/human/necromorph/hunter/play_necro_sound(audio_type, volume, vary, extra_range)
	playsound(src, pick(GLOB.hunter_sounds[audio_type]), volume, vary, extra_range)

/mob/living/carbon/human/necromorph/hunter/handle_death_check()
	var/total_burn = 0
	var/total_brute = 0
	for(var/obj/item/bodypart/BP as anything in bodyparts) //hardcoded to streamline things a bit
		total_brute += BP.brute_dam
		total_burn += BP.burn_dam

	var/damage = getOxyLoss() + getToxLoss() - getCloneLoss() - total_burn - total_brute
	if(damage >= maxHealth)
		if(total_burn >= (maxHealth * 0.5))
			return TRUE

		if(getLastingDamage() >= maxHealth)
			return TRUE

		if(!HAS_TRAIT(src, TRAIT_FAKEDEATH))
			ADD_TRAIT(src, TRAIT_FAKEDEATH, src)
			AddComponent(/datum/component/regenerate, duration = 8.6 SECONDS, heal_amount = 100, max_limbs = 5, lasting_damage_heal = 35, burn_heal_mult = 0.01)
			addtimer(TRAIT_CALLBACK_REMOVE(src, TRAIT_FAKEDEATH, src), 8.6 SECONDS)
			play_necro_sound(SOUND_DEATH, VOLUME_HIGH)
		return FALSE
	return FALSE

/datum/necro_class/hunter
	display_name = "Hunter"
	desc = "A rapidly regenerating vanguard, designed to lead the charge, suffer a glorious death, then get back up and do it again. \
	Avoid fire though."
	ui_icon = 'deadspace/icons/necromorphs/hunter.dmi'
	necromorph_type_path = /mob/living/carbon/human/necromorph/hunter
	nest_allowed = FALSE
	tier = 3
	biomass_cost = 400
	biomass_spent_required = 950
	max_health = 275
	melee_damage_lower = 18
	melee_damage_upper = 22
	actions = list(
		/datum/action/cooldown/necro/swing/hunter,
		// /datum/action/cooldown/necro/taunt/hunter,
		/datum/action/cooldown/necro/regenerate/hunter,
		/datum/action/cooldown/necro/shout,
	)
	minimap_icon = "hunter"
	implemented = TRUE

/datum/species/necromorph/hunter
	name = "Hunter"
	id = SPECIES_NECROMORPH_HUNTER
	speedmod = 1.6
	burnmod = 1.3
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/necromorph/hunter,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/necromorph/hunter,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/necromorph/hunter,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/necromorph/hunter,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/necromorph/hunter,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/necromorph/hunter,
	)

	special_step_sounds = list(
		'deadspace/sound/effects/footstep/ubermorph_footstep_1.ogg',
		'deadspace/sound/effects/footstep/ubermorph_footstep_2.ogg',
		'deadspace/sound/effects/footstep/ubermorph_footstep_3.ogg',
		'deadspace/sound/effects/footstep/ubermorph_footstep_4.ogg'
	)

/datum/species/necromorph/hunter/get_scream_sound(mob/living/carbon/human/necromorph/hunter)
	return pick(
		'deadspace/sound/effects/creatures/necromorph/ubermorph/ubermorph_pain_5.ogg',
		'deadspace/sound/effects/creatures/necromorph/ubermorph/ubermorph_pain_6.ogg',
		'deadspace/sound/effects/creatures/necromorph/ubermorph/ubermorph_shout_long_3.ogg',
	)

/datum/species/necromorph/hunter/apply_damage(damage, damagetype, def_zone, blocked, mob/living/carbon/human/necromorph/H, forced, spread_damage, sharpness, attack_direction)
	if(H.health - damage <= 0)
		return H.handle_death_check()
	. = ..()

/datum/action/cooldown/necro/regenerate/hunter
	cooldown_time = 30 SECONDS
	duration = 8.6 SECONDS
	lasting_damage_heal = 20
	heal_amount = 30
	burn_heal_mult = 0.33

/datum/action/cooldown/necro/regenerate/hunter/PreActivate(atom/target)
	var/mob/living/carbon/human/necromorph/necromorph = owner
	necromorph.play_necro_sound(SOUND_PAIN, VOLUME_HIGH, 1, 3)
	return ..()

/datum/action/cooldown/necro/swing/hunter
	name = "Hookblade"
	desc = "A shortrange charge with a swing at the end, pulling in all enemies it hits."
	visual_type = /obj/effect/temp_visual/swing/hunter

/datum/action/cooldown/necro/swing/hunter/windup()
	var/mob/living/carbon/human/necromorph/necromorph = owner
	necromorph.play_necro_sound(SOUND_ATTACK, VOLUME_MID, 1, 2)
	return ..()

/datum/action/cooldown/necro/swing/hunter/hit_mob(mob/living/L)
	if(..())
		var/throw_dir = pick(
			turn(owner.dir, 90),
			turn(owner.dir, -90),
			)
		var/throw_dist = 2

		var/throw_x = L.x
		if(throw_dir & WEST)
			throw_x += throw_dist
		else if(throw_dir & EAST)
			throw_x -= throw_dist

		var/throw_y = L.y
		if(throw_dir & NORTH)
			throw_y += throw_dist
		else if(throw_dir & SOUTH)
			throw_y -= throw_dist

		throw_x = clamp(throw_x, 1, world.maxx)
		throw_y = clamp(throw_y, 1, world.maxy)

		L.safe_throw_at(locate(throw_x, throw_y, L.z), throw_dist, 1, owner, TRUE)

/obj/effect/temp_visual/swing/hunter
	base_icon_state = "hunter"
	icon_state = "hunter_left"
	variable_icon = TRUE

/datum/action/cooldown/necro/taunt/hunter
	desc = "Provides a defensive buff to the hunter, and a larger one to his allies."
	type_buff = /datum/component/statmod/taunt_buff
	var/obj/effect/temp_visual/expanding_circle/EC

/datum/action/cooldown/necro/taunt/hunter/Activate()
	owner:play_necro_sound(SOUND_SHOUT_LONG, VOLUME_MAX, 1, 3)
	. = ..()
	EC = new /obj/effect/temp_visual/expanding_circle(owner.loc, 1.5 SECONDS, 1.5,"#ff0000")
	EC.pixel_y += 40	//Offset it so it appears to be at our mob's head
	addtimer(CALLBACK(src, PROC_REF(effects)), 4)
	addtimer(CALLBACK(src, PROC_REF(effects)), 8)

/datum/action/cooldown/necro/taunt/hunter/proc/effects()
	EC = new /obj/effect/temp_visual/expanding_circle(owner.loc, 1.5 SECONDS, 1.5,"#ff0000")
	EC.pixel_y += 40	//Offset it so it appears to be at our mob's head

/datum/component/statmod/taunt_buff
	//These stats apply to self
	//statmods = list(STATMOD_MOVESPEED_ADDITIVE = 0.15,
	//				STATMOD_INCOMING_DAMAGE_MULTIPLICATIVE = 0.85
	//)
