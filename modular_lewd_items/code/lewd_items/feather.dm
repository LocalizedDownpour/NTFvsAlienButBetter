/obj/item/tickle_feather
	name = "tickling feather"
	desc = "A rather ticklish feather that can be used in both mirth and malice."
	icon_state = "feather"
	inhand_icon_state = "feather"
	icon = 'modular_lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	lefthand_file = 'modular_lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	w_class = WEIGHT_CLASS_TINY

/obj/item/tickle_feather/attack(mob/living/target, mob/living/user)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(target.stat == DEAD)
		return

	var/mob/living/carbon/carbon_target
	if(iscarbon(target))
		carbon_target = target
	else if(!iscyborg(target))
		return

	if(!target.check_erp_prefs(/datum/preference/toggle/erp/sex_toy, user, src))
		to_chat(user, span_danger("[target] doesn't want you to do that."))
		return

	var/message = ""
	switch(user.zone_selected) //to let code know what part of body we gonna tickle
		if(BODY_ZONE_PRECISE_GROIN)
			if(carbon_target && !carbon_target.is_bottomless())
				to_chat(user, span_danger("Looks like [target]'s groin is covered!"))
				return

			message = (user == target) ? pick("tickles [target.p_them()]self with [src]",
					"gently teases [target.p_their()] belly with [src]") \
				: pick("teases [target]'s belly with [src]",
					"uses [src] to tickle [target]'s belly",
					"tickles [target] with [src]")
		if(BODY_ZONE_CHEST)
			if(carbon_target)
				if(!carbon_target.is_topless())
					to_chat(user, span_danger("Looks like [target]'s chest is covered!"))
					return

				message = (user == target) ? pick("tickles [target.p_them()]self with [src]",
						"gently teases [target.p_their()] own nipples with [src]") \
					: pick("teases [target]'s nipples with [src]",
						"uses [src] to tickle [target]'s left nipple",
						"uses [src] to tickle [target]'s right nipple")
			else
				message = (user == target) ? pick("tickles [target.p_them()]self with [src]",
						"gently teases [target.p_their()] synthetic body with [src]") \
					: pick("teases [target]'s touch sensors with [src]")
		if(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			if(carbon_target && !carbon_target.is_barefoot())
				to_chat(user, span_danger("Looks like [target]'s feet are covered!"))
				return

			message = (user == target) ? pick("tickles [target.p_them()]self with [src]",
					"gently teases [target.p_their()] own feet with [src]") \
				: pick("teases [target]'s feet with [src]",
					"uses [src] to tickle [target]'s [user.zone_selected == BODY_ZONE_L_LEG ? "left" : "right"] foot",
					"uses [src] to tickle [target]'s toes")
		if(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM)
			if(carbon_target && !carbon_target.is_topless())
				to_chat(user, span_danger("Looks like [target]'s armpits are covered!"))
				return

			message = (user == target) ? pick("tickles [target.p_them()]self with [src]",
					"gently teases [target.p_their()] own armpit with [src]") \
				: pick("teases [target]'s right armpit with [src]",
					"uses [src] to tickle [target]'s [user.zone_selected == BODY_ZONE_L_ARM ? "left" : "right"] armpit",
					"uses [src] to tickle [target]'s underarm")
		else
			return

	if(prob(70))
		target.try_lewd_autoemote(pick("laugh", "giggle", "twitch", "twitch_s", "moan"))
	target.do_jitter_animation()
	target.adjustStaminaLoss(4)
	carbon_target?.adjust_arousal(3)
	user.visible_message(span_purple("[user] [message]!"))
	conditional_pref_sound(loc, pick('sound/effects/rustle1.ogg', 'sound/effects/rustle2.ogg'), 70, 1, -1)
