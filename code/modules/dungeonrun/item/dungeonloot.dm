/obj/effect/dungeon

/obj/effect/dungeon/Initialize(mapload)
	. = ..()	


/obj/effect/dungeon/loot
	name = "generic loot"
	desc = "you shouldn't be seeing this"
	var/tier = 1
	var/lootItem = null
	var/list/tierOneLoot = list()
	var/list/tierTwoLoot = list()
	var/list/tierThreeLoot = list()

/obj/effect/dungeon/loot/Initialize(mapload, lvl)
	. = ..()
	if(lvl)
		tier = clamp(lvl, 0, 3)
	var/turf/T = get_turf(src)
	switch(tier)
		if(1)
			lootItem = pick(tierOneLoot)
		if(2)
			lootItem = pick(tierTwoLoot)
		else
			lootItem = pick(tierThreeLoot)

	var/atom/movable/spawnedLoot = new lootItem(T)
