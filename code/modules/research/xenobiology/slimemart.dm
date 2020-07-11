#define VENDING_WEAPON "Weapons" // such as kinetic accelerators and crushers
#define VENDING_UPGRADE "Kinetic Accelerator Upgrades" //KA mods
#define VENDING_TOOL "Tools" //items that miners can actively use
#define VENDING_MINEBOT "Minebot"
#define VENDING_MECHA "Mecha Equipment" //for free miners
#define VENDING_EQUIPMENT "Equipment" // equipment/clothing that miners can wear
#define VENDING_MEDS "Medicial Items"
#define VENDING_MISC "Miscellaneous" // other

/**********************Mining Equipment Vendor**************************/

/obj/machinery/slime_mart
	name = "mining equipment vendor"
	desc = "An equipment vendor for miners, points collected at an ore redemption machine can be spent here."
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "mining"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/slime_mart
	ui_x = 425
	ui_y = 600
	var/icon_deny = "mining-deny"
	var/list/prize_list = list( //if you add something to this, please, for the love of god, sort it by price/type. use tabs and not spaces.
		new /datum/data/mining_equipment("Kinetic Accelerator",			/obj/item/gun/energy/kinetic_accelerator,							750, VENDING_WEAPON),
		new /datum/data/mining_equipment("Kinetic Crusher",				/obj/item/twohanded/required/kinetic_crusher,						750, VENDING_WEAPON),
		new /datum/data/mining_equipment("Resonator",					/obj/item/resonator,												800, VENDING_WEAPON),
		new /datum/data/mining_equipment("Super Resonator",				/obj/item/resonator/upgraded,										2500, VENDING_WEAPON),
		new /datum/data/mining_equipment("Silver Pickaxe",				/obj/item/pickaxe/silver,											1000, VENDING_WEAPON),
		new /datum/data/mining_equipment("Diamond Pickaxe",				/obj/item/pickaxe/diamond,											2000, VENDING_WEAPON),
		new /datum/data/mining_equipment("KA Minebot Passthrough",		/obj/item/borg/upgrade/modkit/minebot_passthrough,					100, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA White Tracer Rounds",		/obj/item/borg/upgrade/modkit/tracer,								100, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA Adjustable Tracer Rounds",	/obj/item/borg/upgrade/modkit/tracer/adjustable,					150, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA Super Chassis",			/obj/item/borg/upgrade/modkit/chassis_mod,							250, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA Hyper Chassis",			/obj/item/borg/upgrade/modkit/chassis_mod/orange,					300, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA Range Increase",			/obj/item/borg/upgrade/modkit/range,								1000, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA Damage Increase",			/obj/item/borg/upgrade/modkit/damage,								1000, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA Cooldown Decrease",		/obj/item/borg/upgrade/modkit/cooldown,								1000, VENDING_UPGRADE),
		new /datum/data/mining_equipment("KA AoE Damage",				/obj/item/borg/upgrade/modkit/aoe/mobs,								2000, VENDING_UPGRADE),
		new /datum/data/mining_equipment("Shelter Capsule",				/obj/item/survivalcapsule,											400, VENDING_TOOL),
		new /datum/data/mining_equipment("Luxury Shelter Capsule",		/obj/item/survivalcapsule/luxury,									3000, VENDING_TOOL),
		new /datum/data/mining_equipment("Advanced Scanner",			/obj/item/t_scanner/adv_mining_scanner,								800, VENDING_TOOL),
		new /datum/data/mining_equipment("Fulton Pack",					/obj/item/extraction_pack,											1000, VENDING_TOOL),
		new /datum/data/mining_equipment("Fulton Beacon",				/obj/item/fulton_core,												400, VENDING_TOOL),
		new /datum/data/mining_equipment("Jaunter",						/obj/item/wormhole_jaunter,											750, VENDING_TOOL),
		new /datum/data/mining_equipment("Stabilizing Serum",			/obj/item/hivelordstabilizer,										400, VENDING_TOOL),
		new /datum/data/mining_equipment("Lazarus Injector",			/obj/item/lazarus_injector,											1000, VENDING_TOOL),
		new /datum/data/mining_equipment("1 Marker Beacon",				/obj/item/stack/marker_beacon,										10, VENDING_TOOL),
		new /datum/data/mining_equipment("10 Marker Beacons",			/obj/item/stack/marker_beacon/ten,									100, VENDING_TOOL),
		new /datum/data/mining_equipment("30 Marker Beacons",			/obj/item/stack/marker_beacon/thirty,								300, VENDING_TOOL),
		new /datum/data/mining_equipment("Nanotrasen Minebot",			/mob/living/simple_animal/hostile/mining_drone,						800, VENDING_MINEBOT),
		new /datum/data/mining_equipment("Minebot Melee Upgrade",		/obj/item/mine_bot_upgrade,											400, VENDING_MINEBOT),
		new /datum/data/mining_equipment("Minebot Armor Upgrade",		/obj/item/mine_bot_upgrade/health,									400, VENDING_MINEBOT),
		new /datum/data/mining_equipment("Minebot Cooldown Upgrade",	/obj/item/borg/upgrade/modkit/cooldown/minebot,						600, VENDING_MINEBOT),
		new /datum/data/mining_equipment("Minebot AI Upgrade",			/obj/item/slimepotion/slime/sentience/mining,						1000, VENDING_MINEBOT),
		new /datum/data/mining_equipment("Explorer's Webbing",			/obj/item/storage/belt/mining,										500, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("Mining Conscription Kit",		/obj/item/storage/backpack/duffelbag/mining_conscript,				1000, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("GAR Meson Scanners",			/obj/item/clothing/glasses/meson/gar,								500, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("Jump Boots",					/obj/item/clothing/shoes/bhop,										2500, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("Mining Hardsuit",				/obj/item/clothing/suit/space/hardsuit/mining,						2000, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("Jetpack Upgrade",				/obj/item/tank/jetpack/suit,										2000, VENDING_EQUIPMENT),
		new /datum/data/mining_equipment("Survival Medipen",			/obj/item/reagent_containers/hypospray/medipen/survival,			500, VENDING_MEDS),
		new /datum/data/mining_equipment("Brute First-Aid Kit",			/obj/item/storage/firstaid/brute,									600, VENDING_MEDS),
		new /datum/data/mining_equipment("Tracking Implant Kit", 		/obj/item/storage/box/minertracker,									600, VENDING_MEDS),
		new /datum/data/mining_equipment("Point Transfer Card",			/obj/item/card/mining_point_card,									500, VENDING_MISC),
		new /datum/data/mining_equipment("Alien Toy",					/obj/item/clothing/mask/facehugger/toy,								300, VENDING_MISC),
		new /datum/data/mining_equipment("Whiskey",						/obj/item/reagent_containers/food/drinks/bottle/whiskey,			100, VENDING_MISC),
		new /datum/data/mining_equipment("Absinthe",					/obj/item/reagent_containers/food/drinks/bottle/absinthe/premium,	100, VENDING_MISC),
		new /datum/data/mining_equipment("Cigar",						/obj/item/clothing/mask/cigarette/cigar/havana,						150, VENDING_MISC),
		new /datum/data/mining_equipment("Soap",						/obj/item/soap/nanotrasen,											200, VENDING_MISC),
		new /datum/data/mining_equipment("Laser Pointer",				/obj/item/laser_pointer,											300, VENDING_MISC),
		new /datum/data/mining_equipment("Space Cash",					/obj/item/stack/spacecash/c1000,									2000, VENDING_MISC)
		)

/datum/data/slime_mart
	var/equipment_name = "generic"
	var/equipment_path = null
	var/cost = 0
	var/category

/datum/data/slime_mart/New(name, path, pcost, cat)
	equipment_name = name
	equipment_path = path
	cost = pcost
	category = cat

/obj/machinery/slime_mart/Initialize()
	. = ..()
	build_inventory()

/obj/machinery/slime_mart/proc/build_inventory()
	for(var/p in prize_list)
		var/datum/data/slime_mart/M = p
		GLOB.vending_products[M.equipment_path] = 1

/obj/machinery/slime_mart/update_icon()
	if(powered())
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-off"


/obj/machinery/slime_mart/ui_base_html(html)
	var/datum/asset/spritesheet/assets = get_asset_datum(/datum/asset/spritesheet/vending)
	. = replacetext(html, "<!--customheadhtml-->", assets.css_tag())

/obj/machinery/slime_mart/ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = FALSE, \
									datum/tgui/master_ui = null, datum/ui_state/state = GLOB.default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		var/datum/asset/assets = get_asset_datum(/datum/asset/spritesheet/vending)
		assets.send(user)
		ui = new(user, src, ui_key, "MiningVendor", name, ui_x, ui_y, master_ui, state)
		ui.open()

/obj/machinery/slime_mart/ui_static_data(mob/user)
	. = list()
	.["product_records"] = list()
	for(var/datum/data/mining_equipment/prize in prize_list)
		var/list/product_data = list(
			path = replacetext(replacetext("[prize.equipment_path]", "/obj/item/", ""), "/", "-"),
			name = prize.equipment_name,
			price = prize.cost,
			ref = REF(prize)
		)
		.["product_records"] += list(product_data)

/obj/machinery/slime_mart/ui_data(mob/user)
	. = list()
	var/mob/living/carbon/human/H
	var/obj/item/card/id/C
	if(ishuman(user))
		H = user
		C = H.get_idcard(TRUE)
		if(C)
			.["user"] = list()
			.["user"]["points"] = C.mining_points
			if(C.registered_account)
				.["user"]["name"] = C.registered_account.account_holder
				if(C.registered_account.account_job)
					.["user"]["job"] = C.registered_account.account_job.title
				else
					.["user"]["job"] = "No Job"

/obj/machinery/slime_mart/ui_act(action, params)
	if(..())
		return
	switch(action)
		if("purchase")
			var/mob/M = usr
			var/obj/item/card/id/I = M.get_idcard(TRUE)
			if(!istype(I))
				to_chat(usr, "<span class='alert'>Error: An ID is required!</span>")
				flick(icon_deny, src)
				return
			var/datum/data/mining_equipment/prize = locate(params["ref"]) in prize_list
			if(!prize || !(prize in prize_list))
				to_chat(usr, "<span class='alert'>Error: Invalid choice!</span>")
				flick(icon_deny, src)
				return
			if(prize.cost > I.mining_points)
				to_chat(usr, "<span class='alert'>Error: Insufficient points for [prize.equipment_name] on [I]!</span>")
				flick(icon_deny, src)
				return
			I.mining_points -= prize.cost
			to_chat(usr, "<span class='notice'>[src] clanks to life briefly before vending [prize.equipment_name]!</span>")
			new prize.equipment_path(loc)
			SSblackbox.record_feedback("nested tally", "mining_equipment_bought", 1, list("[type]", "[prize.equipment_path]"))
			. = TRUE

/obj/machinery/slime_mart/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/mining_voucher))
		RedeemVoucher(I, user)
		return
	if(default_deconstruction_screwdriver(user, "mining-open", "mining", I))
		return
	if(default_deconstruction_crowbar(I))
		return
	return ..()

/obj/machinery/slime_mart/proc/RedeemVoucher(obj/item/mining_voucher/voucher, mob/redeemer)
  /*
   check_menu: Checks if we are allowed to interact with a radial menu

   Arguments:
   redeemer The mob interacting with a menu
   voucher The mining voucher item
   */
/obj/machinery/slime_mart/proc/check_menu(obj/item/mining_voucher/voucher, mob/living/redeemer)
	if(!Adjacent(redeemer))
		return FALSE
	if(QDELETED(voucher))
		return FALSE
	if(voucher.loc != redeemer)
		return FALSE
	return TRUE

/obj/machinery/slime_mart/ex_act(severity, target)
	do_sparks(5, TRUE, src)
	if(prob(50 / severity) && severity < 3)
		qdel(src)

/obj/item/coin/slime_coin
	name = "slimecoin"
	value = 0
	cmineral = "slime"
	icon_state = "coin_slime_heads"
	var/slimeValue = 0
	var/slimeOverlay = icon('icons/obj/economy.dmi', "coin_slime_overlay")
	var/slimeFlipOverlay = icon('icons/obj/economy.dmi', "coin_slime_flip_overlay")
	var/slimeColor

/obj/item/coin/slime_coin/Initialize()
	. = ..()
	if (slimeColor)
		slimeOverlay += slimeColor
		slimeFlipOverlay += slimeColor
		add_overlay(slimeOverlay)

/obj/item/coin/slime_coin/examine(mob/user)
	. = ..()
	if(slimeValue)
		. += "<span class='info'>It's worth [slimeValue] SlimeCoin\s.</span>"

/obj/item/coin/attack_self(mob/user)
	if(cooldown < world.time)
		if(string_attached) //does the coin have a wire attached
			to_chat(user, "<span class='warning'>The coin won't flip very well with something attached!</span>" )
			return FALSE//do not flip the coin
		coinflip = pick(sideslist)
		cooldown = world.time + 15
		cut_overlays()
		var/icon/I = icon('icons/obj/economy.dmi', "coin_slime_flip") + slimeFlipOverlay
		flick(I, src)
		icon_state = "coin_slime_[coinflip]"
		if(coinflip == "heads")
			add_overlay(slimeOverlay)
		playsound(user.loc, 'sound/items/coinflip.ogg', 50, 1)
		var/oldloc = loc
		sleep(15)
		if(loc == oldloc && user && !user.incapacitated())
			user.visible_message("[user] has flipped [src]. It lands on [coinflip].", \
 							 "<span class='notice'>You flip [src]. It lands on [coinflip].</span>", \
							 "<span class='italics'>You hear the clattering of loose change.</span>")
	return TRUE//did the coin flip? useful for suicide_act


/obj/item/coin/slime_coin/one
	slimeValue = 1
	slimeColor = "#ff0080"

/obj/item/coin/slime_coin/five
	slimeValue = 5

/obj/item/coin/slime_coin/ten
	slimeValue = 10

/obj/item/coin/slime_coin/twenty
	slimeValue = 20

/obj/item/coin/slime_coin/fifty
	slimeValue = 50

/obj/item/coin/slime_coin/hundred
	slimeValue = 100

/obj/item/coin/slime_coin/thousand
	slimeValue = 1000