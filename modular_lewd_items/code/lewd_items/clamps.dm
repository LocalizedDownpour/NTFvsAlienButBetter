/obj/item/clothing/sextoy/nipple_clamps
	name = "nipple clamps"
	desc = "For causing nipple pain."
	icon_state = "clamps"
	icon = 'modular_lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	w_class = WEIGHT_CLASS_TINY
	lewd_slot_flags = LEWD_SLOT_NIPPLES
	/// What kind are the wearer's breasts?
	var/breast_type = "pair"
	/// What size are the wearer's breasts?
	var/breast_size = 0
	/// Mutable overlay containing the icon of the clamps
	var/mutable_appearance/clamps_overlay

/obj/item/clothing/sextoy/nipple_clamps/worn_overlays(isinhands = FALSE)
	. = ..()
	if(isxeno(loc))
		return
	if(!isinhands)
		. += clamps_overlay

/obj/item/clothing/sextoy/nipple_clamps/Initialize(mapload)
	. = ..()
	update_icon_state()
	clamps_overlay = mutable_appearance('modular_lewd_items/icons/mob/lewd_items/lewd_items.dmi', "[initial(icon_state)]_[breast_type]_[breast_size]", -BRA_LAYER)
	update_icon()
	update_appearance()
	update_overlays()

/obj/item/clothing/sextoy/nipple_clamps/update_icon_state()
	. = ..()
	worn_icon_state = "[initial(icon_state)]_[breast_type]_[breast_size]"

/obj/item/clothing/sextoy/nipple_clamps/lewd_equipped(mob/living/carbon/user, slot, initial)
	. = ..()
	if(!iscarbon(user))
		return
	breast_type = "pair"
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.boobs_size)
			breast_size = clamp(H.boobs_size, 0, 16)
		else
			breast_size = 0
	else
		breast_size = 0

	update_icon_state()
	clamps_overlay = mutable_appearance('modular_lewd_items/icons/mob/lewd_items/lewd_items.dmi', "[initial(icon_state)]_[breast_type]_[breast_size]", -BRA_LAYER)
	update_icon()
	update_appearance()
	update_overlays()

	if(src == user.lewd_nipples)
		START_PROCESSING(SSobj, src)

/obj/item/clothing/sextoy/nipple_clamps/dropped(mob/user, silent)
	. = ..()
	STOP_PROCESSING(SSobj, src)
	breast_type = "pair"
	breast_size = 0

/obj/item/clothing/sextoy/nipple_clamps/process(seconds_per_tick)
	. = ..()
	var/mob/living/carbon/target = loc
	if(!iscarbon(target))
		return
	target.adjust_arousal(1 * seconds_per_tick)
	if(target.pain < 27.5)
		target.adjust_pain(1 * seconds_per_tick)
	if(target.arousal < 15)
		target.adjust_arousal(1 * seconds_per_tick)

/obj/item/clothing/sextoy/nipple_clamps/attack(mob/living/target, mob/living/user)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(!iscarbon(target))
		return ..()
	var/mob/living/carbon/carbon_target = target
	if(!carbon_target.check_erp_prefs(LEWD_PREF_SEX_TOY, user, src))
		to_chat(user, span_danger("[target] doesn't want you to do that."))
		return

	if(!carbon_target.sexcon_has_breasts())
		to_chat(user, span_danger("[target] doesn't have suitable breasts or nipples for that!"))
		return

	if(!carbon_target.is_topless())
		to_chat(user, span_danger("[target]'s chest is covered!"))
		return

	if(carbon_target.lewd_nipples)
		to_chat(user, span_danger("[target] already has clamps on their nipples!"))
		return

	if(!carbon_target.equip_lewd_item(src, "lewd_nipples", user))
		return

	if(user == carbon_target)
		carbon_target.visible_message(span_purple("[user] attaches [src] to [carbon_target.p_their()] nipples."), span_purple("You attach [src] to your nipples."))
	else
		carbon_target.visible_message(span_purple("[user] attaches [src] to [carbon_target]'s nipples."), span_purple("[user] attaches [src] to your nipples."))
	conditional_pref_sound(loc, 'sound/items/wirecutter.ogg', 30, TRUE)
