/// depending on the species, it will run the corresponding apply_damage code there
/mob/living/carbon/human/apply_damage(damage = 0,damagetype = BRUTE, def_zone = null, blocked = FALSE, forced = FALSE, spread_damage = FALSE, sharpness = NONE, attack_direction = null, cap_loss_at = 0)
	return dna.species.apply_damage(damage, damagetype, def_zone, blocked, src, forced, spread_damage, sharpness, attack_direction, cap_loss_at)

/mob/living/carbon/human/get_sanity()
	return brain.sanity

/mob/living/carbon/human/get_max_sanity()
	return brain.max_sanity

/mob/living/carbon/human/damage_sanity(value)
	brain.sanity = clamp(brain.sanity - value, 0, brain.max_sanity)

/mob/living/carbon/human/heal_sanity(value)
	brain.sanity = clamp(brain.sanity + value, 0, brain.max_sanity)
