/datum/tutorial/marine/hospital_corpsman_advanced
	name = "Marine - Hospital Corpsman (Advanced)"
	desc = "Learn the more advanced skills required of a Marine Hospital Corpsman."
	tutorial_id = "marine_hm_2"
	//required_tutorial = "marine_hm_1"
	tutorial_template = /datum/map_template/tutorial/s7x7

// ------------ CONTENTS ------------ //
//
// Section 1 - Basic Damage Treatment
//

/datum/tutorial/marine/hospital_corpsman_advanced/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()
	message_to_player("This tutorial will teach you the fundamental skills for playing a Marine Hospital Corpsman.")
	addtimer(CALLBACK(src, PROC_REF(tutorial_close)), 4 SECONDS)








/datum/tutorial/marine/hospital_corpsman_advanced/proc/tutorial_close()
	SIGNAL_HANDLER

	TUTORIAL_ATOM_FROM_TRACKING(/mob/living/carbon/human, human_dummy)
	UnregisterSignal(human_dummy, COMSIG_HUMAN_SHRAPNEL_REMOVED)

	message_to_player("This officially completes your basic training to be a Marine Horpital Corpsman. However, you still have some skills left to learn!")
	message_to_player("The <b>Hospital Corpsman <u>Advanced</u></b> tutorial will now be unlocked in your tutorial menu. Give it a go!")
	update_objective("Tutorial completed.")


	tutorial_end_in(15 SECONDS)

/datum/tutorial/marine/hospital_corpsman_advanced/init_mob()
	. = ..()
	arm_equipment(tutorial_mob, /datum/equipment_preset/tutorial/fed)
	tutorial_mob.set_skills(/datum/skills/combat_medic)


/datum/tutorial/marine/hospital_corpsman_advanced/init_map()
	new /obj/structure/surface/table/almayer(loc_from_corner(0, 4))
