/mob/living/carbon
	var/arousal = 0
	var/pleasure = 0
	var/pain = 0

	var/obj/item/lewd_vagina = null
	var/obj/item/lewd_anus = null
	var/obj/item/lewd_nipples = null
	var/obj/item/lewd_penis = null

/mob/living/carbon/proc/adjust_pain(amount)
	pain = max(0, pain + amount)

/mob/living/carbon/proc/adjust_arousal(amount)
	arousal = max(0, arousal + amount)
	if(sexcon)
		sexcon.adjust_arousal(amount)

/mob/living/carbon/proc/adjust_pleasure(amount)
	pleasure = max(0, pleasure + amount)
	if(sexcon)
		sexcon.adjust_arousal(amount)

/mob/living/carbon/proc/adjust_stutter(duration)
	set_timed_status_effect(duration, /datum/status_effect/speech/stutter, only_if_higher = TRUE)

/mob/living/carbon/proc/is_topless()
	return TRUE

/mob/living/carbon/proc/is_bottomless()
	return TRUE

/mob/living/carbon/proc/is_barefoot()
	return TRUE

/mob/living/carbon/proc/is_hands_uncovered()
	return TRUE

/mob/living/carbon/proc/is_head_uncovered()
	return TRUE

/mob/living/carbon/proc/is_mouth_covered()
	return (wear_mask != null)

/mob/living/carbon/human/is_topless()
	if(sexcon_part_exposed("boobs"))
		return TRUE
	return (!wear_suit || !(wear_suit.armor_protection_flags & CHEST)) && (!w_uniform || !(w_uniform.armor_protection_flags & CHEST))

/mob/living/carbon/human/is_bottomless()
	if(sexcon_part_exposed("cock") || sexcon_part_exposed("vagina"))
		return TRUE
	return (!wear_suit || !(wear_suit.armor_protection_flags & GROIN)) && (!w_uniform || !(w_uniform.armor_protection_flags & GROIN))

/mob/living/carbon/human/is_barefoot()
	return (!shoes)

/mob/living/carbon/human/is_hands_uncovered()
	return (!gloves)

/mob/living/carbon/human/is_head_uncovered()
	return (!head)

/mob/living/carbon/human/is_mouth_covered()
	return (wear_mask && (wear_mask.inventory_flags & COVERMOUTH)) || (head && (head.inventory_flags & COVERMOUTH))

/mob/living/carbon/proc/update_inv_vagina()
	return

/mob/living/carbon/proc/update_inv_anus()
	return

/mob/living/carbon/proc/update_inv_nipples()
	return

/mob/living/carbon/proc/update_inv_penis()
	return

/mob/living/carbon/proc/update_inv_lewd()
	return

// Xenomorphs across all castes do not render worn human clothing or toy overlays
/mob/living/carbon/xenomorph/update_inv_vagina()
	return

/mob/living/carbon/xenomorph/update_inv_anus()
	return

/mob/living/carbon/xenomorph/update_inv_nipples()
	return

/mob/living/carbon/xenomorph/update_inv_penis()
	return

/mob/living/carbon/xenomorph/update_inv_lewd()
	return

/mob/living/carbon/proc/fan_hud_set_fandom()
	return

/mob/living/carbon/proc/try_lewd_autoemote(emote_name)
	if(stat == DEAD)
		return
	if(isxeno(src))
		switch(emote_name)
			if("moan")
				play_sexcon_moan(heavy = FALSE)
			if("gasp", "choke")
				emote("hiss")
			if("scream")
				emote(prob(50) ? "roar" : "hiss")
			if("shiver", "twitch", "twitch_s")
				do_jitter_animation()
				emote("tail")
			else
				emote(emote_name)
		return

	switch(emote_name)
		if("moan")
			play_sexcon_moan(heavy = FALSE)
		if("gasp")
			emote("gasp")
		if("choke")
			emote("choke")
		if("exhale", "inhale")
			visible_message(span_purple("[src] [emote_name]s deeply."))
		if("scream")
			emote("scream")
		if("shiver")
			emote("shiver")
		if("twitch", "twitch_s")
			emote("twitch")
		else
			emote(emote_name)

/mob/living/carbon/proc/is_wearing_condom()
	if(!lewd_penis || !istype(lewd_penis, /obj/item/clothing/sextoy/condom))
		return FALSE
	var/obj/item/clothing/sextoy/condom/condom = lewd_penis
	return condom.condom_state != "broken"

