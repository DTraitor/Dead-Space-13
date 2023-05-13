/datum/antagonist/unitoligst
	name = "\improper Santa"
	suicide_cry = "FOR CHRISTMAS!!"

/datum/antagonist/unitoligst/on_gain()
	. = ..()
	give_equipment()
	give_objective()

	ADD_TRAIT(owner, TRAIT_CANNOT_OPEN_PRESENTS, TRAIT_SANTA)
	ADD_TRAIT(owner, TRAIT_PRESENT_VISION, TRAIT_SANTA)

/datum/antagonist/unitoligst/greet()
	. = ..()
	to_chat(owner, span_boldannounce("Your objective is to bring joy to the people on this station. You have a magical bag, which generates presents as long as you have it! You can examine the presents to take a peek inside, to make sure that you give the right gift to the right person."))

/datum/antagonist/unitoligst/proc/give_equipment()
	var/mob/living/carbon/human/H = owner.current
	if(istype(H))
		H.equipOutfit(/datum/outfit/santa)
		H.dna.update_dna_identity()

	var/datum/action/cooldown/spell/teleport/area_teleport/wizard/santa/teleport = new(owner)
	teleport.Grant(H)

/datum/antagonist/unitoligst/proc/give_objective()
	var/datum/objective/santa_objective = new()
	santa_objective.explanation_text = "Bring joy and presents to the station!"
	santa_objective.completed = TRUE //lets cut our santas some slack.
	santa_objective.owner = owner
	objectives |= santa_objective
