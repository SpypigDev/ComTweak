/obj/item/hardpoint/locomotion/blackfoot_thrusters
	name = "\improper TJ-700 Turbojet Engines"
	desc = "The beating heart of the Blackfoot, the TJ-700 engines are low-bypass axial flow turbojets capable of producing a constant 23,911 lbs of thrust per engine without afterburners. Fueled by JP-9 at a capacity of 3,419 gallons, the TJ-700s achieve a maximum thrust-to-weight ratio of 5.6:1."
	icon = 'icons/obj/vehicles/hardpoints/blackfoot.dmi'
	icon_state = "engines"
	disp_icon = "blackfoot"
	disp_icon_state = "engines"

	damage_multiplier = 0.15
	health = 500

	move_delay = VEHICLE_SPEED_SUPERFAST
	move_max_momentum = 2
	move_momentum_build_factor = 1.5
	move_turn_momentum_loss_factor = 0.5

	var/idle_sound_cooldown = 3 SECONDS
	var/last_idle_sound = 0

/obj/item/hardpoint/locomotion/blackfoot_thrusters/get_icon_image(x_offset, y_offset, new_dir)
	var/obj/vehicle/multitile/blackfoot/blackfoot_owner = owner

	if(!blackfoot_owner)
		return

	var/image/I = image(icon = disp_icon, icon_state = "[disp_icon_state]_[blackfoot_owner.get_sprite_state()]", pixel_x = x_offset, pixel_y = y_offset, dir = new_dir)

	return I

/obj/item/hardpoint/locomotion/blackfoot_thrusters/process(deltatime)
	var/obj/vehicle/multitile/blackfoot/blackfoot_owner = owner

	if(!blackfoot_owner)
		return

	for(var/atom/movable/screen/blackfoot/custom_screen as anything in blackfoot_owner.custom_hud)
		custom_screen.update(blackfoot_owner.fuel, blackfoot_owner.max_fuel, blackfoot_owner.health, blackfoot_owner.maxhealth, blackfoot_owner.battery, blackfoot_owner.max_battery)

	blackfoot_owner.fuel = max(0, blackfoot_owner.fuel - deltatime / 2)

	if(blackfoot_owner.fuel < 0)
		blackfoot_owner.toggle_engines()
		blackfoot_owner.engine_sound_loop.stop()
		STOP_PROCESSING(SSobj, src)

/datum/looping_sound/blackfoot/thruster
	start_sound = 'sound/vehicles/vtol/enginestartup.ogg'
	start_length = 2 SECONDS
	start_volume = 25
	mid_sounds = 'sound/vehicles/vtol/engineidleloop.ogg'
	mid_length = 3.3 SECONDS
	end_sound = 'sound/vehicles/vtol/engineshutdown.ogg'
	volume = 20

/datum/looping_sound/blackfoot/thruster/start()
	var/obj/vehicle/multitile/blackfoot/blackfoot_owner = parent
	if(blackfoot_owner.state != "deployed")
		skip_starting_sounds = TRUE
	end_sound = initial(end_sound)
	return ..()

/datum/looping_sound/blackfoot/thruster/stop()
	var/obj/vehicle/multitile/blackfoot/blackfoot_owner = parent
	if(blackfoot_owner.state != "idling")
		end_sound = null
	return ..()
