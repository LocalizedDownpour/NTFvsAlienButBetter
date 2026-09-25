/obj/item/clothing/strapon
	name = "strapon"
	desc = "Sometimes you need a special way to humiliate someone."
	icon_state = "strapon_human"
	base_icon_state = "strapon"
	icon = 'modular_lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	icon_override = 'modular_lewd_items/icons/mob/lewd_items/lewd_items.dmi'
	equip_slot_flags = ITEM_SLOT_BELT
	var/in_hands = FALSE
	var/type_changed = FALSE
	var/strapon_type = "human"
	var/obj/item/strapon_dildo/strapon_item
	var/static/list/strapon_types
	actions_types = list(/datum/action/item_action/take_strapon)

//create radial menu
/obj/item/clothing/strapon/proc/populate_strapon_types()
	strapon_types = list(
		"avian" = image (icon = src.icon, icon_state = "strapon_avian"),
		"canine" = image (icon = src.icon, icon_state = "strapon_canine"),
		"dragon" = image (icon = src.icon, icon_state = "strapon_dragon"),
		"equine" = image (icon = src.icon, icon_state = "strapon_equine"),
		"human" = image (icon = src.icon, icon_state = "strapon_human"))

//to change model
/obj/item/clothing/strapon/click_alt(mob/user)
	if(type_changed)
		return CLICK_ACTION_BLOCKING
	var/choice = show_radial_menu(user, src, strapon_types, custom_check = CALLBACK(src, PROC_REF(check_menu), user), radius = 36, require_near = TRUE)
	if(!choice)
		return CLICK_ACTION_BLOCKING
	strapon_type = choice
	update_icon()
	type_changed = TRUE
	return CLICK_ACTION_SUCCESS

//Check if we can change strapon's model
/obj/item/clothing/strapon/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/obj/item/clothing/strapon/Initialize(mapload)
	. = ..()
	update_icon_state()
	update_icon()
	update_mob_action_buttonss()
	if(!length(strapon_types))
		populate_strapon_types()

/obj/item/clothing/strapon/equipped(mob/user, slot)
	. = ..()
	var/mob/living/carbon/human/affected_mob = user
	if(istype(affected_mob) && src == affected_mob.belt)
		blocks_bottom_genital = TRUE
	else
		return

/obj/item/clothing/strapon/dropped(mob/living/user)
	. = ..()
	var/mob/living/carbon/human/affected_mob = user
	blocks_bottom_genital = FALSE

	if(strapon_item && !ismob(loc) && in_hands == TRUE && (!istype(affected_mob) || src != affected_mob.belt))
		qdel(strapon_item)
		in_hands = FALSE

/obj/item/clothing/strapon/update_icon_state()
	.=..()
	icon_state = "[base_icon_state]_[strapon_type]"
	worn_icon_state = "[base_icon_state]_[strapon_type]"

//Functionality stuff
/obj/item/clothing/strapon/proc/update_mob_action_buttonss()
	for(var/datum/action/item_action/take_strapon/action_button in actions)
		action_button.button_icon_state = "dildo_[strapon_type]"
		action_button.button_icon = 'modular_lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	update_icon()

//button stuff
/datum/action/item_action/take_strapon
	name = "Put strapon in hand"
	desc = "Put the strapon in your hand in order to use it properly."

/datum/action/item_action/take_strapon/action_activate()
	var/obj/item/clothing/strapon/affected_item = target
	if(istype(affected_item))
		affected_item.check()
	return TRUE

/datum/action/item_action/take_strapon/Trigger(trigger_flags)
	return action_activate()

/obj/item/clothing/strapon/proc/check()
	var/mob/living/carbon/human/user = usr
	if(src == user.belt)
		toggle(user)
	else
		to_chat(user, span_warning("You need to put the strapon around your waist before you can use it!"))

/obj/item/clothing/strapon/proc/toggle(mob/living/carbon/human/user)
	conditional_pref_sound(user, 'modular_lewd_items/sounds/latex.ogg', 40, TRUE)
	var/obj/item/held = user.get_active_held_item()
	var/obj/item/unheld = user.get_inactive_held_item()

	if(in_hands == TRUE)
		if(istype(held, /obj/item/strapon_dildo))
			qdel(held)
			user.visible_message(span_notice("[user] puts the strapon back."))
			in_hands = FALSE
			return

		else if(istype(unheld, /obj/item/strapon_dildo))
			qdel(unheld)
			user.visible_message(span_notice("[user] puts the strapon back."))
			in_hands = FALSE
			return

		else if(held == null)
			if(istype(unheld, /obj/item/strapon_dildo))
				if(src == user.belt)
					qdel(unheld)
					strapon_item = new()
					user.put_in_hands(strapon_item)
					strapon_item.strapon_type = strapon_type
					strapon_item.update_icon_state()
					strapon_item.update_icon()
					user.visible_message(span_notice("[user] holds the strapon in their hand menacingly."))
					in_hands = TRUE
					return
		else
			user.visible_message(span_notice("[user] tries to hold the strapon in their hand, but their hand isn't empty!"))
			return
	else
		strapon_item = new()
		user.put_in_hands(strapon_item)
		strapon_item.strapon_type = strapon_type
		strapon_item.update_icon_state()
		strapon_item.update_icon()
		user.visible_message(span_notice("[user] holds the strapon in their hand menacingly."))
		in_hands = TRUE
		return

