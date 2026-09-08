//Nachtreiher Volkite Pump-Action Shotgun

/obj/item/weapon/gun/shotgun/pump/nachtreiher
	name = "\improper VX-16 Nachtreiher"
	desc = "A nine-round pump action shotgun which uses charged volkite shells. Thanks to the integrated barrel charger, the weapon quickly accelerates multiple lesser volkite bolts at its targets."
	icon = 'ntf_modular/icons/obj/items/guns/shotguns64.dmi'
	icon_state = "nachtreiher"
	cock_animation = "nachtreiher_pump"
	worn_icon_state = "nachtreiher"
	worn_icon_list = list(
		slot_l_hand_str = 'ntf_modular/icons/mob/inhands/guns/shotguns_left_1.dmi',
		slot_r_hand_str = 'ntf_modular/icons/mob/inhands/guns/shotguns_right_1.dmi',
		slot_s_store_str = 'ntf_modular/icons/mob/suit_slot.dmi',
		slot_back_str = 'ntf_modular/icons/mob/clothing/back.dmi',
	)
	fire_sound = 'sound/weapons/guns/fire/volkite_nachtreiher.ogg'
	reload_sound = 'sound/weapons/guns/interact/shotgun_cmb_insert.ogg'
	cocked_sound = 'sound/weapons/guns/interact/shotgun_cmb_pump.ogg'
	allowed_ammo_types = list(/datum/ammo/energy/volkite/shotgun,/obj/item/ammo_magazine/handful/volkite)
	default_ammo_type = /datum/ammo/energy/volkite/shotgun
	attachable_allowed = list(
		/obj/item/attachable/reddot,
		/obj/item/attachable/lasersight,
		/obj/item/attachable/flashlight,
		/obj/item/attachable/flashlight/under,
		/obj/item/attachable/scope/mini,
		/obj/item/attachable/magnetic_harness,
		/obj/item/attachable/motiondetector,
	)
	item_map_variant_flags = NONE
	attachable_offset = list("muzzle_x" = 38, "muzzle_y" = 19,"rail_x" = 21, "rail_y" = 21, "under_x" = 41, "under_y" = 12, "stock_x" = 15, "stock_y" = 14)

	fire_delay = 1 SECONDS
	damage_mult = 1
	accuracy_mult = 1.1
	accuracy_mult_unwielded = 1
	scatter_unwielded = 10
	recoil = 0 // It has a stock. It's on the sprite.
	recoil_unwielded = 0
	cock_delay = 1 SECONDS
	aim_slowdown = 0.5

/obj/item/weapon/gun/shotgun/pump/nachtreiher/somvet
	starting_attachment_types = list(/obj/item/attachable/reddot, /obj/item/attachable/lasersight)

/datum/ammo/energy/volkite/shotgun
	name = "volkite groupshot"
	handful_icon = 'ntf_modular/icons/obj/items/ammo/handful.dmi'
	handful_icon_state = "volkite_groupshot"
	icon_state = "overchargedlaser_small"
	icon = 'ntf_modular/icons/obj/items/projectiles.dmi'
	hud_state = "laser_heat"
	handful_amount = 5
	hud_state_empty = "battery_empty_flash"
	ammo_behavior_flags = AMMO_ENERGY|AMMO_SOUND_PITCH
	bonus_projectiles_type = /datum/ammo/energy/volkite/shotgun/volkite_spread
	bonus_projectiles_amount = 4
	bonus_projectiles_scatter = 2
	bullet_color = COLOR_TAN_ORANGE
	armor_type = ENERGY
	max_range = 14
	accurate_range = 5 //for nachtreiher
	shell_speed = 4.5
	accuracy_variation = 5
	accuracy = 5
	point_blank_range = 2
	damage = 15
	penetration = 12.5
	sundering = 1.25
	deflagrate_mult = 0.5

/obj/item/ammo_magazine/shotgun/volkite
	name = "box of 12 gauge volkite shells"
	desc = "A box filled with 12 gauge volkite shells."
	icon_state = "vokite_buckshot"
	default_ammo = /datum/ammo/energy/volkite/shotgun
	max_rounds = 25
	w_class = WEIGHT_CLASS_NORMAL
	icon_state_mini = "incendiary"

/obj/item/ammo_magazine/handful/volkite
	name = "handful of shotgun volkite groupshot (12 gauge)"
	icon = 'ntf_modular/icons/obj/items/ammo/handful.dmi'
	icon_state = "volkite_groupshot"
	current_rounds = 5
	max_rounds = 5
	default_ammo = /datum/ammo/energy/volkite/shotgun
	caliber = CALIBER_12G

/datum/ammo/energy/volkite/shotgun/volkite_spread
	name = "additional small thermal energy bolt"
	damage = 15
	sundering = 1.25
	penetration = 12.5
	deflagrate_mult = 0.5

/datum/ammo/energy/volkite/shotgun/vx30_spread
	name = "small thermal energy bolt"
	damage = 20
	deflag_damage = 5
	shell_speed = 5
	bonus_projectiles_amount = 0
	penetration = 15
	sundering = 1.5
	accuracy_variation = 9
	accurate_range = 5
	max_range = 20
	damage_falloff = 0
