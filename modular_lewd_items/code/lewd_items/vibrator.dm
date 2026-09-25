#define DEFAULT_AROUSAL_INCREASE 4
#define DEFAULT_PLEASURE_INCREASE 2

#define VIB_OFF "off"
#define VIB_LOW "low"
#define VIB_MEDIUM "medium"
#define VIB_HIGH "hard"

//This code huge and blocky, but we're working on update for... my god, 4 months. If you can upgrade it - do it, but don't remove or break something, test carefully. This item is insertable.
/obj/item/clothing/sextoy/vibrator
	name = "vibrator"
	desc = "Woah. What an... Interesting item. I wonder what this red button does..."
	icon_state = "vibrator_pink_off"
	base_icon_state = "vibrator"
	inhand_icon_state = "vibrator_pink"
	icon = 'modular_lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	lefthand_file = 'modular_lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	lewd_slot_flags = LEWD_SLOT_VAGINA | LEWD_SLOT_ANUS
	/// If the toy is on or not
	var/toy_on = FALSE
	/// Current color of the toy, can be changed and affects sprite
	var/current_color = "pink"
	/// If the color has been changed before
	var/color_changed = FALSE
	/// Current vibration mode of the toy
	var/vibration_mode = VIB_OFF
	/// Looping sound used for the toy's audible bit
	var/datum/looping_sound/lewd/vibrator/low/soundloop1
	/// Looping sound used for the toy's audible bit
	var/datum/looping_sound/lewd/vibrator/medium/soundloop2
	/// Looping sound used for the toy's audible bit
	var/datum/looping_sound/lewd/vibrator/high/soundloop3
	/// Static list of designs of the toy, used for the color selection radial menu
	var/static/list/vibrator_designs
	w_class = WEIGHT_CLASS_TINY

//create radial menu
/obj/item/clothing/sextoy/vibrator/proc/populate_vibrator_designs()
	vibrator_designs = list(
		"pink" = image (icon = src.icon, icon_state = "vibrator_pink_low"),
		"teal" = image(icon = src.icon, icon_state = "vibrator_teal_low"),
		"red" = image(icon = src.icon, icon_state = "vibrator_red_low"),
		"yellow" = image(icon = src.icon, icon_state = "vibrator_yellow_low"),
		"green" = image(icon = src.icon, icon_state = "vibrator_green_low"))

/obj/item/clothing/sextoy/vibrator/examine(mob/user)
	. = ..()
	if(!color_changed)
		. += span_notice("Alt-click to change it's design.")

/obj/item/clothing/sextoy/vibrator/click_alt(mob/user)
	if(color_changed)
		return
	var/choice = show_radial_menu(user, src, vibrator_designs, custom_check = CALLBACK(src, PROC_REF(check_menu), user), radius = 36, require_near = TRUE)
	if(!choice)
		return CLICK_ACTION_BLOCKING
	current_color = choice
	update_icon_state()
	update_icon()
	color_changed = TRUE
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/sextoy/vibrator/Initialize(mapload)
	. = ..()
	update_icon_state()
	update_icon()
	if(!length(vibrator_designs))
		populate_vibrator_designs()

	//soundloop
	soundloop1 = new(src, FALSE)
	soundloop2 = new(src, FALSE)
	soundloop3 = new(src, FALSE)

/obj/item/clothing/sextoy/vibrator/Destroy()
	QDEL_NULL(soundloop1)
	QDEL_NULL(soundloop2)
	QDEL_NULL(soundloop3)
	return ..()

/obj/item/clothing/sextoy/vibrator/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]_[current_color]_[vibration_mode]"
	inhand_icon_state = "[base_icon_state]_[current_color]"

/obj/item/clothing/sextoy/vibrator/lewd_equipped(mob/living/carbon/user, slot)
	. = ..()
	if(!iscarbon(user))
		return
	if(is_inside_lewd_slot(user))
		START_PROCESSING(SSobj, src)

/obj/item/clothing/sextoy/vibrator/dropped(mob/user, slot)
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/clothing/sextoy/vibrator/process(seconds_per_tick)
	var/mob/living/carbon/user = loc
	if(!iscarbon(user))
		return
	if(toy_on)
		if(vibration_mode == VIB_LOW && user.arousal < 40) //prevent non-stop cumming from wearing this thing
			user.adjust_arousal(0.7 * seconds_per_tick)
			user.adjust_pleasure(0.7 * seconds_per_tick)
		if(vibration_mode == VIB_MEDIUM && user.arousal < 70)
			user.adjust_arousal(1 * seconds_per_tick)
			user.adjust_pleasure(1 * seconds_per_tick)
		if(vibration_mode == VIB_HIGH) //no mercy
			user.adjust_arousal(1.5 * seconds_per_tick)
			user.adjust_pleasure(1.5 * seconds_per_tick)
	else if(!toy_on && user.arousal < 30)
		user.adjust_arousal(0.5 * seconds_per_tick)
		user.adjust_pleasure(0.5 * seconds_per_tick)

/obj/item/clothing/sextoy/vibrator/verb/wear_vibrator()
	set name = "Insert Vibrator"
	set category = "IC"
	set desc = "Insert this vibrator into yourself to wear it."
	set src in usr

	var/mob/living/carbon/user = usr
	if(!iscarbon(user))
		return
	if(!user.is_bottomless())
		to_chat(user, span_danger("Your groin is covered!"))
		return

	var/list/choices = list("Anus" = "lewd_anus")
	if(user.sexcon_has_vagina())
		choices["Vagina"] = "lewd_vagina"

	var/chosen_label = tgui_input_list(user, "Where do you want to insert [src]?", "Insert Vibrator", choices)
	if(!chosen_label)
		return
	var/slot = choices[chosen_label]
	if(user.vars[slot])
		to_chat(user, span_danger("You already have something in your [chosen_label]!"))
		return

	if(user.equip_lewd_item(src, slot, user))
		user.visible_message(span_purple("[user] inserts [src] into their [chosen_label]."), span_purple("You insert [src] into your [chosen_label]."))
		conditional_pref_sound(loc, 'modular_lewd_items/sounds/squelch1.ogg', 30, TRUE)

