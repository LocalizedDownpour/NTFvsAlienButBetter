/obj/item/restraints/handcuffs/lewd
	name = "kinky handcuffs"
	desc = "Fake handcuffs meant for erotic roleplay. Easy to break out of."
	icon_state = "pinkcuffs"
	worn_icon_state = "pinkcuffs"
	icon = 'modular_lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	worn_icon = 'modular_lewd_items/icons/mob/lewd_items/lewd_items.dmi'
	lefthand_file = 'modular_lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	breakouttime = 1 SECONDS
	cuff_delay = 10

/obj/item/restraints/handcuffs/lewd/place_handcuffs(mob/living/carbon/target, mob/user)
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		if(!C.check_erp_prefs(LEWD_PREF_SEX_TOY, user, src))
			to_chat(user, span_danger("[target] doesn't want you to do that."))
			return FALSE
	return ..()
