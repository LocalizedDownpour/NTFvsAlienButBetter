/*
*	Ported from Rimstation: code/datums/elements/update_icon_updates_onmob.dm
*
*	This fork has neither /mob/proc/update_clothing() nor /mob/proc/update_held_items(),
*	so the refresh goes through the fork's per-slot update_inv_*() procs, falling back to
*	regenerate_icons() for slots without a dedicated updater (e.g. the lewd slots).
*/

/datum/element/update_icon_updates_onmob
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	/// Extra ITEM_SLOT_X flags to refresh on the wearer, in addition to the item's own equip_slot_flags.
	var/update_flags = NONE
	/// Should the wearer's body be refreshed as well?
	var/update_body = FALSE

/datum/element/update_icon_updates_onmob/Attach(datum/target, flags, body = FALSE)
	. = ..()
	if(!istype(target, /obj/item))
		return ELEMENT_INCOMPATIBLE
	update_flags = isnull(flags) ? NONE : flags
	update_body = body
	RegisterSignal(target, COMSIG_ATOM_UPDATED_ICON, PROC_REF(update_onmob))

/datum/element/update_icon_updates_onmob/proc/update_onmob(obj/item/target)
	SIGNAL_HANDLER

	var/mob/wearer = target.loc
	if(!ismob(wearer))
		return

	if(wearer.is_holding(target))
		wearer.update_inv_l_hand()
		wearer.update_inv_r_hand()
		return

	var/slots = target.equip_slot_flags | update_flags
	var/updated = FALSE

	if(slots & ITEM_SLOT_ICLOTHING)
		wearer.update_inv_w_uniform()
		updated = TRUE
	if(slots & ITEM_SLOT_OCLOTHING)
		wearer.update_inv_wear_suit()
		updated = TRUE
	if(slots & ITEM_SLOT_GLOVES)
		wearer.update_inv_gloves()
		updated = TRUE
	if(slots & ITEM_SLOT_EYES)
		wearer.update_inv_glasses()
		updated = TRUE
	if(slots & ITEM_SLOT_EARS)
		wearer.update_inv_ears()
		updated = TRUE
	if(slots & ITEM_SLOT_MASK)
		wearer.update_inv_wear_mask()
		updated = TRUE
	if(slots & ITEM_SLOT_HEAD)
		wearer.update_inv_head()
		updated = TRUE
	if(slots & ITEM_SLOT_FEET)
		wearer.update_inv_shoes()
		updated = TRUE
	if(slots & ITEM_SLOT_BELT)
		wearer.update_inv_belt()
		updated = TRUE
	if(slots & ITEM_SLOT_BACK)
		wearer.update_inv_back()
		updated = TRUE
	if(slots & ITEM_SLOT_ID)
		wearer.update_inv_wear_id()
		updated = TRUE
	if(slots & ITEM_SLOT_SUITSTORE)
		wearer.update_inv_s_store()
		updated = TRUE
	if(slots & ITEM_SLOT_HANDCUFF)
		wearer.update_inv_handcuffed()
		updated = TRUE
	if(slots & ITEM_SLOT_UNDERWEAR)
		wearer.update_inv_underwear()
		updated = TRUE
	if(slots & ITEM_SLOT_SOCKS)
		wearer.update_inv_socks()
		updated = TRUE
	if(slots & ITEM_SLOT_SHIRT)
		wearer.update_inv_undershirt()
		updated = TRUE
	if(slots & ITEM_SLOT_BRA)
		wearer.update_inv_bra()
		updated = TRUE
	if(slots & (ITEM_SLOT_L_HAND|ITEM_SLOT_R_HAND))
		wearer.update_inv_l_hand()
		wearer.update_inv_r_hand()
		updated = TRUE

	if(!updated)
		// Unknown or lewd-only slot: make sure the wearer's overlays are still consistent.
		wearer.regenerate_icons()

	if(update_body && ishuman(wearer))
		var/mob/living/carbon/human/human_wearer = wearer
		human_wearer.update_body()
