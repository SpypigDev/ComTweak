/datum/tutorial/marine/comtech
	name = "Comtech tutorial"
	tutorial_id = "marine_comtech_1"
	desc = "learn comtech"
	icon_state = "ss13"
	category = TUTORIAL_CATEGORY_MARINE
	tutorial_template = /datum/map_template/tutorial/s17x13/ct
	required_tutorial = "marine_basic_1"

/datum/tutorial/marine/comtech/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()
	message_to_player("This is the tutorial for marine rifleman. Leave the cryopod by pressing <b>[retrieve_bind("North")]</b> or <b>[retrieve_bind("East")]</b> to continue.")

// END OF SCRIPT HELPERS

/datum/tutorial/marine/comtech/init_mob()
	. = ..()
	arm_equipment(tutorial_mob, /datum/equipment_preset/tutorial)

	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cryopod/tutorial, tutorial_pod)
	tutorial_pod.go_in_cryopod(tutorial_mob, TRUE, FALSE)

/datum/tutorial/marine/comtech/init_map()
	var/area/misc/tutorial/tutorial_area = get_area(bottom_left_corner)
	var/list/tracking_markers = tutorial_area.atom_tracking_landmarks

	for(var/obj/effect/landmark/tutorial_tracking_marker/tracker in tracking_markers)
		if(!tracker.tracking_target_type)
			tracking_markers -= tracker
			continue
		var/atom/tracking_atom = locate(tracker.tracking_target_type) in tracker.loc
		if(!tracking_atom)
			continue
		add_to_tracking_atoms(tracking_atom)

