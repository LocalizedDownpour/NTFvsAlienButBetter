#define CANDLE_LUMINOSITY 2
#define PAIN_DEFAULT 9

/obj/item/bdsm_candle
	name = "soy candle"
	desc = "A candle with low melting temperature."
	icon = 'modular_lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	lefthand_file = 'modular_lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	icon_state = "candle_pink_off"
	base_icon_state = "candle"
	inhand_icon_state = "candle_pink_off"
	w_class = WEIGHT_CLASS_TINY
	light_color = LIGHT_COLOR_FIRE
	heat = 600
	/// Current color of the candle, can be changed and affects sprite
	var/current_color = "pink"
	/// If the color has been changed before
	var/color_changed = FALSE
	/// If the candle is on
	var/lit = FALSE
	/// If the candle should spawn lit
	var/start_lit = FALSE
	/// Static list used for displaying colors in the radial selection menu
	var/static/list/candle_designs
	/// Static list of possible colors for the candle
	var/static/list/candlelights = list(
		"pink" = LIGHT_COLOR_FIRE,
		"teal" = COLOR_CYAN,
	)

//to change color of candle
//create radial menu
/obj/item/bdsm_candle/proc/populate_candle_designs()
	candle_designs = list(
		"pink" = image(icon = src.icon, icon_state = "candle_pink_lit"),
		"teal" = image(icon = src.icon, icon_state = "candle_teal_lit"),
	)

/obj/item/bdsm_candle/proc/update_brightness()
	set_light_on(lit)
	update_light()

/obj/item/bdsm_candle/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated)
		return FALSE
	return TRUE

/obj/item/bdsm_candle/Initialize(mapload)
	. = ..()
	update_icon()
	update_icon_state()
	if(start_lit)
		light()
	if(!length(candle_designs))
		populate_candle_designs()

/obj/item/bdsm_candle/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]_[current_color]_[lit ? "lit" : "off"]"
	inhand_icon_state = "[base_icon_state]_[current_color]_[lit ? "lit" : "off"]"

/obj/item/bdsm_candle/attackby(obj/item/object, mob/user, params)
	var/msg = object.ignition_effect(src, user)
	update_brightness()
	if(msg)
		light(msg)
	else
		return ..()

/obj/item/bdsm_candle/fire_act(exposed_temperature, exposed_volume)
	if(!lit)
		light()
		update_brightness()
	return ..()

/obj/item/bdsm_candle/get_temperature()
	return lit * heat

/obj/item/bdsm_candle/proc/light(show_message)
	if(lit)
		return
	lit = TRUE
	if(show_message)
		usr.visible_message(show_message)
	set_light(CANDLE_LUMINOSITY)
	START_PROCESSING(SSobj, src)
	update_icon()
	update_brightness()

/obj/item/bdsm_candle/proc/put_out_candle()
	if(!lit)
		return
	lit = FALSE
	update_icon()
	set_light(0)
	return TRUE

/obj/item/bdsm_candle/extinguish()
	put_out_candle()
	return ..()

/obj/item/bdsm_candle/process(seconds_per_tick)
	if(!lit)
		return PROCESS_KILL
	update_brightness()

/obj/item/bdsm_candle/examine(mob/user)
	. = ..()
	if(!color_changed && !lit)
		. += span_notice("Alt-click to change it's color.")
	else if(lit)
		. += span_notice("Alt-click to snuff the flame out.")

/obj/item/bdsm_candle/click_alt(mob/user)
	if(!lit && !color_changed)
		var/choice = show_radial_menu(user, src, candle_designs, custom_check = CALLBACK(src, PROC_REF(check_menu), user), radius = 36, require_near = TRUE)
		if(!choice)
			return CLICK_ACTION_BLOCKING
		current_color = choice
		light_color = candlelights[choice]
		update_icon()
		update_brightness()
		color_changed = TRUE
		return CLICK_ACTION_SUCCESS
	else
		if(!put_out_candle())
			return CLICK_ACTION_BLOCKING
		user.visible_message(span_notice("[user] snuffs [src]."))
		return CLICK_ACTION_SUCCESS

