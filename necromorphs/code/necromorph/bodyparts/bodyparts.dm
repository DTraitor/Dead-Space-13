/obj/item/bodypart/chest/necromorph
	name = BODY_ZONE_CHEST
	bodytype = BODYTYPE_NECROMORPH|BODYTYPE_ORGANIC
	limb_id = SPECIES_NECROMORPH
	should_draw_greyscale = FALSE
	icon_static = 'necromorphs/icons/necromorphs/base_necromorph.dmi'
	icon_state = "chest"
	max_damage = 200
	body_zone = BODY_ZONE_CHEST
	body_part = CHEST
	is_dimorphic = FALSE
	px_x = 0
	px_y = 0
	stam_damage_coeff = 1
	max_stamina_damage = 120
	grind_results = null
	wound_resistance = 10
	acceptable_bodytype = BODYTYPE_NECROMORPH
	can_be_disabled = FALSE

/obj/item/bodypart/head/necromorph
	name = BODY_ZONE_HEAD
	bodytype = BODYTYPE_NECROMORPH|BODYTYPE_ORGANIC
	limb_id = SPECIES_NECROMORPH
	should_draw_greyscale = FALSE
	icon_static = 'necromorphs/icons/necromorphs/base_necromorph.dmi'
	icon_state = "head"
	body_zone = BODY_ZONE_HEAD
	body_part = HEAD
	max_damage = 200
	px_x = 0
	px_y = -8
	stam_damage_coeff = 1
	max_stamina_damage = 100
	wound_resistance = 5
	is_dimorphic = FALSE
	can_be_disabled = FALSE
	show_organs_on_examine = TRUE

/obj/item/bodypart/head/necromorph/attempt_dismemberment(brute as num, burn as num, sharpness)
	if(brute_dam >= max_damage)
		return dismember(DROPLIMB_BLUNT, FALSE, FALSE)

	else if(burn_dam >= max_damage)
		return dismember(DROPLIMB_BURN, FALSE, FALSE)

/obj/item/bodypart/arm/left/necromorph
	name = "left arm"
	bodytype = BODYTYPE_NECROMORPH|BODYTYPE_ORGANIC
	limb_id = SPECIES_NECROMORPH
	should_draw_greyscale = FALSE
	icon_static = 'necromorphs/icons/necromorphs/base_necromorph.dmi'
	icon_state = "l_arm"
	attack_verb_continuous = list("slaps", "punches")
	attack_verb_simple = list("slap", "punch")
	max_damage = 50
	max_stamina_damage = 50
	body_damage_coeff = 0.75
	px_x = -6
	px_y = 0
	can_be_disabled = FALSE
	wound_resistance = 0

/obj/item/bodypart/arm/left/necromorph/attempt_dismemberment(brute as num, burn as num, sharpness)
	if(brute_dam >= max_damage)
		return dismember(DROPLIMB_BLUNT, FALSE, FALSE)

	else if(burn_dam >= max_damage)
		return dismember(DROPLIMB_BURN, FALSE, FALSE)

/obj/item/bodypart/arm/right/necromorph
	name = "right arm"
	bodytype = BODYTYPE_NECROMORPH|BODYTYPE_ORGANIC
	limb_id = SPECIES_NECROMORPH
	should_draw_greyscale = FALSE
	icon_static = 'necromorphs/icons/necromorphs/base_necromorph.dmi'
	icon_state = "r_arm"
	attack_verb_continuous = list("slaps", "punches")
	attack_verb_simple = list("slap", "punch")
	max_damage = 50
	body_damage_coeff = 0.75
	px_x = 6
	px_y = 0
	max_stamina_damage = 50
	can_be_disabled = FALSE
	wound_resistance = 0

/obj/item/bodypart/arm/right/necromorph/attempt_dismemberment(brute as num, burn as num, sharpness)
	if(brute_dam >= max_damage)
		return dismember(DROPLIMB_BLUNT, FALSE, FALSE)

	else if(burn_dam >= max_damage)
		return dismember(DROPLIMB_BURN, FALSE, FALSE)

/obj/item/bodypart/leg/left/necromorph
	name = "left leg"
	bodytype = BODYTYPE_NECROMORPH|BODYTYPE_ORGANIC
	limb_id = SPECIES_NECROMORPH
	should_draw_greyscale = FALSE
	icon_static = 'necromorphs/icons/necromorphs/base_necromorph.dmi'
	icon_state = "l_leg"
	attack_verb_continuous = list("kicks", "stomps")
	attack_verb_simple = list("kick", "stomp")
	max_damage = 50
	body_damage_coeff = 0.75
	px_x = -2
	px_y = 12
	max_stamina_damage = 50
	can_be_disabled = FALSE
	wound_resistance = 0

/obj/item/bodypart/leg/left/necromorph/attempt_dismemberment(brute as num, burn as num, sharpness)
	if(brute_dam >= max_damage)
		return dismember(DROPLIMB_BLUNT, FALSE, FALSE)

	else if(burn_dam >= max_damage)
		return dismember(DROPLIMB_BURN, FALSE, FALSE)

/obj/item/bodypart/leg/right/necromorph
	name = "right leg"
	bodytype = BODYTYPE_NECROMORPH|BODYTYPE_ORGANIC
	limb_id = SPECIES_NECROMORPH
	should_draw_greyscale = FALSE
	icon_static = 'necromorphs/icons/necromorphs/base_necromorph.dmi'
	icon_state = "r_leg"
	attack_verb_continuous = list("kicks", "stomps")
	attack_verb_simple = list("kick", "stomp")
	max_damage = 50
	body_zone = BODY_ZONE_R_LEG
	body_part = LEG_RIGHT
	body_damage_coeff = 0.75
	px_x = 2
	px_y = 12
	max_stamina_damage = 50
	can_be_disabled = FALSE
	wound_resistance = 0

/obj/item/bodypart/leg/right/necromorph/attempt_dismemberment(brute as num, burn as num, sharpness)
	if(brute_dam >= max_damage)
		return dismember(DROPLIMB_BLUNT, FALSE, FALSE)

	else if(burn_dam >= max_damage)
		return dismember(DROPLIMB_BURN, FALSE, FALSE)

/obj/item/organ/external/tail/necromorph
	name = "tail"
	visual = TRUE
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_EXTERNAL_TAIL

/obj/item/organ/external/tail/necromorph/get_global_feature_list()
	return GLOB.necromorph_tails

/datum/sprite_accessory/necromorph
	name = "Necromorph Tail"
	em_block = TRUE
	locked = TRUE
