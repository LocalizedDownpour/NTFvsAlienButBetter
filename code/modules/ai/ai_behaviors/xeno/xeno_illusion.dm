/datum/ai_behavior/xeno/illusion
	target_distance = 3 //We attack only nearby
	base_action = ESCORTING_ATOM
	is_offered_on_creation = FALSE
	/// Illusions are not real xenos: they have no health to look after and never take damage
	can_heal = FALSE
	/// How close a human has to be in order for illusions to react
	var/illusion_react_range = 5

/datum/ai_behavior/xeno/illusion/New(loc, mob/parent_to_assign, atom/escorted_atom)
	if(!escorted_atom)
		base_action = MOVING_TO_NODE
	..()

/// We want a separate look_for_new_state in order to make illusions behave as we wish
/datum/ai_behavior/xeno/illusion/look_for_new_state(atom/next_target)
	//We use the standard targeting helper so that illusions only notice humans they can actually see, and so that
	//dead, cloaked, nested, godmode, hauled and monkey humans are ignored just like every other xeno AI ignores them.
	var/mob/living/carbon/human/victim = get_nearest_target(mob_parent, illusion_react_range, TARGET_HUMAN, mob_parent.faction, mob_parent.get_xeno_hivenumber(), TRUE)
	if(!victim)
		return
	//Take a swing if we are already standing next to them, then chase them down either way
	attack_target(src, victim)
	set_escorted_atom(src, victim)

///Illusions pretends of making damage
/datum/ai_behavior/xeno/illusion/proc/attack_target(datum/source, atom/attacked)
	if(world.time < mob_parent.next_move) //Don't swing faster than an actual xeno could
		return
	if(!attacked)
		attacked = atom_to_walk_to
	if(!attacked)
		return
	if(get_dist(attacked, mob_parent) > 1) //Melee only, we do not claw people from across the room
		return
	var/mob/illusion/illusion_parent = mob_parent
	var/mob/living/carbon/xenomorph/original_xeno = illusion_parent.original_mob
	if(!original_xeno)
		return
	//random so that the illusions of a single mirage do not swing in perfect sync
	illusion_parent.changeNext_move(original_xeno.xeno_caste.attack_delay + rand(0, 5))
	illusion_parent.face_atom(attacked)
	if(ismob(attacked))
		//ATTACK_EFFECT_REDSLASH is a list of icon states in this codebase, and do_attack_animation() needs a single
		//icon state to draw the slash on top of the victim, otherwise nothing shows up
		illusion_parent.do_attack_animation(attacked, pick(ATTACK_EFFECT_REDSLASH))
		playsound(illusion_parent.loc, SFX_ALIEN_CLAW_FLESH, 25, 1)
		return
	illusion_parent.do_attack_animation(attacked, ATTACK_EFFECT_CLAW)
	playsound(illusion_parent.loc, SFX_ALIEN_CLAW_METAL, 25, 1)

/datum/ai_behavior/xeno/fleeing_illusion
	target_distance = 15 // We will run away forever.
	base_action = ESCORTING_ATOM
	is_offered_on_creation = FALSE

/datum/ai_behavior/xeno/fleeing_illusion/New(loc, mob/parent_to_assign, atom/escorted_atom)
	if(!escorted_atom)
		base_action = MOVING_TO_NODE
	..()

/// We want a separate look_for_new_state in order to make illusions behave as we wish
/datum/ai_behavior/xeno/fleeing_illusion/look_for_new_state()
	switch(current_action)
		if(ESCORTING_ATOM)
			change_action(MOVING_TO_SAFETY, escorted_atom, list(INFINITY))
