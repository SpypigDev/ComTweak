/datum/tutorial/marine/hospital_corpsman_advanced
	name = "Marine - Hospital Corpsman (Advanced)"
	desc = "Learn the more advanced skills required of a Marine Hospital Corpsman."
	tutorial_id = "marine_hm_2"
	icon_state = "medic"
	//required_tutorial = "marine_hm_1"
	tutorial_template = /datum/map_template/tutorial/s7x7/hm
	var/clothing_items_to_vend = 6
	var/ontime
	/// To be used to differentiate subsections in long-winded procs. SET TO 0 WHEN NOT IN USE! CLEAN UP AFTER YOURSELF!
	var/stage = 0
	var/cpr_count = 0
	/// For use in the handle_pill_bottle helper, should always be set to 0 when not in use
	var/handle_pill_bottle_status = 0

// ------------ CONTENTS ------------ //
//
// Section 1 - Stabilizing Types of Organ Damage
// 1.1 Internal Organ Damage (Chest)
// 1.2 Heart Damage
// 1.3 Lung Damage
// 1.4 Internal Organ Damage (Head)
// 1.5 Liver and Kidney Damage
//
// Section 2 - Revivals
// 2.1 Defibrillations
// 2.2 Revival Conditions
// 2.3 Delivering CPR
// 2.4 Assisted Revivals
//
// Section 3 - Field Surgery
// 3.1 Surgical Damage Treatment
// 3.2 Internal Bleeding

/datum/tutorial/marine/hospital_corpsman_advanced/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()
	message_to_player("This tutorial will teach you the more complex elements of playing as a Marine Hospital Corpsman.")
	addtimer(CALLBACK(src, PROC_REF(uniform)), 4 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/uniform()

	message_to_player("Before you're ready to take on the world as a Marine Hospital Corpsman, you should probably put some clothes on...")
	message_to_player("Stroll on over to the outlined vendor and vend everything inside.")
	update_objective("Vend everything inside the ColMarTech Automated Closet.")

	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/clothing/tutorial/medic/advanced, medical_vendor)
	add_highlight(medical_vendor, COLOR_GREEN)
	medical_vendor.req_access = list()
	RegisterSignal(medical_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND, PROC_REF(uniform_vend))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/uniform_vend(datum/source)
	SIGNAL_HANDLER

	clothing_items_to_vend--
	if(clothing_items_to_vend <= 0)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/clothing/tutorial/medic/advanced, medical_vendor)
		UnregisterSignal(medical_vendor, COMSIG_VENDOR_SUCCESSFUL_VEND)
		medical_vendor.req_access = list(ACCESS_TUTORIAL_LOCKED)
		remove_highlight(medical_vendor)

		var/obj/item/storage/belt/medical/lifesaver/medbelt = locate(/obj/item/storage/belt/medical/lifesaver) in tutorial_mob.contents
		add_to_tracking_atoms(medbelt)
		var/obj/item/device/healthanalyzer/healthanalyzer = new(loc_from_corner(0, 4))
		add_to_tracking_atoms(healthanalyzer)
		add_highlight(healthanalyzer, COLOR_GREEN)
		message_to_player("Great. Now pick up your trusty <b>Health Analyzer</b>, and let's get started with the tutorial!")
		update_objective("")
		RegisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM, PROC_REF(organ_tutorial))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	remove_highlight(healthanalyzer)

	message_to_player("<b>Section 1: Stabilizing Types of Organ Damage</b>.")
	message_to_player("In a combat environment, <b>Internal Damage</b> can be just as deadly as its external counterparts.")
	message_to_player("A patient can accumulate internal damage in a variety of forms. However, this section will focus specifically on <b>Internal Organ Damage</b>.")
	message_to_player("A skilled Marine Hospital Corpsman (you) must be able to detect the cause and location of <b>Organ Damage</b>, as well as understanding its various methods of treatment")
	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_2)), 19 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_2()

	message_to_player("Like the rest of the body, damage to <b>Internal Organs</b> can be classified in levels.")
	message_to_player("As an internal organ sustains increasing amounts of damage, its condition will change from:")
	message_to_player("Healthy -> [SPAN_YELLOW("Slighty Bruised")] -> [SPAN_ORANGE("Bruised")] -> [SPAN_RED("Ruptured / Broken")]")
	message_to_player("Each increase in organ damage severity will produce similarly life-threatening side effects on the body.")
	message_to_player("A <b>Ruptured Internal Organ</b> has been damaged beyond the point of function, and will require immediate surgical intervention from a <u>trained Doctor</u>.")
	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_chest)), 21 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_chest()

	message_to_player("<b>Section 1.1: Internal Organ Damage (Chest)</b>.")

	message_to_player("Unlike the rest of the body, the condition of <b>Internal Organs</b> do not appear on a Health Analyzer scan.")
	message_to_player("Instead, a more specialized tool is used. Say hello to the humble <b>Stethoscope</b>!")

	var/obj/item/clothing/accessory/stethoscope/steth = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(steth)
	add_highlight(steth, COLOR_GREEN)

	message_to_player("Pick up the <b>Stethoscope</b>, and revel is its simple beauty.")

	RegisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM, PROC_REF(organ_tutorial_chest_2))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_chest_2()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM)

	message_to_player("When someone takes any amount of <b>Internal Organ Damage</b>, the <b>Stethoscope</b> can be used in exactly the same manner as a Health Analyzer to scan their condition.")
	message_to_player("Oh, look's like our old friend <b>Mr Dummy</b> is back, and looking for a health checkup!")

	var/mob/living/carbon/human/human_dummy = new(loc_from_corner(2,2))
	add_to_tracking_atoms(human_dummy)
	add_highlight(human_dummy, COLOR_GREEN)

	message_to_player("Click on the Dummy with your <b>Stethoscope</b> in hand to test the health of their <b>Internal Organs</b>.")

	RegisterSignal(tutorial_mob, COMSIG_LIVING_STETHOSCOPE_USED, PROC_REF(organ_tutorial_chest_3))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_chest_3(datum/source, mob/living/carbon/human/being, mob/living/user)

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	if(being != human_dummy)
		return
	else
		if(tutorial_mob.zone_selected != "chest")
			message_to_player("Make sure to have the Dummys <b>Chest</b> selected as your target. Use the <b>Zone Selection Element</b> on the bottom right of your hud to target the Dummys chest, and try again.")
		else
			message_to_player("Well done! If you check the <b>Chat-Box</b> on the right of your screen, you will now see the following message from your <b>Stethoscope</b>:")
			message_to_player("You hear normal heart beating patterns, his heart is surely <u>Healthy</u>. You also hear normal respiration sounds aswell, that means his lungs are <u>Healthy</u>,")
			message_to_player("This means that all internal organs in Mr Dummys chest are <b>Fully Healthy</b>!")

			TUTORIAL_ATOM_FROM_TRACKING(/obj/item/clothing/accessory/stethoscope, steth)
			UnregisterSignal(tutorial_mob, COMSIG_LIVING_STETHOSCOPE_USED)
			remove_highlight(steth)

			addtimer(CALLBACK(src, PROC_REF(organ_tutorial_heart)), 14 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_heart()

	message_to_player("<b>Section 1.2: Heart Damage</b>.")
	message_to_player("Despite their otherwise stone-cold exterior, the heart of a combat Marine is in actuality, quite delecate.") // naturally excepting members of Delta squad
	message_to_player("A damaged heart is the most common source of <b>Oxygen Damage</b> on the field, as even small amounts of <b>Heart Damage</b> proves capable of seriously impairing the human body.")
	message_to_player("Heart damage can be caused as a result of moving with an <b>Unsplinted Chest Fracture, Extreme Brute Damage</b>, or being shot by an <b>Armor Piercing Bullet</b>.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_heart_2)), 18 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_heart_2()
	message_to_player("Depending on the levels of damage to the heart, patients will experience escelating symptoms.")
	message_to_player("<b>Heart - Slightly Bruised (Damage: 1-9) |</b> Slowly creates up to 21 points of <b>Oxygen Damage</b>.")
	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_heart_3)), 8 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_heart_3()
	message_to_player("<b>Heart - Bruised (Damage: 10-29) |</b> Rapidly creates 50 points of <b>Oxygen Damage</b>, and continues to create Oxygen damage at a slower pace indefinitely past this point.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_heart_4)), 6 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_heart_4()
	message_to_player("<b>Heart - Broken (Damage: 30+) |</b> The Heart has been damaged so severely, that it can no longer function. A broken Heart will rapidly and indefinitely create <b>Oxygen and Toxin Damage</b>, with no damage limit.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_heart_5)), 6 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_heart_5()

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	human_dummy.apply_internal_damage(12, "heart")
	human_dummy.setOxyLoss(15)
	message_to_player("Mr Dummy has taken some <b>Internal Organ Damage</b> in his <b>Chest</b>! Use your <b>Stethoscope</b> on his chest to determine his condition.")

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/clothing/accessory/stethoscope, steth)
	add_highlight(steth, COLOR_GREEN)

	RegisterSignal(tutorial_mob, COMSIG_LIVING_STETHOSCOPE_USED, PROC_REF(organ_tutorial_heart_6))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_heart_6(datum/source, mob/living/carbon/human/being, mob/living/user)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	if(being != human_dummy)
		return
	else
		if(tutorial_mob.zone_selected != "chest")
			message_to_player("Make sure to have the Dummys <b>Chest</b> selected as your target. Use the <b>Zone Selection Element</b> on the bottom right of your hud to target the Dummys chest, and try again.")
		else
			UnregisterSignal(tutorial_mob, COMSIG_LIVING_STETHOSCOPE_USED)
			TUTORIAL_ATOM_FROM_TRACKING(/obj/item/clothing/accessory/stethoscope, steth)
			remove_highlight(steth)

			message_to_player("Well done! If you check the <b>Chat-Box</b>, your <b>Stethoscope</b> has reported that: you hear deviant heart beating patterns, result of <u>probable heart damage</u>.")
			message_to_player("This tells you that Mr Dummy's Heart is <b>Bruised</b>, and will begin creating <b>Oxygen Damage</b> in his body.")

			addtimer(CALLBACK(src, PROC_REF(organ_tutorial_heart_7_pre)), 6 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_heart_7_pre(obj/item/storage/pill_bottle)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	var/obj/item/storage/pill_bottle/dex = new /obj/item/storage/pill_bottle
	medbelt.handle_item_insertion(dex)
	medbelt.update_icon()

	dex.name = "\improper Dexalin pill bottle"
	dex.icon_state = "pill_canister1"
	dex.maptext_label = "Dx"
	dex.maptext = SPAN_LANGCHAT("Dx")
	dex.max_storage_space = 1
	dex.overlays.Cut()
	dex.bottle_lid = FALSE
	dex.overlays += "pills_closed"

	var/obj/item/reagent_container/pill/dexalin/pill = new(dex)

	add_to_tracking_atoms(pill)
	add_to_tracking_atoms(dex)


	message_to_player("To counteract this, a <b>Dexalin Pill Bottle</b> has been placed in your <b>M276 Lifesaver Bag</b>.")
	message_to_player("Feed the Dummy a <b>Dexalin Pill</b> to heal the <b>Oxygen Damage</b> created by his bruised Heart.")
	message_to_player("Click on the <b>M276 Lifesaver Bag</b> with an empty hand to open it, then click on the <b>Dexalin Pill Bottle</b> to draw a pill.")

	add_highlight(medbelt, COLOR_GREEN)
	add_highlight(dex, COLOR_GREEN)

	RegisterSignal(pill, COMSIG_ITEM_DRAWN_FROM_STORAGE, PROC_REF(organ_tutorial_heart_7))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_heart_7()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, dex)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/pill/dexalin, pill)

	UnregisterSignal(pill, COMSIG_ITEM_DRAWN_FROM_STORAGE)


	message_to_player("Good. Now click on the Dummy while holding the <b>Dexalin Pill</b> and standing next to them to medicate it.")
	update_objective("Feed the Dummy the Dexalin pill.")

	add_highlight(pill, COLOR_GREEN)
	remove_highlight(medbelt)
	remove_highlight(dex)

	RegisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED, PROC_REF(dex_pill_fed_reject))
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	RegisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED, PROC_REF(dex_pill_fed))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/dex_pill_fed_reject()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED)
	var/mob/living/living_mob = tutorial_mob
	living_mob.rejuvenate()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, dex)
	remove_highlight(dex)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	remove_from_tracking_atoms(dex)
	qdel(dex)
	medbelt.update_icon()
	message_to_player("Dont feed yourself the pill, try again.")
	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_heart_7_pre)), 2 SECONDS)


