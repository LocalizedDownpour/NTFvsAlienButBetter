/mob/living/carbon/xenomorph/proc/force_devolution_if_not_enough_xenos()
	SIGNAL_HANDLER
	var/num_xenos = hive.total_xenos_for_evolving()
	var/mob/living/carbon/xenomorph/base_type = xeno_caste.base_strain_type //strains should be treated as their base types
	var/datum/xeno_caste/base_caste_type = initial(base_type.caste_base_type)
	var/min_xenos = GLOB.xeno_caste_datums[base_caste_type][XENO_UPGRADE_BASETYPE].evolve_min_xenos //Can't just do xeno_caste.evolve_min_xenos because evo requirements are only applied to the basetype upgrade
	if(num_xenos >= min_xenos)
		return
	balloon_alert(src, "forced deevolution!")
	to_chat(src, span_xenouserdanger("Your hive has [num_xenos] of the minimum of [min_xenos] xenos (including burrowed) required to support your caste.  You will be automatically devolved in 10 seconds."))
	addtimer(CALLBACK(src, PROC_REF(do_forced_devolution_for_not_enough_xenos)), 10 SECONDS)

/mob/living/carbon/xenomorph/proc/do_forced_devolution_for_not_enough_xenos()
	if(is_ventcrawling || !isturf(loc))
		force_devolution_if_not_enough_xenos() //can't do it now, try again in 10 seconds.
		to_chat(src, span_xenouserdanger("Please stop ventcrawling so you can be devolved."))
		log_admin("[logdetails(src)] could not be automatically devolved because they were ventcrawling, trying again in 10 seconds.")
		return
	var/attempts = 0
	var/datum/xeno_caste/new_caste = GLOB.xeno_caste_datums[xeno_caste.deevolves_to][XENO_UPGRADE_BASETYPE]
	while(new_caste.tier != XENO_TIER_ONE)
		new_caste = GLOB.xeno_caste_datums[xeno_caste.deevolves_to][XENO_UPGRADE_BASETYPE]
		if(!istype(xeno_caste) || attempts++ > 5)
			new_caste = GLOB.xeno_caste_datums[/datum/xeno_caste/drone][XENO_UPGRADE_BASETYPE]
			break
	var/mob/living/carbon/xenomorph/new_xeno = do_evolve(new_caste.type, regression = TRUE, forced = TRUE)
	if(!istype(new_xeno))
		force_devolution_if_not_enough_xenos() //can't do it now, try again in 10 seconds.
		to_chat(src, span_xenouserdanger("Please eject any mobs you are carrying and do not ventcrawl."))
		log_admin("[logdetails(src)] could not be automatically devolved.  eaten_mob = [logdetails(eaten_mob)]. Trying again in 10 seconds.")

/mob/living/carbon/xenomorph/Initialize(mapload, do_not_set_as_ruler, _hivenumber)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_GAMESTATE_GROUNDSIDE, PROC_REF(force_devolution_if_not_enough_xenos))

