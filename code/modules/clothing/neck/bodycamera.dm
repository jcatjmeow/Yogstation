/*
 * Bodycamera stuff
 * NOTE: Unlike regular cameras, bodycams can only stream to one camera network at a time. Unless you want to give it more networks,
 * the code will only ever worry about bodcam.network[1]
 */

/obj/item/clothing/neck/bodycam
	name = "body camera"
	desc = "A wearable camera, capable of streaming a live feed."
	icon_state = "bodycam_off"
	item_state = "bodycam_off"
	var/prefix = "sec"//used for sprites, miner etc
	var/obj/machinery/camera/bodcam = null
	var/setup = FALSE
	var/preset = FALSE //if true, the camera is already configured and cannot be reset
	actions_types = list(/datum/action/item_action/toggle_bodycam)
	strip_delay = 1 SECONDS //takes one second to strip, so a downed officer can be un-cammed quickly
	w_class = WEIGHT_CLASS_NORMAL
	var/mob/listeningTo //This code is simular to the code for the RCL.

/obj/item/clothing/neck/bodycam/Initialize()
	..()
	ADD_TRAIT(src, TRAIT_NO_STORAGE, TRAIT_GENERIC)
	bodcam = new(src)
	bodcam.c_tag = "NT_BodyCam"
	bodcam.network = list("ss13")
	bodcam.internal_light = FALSE
	bodcam.status = FALSE
	update_icon()

/obj/item/clothing/neck/bodycam/attack_self(mob/user)
	if(!setup)
		AltClick(user)
		return
	if(bodcam.status)
		bodcam.status = FALSE
		to_chat(user, "<span class='notice'>You shut off the body camera.</span>")
		Screenfuzz("Error: Feed disconnected")
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
		listeningTo = null
	else
		bodcam.status = TRUE
		to_chat(user, "<span class='notice'>You turn on the body camera.</span>")
		getMobhook(user)
	update_icon()

/obj/item/clothing/neck/bodycam/AltClick(mob/user)
	if(preset)
		return //can't change the settings on it if it's preset
	var/name = stripped_input(user, "What would you like your camera's display name to be?", "Camera id", "[user.name]")
	if(name)
		bodcam.c_tag = "(Bodycam) " + name
	var/temp = stripped_input(user, "Which network should the camera broadcast to?\nFor example, 'ss13', 'security', and 'mine' are existing networks", "Camera network", "ss13")
	if(temp)
		bodcam.network[1]=temp
		setup = TRUE
		bodcam.status = TRUE
		Screenfuzz("Error: Network change detected")
		update_icon()
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
		listeningTo = null

/obj/item/clothing/neck/bodycam/update_icon()
	..()
	var/suffix = "off"
	if (bodcam.status)
		suffix = "on"
	icon_state = "[prefix]_bodycam_[suffix]"
	item_state = "[prefix]_bodycam_[suffix]"
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()

/obj/item/clothing/neck/bodycam/examine(mob/user)
	.=..()
	. += "<span class='notice'>The camera is currently [bodcam.status ? "on" : "off"].<span>"
	if(setup)
		. += "<span class='notice'>It is registered under the name \"[bodcam.c_tag]\".</span>"
		. += "<span class='notice'>It is streaming to the network \"[bodcam.network[1]]\".</span>"
		if(!preset)
			. += "<span class='notice'>Alt-click to configure the camera.</span>"
		else
			. += "<span class='notice'>This camera is locked and cannot be reconfigured.</span>"
	else
		. += "<span class='warning'>It hasn't been set up yet!</span>"

/obj/item/clothing/neck/bodycam/verb/toggle_bodycam()
	set name = "Toggle Bodycam"
	set category = "Object"
	set src in oview(1)

	if(!usr.incapacitated())
		attack_self(usr)

/obj/item/clothing/neck/bodycam/emp_act(severity)
	. = ..()
	if(prob(150/severity))
		Screenfuzz("Error: Hardware compromised. Manual reboot required")
		bodcam.c_tag = rand(1,10000)
		bodcam.network[1] = rand(1, 10000) //gibberish, this will render the camera basically unreadable by any console
		bodcam.status = FALSE
		update_icon()
		if(listeningTo)
			UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
			listeningTo = null

/obj/item/clothing/neck/bodycam/Destroy()
	. = ..()
	if (listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
		listeningTo = null
	QDEL_NULL(bodcam)

/obj/item/clothing/neck/bodycam/proc/Screenfuzz(message)//this handles what happens when your camera disconnects and someone is watching
	var/temp="The screen bursts into static."
	if (message)
		temp += "\nThe message \'[message]\' appears."
	for(var/i in GLOB.player_list)
		var/mob/M = i
		if (M.client.eye == bodcam)
			M.unset_machine()
			M.reset_perspective(null)
			to_chat(M, temp)

/obj/item/clothing/neck/bodycam/pickup(mob/user)
	..()
	getMobhook(user)

/obj/item/clothing/neck/bodycam/dropped(mob/wearer)
	..()
	if (bodcam.status)//if it's on
		attack_self(wearer) //turn it off
	GLOB.cameranet.updatePortableCamera(bodcam)
	UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)

/obj/item/clothing/neck/bodycam/proc/getMobhook(mob/to_hook) //This stuff is basically copypasta from RCL.dm, look there if you are confused
	if(listeningTo == to_hook)
		return
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
	listeningTo = to_hook
	RegisterSignal(listeningTo, COMSIG_MOVABLE_MOVED, .proc/trigger)

/obj/item/clothing/neck/bodycam/proc/trigger(mob/user)
	if (!bodcam.status)//this is a safety in case of some fucky wucky shit. This SHOULD not ever be true but sometimes it is anyway :(
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
		listeningTo = null
	to_chat(user,"Debug: Trigger")
	GLOB.cameranet.updatePortableCamera(bodcam)

//Miner specfic camera, cannot be reconfigured
/obj/item/clothing/neck/bodycam/miner
	name = "miner body camera"
	desc = "A wearable camera, capable of streaming a live feed. This one is preconfigured to be used by miners."
	prefix = "miner"
	setup = TRUE
	preset = TRUE

/obj/item/clothing/neck/bodycam/miner/Initialize()
	..()
	bodcam.network[1] = "mine"
	bodcam.c_tag = "Unactivated Miner Body Camera"

/obj/item/clothing/neck/bodycam/miner/attack_self(mob/user)
	..()
	bodcam.c_tag = "(Miner bodycam) " + user.name
	bodcam.network[1] = "mine"
