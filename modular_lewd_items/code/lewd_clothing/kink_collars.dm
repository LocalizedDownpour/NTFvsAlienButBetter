/*
*	NORMAL COLLAR
*/

/datum/storage/kink_collar
	max_w_class = WEIGHT_CLASS_SMALL
	storage_slots = 1

/datum/storage/kink_collar/locked
	max_w_class = WEIGHT_CLASS_SMALL
	storage_slots = 1

/datum/storage/kink_collar/mind_collar
	max_w_class = WEIGHT_CLASS_SMALL
	storage_slots = 1

/obj/item/clothing/neck
	name = "neck accessory"
	icon = 'modular_lewd_items/icons/obj/lewd_clothing/lewd_neck.dmi'
	icon_override = 'modular_lewd_items/icons/mob/lewd_clothing/lewd_neck.dmi'
	equip_slot_flags = ITEM_SLOT_MASK | ITEM_SLOT_ID
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/neck/kink_collar
	name = "collar"
	desc = "A nice, tight collar. It fits snug to your skin."
	icon = 'modular_lewd_items/icons/obj/lewd_clothing/lewd_neck.dmi'
	icon_override = 'modular_lewd_items/icons/mob/lewd_clothing/lewd_neck.dmi'
	icon_state = "collar_cyan"
	worn_icon_state = "collar_cyan"
	equip_slot_flags = ITEM_SLOT_MASK | ITEM_SLOT_ID
	w_class = WEIGHT_CLASS_SMALL
	var/kink_collar = TRUE
	/// What the name on the tag is
	var/tagname = null
	/// Item path of on-init creation in the collar's storage
	var/treat_path = /obj/item/reagent_containers/food/snacks/cookie
	var/current_color = "cyan"
	var/static/list/collar_colors

/obj/item/clothing/neck/kink_collar/Initialize(mapload)
	. = ..()
	create_storage(storage_type = /datum/storage/kink_collar, canhold = list(/obj/item/reagent_containers/food/snacks/cookie))
	if(treat_path)
		var/obj/item/new_treat = new treat_path(src)
		if(istype(new_treat, /obj/item/key/kink_collar))
			var/obj/item/key/kink_collar/collar_key = new_treat
			collar_key.key_id = REF(src)

/obj/item/clothing/neck/kink_collar/proc/populate_collar_colors()
	collar_colors = list(
		"cyan" = image(icon = src.icon, icon_state = "collar_cyan"),
		"yellow" = image(icon = src.icon, icon_state = "collar_yellow"),
		"green" = image(icon = src.icon, icon_state = "collar_green"),
		"red" = image(icon = src.icon, icon_state = "collar_red"),
		"latex" = image(icon = src.icon, icon_state = "collar_latex"),
		"orange" = image(icon = src.icon, icon_state = "collar_orange"),
		"white" = image(icon = src.icon, icon_state = "collar_white"),
		"purple" = image(icon = src.icon, icon_state = "collar_purple"),
		"black" = image(icon = src.icon, icon_state = "collar_black"),
		"spike" = image(icon = src.icon, icon_state = "collar_spike"),
	)

/obj/item/clothing/neck/kink_collar/click_alt(mob/user)
	if(!length(collar_colors))
		populate_collar_colors()
	var/choice = show_radial_menu(user, src, collar_colors, radius = 36, require_near = TRUE)
	if(!choice)
		return CLICK_ACTION_BLOCKING
	current_color = choice
	icon_state = "collar_[current_color]"
	worn_icon_state = "collar_[current_color]"
	update_clothing_icon()
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/neck/kink_collar/attack_self(mob/user)
	var/input = stripped_input(user, "Would you like to change the name on the tag?", "Name your new pet", tagname ? tagname : "Spot", MAX_NAME_LEN)
	if(input)
		tagname = input
		name = "[initial(name)] - [tagname]"

/*
*	LOCKED COLLAR
*/

/obj/item/clothing/neck/kink_collar/locked
	name = "locked collar"
	desc = "A tight collar. It appears to have some kind of lock."
	icon_state = "lock_collar_cyan"
	worn_icon_state = "lock_collar_cyan"
	treat_path = /obj/item/key/kink_collar
	var/locked = FALSE
	var/broken = FALSE

/obj/item/clothing/neck/kink_collar/locked/Initialize(mapload)
	. = ..()
	create_storage(storage_type = /datum/storage/kink_collar/locked, canhold = list(/obj/item/reagent_containers/food/snacks/cookie, /obj/item/key/kink_collar))

/obj/item/clothing/neck/kink_collar/locked/proc/IsLocked(to_lock, mob/user)
	if(!broken)
		to_chat(user, span_warning("[to_lock ? "The collar locks with a resounding click!" : "The collar unlocks with a small clunk."]"))
		locked = (to_lock ? TRUE : FALSE)
		if(!to_lock)
			REMOVE_TRAIT(src, TRAIT_NODROP, TRAIT_NODROP)
		return
	to_chat(user, span_warning("It looks like the lock is broken - now it's just an ordinary old collar."))
	locked = FALSE
	REMOVE_TRAIT(src, TRAIT_NODROP, TRAIT_NODROP)

