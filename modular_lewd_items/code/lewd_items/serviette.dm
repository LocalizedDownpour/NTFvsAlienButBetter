/obj/item/serviette
	name = "serviette"
	desc = "To clean all the mess."
	icon_state = "serviette_clean"
	icon = 'modular_lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	/// How much time it takes to clean something using it
	var/cleanspeed = 1.5 SECONDS
	/// Which item spawns after it's used
	var/used_serviette = /obj/item/serviette_used
	w_class = WEIGHT_CLASS_TINY
	item_flags = NOBLUDGEON

/obj/item/serviette_used
	name = "dirty serviette"
	desc = "Eww... Throw it in the trash!"
	icon_state = "serviette_dirty"
	icon = 'modular_lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	w_class = WEIGHT_CLASS_TINY

/obj/item/serviette/afterattack(atom/target, mob/user, proximity)
	if(!proximity || !user)
		return
	if(user.client && (target in user.client.screen))
		balloon_alert(user, "take that off first!")
		return

	if(istype(target, /obj/effect/decal/cleanable) || isturf(target))
		user.visible_message(span_notice("[user] begins to wipe \the [target.name] with [src]."), span_notice("You begin to wipe \the [target.name] with [src]..."))
		if(!do_after(user, cleanspeed, target = target))
			return
		if(istype(target, /obj/effect/decal/cleanable))
			qdel(target)
		else if(isturf(target))
			var/turf/target_turf = target
			target_turf.wash()
		user.balloon_alert(user, "cleaned")
		var/obj/item/serviette_used/used_cloth = new used_serviette(get_turf(user))
		qdel(src)
		user.put_in_hands(used_cloth)
		return

	user.visible_message(span_notice("[user] begins to wipe \the [target.name] with [src]."), span_notice("You begin to wipe \the [target.name] with [src]..."))
	if(!do_after(user, cleanspeed, target = target))
		return
	target.wash()
	user.balloon_alert(user, "cleaned")
	var/obj/item/serviette_used/used_cloth = new used_serviette(get_turf(user))
	qdel(src)
	user.put_in_hands(used_cloth)

/*
*	SERVIETTE PACK
*/

/obj/item/serviette_pack
	name = "pack of serviettes"
	desc = "I wonder why LustWish makes them..."
	icon_state = "serviettepack_4"
	base_icon_state = "serviettepack"
	icon = 'modular_lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	/// A count of how many serviettes are left in the pack
	var/number_remaining = 4
	w_class = WEIGHT_CLASS_SMALL

/obj/item/serviette_pack/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]_[number_remaining]"

/obj/item/serviette_pack/Initialize(mapload)
	. = ..()
	update_icon_state()
	update_icon()

/obj/item/serviette_pack/attack_self(mob/user)
	if(number_remaining)
		to_chat(user, span_notice("You take a serviette from [src]."))
		number_remaining--
		var/obj/item/serviette/used_serviette = new /obj/item/serviette(get_turf(user))
		user.put_in_hands(used_serviette)
		update_icon()
		update_icon_state()
	else
		to_chat(user, span_notice("There are no serviettes left!"))
