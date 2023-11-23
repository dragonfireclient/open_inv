local function get_slot(x, y, size, texture)
	local t = "image[" .. x - size .. "," .. y - size .. ";" .. 1 + (size * 2) ..
		"," .. 1 + (size * 2) .. ";" .. (texture and texture or "mcl_formspec_itemslot.png") .. "]"
	return t
end

local function get_itemslot_bg_v4(x, y, w, h, size, texture)
	if not size then
		size = 0.05
	end
	local out = ""
	for i = 0, w - 1, 1 do
		for j = 0, h - 1, 1 do
			out = out .. get_slot(x + i + (i * 0.25), y + j + (j * 0.25), size, texture)
		end
	end
	return out
end

local function show_formspec(param)
	local name = minetest.localplayer:get_name()
	local inv = minetest.get_inventory("player:"..name)
	local dlists = ""
	local i = 1
	local idx = 1
	for k,v in pairs(inv) do
		if not param or param == "" then
			param = k
		end
		dlists = dlists .. k .. ","
		if k == param then idx = i end
		i = i + 1
	end
	dlists = dlists:sub(1, -2)
	if inv[param] then
		local x = 0
		local y = 1
		for k,v in pairs(inv[param]) do
			if x < 9 then
				x = x + 1
			elseif y < 3 then
				y = y + 1
			end
		end
		local fs = table.concat({
			"formspec_version[4]",
			"size[11.75,12.425]",

			"label[0.375,0.375;Show Inv List]",

			"dropdown[8,0.175;3,1;select_list;"..dlists..";"..idx.."]",

			get_itemslot_bg_v4(0.375, 1.75, x, y),
			"list[current_player;"..param..";0.375,1.75;"..x..","..y..";]",

			"label[0.375,6.7;Inventory]",

			get_itemslot_bg_v4(0.375, 7.1, 9, 3),
			"list[current_player;main;0.375,7.1;9,3;9]",

			get_itemslot_bg_v4(0.375, 11.05, 9, 1),
			"list[current_player;main;0.375,11.05;9,1;]",

			"listring[current_player;"..param.."]",
			"listring[current_player;main]",
		})
		minetest.show_formspec("invutil_invlist", fs)
		return true
	else
		return false, "List doesn't exists"
	end
end

minetest.register_cheat("OpenInvLists", "Inventory", show_formspec)

minetest.register_chatcommand("openlist", {func=function(param)
	return show_formspec(param)
end})

minetest.register_on_formspec_input(function(formname, fields)
	if formname ~= 'invutil_invlist' then return end
	if fields.select_list then
		show_formspec(fields.select_list)
	end
end)