/mob/living/carbon/proc/equip_lewd_item(obj/item/clothing/sextoy/toy, slot, mob/user)
	if(!istype(toy) || !(slot in list("lewd_vagina", "lewd_anus", "lewd_nipples", "lewd_penis")))
		return FALSE
	if(vars[slot])
		return FALSE
	if(user && (toy in user.get_held_items()))
		user.drop_inv_item_to_loc(toy, src)
	else
		toy.forceMove(src)
	vars[slot] = toy
	toy.lewd_equipped(src, slot)
	return TRUE

/mob/living/carbon/proc/unequip_lewd_item(slot, mob/user)
	if(!(slot in list("lewd_vagina", "lewd_anus", "lewd_nipples", "lewd_penis")))
		return FALSE
	var/obj/item/clothing/sextoy/toy = vars[slot]
	if(!toy)
		return FALSE
	vars[slot] = null
	toy.lewd_unequipped(src)
	if(user && isliving(user))
		var/mob/living/L = user
		if(!L.put_in_hands(toy))
			toy.forceMove(get_turf(src))
	else
		toy.forceMove(get_turf(src))
	return TRUE

/mob/living/carbon/verb/remove_lewd_item_verb()
	set name = "Remove Lewd Item"
	set category = "IC"
	set desc = "Remove an equipped sex toy or restraint from your body."
	set src = usr

	var/list/available = list()
	if(lewd_penis)
		available["Penis ([lewd_penis.name])"] = "lewd_penis"
	if(lewd_vagina)
		available["Vagina ([lewd_vagina.name])"] = "lewd_vagina"
	if(lewd_anus)
		available["Anus ([lewd_anus.name])"] = "lewd_anus"
	if(lewd_nipples)
		available["Nipples ([lewd_nipples.name])"] = "lewd_nipples"

	if(!length(available))
		to_chat(src, span_notice("You don't have any sex toys equipped."))
		return

	var/choice
	if(length(available) == 1)
		choice = available[available[1]]
	else
		var/chosen_label = tgui_input_list(src, "Which item do you want to remove?", "Remove Toy", available)
		if(!chosen_label)
			return
		choice = available[chosen_label]

	var/obj/item/clothing/sextoy/toy = vars[choice]
	if(!toy)
		return

	if(unequip_lewd_item(choice, src))
		visible_message(span_purple("[src] removes [toy] from their body."), span_purple("You remove [toy] from your body."))

/mob/living/carbon/verb/remove_target_lewd_item()
	set name = "Remove Target's Lewd Item"
	set category = "IC"
	set desc = "Remove a sex toy from another person."
	set src in view(1)

	if(usr == src)
		usr.remove_lewd_item_verb()
		return

	if(!Adjacent(usr))
		to_chat(usr, span_warning("You are too far away!"))
		return

	if(!iscarbon(usr))
		return

	if(stat == CONSCIOUS && !check_erp_prefs(/datum/preference/toggle/erp/sex_toy, usr))
		to_chat(usr, span_danger("[src] does not want you to do that."))
		return

	var/list/available = list()
	if(lewd_penis)
		available["Penis ([lewd_penis.name])"] = "lewd_penis"
	if(lewd_vagina)
		available["Vagina ([lewd_vagina.name])"] = "lewd_vagina"
	if(lewd_anus)
		available["Anus ([lewd_anus.name])"] = "lewd_anus"
	if(lewd_nipples)
		available["Nipples ([lewd_nipples.name])"] = "lewd_nipples"

	if(!length(available))
		to_chat(usr, span_notice("[src] doesn't have any sex toys equipped."))
		return

	var/chosen_label = tgui_input_list(usr, "Which item do you want to remove from [src]?", "Remove Toy", available)
	if(!chosen_label)
		return
	var/choice = available[chosen_label]
	var/obj/item/clothing/sextoy/toy = vars[choice]
	if(!toy)
		return

	to_chat(usr, span_notice("You start removing [toy] from [src]..."))
	if(!do_after(usr, 2 SECONDS, target = src))
		return

	if(unequip_lewd_item(choice, usr))
		visible_message(span_purple("[usr] removes [toy] from [src]'s body."), span_purple("[usr] removes [toy] from your body."))
