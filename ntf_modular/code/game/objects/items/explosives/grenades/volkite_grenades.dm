///volkite grenade: disperses small volkite bolts out from itself in a ring similar to the HEFA

/obj/item/explosive/grenade/bullet/volkite
	name = "\improper VX30 HE-VOLK grenade"
	desc = "High explosive volkite grenades cause a powerful yet small explosion combined with a scattering ring of blistering volkite bolts that will most likely deflagerate, please throw very, very, VERY far away."
	icon = 'ntf_modular/icons/obj/items/grenade.dmi'
	icon_state = "grenade_volkite"
	worn_icon_state = "grenade_hefa2"
	icon_state_mini = "grenade_hefa"
	hud_state = "laser_heat"
	rotations = -1
	fire_sound = null
	projectile_count = 24
	ammo_type = /datum/ammo/energy/volkite/shotgun/vx30_spread

/obj/item/explosive/grenade/bullet/volkite/prime()
	explosion(loc, light_impact_range = 1, heavy_impact_range = 1, explosion_cause=src)
	return ..()
