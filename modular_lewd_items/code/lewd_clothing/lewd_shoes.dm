/obj/item/clothing/shoes/latex_heels
	name = "latex heels"
	desc = "Lace up before use. It's pretty difficult to walk in these."
	icon_state = "latexheels"
	worn_icon_state = "latexheels"
	inhand_icon_state = null
	icon = 'modular_lewd_items/icons/obj/lewd_clothing/lewd_shoes.dmi'
	icon_override = 'modular_lewd_items/icons/mob/lewd_clothing/lewd_shoes.dmi'
	equip_slot_flags = ITEM_SLOT_FEET
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/clothing/shoes/latex_heels/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/squeak, list('modular_lewd_items/sounds/highheel1.ogg' = 1, 'modular_lewd_items/sounds/highheel2.ogg' = 1), 70)

/obj/item/clothing/shoes/latex_heels/domina_heels
	name = "dominant heels"
	desc = "A pair of aesthetically pleasing heels."
	icon_state = "dominaheels"
	worn_icon_state = "dominaheels"

/obj/item/clothing/shoes/latex_heels/ballet_heels
	name = "ballet heels"
	desc = "A pair of ballet dancing heels."
	icon_state = "balletheels"
	worn_icon_state = "balletheels"