/obj/item/clothing/sextoy/vibrator/attack(mob/living/target, mob/living/user)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(target.stat == DEAD)
		return
	if(!iscarbon(target))
		return

	var/mob/living/carbon/carbon_target = target

	var/message = ""
	if(!toy_on)
		to_chat(user, span_notice("[src] must be on to use it!"))
		return
	if(!carbon_target.check_erp_prefs(LEWD_PREF_SEX_TOY, user, src))
		to_chat(user, span_danger("Looks like [carbon_target] doesn't want you to do that."))
		return

	var/vibration_adj = ""
	switch(vibration_mode)
		if(VIB_LOW)
			vibration_adj = pick("gently", "delicately")
		if(VIB_HIGH)
			vibration_adj = pick("roughly", "aggressively")

	switch(user.zone_selected) //to let code know what part of body we gonna vibe
		if(BODY_ZONE_PRECISE_GROIN)
			if(!carbon_target.is_bottomless())
				to_chat(user, span_danger("Looks like [carbon_target]'s groin is covered!"))
				return
			var/penis_message = (user == carbon_target) ? pick("massages their penis with the [src]",
					"[vibration_adj] teases their penis with [src]") \
				: pick("[vibration_adj] massages [carbon_target]'s penis with [src]",
					"uses [src] to [vibration_adj] massage [carbon_target]'s penis",
					"leans the massager against [carbon_target]'s penis")
			var/vagina_message = (user == carbon_target) ? pick("massages their vagina with the [src]",
						"[vibration_adj] teases their pussy with [src]") \
					: pick("[vibration_adj] massages [carbon_target]'s vagina with [src]",
						"uses [src] to [vibration_adj] massage [carbon_target]'s crotch",
						"leans the massager against [carbon_target]'s pussy")
			if(carbon_target.sexcon_has_penis() && carbon_target.sexcon_has_vagina())
				message = pick(penis_message, vagina_message)
			else if(carbon_target.sexcon_has_penis())
				message = penis_message
			else
				message = vagina_message

			carbon_target.adjust_arousal(DEFAULT_AROUSAL_INCREASE)
			carbon_target.adjust_pleasure(DEFAULT_PLEASURE_INCREASE)
			if(prob(50))
				carbon_target.try_lewd_autoemote(pick("twitch_s", "moan", "blush"))

		if(BODY_ZONE_CHEST)
			if(!carbon_target.is_topless())
				to_chat(user, span_danger("Looks like [carbon_target]'s chest is covered!"))
				return

			message = (user == carbon_target) ? pick("massages their breasts with the [src]",
					"[vibration_adj] teases their tits with [src]") \
				: pick("[vibration_adj] teases [carbon_target]'s breasts with [src]",
					"uses [src] to [vibration_adj] massage [carbon_target]'s tits",
					"uses [src] to tease [carbon_target]'s boobs",
					"rubs [carbon_target]'s tits with [src]")

			carbon_target.adjust_arousal(DEFAULT_AROUSAL_INCREASE)
			carbon_target.adjust_pleasure(DEFAULT_PLEASURE_INCREASE * 0.5)
			if(prob(30))
				carbon_target.try_lewd_autoemote(pick("twitch_s", "moan"))
		else
			return
	user.visible_message(span_purple("[user] [message]!"))
	conditional_pref_sound(loc, 'modular_lewd_items/sounds/vibrate.ogg', 10, TRUE)

/obj/item/clothing/sextoy/vibrator/attack_self(mob/user, obj/item/attack_item)
	toggle_mode()
	switch(vibration_mode)
		if(VIB_LOW)
			to_chat(user, span_notice("Vibration mode now is low. Bzzz..."))
		if(VIB_MEDIUM)
			to_chat(user, span_notice("Vibration mode now is medium. Bzzzz!"))
		if(VIB_HIGH)
			to_chat(user, span_notice("Vibration mode now is high. Careful with that thing."))
		if(VIB_OFF)
			to_chat(user, span_notice("Vibrator turned off. Fun's over?"))
	update_icon()
	update_icon_state()

/obj/item/clothing/sextoy/vibrator/proc/toggle_mode()
	switch(vibration_mode)
		if(VIB_OFF)
			vibration_mode = VIB_LOW
			toy_on = TRUE
			conditional_pref_sound(loc, 'sound/machines/click.ogg', 20, TRUE)
			soundloop1.start()
		if(VIB_LOW)
			vibration_mode = VIB_MEDIUM
			conditional_pref_sound(loc, 'sound/machines/click.ogg', 20, TRUE)
			soundloop1.stop()
			soundloop2.start()
		if(VIB_MEDIUM)
			vibration_mode = VIB_HIGH
			conditional_pref_sound(loc, 'sound/machines/click.ogg', 20, TRUE)
			soundloop2.stop()
			soundloop3.start()
		if(VIB_HIGH)
			vibration_mode = VIB_OFF
			toy_on = FALSE
			conditional_pref_sound(loc, 'sound/machines/click.ogg', 20, TRUE)
			soundloop3.stop()

#undef DEFAULT_AROUSAL_INCREASE
#undef DEFAULT_PLEASURE_INCREASE

#undef VIB_OFF
#undef VIB_LOW
#undef VIB_MEDIUM
#undef VIB_HIGH
