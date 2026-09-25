/*
*	Ported from Rimstation: modular_zubbers/code/modules/lewd_machinery/clicker.dm
*
*	Adapted: this fork has no modular_zubbers module, no /datum/component/reskinable_item,
*	no /datum/atom_skin and no quirk system, so the color swap is a plain alt-click toggle
*	instead of a reskin component.
*/

/obj/item/clicker
	name = "clicker"
	desc = "A small clicking toy that fits in the palm of your hand, typically used to condition pets into obedience. It makes a satisfying 'click' sound when pressed."
	icon = 'modular_lewd_items/icons/obj/lewd_clicker.dmi'
	icon_state = "clicker_pink"
	inhand_icon_state = "clicker_pink"
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	/// Current color of the clicker, can be toggled with alt-click
	var/current_color = "pink"

/obj/item/clicker/proc/click(atom/source, mob/user)
	source.balloon_alert(user, "click!")
	playsound(source, 'modular_lewd_items/sounds/clicker.ogg', 40, FALSE)

/obj/item/clicker/attack_self(mob/user)
	. = ..()
	click(src, user)

/obj/item/clicker/click_alt(mob/user)
	current_color = (current_color == "pink") ? "teal" : "pink"
	icon_state = "clicker_[current_color]"
	inhand_icon_state = "clicker_[current_color]"
	update_icon()
	to_chat(user, span_notice("You flip [src] to the [current_color] side."))
	return CLICK_ACTION_SUCCESS
