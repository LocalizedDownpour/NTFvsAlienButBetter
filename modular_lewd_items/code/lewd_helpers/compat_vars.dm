/*
*	Base-type vars that the ported Skyrat lewd content expects, but that this fork trimmed.
*	Kept module-local so upstream base types stay untouched.
*/

/obj/structure
	/// Stack type this structure gives back when deconstructed.
	var/build_stack_type = null
	/// Whether this seat has armrests (used by the ported pillow furniture).
	var/has_armrest = FALSE
