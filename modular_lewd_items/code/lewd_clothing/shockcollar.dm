/obj/item/electropack/shockcollar
	name = "shock collar"
	desc = "A reinforced metal collar. It has some sort of wiring near the front."
	icon = 'modular_lewd_items/icons/obj/lewd_clothing/lewd_neck.dmi'
	icon_override = 'modular_lewd_items/icons/mob/lewd_clothing/lewd_neck.dmi'
	icon_state = "shockcollar"
	worn_icon_state = "shockcollar"
	inhand_icon_state = null
	equip_slot_flags = ITEM_SLOT_MASK | ITEM_SLOT_ID
	w_class = WEIGHT_CLASS_SMALL
	strip_delay = 60
	var/random = TRUE
	var/freq_in_name = TRUE
	var/tagname = null

/obj/item/electropack/shockcollar/attack_hand(mob/user)
	if(loc == user && (user.wear_mask == src || user.wear_id == src))
		to_chat(user, span_warning("The collar is fastened tight! You'll need help if you want to take it off!"))
		return
	return ..()

/obj/item/electropack/shockcollar/receive_signal(datum/signal/signal)
	if(!signal || signal.data["code"] != code)
		return

	if(iscarbon(loc))
		var/mob/living/carbon/affected_mob = loc
		if(affected_mob.wear_mask != src && (!ishuman(affected_mob) || affected_mob:wear_id != src))
			return
		if(shock_cooldown)
			return
		shock_cooldown = TRUE
		addtimer(VARSET_CALLBACK(src, shock_cooldown, FALSE), 10 SECONDS)
		step(affected_mob, pick(GLOB.cardinals))

		to_chat(affected_mob, span_danger("You feel a sharp shock from the collar!"))
		do_sparks(3, TRUE, affected_mob)

		affected_mob.Paralyze(3 SECONDS)
		affected_mob.adjust_pain(10)
		affected_mob.adjust_stutter(30 SECONDS)

	if(master)
		if(isassembly(master))
			var/obj/item/assembly/master_as_assembly = master
			master_as_assembly.pulsed()
		master.receive_signal()

/obj/item/electropack/shockcollar/attackby(obj/item/used_item, mob/user, params)
	if(istype(used_item, /obj/item/tool/pen))
		var/tag_input = stripped_input(user, "Would you like to change the name on the tag?", "Name your new pet", tagname ? tagname : "Spot", MAX_NAME_LEN)
		if(tag_input)
			tagname = tag_input
			name = "[initial(name)] - [tag_input]"
		return
	return ..()

/obj/item/electropack/shockcollar/Initialize(mapload)
	if(random)
		code = rand(1, 100)
		frequency = rand(MIN_FREE_FREQ, MAX_FREE_FREQ)
		if(ISMULTIPLE(frequency, 2))
			frequency++
	if(freq_in_name)
		name = initial(name) + " - freq: [frequency/10] code: [code]"
	. = ..()
