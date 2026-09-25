/*
*	Ported from Rimstation: lewd_arousal/status_effects/ropebunny.dm
*	Mood events do not exist in this fork, so the effect stays a plain marker that the
*	shibari ropes use to know someone is fully tied up.
*/

/datum/status_effect/ropebunny
	id = "ropebunny"
	tick_interval = 1 SECONDS
	duration = -1
	alert_type = null
