
//quicksex
/*/mob/living/MouseDrop_T(atom/dropping, mob/user)
	. = ..()
	if(!user.client || !user.client.prefs)
		return
	if(dropping != usr)
		return
	if(!isliving(dropping))
		return
	if(!isliving(user) || !isliving(src))
		return
	if(!user.sexcon || !sexcon)
		return
	if(user.incapacitated(TRUE))
		return
	if(dropping != src)
		if(!(user.client?.prefs.sex_pref_flags & SEXPREF_QUICK_SEX))
			balloon_alert(user,"Your QK sex pref is OFF!")
			return
		//they are just warnings to show your action isnt working on this fucking snowflake
		if(user.a_intent == INTENT_DISARM && !((client?.prefs.sex_pref_flags & SEXPREF_QUICK_SEX_HEAL)))
			balloon_alert(user,"QK Heal sex is off!")
			return
		if(user.a_intent == INTENT_DISARM && !((client?.prefs.sex_pref_flags & SEXPREF_STAMINA_DRAIN) && (client?.prefs.sex_pref_flags & SEXPREF_CHOKING)))
			balloon_alert(user,"Some Stam sex prefs are OFF!")
			return
		if(user.a_intent == INTENT_HARM && !(client?.prefs.sex_pref_flags & SEXPREF_BLOOD_DRAIN) && ((client?.prefs.sex_pref_flags & SEXPREF_ALL) && (client?.prefs.sex_pref_flags & SEXPREF_ROUGH_SEX)))
			balloon_alert(user,"Some Harm sex prefs are OFF!")
			return
		user.sexcon.set_target(src)
		if(user.a_intent != INTENT_HELP && !user.sexcon.current_action)
			user.face_atom(src)
			face_atom(user)
			var/action = /datum/sex_action/rimming // neuter things ig
			if(sexcon.can_use_penis()) //male target
				if(user.sexcon.can_use_vagina())
					action = pick(/datum/sex_action/vaginal_ride_sex, /datum/sex_action/anal_ride_sex, /datum/sex_action/blowjob)
					if(user.a_intent == INTENT_DISARM)
						action = /datum/sex_action/facesitting
				else if(user.sexcon.can_use_penis() || (isxeno(user) && user.client?.prefs?.xenogender > 2)) //gay
					action = pick(/datum/sex_action/anal_sex, /datum/sex_action/throat_sex, /datum/sex_action/frotting) //funny frot
					if(user.a_intent == INTENT_DISARM) //prioritise stamdrain acts
						action = /datum/sex_action/throat_sex
				else
					action = /datum/sex_action/anal_sex
			else if(sexcon.can_use_vagina()) //female target
				if(user.sexcon.can_use_penis() || (isxeno(user) && user.client?.prefs?.xenogender <= 2))
					action = pick(/datum/sex_action/vaginal_sex, /datum/sex_action/anal_sex, /datum/sex_action/throat_sex)
					if(user.a_intent == INTENT_DISARM)
						action = /datum/sex_action/throat_sex
				else if(user.sexcon.can_use_vagina())
					action = pick(/datum/sex_action/scissoring, /datum/sex_action/cunnilingus)
					if(user.a_intent == INTENT_DISARM)
						action = /datum/sex_action/facesitting
				else
					action = /datum/sex_action/facesitting
			user.sexcon.speed = SEX_SPEED_HIGH
			if(user.a_intent == INTENT_GRAB) //in place of help cuz that opens regular sexcon
				balloon_alert_to_viewers("QK heal sex")
				if(!buckled)
					user.start_pulling(src)
				user.sexcon.drain_style = SEX_DRAIN_STYLE_HEAL_TARGET
				user.sexcon.force = SEX_FORCE_LOW
			if(user.a_intent == INTENT_HARM)
				balloon_alert_to_viewers("QK health-drain sex")
				user.sexcon.drain_style = SEX_DRAIN_STYLE_DRAIN_BLOOD_FAST
				user.sexcon.force = SEX_FORCE_EXTREME
			if(user.a_intent == INTENT_DISARM)
				balloon_alert_to_viewers("QK stam-drain sex")
				if(!buckled)
					user.start_pulling(src)
				user.sexcon.drain_style = SEX_DRAIN_STYLE_DRAIN_STAMINA
				user.sexcon.force = SEX_FORCE_EXTREME
			if(lying_angle)
				AdjustParalyzed(3 SECONDS)
				user.Move(loc)
				user.sexcon.speed = SEX_SPEED_EXTREME
			else
				AdjustImmobilized(1 SECONDS)
			user.sexcon.try_start_action(action)
	erptime(user, src)*/
