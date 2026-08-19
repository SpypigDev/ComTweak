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
	var/sound/idle_sound
	var/semi_reserved_channel
	var/list/hear
	var/list/listeners

/obj/item/hardpoint/locomotion/blackfoot_thrusters/on_install(obj/vehicle/multitile/V)
	hear = list()
	listeners = list()
	semi_reserved_channel = register_reserved_channel()
	return ..()

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

	if(!idle_sound)
		idle_sound = sound('sound/vehicles/vtol/engineidleloop.ogg', 1, 1, semi_reserved_channel, 20)
		idle_sound.status = SOUND_STREAM
		playsound(owner.loc, idle_sound, 20, FALSE, channel=semi_reserved_channel, status=SOUND_STREAM)
		return

	hear = listeners.Copy()
	listeners = list()
	var/list/atom/movable/all_contents = SSmapgrids.get_movables_in_region(owner.z, owner.x - 5, owner.x + 5, owner.y - 5, owner.y + 5)
	for(var/mob/mob in all_contents)
		if(mob.client)
			listeners |= mob.client
	hear -= listeners
	var/sound/break_sound = sound(null, 1, 0, semi_reserved_channel)
	break_sound.status = SOUND_STREAM | SOUND_MUTE | SOUND_UPDATE
	for(var/client/player as anything in hear)
		sound_to(player, break_sound)

	for(var/client/player as anything in listeners)
		var/sound/update_sound = sound(null, 1, 0, semi_reserved_channel, null)
		update_sound.status = SOUND_STREAM | SOUND_UPDATE
		update_sound.atom = owner
		update_sound.volume = idle_sound.volume
		update_sound.falloff = 5
		update_sound.echo = SOUND_ECHO_REVERB_ON //enable environment reverb for positional sounds
		sound_to(player, update_sound)

	if(blackfoot_owner.fuel < 0)
		blackfoot_owner.toggle_engines()
		STOP_PROCESSING(SSobj, src)
