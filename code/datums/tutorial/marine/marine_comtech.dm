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
	wake_up_screen()

	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cryopod/tutorial, tutorial_pod)
	RegisterSignal(tutorial_pod, COMSIG_CRYOPOD_GO_OUT, PROC_REF(briefing_scene))

/datum/tutorial/marine/comtech/proc/briefing_scene()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cryopod/tutorial, tutorial_pod)
	UnregisterSignal(tutorial_pod, COMSIG_CRYOPOD_GO_OUT)

	var/message = "- INCOMING RADIO TRANSMISSION -"
	playsound_client(tutorial_mob.client, 'sound/machines/telephone/scout_ring.ogg', tutorial_mob, 35, FALSE)
	tutorial_mob.play_screen_text(message, /atom/movable/screen/text/screen_text/hypersleep_status)

	addtimer(CALLBACK(src, PROC_REF(briefing_scene_2)), 4 SECONDS)

/datum/tutorial/marine/comtech/proc/briefing_scene_2()
	playsound_client(tutorial_mob.client, 'sound/machines/telephone/scout_pick_up.ogg', tutorial_mob, 35, FALSE)

	var/list/scene_script = list(
		"This is the tutorial for marine rifleman. Leave the cryopod by pressing <b>[retrieve_bind("North")]</b> or <b>[retrieve_bind("East")]</b> to continue.",
		"you are super cool",
		"you are kinda a bit cool?"
	)

	var/scene_length = dynamic_potrait_timer(scene_script)

	//addtimer(CALLBACK(src, PROC_REF(briefing_scene_2)), scene_length)

/datum/tutorial/marine/comtech/proc/briefing_scene_3()
	playsound_client(tutorial_mob.client, 'sound/machines/telephone/scout_pick_up.ogg', tutorial_mob, 35, FALSE)

	var/list/scene_script = list(
		"This is the tutorial for marine rifleman. Leave the cryopod by pressing <b>[retrieve_bind("North")]</b> or <b>[retrieve_bind("East")]</b> to continue.",
		"you are super cool",
		"you are kinda a bit cool?"
	)

	var/scene_length = dynamic_script_timer(scene_script)

	//addtimer(CALLBACK(src, PROC_REF(briefing_scene_2)), scene_length)

/datum/tutorial/marine/comtech/message_to_player(message)
	playsound_client(tutorial_mob.client, 'sound/effects/radiostatic.ogg', tutorial_mob.loc, 25, FALSE)
	tutorial_mob.play_screen_text(message, /atom/movable/screen/text/screen_text/command_order/tutorial/dynamic, rgb(103, 214, 146))
	to_chat(tutorial_mob, SPAN_NOTICE(message))

/datum/tutorial/marine/comtech/proc/ideal_speech_time(message)
	if(length_char(message) >= 500)
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

/datum/tutorial/marine/comtech/Destroy(force)
	var/area/misc/tutorial/tutorial_area = get_area(bottom_left_corner)
	var/list/tracking_markers = tutorial_area.atom_tracking_landmarks
	QDEL_LIST(tracking_markers)
	return ..()


// TEMPCODE

/datum/tutorial/marine/comtech/proc/portrait_speech(text)
	var/list/speech_sounds = list(
		'sound/machines/telephone/talk_phone4.ogg',
		'sound/machines/telephone/talk_phone2.ogg',
		'sound/machines/telephone/talk_phone3.ogg',
	)
	playsound_client(tutorial_mob.client, pick(speech_sounds), tutorial_mob, 25, FALSE)
	tutorial_mob.play_screen_text("<span class='langchat' style=font-size:24pt;text-align:left valign='top'><u>Command Update:</u></span><br>" + text, new /atom/movable/screen/text/screen_text/potrait(null, null, "Steve Muppy", 'icons/ui_icons/screen_alert_images.dmi', "overwatch_green"), rgb(103, 214, 146))

/datum/tutorial/marine/comtech/proc/dynamic_potrait_timer(list/input_script)
	var/scene_length = 0 SECONDS	// multiplier included for readability
	var/list/scene_script = input_script.Copy()

	if(!length(scene_script))
		return FALSE

	for(var/speech_line in scene_script)
		var/line_duration = ideal_speech_time("<span class='langchat' style=font-size:24pt;text-align:left valign='top'><u>Command Update:</u></span><br>" + speech_line) + 0.5 SECONDS
		if(!line_duration)
			continue
		addtimer(CALLBACK(src, PROC_REF(portrait_speech), speech_line), scene_length)
		scene_length |= line_duration

	return scene_length

/datum/tutorial/marine/comtech/proc/wake_up_screen()
	var/mob/living/carbon/human/target = tutorial_mob
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cryopod/tutorial, tutorial_pod)
	playsound_client(target.client, 'sound/machines/tcomms_on.ogg', tutorial_pod, 25, FALSE)
	target.overlay_fullscreen_timer(8 SECONDS, 10, "roundstart1", /atom/movable/screen/fullscreen/black)
	target.overlay_fullscreen_timer(8 SECONDS, 10, "roundstartcrt1", /atom/movable/screen/fullscreen/crt)
	var/message = "GENERAL QUARTERS ORDER RECIEVED<br><br>ALERT LEVEL: RED<br>ALL HANDS ON DECK!<br><br>THAWING LV-975 PERSONNEL<br><br>OCCUPANT REM:NOMINAL"
	tutorial_mob.play_screen_text(message, /atom/movable/screen/text/screen_text/hypersleep_status)

/datum/tutorial/marine/comtech/proc/dynamic_script_timer(input_script)
	var/scene_length = 0 SECONDS	// multiplier included for readability
	var/list/scene_script = input_script

	if(!length(scene_script))
		return FALSE

	for(var/speech_line in scene_script)
		var/line_duration = ideal_speech_time(speech_line) + 0.5 SECONDS
		if(!line_duration)
			continue
		addtimer(CALLBACK(src, PROC_REF(message_to_player), speech_line), scene_length)
		scene_length |= line_duration

	return scene_length
