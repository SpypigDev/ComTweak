/datum/tutorial/marine/comtech
	name = "Comtech tutorial"
	tutorial_id = "marine_comtech_1"
	desc = "learn comtech"
	icon_state = "ss13"
	category = TUTORIAL_CATEGORY_MARINE
	tutorial_template = /datum/map_template/tutorial/s17x13/ct
	required_tutorial = "marine_basic_1"
	var/scene_override = FALSE

/datum/tutorial/marine/comtech/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()
	if(scene_override)
		briefing_scene_3()
		return
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
		"Good morning Marine! You arrived just in time for the action.",
		"Those terrorizing colonist bastards have just sent another rocket barrage our way!!",
		"We have anti-air batteries preparing to-"
	)

	var/scene_length = dynamic_potrait_timer(scene_script)

	addtimer(CALLBACK(src, PROC_REF(rocket_strike_1)), (scene_length + 2 SECONDS))
	addtimer(CALLBACK(src, PROC_REF(rocket_strike_2)), (scene_length + 7 SECONDS))
	addtimer(CALLBACK(src, PROC_REF(briefing_scene_3)), (scene_length + 10 SECONDS))

/datum/tutorial/marine/comtech/proc/rocket_strike_1()
	playsound_client(tutorial_mob.client, 'sound/effects/missile_warning.ogg', tutorial_mob, 25, FALSE)
	playsound_client(tutorial_mob.client, 'sound/effects/antiair_explosions.ogg', tutorial_mob, 25, FALSE)
	shake_camera(tutorial_mob, 11, 2)

/datum/tutorial/marine/comtech/proc/rocket_strike_2()
	playsound_client(tutorial_mob.client, 'sound/machines/telephone/scout_remote_hangup.ogg', tutorial_mob, 45, FALSE)
	playsound_client(tutorial_mob.client, 'sound/effects/explosionfar.ogg', tutorial_mob, 35, FALSE)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/light/double, light)
	addtimer(CALLBACK(light, TYPE_PROC_REF(/obj/structure/machinery/light/double, broken)), 1 SECONDS)
	tutorial_mob.play_screen_text("<span class='langchat' style=font-size:24pt;text-align:left valign='top'><u>Anti-Air Command:</u></span><br>" + "<i>static...</i>  That's a hit!", new /atom/movable/screen/text/screen_text/potrait(null, null, "Lt. Ramirez", 'icons/ui_icons/screen_alert_images.dmi', "overwatch_3_green"), rgb(103, 214, 146))

/datum/tutorial/marine/comtech/proc/briefing_scene_3()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/door/airlock/almayer/maint, door)
	door.open(TRUE)
	door.lock(TRUE)
	var/datum/effect_system/spark_spread/spark = new /datum/effect_system/spark_spread
	spark.set_up(2, 1, door)
	spark.start()

	playsound_client(tutorial_mob.client, 'sound/machines/telephone/scout_pick_up.ogg', tutorial_mob, 35, FALSE)

	var/list/scene_script = list(
		"Im calling all hands on deck!<br>The door to your prep room has been overridden.",
		"Get geared up as quickly as possible, and prepare to defend the outpost!!"
	)

	var/scene_length = dynamic_potrait_timer(scene_script)
	addtimer(CALLBACK(src, PROC_REF(update_objective), "Enter the preperations room."), scene_length)

	TUTORIAL_ATOM_FROM_TRACKING(/turf/open/floor/strata/multi_tiles/west, prep_room_entry_turf)
	RegisterSignal(prep_room_entry_turf, COMSIG_TURF_ENTERED, PROC_REF(prep_room_1))
	prep_room_entry_turf.color = COLOR_BLUE

/datum/tutorial/marine/comtech/proc/prep_room_1(source, mob/entering_mob)
	SIGNAL_HANDLER

	if(entering_mob != tutorial_mob)
		return

	TUTORIAL_ATOM_FROM_TRACKING(/turf/open/floor/strata/multi_tiles/west, prep_room_entry_turf)
	prep_room_entry_turf.color = COLOR_RED
	UnregisterSignal(prep_room_entry_turf, COMSIG_TURF_ENTERED)
	addtimer(CALLBACK(src, PROC_REF(lock_prep_room)), 0.5 SECONDS)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/door/airlock/almayer/maint, door)
	new /obj/structure/blocker/invisible_wall(get_step(door, NORTH))

	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cm_vending/clothing/engi/tutorial, clothing_vendor)
	clothing_vendor.req_access = list()
	add_highlight(clothing_vendor, COLOR_ORANGE)

/datum/tutorial/marine/comtech/proc/lock_prep_room()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/door/airlock/almayer/maint, door)
	if(!door || QDELETED(src))
		return
	door.unlock()
	if(!door.close(TRUE))
		addtimer(CALLBACK(src, PROC_REF(lock_prep_room)), 1 SECONDS)
		return
	door.lock(TRUE)

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
	arm_equipment(tutorial_mob, /datum/equipment_preset/tutorial/fed)
	tutorial_mob.set_skills(/datum/skills/combat_engineer)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/cryopod/tutorial, tutorial_pod)
	tutorial_pod.go_in_cryopod(tutorial_mob, TRUE, FALSE)

/datum/tutorial/marine/comtech/init_map()
	var/area/misc/tutorial/tutorial_area = get_area(bottom_left_corner)
	var/list/tracking_markers = tutorial_area.atom_tracking_landmarks

	for(var/obj/effect/landmark/tutorial_tracking_marker/tracker in tracking_markers)
		if(!tracker.tracking_target_type)
			tracking_markers -= tracker
			continue
		var/atom/tracking_atom
		if(istype(get_turf(tracker), tracker.tracking_target_type))
			tracking_atom = get_turf(tracker)
		else
			tracking_atom = locate(tracker.tracking_target_type) in tracker.loc
		if(!tracking_atom)
			qdel(tracker)
			continue
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
