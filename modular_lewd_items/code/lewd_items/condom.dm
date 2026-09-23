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
	var/current_color = "pink"
	var/condom_state = "unused"
	lewd_slot_flags = LEWD_SLOT_PENIS

/obj/item/clothing/sextoy/condom/Initialize(mapload)
	. = ..()

	if(current_color != "pink" || condom_state != "unused")
		update_icon_state()
		update_icon()

/obj/item/clothing/sextoy/condom/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]_[current_color]_[condom_state]"

/// Updates the condom's sprite and durability state, called after use. Returns TRUE if intact, FALSE if broken.
/obj/item/clothing/sextoy/condom/proc/condom_use()
	switch(condom_state)
		if("used")
			name = "used condom"
			condom_state = "dirty"
			if(prob(10)) // 10% chance to break on first ejaculation
				name = "broken condom"
				condom_state = TRAIT_CONDOM_BROKEN
				update_icon_state()
				update_icon()
				return FALSE
			update_icon_state()
			update_icon()
			return TRUE

		if("dirty")
			// Already used once! Guaranteed failure on repeated use without replacement
			name = "broken condom"
			condom_state = TRAIT_CONDOM_BROKEN
			update_icon_state()
			update_icon()
			return FALSE

		if(TRAIT_CONDOM_BROKEN)
			return FALSE

	return TRUE

//When condom equipped we doing stuff
/obj/item/clothing/sextoy/condom/lewd_equipped(mob/user, slot, initial)
	. = ..()
	if((slot == "lewd_penis") && condom_state == "unused")
		condom_state = "used"
		update_icon_state()
		update_icon()

/obj/item/clothing/sextoy/condom/attack(mob/living/target, mob/living/user)
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
		carbon_target.visible_message(span_purple("[user] rolls [src] onto [carbon_target.p_their()] penis."), span_purple("You roll [src] onto your penis."))
	else
		carbon_target.visible_message(span_purple("[user] rolls [src] onto [carbon_target]'s penis."), span_purple("[user] rolls [src] onto your penis."))
	conditional_pref_sound(loc, 'modular_lewd_items/sounds/rubber1.ogg', 30, TRUE)
