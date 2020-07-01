/datum/component/tether
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	var/atom/tether_target
	var/max_dist
	var/tether_name

/datum/component/tether/Initialize(atom/tether_target, max_dist = 4, tether_name)
	if(!isliving(parent) || !istype(tether_target) || !tether_target.loc)
		return COMPONENT_INCOMPATIBLE
	src.tether_target = tether_target
	src.max_dist = max_dist
	if (ispath(tether_name, /atom))
		var/atom/tmp = tether_name
		src.tether_name = initial(tmp.name)
	else
		src.tether_name = tether_name
	RegisterSignal(parent, list(COMSIG_MOVABLE_PRE_MOVE), .proc/checkTether)

/datum/component/tether/proc/checkTether(mob/mover, newloc)
	if (get_dist(mover,newloc) > max_dist)
		to_chat(mover, "<span class='userdanger'>The [tether_name] runs out of slack and prevents you from moving!</span>")
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

	var/atom/blocker
	out:
		for(var/turf/T in getline(tether_target,newloc))
			if (T.density)
				blocker = T
				break out
			for(var/a in T)
				var/atom/A = a
				if(A.density && A != mover && A != tether_target)
					blocker = A
					break out
	if (blocker)
		to_chat(mover, "<span class='userdanger'>The [tether_name] catches on [blocker] and prevents you from moving!</span>")
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE

/*
 * Tether
 */

/obj/item/tether
	name = "Tether"
	desc = "A robust tether system, to keep astronauts from drifting away.\nClick on a wall to anchor the tether to it."
	icon = 'icons/obj/chronos.dmi'
	icon_state = "chronogun"
	item_state = "chronogun"
	w_class = WEIGHT_CLASS_NORMAL

	var/mob/living/listeningTo
	var/last_check = 0
	var/check_delay = 10 //Check los as often as possible, max resolution is SSobj tick though
	var/max_range = 8
	var/list/anchorpoints = list()//This is a list of the locations of each anchor point. This does NOT include the last point, aka the user.
	var/list/datum/beam/current_beams = list() //one beam per anchor point
	var/BeenHereBefore = FALSE //This handles the behavior of when you walk back to the original turf. It's supposed to unhook the tether automatically. But you have to walk away first!

/obj/item/tether/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/tether/Destroy(mob/user)
	STOP_PROCESSING(SSobj, src)
	listeningTo = null
	for (var/i in current_beams)
		qdel(i)
	for (var/j in anchorpoints)
		qdel(j)
	return ..()

/obj/item/tether/proc/newTether()
	anchorpoints += loc
	var/e = anchorpoints.len
	current_beams[e] = new(anchorpoints[e], listeningTo.loc, time = INFINITY, beam_icon_state = "chain", btype = /obj/effect/ebeam/tether)

/obj/effect/ebeam/tether
	name = "tether"