/datum/tutorial/marine/hospital_corpsman_advanced/proc/dex_pill_fed(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, dex)
	remove_highlight(dex)
	remove_from_tracking_atoms(dex)
	qdel(dex)

	message_to_player("Well done. The Dexalin will slowly begin to reduce the amount of Oxygen damage in the Dummys body.")
	message_to_player("However, the Dexalin in the Dummys body is only counteracting the Oxygen damage created by the bruised Heart, and not any of its other side-effects.")
	message_to_player("This is where the chemical <b>Peridaxon</b> comes in to play.")
	message_to_player("<b>Peridaxon</b> is, without a doubt, the most useful tool at a Medics disposal when treating various types of organ damage.")
	message_to_player("When fed to a patient suffering from <b>Internal Organ Damage</b>, a <b>Peridaxon Pill</b> can <u>TEMPORARILY</u> return damaged internal organs to a fully healthy state.")
	message_to_player("However, this does <b>NOT</b> actually heal damaged organs, and all symptoms will return once the Peridaxon has been fully metabolized.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_heart_8_pre)), 24 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_heart_8_pre(obj/item/storage/pill_bottle)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	var/obj/item/storage/pill_bottle/peri = new /obj/item/storage/pill_bottle
	medbelt.handle_item_insertion(peri)
	medbelt.update_icon()

	peri.name = "\improper Peridaxon pill bottle"
	peri.icon_state = "pill_canister10"
	peri.maptext_label = "Pr"
	peri.maptext = SPAN_LANGCHAT("Pr")
	peri.max_storage_space = 1
	peri.overlays.Cut()
	peri.bottle_lid = FALSE
	peri.overlays += "pills_closed"

	var/obj/item/reagent_container/pill/peridaxon/peripill = new(peri)

	add_to_tracking_atoms(peripill)
	add_to_tracking_atoms(peri)


	message_to_player("A <b>Peridaxon Pill Bottle</b> has been placed in your <b>M276 Lifesaver Bag</b>.")
	message_to_player("Click on the <b>M276 Lifesaver Bag</b> with an empty hand to open it, then click on the <b>Peridaxon Pill Bottle</b> to draw a pill.")

	add_highlight(medbelt, COLOR_GREEN)
	add_highlight(peri, COLOR_GREEN)

	RegisterSignal(peripill, COMSIG_ITEM_DRAWN_FROM_STORAGE, PROC_REF(organ_tutorial_heart_8))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_heart_8()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, peri)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/pill/peridaxon, peripill)

	UnregisterSignal(peripill, COMSIG_ITEM_DRAWN_FROM_STORAGE)


	message_to_player("Good. Now click on the Dummy while holding the <b>Peridaxon Pill</b> and standing next to them to medicate it.")
	update_objective("Feed the Dummy the Peridaxon pill.")

	add_highlight(peripill, COLOR_GREEN)
	remove_highlight(medbelt)
	remove_highlight(peri)

	RegisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED, PROC_REF(peri_pill_fed_reject))
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	RegisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED, PROC_REF(peri_pill_fed))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/peri_pill_fed_reject()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED)
	var/mob/living/living_mob = tutorial_mob
	living_mob.rejuvenate()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, peri)
	remove_highlight(peri)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	remove_from_tracking_atoms(peri)
	qdel(peri)
	medbelt.update_icon()
	message_to_player("Dont feed yourself the pill, try again.")
	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_heart_8_pre)), 2 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/peri_pill_fed(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, peri)
	remove_highlight(peri)
	remove_from_tracking_atoms(peri)
	qdel(peri)

	message_to_player("Well done! The Dummys condition has been stabilized.. at least until the medication wears off.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_lungs)), 4 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_lungs()

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	human_dummy.rejuvenate()

	message_to_player("<b>Section 1.3: Lung Damage</b>.")

	message_to_player("As you may have guessed, the second vital organ in the chest is of course, the <b>Lungs</b>!")
	message_to_player("The Lungs, alongside other functions, allow Marines to breathe while carrying out their combat-related duties.")
	message_to_player("Like Heart damage, <b>Lung Damage</b> can be caused by moving with an <b>Unsplinted Chest Fracture, Extreme Brute Damage</b>, or being shot by an <b>Armor Piercing Bullet</b>.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_lungs_2)), 18 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_lungs_2()

	message_to_player("However, unlike Heart damage, symptoms of <b>Lung Damage</b> will only appear <u>beyond the point of rupture</u>.")
	message_to_player("A <b>Bruised Lung</b> will generate no harmful side-effects on the body, but is still detectable with a <b>Stethoscope</b>.")
	message_to_player("Once the Lungs have taken more than <b>30 Points of Internal Damage</b>, they will become <b>Ruptured</b>.")
	message_to_player("<b>Ruptured Lungs</b> will create <b>Oxygen Damage</b> at a rapid pace, as well as causing afflicted patients to cough up blood.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_lungs_3)), 18 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_lungs_3()

	message_to_player("Mr Dummys Lungs are looking rather squishy... Use your <b>Stethoscope</b> to test the condition of his <b>Lungs</b>.")

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	human_dummy.apply_internal_damage(35, "lungs")
	human_dummy.setOxyLoss(15)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/clothing/accessory/stethoscope, steth)
	add_highlight(steth, COLOR_GREEN)

	RegisterSignal(tutorial_mob, COMSIG_LIVING_STETHOSCOPE_USED, PROC_REF(organ_tutorial_lungs_4))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_lungs_4(datum/source, mob/living/carbon/human/being, mob/living/user)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_STETHOSCOPE_USED)

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	if(being != human_dummy)
		return
	else
		if(tutorial_mob.zone_selected != "chest")
			message_to_player("Make sure to have the Dummys <b>Chest</b> selected as your target. Use the <b>Zone Selection Element</b> on the bottom right of your hud to target the Dummys chest, and try again.")
		else
			UnregisterSignal(tutorial_mob, COMSIG_LIVING_STETHOSCOPE_USED)
			TUTORIAL_ATOM_FROM_TRACKING(/obj/item/clothing/accessory/stethoscope, steth)
			remove_highlight(steth)

			message_to_player("Well done! If you check the <b>Chat-Box</b>, your <b>Stethoscope</b> has reported that: you [SPAN_RED("barely hear any respiration sounds")] and a lot of difficulty to breath, the Dummys lungs are [SPAN_RED("heavily failing")]")
			message_to_player("This tells you that Mr Dummys Lungs have <b>Ruptured</b>, and <u>need to be stabilized immediately</u>.")

			addtimer(CALLBACK(src, PROC_REF(organ_tutorial_lungs_5)), 11 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_lungs_5(datum/source, obj/item/storage/pill_bottle)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	var/obj/item/storage/pill_bottle/dex = new /obj/item/storage/pill_bottle
	medbelt.handle_item_insertion(dex)
	medbelt.update_icon()

	dex.name = "\improper Dexalin pill bottle"
	dex.icon_state = "pill_canister1"
	dex.maptext_label = "Dx"
	dex.maptext = SPAN_LANGCHAT("Dx")
	dex.max_storage_space = 1
	dex.overlays.Cut()
	dex.bottle_lid = FALSE
	dex.overlays += "pills_closed"

	var/obj/item/reagent_container/pill/dexalin/pill = new(dex)

	add_to_tracking_atoms(pill)
	add_to_tracking_atoms(dex)


	message_to_player("To counteract the immediate <b>Oxygen Damage</b>, a <b>Dexalin Pill Bottle</b> has been placed in your <b>M276 Lifesaver Bag</b>.")
	message_to_player("Click on the <b>M276 Lifesaver Bag</b> with an empty hand to open it, then click on the <b>Dexalin Pill Bottle</b> to draw a pill.")

	add_highlight(medbelt, COLOR_GREEN)
	add_highlight(dex, COLOR_GREEN)

	RegisterSignal(pill, COMSIG_ITEM_DRAWN_FROM_STORAGE, PROC_REF(organ_tutorial_lungs_6))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_lungs_6()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, dex)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/pill/dexalin, pill)

	UnregisterSignal(pill, COMSIG_ITEM_DRAWN_FROM_STORAGE)


	message_to_player("Good. Now click on the Dummy while holding the <b>Dexalin Pill</b> and standing next to them to medicate it.")
	update_objective("Feed the Dummy the Dexalin pill.")

	add_highlight(pill, COLOR_GREEN)
	remove_highlight(medbelt)
	remove_highlight(dex)

	RegisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED, PROC_REF(dex_pill_fed_reject_2))
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	RegisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED, PROC_REF(dex_pill_fed_2))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/dex_pill_fed_reject_2()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED)
	var/mob/living/living_mob = tutorial_mob
	living_mob.rejuvenate()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, dex)
	remove_highlight(dex)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	remove_from_tracking_atoms(dex)
	qdel(dex)
	medbelt.update_icon()
	message_to_player("Dont feed yourself the pill, try again.")
	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_lungs_5)), 2 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/dex_pill_fed_2(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, dex)
	remove_highlight(dex)
	remove_from_tracking_atoms(dex)
	qdel(dex)

	message_to_player("Well done. Next, we need to stabilize Mr Dummys <b>Ruptured Lungs</b> with <b>Peridaxon</b>.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_lungs_7)), 5 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_lungs_7(obj/item/storage/pill_bottle)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	var/obj/item/storage/pill_bottle/peri = new /obj/item/storage/pill_bottle
	medbelt.handle_item_insertion(peri)
	medbelt.update_icon()

	peri.name = "\improper Peridaxon pill bottle"
	peri.icon_state = "pill_canister10"
	peri.maptext_label = "Pr"
	peri.maptext = SPAN_LANGCHAT("Pr")
	peri.max_storage_space = 1
	peri.overlays.Cut()
	peri.bottle_lid = FALSE
	peri.overlays += "pills_closed"

	var/obj/item/reagent_container/pill/peridaxon/peripill = new(peri)

	add_to_tracking_atoms(peripill)
	add_to_tracking_atoms(peri)


	message_to_player("A <b>Peridaxon Pill Bottle</b> has been placed in your <b>M276 Lifesaver Bag</b>.")
	message_to_player("Click on the <b>M276 Lifesaver Bag</b> with an empty hand to open it, then click on the <b>Peridaxon Pill Bottle</b> to draw a pill.")

	add_highlight(medbelt, COLOR_GREEN)
	add_highlight(peri, COLOR_GREEN)

	RegisterSignal(peripill, COMSIG_ITEM_DRAWN_FROM_STORAGE, PROC_REF(organ_tutorial_lungs_8))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_lungs_8()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, peri)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/pill/peridaxon, peripill)

	UnregisterSignal(peripill, COMSIG_ITEM_DRAWN_FROM_STORAGE)


	message_to_player("Good. Now click on the Dummy while holding the <b>Peridaxon Pill</b> and standing next to them to medicate it.")
	update_objective("Feed the Dummy the Peridaxon pill.")

	add_highlight(peripill, COLOR_GREEN)
	remove_highlight(medbelt)
	remove_highlight(peri)

	RegisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED, PROC_REF(peri_pill_fed_reject_2))
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	RegisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED, PROC_REF(peri_pill_fed_2))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/peri_pill_fed_reject_2()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED)
	var/mob/living/living_mob = tutorial_mob
	living_mob.rejuvenate()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, peri)
	remove_highlight(peri)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	remove_from_tracking_atoms(peri)
	qdel(peri)
	medbelt.update_icon()
	message_to_player("Dont feed yourself the pill, try again.")
	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_lungs_7)), 2 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/peri_pill_fed_2(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, peri)
	remove_highlight(peri)
	remove_from_tracking_atoms(peri)
	qdel(peri)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/clothing/accessory/stethoscope, steth)
	remove_highlight(steth)
	remove_from_tracking_atoms(steth)
	qdel(steth)

	message_to_player("Well done! The Dummys condition has been stabilized.")
	message_to_player("However, one Peridaxon pill will be fully metabolized in just over <u>5 minutes</u>, at which point full symptoms will return.")
	message_to_player("Once you have stabilized a patient with a ruptured organ, you <u>MUST</u> transport them to a <b>Trained Doctor for Surgery</b> as <u>SOON AS POSSIBLE</u>.")

	human_dummy.rejuvenate()

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_head)), 10 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_head()

	message_to_player("<b>Section 1.4: Internal Organ Damage (Head)</b>.")
	message_to_player("Inside the skulls of most Marines, a <b>Brain</b> and <b>Eyes</b> can typically be found.")
	message_to_player("While the presence of the former is sometimes debated in particular Marines, a Hospital Corpsman remains responsible for the health of both.")
	message_to_player("Both Brain and Eye damage are directly caused as a result of excessive <b>Brute Damage Injuries</b> to head.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_head_2)), 19 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_head_2()

	message_to_player("In addition to <b>Brute Damage</b>, Brain Damage is also caused by <b>Tricordrazine overdose</b>, and <b>Brain Hemorrhaging</b> (to be covered further on)")
	message_to_player("Symptoms of a <b>Bruised Brain</b> can include randomly dropping held items, sudden unconsciousness, erratic movements, headaches, and impaired vision.")
	message_to_player("As well as this, symptoms of a <b>Ruptured Brain</b> brain can <u>also include</u> sudden seizures, and paralysis.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_head_3)), 15 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_head_3()

	message_to_player("<b>Brain</b> and <b>Eye</b> damage can be detected in a patient using a simple <b>Pen Light</b>!")
	message_to_player("Pick up the <b>Pen Light</b>, then press <b>[retrieve_bind("activate_inhand")]</b> to switch its light on.")

	var/obj/item/device/flashlight/pen/pen = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(pen)
	add_highlight(pen, COLOR_GREEN)

	RegisterSignal(tutorial_mob, COMSIG_MOB_ITEM_ATTACK_SELF, PROC_REF(organ_tutorial_head_4))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_head_4(datum/source, obj/item/used)
	SIGNAL_HANDLER

	if(!istype(used, /obj/item/device/flashlight/pen))
		return

	UnregisterSignal(tutorial_mob, COMSIG_MOB_ITEM_ATTACK_SELF)

	message_to_player("Well done!")
	message_to_player("Now, use the <b>Zone Selection Element</b> on the bottom right of your HUD to target the <b>Eyes</b>, a smaller zone within the Head.")
	message_to_player("Once this is done, make sure you are on the green <b>Help Intent</b>, then click on the Dummy with your <b>Pen Light</b> in hand to test for damage to the organs in their head.")

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	human_dummy.apply_internal_damage(35, "eyes")
	human_dummy.apply_internal_damage(15, "brain")

	RegisterSignal(tutorial_mob, COMSIG_LIVING_PENLIGHT_USED, PROC_REF(organ_tutorial_head_5))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_head_5(datum/source, mob/living/carbon/human/being, mob/living/user)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	if(being != human_dummy)
		return
	else
		if(tutorial_mob.zone_selected != "eyes")
			message_to_player("Make sure to have the Dummys <b>Eyes</b> selected as your target. Use the <b>Zone Selection Element</b> on the bottom right of your hud to target the Dummys Eyes, and try again.")
		else
			UnregisterSignal(tutorial_mob, COMSIG_LIVING_PENLIGHT_USED)
			TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/flashlight/pen, pen)
			remove_highlight(pen)

			message_to_player("Well done! If you check the <b>Chat-Box</b>, your <b>Pen Light</b> has reported that: notice that the Dummys eyes are not reacting to the light, and the pupils of both eyes are not constricting with the light shine at all, the Dummy is probably [SPAN_RED("blind")].")
			message_to_player("We also see that: the Dummys pupils are not consensually constricting when light is separately applied to each eye, meaning possible [SPAN_ORANGE("brain damage")].")
			message_to_player("This tells you that Mr Dummy has <b>Broken Eyes</b> and a <b>Bruised Brain</b>.")

			addtimer(CALLBACK(src, PROC_REF(organ_tutorial_head_6)), 16 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_head_6()

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/flashlight/pen, pen)
	remove_from_tracking_atoms(pen)
	qdel(pen)
	message_to_player("The only way to treat Brain and Eye damage without surgical intervention, is through the use of <b>Custom Chemical Medications</b>.")
	message_to_player("<b>Custom Chemical Medications</b> describes any medicine that must be specifically synthesised by a <u>trained Chemist</u> in the Almayer Medical Bay.")
	message_to_player("Imidazoline-Alkysine <b>(IA)</b> is one such custom medication that is used to heal <b>Brain and Eye Damage</b> on the field.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_head_7)), 16 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_head_7(obj/item/storage/pill_bottle)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	var/obj/item/storage/pill_bottle/ia = new /obj/item/storage/pill_bottle
	medbelt.handle_item_insertion(ia)
	medbelt.update_icon()

	ia.name = "\improper IA pill bottle"
	ia.icon_state = "pill_canister11"
	ia.maptext_label = "IA"
	ia.maptext = SPAN_LANGCHAT("IA")
	ia.max_storage_space = 1
	ia.overlays.Cut()
	ia.bottle_lid = FALSE
	ia.overlays += "pills_closed"

	var/obj/item/reagent_container/pill/imialky/iapill = new(ia)

	add_to_tracking_atoms(iapill)
	add_to_tracking_atoms(ia)


	message_to_player("An <b>IA Pill Bottle</b> has been placed in your <b>M276 Lifesaver Bag</b>.")
	message_to_player("Click on the <b>M276 Lifesaver Bag</b> with an empty hand to open it, then click on the <b>IA Pill Bottle</b> to draw a pill.")

	add_highlight(medbelt, COLOR_GREEN)
	add_highlight(ia, COLOR_GREEN)

	RegisterSignal(iapill, COMSIG_ITEM_DRAWN_FROM_STORAGE, PROC_REF(organ_tutorial_head_8))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_head_8()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, ia)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/pill/imialky, iapill)

	UnregisterSignal(iapill, COMSIG_ITEM_DRAWN_FROM_STORAGE)


	message_to_player("Good. Now click on the Dummy while holding the <b>IA Pill</b> and standing next to them to medicate it.")
	update_objective("Feed the Dummy the IA pill.")

	add_highlight(iapill, COLOR_GREEN)
	remove_highlight(medbelt)
	remove_highlight(ia)

	RegisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED, PROC_REF(ia_pill_fed_reject_2))
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	RegisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED, PROC_REF(ia_pill_fed_2))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/ia_pill_fed_reject_2()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED)
	var/mob/living/living_mob = tutorial_mob
	living_mob.rejuvenate()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, ia)
	remove_highlight(ia)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	remove_from_tracking_atoms(ia)
	qdel(ia)
	medbelt.update_icon()
	message_to_player("Dont feed yourself the pill, try again.")
	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_head_7)), 2 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/ia_pill_fed_2(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_PILL_FED)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, ia)
	remove_highlight(ia)
	remove_from_tracking_atoms(ia)
	qdel(ia)

	message_to_player("Well done! The Dummys condition has been stabilized, and their Brain/Eye damage will rapidly heal.")

	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_tox)), 5 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_tox()

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	human_dummy.rejuvenate()

	message_to_player("<b>Section 1.5: Liver and Kidney Damage</b>.")

	message_to_player("The Liver and Kidney, located in the Chest and Groin respectively, are the final two internal organs to be covered in this tutorial.")
	message_to_player("Both organs can be damaged by moving with an <b>Unsplinted Bone Fracture</b> in their respective regions, as well as from extreme amounts of <b>Brute damage</b> to either area.")
	message_to_player("Both the Liver and Kidney are <u>extremely vulnerable</u> to <b>Toxin Damage</b> in the body.")
	message_to_player("This includes <b>Alcohol Poisoning</b> in the case of the Liver <u>specifically</u>.")
	addtimer(CALLBACK(src, PROC_REF(organ_tutorial_tox_2)), 19 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/organ_tutorial_tox_2()

	message_to_player("When damaged, both the Liver and Kidney will create <b>Toxin Damage</b> in the body, corresponding to the amount of damage they have <u>already taken</u>.")
	message_to_player("If not stabilized, this will create a feedback loop of endless <b>Toxin Damage</b>, eventually resulting in the complete failure of both organs.")
	message_to_player("Damage to the Liver and Kidney can only be treated via <u>surgical intervention</u>.")
	message_to_player("Marines with high levels of <b>Toxin Damage</b> in their body without an obvious cause, are likely suffering from internal organ damage to their Liver or Kidney.")

	addtimer(CALLBACK(src, PROC_REF(section_2)), 19 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/section_2()

	message_to_player("<b>Section 2: Revivals</b>.")
	message_to_player("Try as we might to prevent it, death is an inevitability within the Marine Corps.")
	message_to_player("However, to a trained Marine <b>Hospital Corpsman</b>, death is not the end!")
	message_to_player("In this section of the tutorial, we will go over various methods of awakening the dead, from a purely medical standpoint.")

	addtimer(CALLBACK(src, PROC_REF(defib_tutorial_pre)), 17 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/defib_tutorial_pre()

	message_to_player("Once the heart stops beating and bloodflow is cut from the brain, the Human body enters a state known as <b>Clinical Death</b>.")
	message_to_player("Once the body experiences <b>Clinical Death</b>, the lack of oxygen supplied to the brain will quickly cause it to deteriorate.")
	message_to_player("If left untreated, a <b>Clinically Dead</b> Marine has exactly <b>5 Minutes</b> before their brain has deteriorated beyond the point of <b>Biological Death</b>.")
	message_to_player("Biological Death, also known as <b>Perma-Death</b>, represents the threshold in which someone's condition has surpassed our abilities of care. Nothing more can be done for them.")

	addtimer(CALLBACK(src, PROC_REF(defib_tutorial)), 20 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/defib_tutorial()

	message_to_player("<b>Section 2.1: Defibrillations</b>.")
	message_to_player("In that 5 minute window between clinical and biological death, it is possible to perform a <b>Defibrillation</b>, and restart the heart!")
	message_to_player("While not at all similar to the <i>actual</i> process of revival, the vital functions of a body in <u>reasonable condition</u> can be fully restored through the use of a <b>Defibrillator</b>!")

	addtimer(CALLBACK(src, PROC_REF(defib_tutorial_2)), 13 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/defib_tutorial_2()

	message_to_player("In short, <b>Defibrillators</b> work by administering a small <b>Electric Shock</b> to the Heart of a dead Marine, causing it to briefly sieze up, before resuming a regular heartbeat.")
	message_to_player("Each <b>Defibrillator</b> comes with an inbuilt <b>Power-Cell</b> for storing charge and two <b>Contact Paddles</b> transferring said charge.")
	message_to_player("The easiest way to learn how to use a <b>Defibrillator</b> properly can be found through a hands-on approach!")
	message_to_player("Let's set the scene, shall we?")

	addtimer(CALLBACK(src, PROC_REF(defib_tutorial_3)), 15 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/defib_tutorial_3()

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	var/datum/effect_system/spark_spread/sparks = new
	sparks.set_up(5, 1, human_dummy.loc)
	sparks.start()
	remove_from_tracking_atoms(human_dummy)
	var/mob/living/carbon/human/realistic_dummy/marine_dummy = new(human_dummy.loc)
	arm_equipment(marine_dummy, /datum/equipment_preset/other/realistic_dummy)
	add_to_tracking_atoms(marine_dummy)
	qdel(human_dummy)
	var/obj/item/clothing/suit/storage/marine/medium/armor = marine_dummy.get_item_by_slot(WEAR_JACKET)
	add_to_tracking_atoms(armor)

	message_to_player("This is <b>Private Stanley</b>! He will be our new test-subject for the remainder of the tutorial.")

	addtimer(CALLBACK(src, PROC_REF(defib_tutorial_4)), 4 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/defib_tutorial_4()

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)
	marine_dummy.revive_grace_period = INFINITY // surely nothing can go wrong
	marine_dummy.adjustBruteLoss(100)
	marine_dummy.death()
	marine_dummy.updatehealth()
	add_highlight(marine_dummy, COLOR_RED)

	message_to_player("Oh no! It appears Pvt Stanley has dropped dead!!")

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	add_highlight(healthanalyzer, COLOR_GREEN)

	message_to_player("This is indicated by two things: the Healthbar above Stanleys head is now <b>Empty</b>, and a <b>Heart-Rate Icon</b> is visible to the top-left of his body.")
	message_to_player("The first step to any revival, is always a <b>Health Scan</b>! Draw your <b>Health Analyzer</b> and scan Private Stanleys condition.")

	RegisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED, PROC_REF(defib_tutorial_5))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/defib_tutorial_5(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	if(attacked_mob == tutorial_mob)
		return

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	remove_highlight(healthanalyzer)

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)
	remove_highlight(marine_dummy)
	UnregisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED)

	var/obj/item/device/defibrillator/defib = new(loc_from_corner(0,4))
	add_to_tracking_atoms(defib)
	add_highlight(defib, COLOR_GREEN)

	message_to_player("As you can see listed on your <b>Health Analyzer</b> scan, Private Stanleys status is listed as: <u>Cardiac arrest, defibrillation possible</u>.")
	message_to_player("Secondly, by looking at the damage amounts on Stanleys body, we see that he has sustained <u>less than 200 damage</u> overall.")
	message_to_player("This is extremely important, as defibrillation is only possible when a patients <u>overall damage is less than 200</u>, for all types of damage <u>besides Oxygen</u>.")
	message_to_player("This means that we are able to restart Stanleys heart using a <b>Defibrillator</b>! Pick up your brand new Defibrillator from the desk!")

	RegisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM, PROC_REF(defib_tutorial_6))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/defib_tutorial_6(datum/source, obj/item/picked_up)

	if(!(istype(picked_up, /obj/item/device/defibrillator)))
		return

	UnregisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM)

	message_to_player("Before we can use the <b>Defibrillator</b> on Private Stanley, we must remove his <b>Bodyarmor</b>!")
	message_to_player("Click and drag your mouse from Private Stanleys body to yours, then when his inventory appears on your screen, click on his <b>Chestplate</b> to remove it!")

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)
	add_highlight(marine_dummy, COLOR_GREEN)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/clothing/suit/storage/marine/medium, armor)

	RegisterSignal(armor, COMSIG_ITEM_UNEQUIPPED, PROC_REF(defib_tutorial_7))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/defib_tutorial_7()

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/clothing/suit/storage/marine/medium, armor)
	UnregisterSignal(armor, COMSIG_ITEM_UNEQUIPPED)
	message_to_player("As the final step before reviving Private Stanley, we must first detach the <b>Defibrillators Contact Paddles</b>.")
	message_to_player("Hold your <b>Defibrillator</b> in hand, and press the <b>[retrieve_bind("activate_inhand")]</b> key to take out the <b>Contact Paddles</b>!")

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/defibrillator, defib)

	RegisterSignal(defib, COMSIG_ITEM_ATTACK_SELF, PROC_REF(defib_tutorial_8))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/defib_tutorial_8()

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/defibrillator, defib)
	UnregisterSignal(defib, COMSIG_ITEM_ATTACK_SELF)

	message_to_player("Clear!! Time to get to <b>Defibrillating</b> Private Stanley! Click on his body with your Defib, and hold still while it delivers its charge!")

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)
	RegisterSignal(marine_dummy, COMSIG_HUMAN_REVIVED, PROC_REF(defib_tutorial_9))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/defib_tutorial_9()

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)
	UnregisterSignal(marine_dummy, COMSIG_HUMAN_REVIVED)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/defibrillator, defib)
	remove_highlight(defib)
	remove_from_tracking_atoms(defib)
	QDEL_IN(defib, 2 SECONDS)

	message_to_player("Well done! Private Stanley lives again!")
	message_to_player("However, Private Stanley still has a large amount of <b>Brute Damage</b> across his body")

	handle_pill_bottle(marine_dummy, "Bicaridine", "Bi", "11", /obj/item/reagent_container/pill/bicaridine)
	RegisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_RETURN, PROC_REF(defib_tutorial_10))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/defib_tutorial_10()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_RETURN)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)
	marine_dummy.rejuvenate()

	message_to_player("Well done! Private Stanley will now fully recover from his injuries, and be allowed back on the front lines of battle!")

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/clothing/suit/storage/marine/medium, armor)
	marine_dummy.equip_to_slot_or_del(armor, WEAR_JACKET)

	addtimer(CALLBACK(src, PROC_REF(revival_condition_tutorial)), 4 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/revival_condition_tutorial()

	message_to_player("<b>Section 2.2: Revival Conditions</b>")
	slower_message_to_player("As stated earlier in section 1.1, there exists only a limited window of time in which revivals are possible for a deceased patient.")
	slower_message_to_player("Barring extremely rare exceptions, the human brain can only last <b>5 minutes</b> without a steady supply of oxygen before experiencing <u>irreversible deterioration</u>.")
	slower_message_to_player("As a patient progresses through this 5 minute window, their deteriorating state will be indicated by the <b>Revival Icon</b> to the top-left of their body.")

	addtimer(CALLBACK(src, PROC_REF(revival_condition_tutorial_1)), 26 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/revival_condition_tutorial_1()

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)
	var/datum/effect_system/spark_spread/sparks = new
	sparks.set_up(5, 1, marine_dummy.loc)
	sparks.start()

	if(!(stage > 0))
		slower_message_to_player("Oh goodness! It appears Private Stanley has once again dropped dead! Note that his invisible <b>5 Minute Perma-Death Timer</b> has now started.")
		slower_message_to_player("As you can see, just like the section prior, Private Stanleys <b>Revival Icon</b> is <b>Green</b>, meaning he has <u>more than half his revival timer left</u> (more than 2.5 minutes)")

		marine_dummy.revive_grace_period = INFINITY // surely nothing can go wrong... right?... guys??
		marine_dummy.death()
		marine_dummy.updatehealth()
		add_highlight(marine_dummy, COLOR_GREEN)
		stage++
		addtimer(CALLBACK(src, PROC_REF(revival_condition_tutorial_1)), 15 SECONDS)
		return
	if(stage == 1)
		marine_dummy.revive_grace_period = 2.4 MINUTES // yellow yellow!
		marine_dummy.updatehealth()

		slower_message_to_player("However, lets fast-forward a bit..")
		slower_message_to_player("After 2 and a half minutes, Private Stanley's <b>Revival Icon</b> has changed to <b>Yellow/Organge Flashes</b>.")
		slower_message_to_player("This indicates that he has <u>less than half his revival timer left</u>!")

		add_highlight(marine_dummy, LIGHT_COLOR_ORANGE)

		stage++
		addtimer(CALLBACK(src, PROC_REF(revival_condition_tutorial_1)), 16 SECONDS)
		return
	if(stage == 2)
		marine_dummy.revive_grace_period = 1.15 MINUTES // red red!!!
		marine_dummy.updatehealth()

		slower_message_to_player("Jumping forwards once again, Private Stanley's <b>Revival Icon</b> is now <b>Flashing Red</b>!")
		slower_message_to_player("This means that Stanley has <u>less than 60 seconds to be revived</u> before he expires <b>for good</b>, known as <b>Perma-Death/Biological Death</b>.")
		slower_message_to_player("This state is known in slang terms as 'going red', 'redlining' or 'flatlining'.")
		slower_message_to_player("Unless you are operating on a patient who is also flatlining, you MUST drop whatever you are doing to assist REGARDLESS of if another Medic is already treating them.")
		slower_message_to_player("If a Medic is already treating the patient, approach and ask 'How can I help?'.")
		slower_message_to_player("Flatlining patients will always be your <u>#1 PRIORITY</u> of care on the field.")

		add_highlight(marine_dummy, COLOR_DARK_RED)

		stage++
		addtimer(CALLBACK(src, PROC_REF(revival_condition_tutorial_1)), 38 SECONDS)
		return
	if(stage == 3)
		marine_dummy.revive_grace_period = 0 // BREATHE DAMN IT! BREATHE!!
		marine_dummy.updatehealth() // I'm... sorry, Doc...

		slower_message_to_player("It seems that, despite everything, Private Stanley has slipped through our fingers.")
		slower_message_to_player("After their full <b>Revival Timer</b> has elapsed, a patient will enter <b>Biological/Perma-Death</b>, and their <b>Revival Icon</b> will be replaced with a <b>Skull</b>.")
		slower_message_to_player("Barring <b>EXTREMELY</b> rare circumstances, this is the end of the line for any patient. You should pick up your tools, and move on.")

		add_highlight(marine_dummy, COLOR_BLACK)
		marine_dummy.status_flags &= ~FAKESOUL // I know... what kind of man you are

		stage++
		addtimer(CALLBACK(src, PROC_REF(revival_condition_tutorial_1)), 18 SECONDS)
		return
	if(stage > 3)
		marine_dummy.revive_grace_period = INFINITY
		marine_dummy.rejuvenate() // DNR doesnt play nice
		marine_dummy.death()
		marine_dummy.updatehealth()

		slower_message_to_player("The final common type of revival status you will come across, is <b>DNR</b>, or <b>Do Not Resuscitate</b>.")
		slower_message_to_player("Indicated by a flat red line, the <b>DNR</b> icon indicates that a patient has either <b>Opted-Out</b> of being revived, or has <b>disconnected from the game</b>.")
		slower_message_to_player("For the purposes of treatment, a <b>DNR</b> patiend should be viewed as if they were <b>Perma-Dead</b>.")

		stage = 0
		addtimer(CALLBACK(src, PROC_REF(revival_condition_tutorial_2)), 16 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/revival_condition_tutorial_2()

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)
	var/datum/effect_system/spark_spread/sparks = new
	sparks.set_up(5, 1, marine_dummy.loc)
	sparks.start()

	marine_dummy.revive_grace_period = 5 MINUTES // back to normal, phew..
	marine_dummy.status_flags |= FAKESOUL
	marine_dummy.rejuvenate()
	marine_dummy.updatehealth()
	remove_highlight(marine_dummy)

	message_to_player("Luckily for Private Stanley, he still has the favor of the gods, and will live again!")
	addtimer(CALLBACK(src, PROC_REF(cpr_tutorial)), 3 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/cpr_tutorial()

	if(stage == 0)
		message_to_player("<b>Section 2.3: Delivering CPR</b>.")
		slower_message_to_player("Knowing how and when to perform CPR on a patient, can easily become the difference between life or death in a combat environment.")
		slower_message_to_player("CPR works by manually operating the lungs of a critically wounded patient, and allowing oxygen back into their bloodstream, and supplied to <b>Brain</b>.")
		slower_message_to_player("Performing CPR on a patient will both <u>reduce their Oxygen damage</u> levels, as well as slowing or preventing the rate at which they accumulate more Oxygen damage.")

		stage++
		addtimer(CALLBACK(src, PROC_REF(cpr_tutorial)), 23 SECONDS)
		return
	if(stage == 1)
		slower_message_to_player("Most importantly, CPR can also be used on dead (but still revivable) Marines to <b>Extend their Revival Timer</b>!")
		slower_message_to_player("Like CPR in the real world, it must be done with timing in mind.")
		slower_message_to_player("One round of CPR takes <u>4 seconds to complete</u>, and adds <u>7 seconds to a patients Revival Timer</u> if successful.")
		slower_message_to_player("You <u>MUST</u> wait at least <u>3 SECONDS</u> between rounds of CPR, otherwise you will fail the procedure.")

		stage++
		addtimer(CALLBACK(src, PROC_REF(cpr_tutorial)), 24 SECONDS)
		return
	if(stage == 2)
		TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)
		var/datum/effect_system/spark_spread/sparks = new
		sparks.set_up(5, 1, marine_dummy.loc)
		sparks.start()

		marine_dummy.revive_grace_period = 5 MINUTES
		marine_dummy.death()
		marine_dummy.updatehealth()
		add_highlight(marine_dummy, COLOR_GREEN)

		slower_message_to_player("Private Stanley has once again dropped dead! We are going to practice <b>CPR</b> to <b>Extend his Revival Timer</b>")
		slower_message_to_player("To perform <b>CPR</b>, make sure you are on the green <b>Help Intent</b> and <u>neither of you are wearing face coverings</u>.")
		slower_message_to_player("Then, click on Private Stanley with an empty hand, and hold still while <b>CPR</b> is performed!")

		RegisterSignal(tutorial_mob, COMSIG_HUMAN_CPR_PERFORMED, PROC_REF(cpr_tutorial_1))
		stage = 0
		return

/datum/tutorial/marine/hospital_corpsman_advanced/proc/cpr_tutorial_1(datum/source, successful)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)
	if(successful != TRUE)
		message_to_player("Bad luck! You made a mistake in the rhythm, and failed a round of CPR. You'll have to try again from the start.")
		message_to_player("Remember to count in your head: <u>4 seconds to perform, 3 seconds between</u>. Give it another go!")
		cpr_count = 0
		return
	if(successful == TRUE)
		if(cpr_count == 0)
			message_to_player("Well done! To get you into the rhythm of CPR, we are going to perform <b>CPR</b> 4 times in a row on Private Stanley!")
			cpr_count++
			return
		if((cpr_count > 0) && (cpr_count != 4))
			message_to_player("One down! <b>[4 - cpr_count]</b> to go!!")
			cpr_count++
			return
		if(cpr_count > 3)
			message_to_player("4 in a row! Thats some serious skill you have!")
			cpr_count = 0
	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_CPR_PERFORMED)
	slower_message_to_player("Even if you aren't playing as a Hospital Corpsman, performing CPR on critically injured Marines can still make you a lifesaver!")
	remove_highlight(marine_dummy)
	addtimer(CALLBACK(src, PROC_REF(field_surgery)), 5 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/revival_mix_tutorial()
	SIGNAL_HANDLER

	if(stage == 0)
		message_to_player("<b>Section 2.4: Assisted Revivals</b>.")
		slower_message_to_player("As you know, to successfully revive a non-breathing patient using a <b>Defibrillator</b>, their overall damage must be <u>below 200</u> (NOT including Oxygen damage).")
		slower_message_to_player("However, when using a <b>Defibrillator</b>, you are provided some leeway on the amount of overall damage.")
		slower_message_to_player("When you use a <b>Defibrillator</b> on a patient, regardless of revival outcome, it will heal <u>12 damage</u> of each <u>DIFFERENT DAMAGE TYPE</u> (not including Oxygen).")
		addtimer(CALLBACK(src, PROC_REF(revival_mix_tutorial)), 25 SECONDS)
		stage++
		return
	if(stage == 1)
		slower_message_to_player("Be warned, despite the large healing potential of the <b>Defibrillator</b>, repeated usage will apply large amounts of <b>Heart Damage</b> to the patient, requiring surgical intervention.")
		slower_message_to_player("If the overall damage levels of a patient (not including Oxygen damage) are below 200 <u>AFTER</u> the <b>Defibrillator</b> has applied its 12 points of healing, the revival will be <b>Successful</b>!")

		addtimer(CALLBACK(src, PROC_REF(revival_mix_tutorial)), 17 SECONDS)
		stage++
		return
	if(stage == 2)
		slower_message_to_player("As well as a <b>Defibrillators Healing Factor</b> of 12 damage, a chemical called <b>Epinephrine</b> (aka. Adrenaline) can be used to apply an additional 20 Points of Healing per defibrillation, per damage type!")

		addtimer(CALLBACK(src, PROC_REF(revival_mix_tutorial)), 7 SECONDS)
		stage++
		return
	if(stage == 3)
		slower_message_to_player("<b>Epinephrine</b> has an <b>Overdose of 10.5 units</b>, and <u>MUST BE INJECTED</u> into the body to work.")
		slower_message_to_player("This means that, with <b>Epinephrine</b> in a patients system, one defibrillation can heal: <b>32 Brute, 32 Burn, and 32 Toxin</b> damage in a single use!")
		stage = 0
	addtimer(CALLBACK(src, PROC_REF(revival_mix_tutorial_1)), 15 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/revival_mix_tutorial_1()

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)

	if(stage == 0)
		var/obj/item/storage/pouch/pressurized_reagent_canister/revival_tricord/revivalmix = new(loc_from_corner(1,4))
		var/obj/item/reagent_container/hypospray/autoinjector/empty/medic/revivalpen = locate(/obj/item/reagent_container/hypospray/autoinjector/empty/medic) in revivalmix.contents
		add_to_tracking_atoms(revivalmix)
		add_to_tracking_atoms(revivalpen)
		add_highlight(revivalmix, COLOR_GREEN)

		slower_message_to_player("<b>Epinephrine</b> is primarily found in a <b>Pressurized Reagent Canister</b>, in the form of a chemical cocktail called <b>Revival Mix</b>.")
		slower_message_to_player("A new <b>Pressurized Reagent Canister</b> has appeared on your desk! Pick it up and equip it to a <b>Pouch Slot</b> by pressing <b>[retrieve_bind("quick_equip")]</b>.")

		RegisterSignal(revivalmix, COMSIG_ITEM_EQUIPPED, PROC_REF(revival_mix_tutorial_1))
		stage++
		return

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pouch/pressurized_reagent_canister/revival_tricord, revivalmix)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/empty/medic, revivalpen)

	if(stage == 1)
		UnregisterSignal(revivalmix, COMSIG_ITEM_EQUIPPED)
		slower_message_to_player("Inside every <b>Pressurized Reagent Canister</b>, an <b>Autoinjector</b> comes pre-loaded, set to deliver <b>15 Chemical Units</b> of the canisters contents per injection.")
		slower_message_to_player("Since we have been supplied with the <b>Tricordrazine</b> variant of <b>Revival Mix</b>, your <b>Pressurized Reagent Canisters Autoinjector</b> will deliver <u>5u of Tricordrazine, Inaprovaline, and Epinephrine per injection</u>.")

		addtimer(CALLBACK(src, PROC_REF(revival_mix_tutorial_1)), 15 SECONDS)
		stage++
		return
	if(stage == 2)
		UnregisterSignal(revivalpen, COMSIG_ITEM_DRAWN_FROM_STORAGE)
		add_highlight(revivalpen, COLOR_GREEN)
		message_to_player("We will now run through the use case for <b>Revival Mix and Epinephrine</b> on the field.")

		var/datum/effect_system/spark_spread/sparks = new
		sparks.set_up(5, 1, marine_dummy.loc)
		sparks.start()

		marine_dummy.adjustBruteLoss(120)
		marine_dummy.adjustFireLoss(120)
		marine_dummy.revive_grace_period = INFINITY
		marine_dummy.death()
		marine_dummy.updatehealth()
		add_highlight(marine_dummy, COLOR_GREEN)

		TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
		add_highlight(healthanalyzer, COLOR_GREEN)
		remove_highlight(revivalmix)

		slower_message_to_player("Private Stanley is dead yet again. Before attempting a revival, you will first scan his condition with a <b>Health Analyzer</b>.")

		RegisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED, PROC_REF(revival_mix_tutorial_2))
		stage = 0

