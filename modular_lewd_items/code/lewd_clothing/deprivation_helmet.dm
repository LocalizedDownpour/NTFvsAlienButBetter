/obj/item/clothing/head/deprivation_helmet
	name = "deprivation helmet"
	desc = "Completely cuts off the wearer from the outside world."
	icon_state = "dephelmet_pink"
	base_icon_state = "dephelmet"
	inhand_icon_state = "dephelmet_pinkn"
	icon = 'modular_lewd_items/icons/obj/lewd_clothing/lewd_hats.dmi'
	icon_override = 'modular_lewd_items/icons/mob/lewd_clothing/lewd_hats.dmi'
	worn_icon_state = "dephelmet_pink"
	lefthand_file = 'modular_lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	inv_hide_flags = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDESNOUT|HIDEFACIALHAIR
	armor_protection_flags = HEAD|FACE|EYES
	equip_slot_flags = ITEM_SLOT_HEAD
	var/color_changed = FALSE
	var/muzzle = FALSE
	var/earmuffs = FALSE
	var/prevent_vision = FALSE
	var/current_helmet_color = "pink"
	var/static/list/helmet_designs
	actions_types = list(
		/datum/action/item_action/toggle_vision,
		/datum/action/item_action/toggle_hearing,
		/datum/action/item_action/toggle_speech,
	)

/datum/action/item_action/toggle_vision
	name = "Vision switch"
	desc = "Makes it impossible to see anything"

/datum/action/item_action/toggle_vision/action_activate()
	var/obj/item/clothing/head/deprivation_helmet/helmet = target
	var/mob/living/carbon/affected_carbon = usr
	if(istype(helmet))
		if(helmet == affected_carbon.head)
			to_chat(usr, span_notice("You can't reach the deprivation helmet switch!"))
		else
			helmet.SwitchHelmet("vision")
	return TRUE

/datum/action/item_action/toggle_hearing
	name = "Hearing switch"
	desc = "Makes it impossible to hear anything"

/datum/action/item_action/toggle_hearing/action_activate()
	var/obj/item/clothing/head/deprivation_helmet/helmet = target
	var/mob/living/carbon/affected_carbon = usr
	if(istype(helmet))
		if(helmet == affected_carbon.head)
			to_chat(usr, span_notice("You can't reach the deprivation helmet switch!"))
		else
			helmet.SwitchHelmet("hearing")
	return TRUE

/datum/action/item_action/toggle_speech
	name = "Speech switch"
	desc = "Makes it impossible to say anything"

/datum/action/item_action/toggle_speech/action_activate()
	var/obj/item/clothing/head/deprivation_helmet/helmet = target
	var/mob/living/carbon/affected_carbon = usr
	if(istype(helmet))
		if(helmet == affected_carbon.head)
			to_chat(usr, span_notice("You can't reach the deprivation helmet switch!"))
		else
			helmet.SwitchHelmet("speech")
	return TRUE

/obj/item/clothing/head/deprivation_helmet/proc/SwitchHelmet(button)
	if(button == "speech")
		muzzle = !muzzle
		playsound(usr, muzzle ? 'sound/weapons/armbomb.ogg' : 'sound/weapons/guns/fire/empty.ogg', 40, TRUE)
		to_chat(usr, span_notice("Speech switch [muzzle ? "on" : "off"]."))
		var/mob/living/carbon/human/H = loc
		if(istype(H) && H.head == src)
			if(muzzle)
				ADD_TRAIT(H, TRAIT_MUTE, CLOTHING_TRAIT)
				to_chat(H, span_purple("Something is gagging your mouth! You can barely make a sound..."))
			else
				REMOVE_TRAIT(H, TRAIT_MUTE, CLOTHING_TRAIT)
				to_chat(H, span_purple("Your mouth is free. You breathe out with relief."))

	if(button == "hearing")
		earmuffs = !earmuffs
		playsound(usr, earmuffs ? 'sound/weapons/armbomb.ogg' : 'sound/weapons/guns/fire/empty.ogg', 40, TRUE)
		to_chat(usr, span_notice("Hearing switch [earmuffs ? "on" : "off"]."))
		var/mob/living/carbon/human/H = loc
		if(istype(H) && H.head == src)
			if(earmuffs)
				ADD_TRAIT(H, TRAIT_DEAF, CLOTHING_TRAIT)
				to_chat(H, span_purple("You can barely hear anything!"))
			else
				REMOVE_TRAIT(H, TRAIT_DEAF, CLOTHING_TRAIT)
				to_chat(H, span_purple("Finally you can hear the world around again."))

	if(button == "vision")
		prevent_vision = !prevent_vision
		playsound(usr, prevent_vision ? 'sound/weapons/armbomb.ogg' : 'sound/weapons/guns/fire/empty.ogg', 40, TRUE)
		to_chat(usr, span_notice("Vision switch [prevent_vision ? "on" : "off"]."))
		if(prevent_vision)
			AddComponent(/datum/component/clothing_tint, TINT_BLIND, TRUE, ITEM_SLOT_HEAD)
		else
			remove_component(/datum/component/clothing_tint)
		var/mob/living/carbon/human/H = loc
		if(istype(H) && H.head == src)
			to_chat(H, span_purple(prevent_vision ? "The helmet is blocking your vision!" : "Helmet no longer restricts your vision."))

/obj/item/clothing/head/deprivation_helmet/proc/populate_helmet_designs()
	helmet_designs = list(
		"pink" = image(icon = src.icon, icon_state = "dephelmet_pink"),
		"teal" = image(icon = src.icon, icon_state = "dephelmet_teal"),
		"pinkn" = image(icon = src.icon, icon_state = "dephelmet_pinkn"),
		"tealn" = image(icon = src.icon, icon_state = "dephelmet_tealn"))

/obj/item/clothing/head/deprivation_helmet/click_alt(mob/user)
	if(!color_changed)
		var/choice = show_radial_menu(user, src, helmet_designs, radius = 36, require_near = TRUE)
		if(!choice)
			return CLICK_ACTION_BLOCKING
		current_helmet_color = choice
		color_changed = TRUE
		update_icon_state()
		update_clothing_icon()
		return CLICK_ACTION_SUCCESS
	return CLICK_ACTION_BLOCKING

/obj/item/clothing/head/deprivation_helmet/Initialize(mapload)
	. = ..()
	if(!length(helmet_designs))
		populate_helmet_designs()
	update_icon_state()

/obj/item/clothing/head/deprivation_helmet/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]_[current_helmet_color]"
	worn_icon_state = "[base_icon_state]_[current_helmet_color]"
	inhand_icon_state = "[base_icon_state]_[current_helmet_color]"

/obj/item/clothing/head/deprivation_helmet/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!(slot & ITEM_SLOT_HEAD))
		return
	if(muzzle)
		ADD_TRAIT(user, TRAIT_MUTE, CLOTHING_TRAIT)
		to_chat(user, span_purple("Something is gagging your mouth! You can barely make a sound..."))
	if(earmuffs)
		ADD_TRAIT(user, TRAIT_DEAF, CLOTHING_TRAIT)
		to_chat(user, span_purple("You can barely hear anything!"))
	if(prevent_vision)
		to_chat(user, span_purple("The helmet is blocking your vision!"))

/obj/item/clothing/head/deprivation_helmet/dropped(mob/living/carbon/human/user)
	. = ..()
	if(muzzle)
		REMOVE_TRAIT(user, TRAIT_MUTE, CLOTHING_TRAIT)
	if(earmuffs)
		REMOVE_TRAIT(user, TRAIT_DEAF, CLOTHING_TRAIT)
