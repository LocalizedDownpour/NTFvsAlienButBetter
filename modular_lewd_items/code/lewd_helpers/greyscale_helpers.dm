/*
*	Stand-in for the TG set_greyscale() proc, which this fork does not have.
*	Keeps the ported lewd content working with the fork's set_greyscale_colors()/update_greyscale() pair.
*/

/obj/item/proc/set_greyscale(list/colors, datum/greyscale_config/new_config, datum/greyscale_config/new_config_icon_state, new_color_is_fixed)
	if(new_config)
		greyscale_config = new_config
	if(colors)
		if(islist(colors))
			colors = colors.Join("")
		set_greyscale_colors(colors, update = FALSE)
	update_greyscale()