/datum/tutorial/marine/hospital_corpsman_advanced/proc/revival_mix_tutorial_2(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	if(attacked_mob == tutorial_mob)
		return

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)
	remove_highlight(marine_dummy)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/healthanalyzer, healthanalyzer)
	remove_highlight(healthanalyzer)

	slower_message_to_player("As you can see on your <b>Health Analyzer Interface</b>, Private Stanley has <b>120 Brute Damage</b> and <b>120 Burn Damage</b>, adding up to <b>240 Damage in Total</b>.")
	slower_message_to_player("Using a regular Defibrillator, only 12 Brute and Burn damage would be healed, leaving Private Stanley above the 200 overall damage mark, causing the revival attempt to <b>Fail</b>.")
	slower_message_to_player("Instead, we are going to inject Stanley with <b>Revival Mix</b>, allowing us to heal an <u>additional</u> 20 Brute and Burn damage when defibrillating, allowing a <b>Successful Revival</b>!")
	message_to_player("Click on your <b>Pressurized Reagent Canister</b> with an empty hand to draw its stored <b>Autoinjector</b>.")

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pouch/pressurized_reagent_canister/revival_tricord, revivalmix)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/empty/medic, revivalpen)
	add_highlight(revivalmix, COLOR_GREEN)
	RegisterSignal(revivalpen, COMSIG_ITEM_DRAWN_FROM_STORAGE, PROC_REF(revival_mix_tutorial_3))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/revival_mix_tutorial_3()

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pouch/pressurized_reagent_canister/revival_tricord, revivalmix)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/empty/medic, revivalpen)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)

	if(stage == 0)
		UnregisterSignal(revivalpen, COMSIG_ITEM_DRAWN_FROM_STORAGE)
		remove_highlight(revivalmix)
		add_highlight(revivalpen, COLOR_GREEN)
		add_highlight(marine_dummy, COLOR_GREEN)
		message_to_player("Good, now click on Private Stanley with your Autoinjector in hand to inject him with a shot of <b>Revival Mix</b>.")
		RegisterSignal(marine_dummy, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(revival_mix_tutorial_3))
		stage++
		return
	if(stage == 1)
		UnregisterSignal(marine_dummy, COMSIG_LIVING_HYPOSPRAY_INJECTED)
		remove_highlight(revivalpen)

		slower_message_to_player("Excellent. Place your <b>Revival Mix Autoinjector</b> back in its Reagent Canister to store and refill it after use.")
		slower_message_to_player("Private Stanley is now ready for <b>Defibrillation</b>.")
		slower_message_to_player("Remove his <b>Armor</b>, pick up the <b>Defibrillator</b> from the desk, detach its contact paddles, and use it to <b>Revive Private Stanley</b>!")

		var/obj/item/device/defibrillator/defib = new(loc_from_corner(0,4))
		add_to_tracking_atoms(defib)
		add_highlight(defib, COLOR_GREEN)

		RegisterSignal(marine_dummy, COMSIG_HUMAN_REVIVED, PROC_REF(revival_mix_tutorial_3))
		stage++
		return
	if(stage == 2)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/defibrillator, defib)
		UnregisterSignal(marine_dummy, COMSIG_HUMAN_REVIVED)
		remove_highlight(marine_dummy)
		remove_highlight(defib)
		remove_from_tracking_atoms(defib)
		remove_from_tracking_atoms(revivalpen)
		remove_from_tracking_atoms(revivalmix)
		var/cleanup = list(defib, revivalpen, revivalmix)
		QDEL_LIST_IN(cleanup, 2 SECONDS)

		marine_dummy.rejuvenate()
		marine_dummy.revive_grace_period = 5 MINUTES
		TUTORIAL_ATOM_FROM_TRACKING(/obj/item/clothing/suit/storage/marine/medium, armor)
		marine_dummy.equip_to_slot_or_del(armor, WEAR_JACKET)
		stage = 0

	slower_message_to_player("Great work! As you can see, with the help of <b>Epinephrine</b> and <b>Revival Mix</b>, Private Stanley was able to be revived!")
	slower_message_to_player("Note that, with each attempted <b>Defibrillation</b> successful or not, 1u of <b>Epinephrine</b> will be consumed in the patients body.")

	addtimer(CALLBACK(src, PROC_REF(field_surgery)), 7 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery()

	message_to_player("<b>Section 3: Field Surgery</b>.")
	message_to_player("In this section of the tutorial, we will cover a more hands-on method of medical treatment on the field.")
	message_to_player("All Marine Hospital Corpsmen have been trained in basic surgery procedures.")
	message_to_player("This allows you to carry out simple, but highly effective procedures to heal injured Marines far closer to the frontlines than any Doctor could.")

	addtimer(CALLBACK(src, PROC_REF(field_surgery_brute)), 18 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_brute()

	message_to_player("<b>Section 3.1: Surgical Damage Treatment (Brute)</b>.")
	message_to_player("When dealing with large amounts of mundane damage focused on a specific region of the body, damage kits will prove ineffective.")
	message_to_player("This is where <b>Surgical Damage Treatment</b> comes into play!")
	message_to_player("Using tools like the <b>Surgical Line</b> (Brute) and <b>Synth-Graft</b> (Burn), a trained Hospital Corpsman can surgically treat damage for specific parts of the body")

	addtimer(CALLBACK(src, PROC_REF(field_surgery_brute_2)), 15 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_brute_2()

	message_to_player("Oh no! Mr Dummy has taken a large amount of <b>Brute Damage</b>! Scan him with your <b>Health Analyzer</b> for more details.")

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)
	marine_dummy.rejuvenate()
	marine_dummy.apply_damage(35, BRUTE, "chest")
	RegisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED, PROC_REF(field_surgery_brute_3))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_brute_3(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	if(attacked_mob == tutorial_mob)
		return

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)
	UnregisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED)

	message_to_player("As you can see, the Dummy has <b>35 Brute Damage</b> on their chest.")
	message_to_player("To treat this, we are going to surgically <b>Suture</b> their wounds with a <b>Surgical Line</b>.")
	message_to_player("But first, we must apply a painkiller to the Dummy, to avoid complications during surgery.")
	message_to_player("For surgeries that <u>dont</u> require an incision, Tramadol will act as a sufficient painkiller.")

	addtimer(CALLBACK(src, PROC_REF(field_surgery_brute_4)), 12 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_brute_4()
	SIGNAL_HANDLER

	message_to_player("A <b>Tramadol Pill Bottle</b> has been placed into your <b>M276 Lifesaver Bag</b>.")
	message_to_player("Click on the <b>M276 Lifesaver Bag</b> with an empty hand to open it, then click on the <b>Tramadol Pill Bottle</b> to draw a pill.")

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)

	var/obj/item/storage/pill_bottle/tram = new /obj/item/storage/pill_bottle
	medbelt.handle_item_insertion(tram)

	medbelt.update_icon()

	tram.name = "\improper Tramadol pill bottle"
	tram.icon_state = "pill_canister5"
	tram.maptext_label = "Tr"
	tram.maptext = SPAN_LANGCHAT("Tr")
	tram.max_storage_space = 1
	tram.overlays.Cut()
	tram.bottle_lid = FALSE
	tram.overlays += "pills_closed"
	var/obj/item/reagent_container/pill/tramadol/trampill = new(tram)

	add_to_tracking_atoms(trampill)
	add_to_tracking_atoms(tram)

	add_highlight(medbelt, COLOR_GREEN)
	add_highlight(tram, COLOR_GREEN)

	RegisterSignal(trampill, COMSIG_ITEM_DRAWN_FROM_STORAGE, PROC_REF(field_surgery_brute_5))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_brute_5()

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, tram)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/pill/tramadol, trampill)

	UnregisterSignal(trampill, COMSIG_ITEM_DRAWN_FROM_STORAGE)


	message_to_player("Good. Now click on the Dummy while holding the <b>Tramadol Pill</b> and standing next to them to medicate it.")
	update_objective("Feed the Dummy the Tramadol pill.")

	add_highlight(trampill, COLOR_GREEN)
	remove_highlight(medbelt)
	remove_highlight(tram)

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)
	RegisterSignal(marine_dummy, COMSIG_HUMAN_PILL_FED, PROC_REF(tram_pill_fed))
	RegisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED, PROC_REF(tram_pill_fed_reject))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/tram_pill_fed_reject()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)
	UnregisterSignal(marine_dummy, COMSIG_HUMAN_PILL_FED)
	var/mob/living/living_mob = tutorial_mob
	living_mob.rejuvenate()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, tram)
	remove_highlight(tram)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	remove_from_tracking_atoms(tram)
	qdel(tram)
	medbelt.update_icon()
	message_to_player("Dont feed yourself the pill, try again.")
	addtimer(CALLBACK(src, PROC_REF(field_surgery_brute_3)), 2 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/tram_pill_fed()
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)
	UnregisterSignal(marine_dummy, COMSIG_HUMAN_PILL_FED)
	marine_dummy.pain.feels_pain = FALSE //failsafe

	message_to_player("Now that Mr Dummy has been medicated with a painkiller, we can begin surgery on their chest.")
	message_to_player("Pick up the <b>Surgical Line</b> on the desk, and click on Mr Dummy with it while <u>targeting his chest</u> to begin the surgery")
	message_to_player("Your <b>Surgical Line</b> will heal small portions of damage in repeating intervals until up to <u>half</u> of the regions overall damage.")
	message_to_player("Stand next to the Dummy and dont move until the surgery has been fully completed")

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, tram)
	remove_highlight(tram)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	remove_from_tracking_atoms(tram)
	qdel(tram)
	medbelt.update_icon()

	var/obj/item/tool/surgery/surgical_line/surgical_line = new(loc_from_corner(1,4))
	add_to_tracking_atoms(surgical_line)
	add_highlight(surgical_line, COLOR_GREEN)

	var/obj/limb/chest/mob_chest = locate(/obj/limb/chest) in marine_dummy.limbs
	add_to_tracking_atoms(mob_chest)
	add_highlight(mob_chest, COLOR_GREEN)

	RegisterSignal(mob_chest, COMSIG_LIMB_FULLY_SUTURED, PROC_REF(field_surgery_brute_6))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_brute_6()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/limb/chest, mob_chest)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/tool/surgery/surgical_line, surgical_line)

	UnregisterSignal(mob_chest, COMSIG_LIMB_FULLY_SUTURED)
	remove_highlight(mob_chest)
	remove_highlight(surgical_line)

	message_to_player("Well done! As said earlier, suturing wounds can only heal up to <u>half</u> of the regions overall damage, and should be used alongside other methods of treatment.")
	message_to_player("Surgical damage treatment is useful as it can be carried out indefinitely, albeit slowly on the field.")

	addtimer(CALLBACK(src, PROC_REF(field_surgery_burn)), 8 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_burn()

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/tool/surgery/surgical_line, surgical_line)
	remove_from_tracking_atoms(surgical_line)
	qdel(surgical_line)

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)
	marine_dummy.rejuvenate()
	marine_dummy.apply_damage(70, BURN, "chest")
	message_to_player("Like Brute damage treatment, <b>Burn Damage</b> can also be surgically treated using a <b>Synth-Graft</b>.")
	message_to_player("Mr Dummy has taken additional <b>Burn Damage</b> to his chest!")
	message_to_player("Pick up your <b>Synth-Graft</b>, and apply it to the Dummys <b>Chest</b>.")

	var/obj/item/tool/surgery/synthgraft/graft = new(loc_from_corner(1,4))
	add_to_tracking_atoms(graft)
	add_highlight(graft, COLOR_ORANGE)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/limb/chest, mob_chest)
	add_highlight(mob_chest, COLOR_ORANGE)

	RegisterSignal(mob_chest, COMSIG_LIMB_FULLY_SUTURED, PROC_REF(field_surgery_burn_2))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_burn_2()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/obj/limb/chest, mob_chest)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/tool/surgery/synthgraft, graft)

	UnregisterSignal(mob_chest, COMSIG_LIMB_FULLY_SUTURED)
	remove_highlight(mob_chest)
	remove_from_tracking_atoms(mob_chest)
	remove_highlight(graft)

	message_to_player("Well done! Mr Dummy has been healed!")

	addtimer(CALLBACK(src, PROC_REF(field_surgery_burn_3)), 2 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_burn_3()

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)
	marine_dummy.rejuvenate()
	marine_dummy.pain.feels_pain = TRUE
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/tool/surgery/synthgraft, graft)
	remove_from_tracking_atoms(graft)
	qdel(graft)

	addtimer(CALLBACK(src, PROC_REF(field_surgery_ib)), 1 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_ib()

	message_to_player("<b>Section 3.2: Internal Bleeding</b>.")
	message_to_player("As mentioned across both this, and the basic Hospital Corpsman tutorial, <b>Internal Bleeding</b> can appear as a dangerous side-effect of a wide range of injuries.")
	message_to_player("<b>Internal Bleeding</b> can be caused by extreme Brute damage, Armor Piercing attacks, or moving with an <b>Unsplinted Bone Fracture</b>.")
	message_to_player("If left untreated, Internal Bleeding will quickly lead to extreme <b>Blood Loss</b>.")

	addtimer(CALLBACK(src, PROC_REF(field_surgery_ib_2)), 16 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_ib_2()

	message_to_player("<b>Internal Bleeding</b> requires invasive surgical treatment. Including a <b>Surgical Incision</b>.")
	message_to_player("While not as extensively fitted as a proper surgical kit, Combat Medics recieve a <b>Basic Surgical Case</b> for field use.")

	var/obj/item/storage/surgical_case/regular/surgical_case = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(surgical_case)
	add_highlight(surgical_case, COLOR_GREEN)

	message_to_player("Pickup your <b>Basic Surgical Case</b>, highlighted in green!")

	RegisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM, PROC_REF(field_surgery_ib_3))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_ib_3()

	UnregisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM)

	message_to_player("Excellent! Your <b>Basic Surgical Case</b> comes pre-fitted with three tools; a <b>Scalpel, Hemostat, and Retractor</b>.")
	message_to_player("These can be used to create <b>Incisions</b> on the body, which are the first step to most surgeries.")

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/surgical_case/regular, surgical_case)
	remove_highlight(surgical_case)

	addtimer(CALLBACK(src, PROC_REF(field_surgery_ib_4)), 8 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_ib_4()

	var/obj/item/roller/foldedroller = new(loc_from_corner(1, 4))
	add_to_tracking_atoms(foldedroller)
	add_highlight(foldedroller, COLOR_GREEN)

	message_to_player("Some surgeries require the patient to be laying down on a secure surface, such as an Operating Table.")
	message_to_player("However, for the purposes of field surgery, we will have to make do with a <b>Roller Bed</b>.")
	message_to_player("<b>Roller Beds</b> serve a dual function, being able to quickly transport patients, as well as acting as a <b>Secure Surface</b> to carry out surgeries.")
	message_to_player("Pickup the <b>Folded Roller Bed</b>, walk to the middle of the room, then press the <b>[retrieve_bind("activate_inhand")]</b> key while holding it in hand to unfold it.")

	RegisterSignal(tutorial_mob, COMSIG_MOB_ITEM_ROLLER_DEPLOYED, PROC_REF(field_surgery_ib_5))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_ib_5(datum/source, obj/structure/bed/roller/rollerdeployed)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_MOB_ITEM_ROLLER_DEPLOYED)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/roller, foldedroller)
	remove_highlight(foldedroller)
	remove_from_tracking_atoms(foldedroller)

	add_to_tracking_atoms(rollerdeployed)
	add_highlight(rollerdeployed, COLOR_GREEN)
	rollerdeployed.anchored = TRUE

	message_to_player("Excellent! Now, to prepare Mr Dummy for surgery, we need to buckle him to the Roller Bed.")
	message_to_player("Set your intent to the yellow <b>Grab Intent</b>, and click on Mr Dummy to grab them.")

	RegisterSignal(tutorial_mob, COMSIG_MOB_GRAB_PASSIVE, PROC_REF(field_surgery_ib_6))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_ib_6(datum/source, mob/target)

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)

	if(target != marine_dummy)
		return

	UnregisterSignal(tutorial_mob, COMSIG_MOB_GRAB_PASSIVE)

	message_to_player("Then, drag them next to the <b>Roller Bed</b>, and click and drag your mouse from Mr Dummy, to the Roller bed to buckle them into it.")

	RegisterSignal(marine_dummy, COMSIG_LIVING_SET_BUCKLED, PROC_REF(field_surgery_ib_7))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_ib_7()

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)
	UnregisterSignal(marine_dummy, COMSIG_LIVING_SET_BUCKLED)

	message_to_player("Now, for the final step before Mr Dummy is ready for Surgery, we must inject him with a powerful painkiller.")

	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/bed/roller, rollerdeployed)
	remove_highlight(rollerdeployed)

	message_to_player("Since Internal Bleeding surgery requires an <b>Incision</b>, we must use a painkiller as strong as, or stronger than, <b>Oxycodone</b>.")

	message_to_player("An <b>Oxycodone Autoinjector</b> has been placed into your <b>M276 Lifesaver Bag</b>.")
	message_to_player("Use the Autoinjector on Mr Dummy by clicking on them, to administer the <b>Oxycodone</b>")

	var/obj/item/reagent_container/hypospray/autoinjector/oxycodone/one_use/oxy = new(loc_from_corner(0, 4))
	add_to_tracking_atoms(oxy)
	add_highlight(oxy, COLOR_GREEN)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
	medbelt.handle_item_insertion(oxy)
	medbelt.update_icon()

	RegisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(oxy_inject_self))
	RegisterSignal(marine_dummy, COMSIG_LIVING_HYPOSPRAY_INJECTED, PROC_REF(oxy_inject))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/oxy_inject_self()
	SIGNAL_HANDLER

	var/mob/living/living_mob = tutorial_mob
	living_mob.rejuvenate()
	living_mob.reagents.clear_reagents()
	message_to_player("Dont use the injector on yourself, try again.")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/oxycodone/one_use, oxy)
	remove_highlight(oxy)
	remove_from_tracking_atoms(oxy)
	qdel(oxy)
	addtimer(CALLBACK(src, PROC_REF(field_surgery_ib_7)), 4 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/oxy_inject()
	//adds a slight grace period, so humans are not rejuved before oxy is registered in their system

	message_to_player("Well done!")
	addtimer(CALLBACK(src, PROC_REF(field_surgery_ib_8)), 2 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_ib_8()

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/hypospray/autoinjector/oxycodone/one_use, oxy)
	remove_highlight(oxy)
	remove_from_tracking_atoms(oxy)
	qdel(oxy)

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)
	UnregisterSignal(tutorial_mob, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	UnregisterSignal(marine_dummy, COMSIG_LIVING_HYPOSPRAY_INJECTED)
	marine_dummy.pain.feels_pain = FALSE //surgery failsafe

	TUTORIAL_ATOM_FROM_TRACKING(/obj/limb/chest, mob_chest)
	var/datum/wound/internal_bleeding/IB = new (0)
	mob_chest.add_bleeding(IB, TRUE)
	mob_chest.wounds += IB

	message_to_player("Now, we will initiate an <b>Internal Bleeding</b> surgery on Mr Dummy.")
	message_to_player("First, draw your <b>Health Analyzer</b>, and scan Mr Dummy to locate the source of his Internal Bleeding.")

	RegisterSignal(marine_dummy, COMSIG_LIVING_HEALTH_ANALYZED, PROC_REF(field_surgery_ib_9))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_ib_9(datum/source, mob/living/carbon/human/attacked_mob)
	SIGNAL_HANDLER

	if(attacked_mob == tutorial_mob)
		return

	UnregisterSignal(attacked_mob, COMSIG_LIVING_HEALTH_ANALYZED)

	message_to_player("By looking at your <b>Health Analyzer</b> scan, we can see that Mr Dummy has <b>Internal Bleeding</b> in his <b>Chest</b>.")
	message_to_player("This must be treated urgently. We will begin the <b>Internal Bleeding Repair</b> surgery by making an <b>Incision</b> on Mr Dummys <b>Chest</b>.")
	message_to_player("Open your <b>Field Surgery Pouch</b> and draw the <b>Scalpel</b> from within.")

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/surgical_case/regular, surgical_case)
	add_highlight(surgical_case, COLOR_GREEN)

	var/obj/item/tool/surgery/scalpel/scalpel = locate(/obj/item/tool/surgery/scalpel) in surgical_case.contents
	add_to_tracking_atoms(scalpel)
	add_highlight(scalpel, COLOR_GREEN)

	RegisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM, PROC_REF(field_surgery_ib_10))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_ib_10(datum/source, obj/item/picked_up)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/tool/surgery/scalpel, scalpel)

	if(picked_up != scalpel)
		return

	UnregisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM)

	message_to_player("Now, make sure you are on the <b>Help Intent</b> with <b>Surgery Mode Enabled</b>, then click on Mr Dummy while holding your Scalpel to create an incision.")


	RegisterSignal(tutorial_mob, COMSIG_HUMAN_SURGERY_STEP_SUCCESS, PROC_REF(field_surgery_ib_11))

