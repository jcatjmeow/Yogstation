/obj/structure/dungeon

/obj/structure/dungeon/Initialize()
	. = ..()
	



/obj/structure/dungeon/dungeondoor
	name = "door"
	desc = "It's a door."
	icon = 'icons/effects/96x96.dmi'
	icon_state = "gate_full"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	anchored = TRUE
	density = TRUE

	///This variable keeps track of if the room the door leads to has been visited yet.
	var/explored = FALSE
	///This variable keeps track of if the door is able to be opened. This is false when the room still needs to be cleared.
	var/openable = FALSE
	var/open = FALSE
	


/obj/structure/dungeon/dungeondoor/Initialize()
	. = ..()
	

/obj/structure/dungeon/dungeondoor/attack_hand(mob/user)
	. = ..()
	if (!openable)
		to_chat(user,"<span class='boldannounce'>It wont budge! .</span>")
	else
		if (open)
			return
		handleTele(user)

/obj/structure/dungeon/dungeondoor/proc/handleTele(mob/user)
