#define MAX_EVENTS_AFFECTING_SANITY 5

/datum/sanity
	/// Owner of the sanity datum
	var/mob/living/carbon/human/parent

	/// The current sanity of the owner
	var/sanity = 100
	/// The maximum sanity of the owner
	var/max_sanity = 100
	/// The current sanity of the owner visible to players
	var/visible_sanity = 100
	/// List of sanity events affecting the owner
	var/list/sanity_events

/datum/sanity/proc/get_visible_sanity()
	return visible_sanity

/datum/sanity/proc/get_real_sanity()
	return sanity

/datum/sanity/proc/get_max_sanity()
	return max_sanity

/datum/sanity/proc/get_sanity_percentage()
	return sanity / max_sanity

/datum/sanity/proc/add_sanity_event(event_type)
	var/datum/sanity_event/event = new event_type()

	event.added_at = world.time
	event.sanity_change *= 1 - (length(sanity_events[event.category]) / MAX_EVENTS_AFFECTING_SANITY)
	LAZYADD(sanity_events[event.category], event)
	sanity += event.sanity_change
	if(!event.hidden)
		visible_sanity += event.sanity_change
