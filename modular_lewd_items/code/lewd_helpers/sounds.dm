/proc/conditional_pref_sound(
	atom/source,
	soundin,
	vol as num,
	vary,
	extrarange as num,
	falloff_exponent = SOUND_FALLOFF_EXPONENT,
	frequency = null,
	channel = 0,
	pressure_affected = TRUE,
	ignore_walls = FALSE,
	falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE,
	use_reverb = TRUE,
	pref_to_check = null,
)
	playsound(source, soundin, vol, vary, extrarange)

