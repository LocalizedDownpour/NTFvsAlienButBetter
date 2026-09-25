/obj/item/clothing/suit/straight_jacket/shackles
	name = "shackles"
	desc = "Fancy shackles with a fake lock."
	inhand_icon_state = null
	icon = 'modular_lewd_items/icons/obj/lewd_clothing/lewd_suits.dmi'
	icon_override = 'modular_lewd_items/icons/mob/lewd_clothing/lewd_suit/lewd_suits.dmi'
	icon_state = "shackles_metal"
	base_icon_state = "shackles"
	equip_slot_flags = ITEM_SLOT_OCLOTHING
	armor_protection_flags = NONE
	inv_hide_flags = NONE
	equip_delay_self = NONE
	strip_delay = 12 SECONDS
	breakouttime = 10 SECONDS
	slowdown = 1
	/// The current variant of the shackles' color.
	var/current_color = "metal" //yes, metal color. Don't ask.
	var/color_changed = FALSE
	var/static/list/shackles_designs

/*
*	MODEL CHANGES
*/

//create radial menu
/obj/item/clothing/suit/straight_jacket/shackles/proc/populate_shackles_designs()
	shackles_designs = list(
		"pink" = image (icon = src.icon, icon_state = "shackles_pink"),
		"teal" = image (icon = src.icon, icon_state = "shackles_teal"),
		"metal" = image (icon = src.icon, icon_state = "shackles_metal"))

//to change model
/obj/item/clothing/suit/straight_jacket/shackles/click_alt(mob/user)
	if(color_changed)
		return CLICK_ACTION_BLOCKING

	var/choice = show_radial_menu(user, src, shackles_designs, custom_check = CALLBACK(src, PROC_REF(check_menu), user), radius = 36, require_near = TRUE)
	if(!choice)
		return CLICK_ACTION_BLOCKING
	current_color = choice
	update_icon()
	color_changed = TRUE
	return CLICK_ACTION_SUCCESS

//to check if we can change shackles' model
/obj/item/clothing/suit/straight_jacket/shackles/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/clothing/suit/straight_jacket/shackles/Initialize(mapload)
	. = ..()
	update_icon_state()
	update_icon()
	if(!length(shackles_designs))
		populate_shackles_designs()

/obj/item/clothing/suit/straight_jacket/shackles/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]_[current_color]"
	worn_icon_state = "[base_icon_state]_[current_color]"
	inhand_icon_state = "[base_icon_state]_[current_color]"

//message when equipping that thing
/obj/item/clothing/suit/straight_jacket/shackles/equipped(mob/user, slot)
	. = ..()
	var/mob/living/carbon/human/affected_mob = user
	if(src == affected_mob.wear_suit)
		to_chat(user, span_purple("The shackles are restraining your body, though the lock appears to be made of... Plastic?"))
	else
		return

//message when unequipping that thing
/obj/item/clothing/suit/straight_jacket/shackles/dropped(mob/user)
	. = ..()
	var/mob/living/carbon/human/affected_mob = user
	if(src == affected_mob.wear_suit)
		to_chat(user, span_purple("The shackles are no longer restraining your body. It wasn't too hard, huh?"))

//reinforcing normal version by using handcuffs on it.
/obj/item/clothing/suit/straight_jacket/shackles/attackby(obj/item/used_item, mob/user, params) //That part allows reinforcing this item with normal straightjacket
	if(istype(used_item, /obj/item/restraints/handcuffs))
		var/obj/item/clothing/suit/straight_jacket/shackles/reinforced/shackles = new(get_turf(user))
		user.dropItemToGround(used_item, TRUE)
		user.put_in_hands(shackles)
		to_chat(user, span_notice("You reinforced the locks on [src] with [used_item]."))
		qdel(used_item)
		qdel(src)
		return TRUE

	return ..()

//reinforced version.
/obj/item/clothing/suit/straight_jacket/shackles/reinforced
	name = "reinforced shackles"
	desc = "Fancy shackles, but with a suspiciously sturdy lock..."
	equip_delay_self = 10 SECONDS
	strip_delay = 12 SECONDS
	breakouttime = 180 SECONDS
	slowdown = 2

//message when equipping that thing
/obj/item/clothing/suit/straight_jacket/shackles/reinforced/equipped(mob/user, slot)
	. = ..()
	var/mob/living/carbon/human/affected_mob = user
	if(src == affected_mob.wear_suit)
		to_chat(user, span_purple("The shackles are restraining your body!"))
	else
		return

//message when unequipping that thing
/obj/item/clothing/suit/straight_jacket/shackles/reinforced/dropped(mob/user)
	. = ..()
	var/mob/living/carbon/human/affected_mob = user
	if(src == affected_mob.wear_suit)
		to_chat(user, span_purple("The shackles are no longer restraining your body. You are free!"))
