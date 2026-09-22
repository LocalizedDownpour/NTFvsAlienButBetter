/obj/item/clothing/sextoy
	name = "sextoy"
	icon = 'modular_lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	worn_icon = 'modular_lewd_items/icons/mob/lewd_items/lewd_items.dmi'
	/// This is used to decide what lewd slot a toy should be able to be inserted into.
	var/lewd_slot_flags = NONE
	/// This is to keep track of where we are stored, because sometimes we might want to know that
	var/current_equipped_slot

/obj/item/clothing/sextoy/proc/lewd_equipped(mob/living/carbon/user, slot, initial)
	SHOULD_CALL_PARENT(TRUE)

	current_equipped_slot = slot

	for(var/datum/action/action as anything in actions)
		action.give_action(user)

/obj/item/clothing/sextoy/proc/lewd_unequipped(mob/living/carbon/user)
	for(var/datum/action/action as anything in actions)
		action.remove_action(user)
	current_equipped_slot = null

/obj/item/clothing/sextoy/dropped(mob/user)
	..()
	update_appearance()
	if(!iscarbon(loc))
		if(current_equipped_slot && iscarbon(user))
			var/mob/living/carbon/C = user
			if(C.vars[current_equipped_slot] == src)
				C.vars[current_equipped_slot] = null
		current_equipped_slot = null
		return
	var/mob/living/carbon/holder = loc
	holder.update_inv_lewd()
	holder.fan_hud_set_fandom()

/obj/item/clothing/sextoy/moveToNullspace()
	if(iscarbon(loc) && current_equipped_slot)
		var/mob/living/carbon/current_holder = loc
		current_holder.vars[current_equipped_slot] = null
		current_equipped_slot = null
	return ..()

/// A check to confirm if you can open the toy's color/design radial menu
/obj/item/clothing/sextoy/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	return TRUE

/// Returns if the item is inside a lewd slot.
/obj/item/clothing/sextoy/proc/is_inside_lewd_slot(mob/living/carbon/target)
	if(!iscarbon(target))
		return FALSE
	return (src == target.lewd_penis || src == target.lewd_vagina || src == target.lewd_anus || src == target.lewd_nipples)