/obj/item/strapon_dildo
	name = "strapon"
	desc = "An item with which to be menacing and merciless."
	icon = 'modular_lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	icon_state = "dildo_human"
	base_icon_state = "dildo"
	inhand_icon_state = "nothing"
	force = 0
	throwforce = 0
	item_flags = ABSTRACT | DROPDEL
	var/strapon_type = "human"

/obj/item/strapon_dildo/Initialize(mapload)
	. = ..()
	update_icon_state()
	update_icon()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_STRAPON)

/obj/item/strapon_dildo/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]_[strapon_type]"

/obj/item/strapon_dildo/attack(mob/living/hit_mob, mob/living/user)
	if(hit_mob == user)
		return
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(!iscarbon(hit_mob))
		return

	var/mob/living/carbon/carbon_hit = hit_mob

	var/message = ""
	if(carbon_hit.check_erp_prefs(LEWD_PREF_SEX_TOY, user, src))
		switch(user.zone_selected)
			if(BODY_ZONE_PRECISE_GROIN)
				if(carbon_hit.sexcon_has_vagina())
					if(carbon_hit.is_bottomless())
						message = pick("delicately rubs [carbon_hit]'s vagina with [src]", "uses [src] to fuck [carbon_hit]'s vagina", "jams [carbon_hit]'s pussy with [src]", "teases [carbon_hit]'s pussy with [src]")
						carbon_hit.adjust_arousal(6)
						carbon_hit.adjust_pleasure(8)
						if(prob(40))
							carbon_hit.try_lewd_autoemote(pick("twitch_s", "moan"))
						user.visible_message(span_purple("[user] [message]!"))
						conditional_pref_sound(loc, pick('modular_lewd_items/sounds/bang1.ogg',
											'modular_lewd_items/sounds/bang2.ogg',
											'modular_lewd_items/sounds/bang3.ogg',
											'modular_lewd_items/sounds/bang4.ogg',
											'modular_lewd_items/sounds/bang5.ogg',
											'modular_lewd_items/sounds/bang6.ogg'), 60, TRUE)
					else
						to_chat(user, span_danger("[carbon_hit]'s groin is covered!"))
						return
				else
					to_chat(user, span_danger("[carbon_hit] doesn't have suitable genitalia for that!"))
					return

			if(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_PRECISE_EYES)
				if(!carbon_hit.is_mouth_covered())
					message = pick("fucks [carbon_hit]'s mouth with [src]", "chokes [carbon_hit] by inserting [src] into [carbon_hit.p_their()] throat", "forces [carbon_hit] to suck [src]", "inserts [src] into [carbon_hit]'s throat")
					carbon_hit.adjust_arousal(4)
					carbon_hit.adjust_pleasure(1)
					carbon_hit.adjustOxyLoss(1.5)
					if(prob(70))
						carbon_hit.try_lewd_autoemote(pick("gasp", "moan"))
					user.visible_message(span_purple("[user] [message]!"))
					conditional_pref_sound(loc, pick('modular_lewd_items/sounds/bang1.ogg',
										'modular_lewd_items/sounds/bang2.ogg',
										'modular_lewd_items/sounds/bang3.ogg',
										'modular_lewd_items/sounds/bang4.ogg',
										'modular_lewd_items/sounds/bang5.ogg',
										'modular_lewd_items/sounds/bang6.ogg'), 40, TRUE)

				else
					to_chat(user, span_danger("[carbon_hit]'s mouth is covered!"))
					return

			else
				if(carbon_hit.is_bottomless())
					message = pick("fucks [carbon_hit]'s ass with [src]", "uses [src] to fuck [carbon_hit]'s anus", "jams [carbon_hit]'s ass with [src]", "roughly fucks [carbon_hit]'s ass with [src], causing their eyes to roll back")
					carbon_hit.adjust_arousal(5)
					carbon_hit.adjust_pleasure(5)
					if(prob(60))
						carbon_hit.try_lewd_autoemote(pick("twitch_s", "moan", "shiver"))
					user.visible_message(span_purple("[user] [message]!"))
					conditional_pref_sound(loc, pick('modular_lewd_items/sounds/bang1.ogg',
										'modular_lewd_items/sounds/bang2.ogg',
										'modular_lewd_items/sounds/bang3.ogg',
										'modular_lewd_items/sounds/bang4.ogg',
										'modular_lewd_items/sounds/bang5.ogg',
										'modular_lewd_items/sounds/bang6.ogg'), 100, TRUE)

				else
					to_chat(user, span_danger("[carbon_hit]'s anus is covered!"))
					return
	else
		to_chat(user, span_danger("[carbon_hit] doesn't want you to do that."))
		return
