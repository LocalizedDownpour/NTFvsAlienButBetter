/obj/item/clothing/under/stripper_outfit
	name = "stripper outfit"
	desc = "An item of clothing that leaves little to the imagination."
	icon = 'modular_lewd_items/icons/obj/lewd_clothing/lewd_uniform.dmi'
	icon_override = 'modular_lewd_items/icons/mob/lewd_clothing/lewd_uniform/lewd_uniform.dmi'
	icon_state = "stripper_cyan"
	worn_icon_state = "stripper_cyan"
	inhand_icon_state = "b_suit"
	equip_slot_flags = ITEM_SLOT_ICLOTHING
	armor_protection_flags = CHEST|GROIN
	shows_butt = TRUE
	shows_top_genital = TRUE
	shows_bottom_genital = TRUE
	var/static/list/stripper_colors

/obj/item/clothing/under/stripper_outfit/Initialize(mapload)
	. = ..()
	if(!length(stripper_colors))
		stripper_colors = list(
			"stripper_cyan" = image(icon = icon, icon_state = "stripper_cyan"),
			"stripper_pink" = image(icon = icon, icon_state = "stripper_purple"),
			"stripper_white" = image(icon = icon, icon_state = "stripper_white"),
			"stripper_yellow" = image(icon = icon, icon_state = "stripper_yellow"),
			"stripper_green" = image(icon = icon, icon_state = "stripper_green"),
			"stripper_red" = image(icon = icon, icon_state = "stripper_red"),
			"stripper_latex" = image(icon = icon, icon_state = "stripper_latex"),
			"stripper_orange" = image(icon = icon, icon_state = "stripper_orange"),
			"stripper_purple" = image(icon = icon, icon_state = "stripper_purple"),
			"stripper_black" = image(icon = icon, icon_state = "stripper_black"),
			"stripper_tealblack" = image(icon = icon, icon_state = "stripper_tealblack"),
		)

/obj/item/clothing/under/stripper_outfit/click_alt(mob/user)
	var/choice = show_radial_menu(user, src, stripper_colors, custom_check = CALLBACK(src, PROC_REF(check_menu), user), radius = 36, require_near = TRUE)
	if(!choice)
		return CLICK_ACTION_BLOCKING
	icon_state = choice
	worn_icon_state = choice
	update_icon()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		H.update_inv_w_uniform()
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/under/stripper_outfit/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE
