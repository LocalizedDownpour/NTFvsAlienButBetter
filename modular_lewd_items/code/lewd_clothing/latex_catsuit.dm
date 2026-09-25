/obj/item/clothing/under/latex_catsuit
	name = "latex catsuit"
	desc = "A shiny uniform that fits snugly to the skin."
	icon_state = "latex_catsuit_female"
	worn_icon_state = "latex_catsuit_female"
	icon = 'modular_lewd_items/icons/obj/lewd_clothing/lewd_uniform.dmi'
	icon_override = 'modular_lewd_items/icons/mob/lewd_clothing/lewd_uniform/lewd_uniform.dmi'
	inhand_icon_state = "latex_catsuit"
	lefthand_file = 'modular_lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	equip_slot_flags = ITEM_SLOT_ICLOTHING
	armor_protection_flags = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/under/latex_catsuit/equipped(mob/living/affected_mob, slot)
	. = ..()
	var/mob/living/carbon/human/affected_human = affected_mob
	if(!istype(affected_human))
		return
	if(src == affected_human.w_uniform)
		if(affected_mob.gender == FEMALE)
			icon_state = "latex_catsuit_female"
			worn_icon_state = "latex_catsuit_female"
		else
			icon_state = "latex_catsuit_male"
			worn_icon_state = "latex_catsuit_male"
