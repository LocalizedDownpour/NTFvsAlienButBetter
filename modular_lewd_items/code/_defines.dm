/// Defines for modular lewd items compatibility with TGMC

// Lewd slot bitflags
#define LEWD_SLOT_PENIS (1<<0)
#define LEWD_SLOT_VAGINA (1<<1)
#define LEWD_SLOT_ANUS (1<<2)
#define LEWD_SLOT_NIPPLES (1<<3)

// Item / Clothing flags compatibility
#ifndef ABSTRACT
#define ABSTRACT ITEM_ABSTRACT
#endif

#ifndef DROPDEL
#define DROPDEL DELONDROP
#endif

#ifndef HAND_ITEM
#define HAND_ITEM 0
#endif

#ifndef INEDIBLE_CLOTHING
#define INEDIBLE_CLOTHING 0
#endif

#ifndef NEED_DEXTERITY
#define NEED_DEXTERITY 0
#endif

#ifndef IS_PLAYER_COLORABLE_1
#define IS_PLAYER_COLORABLE_1 0
#endif

#ifndef NO_NEW_GAGS_PREVIEW_1
#define NO_NEW_GAGS_PREVIEW_1 0
#endif

// Click action compatibility
#ifndef CLICK_ACTION_BLOCKING
#define CLICK_ACTION_BLOCKING (1<<0)
#endif

#ifndef CLICK_ACTION_SUCCESS
#define CLICK_ACTION_SUCCESS (1<<1)
#endif

#ifndef COMPONENT_CANCEL_ATTACK_CHAIN
#define COMPONENT_CANCEL_ATTACK_CHAIN (1<<0)
#endif

#ifndef FORBID_TELEKINESIS_REACH
#define FORBID_TELEKINESIS_REACH (1<<0)
#endif

// Signal compatibility
#ifndef COMSIG_LIVING_RESIST
#define COMSIG_LIVING_RESIST COMSIG_LIVING_DO_RESIST
#endif

// Traits and Trait sources
#ifndef CLOTHING_TRAIT
#define CLOTHING_TRAIT "clothing"
#endif

#ifndef TRAIT_DEAF
#define TRAIT_DEAF "deaf"
#endif

#ifndef TRAIT_RIGGER
#define TRAIT_RIGGER "rigger"
#endif

#ifndef TRAIT_ROPEBUNNY
#define TRAIT_ROPEBUNNY "ropebunny"
#endif

#ifndef TRAIT_STRAPON
#define TRAIT_STRAPON "strapon"
#endif

#ifndef TRAIT_CONDOM_BROKEN
#define TRAIT_CONDOM_BROKEN "condom_broken"
#endif

// Visual / Layer compatibility
#ifndef BODY_FRONT_UNDER_CLOTHES
#define BODY_FRONT_UNDER_CLOTHES UNDERWEAR_LAYER
#endif

#ifndef OVERLAY_LIGHT
#define OVERLAY_LIGHT MOVABLE_LIGHT
#endif

// Materials
#ifndef SHEET_MATERIAL_AMOUNT
#define SHEET_MATERIAL_AMOUNT MINERAL_MATERIAL_AMOUNT
#endif
