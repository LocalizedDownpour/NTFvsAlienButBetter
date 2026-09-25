/obj/item/clothing/gloves/ball_mittens
	name = "ball mittens"
	desc = "A pair of inflatable latex mittens. Adorable and comfortable, but completely useless for anything requiring fingers. Getting these off yourself is a serious ordeal — you'll probably want help."
	icon_state = "ballmittens"
	inhand_icon_state = ""
	icon = 'modular_lewd_items/icons/obj/lewd_clothing/lewd_gloves.dmi'
	icon_override = 'modular_lewd_items/icons/mob/lewd_clothing/lewd_gloves.dmi'
	worn_icon_state = "ballmittens"
	equip_slot_flags = ITEM_SLOT_GLOVES
	strip_delay = 8 SECONDS

/obj/item/clothing/gloves/ball_mittens/equipped(mob/user, slot)
	. = ..()
	if(slot != ITEM_SLOT_GLOVES)
		return
	to_chat(user, span_purple("Your hands sink into [src]. Soft, round, and not particularly good at anything. As soon as you put them on, you hear them self inflate."))
	ADD_TRAIT(user, TRAIT_HANDS_BLOCKED, "ball_mittens")

/obj/item/clothing/gloves/ball_mittens/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_HANDS_BLOCKED, "ball_mittens")
