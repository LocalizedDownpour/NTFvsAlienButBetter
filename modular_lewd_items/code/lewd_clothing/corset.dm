#define TIGHT_SLOWDOWN 2

/obj/item/clothing/suit/corset
	name = "corset"
	desc = "A tight latex corset. How can anybody fit in THAT?"
	icon_state = "corset"
	inhand_icon_state = null
	icon = 'modular_lewd_items/icons/obj/lewd_clothing/lewd_suits.dmi'
	icon_override = 'modular_lewd_items/icons/mob/lewd_clothing/lewd_suit/lewd_suits.dmi'
	equip_slot_flags = ITEM_SLOT_OCLOTHING
	armor_protection_flags = CHEST
	slowdown = 1

	/// Has it been laced tightly?
	var/laced_tight = FALSE

/obj/item/clothing/suit/corset/click_alt(mob/user)
	laced_tight = !laced_tight
	to_chat(user, span_notice("You [laced_tight ? "tighten" : "loosen"] the corset, making it far [laced_tight ? "harder" : "easier"] to breathe."))
	conditional_pref_sound(user, laced_tight ? 'sound/effects/rustle1.ogg' : 'sound/effects/rustle2.ogg', 40, TRUE)
	. = CLICK_ACTION_SUCCESS
	if(laced_tight)
		slowdown = TIGHT_SLOWDOWN
		return
	slowdown = initial(slowdown)

/obj/item/clothing/suit/corset/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(laced_tight && src == user.wear_suit)
		to_chat(user, span_purple("The corset squeezes tightly against your ribs! Breathing suddenly feels much more difficult."))

/obj/item/clothing/suit/corset/dropped(mob/living/carbon/human/user)
	. = ..()
	if(laced_tight && src == user.wear_suit)
		to_chat(user, span_purple("Phew. Now you can breathe normally."))

#undef TIGHT_SLOWDOWN