/*
*	WAX DROPPING
*/

/obj/item/bdsm_candle/attack(mob/living/attacked, mob/living/user)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(attacked.stat == DEAD)
		return
	if(!iscarbon(attacked))
		return

	var/mob/living/carbon/carbon_attacked = attacked

	var/message = ""
	if(!carbon_attacked.check_erp_prefs(LEWD_PREF_SEX_TOY, user, src))
		to_chat(user, span_danger("It looks like [carbon_attacked] don't want you to do that."))
		return
	if(!lit)
		to_chat(user, span_danger("[src] needs to be lit to produce wax!"))
		return
	switch(user.zone_selected) //to let code know what part of body we gonna wax
		if(BODY_ZONE_PRECISE_GROIN)
			if(!carbon_attacked.is_bottomless())
				to_chat(user, span_danger("Looks like [carbon_attacked]'s groin is covered!"))
				return
			if(carbon_attacked.sexcon_has_penis())
				message = (user == carbon_attacked) ? pick("drips some wax on [carbon_attacked.p_their()] penis, causing [carbon_attacked.p_them()] to moan in pleasure.",
							"drips some wax on [carbon_attacked.p_them()]self, letting it reach [carbon_attacked.p_their()] penis.") \
						: pick("drips wax right on [carbon_attacked]'s penis. It slightly itches.",
							"drips hot wax from [src] onto [carbon_attacked]'s penis, [carbon_attacked.p_they()] shivers slightly.",
							"tilts the candle. Drops of wax, dripping from [src] onto [carbon_attacked]'s penis, made [carbon_attacked.p_them()] moan.")
			else
				message = (user == carbon_attacked) ? pick("drips some wax on [carbon_attacked.p_them()]self, letting it reach [carbon_attacked.p_their()] vagina.",
							"drips some wax onto [carbon_attacked.p_their()] pussy as [carbon_attacked.p_they()] moan in pleasure") \
						: pick("drips some wax on [carbon_attacked]'s vagina.",
							"tilts the candle as the wax slowly drops down, reaching [carbon_attacked]'s vagina.",
							"tilts the candle. Drops of wax, dripping from [src] onto [carbon_attacked]'s pussy, made [carbon_attacked.p_them()] moan.")
			carbon_attacked.adjust_pain(PAIN_DEFAULT)

		if(BODY_ZONE_CHEST)
			if(!carbon_attacked.is_topless())
				to_chat(user, span_danger("Looks like [carbon_attacked]'s chest is covered!"))
				return
			message = (user == carbon_attacked) ? pick("drips some wax on [carbon_attacked.p_their()] breasts, releasing all [carbon_attacked.p_their()] lustness",
					"drips some wax right on [carbon_attacked.p_their()] chest, making [carbon_attacked.p_their()] feel faint.") \
				: pick("pours the wax that is slowly dripping from [src] onto [carbon_attacked]'s breasts, [carbon_attacked.p_they()] shows pure enjoyment.",
					"tilts the candle. Right in the moment when wax drips on [carbon_attacked]'s breasts, [carbon_attacked.p_they()] shivers",
					"tilts the candle. Just when hot drops of wax fell on [carbon_attacked]'s breasts, [carbon_attacked.p_they()] quietly moans in pleasure")
			carbon_attacked.adjust_pain(PAIN_DEFAULT * 0.66)
		else
			return
	carbon_attacked.do_jitter_animation()
	if(prob(50))
		carbon_attacked.try_lewd_autoemote(pick("twitch_s" , "gasp", "shiver"))
	user.visible_message(span_purple("[user] [message]!"))
	conditional_pref_sound(loc, pick('modular_lewd_items/sounds/vax1.ogg',
						'modular_lewd_items/sounds/vax2.ogg'), 70, TRUE)

#undef CANDLE_LUMINOSITY
#undef PAIN_DEFAULT
