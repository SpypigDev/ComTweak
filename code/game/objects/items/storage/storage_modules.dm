#define MODULE_SIZE_GENERAL "general"
#define MODULE_SIZE_AUXILIARY "auxiliary"
#define MODULE_SIZE_LARGE "large"

/obj/item/storage/storage_module
	name = "storage module"
	desc = "Can be attached to storage equipment"
	icon_state = "tankt"
	icon = 'icons/obj/items/clothing/modular_equipment/belt.dmi'
	var/module_size

/obj/item/storage/storage_module/medical
	name = "corpsman storage modules"
	desc = "Can be attached to storage equipment"
	icon_state = "tankt"
	icon = 'icons/obj/items/clothing/modular_equipment/belt.dmi'

/obj/item/storage/storage_module/medical/belt
	name = "corpsman belt storage modules"
	desc = "Can be attached to storage equipment"
	icon_state = "belt"
	icon = 'icons/obj/items/clothing/modular_equipment/belt.dmi'

/obj/item/storage/storage_module/medical/belt/general
	module_size = MODULE_SIZE_GENERAL
	desc = "Fills a general storage slot on a modular corpsman storage rig."
	icon_state = "belt_full"

/obj/item/storage/storage_module/medical/belt/general/full
	name = "General storage module"
	desc = "Fills 2 general storage slots on a modular corpsman storage rig."
	icon_state = "belt_full"

/obj/item/storage/storage_module/medical/belt/general/trauma_response_pouch
	name = "trauma response kit module"
	icon_state = "belt_trauma_response"

/obj/item/storage/storage_module/medical/belt/general/tank_pouch
	name = "compact pressurized tank storage module"
	icon_state = "belt_pressurized_tanks"

/obj/item/storage/storage_module/medical/belt/general/storage_harness
	name = "storage harness module"
	icon_state = "belt_sling"

/obj/item/storage/storage_module/medical/belt/auxiliary
	module_size = MODULE_SIZE_AUXILIARY
	desc = "Fills an auxiliary storage slot on a modular corpsman storage rig."
	icon_state = "belt_full"

/obj/item/storage/storage_module/medical/belt/auxiliary/autoinjector_pouch
	name = "small autoinjector pouch module"
	icon_state = "belt_injectors"

/obj/item/storage/storage_module/medical/belt/auxiliary/hypospray_pouch
	name = "hypospray support pouch module"
	icon_state = "belt_hypospray"

/obj/item/storage/storage_module/medical/belt/auxiliary/tools_pouch
	name = "surgical tools storage module"
	icon_state = "belt_tools"

/obj/item/storage/storage_module/medical/belt/auxiliary/general_pouch
	name = "general pouch module"
	icon_state = "belt_general_pouch"

#undef MODULE_SIZE_GENERAL
#undef MODULE_SIZE_AUXILIARY
#undef MODULE_SIZE_LARGE
