#define VENDING_WEAPON "Weapons" // such as kinetic accelerators and crushers
#define VENDING_UPGRADE "Kinetic Accelerator Upgrades" //KA mods
#define VENDING_TOOL "Tools" //items that miners can actively use
#define VENDING_MINEBOT "Minebot"
#define VENDING_MECHA "Mecha Equipment" //for free miners
#define VENDING_EQUIPMENT "Equipment" // equipment/clothing that miners can wear
#define VENDING_MEDS "Medicial Items"
#define VENDING_MISC "Miscellaneous" // other

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
	for(var/datum/data/slime_mart/prize in prize_list)
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
	//	RedeemVoucher(I, user)
		return
	if(default_deconstruction_screwdriver(user, "mining-open", "mining", I))
		return
	if(default_deconstruction_crowbar(I))
		return
	return ..()

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

/obj/item/coin/slime_coin/attack_self(mob/user)
	return

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