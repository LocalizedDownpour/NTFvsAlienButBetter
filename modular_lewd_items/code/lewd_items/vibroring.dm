/obj/item/clothing/sextoy/vibroring
	name = "vibrating ring"
	desc = "A ring toy used to keep your erection going strong."
	icon_state = "vibroring_pink_off"
	base_icon_state = "vibroring"
	icon = 'modular_lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	/// If the toy is currently on or not
	var/toy_on = FALSE
	/// The current color of the toy, cna be changed and affects sprite
	var/current_color = "pink"
	/// If the color has been changed before
	var/color_changed = FALSE
	/// A list of designs, used in the radial color selection menu
	var/static/list/vibroring_designs
	/// Looping sound called on process
	var/datum/looping_sound/lewd/vibrator/medium/soundloop
	w_class = WEIGHT_CLASS_TINY
	lewd_slot_flags = LEWD_SLOT_PENIS
	clothing_flags = INEDIBLE_CLOTHING

/obj/item/clothing/sextoy/vibroring/attack_self(mob/user)
	toy_on = !toy_on
	to_chat(user, span_notice("You turn the vibroring [toy_on ? "on. Brrrr..." : "off."]"))
	conditional_pref_sound(user, toy_on ? 'sound/machines/click.ogg' : 'sound/machines/click.ogg', 40, TRUE)
	update_icon_state()
	update_icon()
	switch(toy_on)
		if(TRUE)
			soundloop.start()
		if(FALSE)
			soundloop.stop()

/// populates the design list used when creating the radial color choice menu
/obj/item/clothing/sextoy/vibroring/proc/populate_vibroring_designs()
	vibroring_designs = list(
		"pink" = image(icon = src.icon, icon_state = "vibroring_pink_off"),
		"teal" = image(icon = src.icon, icon_state = "vibroring_teal_off"))

/obj/item/clothing/sextoy/vibroring/examine(mob/user)
	. = ..()
	if(!color_changed)
		. += span_notice("Alt-click to change it's color.")

/obj/item/clothing/sextoy/vibroring/click_alt(mob/user)
	if(color_changed)
		return CLICK_ACTION_BLOCKING
	var/choice = show_radial_menu(user, src, vibroring_designs, custom_check = CALLBACK(src, PROC_REF(check_menu), user), radius = 36, require_near = TRUE)
	if(!choice)
		return CLICK_ACTION_BLOCKING
	current_color = choice
	update_icon()
	color_changed = TRUE
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/sextoy/vibroring/Initialize(mapload)
	. = ..()
	update_icon_state()
	update_icon()
	if(!length(vibroring_designs))
		populate_vibroring_designs()

	soundloop = new(src, FALSE)

/obj/item/clothing/sextoy/vibroring/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/obj/item/clothing/sextoy/vibroring/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]_[current_color]_[toy_on? "on" : "off"]"
	inhand_icon_state = "[base_icon_state]_[current_color]"

/obj/item/clothing/sextoy/vibroring/lewd_equipped(mob/living/carbon/user, slot, initial)
	. = ..()
	if(!iscarbon(user))
		return
	if(is_inside_lewd_slot(user))
		START_PROCESSING(SSobj, src)

/obj/item/clothing/sextoy/vibroring/dropped(mob/user, silent)
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/item/clothing/sextoy/vibroring/process(seconds_per_tick)
	var/mob/living/carbon/user = loc
	if(!user || !iscarbon(user))
		return PROCESS_KILL
	if(!toy_on || !user.sexcon_has_penis())
		return
	user.adjust_arousal(1 * seconds_per_tick)
	user.adjust_pleasure(1 * seconds_per_tick)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.cock_state = COCK_STATE_ERECT

/obj/item/clothing/sextoy/vibroring/attack(mob/living/target, mob/living/user)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(!iscarbon(target))
		return ..()
	var/mob/living/carbon/carbon_target = target
	if(!carbon_target.check_erp_prefs(/datum/preference/toggle/erp/sex_toy, user, src))
		to_chat(user, span_danger("[target] doesn't want you to do that."))
		return

	if(!carbon_target.is_bottomless())
		to_chat(user, span_danger("Looks like [target]'s groin is covered!"))
		return

	if(!carbon_target.sexcon_has_penis())
		to_chat(user, span_danger("[target] doesn't have a penis!"))
		return

	if(carbon_target.lewd_penis)
		to_chat(user, span_danger("[target] already has something on their penis!"))
		return

	if(!carbon_target.equip_lewd_item(src, "lewd_penis", user))
		return

	if(user == carbon_target)
		carbon_target.visible_message(span_purple("[user] slips [src] onto the base of [carbon_target.p_their()] penis."), span_purple("You slip [src] onto the base of your penis."))
	else
		carbon_target.visible_message(span_purple("[user] slips [src] onto the base of [carbon_target]'s penis."), span_purple("[user] slips [src] onto the base of your penis."))
	conditional_pref_sound(loc, 'modular_lewd_items/sounds/rubber2.ogg', 30, TRUE)
