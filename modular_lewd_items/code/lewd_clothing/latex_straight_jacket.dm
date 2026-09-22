/obj/item/clothing/suit/straight_jacket/latex_straight_jacket
	name = "latex straight jacket"
	desc = "A toy that is unable to actually restrain anyone. Still fun to wear!"
	inhand_icon_state = "latex_straight_jacket"
	icon = 'modular_lewd_items/icons/obj/lewd_clothing/lewd_suits.dmi'
	icon_override = 'modular_lewd_items/icons/mob/lewd_clothing/lewd_suit/lewd_suits.dmi'
	icon_state = "latex_straight_jacket"
	worn_icon_state = "latex_straight_jacket"
	lefthand_file = 'modular_lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	equip_slot_flags = ITEM_SLOT_OCLOTHING
	armor_protection_flags = CHEST | GROIN | LEGS | ARMS | HANDS
	inv_hide_flags = HIDEGLOVES | HIDESHOES | HIDEJUMPSUIT
	equip_delay_self = NONE
	strip_delay = 12 SECONDS
	breakouttime = 1 SECONDS

/obj/item/clothing/suit/straight_jacket/latex_straight_jacket/attackby(obj/item/attacking_item, mob/user, params) //That part allows reinforcing this item with normal straightjacket
	if(!istype(attacking_item, /obj/item/clothing/suit/straight_jacket))
		return ..()
	var/obj/item/clothing/suit/straight_jacket/latex_straight_jacket/reinforced/reinforced_jacket = new(get_turf(user))
	user.drop_inv_item_to_loc(attacking_item, user)
	user.put_in_hands(reinforced_jacket)
	to_chat(user, span_notice("You reinforce the belts on [src] with [attacking_item]."))
	qdel(attacking_item)
	qdel(src)

/obj/item/clothing/suit/straight_jacket/latex_straight_jacket/reinforced
	name = "latex straight jacket"
	desc = "A suit that completely restrains the wearer - in quite an arousing way."
	icon_state = "latex_straight_jacket"
	worn_icon_state = "latex_straight_jacket"
	inhand_icon_state = "latex_straight_jacket"
	icon = 'modular_lewd_items/icons/obj/lewd_clothing/lewd_suits.dmi'
	icon_override = 'modular_lewd_items/icons/mob/lewd_clothing/lewd_suit/lewd_suits.dmi'
	lefthand_file = 'modular_lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	equip_slot_flags = ITEM_SLOT_OCLOTHING
	armor_protection_flags = CHEST | GROIN | LEGS | ARMS | HANDS
	inv_hide_flags = HIDEGLOVES | HIDESHOES | HIDEJUMPSUIT
	equip_delay_self = NONE
	strip_delay = 12 SECONDS
	breakouttime = 300 SECONDS
