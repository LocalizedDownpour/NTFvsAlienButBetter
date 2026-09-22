/obj/item/clothing/head/domina_cap
	name = "dominant cap"
	desc = "For special types of inspections."
	icon_state = "dominacap"
	icon = 'modular_lewd_items/icons/obj/lewd_clothing/lewd_hats.dmi'
	icon_override = 'modular_lewd_items/icons/mob/lewd_clothing/lewd_hats.dmi'
	equip_slot_flags = ITEM_SLOT_HEAD
	armor_protection_flags = HEAD

//message when equipping that thing
/obj/item/clothing/head/domina_cap/equipped(mob/living/carbon/user, slot)
	. = ..()
	if(src == user.head)
		to_chat(user, span_purple("You feel much more determined."))

//message when unequipping that thing
/obj/item/clothing/head/domina_cap/dropped(mob/living/carbon/user)
	. = ..()
	if(src == user.head)
		to_chat(user, span_purple("BDSM session ended, huh?"))
