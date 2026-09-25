////////////
///CONDOM///
////////////

//Packaged condom

/obj/item/condom_pack
	name = "condom pack"
	desc = "Don't worry, I have protection."
	icon_state = "condom_pack_pink"
	base_icon_state = "condom_pack"
	icon = 'modular_lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	w_class = WEIGHT_CLASS_TINY
	/// The current color of the condom, can be changed and affects sprite
	var/current_color = "pink"

/obj/item/condom_pack/Initialize(mapload)
	. = ..()
	//color chosen randomly when item spawned
	current_color = "pink"
	if(prob(50))
		current_color = "teal"
	update_icon_state()
	update_icon()

/obj/item/condom_pack/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]_[current_color]"

/obj/item/condom_pack/attack_self(mob/user)
	to_chat(user, span_notice("You start to open the condom pack..."))
	if(!do_after(user, 1.5 SECONDS, target = user))
		return
	conditional_pref_sound(src.loc, 'sound/items/poster_ripped.ogg', 50, TRUE)
	var/obj/item/clothing/sextoy/condom/removed_condom = new /obj/item/clothing/sextoy/condom

	user.put_in_hands(removed_condom)
	switch(current_color)
		if("pink")
			removed_condom.current_color = "pink"
		if("teal")
			removed_condom.current_color = "teal"
	removed_condom.update_icon_state()
	removed_condom.update_icon()
	qdel(src)

//Opened condom

/obj/item/clothing/sextoy/condom
	name = "condom"
	desc = "I wonder if I can put this over my head..."
	icon_state = "condom_pink_unused"
	base_icon_state = "condom"
	icon = 'modular_lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	w_class = WEIGHT_CLASS_TINY
	lewd_slot_flags = LEWD_SLOT_PENIS
	/// Current color of the condom, can be changed and affects sprite
	var/current_color = "pink"
	/// Sprite/durability state: unused, used, dirty (filled) or broken
	var/condom_state = CONDOM_STATE_UNUSED
	/// How many units of cum the condom can hold before it bursts
	var/condom_volume = CONDOM_MAX_VOLUME

/obj/item/clothing/sextoy/condom/Initialize(mapload)
	. = ..()

	create_reagents(condom_volume)

	if(current_color != "pink" || condom_state != CONDOM_STATE_UNUSED)
		update_icon_state()
		update_icon()

/obj/item/clothing/sextoy/condom/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]_[current_color]_[condom_state]"

/obj/item/clothing/sextoy/condom/examine(mob/user)
	. = ..()
	if(reagents?.total_volume)
		. += span_notice("It holds [reagents.total_volume] out of [reagents.maximum_volume] units - pour it into any open container before it bursts (the condom will not survive that, though).")

/// Updates the condom's sprite and durability state, called after use. Returns TRUE if intact, FALSE if broken.
/obj/item/clothing/sextoy/condom/proc/condom_use()
	switch(condom_state)
		if(CONDOM_STATE_USED)
			name = "used condom"
			condom_state = CONDOM_STATE_DIRTY
			if(prob(10)) // 10% chance to break on first ejaculation
				break_condom()
				return FALSE
			update_icon_state()
			update_icon()
			return TRUE

		if(CONDOM_STATE_UNUSED)
			// Worn without being marked as such: treat this as the first load.
			condom_state = CONDOM_STATE_USED
			return condom_use()

		if(CONDOM_STATE_DIRTY)
			// Already holding a load, but it keeps catching more until it is full (see fill_with_cum).
			return TRUE

		if(CONDOM_STATE_BROKEN)
			return FALSE

	return TRUE

/// Catches one load of cum so it can be poured out into a container later.
/// Loads stack up to CONDOM_MAX_VOLUME; a load that does not fit bursts the condom (returns FALSE).
/obj/item/clothing/sextoy/condom/proc/fill_with_cum(mob/living/carbon/filler, datum/reagent/cum_type, amount)
	if(!reagents)
		create_reagents(condom_volume)
	if(!cum_type)
		if(isxeno(filler))
			cum_type = /datum/reagent/consumable/nutriment/cum/xeno/strong
		else if(filler?.sexcon?.can_use_testicles())
			cum_type = /datum/reagent/consumable/nutriment/cum
		else
			cum_type = /datum/reagent/consumable/nutriment/cum/girl
	if(isnull(amount))
		amount = isxeno(filler) ? CONDOM_XENO_FILL_AMOUNT : CONDOM_FILL_AMOUNT
	if(reagents.total_volume + amount > reagents.maximum_volume)
		// Too much for one condom: it bursts and everything leaks out.
		break_condom()
		return FALSE
	reagents.add_reagent(cum_type, amount)
	return TRUE

/// Ruins the condom: it snaps open and can no longer hold anything.
/obj/item/clothing/sextoy/condom/proc/break_condom()
	if(condom_state == CONDOM_STATE_BROKEN)
		return FALSE
	condom_state = CONDOM_STATE_BROKEN
	name = "broken condom"
	reagents?.clear_reagents() // everything it held leaks out
	update_icon_state()
	update_icon()
	return TRUE

/// Pouring a filled condom into any open container. Doing so rips it open.
/obj/item/clothing/sextoy/condom/afterattack(atom/target, mob/user, proximity, params)
	. = ..()
	if(!proximity || !reagents || !reagents.total_volume)
		return
	if(!target.is_refillable() || !target.reagents)
		return
	if(target.reagents.holder_full())
		to_chat(user, span_warning("[target] is full."))
		return
	var/trans = reagents.trans_to(target, reagents.total_volume)
	if(!trans)
		return
	playsound(target, 'sound/effects/slosh.ogg', 25, TRUE)
	user.visible_message(span_purple("[user] wrings [src] out into [target]."),\
		span_purple("You wring [src] out into [target], spilling [trans] unit\s of its contents."))
	break_condom()

//When condom equipped we doing stuff
/obj/item/clothing/sextoy/condom/lewd_equipped(mob/user, slot, initial)
	. = ..()
	if((slot == "lewd_penis") && condom_state == CONDOM_STATE_UNUSED)
		condom_state = CONDOM_STATE_USED
		update_icon_state()
		update_icon()

/obj/item/clothing/sextoy/condom/attack(mob/living/target, mob/living/user)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(!iscarbon(target))
		return ..()
	if(condom_state == CONDOM_STATE_BROKEN)
		to_chat(user, span_danger("[src] is ripped open and won't stay on anyone!"))
		return
	var/mob/living/carbon/carbon_target = target
	if(!carbon_target.check_erp_prefs(LEWD_PREF_SEX_TOY, user, src))
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
		carbon_target.visible_message(span_purple("[user] rolls [src] onto [carbon_target.p_their()] penis."), span_purple("You roll [src] onto your penis."))
	else
		carbon_target.visible_message(span_purple("[user] rolls [src] onto [carbon_target]'s penis."), span_purple("[user] rolls [src] onto your penis."))
	conditional_pref_sound(loc, 'modular_lewd_items/sounds/rubber1.ogg', 30, TRUE)
