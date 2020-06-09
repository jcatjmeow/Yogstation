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
	w_class = WEIGHT_CLASS_BULKY //you HAVE to wear it or carry it. No cheating by putting it in a bag!

/obj/item/clothing/neck/bodycam/Initialize()
	..()
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
	else
		bodcam.status = TRUE
		to_chat(user, "<span class='notice'>You turn on the body camera.</span>")
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
		update_icon()

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
		bodcam.c_tag = rand(1,10000)
		bodcam.network[1] = rand(1, 10000) //gibberish, this will render the camera basically unreadable by any console
		bodcam.status = FALSE
		update_icon()

/obj/item/clothing/neck/bodycam/Destroy()
	. = ..()
	QDEL_NULL(bodcam)

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