/obj/item/clothing/neck/kink_collar/locked/attackby(obj/item/attack_item, mob/user, params)
	if(istype(attack_item, /obj/item/key/kink_collar))
		var/obj/item/key/kink_collar/collar_key = attack_item
		if(collar_key.key_id == REF(src))
			IsLocked(!locked, user)
		else
			to_chat(user, span_warning("This isn't the correct key!"))
		return
	if(istype(attack_item, /obj/item/tool/surgery/circular_saw) || istype(attack_item, /obj/item/tool/wirecutters))
		if(broken)
			to_chat(user, span_warning("The lock is already broken!"))
			return
		to_chat(user, span_warning("You try to cut the lock right off!"))
		if(!do_after(user, 3 SECONDS, src))
			return
		broken = TRUE
		IsLocked(FALSE, user)
		to_chat(user, span_notice("You cut away the lock!"))
		return
	return ..()

/obj/item/clothing/neck/kink_collar/locked/equipped(mob/living/carbon/user, slot)
	. = ..()
	if(locked && (slot in list(ITEM_SLOT_MASK, ITEM_SLOT_ID)))
		ADD_TRAIT(src, TRAIT_NODROP, TRAIT_NODROP)
		to_chat(user, span_warning("You hear a suspicious click around your neck - it seems the collar is now locked!"))

/obj/item/clothing/neck/kink_collar/locked/attack_hand(mob/user)
	if(loc == user && (user.wear_mask == src || (ishuman(user) && user:wear_id == src)) && locked)
		to_chat(user, span_warning("The collar is locked! You'll need to unlock it before you can take it off!"))
		return
	return ..()

/*
*	KEY
*/

/obj/item/key/kink_collar
	name = "kink collar key"
	desc = "A key for a tiny lock on a collar or bag."
	icon = 'modular_lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	icon_state = "collar_key_metal"
	base_icon_state = "collar_key"
	w_class = WEIGHT_CLASS_TINY
	var/keyname = null
	var/key_id = null

/obj/item/key/kink_collar/attack_self(mob/user)
	var/input = stripped_input(user, "Would you like to change the name on the key?", "Renaming key", keyname ? keyname : "Key", MAX_NAME_LEN)
	if(input)
		keyname = input
		name = "[initial(name)] - [keyname]"

/obj/item/key/kink_collar/attack(mob/living/target, mob/living/user, params)
	if(!iscarbon(target))
		return ..()
	var/mob/living/carbon/carbon_target = target
	var/obj/item/clothing/neck/kink_collar/locked/collar
	if(istype(carbon_target.wear_mask, /obj/item/clothing/neck/kink_collar/locked))
		collar = carbon_target.wear_mask
	else if(ishuman(carbon_target) && istype(carbon_target:wear_id, /obj/item/clothing/neck/kink_collar/locked))
		collar = carbon_target:wear_id
	if(collar)
		if(REF(collar) == key_id)
			collar.IsLocked(!collar.locked, user)
		else
			to_chat(user, span_warning("This isn't the correct key!"))
		return
	return ..()

/*
*	MIND CONTROL COLLAR
*/

/obj/item/mind_controller
	name = "mind controller"
	desc = "A small remote for sending basic emotion patterns to a collar."
	icon = 'modular_lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	lefthand_file = 'modular_lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	icon_state = "mindcontroller"
	w_class = WEIGHT_CLASS_SMALL
	var/obj/item/clothing/neck/mind_collar/collar = null

/obj/item/mind_controller/Initialize(mapload, collar_init)
	. = ..()
	collar = collar_init

/obj/item/mind_controller/Destroy()
	collar?.remote = null
	collar = null
	return ..()

/obj/item/mind_controller/attack_self(mob/user)
	if(!collar)
		return
	var/choice = tgui_input_text(user, "Change the emotion pattern.", max_length = MAX_MESSAGE_LEN)
	if(choice)
		collar.emoting = choice
		collar.emoting_proc()

/obj/item/clothing/neck/mind_collar
	name = "mind collar"
	desc = "A tight collar. It has some strange high-tech emitters on the side."
	icon = 'modular_lewd_items/icons/obj/lewd_clothing/lewd_neck.dmi'
	icon_override = 'modular_lewd_items/icons/mob/lewd_clothing/lewd_neck.dmi'
	icon_state = "mindcollar"
	worn_icon_state = "mindcollar"
	inhand_icon_state = null
	equip_slot_flags = ITEM_SLOT_MASK | ITEM_SLOT_ID
	w_class = WEIGHT_CLASS_SMALL
	var/kink_collar = TRUE
	var/obj/item/mind_controller/remote
	var/emoting = "shivers."

/obj/item/clothing/neck/mind_collar/Initialize(mapload)
	. = ..()
	create_storage(storage_type = /datum/storage/kink_collar/mind_collar, canhold = list(/obj/item/mind_controller))
	remote = new /obj/item/mind_controller(src, src)
	remote.forceMove(src)

/obj/item/clothing/neck/mind_collar/proc/emoting_proc()
	var/mob/living/carbon/user = loc
	if(iscarbon(user) && (user.wear_mask == src || (ishuman(user) && user:wear_id == src)))
		user.emote("me", 1, "[emoting]", TRUE)

/obj/item/clothing/neck/mind_collar/Destroy()
	remote?.collar = null
	remote = null
	return ..()