/datum/tutorial/marine/hospital_corpsman_advanced/proc/field_surgery_ib_11(datum/source, mob/living/carbon/target, datum/surgery/surgery, obj/item/tool)
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)

	if(target != marine_dummy)
		message_to_player("Operate on the Dummy, not yourself! Try again.")
		var/mob/living/living_mob = tutorial_mob
		living_mob.rejuvenate()
		return

	if(surgery.location != "chest")
		message_to_player("Operate on the Dummys chest! Try again.")
		return

	if(tool.name == "Hemostat")
		return

	if(surgery.name == "Open Incision")
		if(surgery.status == 1)
			TUTORIAL_ATOM_FROM_TRACKING(/obj/item/tool/surgery/scalpel, scalpel)
			remove_highlight(scalpel)
			remove_from_tracking_atoms(scalpel)
			message_to_player("Well done! Next, we will retract the skin around the incision with a <b>Retractor</b>.")
			message_to_player("Draw the <b>Retractor</b> from your <b>Field Surgery Kit</b> and use it on Mr Dummy.")

			TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/surgical_case/regular, surgical_case)
			var/obj/item/tool/surgery/retractor/retractor = locate(/obj/item/tool/surgery/retractor) in surgical_case.contents
			add_to_tracking_atoms(retractor)
			add_highlight(retractor, COLOR_GREEN)
			return

		if(surgery.status > 1)
			TUTORIAL_ATOM_FROM_TRACKING(/obj/item/tool/surgery/retractor, retractor)
			remove_highlight(retractor)
			remove_from_tracking_atoms(retractor)
			message_to_player("Mission complete! You have successfully created an incision of Mr Dummys chest.")
			message_to_player("We are now able to access and repair the source of <b>Internal Bleeding</b> in the Dummys chest.")
			message_to_player("To do this, we are going to once again use a <b>Surgical Line</b>.")
			message_to_player("Pickup the <b>Surgical Line</b> from the bench, and use it on Mr Dummy.")
			message_to_player("If you have done this step correctly, an options box will appear that allows you to either <b>Fix Mr Dummys Internal Bleeding</b>, or <b>Cauterize</b> your incision. Click the first option!")

			var/obj/item/tool/surgery/surgical_line/surgical_line = new(loc_from_corner(1,4))
			add_to_tracking_atoms(surgical_line)
			add_highlight(surgical_line, COLOR_GREEN)
			return

	if(surgery.name == "Internal Bleeding Repair")
		if(surgery.status == 1)
			message_to_player("Amazing work! Mr Dummy's condition has been stabilized!")
			message_to_player("Now, all that's left to do is to <b>Cauterize the Incision</b>. Use your <b>Surgical Line</b> on Mr Dummys chest one more time!")
			ontime = TRUE
			return

	if(surgery.name == "Suture Incision")
		if(ontime != TRUE)
			message_to_player("You have closed your incision before treating Mr Dummys internal bleeding. You will have to restart the procedure.")
			TUTORIAL_ATOM_FROM_TRACKING(/obj/item/tool/surgery/surgical_line, surgical_line)
			remove_from_tracking_atoms(surgical_line)
			remove_highlight(surgical_line)
			qdel(surgical_line)
			UnregisterSignal(tutorial_mob, COMSIG_HUMAN_SURGERY_STEP_SUCCESS)
			marine_dummy.rejuvenate()
			addtimer(CALLBACK(src, PROC_REF(field_surgery_ib_8)), 4 SECONDS)
			return
		else
			message_to_player("Congratulations, you are now fully qualified to repair internal bleeding on the field!")
			TUTORIAL_ATOM_FROM_TRACKING(/obj/item/tool/surgery/surgical_line, surgical_line)
			remove_from_tracking_atoms(surgical_line)
			remove_highlight(surgical_line)
			qdel(surgical_line)
			UnregisterSignal(tutorial_mob, COMSIG_HUMAN_SURGERY_STEP_SUCCESS)
			marine_dummy.rejuvenate()

