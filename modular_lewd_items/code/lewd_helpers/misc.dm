/*
*	Looping sound for vibrating stuff
*/

/datum/looping_sound/lewd/vibrator
	start_sound = 'modular_lewd_items/sounds/bzzz-loop-1.ogg'
	start_length = 1
	mid_sounds = list('modular_lewd_items/sounds/bzzz-loop-1.ogg')
	mid_length = 10
	end_sound = 'modular_lewd_items/sounds/bzzz-loop-1.ogg'
	range = 3
	falloff = 5
	ignore_walls = FALSE

/datum/looping_sound/lewd/vibrator/low
	volume = 30

/datum/looping_sound/lewd/vibrator/medium
	volume = 50

/datum/looping_sound/lewd/vibrator/high
	volume = 70

/// Used to add a cum decal to the floor while transferring viruses and DNA to it
/mob/living/proc/add_cum_splatter_floor(turf/the_turf, female = FALSE)
	if(!the_turf)
		the_turf = get_turf(src)

	var/selected_type = female ? /obj/effect/decal/cleanable/cum/femcum : /obj/effect/decal/cleanable/cum
	var/atom/stain = new selected_type(the_turf)

	stain.add_mob_blood(src)

/mob/living/proc/can_perform_action(atom/target, flags = 0)
	if(stat || incapacitated())
		return FALSE
	if(target && !Adjacent(target))
		return FALSE
	return TRUE
