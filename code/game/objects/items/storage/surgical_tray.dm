/obj/item/storage/surgical_tray
	name = "surgical tray"
	desc = "A small metallic tray covered in sterile tarp. Intended to store surgical tools in a neat and clean fashion."
	icon_state = "surgical_tray"
	atom_flags = CONDUCT
	w_class = WEIGHT_CLASS_BULKY //Should not fit in backpacks
	storage_type = /datum/storage/surgical_tray

/obj/item/storage/surgical_tray/PopulateContents()
	new /obj/item/tool/surgery/scalpel/manager(src)
	new /obj/item/tool/surgery/hemostat(src)
	new /obj/item/tool/surgery/retractor(src)
	new /obj/item/tool/surgery/surgical_membrane(src)
	new /obj/item/tool/surgery/cautery(src)
	new /obj/item/tool/surgery/circular_saw(src)
	new /obj/item/tool/surgery/suture(src)
	new /obj/item/tool/surgery/bonegel(src)
	new /obj/item/tool/surgery/bonesetter(src)
	new /obj/item/tool/surgery/FixOVein(src)
	new /obj/item/tool/surgery/surgicaldrill(src)
	new /obj/item/stack/nanopaste(src)

/obj/item/storage/surgical_tray/update_icon_state()
	. = ..()
	if(!length(contents))
		icon_state = "surgical_tray_e"
	else
		icon_state = "surgical_tray"

/obj/item/storage/surgical_tray/coe // The sprites were unused in surgery_tools.dmi, and the siren call of feature creep was.. well.
	name = "advanced surgical tray"
	desc = "A small metallic tray covered in sterilizing tarp, unfortunately the tarp is not effective against excessively bloody instruments and any tools that belong under it should be cleaned first. Intended to store surgical tools in a neat and clean fashion. It has a stylized design of a xenomorph larva embossed in the center of the tray. It is functionally identical to a normal surgical tray, with it's contents merely being cosmetic analogues of the normal surgical tools."
	icon_state = "predator_surgical_tray"
	atom_flags = CONDUCT
	w_class = WEIGHT_CLASS_BULKY //Should not fit in backpacks
	storage_type = /datum/storage/surgical_tray

/obj/item/storage/surgical_tray/PopulateContents()
	new /obj/item/tool/surgery/scalpel/manager/coe(src)
	new /obj/item/tool/surgery/hemostat/coe(src)
	new /obj/item/tool/surgery/retractor/coe(src)
	new /obj/item/tool/surgery/surgical_membrane/coe(src)
	new /obj/item/tool/surgery/cautery/coe(src)
	new /obj/item/tool/surgery/circular_saw/coe(src)
	new /obj/item/tool/surgery/suture/coe(src)
	new /obj/item/tool/surgery/bonegel/coe(src)
	new /obj/item/tool/surgery/bonesetter/coe(src)
	new /obj/item/tool/surgery/FixOVein/coe(src)
	new /obj/item/tool/surgery/surgicaldrill/coe(src)
	new /obj/item/stack/nanopaste(src) // Who the hell uses nanopaste anyway? In all my hours as CMO I've NEVER used it.

/obj/item/storage/surgical_tray/coe/update_icon_state()
	. = ..()
	if(!length(contents))
		icon_state = "predator_surgical_tray_e"
	else
		icon_state = "predator_surgical_tray"
