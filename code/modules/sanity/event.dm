/datum/sanity_event
	/// Description of the sanity event
	var/description
	/// The amount of sanity to change by
	var/sanity_change = 0
	/// If the event is hidden from the player
	var/hidden = FALSE
	/// Used to determine if event effect is reduced when multiple events are active
	var/category = "Misc"
	/// World time when the event was added
	var/added_at = 0
	/// The amount of time to event lasts
	var/timeout = 0

	var/mob/living/carbon/human/owner


