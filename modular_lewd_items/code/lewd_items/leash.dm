/obj/item/clothing/erp_leash
	name = "leash"
	desc = "A guiding hand's best friend; in a sleek, semi-elastic package. Can either clip to a collar or be affixed to the neck on its own."
	icon = 'modular_lewd_items/icons/obj/lewd_clothing/lewd_belts.dmi'
	icon_override = 'modular_lewd_items/icons/mob/lewd_clothing/lewd_belts.dmi'
	icon_state = "neckleash_pink"
	worn_icon_state = "neckleash_pink"
	equip_slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	breakouttime = 3 SECONDS
	/// Weakref to the leash component we're using, if it exists.
	var/datum/weakref/our_leash_component
	/// Leash beam visual
	var/datum/beam/leash_line
	var/current_color = "pink"
	var/last_tug = 0

/obj/item/clothing/erp_leash/click_alt(mob/user)
	if(current_color == "pink")
		current_color = "teal"
	else
		current_color = "pink"
	icon_state = "neckleash_[current_color]"
	worn_icon_state = "neckleash_[current_color]"
	to_chat(user, span_notice("You switch the [src] color to [current_color]."))
	update_clothing_icon()
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/erp_leash/attack(mob/living/to_be_leashed, mob/living/user, params)
	var/datum/component/leash/erp/the_leash_component = our_leash_component?.resolve()
	if(the_leash_component)
		if(the_leash_component.parent == to_be_leashed)
			remove_leash(to_be_leashed)
			return
	else
		our_leash_component = null

	if(user == to_be_leashed)
		return
	if(!iscarbon(to_be_leashed) && !iscyborg(to_be_leashed))
		return
	if(!iscarbon(user) && !iscyborg(user))
		return

	if(!to_be_leashed.check_erp_prefs(/datum/preference/toggle/erp/sex_toy, user, src))
		to_chat(user, span_danger("[to_be_leashed] doesn't want you to do that."))
		return

	to_be_leashed.visible_message(
		span_warning("[user] raises the [src] to [to_be_leashed]'s neck!"),
		span_danger("[user] starts to bring the [src] to your neck!"),
		span_hear("You hear a light click as pressure builds in the air around your neck.")
	)
	if(!do_after(user, 2 SECONDS, to_be_leashed))
		return
	create_leash(user, to_be_leashed)

/obj/item/clothing/erp_leash/proc/create_leash(mob/user, mob/ouppy)
	if(!istype(ouppy))
		return

	ouppy.AddComponent(/datum/component/leash/erp, src, 2)
	if(our_leash_component?.resolve())
		to_chat(user, span_notice("You attach the leash to [ouppy]."))
		create_leash_line(ouppy)
		return
	else
		to_chat(user, span_danger("There's a leash attached to [ouppy] already."))

/obj/item/clothing/erp_leash/proc/remove_leash(mob/free_bird)
	to_chat(free_bird, span_notice("You are unhooked from the leash."))
	clear_line()
	var/datum/component/leash/erp/C = our_leash_component?.resolve()
	if(C)
		qdel(C)
	our_leash_component = null

/obj/item/clothing/erp_leash/proc/create_leash_line(atom/movable/target)
	var/mob/user = loc
	if(!istype(user))
		return
	clear_line()
	leash_line = user.beam(target, icon_state = "b_beam", maxdistance = 6)
	return leash_line

/obj/item/clothing/erp_leash/proc/clear_line()
	if(leash_line)
		QDEL_NULL(leash_line)

/obj/item/clothing/erp_leash/dropped(mob/user, silent)
	. = ..()
	clear_line()

/obj/item/clothing/erp_leash/Destroy()
	clear_line()
	var/datum/component/leash/erp/C = our_leash_component?.resolve()
	if(C)
		qdel(C)
	our_leash_component = null
	return ..()

/*
*	Leash Component
*/

/datum/component/leash/erp
	dupe_mode = COMPONENT_DUPE_UNIQUE

/datum/component/leash/erp/RegisterWithParent()
	. = ..()
	RegisterSignal(owner, COMSIG_ITEM_ATTACK_SELF, PROC_REF(on_item_attack_self))
	RegisterSignal(owner, COMSIG_ITEM_DROPPED, PROC_REF(on_item_dropped))
	RegisterSignal(owner, COMSIG_ITEM_EQUIPPED, PROC_REF(on_item_dropped))
	RegisterSignal(parent, COMSIG_LIVING_RESIST, PROC_REF(on_parent_resist))
	if(istype(owner, /obj/item/clothing/erp_leash))
		var/obj/item/clothing/erp_leash/our_leash = owner
		our_leash.our_leash_component = WEAKREF(src)

/datum/component/leash/erp/UnregisterFromParent()
	if(owner)
		UnregisterSignal(owner, list(COMSIG_ITEM_ATTACK_SELF, COMSIG_ITEM_DROPPED, COMSIG_ITEM_EQUIPPED))
		UnregisterSignal(parent, COMSIG_LIVING_RESIST)
	return ..()

/datum/component/leash/erp/Destroy()
	if(owner)
		UnregisterSignal(owner, list(COMSIG_ITEM_ATTACK_SELF, COMSIG_ITEM_DROPPED, COMSIG_ITEM_EQUIPPED))
	if(parent)
		UnregisterSignal(parent, COMSIG_LIVING_RESIST)
	if(istype(owner, /obj/item/clothing/erp_leash))
		var/obj/item/clothing/erp_leash/our_leash = owner
		our_leash.our_leash_component = null
	return ..()

/datum/component/leash/erp/proc/on_item_attack_self(datum/source, mob/user)
	SIGNAL_HANDLER

	if(istype(source, /obj/item/clothing/erp_leash))
		var/obj/item/clothing/erp_leash/leash_hookin = source
		if(world.time < leash_hookin.last_tug + 1 SECONDS)
			return
		if(istype(parent, /mob/living))
			var/mob/living/yoinked = parent
			yoinked.Move(get_step_towards(yoinked, user))
			yoinked.adjustStaminaLoss(10)
			yoinked.visible_message(
				span_warning("[yoinked] is pulled in as [user] tugs the [source]!"),
				span_danger("[user] suddenly tugs the [source], pulling you closer!"),
				span_danger("A sudden tug against your neck pulls you ahead!")
			)
			leash_hookin.last_tug = world.time

/datum/component/leash/erp/proc/on_item_dropped(datum/source, mob/user)
	SIGNAL_HANDLER
	if(istype(parent, /mob))
		to_chat(parent, span_notice("The leash comes unhooked."))
	qdel(src)

/datum/component/leash/erp/proc/on_parent_resist(datum/source, mob/user)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(do_resist))

/datum/component/leash/erp/proc/do_resist(datum/source, mob/user)
	if(istype(parent, /mob) && istype(owner, /obj/item))
		var/mob/our_parent = parent
		var/obj/item/our_owner = owner
		our_parent.visible_message(
			span_warning("[our_parent] attempts to unhook [our_parent.p_them()]self from the leash!"),
			span_danger("You start to unhook yourself from the leash..."),
			span_danger("You fumble in the dark, looking to unhook the leash...")
		)
		if(do_after(our_parent, our_owner.breakouttime, target = our_parent))
			to_chat(our_parent, span_notice("You unhook yourself from the leash."))
			qdel(src)
	else
		qdel(src)
