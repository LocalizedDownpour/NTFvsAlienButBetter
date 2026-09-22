/obj/item/kinky_shocker
	name = "kinky shocker"
	desc = "A small toy that can weakly shock someone."
	icon_state = "shocker_off"
	base_icon_state = "shocker"
	inhand_icon_state = "shocker_off"
	icon = 'modular_lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	lefthand_file = 'modular_lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	w_class = WEIGHT_CLASS_TINY
	/// If the shocker is on or not
	var/shocker_on = FALSE
	/// Holds the cell placed in the shocker
	var/obj/item/cell/cell
	/// A type of what cell should be put in the shocker on initialize
	var/preload_cell_type = /obj/item/cell/crap
	/// What it should cost the cell to use the shocker once
	var/cell_hit_cost = 10
	/// If the user should be able to remove the cell or not
	var/can_remove_cell = TRUE
	/// The custom part of the string that is displayed on activation of the shocker
	var/activate_sound = "sparks"

/obj/item/kinky_shocker/get_cell()
	return cell

/obj/item/kinky_shocker/Initialize(mapload)
	. = ..()
	update_icon_state()
	update_icon()
	if(preload_cell_type && ispath(preload_cell_type, /obj/item/cell))
		cell = new preload_cell_type(src)

/// Deduct an amount of charge from the cell
/obj/item/kinky_shocker/proc/deductcharge(chrgdeductamt)
	if(!cell)
		return FALSE
	. = cell.use(chrgdeductamt)
	if(shocker_on && cell.charge < cell_hit_cost)
		shocker_on = FALSE
		update_icon_state()
		update_icon()

/obj/item/kinky_shocker/examine(mob/user)
	. = ..()
	if(cell)
		. += span_notice("\The [src] is [round(cell.percent())]% charged.")
	else
		. += span_warning("\The [src] does not have a power source installed.")

/obj/item/kinky_shocker/attackby(obj/item/cell/powercell, mob/user, params)
	if(!istype(powercell, /obj/item/cell))
		return ..()
	if(cell)
		to_chat(user, span_warning("[src] already has a cell!"))
	else
		if(powercell.maxcharge < cell_hit_cost)
			to_chat(user, span_notice("[src] requires a higher capacity cell."))
			return
		if(!user.drop_inv_item_to_loc(powercell, src))
			return
		cell = powercell
		to_chat(user, span_notice("You install a cell in [src]."))
		update_icon_state()
		update_icon()

/obj/item/kinky_shocker/click_alt(mob/user)
	tryremovecell(user)
	return CLICK_ACTION_SUCCESS

/obj/item/kinky_shocker/proc/tryremovecell(mob/user)
	if(!(cell && can_remove_cell))
		return
	cell.forceMove(get_turf(src))
	cell = null
	to_chat(user, span_notice("You remove the cell from [src]."))
	shocker_on = FALSE
	update_icon_state()
	update_icon()
	return CLICK_ACTION_SUCCESS

/obj/item/kinky_shocker/attack_self(mob/user)
	toggle_shocker(user)

/obj/item/kinky_shocker/proc/toggle_shocker(mob/user)
	if(cell && cell.charge >= cell_hit_cost)
		shocker_on = !shocker_on
		to_chat(user, span_notice("You turn the shocker [shocker_on ? "on. Buzz!" : "off."]"))
		playsound(user, shocker_on ? 'sound/weapons/armbomb.ogg' : 'sound/weapons/guns/fire/empty.ogg', 40, TRUE)
	else
		shocker_on = FALSE
		if(!cell)
			to_chat(user, span_warning("[src] does not have a power source!"))
		else
			to_chat(user, span_warning("[src] is out of charge."))
	update_icon_state()
	update_icon()
	add_fingerprint(user)

/obj/item/kinky_shocker/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]_[shocker_on ? "on" : "off"]"
	inhand_icon_state = "[base_icon_state]_[shocker_on ? "on" : "off"]"

/obj/item/kinky_shocker/attack(mob/living/target, mob/living/user)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(target.stat == DEAD)
		return

	var/mob/living/carbon/carbon_target
	if(iscarbon(target))
		carbon_target = target
	else
		return

	if(!shocker_on)
		to_chat(user, span_danger("[src] must be enabled before use!"))
		return

	if(!target.check_erp_prefs(/datum/preference/toggle/erp/sex_toy, user, src))
		to_chat(user, span_danger("[target] doesn't want you to do that."))
		return

	var/message = ""
	switch(user.zone_selected)
		if(BODY_ZONE_PRECISE_GROIN)
			if(carbon_target && !carbon_target.is_bottomless())
				to_chat(user, span_danger("Looks like [target]'s groin is covered!"))
				return
			var/penis_message = (user == target) ? pick("leans [src] against [target.p_their()] penis, letting it shock [target.p_them()]. Ouch...", "shocks [target.p_their()] penis with [src]") : pick("uses [src] to shock [target]'s penis", "shocks [target]'s penis with [src]")
			var/vagina_message = (user == target) ? pick("leans [src] against [target.p_their()] vagina, letting it shock [target.p_them()]. Ouch...", "shocks [target.p_their()] pussy with [src]") : pick("uses [src] to shock [target]'s vagina", "shocks [target]'s pussy with [src]")

			if(carbon_target?.sexcon_has_penis() && carbon_target?.sexcon_has_vagina())
				message = pick(penis_message, vagina_message)
			else if(carbon_target?.sexcon_has_vagina())
				message = vagina_message
			else if(carbon_target?.sexcon_has_penis())
				message = penis_message
			else
				message = (user == target) ? "leans [src] against [target.p_their()] groin, shocking [target.p_them()]." : "shocks [target]'s groin with [src]"

		if(BODY_ZONE_CHEST)
			if(carbon_target && !carbon_target.is_topless())
				to_chat(user, span_danger("Looks like [target]'s chest is covered!"))
				return
			message = (user == target) ? "leans [src] against [target.p_their()] chest, shocking [target.p_them()]." : "uses [src] to shock [target]'s chest."

		if(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
			var/arm = user.zone_selected == BODY_ZONE_L_ARM ? "left arm" : "right arm"
			message = (user == target) ? "shocks [target.p_their()] [arm] with [src]." : "shocks [target]'s [arm] with [src]."

		if(BODY_ZONE_HEAD)
			message = (user == target) ? "shocks [target.p_their()] neck with [src]." : "shocks [target]'s neck with [src]."

		if(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			var/leg = user.zone_selected == BODY_ZONE_L_LEG ? "left leg" : "right leg"
			message = (user == target) ? "shocks [target.p_their()] [leg] with [src]." : "shocks [target]'s [leg] with [src]."
		else
			to_chat(user, span_danger("You can't shock [target] there!"))
			return

	user.visible_message(span_purple("[user] [message]!"))
	playsound(loc, 'sound/effects/sparks1.ogg', 50, TRUE)
	deductcharge(cell_hit_cost)
	target.do_jitter_animation()
	target.adjustStaminaLoss(3)
	target.adjust_pain(9)
	target.adjust_stutter(30 SECONDS)