/datum/tutorial/marine/hospital_corpsman_advanced/proc/tutorial_close()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)
	UnregisterSignal(marine_dummy, COMSIG_HUMAN_SHRAPNEL_REMOVED)

	message_to_player("This officially completes your basic training to be a Marine Horpital Corpsman. However, you still have some skills left to learn!")
	message_to_player("The <b>Hospital Corpsman <u>Advanced</u></b> tutorial will now be unlocked in your tutorial menu. Give it a go!")
	update_objective("Tutorial completed.")


	tutorial_end_in(15 SECONDS)



// Helpers

/**
* Handles the creation and describes the use of pill bottles and pills in HM tutorials
*
* NOT FOR USE OUTSIDE OF TUTORIAL SYSTEM
*
* Currently limited to /mob/living/carbon/human/realistic_dummy
*
* Will break if used more than once per proc, see add_to_tracking_atoms() limitations
*
* Arguments:
* * target Set to realistic_dummy of choosing
* * name Uppercased name of the selected chemical, in string form
* * maptext Sets the maptext_label variable for the created pill bottle, also a string
* * iconnumber Sets the icon for the created pill bottle, input a number string ONLY (IE: "1")
* * pill Typepath of the pill to place into the pill bottle
*/
/datum/tutorial/marine/hospital_corpsman_advanced/proc/handle_pill_bottle(target, name, maptext, iconnumber, pill)
	SIGNAL_HANDLER

	if(handle_pill_bottle_status == 0)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
		var/obj/item/storage/pill_bottle/bottle = new /obj/item/storage/pill_bottle
		medbelt.handle_item_insertion(bottle)
		medbelt.update_icon()

		bottle.name = "\improper [name] pill bottle"
		bottle.icon_state = "pill_canister[iconnumber]"
		bottle.maptext_label = "[maptext]"
		bottle.maptext = SPAN_LANGCHAT("[maptext]")
		bottle.max_storage_space = 1
		bottle.overlays.Cut()
		bottle.bottle_lid = FALSE
		bottle.overlays += "pills_closed"

		var/obj/item/reagent_container/pill/tpill = new pill(bottle) // tpill = tracking pill
		add_to_tracking_atoms(bottle)


		message_to_player("A <b>[name] Pill Bottle</b> has been placed in your <b>M276 Lifesaver Bag</b>.")
		message_to_player("Click on the <b>M276 Lifesaver Bag</b> with an empty hand to open it, then click on the <b>[name] Pill Bottle</b> to draw a pill.")

		add_highlight(medbelt, COLOR_GREEN)
		add_highlight(bottle, COLOR_GREEN)

		handle_pill_bottle_status++
		RegisterSignal(tpill, COMSIG_ITEM_DRAWN_FROM_STORAGE, PROC_REF(handle_pill_bottle))
		return

	if(handle_pill_bottle_status == 1)
		message_to_player("Good. Now click on the Dummy while holding the pill and standing next to them to medicate it.")

		TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, bottle)
		TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)

		UnregisterSignal(target, COMSIG_ITEM_DRAWN_FROM_STORAGE)

		add_highlight(target, COLOR_GREEN)
		remove_highlight(medbelt)
		remove_highlight(bottle)

		handle_pill_bottle_status++
		RegisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED, PROC_REF(handle_pill_bottle))
		RegisterSignal(marine_dummy, COMSIG_HUMAN_PILL_FED, PROC_REF(handle_pill_bottle))

		return

	if(handle_pill_bottle_status == 2)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/belt/medical/lifesaver, medbelt)
		TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/pill_bottle, bottle)
		TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human/realistic_dummy, marine_dummy)
		if(target == tutorial_mob)
			UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
			UnregisterSignal(target, COMSIG_HUMAN_PILL_FED)
			var/mob/living/living_mob = tutorial_mob
			living_mob.rejuvenate()
			remove_highlight(bottle)
			qdel(bottle)
			medbelt.update_icon()
			message_to_player("Dont feed yourself the pill, try again.")
			handle_pill_bottle_status = 0
			addtimer(CALLBACK(src, PROC_REF(handle_pill_bottle)), 2 SECONDS)
			return

		else if(target == marine_dummy)
			UnregisterSignal(tutorial_mob, COMSIG_HUMAN_PILL_FED)
			UnregisterSignal(target, COMSIG_HUMAN_PILL_FED)

			remove_highlight(bottle)
			QDEL_IN(bottle, 1 SECONDS)
			handle_pill_bottle_status = 0
			SEND_SIGNAL(tutorial_mob, COMSIG_MOB_TUTORIAL_HELPER_RETURN)

// Helpers End


// TO DO LIST
//
// apply slower messages
//
// fix helpers
//
// apply marine_dummy instead of human_dummy
//
// Section 1 - Stabilizing Types of Organ Damage
// 1.5 Liver and Kidney Damage
//
// Section 4 - Specialized Treatments
// 4.1 Medical Evacuations, Stasis
// 4.2 Genetic Damage
// 4.3 Extreme Overdoses
// 4.4 Synthetic Limb Repair
// 4.5 Blood Transfusions
//




/datum/tutorial/marine/hospital_corpsman_advanced/init_mob()
	. = ..()
	arm_equipment(tutorial_mob, /datum/equipment_preset/tutorial/fed)
	tutorial_mob.set_skills(/datum/skills/combat_medic)


/datum/tutorial/marine/hospital_corpsman_advanced/init_map()
	var/obj/structure/machinery/cm_vending/clothing/tutorial/medic/advanced/medical_vendor = new(loc_from_corner(4, 4))
	add_to_tracking_atoms(medical_vendor)