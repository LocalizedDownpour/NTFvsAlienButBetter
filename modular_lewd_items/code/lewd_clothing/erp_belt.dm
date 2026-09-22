/datum/storage/belt/erpbelt
	storage_slots = 14
	max_w_class = WEIGHT_CLASS_NORMAL

/datum/storage/belt/erpbelt/New(atom/parent)
	. = ..()
	set_holdable(list(
		//toys
		/obj/item/clothing/sextoy/eggvib/signalvib,
		/obj/item/clothing/sextoy/buttplug,
		/obj/item/clothing/sextoy/nipple_clamps,
		/obj/item/clothing/sextoy/eggvib,
		/obj/item/clothing/sextoy/dildo/double_dildo,
		/obj/item/clothing/sextoy/vibroring,
		/obj/item/clothing/sextoy/condom,
		/obj/item/condom_pack,
		/obj/item/clothing/sextoy/dildo,
		/obj/item/clothing/sextoy/dildo/custom_dildo,
		/obj/item/tickle_feather,
		/obj/item/clothing/sextoy/fleshlight,
		/obj/item/kinky_shocker,
		/obj/item/clothing/mask/leatherwhip,
		/obj/item/clothing/sextoy/magic_wand,
		/obj/item/bdsm_candle,
		/obj/item/spanking_pad,
		/obj/item/clothing/sextoy/vibrator,
		/obj/item/restraints/handcuffs/lewd,
		/obj/item/reagent_containers/cup/lewd_filter,
		/obj/item/assembly/signaler,
		/obj/item/clicker,

		//clothing
		/obj/item/clothing/mask/ballgag,
		/obj/item/clothing/mask/ballgag/choking,
		/obj/item/clothing/head/domina_cap,
		/obj/item/clothing/glasses/blindfold/kinky,
		/obj/item/clothing/glasses/sunglasses/blindfold/kinky,
		/obj/item/clothing/ears/earmuffs/kinky_headphones,
		/obj/item/clothing/ears/kinky_headphones,
		/obj/item/clothing/suit/straight_jacket/latex_straight_jacket,
		/obj/item/clothing/mask/gas/bdsm_mask,
		/obj/item/clothing/head/deprivation_helmet,

		//neck
		/obj/item/clothing/neck/kink_collar,
		/obj/item/clothing/neck/kink_collar/locked,
		/obj/item/clothing/neck/mind_collar,
		/obj/item/clothing/neck/shockcollar,
		/obj/item/clothing/erp_leash,

		//hands
		/obj/item/clothing/gloves/ball_mittens,
		/obj/item/clothing/gloves/latex,

		//legs
		/obj/item/clothing/shoes/latex_heels,
		/obj/item/clothing/shoes/latex_heels/domina_heels,
		/obj/item/clothing/shoes/latex_heels/ballet_heels,

		//belt
		/obj/item/clothing/strapon,

		//chems
		/obj/item/reagent_containers/pill/aphrotoxin,
		/obj/item/reagent_containers/glass/bottle/aphrotoxin,
	))

/obj/item/storage/belt/erpbelt
	name = "leather belt"
	desc = "Used to hold sex toys. Looks pretty good."
	icon = 'modular_lewd_items/icons/obj/lewd_clothing/lewd_belts.dmi'
	icon_override = 'modular_lewd_items/icons/mob/lewd_clothing/lewd_belts.dmi'
	lefthand_file = 'modular_lewd_items/icons/mob/lewd_inhands/lewd_inhand_left.dmi'
	righthand_file = 'modular_lewd_items/icons/mob/lewd_inhands/lewd_inhand_right.dmi'
	icon_state = "erpbelt"
	inhand_icon_state = "erpbelt"
	worn_icon_state = "erpbelt"
	equip_slot_flags = ITEM_SLOT_BELT
	storage_type = /datum/storage/belt/erpbelt
