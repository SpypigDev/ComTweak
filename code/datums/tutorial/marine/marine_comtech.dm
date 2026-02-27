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

/datum/tutorial/marine/comtech/proc/briefing_scene()
	var/scene_length = 0 SECONDS	// multiplier included for readability
	var/list/scene_script = list(
		"This is the tutorial for marine rifleman. Leave the cryopod by pressing <b>[retrieve_bind("North")]</b> or <b>[retrieve_bind("East")]</b> to continue.",
		"you are super cool",
		"you are kinda a bit cool?"
	)

	for(var/speech_line in scene_script)
		var/line_duration = ideal_speech_time(speech_line) + 0.5 SECONDS
		if(!line_duration)
			continue
		addtimer(CALLBACK(src, PROC_REF(message_to_player), speech_line), scene_length)
		scene_length |= line_duration

	addtimer(CALLBACK(src, PROC_REF(briefing_scene_2)), scene_length)

/datum/tutorial/marine/comtech/proc/briefing_scene_2()
	return

/datum/tutorial/marine/comtech/message_to_player(message)
	playsound_client(tutorial_mob.client, 'sound/effects/radiostatic.ogg', tutorial_mob.loc, 25, FALSE)
	tutorial_mob.play_screen_text(message, /atom/movable/screen/text/screen_text/command_order/tutorial/dynamic, rgb(103, 214, 146))
	to_chat(tutorial_mob, SPAN_NOTICE(message))

/datum/tutorial/marine/comtech/proc/ideal_speech_time(message)
	if(length_char(message) >= 200)
		return FALSE

	var/aproximate_word_count = 0

	for(var/character in 1 to length_char(message))
		// ASCII 32 = spacebar thing
		if(text2ascii(message, character) == 32)
			aproximate_word_count++
		character++

	if(!aproximate_word_count)
		return FALSE

	// roughly 150 words per minute
	var/time_to_speak = (round(aproximate_word_count / 3, 0.1) + 1.5) SECONDS

	return time_to_speak

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
			return
		add_to_tracking_atoms(tracking_atom)

