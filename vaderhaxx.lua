-- "FIXED" by ntf
--vader haxx -- super pasted AHAHAHHAHA ( jerking my shit rn) fix everything nigger
-- 12 october 2022???? around then!?
--credits :
--[[
	ANCHOR credits
	Integer = esp, heap lib, mathematics lib and bfs pathfinding
	Gas 	= exploits, gun mods, hooking libs, janitor lib, most of the playerinfo lib, legit silent aim, weapon wrapper, game module resolver and future proofing
    Invaded = everything else
]]

getgenv().vaderhaxx = {}
getgenv().vaderhaxx.loaded = false

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local mainActor

local run = function(s)
	return if mainActor then run_on_actor(mainActor, s) else loadstring(s)()
end

local tried = tick() 
repeat -- shit actor resolver
	local id, event = create_comm_channel()
	local actors = getactors()
	event.Event:Connect(function(...)
		local data, actor = ...
		if mainActor then
			return
		end
		for i, v in next, data do
			if tostring(v) == "ClientLoader" then
				mainActor = actors[actor]
			end
		end
	end)
	for i, v in next, actors do -- fuck you 3dsboy08 smd faggot
		run_on_actor(v, "local actorId = " .. i .. "\n" .. [[
			local id, actor = ...
			local event = get_comm_channel(id)

			event:Fire(getrunningscripts(), actorId)
		]], id)
	end 
	task.wait(2)
until mainActor ~= nil or tick() - tried >= 10

run([=[
local disableImageLoading = false
local oldWatermark = false
local startLoad = tick()

local tick                              = tick
local unpack                            = unpack
local Drawing                         = Drawing

local utilities                         = {}
local Drawings                        = {}
local uilibrary                         = {}
local encryption                        = {}
local base64                            = {}
local json								= {}

do -- base 64 lib
	local function extract( v, from, width )
		local w = 0
		local flag = 2^from
		for i = 0, width-1 do
			local flag2 = flag + flag
			if v % flag2 >= flag then
				w = w + 2^i
			end
			flag = flag2
		end
		return w
	end
	function base64.makeencoder( s62, s63, spad )
		local encoder = {}
		for b64code, char in pairs{[0]='A','B','C','D','E','F','G','H','I','J',
			'K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y',
			'Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n',
			'o','p','q','r','s','t','u','v','w','x','y','z','0','1','2',
			'3','4','5','6','7','8','9',s62 or '+',s63 or'/',spad or'='} do
			encoder[b64code] = char:byte()
		end
		return encoder
	end

	function base64.makedecoder( s62, s63, spad )
		local decoder = {}
		for b64code, charcode in pairs( base64.makeencoder( s62, s63, spad )) do
			decoder[charcode] = b64code
		end
		return decoder
	end

	local DEFAULT_ENCODER = base64.makeencoder()
	local DEFAULT_DECODER = base64.makedecoder()

	local char, concat = schar, tconcat

	function base64.encode( str, encoder, usecaching )
		encoder = encoder or DEFAULT_ENCODER
		local t, k, n = {}, 1, #str
		local lastn = n % 3
		local cache = {}
		for i = 1, n-lastn, 3 do
			local a, b, c = str:byte( i, i+2 )
			local v = a*0x10000 + b*0x100 + c
			local s
			if usecaching then
				s = cache[v]
				if not s then
					s = string.char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[extract(v,0,6)])
					cache[v] = s
				end
			else
				s = string.char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[extract(v,0,6)])
			end
			t[k] = s
			k = k + 1 
		end
		if lastn == 2 then
			local a, b = str:byte( n-1, n )
			local v = a*0x10000 + b*0x100
			t[k] = string.char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[extract(v,6,6)], encoder[64])
		elseif lastn == 1 then
			local v = str:byte( n )*0x10000
			t[k] = string.char(encoder[extract(v,18,6)], encoder[extract(v,12,6)], encoder[64], encoder[64])
		end
		return table.concat( t )
	end

	function base64.decode( b64, decoder, usecaching )
		local decoder = decoder or DEFAULT_DECODER
		local pattern = '[^%w%+%/%=]'
		if decoder then
			local s62, s63
			for charcode, b64code in pairs( decoder ) do
				if b64code == 62 then s62 = charcode
				elseif b64code == 63 then s63 = charcode
				end
			end
			pattern = ('[^%%w%%%s%%%s%%=]'):format( string.char(s62), string.char(s63) )
		end
		b64 = b64:gsub( pattern, '' )
		local cache = usecaching and {}
		local t, k = {}, 1
		local n = #b64
		local padding = b64:sub(-2) == '==' and 2 or b64:sub(-1) == '=' and 1 or 0
		for i = 1, padding > 0 and n-4 or n, 4 do
			local a, b, c, d = b64:byte( i, i+3 )
			local s
			if usecaching then
				local v0 = a*0x1000000 + b*0x10000 + c*0x100 + d
				s = cache[v0]
				if not s then
					local v = decoder[a]*0x40000 + decoder[b]*0x1000 + decoder[c]*0x40 + decoder[d]
					s = string.char( extract(v,16,8), extract(v,8,8), extract(v,0,8))
					cache[v0] = s
				end
			else
				local v = decoder[a]*0x40000 + decoder[b]*0x1000 + decoder[c]*0x40 + decoder[d]
				s = string.char( extract(v,16,8), extract(v,8,8), extract(v,0,8))
			end
			t[k] = s
			k = k + 1
		end
		if padding == 1 then
			local a, b, c = b64:byte( n-3, n-1 )
			local v = decoder[a]*0x40000 + decoder[b]*0x1000 + decoder[c]*0x40
			t[k] = string.char( extract(v,16,8), extract(v,8,8))
		elseif padding == 2 then
			local a, b = b64:byte( n-3, n-2 )
			local v = decoder[a]*0x40000 + decoder[b]*0x1000
			t[k] = string.char( extract(v,16,8))
		end
		return table.concat( t )
	end
end

do -- json lib
	local encode

	local escape_char_map = {
		[ "\\" ] = "\\",
		[ "\"" ] = "\"",
		[ "\b" ] = "b",
		[ "\f" ] = "f",
		[ "\n" ] = "n",
		[ "\r" ] = "r",
		[ "\t" ] = "t",
	}

	local escape_char_map_inv = { [ "/" ] = "/" }
	for k, v in pairs(escape_char_map) do
		escape_char_map_inv[v] = k
	end


	local function escape_char(c)
		return "\\" .. (escape_char_map[c] or string.format("u%04x", c:byte()))
	end


	local function encode_nil(val)
		return "null"
	end


	local function encode_table(val, stack)
		local res = {}
		stack = stack or {}

		-- Circular reference?
		if stack[val] then error("circular reference") end

		stack[val] = true

		if rawget(val, 1) ~= nil or next(val) == nil then
			-- Treat as array -- check keys are valid and it is not sparse
			local n = 0
			for k in pairs(val) do
				if type(k) ~= "number" then
					error("invalid table: mixed or invalid key types")
				end
				n = n + 1
			end
			if n ~= #val then
				error("invalid table: sparse array")
			end
			-- Encode
			for i, v in ipairs(val) do
				table.insert(res, encode(v, stack))
			end
			stack[val] = nil
			return "[" .. table.concat(res, ",") .. "]"

		else
			-- Treat as an object
			for k, v in pairs(val) do
				if type(k) ~= "string" then
					error("invalid table: mixed or invalid key types")
				end
				table.insert(res, encode(k, stack) .. ":" .. encode(v, stack))
			end
			stack[val] = nil
			return "{" .. table.concat(res, ",") .. "}"
		end
	end


	local function encode_string(val)
		return '"' .. val:gsub('[%z\1-\31\\"]', escape_char) .. '"'
	end


	local function encode_number(val)
		-- Check for NaN, -inf and inf
		if val ~= val or val <= -math.huge or val >= math.huge then
			error("unexpected number value '" .. tostring(val) .. "'")
		end
		return string.format("%.14g", val)
	end


	local type_func_map = {
		[ "nil"     ] = encode_nil,
		[ "table"   ] = encode_table,
		[ "string"  ] = encode_string,
		[ "number"  ] = encode_number,
		[ "boolean" ] = tostring,
	}


	encode = function(val, stack)
		local t = type(val)
		local f = type_func_map[t]
		if f then
			return f(val, stack)
		end
		error("unexpected type '" .. t .. "'")
	end


	function json.encode(val)
		return ( encode(val) )
	end

	local parse

	local function create_set(...)
		local res = {}
		for i = 1, select("#", ...) do
			res[ select(i, ...) ] = true
		end
		return res
	end

	local space_chars   = create_set(" ", "\t", "\r", "\n")
	local delim_chars   = create_set(" ", "\t", "\r", "\n", "]", "}", ",")
	local escape_chars  = create_set("\\", "/", '"', "b", "f", "n", "r", "t", "u")
	local literals      = create_set("true", "false", "null")

	local literal_map = {
		[ "true"  ] = true,
		[ "false" ] = false,
		[ "null"  ] = nil,
	}


	local function next_char(str, idx, set, negate)
		for i = idx, #str do
			if set[str:sub(i, i)] ~= negate then
				return i
			end
		end
		return #str + 1
	end


	local function decode_error(str, idx, msg)
		local line_count = 1
		local col_count = 1
		for i = 1, idx - 1 do
			col_count = col_count + 1
			if str:sub(i, i) == "\n" then
				line_count = line_count + 1
				col_count = 1
			end
		end
		error( string.format("%s at line %d col %d", msg, line_count, col_count) )
	end


	local function codepoint_to_utf8(n)
		-- http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=iws-appendixa
		local f = mfloor
		if n <= 0x7f then
			return string.char(n)
		elseif n <= 0x7ff then
			return string.char(f(n / 64) + 192, n % 64 + 128)
		elseif n <= 0xffff then
			return string.char(f(n / 4096) + 224, f(n % 4096 / 64) + 128, n % 64 + 128)
		elseif n <= 0x10ffff then
			return string.char(f(n / 262144) + 240, f(n % 262144 / 4096) + 128,
				f(n % 4096 / 64) + 128, n % 64 + 128)
		end
		error( sformat("invalid unicode codepoint '%x'", n) )
	end


	local function parse_unicode_escape(s)
		local n1 = tonumber( s:sub(1, 4),  16 )
		local n2 = tonumber( s:sub(7, 10), 16 )
		-- Surrogate pair?
		if n2 then
			return codepoint_to_utf8((n1 - 0xd800) * 0x400 + (n2 - 0xdc00) + 0x10000)
		else
			return codepoint_to_utf8(n1)
		end
	end


	local function parse_string(str, i)
		local res = ""
		local j = i + 1
		local k = j

		while j <= #str do
			local x = str:byte(j)

			if x < 32 then
				decode_error(str, j, "control character in string")

			elseif x == 92 then -- `\`: Escape
				res = res .. str:sub(k, j - 1)
				j = j + 1
				local c = str:sub(j, j)
				if c == "u" then
					local hex = str:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", j + 1)
						or str:match("^%x%x%x%x", j + 1)
						or decode_error(str, j - 1, "invalid unicode escape in string")
					res = res .. parse_unicode_escape(hex)
					j = j + #hex
				else
					if not escape_chars[c] then
						decode_error(str, j - 1, "invalid escape char '" .. c .. "' in string")
					end
					res = res .. escape_char_map_inv[c]
				end
				k = j + 1

			elseif x == 34 then -- `"`: End of string
				res = res .. str:sub(k, j - 1)
				return res, j + 1
			end

			j = j + 1
		end

		decode_error(str, i, "expected closing quote for string")
	end


	local function parse_number(str, i)
		local x = next_char(str, i, delim_chars)
		local s = str:sub(i, x - 1)
		local n = tonumber(s)
		if not n then
			decode_error(str, i, "invalid number '" .. s .. "'")
		end
		return n, x
	end


	local function parse_literal(str, i)
		local x = next_char(str, i, delim_chars)
		local word = str:sub(i, x - 1)
		if not literals[word] then
			decode_error(str, i, "invalid literal '" .. word .. "'")
		end
		return literal_map[word], x
	end


	local function parse_array(str, i)
		local res = {}
		local n = 1
		i = i + 1
		while 1 do
			local x
			i = next_char(str, i, space_chars, true)
			-- Empty / end of array?
			if str:sub(i, i) == "]" then
				i = i + 1
				break
			end
			-- Read token
			x, i = parse(str, i)
			res[n] = x
			n = n + 1
			-- Next token
			i = next_char(str, i, space_chars, true)
			local chr = str:sub(i, i)
			i = i + 1
			if chr == "]" then break end
			if chr ~= "," then decode_error(str, i, "expected ']' or ','") end
		end
		return res, i
	end


	local function parse_object(str, i)
		local res = {}
		i = i + 1
		while 1 do
			local key, val
			i = next_char(str, i, space_chars, true)
			-- Empty / end of object?
			if str:sub(i, i) == "}" then
				i = i + 1
				break
			end
			-- Read key
			if str:sub(i, i) ~= '"' then
				decode_error(str, i, "expected string for key")
			end
			key, i = parse(str, i)
			-- Read ':' delimiter
			i = next_char(str, i, space_chars, true)
			if str:sub(i, i) ~= ":" then
				decode_error(str, i, "expected ':' after key")
			end
			i = next_char(str, i + 1, space_chars, true)
			-- Read value
			val, i = parse(str, i)
			-- Set
			res[key] = val
			-- Next token
			i = next_char(str, i, space_chars, true)
			local chr = str:sub(i, i)
			i = i + 1
			if chr == "}" then break end
			if chr ~= "," then decode_error(str, i, "expected '}' or ','") end
		end
		return res, i
	end


	local char_func_map = {
		[ '"' ] = parse_string,
		[ "0" ] = parse_number,
		[ "1" ] = parse_number,
		[ "2" ] = parse_number,
		[ "3" ] = parse_number,
		[ "4" ] = parse_number,
		[ "5" ] = parse_number,
		[ "6" ] = parse_number,
		[ "7" ] = parse_number,
		[ "8" ] = parse_number,
		[ "9" ] = parse_number,
		[ "-" ] = parse_number,
		[ "t" ] = parse_literal,
		[ "f" ] = parse_literal,
		[ "n" ] = parse_literal,
		[ "[" ] = parse_array,
		[ "{" ] = parse_object,
	}

	parse = function(str, idx)
		local chr = str:sub(idx, idx)
		local f = char_func_map[chr]
		if f then
			return f(str, idx)
		end
		decode_error(str, idx, "unexpected character '" .. chr .. "'")
	end


	function json.decode(str)
		if type(str) ~= "string" then
			error("expected argument of type string, got " .. type(str))
		end
		local res, idx = parse(str, next_char(str, 1, space_chars, true))
		idx = next_char(str, idx, space_chars, true)
		if idx <= #str then
			decode_error(str, idx, "trailing garbage")
		end
		return res
	end
end

do -- pasted to avoid using synapse encryption due to compatability issues

	-- ADVANCED ENCRYPTION STANDARD (AES)

	-- Implementation of secure symmetric-key encryption specifically in Luau
	-- Includes ECB, CBC, PCBC, CFB, OFB and CTR modes without padding.
	-- Made by @RobloxGamerPro200007 (verify the original asset)

	-- MORE INFORMATION: https://devforum.roblox.com/t/advanced-encryption-standard-in-luau/2009120


	-- SUBSTITUTION BOXES
	local s_box 	= { 99, 124, 119, 123, 242, 107, 111, 197,  48,   1, 103,  43, 254, 215, 171, 118, 202,
		130, 201, 125, 250,  89,  71, 240, 173, 212, 162, 175, 156, 164, 114, 192, 183, 253, 147,  38,  54,
		63, 247, 204,  52, 165, 229, 241, 113, 216,  49,  21,   4, 199,  35, 195,  24, 150,   5, 154,   7,
		18, 128, 226, 235,  39, 178, 117,   9, 131,  44,  26,  27, 110,  90, 160,  82,  59, 214, 179,  41,
		227,  47, 132,  83, 209,   0, 237,  32, 252, 177,  91, 106, 203, 190,  57,  74,  76,  88, 207, 208,
		239, 170, 251,  67,  77,  51, 133,  69, 249,   2, 127,  80,  60, 159, 168,  81, 163,  64, 143, 146,
		157,  56, 245, 188, 182, 218,  33,  16, 255, 243, 210, 205,  12,  19, 236,  95, 151,  68,  23, 196,
		167, 126,  61, 100,  93,  25, 115,  96, 129,  79, 220,  34,  42, 144, 136,  70, 238, 184,  20, 222,
		94,  11, 219, 224,  50,  58,  10,  73,   6,  36,  92, 194, 211, 172,  98, 145, 149, 228, 121, 231,
		200,  55, 109, 141, 213,  78, 169, 108,  86, 244, 234, 101, 122, 174,   8, 186, 120,  37,  46,  28,
		166, 180, 198, 232, 221, 116,  31,  75, 189, 139, 138, 112,  62, 181, 102,  72,   3, 246,  14,  97,
		53,  87, 185, 134, 193,  29, 158, 225, 248, 152,  17, 105, 217, 142, 148, 155,  30, 135, 233, 206,
		85,  40, 223, 140, 161, 137,  13, 191, 230,  66, 104,  65, 153,  45,  15, 176,  84, 187,  22}
	local inv_s_box	= { 82,   9, 106, 213,  48,  54, 165,  56, 191,  64, 163, 158, 129, 243, 215, 251, 124,
		227,  57, 130, 155,  47, 255, 135,  52, 142,  67,  68, 196, 222, 233, 203,  84, 123, 148,  50, 166,
		194,  35,  61, 238,  76, 149,  11,  66, 250, 195,  78,   8,  46, 161, 102,  40, 217,  36, 178, 118,
		91, 162,  73, 109, 139, 209,  37, 114, 248, 246, 100, 134, 104, 152,  22, 212, 164,  92, 204,  93,
		101, 182, 146, 108, 112,  72,  80, 253, 237, 185, 218,  94,  21,  70,  87, 167, 141, 157, 132, 144,
		216, 171,   0, 140, 188, 211,  10, 247, 228,  88,   5, 184, 179,  69,   6, 208,  44,  30, 143, 202,
		63,  15,   2, 193, 175, 189,   3,   1,  19, 138, 107,  58, 145,  17,  65,  79, 103, 220, 234, 151,
		242, 207, 206, 240, 180, 230, 115, 150, 172, 116,  34, 231, 173,  53, 133, 226, 249,  55, 232,  28,
		117, 223, 110,  71, 241,  26, 113,  29,  41, 197, 137, 111, 183,  98,  14, 170,  24, 190,  27, 252,
		86,  62,  75, 198, 210, 121,  32, 154, 219, 192, 254, 120, 205,  90, 244,  31, 221, 168,  51, 136,
		7, 199,  49, 177,  18,  16,  89,  39, 128, 236,  95,  96,  81, 127, 169,  25, 181,  74,  13,  45,
		229, 122, 159, 147, 201, 156, 239, 160, 224,  59,  77, 174,  42, 245, 176, 200, 235, 187,  60, 131,
		83, 153,  97,  23,  43,   4, 126, 186, 119, 214,  38, 225, 105,  20,  99,  85,  33,  12, 125}

	-- ROUND CONSTANTS ARRAY
	local rcon = {  0,   1,   2,   4,   8,  16,  32,  64, 128,  27,  54, 108, 216, 171,  77, 154,  47,  94,
		188,  99, 198, 151,  53, 106, 212, 179, 125, 250, 239, 197, 145,  57}
	-- MULTIPLICATION OF BINARY POLYNOMIAL
	local function xtime(x)
		local i = bit32.lshift(x, 1)
		return if bit32.band(x, 128) == 0 then i else bit32.bxor(i, 27) % 256
	end

	-- TRANSFORMATION FUNCTIONS
	local function subBytes		(s, inv) 		-- Processes State using the S-box
		inv = if inv then inv_s_box else s_box
		for i = 1, 4 do
			for j = 1, 4 do
				s[i][j] = inv[s[i][j] + 1]
			end
		end
	end
	local function shiftRows		(s, inv) 	-- Processes State by circularly shifting rows
		s[1][3], s[2][3], s[3][3], s[4][3] = s[3][3], s[4][3], s[1][3], s[2][3]
		if inv then
			s[1][2], s[2][2], s[3][2], s[4][2] = s[4][2], s[1][2], s[2][2], s[3][2]
			s[1][4], s[2][4], s[3][4], s[4][4] = s[2][4], s[3][4], s[4][4], s[1][4]
		else
			s[1][2], s[2][2], s[3][2], s[4][2] = s[2][2], s[3][2], s[4][2], s[1][2]
			s[1][4], s[2][4], s[3][4], s[4][4] = s[4][4], s[1][4], s[2][4], s[3][4]
		end
	end
	local function addRoundKey	(s, k) 			-- Processes Cipher by adding a round key to the State
		for i = 1, 4 do
			for j = 1, 4 do
				s[i][j] = bit32.bxor(s[i][j], k[i][j])
			end
		end
	end
	local function mixColumns	(s, inv) 		-- Processes Cipher by taking and mixing State columns
		local t, u
		if inv then
			for i = 1, 4 do
				t = xtime(xtime(bit32.bxor(s[i][1], s[i][3])))
				u = xtime(xtime(bit32.bxor(s[i][2], s[i][4])))
				s[i][1], s[i][2] = bit32.bxor(s[i][1], t), bit32.bxor(s[i][2], u)
				s[i][3], s[i][4] = bit32.bxor(s[i][3], t), bit32.bxor(s[i][4], u)
			end
		end

		local i
		for j = 1, 4 do
			i = s[j]
			t, u = bit32.bxor		(i[1], i[2], i[3], i[4]), i[1]
			for k = 1, 4 do
				i[k] = bit32.bxor	(i[k], t, xtime(bit32.bxor(i[k], i[k + 1] or u)))
			end
		end
	end

	-- BYTE ARRAY UTILITIES
	local function bytesToMatrix	(t, c, inv) -- Converts a byte array to a 4x4 matrix
		if inv then
			table.move		(c[1], 1, 4, 1, t)
			table.move		(c[2], 1, 4, 5, t)
			table.move		(c[3], 1, 4, 9, t)
			table.move		(c[4], 1, 4, 13, t)
		else
			for i = 1, #c / 4 do
				table.clear	(t[i])
				table.move	(c, i * 4 - 3, i * 4, 1, t[i])
			end
		end

		return t
	end
	local function xorBytes		(t, a, b) 		-- Returns bitwise XOR of all their bytes
		table.clear		(t)

		for i = 1, math.min(#a, #b) do
			table.insert(t, bit32.bxor(a[i], b[i]))
		end
		return t
	end
	local function incBytes		(a, inv)		-- Increment byte array by one
		local o = true
		for i = if inv then 1 else #a, if inv then #a else 1, if inv then 1 else - 1 do
			if a[i] == 255 then
				a[i] = 0
			else
				a[i] += 1
				o = false
				break
			end
		end

		return o, a
	end

	-- MAIN ALGORITHM
	local function expandKey	(key) 				-- Key expansion
		local kc = bytesToMatrix(if #key == 16 then {{}, {}, {}, {}} elseif #key == 24 then {{}, {}, {}, {}
			, {}, {}} else {{}, {}, {}, {}, {}, {}, {}, {}}, key)
		local is = #key / 4
		local i, t, w = 2, {}, nil

		while #kc < (#key / 4 + 7) * 4 do
			w = table.clone	(kc[#kc])
			if #kc % is == 0 then
				table.insert(w, table.remove(w, 1))
				for j = 1, 4 do
					w[j] = s_box[w[j] + 1]
				end
				w[1]	 = bit32.bxor(w[1], rcon[i])
				i 	+= 1
			elseif #key == 32 and #kc % is == 4 then
				for j = 1, 4 do
					w[j] = s_box[w[j] + 1]
				end
			end

			table.clear	(t)
			xorBytes	(w, table.move(w, 1, 4, 1, t), kc[#kc - is + 1])
			table.insert(kc, w)
		end

		table.clear		(t)
		for i = 1, #kc / 4 do
			table.insert(t, {})
			table.move	(kc, i * 4 - 3, i * 4, 1, t[#t])
		end
		return t
	end
	local function encrypt	(key, km, pt, ps, r) 	-- Block cipher encryption
		bytesToMatrix	(ps, pt)
		addRoundKey		(ps, km[1])

		for i = 2, #key / 4 + 6 do
			subBytes	(ps)
			shiftRows	(ps)
			mixColumns	(ps)
			addRoundKey	(ps, km[i])
		end
		subBytes		(ps)
		shiftRows		(ps)
		addRoundKey		(ps, km[#km])

		return bytesToMatrix(r, ps, true)
	end
	local function decrypt	(key, km, ct, cs, r) 	-- Block cipher decryption
		bytesToMatrix	(cs, ct)

		addRoundKey		(cs, km[#km])
		shiftRows		(cs, true)
		subBytes		(cs, true)
		for i = #key / 4 + 6, 2, - 1 do
			addRoundKey	(cs, km[i])
			mixColumns	(cs, true)
			shiftRows	(cs, true)
			subBytes	(cs, true)
		end

		addRoundKey		(cs, km[1])
		return bytesToMatrix(r, cs, true)
	end

	-- INITIALIZATION FUNCTIONS
	local function convertType	(a) 					-- Converts data to bytes if possible
		if type(a) == "string" then
			local r = {}

			for i = 1, string.len(a), 7997 do
				table.move({string.byte(a, i, i + 7996)}, 1, 7997, i, r)
			end
			return r
		elseif type(a) == "table" then
			for _, i in ipairs(a) do
				assert(type(i) == "number" and math.floor(i) == i and 0 <= i and i < 256,
					"Unable to cast value to bytes")
			end
			return a
		else
			error("Unable to cast value to bytes")
		end
	end
	local function init			(key, txt, m, iv, s) 	-- Initializes functions if possible
		key = convertType(key)
		assert(#key == 16 or #key == 24 or #key == 32, "Key must be either 16, 24 or 32 bytes long")
		txt = convertType(txt)
		assert(#txt % (s or 16) == 0, "Input must be a multiple of " .. (if s then "segment size " .. s
			else "16") .. " bytes in length")
		if m then
			if type(iv) == "table" then
				iv = table.clone(iv)
				local l, e 		= iv.Length, iv.LittleEndian
				assert(type(l) == "number" and 0 < l and l <= 16,
					"Counter value length must be between 1 and 16 bytes")
				iv.Prefix 		= convertType(iv.Prefix or {})
				iv.Suffix 		= convertType(iv.Suffix or {})
				assert(#iv.Prefix + #iv.Suffix + l == 16, "Counter must be 16 bytes long")
				iv.InitValue 	= if iv.InitValue == nil then {1} else table.clone(convertType(iv.InitValue
				))
				assert(#iv.InitValue <= l, "Initial value length must be of the counter value")
				iv.InitOverflow = if iv.InitOverflow == nil then table.create(l, 0) else table.clone(
				convertType(iv.InitOverflow))
				assert(#iv.InitOverflow <= l,
					"Initial overflow value length must be of the counter value")
				for _ = 1, l - #iv.InitValue do
					table.insert(iv.InitValue, 1 + if e then #iv.InitValue else 0, 0)
				end
				for _ = 1, l - #iv.InitOverflow do
					table.insert(iv.InitOverflow, 1 + if e then #iv.InitOverflow else 0, 0)
				end
			elseif type(iv) ~= "function" then
				local i, t = if iv then convertType(iv) else table.create(16, 0), {}
				assert(#i == 16, "Counter must be 16 bytes long")
				iv = {Length = 16, Prefix = t, Suffix = t, InitValue = i,
					InitOverflow = table.create(16, 0)}
			end
		elseif m == false then
			iv 	= if iv == nil then  table.create(16, 0) else convertType(iv)
			assert(#iv == 16, "Initialization vector must be 16 bytes long")
		end
		if s then
			s = math.floor(tonumber(s) or 1)
			assert(type(s) == "number" and 0 < s and s <= 16, "Segment size must be between 1 and 16 bytes"
			)
		end

		return key, txt, expandKey(key), iv, s
	end
	type bytes = {number} -- Type instance of a valid bytes object

	-- CIPHER MODES OF OPERATION
	encryption = {
		-- Electronic codebook (ECB)
		encrypt_ECB = function(key : bytes, plainText : bytes) 									: bytes
			local km
			key, plainText, km = init(key, plainText)

			local b, k, s, t = {}, {}, {{}, {}, {}, {}}, {}
			for i = 1, #plainText, 16 do
				table.move(plainText, i, i + 15, 1, k)
				table.move(encrypt(key, km, k, s, t), 1, 16, i, b)
			end

			return b
		end,
		decrypt_ECB = function(key : bytes, cipherText : bytes) 								: bytes
			local km
			key, cipherText, km = init(key, cipherText)

			local b, k, s, t = {}, {}, {{}, {}, {}, {}}, {}
			for i = 1, #cipherText, 16 do
				table.move(cipherText, i, i + 15, 1, k)
				table.move(decrypt(key, km, k, s, t), 1, 16, i, b)
			end

			return b
		end,
		-- Cipher block chaining (CBC)
		encrypt_CBC = function(key : bytes, plainText : bytes, initVector : bytes?) 			: bytes
			local km
			key, plainText, km, initVector = init(key, plainText, false, initVector)

			local b, k, p, s, t = {}, {}, initVector, {{}, {}, {}, {}}, {}
			for i = 1, #plainText, 16 do
				table.move(plainText, i, i + 15, 1, k)
				table.move(encrypt(key, km, xorBytes(t, k, p), s, p), 1, 16, i, b)
			end

			return b
		end,
		decrypt_CBC = function(key : bytes, cipherText : bytes, initVector : bytes?) 			: bytes
			local km
			key, cipherText, km, initVector = init(key, cipherText, false, initVector)

			local b, k, p, s, t = {}, {}, initVector, {{}, {}, {}, {}}, {}
			for i = 1, #cipherText, 16 do
				table.move(cipherText, i, i + 15, 1, k)
				table.move(xorBytes(k, decrypt(key, km, k, s, t), p), 1, 16, i, b)
				table.move(cipherText, i, i + 15, 1, p)
			end

			return b
		end,
		-- Propagating cipher block chaining (PCBC)
		encrypt_PCBC = function(key : bytes, plainText : bytes, initVector : bytes?) 			: bytes
			local km
			key, plainText, km, initVector = init(key, plainText, false, initVector)

			local b, k, c, p, s, t = {}, {}, initVector, table.create(16, 0), {{}, {}, {}, {}}, {}
			for i = 1, #plainText, 16 do
				table.move(plainText, i, i + 15, 1, k)
				table.move(encrypt(key, km, xorBytes(k, xorBytes(t, c, k), p), s, c), 1, 16, i, b)
				table.move(plainText, i, i + 15, 1, p)
			end

			return b
		end,
		decrypt_PCBC = function(key : bytes, cipherText : bytes, initVector : bytes?) 			: bytes
			local km
			key, cipherText, km, initVector = init(key, cipherText, false, initVector)

			local b, k, c, p, s, t = {}, {}, initVector, table.create(16, 0), {{}, {}, {}, {}}, {}
			for i = 1, #cipherText, 16 do
				table.move(cipherText, i, i + 15, 1, k)
				table.move(xorBytes(p, decrypt(key, km, k, s, t), xorBytes(k, c, p)), 1, 16, i, b)
				table.move(cipherText, i, i + 15, 1, c)
			end

			return b
		end,
		-- Cipher feedback (CFB)
		encrypt_CFB = function(key : bytes, plainText : bytes, initVector : bytes?, segmentSize : number?)
			: bytes
			local km
			key, plainText, km, initVector, segmentSize = init(key, plainText, false, initVector,
				if segmentSize == nil then 1 else segmentSize)

			local b, k, p, q, s, t = {}, {}, initVector, {}, {{}, {}, {}, {}}, {}
			for i = 1, #plainText, segmentSize do
				table.move(plainText, i, i + segmentSize - 1, 1, k)
				table.move(xorBytes(q, encrypt(key, km, p, s, t), k), 1, segmentSize, i, b)
				for j = 16, segmentSize + 1, - 1 do
					table.insert(q, 1, p[j])
				end
				table.move(q, 1, 16, 1, p)
			end

			return b
		end,
		decrypt_CFB = function(key : bytes, cipherText : bytes, initVector : bytes, segmentSize : number?)
			: bytes
			local km
			key, cipherText, km, initVector, segmentSize = init(key, cipherText, false, initVector,
				if segmentSize == nil then 1 else segmentSize)

			local b, k, p, q, s, t = {}, {}, initVector, {}, {{}, {}, {}, {}}, {}
			for i = 1, #cipherText, segmentSize do
				table.move(cipherText, i, i + segmentSize - 1, 1, k)
				table.move(xorBytes(q, encrypt(key, km, p, s, t), k), 1, segmentSize, i, b)
				for j = 16, segmentSize + 1, - 1 do
					table.insert(k, 1, p[j])
				end
				table.move(k, 1, 16, 1, p)
			end

			return b
		end,
		-- Output feedback (OFB)
		encrypt_OFB = function(key : bytes, plainText : bytes, initVector : bytes?) 			: bytes
			local km
			key, plainText, km, initVector = init(key, plainText, false, initVector)

			local b, k, p, s, t = {}, {}, initVector, {{}, {}, {}, {}}, {}
			for i = 1, #plainText, 16 do
				table.move(plainText, i, i + 15, 1, k)
				table.move(encrypt(key, km, p, s, t), 1, 16, 1, p)
				table.move(xorBytes(t, k, p), 1, 16, i, b)
			end

			return b
		end,
		-- Counter (CTR)
		encrypt_CTR = function(key : bytes, plainText : bytes, counter : ((bytes) -> bytes) | bytes | { [
			string]: any }?) : bytes
			local km
			key, plainText, km, counter = init(key, plainText, true, counter)

			local b, k, c, s, t, r, n = {}, {}, {}, {{}, {}, {}, {}}, {}, type(counter) == "table", nil
			for i = 1, #plainText, 16 do
				if r then
					if i > 1 and incBytes(counter.InitValue, counter.LittleEndian) then
						table.move(counter.InitOverflow, 1, 16, 1, counter.InitValue)
					end
					table.clear	(c)
					table.move	(counter.Prefix, 1, #counter.Prefix, 1, c)
					table.move	(counter.InitValue, 1, counter.Length, #c + 1, c)
					table.move	(counter.Suffix, 1, #counter.Suffix, #c + 1, c)
				else
					n = convertType(counter(c, (i + 15) / 16))
					assert		(#n == 16, "Counter must be 16 bytes long")
					table.move	(n, 1, 16, 1, c)
				end
				table.move(plainText, i, i + 15, 1, k)
				table.move(xorBytes(c, encrypt(key, km, c, s, t), k), 1, 16, i, b)
			end

			return b
		end,
		pkcs7_padding = function(data, block_size)
			local pad_size = block_size - #data % block_size
			local padding = string.char(pad_size):rep(pad_size)
			return data .. padding
		end,
		pkcs7_unpadding = function(data)
			local pad_size = string.byte(data:sub(-1))
			return data:sub(1, -pad_size - 1)
		end
	}
end

-- ui library
do
	local workspace                     = game:GetService("Workspace")
	local camera                        = workspace.CurrentCamera
	local runservice                    = game:GetService("RunService")
	local userinputservice              = game:GetService("UserInputService")
	local tweenservice                  = game:GetService("TweenService")
	local players                       = game:GetService("Players")
	local localplayer                   = players.LocalPlayer
	local mouse                         = localplayer:GetMouse()
	local newvec2                       = Vector2.new
	local newudim2                      = UDim2.new
	local math                          = math
	local floor                         = math.floor
	local clamp                         = math.clamp
	local abs                           = math.abs
	local string                        = string
	local table                         = table

	do
		local HttpService = game:GetService("HttpService")

		local ENABLE_TRACEBACK = false

		local Signal = {}
		Signal.__index = Signal
		Signal.ClassName = "Signal"

		--- Constructs a new signal.
		-- @constructor Signal.new()
		-- @treturn Signal
		function Signal.new()
			local self = setmetatable({}, Signal)

			self._bindableEvent = Instance.new("BindableEvent")
			self._argMap = {}
			self._source = ENABLE_TRACEBACK and traceback() or ""

			-- Events in Roblox execute in reverse order as they are stored in a linked list and
			-- new connections are added at the head. This event will be at the tail of the list to
			-- clean up memory.
			self._bindableEvent.Event:Connect(function(key)
				self._argMap[key] = nil

				-- We've been destroyed here and there's nothing left in flight.
				-- Let's remove the argmap too.
				-- This code may be slower than leaving this table allocated.
				if (not self._bindableEvent) and (not next(self._argMap)) then
					self._argMap = nil
				end
			end)

			return self
		end

		--- Fire the event with the given arguments. All handlers will be invoked. Handlers follow
		-- Roblox signal conventions.
		-- @param ... Variable arguments to pass to handler
		-- @treturn nil
		function Signal:Fire(...)
			if not self._bindableEvent then
				--warn(("Signal is already destroyed. %s"):format(self._source))
				return
			end

			local args = {...}

			-- TODO: Replace with a less memory/computationally expensive key generation scheme
			local key = 1 + #self._argMap
			self._argMap[key] = args

			-- Queues each handler onto the queue.
			self._bindableEvent:Fire(key)
		end

		--- Connect a new handler to the event. Returns a connection object that can be disconnected.
		-- @tparam function handler Function handler called with arguments passed when `:Fire(...)` is called
		-- @treturn Connection Connection object that can be disconnected
		function Signal:Connect(handler)
			if not (type(handler) == "function") then
				error(("connect(%s)"):format(typeof(handler)), 2)
			end

			return self._bindableEvent.Event:Connect(function(key)
				-- note we could queue multiple events here, but we'll do this just as Roblox events expect
				-- to behave.
				handler(unpack(self._argMap[key]))
			end)
		end

		--- Wait for fire to be called, and return the arguments it was given.
		-- @treturn ... Variable arguments from connection
		function Signal:Wait()
			local key = self._bindableEvent.Event:Wait()
			local args = self._argMap[key]
			if args then
				return unpack(args)
			else
				error("Missing arg data, probably due to reentrance.")
				return nil
			end
		end

		--- Disconnects all connected events to the signal. Voids the signal as unusable.
		-- @treturn nil
		function Signal:Destroy()
			if self._bindableEvent then
				-- This should disconnect all events, but in-flight events should still be
				-- executed.

				self._bindableEvent:Destroy()
				self._bindableEvent = nil
			end

			-- Do not remove the argmap. It will be cleaned up by the cleanup connection.

			setmetatable(self, nil)
		end

		utilities.signal = Signal
	end

	utilities.blockmouseevents = false -- local ones get blocked at certain times
	utilities.nextidentifier = 0
	function utilities.getnextidentifier() -- look man, i couldnt do parenting properly so i had to do this (yes i tried v == val, didnt work), (update: wasnt the issue, no longer needed but cba to remove this now)
		utilities.nextidentifier = utilities.nextidentifier + 1
		local bullshit = tostring(utilities.nextidentifier)
		return bullshit
	end
	-- not smth im proud of but itll work

	function utilities.map(x, a, b, c, d)
		return (x - a) / (b - a) * (d - c) + c
	end

	utilities.base = { -- this is sorta like our camera, we have a defined size n sh so we can parent things to this
		children = {},
		absolutesize = camera.ViewportSize,
		Drawingobject = {
			Size = camera.ViewportSize,
			Position = newvec2(),
			Visible = true
		},
		absoluteposition = newvec2(),
		class = "frame",
		name = "startergui", -- x3
		identifier = utilities.getnextidentifier(),
		visible = true,
		getpropertychangedsignal = utilities.signal.new(),
		updatechildsignal = utilities.signal.new(),
	}

	utilities.base.getpropertychangedsignal:Connect(function(event, val) -- p10000000000000000 parenting fix
		local ident = val.identifier
		local thesechildren = utilities.base.children
		if event == "childadded" then
			thesechildren[ident] = val
		elseif event == "childremoved" then
			thesechildren[ident] = nil
		end
	end)

	camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		task.wait()
		utilities.base.absolutesize = camera.ViewportSize
		utilities.base.Drawingobject.Size = camera.ViewportSize
		utilities.base.visible = false
		utilities.base.updatechildsignal:Fire("visible", false)
		utilities.base.visible = true
		utilities.base.updatechildsignal:Fire("visible", true)
	end)

	utilities.mouse = { -- would rather this than every Drawing object go mouse.move:connect(function() -- bullshit end)
		position = newvec2(mouse.x, mouse.y),
		oldposition = newvec2(),
		mouse1held = false,
		mouse2held = false,
		moved = utilities.signal.new(),
		mousebutton1down = utilities.signal.new(),
		mousebutton2down = utilities.signal.new(),
		mousebutton1up = utilities.signal.new(),
		mousebutton2up = utilities.signal.new(),
		scrollup = utilities.signal.new(),
		scrolldown = utilities.signal.new(),
	}

	userinputservice.InputChanged:Connect(function(input, processed)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			if utilities.blockmouseevents then return end
			utilities.mouse.oldposition = utilities.mouse.position
			utilities.mouse.moved:Fire()
			local xy = userinputservice:GetMouseLocation()
			utilities.mouse.position = newvec2(xy.x, xy.y)
		end
	end)

	userinputservice.InputBegan:Connect(function(input, gameProcessed)
		if utilities.blockmouseevents then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			utilities.mouse.mouse1held = true
			utilities.mouse.mousebutton1down:Fire()
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			utilities.mouse.mouse2held = true
			utilities.mouse.mousebutton2down:Fire()
		end
	end)

	userinputservice.InputEnded:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			utilities.mouse.mouse1held = false
			utilities.mouse.mousebutton1up:Fire()
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			utilities.mouse.mouse2held = false
			utilities.mouse.mousebutton2up:Fire()
		end
	end)

	userinputservice.InputChanged:Connect(function(input)
		if utilities.blockmouseevents then return end
		if input.UserInputType == Enum.UserInputType.MouseWheel then
			if input.Position.Z > 0 then
				utilities.mouse.scrollup:Fire(input.Position.Z)
			else
				utilities.mouse.scrolldown:Fire(input.Position.Z)
			end
		end
	end)

	function utilities.copyarray(original)
		local copied = {}
		for i, v in next, (original) do
			if type(v) == "table" then
				v = utilities.copyarray(v)
			end
			copied[i] = v
		end
		return copied
	end

	function utilities.getclipboard()
		local screen = Instance.new("ScreenGui",game.CoreGui)
		local tb = Instance.new("TextBox",screen)
		tb.TextTransparency = 1

		tb:CaptureFocus()
		keypress(0x11)  
		keypress(0x56)
		task.wait()
		keyrelease(0x11)
		keyrelease(0x56)
		tb:ReleaseFocus()

		local captured = tb.Text

		tb:Destroy()
		screen:Destroy()

		return captured
	end

	utilities.types = {
		frame = "Square",
		text = "Text",
		image = "Image",
	}

	utilities.writeableproperties = {
		anchorpoint = newvec2(),
		parent = utilities.base,
		zindex = 0,
		name = "",
		visible = true,
	}

	utilities.readonlyproperties = {
		Drawing = nil,
		children = {},
		activated = false,
		class = "",
		identifier = "",
		updater = connection,
		absolutesize = newvec2(),
		absoluteposition = newvec2(),
	}

	utilities.events = {
		getpropertychangedsignal = utilities.signal.new(),
		updatechildsignal = utilities.signal.new(), -- time to tell the children to update !
	}

	utilities.activations = {
		hovering = false,
		holding = false,
		clicked = utilities.signal.new(),
		mouseenter = utilities.signal.new(),
		mouseleave = utilities.signal.new()
	}

	utilities.specificproperties = {
		frame = {
			thickness = 0,
			transparency = 0,
			size = newudim2(),
			color = Color3.new(),
			filled = false,
			position = newudim2()
		},
		text = {
			text = "",
			size = 0,
			outline = false,
			color = Color3.new(),
			outlinecolor = Color3.new(),
			position = newudim2(),
			font = Drawing.Fonts.Plex
		},
		image = {
			data = "",
			size = newudim2(),
			position = newudim2(),
			rounding = 0,
		},
	}

	utilities.operationorder = {
		"name",
		"parent",
		"anchorpoint",
		"size",
		"position"
	}

	utilities.updatechildren = {
		position = true,
		size = true,
		visible = true
	}

	utilities.childupdate = { -- the new arg isnt the new pos or anything its what the parent is about to be because this is based off of the parent updating
		absoluteposition = function(obj, parentnew) -- basically think of this as "oo my parent updated this property and my ... property is dependant on that so i need to update it"
			local parent = obj.parent
			local scalex = obj.position.X.Scale
			local scaley = obj.position.Y.Scale
			local offsetx = obj.position.X.Offset
			local offsety = obj.position.Y.Offset

			local anchorx = obj.anchorpoint.x
			local anchory = obj.anchorpoint.y

			local x, y = parent.absolutesize.x * scalex + offsetx, parent.absolutesize.y * scaley + offsety
			x = parentnew.x + x - (obj.absolutesize.x * anchorx)
			y = parentnew.y + y - (obj.absolutesize.y * anchory) -- anchorpoints !!!!!
			x = floor(x + 0.5)
			y = floor(y + 0.5)
			local result = newvec2(x, y)

			obj.getpropertychangedsignal:Fire("absoluteposition", result)
			obj.Drawingobject.Position = result
			obj.absoluteposition = result
		end,
		absolutesize = function(obj, parentnew) -- really awful but it worked
			if obj.class == "text" then return end
			local parent = obj.parent

			local old = obj.absolutesize
			local x, y, result

			local scalex = obj.size.X.Scale
			local scaley = obj.size.Y.Scale
			local offsetx = obj.size.X.Offset
			local offsety = obj.size.Y.Offset
			x, y = parentnew.x * scalex + offsetx, parentnew.y * scaley + offsety
			x = floor(x + 0.5)
			y = floor(y + 0.5)
			result = newvec2(x, y)

			-- since dn (this proeprty is dependant on its actual size so it will have to be updated)
			local anchorx = obj.anchorpoint.x
			local anchory = obj.anchorpoint.y

			local scalex2 = obj.position.X.Scale
			local scaley2 = obj.position.Y.Scale
			local offsetx2 = obj.position.X.Offset
			local offsety2 = obj.position.Y.Offset

			local nut = newvec2(parent.absolutesize.x * scaley2 + offsety2, parent.absolutesize.x * scalex2 + offsetx2)
			local x2 = parent.absoluteposition.x + nut.x - (result.x * anchorx)
			local y2 = parent.absoluteposition.y + nut.y - (result.y * anchory) -- as u can see, we are reusing the previous result
			x2 = floor(x2 + 0.5)
			y2 = floor(y2 + 0.5)
			local result2 = newvec2(x2, y2)

			obj.Drawingobject.Size = result
			obj.absolutesize = result
			obj.getpropertychangedsignal:Fire("absolutesize", result)

			obj.Drawingobject.Position = result2
			obj.absoluteposition = result2
			obj.getpropertychangedsignal:Fire("absoluteposition", result2)
		end,
		visible = function(obj, parentnew)
			local parent = obj.parent
			obj.Drawingobject.Visible = parent.Drawingobject.Visible and obj.visible or false
			utilities.setproperty.shared.activated(obj, obj.activated)
			obj.getpropertychangedsignal:Fire("visible", parent.Drawingobject.Visible and obj.visible or false)
		end,
	}

	utilities.setproperty = { -- so i couldve gone to the __newindex and done if i == "position" then elseif i == "size" and so on but this feels a lot better to do
		shared = { -- how to fix stack overflow 2022
			activated = function(obj, new) -- mildly homosexual (done so that when ur thing isnt visible, it doesnt try to pass mouse related objects) (this also ended up being a lot better for fps than as i was previously doing if thing.visible == false then return end)
				for i, v in next, (obj.mouseconnections) do
					v:Disconnect()
					obj.mouseconnections[i] = v
				end
				if new and obj.Drawingobject.Visible then
					local oldhover = false
					obj.mouseconnections.moved = utilities.mouse.moved:Connect(function()
						obj.hovering = utilities.mousechecks.inbounds(obj, utilities.mouse.position)
						if obj.hovering and oldhover == false then
							obj.mouseenter:Fire()
						end
						if obj.hovering == false and oldhover then
							obj.mouseleave:Fire()
						end
						oldhover = obj.hovering
					end)
					obj.mouseconnections.mouse1down = utilities.mouse.mousebutton1down:Connect(function()
						if obj.hovering then
							obj.clicked:Fire()
							obj.holding = true
						end
					end)
					obj.mouseconnections.mouse2down = utilities.mouse.mousebutton2down:Connect(function()
						if obj.hovering then
							obj.clicked2:Fire()
							obj.holding2 = true
						end
					end)
					obj.mouseconnections.mouse1up = utilities.mouse.mousebutton1up:Connect(function()
						obj.holding = false
					end)
					obj.mouseconnections.mouse2up = utilities.mouse.mousebutton2up:Connect(function()
						obj.holding2 = false
					end)
				end
			end,
			parent = function(obj, new)
				local oldparent = obj.parent

				oldparent.getpropertychangedsignal:Fire("childremoved", obj) -- fuck this, its this things problem now
				table.clear(obj.childupdatespool) -- get rid of the old pool


				local Drawingobj = obj.Drawingobject
				local inque = {} -- minor issue !!

				if obj.updater then
					obj.updater:Disconnect()
				end

				new.getpropertychangedsignal:Fire("childadded", obj)

				for i, v in next, (utilities.childupdate) do
					obj.childupdatespool[i] = v -- save it for ourselves !
					obj.childupdatespool[i](obj, new[i])
					obj.updatechildsignal:Fire(i, obj[i])
				end

				obj.updater = new.updatechildsignal:Connect(function(event, val)
					local isnowvisible = Drawingobj.Visible == false and event == "visible" and val == true
					if obj.childupdatespool[event] then
						obj.childupdatespool[event](obj, new[event])
					end
					if Drawingobj.Visible or isnowvisible or event == "visible" then -- only update if the thing is visible
						obj.updatechildsignal:Fire(event, val) -- how 2 inherit
					else
						inque[event] = val -- ok we missed out on this property
					end
					if isnowvisible then -- we comin' back baby
						for i, v in next, (inque) do -- update the shit we "missed out"
							obj.childupdatespool[i](obj, new[i])
							obj.updatechildsignal:Fire(i, obj[i])
						end
						inque = {}
					end
				end)
			end,
			anchorpoint = function(obj, new) -- kinda fucked but stfu
				local old = obj.absoluteposition

				local parent = obj.parent
				local scalex = obj.position.X.Scale
				local scaley = obj.position.Y.Scale
				local offsetx = obj.position.X.Offset
				local offsety = obj.position.Y.Offset
				local anchorx = new.x
				local anchory = new.y
				local x, y = parent.absolutesize.x * scalex + offsetx, parent.absolutesize.y * scaley + offsety
				x = x - (x * anchorx)
				y = y - (y * anchory) -- anchorpoints !!!!!
				x = floor(x + 0.5) -- floored cuz dn!!!!!!!!
				y = floor(y + 0.5)
				local result = newvec2(x, y)

				obj.Drawingobject.Position = result
				obj.absoluteposition = obj.Drawingobject.Position
				obj.getpropertychangedsignal:Fire("anchorpoint", new)
				obj.getpropertychangedsignal:Fire("absoluteposition", obj.Drawingobject.Position)
				obj.updatechildsignal:Fire("absoluteposition", result)
			end,
			position = function(obj, new)
				local old = obj.absoluteposition
				local parent = obj.parent
				local scalex = new.X.Scale
				local scaley = new.Y.Scale
				local offsetx = new.X.Offset
				local offsety = new.Y.Offset
				local anchorx = obj.anchorpoint.x
				local anchory = obj.anchorpoint.y
				local x, y = parent.absolutesize.x * scalex + offsetx, parent.absolutesize.y * scaley + offsety
				x = parent.absoluteposition.x + x - (obj.absolutesize.x * anchorx)
				y = parent.absoluteposition.y + y - (obj.absolutesize.y * anchory) -- anchorpoints !!!!!
				x = floor(x + 0.5)
				y = floor(y + 0.5)
				local result = newvec2(x, y)
				obj.Drawingobject.Position = result
				obj.absoluteposition = obj.Drawingobject.Position

				obj.getpropertychangedsignal:Fire("position", new)
				obj.getpropertychangedsignal:Fire("absoluteposition", obj.Drawingobject.Position)
				obj.updatechildsignal:Fire("absoluteposition", obj.Drawingobject.Position)
			end,
			zindex = function(obj, new)
				obj.Drawingobject.ZIndex = new
				obj.getpropertychangedsignal:Fire("zindex", new)
			end,
			visible = function(obj, new)
				local parent = obj.parent
				obj.Drawingobject.Visible = (parent.Drawingobject.Visible and parent.visible and new == true) and true or false
				obj.getpropertychangedsignal:Fire("visible", obj.Drawingobject.Visible)
				obj.updatechildsignal:Fire("visible", obj.Drawingobject.Visible)
				utilities.setproperty.shared.activated(obj, obj.activated)
			end,
			transparency = function(obj, new)
				obj.Drawingobject.Opacity = new
				obj.getpropertychangedsignal:Fire("transparency", new)
			end,
		},
		frame = { -- ok this fucked up a bit but stfu
			color = function(obj, new)
				obj.Drawingobject.Color = new
				obj.getpropertychangedsignal:Fire("color", new)
			end,
			thickness = function(obj, new)
				obj.Drawingobject.Thickness = new
				obj.getpropertychangedsignal:Fire("thickness", new)
			end,
			filled = function(obj, new)
				obj.Drawingobject.Filled = new
				obj.getpropertychangedsignal:Fire("filled", new)
			end,
			size = function(obj, new) -- this couldve been done for each class like it shouldve but i had too many stack overflows so ripbozo
				local parent = obj.parent

				local old = obj.absolutesize
				local x, y, result

				local scalex = new.X.Scale
				local scaley = new.Y.Scale
				local offsetx = new.X.Offset
				local offsety = new.Y.Offset
				x, y = parent.absolutesize.x * scalex + offsetx, parent.absolutesize.y * scaley + offsety
				x = floor(x + 0.5)
				y = floor(y + 0.5)
				result = newvec2(x, y)

				obj.Drawingobject.Size = result
				obj.absolutesize = obj.Drawingobject.Size

				obj.getpropertychangedsignal:Fire("size", new)
				obj.getpropertychangedsignal:Fire("absolutesize", obj.Drawingobject.Size)
				obj.updatechildsignal:Fire("absolutesize", obj.Drawingobject.Size)

				utilities.setproperty.shared.position(obj, obj.position)
			end,
		},
		text = {
			color = function(obj, new)
				obj.Drawingobject.Color = new
				obj.getpropertychangedsignal:Fire("color", new)
			end,
			text = function(obj, new)
				obj.Drawingobject.Text = new
				obj.getpropertychangedsignal:Fire("text", new)
				utilities.setproperty.text.size(obj, obj.size)
			end,
			size = function(obj, new) -- this couldve been done for each class like it shouldve but i had too many stack overflows so ripbozo
				local parent = obj.parent

				local old = obj.absolutesize
				local x, y, result

				obj.Drawingobject.Size = new -- a bit fucked
				result = obj.Drawingobject.TextBounds
				x = floor(result.x)
				y = floor(result.y)
				result = newvec2(x, y)

				obj.absolutesize = result

				obj.getpropertychangedsignal:Fire("size", new)
				obj.getpropertychangedsignal:Fire("absolutesize", obj.absolutesize)
				obj.updatechildsignal:Fire("absolutesize", result)
				utilities.setproperty.shared.position(obj, obj.position)
			end,
			font = function(obj, new)
				obj.Drawingobject.Font = new
				obj.getpropertychangedsignal:Fire("font", new)
			end,
			outline = function(obj, new)
				obj.Drawingobject.Outlined = new
				obj.getpropertychangedsignal:Fire("outline", new)
			end,
			outlinecolor = function(obj, new)
				obj.Drawingobject.OutlineColor = new
				obj.getpropertychangedsignal:Fire("outlinecolor", new)
			end,
		},
		image = {
			data = function(obj, new)
				--obj.Drawingobject.Data = new
				obj.getpropertychangedsignal:Fire("data", new)
			end,
			rounding = function(obj, new)
				obj.Drawingobject.Rounding = new
				obj.getpropertychangedsignal:Fire("rounding", new)
			end,
			size = function(obj, new) -- this couldve been done for each class like it shouldve but i had too many stack overflows so ripbozo
				local parent = obj.parent

				local old = obj.absolutesize
				local x, y, result

				local scalex = new.X.Scale
				local scaley = new.Y.Scale
				local offsetx = new.X.Offset
				local offsety = new.Y.Offset
				x, y = parent.absolutesize.x * scalex + offsetx, parent.absolutesize.y * scaley + offsety
				x = floor(x + 0.5)
				y = floor(y + 0.5)
				result = newvec2(x, y)

				obj.Drawingobject.Size = result
				obj.absolutesize = result

				obj.getpropertychangedsignal:Fire("size", new)
				obj.getpropertychangedsignal:Fire("absolutesize", obj.Drawingobject.Size)
				obj.updatechildsignal:Fire("absolutesize", result)
				utilities.setproperty.shared.position(obj, obj.position)
			end,
		},
	}

	utilities.mousechecks = { -- uhhhhh these r things to help with ur mouse related shit
		inbounds = function(obj, pos)
			if obj.Drawingobject.Visible == false then return false end
			local lowx = obj.absoluteposition.x
			local highx = lowx + obj.absolutesize.x
			local lowy = obj.absoluteposition.y
			local highy = lowy + obj.absolutesize.y
			local mousex = pos.x
			local mousey = pos.y

			if mousex > lowx and mousex < highx and mousey > lowy and mousey < highy then
				return true
			else
				return false
			end
		end,
	}

	function utilities.createproperties(obj, active) -- ugh
		local properties = {}
		local writeableproperties = {
			anchorpoint = newvec2(),
			parent = utilities.base,
			zindex = 0,
			name = "",
			visible = true,
		}

		local readonlyproperties = {
			Drawing = nil,
			children = {},
			activated = false,
			class = "",
			identifier = "",
			updater = connection,
			childupdatespool = {},
			absolutesize = newvec2(),
			absoluteposition = newvec2(),
		}

		local events = {
			getpropertychangedsignal = utilities.signal.new(),
			updatechildsignal = utilities.signal.new(), -- time to tell the children to update !
		}

		local activations = {
			hovering = false,
			holding = false,
			holding2 = false,
			clicked = utilities.signal.new(),
			clicked2 = utilities.signal.new(),
			mouseenter = utilities.signal.new(),
			mouseleave = utilities.signal.new()
		}

		local specificproperties = {
			frame = {
				thickness = 0,
				transparency = 1,
				size = newudim2(),
				color = Color3.new(),
				filled = false,
				position = newudim2()
			},
			text = {
				text = "",
				size = 0,
				outline = false,
				color = Color3.new(),
				transparency = 1,
				outlinecolor = Color3.new(),
				position = newudim2(),
				font = Drawing.Fonts.Plex
			},
			image = {
				data = "",
				size = newudim2(),
				color = Color3.new(),
				transparency = 1,
				position = newudim2(),
				rounding = 0,
			},
		}

		for i, v in next, ({writeableproperties, readonlyproperties, events, activations, specificproperties[obj]}) do
			for i2, v2 in next, (v) do
				properties[i2] = v2 
				v2 = nil
			end
			table.clear(v) -- get rid of it
		end
		return properties
	end


	function utilities:draw(object, properties) -- basically, updating the properties table will update the actual Drawing object
		local kind = utilities.types[object]
		local Drawingobject = Drawing.new(kind)

		local Drawing = {}
		Drawing.__index = Drawing

		local propertylist = utilities.createproperties(object, properties.activated)
		for i, v in next, (propertylist) do
            Drawing[i] = v
		end

		Drawing.identifier = utilities.getnextidentifier() -- increment$per$Drawing$$
		Drawing.class = object
		Drawing.Drawingobject = Drawingobject
		Drawing.activated = properties.activated
		Drawing.mouseconnections = {}

		local proxy = Drawing -- proxy for metatable stuff

		local newindexpool = {} -- this is our pool of corresponding newindex funcs
		for i, v in next, (utilities.setproperty[object]) do -- specific funcs
			newindexpool[i] = v
		end
		for i, v in next, (utilities.setproperty.shared) do -- add shared funcs
			newindexpool[i] = v
		end

		Drawing = setmetatable({}, { -- set the mt
			__index = function(self, i)
				return proxy[i]
			end,
			__newindex = function(self, i, v)
				if newindexpool[i] then -- is there a special way to update this property or na
					newindexpool[i](self, v) -- update the property how it should be
				end
				proxy[i] = v
			end
		})

		function Drawing:destroy() -- errors a bit but itll do
			Drawing.parent.getpropertychangedsignal:Fire("childremoved", Drawing) -- no more parent :sad:
			Drawing.visible = false -- :wave:
			Drawing.Drawingobject:Remove()
			Drawing.Drawingobject = nil
			Drawing.getpropertychangedsignal:Fire("parentdestroyed") -- get rid of the chain of shit
			table.clear(Drawing)
			Drawing = nil
		end

		Drawing.getpropertychangedsignal:Connect(function(event, val) -- p10000000000000000 parenting fix
			local DrawingChildren = Drawing.children
			local ident = val and type(val) == "table" and val.identifier
			if event == "childadded" then
				DrawingChildren[ident] = val
			elseif event == "childremoved" then -- although its kinda dumb, id say its not too bad becuz its faster than iterating thru god knows how many children and comparing tables
				DrawingChildren[ident] = nil
			elseif event == "parentdestroyed" then
				Drawing:destroy()
			end
		end)

		-- i had to.. sorry!!!!
		local propertiesinque = {}
		for i, v in ipairs(utilities.operationorder) do
			if properties[v] then
				propertiesinque[1 + #propertiesinque] = {
					key = v,
					value = properties[v]
				}
				properties[v] = nil
			end
		end

		for i, v in next, (properties) do
			propertiesinque[1 + #propertiesinque] = {
				key = i,
				value = v
			}
		end

		for i, v in ipairs(propertiesinque) do
			local property = v.key
			local value = v.value
			Drawing[property] = value
		end

		Drawings[1 + #Drawings] = Drawing -- keep a record of it just in case
		return Drawing
	end

	local uilib = {}
	uilib.__index = uilib
	function uilib:start(parameters)
		-- okay actual design starts
		local httpservice = game:GetService("HttpService")
		local menu = {}
		menu.__index = menu
		menu.basezindex = parameters.basezindex or 69420 -- haha funny
		menu.startingParameters = parameters
		menu.uiopen = true
		menu.dragging = false
		menu.objects = {}
		menu.username = "developer"
		menu.flags = {}
		menu.isadropdownopen = false -- shitty fix but itll work
		menu.isacolorpickeropen = false
		menu.tabs = {}
		menu.subsections = {}
		menu.subtabs = {}
		menu.directory = {}
		menu.openclose = {} -- things that are to have the open and close animation
		menu.elements = {}
		menu.activations = {}
		menu.accent = parameters.accent
		menu.cheatname = parameters.name
		menu.accents = {}
		menu.imagecache = {}

		menu.validkeys = {
			"A",
			"B",
			"C",
			"D",
			"E",
			"F",
			"G",
			"H",
			"I",
			"J",
			"K",
			"L",
			"M",
			"N",
			"O",
			"P",
			"Q",
			"R",
			"S",
			"T",
			"U",
			"V",
			"W",
			"X",
			"Y",
			"Z",
		}

		menu.validnumberkeys = {
			One = "1",
			Two = "2",
			Three = "3",
			Four = "4",
			Five = "5",
			Six = "6",
			Seven = "7",
			Eight = "8",
			Nine = "9",
			Zero = "0",
			LeftBracket = "[",
			RightBracket = "]",
			Semicolon = "",
			BackSlash = "\\",
			Slash = "/",
			Minus = "-",
			Equals = "=",
			Backquote = "`",
			Plus = "+",
			Comma = ",",
			Period = ".",
		}

		local colorpickerClipBoard
		local menucolors = parameters.colors
		local colorGroups = {}
		for i, v in next, parameters.colors do
			colorGroups[i] = {}
		end

		local DrawingFunction = function(object, props)
			local thisDrawing = utilities:draw(object, props)
			for i, v in next, parameters.colors do
				if props.color == v then
					local nextIndex = 1 + #colorGroups[i]
					colorGroups[i][nextIndex] = thisDrawing
				end
			end
			return thisDrawing
		end
		menu.colorGroups = colorGroups
		menu.DrawingFunction = DrawingFunction

		menu.objects.backborder = DrawingFunction("frame", {
			parent = utilities.base,
			anchorpoint = newvec2(0, 0),
			size = newudim2(0, parameters.size.x, 0, parameters.size.y),
			position = newudim2(0, (utilities.base.absolutesize.x / 2) + (-parameters.size.x / 2), 0, (utilities.base.absolutesize.y / 2) + (-parameters.size.y / 2)), -- sex
			zindex = menu.basezindex + -3,
			color = parameters.colors.a,
			visible = false,
			thickness = 1,
			transparency = 1,
			filled = false,
			name = "okay",
		})
		menu.openclose[1 + #menu.openclose] = menu.objects.backborder

		local fuck = Instance.new("ScreenGui", game.CoreGui) -- not something im happy about but this is so that clicking on the ui blocks every other click
		local bitch = Instance.new("Frame", fuck)
		bitch.Size = newudim2(0, 0, 0, 0)
		bitch.Active = true
		bitch.Selectable = true
		bitch.Transparency = 1
		bitch.Position = newudim2(0, 0, 0, 0)

		menu.objects.backborder.getpropertychangedsignal:Connect(function(prop, val)
			if prop == "visible" then
				bitch.Visible = val
			end
		end)

		menu.objects.dragdetection = DrawingFunction("frame", { -- uh dn
			parent = menu.objects.backborder,
			anchorpoint = newvec2(0.5, 0),
			size = newudim2(1, 0, 0, 14),
			position = newudim2(0.5, 0, 0, 0),
			zindex = menu.basezindex + 12,
			color = Color3.fromRGB(255, 255, 255),
			visible = true,
			thickness = 0,
			transparency = 0,
			filled = true,
			activated = true,
			name = "okay 2",
		})

		menu.objects.resizedetection = DrawingFunction("frame", { -- yes, this is a thing
			parent = menu.objects.backborder,
			anchorpoint = newvec2(1, 1),
			size = newudim2(0, 8, 0, 8),
			position = newudim2(1, 0, 1, 0),
			zindex = menu.basezindex + 12,
			color = Color3.fromRGB(255, 255, 255),
			visible = true,
			thickness = 0,
			transparency = 0,
			filled = true,
			activated = true,
			name = "okay 2",
		})

		function menu:setsize(size)
			menu.objects.backborder.size = newudim2(0, math.min(size.x, parameters.size.x), 0, math.min(size.y, parameters.size.y))
		end

		local outerTransparency = 0.75
		local outerTransparency2 = 0.65

		menu.objects.outerfirst = DrawingFunction("frame", {
			parent = menu.objects.backborder,
			anchorpoint = newvec2(0.5, 0.5),
			size = newudim2(1, -2, 1, -2),
			position = newudim2(0.5, 0, 0.5, 0), -- sex
			zindex = menu.basezindex + -2,
			color = parameters.colors.b,
			visible = true,
			thickness = 1,
			transparency = outerTransparency,
			filled = false,
			name = "okay",
		})
		menu.openclose[1 + #menu.openclose] = menu.objects.outerfirst

		menu.objects.outersecond1 = DrawingFunction("frame", {
			parent = menu.objects.outerfirst,
			anchorpoint = newvec2(0.5, 0.5),
			size = newudim2(1, -2, 1, -2),
			position = newudim2(0.5, 0, 0.5, 0), -- sex
			zindex = menu.basezindex + -2,
			color = parameters.colors.c,
			visible = true,
			thickness = 1,
			transparency = outerTransparency,
			filled = false,
			name = "okay",
		})
		menu.openclose[1 + #menu.openclose] = menu.objects.outersecond1

		menu.objects.outersecond = DrawingFunction("frame", {
			parent = menu.objects.outersecond1,
			anchorpoint = newvec2(0.5, 0.5),
			size = newudim2(1, -2, 1, -2),
			position = newudim2(0.5, 0, 0.5, 0), -- sex
			zindex = menu.basezindex + -2,
			color = parameters.colors.c,
			visible = true,
			thickness = 1,
			transparency = outerTransparency,
			filled = false,
			name = "okay",
		})
		menu.openclose[1 + #menu.openclose] = menu.objects.outersecond

		menu.objects.outerthird = DrawingFunction("frame", {
			parent = menu.objects.outersecond,
			anchorpoint = newvec2(0.5, 0.5),
			size = newudim2(1, -2, 1, -2),
			position = newudim2(0.5, 0, 0.5, 0), -- sex
			zindex = menu.basezindex + -2,
			color = parameters.colors.b,
			visible = true,
			thickness = 1,
			transparency = outerTransparency,
			filled = false,
			name = "okay",
		})
		menu.openclose[1 + #menu.openclose] = menu.objects.outerthird

		menu.objects.innerfirst = DrawingFunction("frame", {
			parent = menu.objects.outerthird,
			anchorpoint = newvec2(0.5, 0.5),
			size = newudim2(1, -2, 1, -2),
			position = newudim2(0.5, 0, 0.5, 0), -- sex
			zindex = menu.basezindex + -2,
			color = parameters.colors.a,
			visible = true,
			thickness = 0,
			transparency = outerTransparency2,
			filled = true,
			name = "okay",
		})
		menu.openclose[1 + #menu.openclose] = menu.objects.innerfirst

		menu.objects.tabsholder = DrawingFunction("frame", {
			parent = menu.objects.outerthird,
			anchorpoint = newvec2(0.5, 0),
			size = newudim2(1, -38, 0, 18),
			position = newudim2(0.5, 0, 0, 8), -- sex
			zindex = menu.basezindex + -2,
			color = Color3.new(1, 1, 1),
			visible = true,
			thickness = 0,
			transparency = 0,
			filled = true,
			name = "okay",
		})

		menu.objects.containerfirst = DrawingFunction("frame", {
			parent = menu.objects.outerthird,
			anchorpoint = newvec2(0.5, 0.5),
			size = newudim2(1, -36, 1, -48),
			position = newudim2(0.5, 0, 0.5, 8), -- sex
			zindex = menu.basezindex + -2,
			color = parameters.colors.a,
			visible = true,
			thickness = 1,
			transparency = 1,
			filled = false,
			name = "okay",
		})
		menu.openclose[1 + #menu.openclose] = menu.objects.containerfirst

		menu.objects.containersecond = DrawingFunction("frame", {
			parent = menu.objects.containerfirst,
			anchorpoint = newvec2(0.5, 0.5),
			size = newudim2(1, -2, 1, -2),
			position = newudim2(0.5, 0, 0.5, 0), -- sex
			zindex = menu.basezindex + -2,
			color = parameters.colors.c,
			visible = true,
			thickness = 1,
			transparency = 1,
			filled = false,
			name = "okay",
		})
		menu.openclose[1 + #menu.openclose] = menu.objects.containersecond

		menu.objects.maincontainer = DrawingFunction("frame", {
			parent = menu.objects.containersecond,
			anchorpoint = newvec2(0.5, 0.5),
			size = newudim2(1, -2, 1, -2),
			position = newudim2(0.5, 0, 0.5, 0), -- sex
			zindex = menu.basezindex + -2,
			color = parameters.colors.e,
			visible = true,
			thickness = 0,
			transparency = 1,
			filled = true,
			name = "okay",
		})
		menu.openclose[1 + #menu.openclose] = menu.objects.maincontainer

		menu.objects.tabs = {}

		local function openedtab(tab) -- fuck u fuck u fuck u
			if menu.uiopen == false then return end
			for i, v in next, (menu.objects.tabs) do
				local this = v
				if i ~= tab then -- not us
					if this.maincontainer.visible ~= false then
						this.maincontainer.visible = false
						for i2, v2 in next, (this.toggle) do
							v2.visible = false
						end
					end
				else
					if this.maincontainer.visible ~= true then
						this.maincontainer.visible = true
						this.maincontainer.position = this.maincontainer.position
						this.maincontainer.size = this.maincontainer.size
						for i2, v2 in next, (this.toggle) do
							v2.visible = true
						end
					end
				end
			end
		end

		for i, v in next, (parameters.tabs) do
			local this = {}
			local tab = v
			this.maincontainer = DrawingFunction("frame", { -- thing
				parent = menu.objects.maincontainer,
				anchorpoint = newvec2(0.5, 0.5),
				size = newudim2(1, -32, 1, -32),
				position = newudim2(0.5, 0, 0.5, 0),
				zindex = menu.basezindex + 1,
				color = Color3.fromRGB(46, 46, 46),
				visible = false,
				thickness = 0,
				transparency = 0,
				filled = true,
				name = "okay",
			})

			this.elementbox = DrawingFunction("frame", { -- actually holds buttons n shit
				parent = this.maincontainer,
				anchorpoint = newvec2(0.5, 0.5),
				size = newudim2(1, 0, 1, 0),
				position = newudim2(0.5, 0, 0.5, 0),
				zindex = menu.basezindex + 2,
				color = Color3.new(1, 1, 1),
				visible = true,
				thickness = 0,
				transparency = 0,
				filled = true,
				name = "okay",
			})

			this.titleback = DrawingFunction("frame", {
				parent = menu.objects.tabsholder,
				anchorpoint = newvec2(0, 0.5),
				size = newudim2(1 / #parameters.tabs, 0, 1, 0),
				position = newudim2((i - 1) * (1 / #parameters.tabs), 0, 0.5, 0),
				zindex = menu.basezindex + 2,
				color = Color3.fromRGB(46, 46, 46),
				visible = true,
				thickness = 0,
				transparency = 0,
				filled = true,
				activated = true,
				name = "okay",
			})

			this.title = DrawingFunction("text", {
				parent = this.titleback,
				anchorpoint = newvec2(0, 0),
				size = 13, -- x3
				font = Drawing.Fonts.Plex,
				position = newudim2(0.5, -((#tab * 7)/2), 0.5, -8),
				zindex = menu.basezindex + 4,
				color = Color3.fromRGB(255, 255, 255),
				visible = true,
				text = tab,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.title

			this.toggleback = {}
			this.toggle = {}
			for i2 = 1, 2 do -- what the fuck??
				this.toggleback[i2] = DrawingFunction("frame", {
					parent = this.titleback,
					anchorpoint = newvec2(0.5, 0),
					size = newudim2(1, -4, 0, 2),
					position = newudim2(0.5, 0, 0, 15 + (i2 * 2)),
					zindex = menu.basezindex + 2,
					color = parameters.colors.f:lerp(parameters.colors.g, (i2 - 1) / 1),
					visible = true,
					thickness = 0,
					transparency = 1,
					filled = true,
					name = "okay",
				})
				menu.openclose[1 + #menu.openclose] = this.toggleback[i2]

				this.toggle[i2] = DrawingFunction("frame", {
					parent = this.titleback,
					anchorpoint = newvec2(0.5, 0),
					size = newudim2(1, -4, 0, 2),
					position = newudim2(0.5, 0, 0, 15 + (i2 * 2)),
					zindex = menu.basezindex + 2,
					color = parameters.accent:lerp(Color3.fromRGB(math.clamp((parameters.accent.r * 255) - 100, 0, 255), math.clamp((parameters.accent.g * 255) - 100, 0, 255), math.clamp((parameters.accent.b * 255) - 100, 0, 255)), ((i2 - 1) / 1)),
					visible = i == 1,
					thickness = 0,
					transparency = 1,
					filled = true,
					name = "okay",
				})
				menu.openclose[1 + #menu.openclose] = this.toggle[i2]
			end
			menu.accents[1 + #menu.accents] = {this.toggle, "tabs"}

			menu.objects.tabs[tab] = this
			menu.subsections[tab] = {}
			menu.subtabs[tab] = {}
			menu.subsections[tab][1] = {}
			menu.subsections[tab][2] = {}
			menu.tabs[tab] = this.elementbox
			menu.directory[tab] = {}
			menu.elements[tab] = {}

			this.titleback.clicked:Connect(function()
				openedtab(tab)
			end)
		end

		openedtab(parameters.tabs[1])

		function menu:createsubsection(param) -- hiii gassy wassy <3
			local tab = param.tab
			local targettab = menu.tabs[tab]
			local name = param.name
			local side = param.side
			--local length = floor((parameters.length * targettab.absolutesize.y) + 0.5)
			local this = {}

			local xoffset = 0
			local yoffset = 0

			-- check the bounds
			local lastid = 0
			for i, v in next, (menu.subsections[tab][side]) do
				yoffset = yoffset + v.bounds.y
				if v.id > lastid then
					lastid = v.id
				end
			end
			this.id = lastid + 1
			xoffset = (side - 1) * targettab.absolutesize.x / 2
			yoffset = yoffset / targettab.absolutesize.y

			this.maincontainer = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = targettab,
				anchorpoint = newvec2(0, 0),
				size = newudim2(0.5, 0, param.length, 0),
				position = newudim2((side - 1) / 2, 0, yoffset, 0),
				zindex = menu.basezindex + 5,
				color = Color3.fromRGB(0, 0, 0),
				visible = true,
				thickness = 0,
				transparency = 0,
				activated = true,
				filled = true,
				name = "okay",
			})
			this.container = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = this.maincontainer,
				anchorpoint = newvec2(0.5, 0.5),
				size = newudim2(1, -16, 1, -16),
				position = newudim2(0.5, 0, 0.5, 0),
				zindex = menu.basezindex + 6,
				color = parameters.colors.e,
				visible = true,
				thickness = 0,
				transparency = 1,
				filled = true,
				activated = true,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.container

			do
				local scrollBar = {}
				scrollBar.maincontainer = DrawingFunction("frame", { -- for getting the bounds of the thing
					parent = this.container,
					anchorpoint = newvec2(0, 0.5),
					size = newudim2(0, 3, 1, 0),
					position = newudim2(1, -3, 0.5, 0),
					zindex = menu.basezindex + 7,
					color = parameters.colors.c,
					visible = false,
					thickness = 0,
					filled = true,
					activated = true,
					name = "okay",
				})
				menu.openclose[1 + #menu.openclose] = scrollBar.maincontainer
				scrollBar.scroller = DrawingFunction("frame", { -- for getting the bounds of the thing
					parent = scrollBar.maincontainer,
					anchorpoint = newvec2(1, 0),
					size = newudim2(0, 2, 0.5, 0),
					position = newudim2(1, 0, 0, 1),
					zindex = menu.basezindex + 8,
					--color = parameters.colors.f,
					color = menu.accent,
					visible = false,
					thickness = 0,
					filled = true,
					name = "okay",
				})
				menu.openclose[1 + #menu.openclose] = scrollBar.scroller
				menu.accents[1 + #menu.accents] = scrollBar.scroller

				if not param.ignoreScrolling then
					utilities.mouse.scrollup:Connect(function(d)
						if menu.isadropdownopen  or menu.isacolorpickeropen or menu.uiopen == false then return end
						if utilities.mousechecks.inbounds(this.container, utilities.mouse.position) and this.container.Drawingobject.Visible and scrollBar.maincontainer.Drawingobject.Visible then
							local currentY = scrollBar.scroller.position.Y.Offset - (d * 10)
							currentY = math.clamp(currentY, 1, scrollBar.maincontainer.absolutesize.y - scrollBar.scroller.absolutesize.y - 1)
							scrollBar.scroller.position = newudim2(1, 0, 0, currentY)

							local scrolledBy = (currentY - 1) / (scrollBar.maincontainer.absolutesize.y - scrollBar.scroller.absolutesize.y - 1)

							local shitInPanel = 8
							for i, v in next, (menu.elements[tab][name]) do
								if type(v) == "table" then
									shitInPanel = shitInPanel + v.bounds.y
								end
							end
							shitInPanel = shitInPanel + 24

							for i, v in next, (menu.elements[tab][name]) do
								if type(v) == "table" then
									local theFlag = v.myflag

									if theFlag.type == "toggle" or theFlag.type == "button" or theFlag.type == "textbox" then
										v.hitbox.position = newudim2(v.hitbox.position.X.Scale, v.hitbox.position.X.Offset, -scrolledBy * ((shitInPanel - this.container.absolutesize.y) / this.container.absolutesize.y), v.hitbox.position.Y.Offset)
										if v.hitbox.absoluteposition.y + v.bounds.y > ((this.container.absolutesize.y + this.container.absoluteposition.y) - 8) or v.hitbox.absoluteposition.y < this.container.absoluteposition.y then
											v.hitbox.visible = false
										else
											v.hitbox.visible = true

											v.hitbox.size = v.hitbox.size + newudim2(0, 1, 0, 1)
											v.hitbox.size = v.hitbox.size - newudim2(0, 1, 0, 1)
										end
									elseif theFlag.type == "slider" or theFlag.type == "dropdown" then
										v.holder.position = newudim2(v.holder.position.X.Scale, v.holder.position.X.Offset, -scrolledBy * ((shitInPanel - this.container.absolutesize.y) / this.container.absolutesize.y), v.holder.position.Y.Offset)
										if v.holder.absoluteposition.y + v.bounds.y > ((this.container.absolutesize.y + this.container.absoluteposition.y) - 8) or v.holder.absoluteposition.y < this.container.absoluteposition.y then
											v.holder.visible = false
										else
											v.holder.visible = true

											v.holder.size = v.holder.size + newudim2(0, 1, 0, 1)
											v.holder.size = v.holder.size - newudim2(0, 1, 0, 1)
										end
									end
								end
							end
						end
					end)
					utilities.mouse.scrolldown:Connect(function(d)
						if menu.isadropdownopen  or menu.isacolorpickeropen or menu.uiopen == false then return end
						if utilities.mousechecks.inbounds(this.container, utilities.mouse.position) and this.container.Drawingobject.Visible and scrollBar.maincontainer.Drawingobject.Visible then
							local currentY = scrollBar.scroller.position.Y.Offset - (d * 10)
							currentY = math.clamp(currentY, 1, scrollBar.maincontainer.absolutesize.y - scrollBar.scroller.absolutesize.y - 1)
							scrollBar.scroller.position = newudim2(1, 0, 0, currentY)

							local scrolledBy = (currentY - 1) / (scrollBar.maincontainer.absolutesize.y - scrollBar.scroller.absolutesize.y - 1)

							local shitInPanel = 8
							for i, v in next, (menu.elements[tab][name]) do
								if type(v) == "table" then
									shitInPanel = shitInPanel + v.bounds.y
								end
							end
							shitInPanel = shitInPanel + 24

							for i, v in next, (menu.elements[tab][name]) do
								if type(v) == "table" then
									local theFlag = v.myflag

									if theFlag.type == "toggle" or theFlag.type == "button" or theFlag.type == "textbox" then
										v.hitbox.position = newudim2(v.hitbox.position.X.Scale, v.hitbox.position.X.Offset, -scrolledBy * ((shitInPanel - this.container.absolutesize.y) / this.container.absolutesize.y), v.hitbox.position.Y.Offset)
										if v.hitbox.absoluteposition.y + v.bounds.y > ((this.container.absolutesize.y + this.container.absoluteposition.y) - 8) or v.hitbox.absoluteposition.y < this.container.absoluteposition.y then
											v.hitbox.visible = false
										else
											v.hitbox.visible = true

											v.hitbox.size = v.hitbox.size + newudim2(0, 1, 0, 1)
											v.hitbox.size = v.hitbox.size - newudim2(0, 1, 0, 1)
										end
									elseif theFlag.type == "slider" or theFlag.type == "dropdown" then
										v.holder.position = newudim2(v.holder.position.X.Scale, v.holder.position.X.Offset, -scrolledBy * ((shitInPanel - this.container.absolutesize.y) / this.container.absolutesize.y), v.holder.position.Y.Offset)
										if v.holder.absoluteposition.y + v.bounds.y > ((this.container.absolutesize.y + this.container.absoluteposition.y) - 8) or v.holder.absoluteposition.y < this.container.absoluteposition.y then
											v.holder.visible = false
										else
											v.holder.visible = true

											v.holder.size = v.holder.size + newudim2(0, 1, 0, 1)
											v.holder.size = v.holder.size - newudim2(0, 1, 0, 1)
										end
									end
								end
							end
						end
					end)
				end

				if not param.ignoreScrolling then
					scrollBar.maincontainer.clicked:Connect(function()
						if menu.isadropdownopen  or menu.isacolorpickeropen or menu.uiopen == false then return end
						scrollBar.updaterConn = utilities.mouse.moved:Connect(function()
							local currentY = utilities.mouse.position.y - scrollBar.maincontainer.absoluteposition.y - math.floor(scrollBar.scroller.absolutesize.y / 2)
							currentY = math.clamp(currentY, 1, scrollBar.maincontainer.absolutesize.y - scrollBar.scroller.absolutesize.y - 1)
							scrollBar.scroller.position = newudim2(1, 0, 0, currentY)

							local scrolledBy = (currentY - 1) / (scrollBar.maincontainer.absolutesize.y - scrollBar.scroller.absolutesize.y - 1)

							local shitInPanel = 8
							for i, v in next, (menu.elements[tab][name]) do
								if type(v) == "table" then
									shitInPanel = shitInPanel + v.bounds.y
								end
							end
							shitInPanel = shitInPanel + 24

							for i, v in next, (menu.elements[tab][name]) do
								if type(v) == "table" then
									local theFlag = v.myflag

									if theFlag.type == "toggle" or theFlag.type == "button" or theFlag.type == "textbox" then
										v.hitbox.position = newudim2(v.hitbox.position.X.Scale, v.hitbox.position.X.Offset, -scrolledBy * ((shitInPanel - this.container.absolutesize.y) / this.container.absolutesize.y), v.hitbox.position.Y.Offset)
										if v.hitbox.absoluteposition.y + v.bounds.y > ((this.container.absolutesize.y + this.container.absoluteposition.y) - 8) or v.hitbox.absoluteposition.y < this.container.absoluteposition.y then
											v.hitbox.visible = false
										else
											v.hitbox.visible = true

											v.hitbox.size = v.hitbox.size + newudim2(0, 1, 0, 1)
											v.hitbox.size = v.hitbox.size - newudim2(0, 1, 0, 1)
										end
									elseif theFlag.type == "slider" or theFlag.type == "dropdown" then
										v.holder.position = newudim2(v.holder.position.X.Scale, v.holder.position.X.Offset, -scrolledBy * ((shitInPanel - this.container.absolutesize.y) / this.container.absolutesize.y), v.holder.position.Y.Offset)
										if v.holder.absoluteposition.y + v.bounds.y > ((this.container.absolutesize.y + this.container.absoluteposition.y) - 8) or v.holder.absoluteposition.y < this.container.absoluteposition.y then
											v.holder.visible = false
										else
											v.holder.visible = true

											v.holder.size = v.holder.size + newudim2(0, 1, 0, 1)
											v.holder.size = v.holder.size - newudim2(0, 1, 0, 1)
										end
									end
								end
							end
						end)
					end)

					utilities.mouse.mousebutton1up:Connect(function()
						if scrollBar.updaterConn then 
							scrollBar.updaterConn:Disconnect()
						end
					end)
					this.scrollBar = scrollBar
				end
			end

			this.containeroutline = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = this.container,
				anchorpoint = newvec2(0.5, 0.5),
				size = newudim2(1, 2, 1, 2),
				position = newudim2(0.5, 0, 0.5, 0),
				zindex = menu.basezindex + 5,
				color = parameters.colors.c,
				visible = true,
				thickness = 1,
				filled = false,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.containeroutline

			this.containeroutline2 = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = this.containeroutline,
				anchorpoint = newvec2(0.5, 0.5),
				size = newudim2(1, 2, 1, 2),
				position = newudim2(0.5, 0, 0.5, 0),
				zindex = menu.basezindex + 4,
				color = parameters.colors.a,
				visible = true,
				thickness = 1,
				filled = false,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.containeroutline2

			this.title = DrawingFunction("text", {
				parent = this.container,
				anchorpoint = newvec2(0, 0.5),
				size = 13, -- x3
				font = Drawing.Fonts.Plex,
				position = newudim2(0, 18, 0, -2),
				zindex = menu.basezindex + 12,
				color = Color3.fromRGB(255, 255, 255),
				visible = true,
				text = name,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.title

			do
				local dragConn
				this.maincontainer.clicked:Connect(function()
					if menu.isadropdownopen  or menu.isacolorpickeropen or menu.uiopen == false then return end
					if utilities.mouse.position.y > (this.container.absoluteposition.y + this.container.absolutesize.y) and not param.ignoreResizing then
						dragConn = runservice.RenderStepped:Connect(function()
							this.title.color = menu.accent
							this.containeroutline.color = menu.accent
							local real = utilities.mouse.position.y - this.container.absoluteposition.y
							local nextPanel = nil
							for i, v in next, menu.subsections[tab][side] do
								if v.id == this.id + 1 then
									nextPanel = v
									break
								end
							end

							local emptySpace = targettab.absolutesize.y
							for i, v in next, menu.subsections[tab][side] do
								if v ~= this then
									emptySpace = emptySpace - v.maincontainer.absolutesize.y
								end
							end
							local canExtendUpTo = emptySpace / targettab.absolutesize.y

							this.maincontainer.size = newudim2(0.5, 0, math.clamp(real / (targettab.absolutesize.y), 0.1, canExtendUpTo), 0)

							local positions = {}
							for i, v in next, (menu.subsections[tab][side]) do
								positions[1 + #positions] = {
									yPos = v.maincontainer.absoluteposition.y,
									ref = v
								}
							end

							table.sort(positions, function(a, b) return a.yPos < b.yPos end)

							local yoffset = 0
							local real = 0
							for i, v in next, (positions) do
								real = real + 1
								v.ref.maincontainer.position = newudim2((side - 1) / 2, 0, yoffset / targettab.absolutesize.y, 0)
								v.ref.id = real
								yoffset = yoffset + v.ref.bounds.y
							end  
						end)
					elseif utilities.mouse.position.y < this.container.absoluteposition.y and not param.ignoreMoving then
						local clickedWhere = utilities.mouse.position - this.maincontainer.absoluteposition
						dragConn = runservice.RenderStepped:Connect(function()
							this.title.color = menu.accent
							this.containeroutline.color = menu.accent
							this.maincontainer.position = newudim2(this.maincontainer.position.X.Scale, utilities.mouse.position.x - clickedWhere.x - ((this.maincontainer.position.X.Scale * targettab.absolutesize.X) + targettab.absoluteposition.X), this.maincontainer.position.Y.Scale, utilities.mouse.position.y - clickedWhere.y - ((this.maincontainer.position.Y.Scale * targettab.absolutesize.y) + targettab.absoluteposition.y))

							local prevside = side
							if this.maincontainer.absoluteposition.x < targettab.absoluteposition.x then
								if menu.subsections[tab][side - 1] then
									menu.subsections[tab][side][name] = nil
									side = side - 1
								end
							elseif this.maincontainer.absoluteposition.x > targettab.absoluteposition.x + targettab.absolutesize.x then
								if menu.subsections[tab][side + 1] then
									menu.subsections[tab][side][name] = nil
									side = side + 1
								end
							end

							if side ~= prevside then
								menu.subsections[tab][side][name] = this
								do
									local totalBoundsOfShit = 0
									local things = 0
									for i, v in next, (menu.subsections[tab][prevside]) do
										v.maincontainer.size = v.panelResize.originalSize

										totalBoundsOfShit = totalBoundsOfShit + v.maincontainer.absolutesize.y
										things = things + 1
									end
									if totalBoundsOfShit > targettab.absolutesize.y then
										totalBoundsOfShit = 0
										for i, v in next, (menu.subsections[tab][prevside]) do
											local shitInPanel = 8
											for i2, v2 in next, (menu.elements[tab][i]) do
												if type(v2) == "table" then
													shitInPanel = shitInPanel + v2.bounds.y
												end
											end

											-- nigeh u dont need THAT much space xD
											if v.container.absolutesize.y > shitInPanel then
												v.maincontainer.size = newudim2(v.maincontainer.size.X.Scale, v.maincontainer.size.X.Offset, (shitInPanel + 24) / targettab.absolutesize.y, 0)
											end
											totalBoundsOfShit = totalBoundsOfShit + v.maincontainer.absolutesize.y
										end
									end
									if totalBoundsOfShit > targettab.absolutesize.y then
										local howMuchBiggerIsThisBullshit = (totalBoundsOfShit - targettab.absolutesize.y) / targettab.absolutesize.y
										local eachSmallerBy = howMuchBiggerIsThisBullshit / things

										for i, v in next, (menu.subsections[tab][prevside]) do
											v.maincontainer.size = newudim2(v.maincontainer.size.X.Scale, v.maincontainer.size.X.Offset, v.maincontainer.size.Y.Scale - eachSmallerBy, v.maincontainer.size.Y.Offset)
										end
									end
								end
								do
									local totalBoundsOfShit = 0
									local things = 0
									for i, v in next, (menu.subsections[tab][side]) do
										v.maincontainer.size = v.panelResize.originalSize

										totalBoundsOfShit = totalBoundsOfShit + v.maincontainer.absolutesize.y
										things = things + 1
									end
									if totalBoundsOfShit > targettab.absolutesize.y then
										totalBoundsOfShit = 0
										for i, v in next, (menu.subsections[tab][side]) do
											local shitInPanel = 8
											for i2, v2 in next, (menu.elements[tab][i]) do
												if type(v2) == "table" then
													shitInPanel = shitInPanel + v2.bounds.y
												end
											end

											-- nigeh u dont need THAT much space xD
											if v.container.absolutesize.y > shitInPanel then
												v.maincontainer.size = newudim2(v.maincontainer.size.X.Scale, v.maincontainer.size.X.Offset, (shitInPanel + 24) / targettab.absolutesize.y, 0)
											end
											totalBoundsOfShit = totalBoundsOfShit + v.maincontainer.absolutesize.y
										end
									end
									if totalBoundsOfShit > targettab.absolutesize.y then
										local howMuchBiggerIsThisBullshit = (totalBoundsOfShit - targettab.absolutesize.y) / targettab.absolutesize.y
										local eachSmallerBy = howMuchBiggerIsThisBullshit / things

										for i, v in next, (menu.subsections[tab][side]) do
											v.maincontainer.size = newudim2(v.maincontainer.size.X.Scale, v.maincontainer.size.X.Offset, v.maincontainer.size.Y.Scale - eachSmallerBy, v.maincontainer.size.Y.Offset)
										end
									end
								end
							end

							do  
								local positions = {}
								for i, v in next, (menu.subsections[tab][side]) do
									positions[1 + #positions] = {
										yPos = v.maincontainer.absoluteposition.y,
										ref = v
									}
								end

								table.sort(positions, function(a, b) return a.yPos < b.yPos end)

								local yoffset = 0
								local real = 0
								for i, v in next, (positions) do
									real = real + 1
									if v.ref ~= this then
										v.ref.maincontainer.position = newudim2((side - 1) / 2, 0, yoffset / targettab.absolutesize.y, 0)
									end
									v.ref.id = real
									yoffset = yoffset + v.ref.bounds.y
								end  
								if side ~= prevside then
									local positions = {}
									for i, v in next, (menu.subsections[tab][prevside]) do
										positions[1 + #positions] = {
											yPos = v.maincontainer.absoluteposition.y,
											ref = v
										}
									end

									table.sort(positions, function(a, b) return a.yPos < b.yPos end)

									local yoffset = 0
									local real = 0
									for i, v in next, (positions) do
										real = real + 1
										v.ref.maincontainer.position = newudim2((prevside - 1) / 2, 0, yoffset / targettab.absolutesize.y, 0)
										v.ref.id = real
										yoffset = yoffset + v.ref.bounds.y
									end  
								end
							end                                
						end)
					end
				end)

				utilities.mouse.mousebutton1up:Connect(function()
					if dragConn then
						this.title.color = Color3.fromRGB(255, 255, 255)
						this.containeroutline.color = parameters.colors.c
						dragConn:Disconnect()

						local positions = {}
						for i, v in next, (menu.subsections[tab][side]) do
							positions[1 + #positions] = {
								yPos = v.maincontainer.absoluteposition.y,
								ref = v
							}
						end

						table.sort(positions, function(a, b) return a.yPos < b.yPos end)

						local yoffset = 0
						local real = 0
						for i, v in next, (positions) do
							real = real + 1
							v.ref.maincontainer.position = newudim2((side - 1) / 2, 0, yoffset / targettab.absolutesize.y, 0)
							v.ref.id = real
							yoffset = yoffset + v.ref.bounds.y
						end                                        
					end
				end)
			end


			this.block = DrawingFunction("frame", {
				parent = this.title,
				anchorpoint = newvec2(0.5, 0.5),
				size = newudim2(1, 8, 0, 2),
				position = newudim2(0.5, 0, 0.5, 0),
				zindex = menu.basezindex + 5,
				color = parameters.colors.e,
				visible = false,
				thickness = 0,
				filled = true,
				name = "okay",
			})

			menu.openclose[1 + #menu.openclose] = this.block
			this.bounds = this.maincontainer.absolutesize
			menu.directory[tab][name] = this.container
			menu.elements[tab][name] = {}
			if not param.ignoreScrolling then
				menu.elements[tab][name].updateScrollBarLength = function()
					local shitInPanel = 8
					for i, v in next, (menu.elements[tab][name]) do
						if type(v) == "table" then
							shitInPanel = shitInPanel + v.bounds.y
						end
					end
					if shitInPanel > this.container.absolutesize.y then
						shitInPanel = shitInPanel + 24
						this.scrollBar.maincontainer.visible = true
						this.scrollBar.scroller.visible = true
						this.scrollBar.scroller.size = newudim2(0, 2, (this.container.absolutesize.y / shitInPanel), 0)

						local scrollBar = this.scrollBar

						local currentY = scrollBar.scroller.position.Y.Offset
						currentY = (currentY < 1) and 1 or (currentY > scrollBar.maincontainer.absolutesize.y - scrollBar.scroller.absolutesize.y - 1) and scrollBar.maincontainer.absolutesize.y - scrollBar.scroller.absolutesize.y - 1 or currentY 

						scrollBar.scroller.position = newudim2(1, 0, 0, currentY)

						local scrolledBy = (currentY - 1) / (scrollBar.maincontainer.absolutesize.y - scrollBar.scroller.absolutesize.y - 1)
						local posAt = (-scrolledBy * ((shitInPanel - this.container.absolutesize.y) / this.container.absolutesize.y))
						if posAt == 1/0 or posAt == -1/0 or posAt ~= posAt then
							this.scrollBar.maincontainer.visible = false
							this.scrollBar.scroller.visible = false

							for i, v in next, (menu.elements[tab][name]) do
								if type(v) == "table" then
									local theFlag = v.myflag
									if theFlag then
										if theFlag.type == "toggle" or theFlag.type == "button" or theFlag.type == "textbox" then
											v.hitbox.visible = true

											v.hitbox.size = v.hitbox.size + newudim2(0, 0, 0, 1)
											v.hitbox.size = v.hitbox.size - newudim2(0, 0, 0, 1)
										elseif theFlag.type == "slider" or theFlag.type == "dropdown" then
											v.holder.visible = true

											v.holder.size = v.holder.size + newudim2(0, 0, 0, 1)
											v.holder.size = v.holder.size - newudim2(0, 0, 0, 1)
										end
									end
								end
							end
							return
						end
						for i, v in next, (menu.elements[tab][name]) do
							if type(v) == "table" then
								local theFlag = v.myflag
								if theFlag then
									if theFlag.type == "toggle" or theFlag.type == "button" or theFlag.type == "textbox" then
										v.hitbox.position = newudim2(v.hitbox.position.X.Scale, v.hitbox.position.X.Offset, -scrolledBy * ((shitInPanel - this.container.absolutesize.y) / this.container.absolutesize.y), v.hitbox.position.Y.Offset)
										if v.hitbox.absoluteposition.y + v.bounds.y > ((this.container.absolutesize.y + this.container.absoluteposition.y) - 8) or v.hitbox.absoluteposition.y < this.container.absoluteposition.y then
											v.hitbox.visible = false
										else
											v.hitbox.visible = true
										end
										v.hitbox.size = v.hitbox.size + newudim2(0, 1, 0, 1)
										v.hitbox.size = v.hitbox.size - newudim2(0, 1, 0, 1)
									elseif theFlag.type == "slider" or theFlag.type == "dropdown" then
										v.holder.position = newudim2(v.holder.position.X.Scale, v.holder.position.X.Offset, -scrolledBy * ((shitInPanel - this.container.absolutesize.y) / this.container.absolutesize.y), v.holder.position.Y.Offset)
										if v.holder.absoluteposition.y + v.bounds.y > ((this.container.absolutesize.y + this.container.absoluteposition.y) - 8) or v.holder.absoluteposition.y < this.container.absoluteposition.y then
											v.holder.visible = false
										else
											v.holder.visible = true
										end
										v.holder.size = v.holder.size + newudim2(0, 1, 0, 1)
										v.holder.size = v.holder.size - newudim2(0, 1, 0, 1)
									end
								end
							end
						end
					else
						this.scrollBar.maincontainer.visible = false
						this.scrollBar.scroller.visible = false

						for i, v in next, (menu.elements[tab][name]) do
							if type(v) == "table" then
								local theFlag = v.myflag
								if theFlag then
									if theFlag.type == "toggle" or theFlag.type == "button" or theFlag.type == "textbox" then
										v.hitbox.visible = true
										v.hitbox.position = newudim2(v.hitbox.position.X.Scale, v.hitbox.position.X.Offset, 0, v.hitbox.position.Y.Offset)

										v.hitbox.size = v.hitbox.size + newudim2(0, 0, 0, 1)
										v.hitbox.size = v.hitbox.size - newudim2(0, 0, 0, 1)

										v.hitbox.position = v.hitbox.position + newudim2(0, 0, 0, 1)
										v.hitbox.position = v.hitbox.position - newudim2(0, 0, 0, 1)
									elseif theFlag.type == "slider" or theFlag.type == "dropdown" then
										v.holder.visible = true
										v.holder.position = newudim2(v.holder.position.X.Scale, v.holder.position.X.Offset, 0, v.holder.position.Y.Offset)

										v.holder.size = v.holder.size + newudim2(0, 0, 0, 1)
										v.holder.size = v.holder.size - newudim2(0, 0, 0, 1)

										v.holder.position = v.holder.position + newudim2(0, 0, 0, 1)
										v.holder.position = v.holder.position - newudim2(0, 0, 0, 1)
									end
								end
							end
						end
					end
				end

				this.container.getpropertychangedsignal:Connect(function(prop, val) 
					if prop == "absolutesize" then
						menu.elements[tab][name].updateScrollBarLength()
						this.bounds = this.maincontainer.absolutesize
					end
				end)
			else
				menu.elements[tab][name].updateScrollBarLength = function()

				end
			end

			this.panelResize = {
				originalSize = this.maincontainer.size,
				resetSize = function()
					this.maincontainer.size = this.panelResize.originalSize
					this.maincontainer.size = this.maincontainer.size + newudim2(0, 1, 0, 1)
					this.maincontainer.size = this.maincontainer.size - newudim2(0, 1, 0, 1)

					local positions = {}
					for i, v in next, (menu.subsections[tab][side]) do
						positions[1 + #positions] = {
							yPos = v.maincontainer.absoluteposition.y,
							ref = v
						}
					end

					table.sort(positions, function(a, b) return a.yPos < b.yPos end)

					local yoffset = 0
					local real = 0
					for i, v in next, (positions) do
						real = real + 1
						v.ref.maincontainer.position = newudim2((side - 1) / 2, 0, yoffset / targettab.absolutesize.y, 0)
						v.ref.id = real
						yoffset = yoffset + v.ref.bounds.y
					end     
				end,
				getSize = function()
					return this.maincontainer.size
				end,
				setSize = function(new)
					this.maincontainer.size = new
				end,
			}

			this.panelReposition = {
				originalPosition = this.maincontainer.position,
				originalSide = param.side,
				resetPosition = function()
					this.maincontainer.position = this.panelReposition.originalPosition
					this.maincontainer.size = this.maincontainer.size + newudim2(0, 1, 0, 1)
					this.maincontainer.size = this.maincontainer.size - newudim2(0, 1, 0, 1)

					local positions = {}
					for i, v in next, (menu.subsections[tab][side]) do
						positions[1 + #positions] = {
							yPos = v.maincontainer.absoluteposition.y,
							ref = v
						}
					end

					table.sort(positions, function(a, b) return a.yPos < b.yPos end)

					local yoffset = 0
					local real = 0
					for i, v in next, (positions) do
						real = real + 1
						v.ref.maincontainer.position = newudim2((side - 1) / 2, 0, yoffset / targettab.absolutesize.y, 0)
						v.ref.id = real
						yoffset = yoffset + v.ref.bounds.y
					end
				end,
				getPosition = function()
					return this.maincontainer.position
				end,
				resetSide = function()
					menu.subsections[tab][side][name] = nil
					side = this.panelReposition.originalSide
					menu.subsections[tab][this.panelReposition.originalSide][name] = this
				end,
				getSide = function()
					return side
				end,
				setSide = function(new)
					menu.subsections[tab][side][name] = nil
					side = new
					menu.subsections[tab][new][name] = this
				end,
				setPosition = function(new)
					this.maincontainer.position = new

					local positions = {}
					for i, v in next, (menu.subsections[tab][side]) do
						positions[1 + #positions] = {
							yPos = v.maincontainer.absoluteposition.y,
							ref = v
						}
					end

					table.sort(positions, function(a, b) return a.yPos < b.yPos end)

					local yoffset = 0
					local real = 0
					for i, v in next, (positions) do
						real = real + 1
						v.ref.maincontainer.position = newudim2((side - 1) / 2, 0, yoffset / targettab.absolutesize.y, 0)
						v.ref.id = real
						yoffset = yoffset + v.ref.bounds.y
					end
				end,
			}

			menu.subtabs[tab][name] = {}
			menu.subsections[tab][side][name] = this
		end

		menu.tooltip = {}
		menu.tooltip.open = false

		menu.tooltip.backoutline = DrawingFunction("frame", { -- for getting the bounds of the thing
			parent = utilities.base,
			anchorpoint = newvec2(0, 0),
			size = newudim2(0, 128, 0, 48),
			position = newudim2(0, 100, 0, 100),
			zindex = menu.basezindex + 23,
			color = menucolors.a,
			visible = true,
			thickness = 0,
			filled = true,
			transparency = 0,
			name = "okay",
		})

		menu.tooltip.container = DrawingFunction("frame", { -- for getting the bounds of the thing
			parent = menu.tooltip.backoutline,
			anchorpoint = newvec2(0.5, 0.5),
			size = newudim2(1, -2, 1, -2),
			position = newudim2(0.5, 0, 0.5, 0),
			zindex = menu.basezindex + 24,
			color = menucolors.b,
			visible = true,
			thickness = 0,
			filled = true,
			transparency = 0,
			name = "okay",
		})

		menu.tooltip.title = DrawingFunction("text", {
			parent = menu.tooltip.container,
			anchorpoint = newvec2(0, 0),
			size = 13, -- x3
			font = Drawing.Fonts.Plex,
			position = newudim2(0, 4, 0, 2),
			zindex = menu.basezindex + 25,
			color = Color3.fromRGB(255, 255, 255),
			visible = true,
			outline = false,
			outlinecolor = Color3.fromRGB(12, 12, 12),
			text = "Example of a tooltip",
			transparency = 0,
			name = "okay",
		})

		menu.tooltip.currenttrans = 0
		menu.tooltip.hoveredfor = 0
		function menu:calltooltip(text, object, offset)
			if menu.tooltip.connection then
				menu.tooltip.connection:Disconnect()
				menu.tooltip.connection = nil
			end
			menu.tooltip.hoveredfor = 0
			menu.tooltip.currenttrans = 0
			menu.tooltip.backoutline.transparency = menu.tooltip.currenttrans
			menu.tooltip.container.transparency = menu.tooltip.currenttrans
			menu.tooltip.title.transparency = menu.tooltip.currenttrans

			menu.tooltip.backoutline.position = newudim2(0, object.absoluteposition.x + 4 + offset.x, 0, object.absoluteposition.y + object.absolutesize.y + offset.y)

			local splitText = {}
			local charInline = 0
			for i, v in next, text:split("") do
				charInline = charInline + 1
				if v == " " then
					splitText.lastSpaceIdx = i
				end
				if charInline >= math.floor((menu.objects.backborder.absolutesize.x * 0.5) / 6) then
					splitText.lastSpaceIdx = splitText.lastSpaceIdx or i
					splitText.lastSpaceIdx = i
					v = "\n"
					charInline = 0
				end
				table.insert(splitText, v)
			end
			text = table.concat(splitText)

			local split = text:split("\n")
			local textLineLength = {}
			local yLength = 0
			for i, v in next, split do
				local textBound = Drawing.new("Text")
				textBound.Visible = true
				textBound.Font = Drawing.Fonts.Plex
				textBound.Size = 13
				textBound.Text = v
				local textBounds = textBound.TextBounds
				textBound.Visible = false
				textBound:Remove()
				textBound = nil

				textLineLength[i] = textBounds.x
				yLength = yLength + textBounds.y
			end

			table.sort(textLineLength, function(a, b) return a > b end)
			local longestThing = textLineLength[1]

			menu.tooltip.backoutline.size = newudim2(0, longestThing + 8, 0, yLength + 8)
			menu.tooltip.title.text = text

			local createdPos = object.absoluteposition
			menu.tooltip.connection = runservice.Stepped:Connect(function(u, dt)
				if object.hovering then
					menu.tooltip.hoveredfor = menu.tooltip.hoveredfor + dt
					if menu.tooltip.hoveredfor > 1 then
						menu.tooltip.currenttrans = menu.tooltip.currenttrans + (dt * 4)
					end
				else
					menu.tooltip.currenttrans = menu.tooltip.currenttrans - (dt * 4)
				end

				menu.tooltip.currenttrans = clamp(menu.tooltip.currenttrans, 0, 1)
				menu.tooltip.backoutline.transparency = menu.tooltip.currenttrans
				menu.tooltip.container.transparency = menu.tooltip.currenttrans
				menu.tooltip.title.transparency = menu.tooltip.currenttrans

				if menu.uiopen == false or createdPos ~= object.absoluteposition then
					menu.tooltip.connection:Disconnect()
					menu.tooltip.connection = nil
					menu.tooltip.currenttrans = 0
					menu.tooltip.hoveredfor = 0
					menu.tooltip.backoutline.transparency = menu.tooltip.currenttrans
					menu.tooltip.container.transparency = menu.tooltip.currenttrans
					menu.tooltip.title.transparency = menu.tooltip.currenttrans
				end
			end)
		end        

		local baseoffset = 0
		local boundoffset = 0
		function menu:createtoggle(parameters)
			local tab = parameters.tab
			local subsection = parameters.subsection
			local targetsection = menu.directory[tab][subsection]
			local name = parameters.name
			local flag = parameters.flag
			local tooltip = parameters.tooltip
			local this = {}
			menu.flags[flag] = {}
			local myflag = menu.flags[flag]
			this.myflag = myflag -- mypenis
			myflag.__index = menu.flags[flag]
			myflag.type = "toggle"
			myflag.name = name
			myflag.value = parameters.value
			myflag.changed = utilities.signal.new()
			myflag.element = this

			local offset = baseoffset + 8

			for i, v in next, (menu.elements[tab][subsection]) do
				if type(v) == "table" then
					offset = offset + v.bounds.y
				end
			end

			this.hitbox = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = targetsection,
				anchorpoint = newvec2(0.5, 0),
				size = newudim2(1, 0, 0, 14),
				position = newudim2(0.5, 0, 0, offset),
				zindex = menu.basezindex + 6,
				color = Color3.fromRGB(0, 0, 0),
				visible = true,
				thickness = 0,
				filled = true,
				transparency = 0,
				name = "okay",
			})

			this.toggle = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = this.hitbox,
				anchorpoint = newvec2(0, 0.5),
				size = newudim2(0, 8, 0, 8),
				position = newudim2(0, 8, 0.5, 0),
				zindex = menu.basezindex + 7,
				color =  menu.startingParameters.colors.f,
				visible = true,
				thickness = 0,
				filled = true,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.toggle

			this.toggleoutline = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = this.toggle,
				anchorpoint = newvec2(0.5, 0.5),
				size = newudim2(1, 2, 1, 2),
				position = newudim2(0.5, 0, 0.5, 0),
				zindex = menu.basezindex + 6,
				color = Color3.fromRGB(12, 12, 12),
				visible = true,
				thickness = 1,
				filled = false,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.toggleoutline

			this.toggled = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = this.toggle,
				anchorpoint = newvec2(0, 0),
				size = newudim2(1, 0, 1, 0),
				position = newudim2(0, 0, 0, 0),
				zindex = menu.basezindex + 7,
				color = menu.accent,
				visible = false,
				thickness = 0,
				filled = true,
				name = "okay",
			})
			this.toggled.visible = myflag.value
			menu.openclose[1 + #menu.openclose] = this.toggled
			menu.accents[1 + #menu.accents] = this.toggled

			this.title = DrawingFunction("text", {
				parent = this.hitbox,
				anchorpoint = newvec2(0, 0.5),
				size = 13, -- x3
				font = Drawing.Fonts.Plex,
				position = newudim2(0, 24, 0.5, -1),
				zindex = menu.basezindex + 6,
				color = parameters.detected and Color3.fromRGB(255, 106, 79) or Color3.fromRGB(255, 255, 255),
				visible = true,
				outline = false,
				outlinecolor = Color3.fromRGB(12, 12, 12),
				text = name,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.title
			this.realhitbox = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = this.hitbox,
				anchorpoint = newvec2(0, 0.5),
				size = newudim2(0, 32 + this.title.absolutesize.x, 1, 0),
				position = newudim2(0, 0, 0.5, 0),
				zindex = menu.basezindex + 8,
				color = Color3.fromRGB(255, 255, 255),
				visible = true,
				thickness = 0,
				filled = true,
				transparency = 0,
				activated = true,
				name = "okay",
			})
			menu.activations[1 + #menu.activations] = this.realhitbox
			function myflag:setvalue(new) -- how 2 config in 5 seconds
				myflag.value = new
				this.toggled.visible = new
				myflag.changed:Fire()
			end

			this.realhitbox.clicked:Connect(function()
				if menu.uiopen == false or menu.isadropdownopen or menu.isacolorpickeropen then return end
				myflag:setvalue(not myflag.value)
			end)

			if tooltip then
				this.realhitbox.mouseenter:Connect(function()
					if menu.uiopen == false or menu.isadropdownopen or menu.isacolorpickeropen then return end
					menu:calltooltip(tooltip, this.realhitbox, newvec2(0, 0))
				end)
			end

			this.bounds = newvec2(0, 14 + boundoffset)
			this.accessories = {} -- color pickers and what not
			menu.elements[tab][subsection][name] = this -- keep a record of this fuck
			menu.elements[tab][subsection].updateScrollBarLength()
		end

		function menu:createcolorpicker(parameters)
			local targetobj = menu.elements[parameters.tab][parameters.subsection][parameters.object]
			if not targetobj.accessories then
				return
			end
			local name = parameters.name
			local flag = parameters.flag
			local this = {}
			menu.flags[flag] = {}
			local myflag = menu.flags[flag]
			this.myflag = myflag
			myflag.__index = menu.flags[flag]
			myflag.type = "color"
			myflag.name = name
			myflag.color = parameters.color
			myflag.animation = {
				none = true,
				rainbow = false,
				linear = false,
				oscillating = false, 
				sawtooth = false,
				strobe = false
			}
			myflag.animationKeyFrames = {
				linear = {
					["keyframe 1"] = {
						color = parameters.color,
						transparency = parameters.transparency
					},
					["keyframe 2"] = {
						color = parameters.color,
						transparency = parameters.transparency
					}
				},
				oscillating = {
					["keyframe 1"] = {
						color = parameters.color,
						transparency = parameters.transparency
					},
					["keyframe 2"] = {
						color = parameters.color,
						transparency = parameters.transparency
					}
				},
				sawtooth = {
					["keyframe 1"] = {
						color = parameters.color,
						transparency = parameters.transparency
					},
					["keyframe 2"] = {
						color = parameters.color,
						transparency = parameters.transparency
					}
				},
				strobe = {
					["keyframe 1"] = {
						color = parameters.color,
						transparency = parameters.transparency
					},
					["keyframe 2"] = {
						color = parameters.color,
						transparency = parameters.transparency
					}
				},
			} -- color and transparency
			myflag.animationSpeed = {
				rainbow = 100,
				linear = 100,
				oscillating = 100,
				sawtooth = 100,
				strobe = 100
			}
			myflag.transparency = parameters.transparency
			myflag.changed = utilities.signal.new()

			local offset = baseoffset + 12

			for i, v in next, (targetobj.accessories) do
				offset = offset + v.bounds.x -- get the bounds of the current accessories in the thing
			end

			this.outline = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = targetobj.hitbox,
				anchorpoint = newvec2(1, 0.5),
				size = newudim2(0, 24, 0, 12),
				position = newudim2(1, -offset, 0.5, 0),
				zindex = menu.basezindex + 8,
				color = Color3.fromRGB(12, 12, 12),
				visible = true,
				thickness = 0,
				activated = true,
				filled = true,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.outline

			this.color = {}
			for i = 1, 5 do
				this.color[i] = utilities:draw("frame", { -- for getting the bounds of the thing, also not using DrawingFunction because the gradient isnt part of the ui accents
					parent = this.outline,
					anchorpoint = newvec2(0.5, 0),
					size = newudim2(1, -2, 0, 2),
					position = newudim2(0.5, 0, 0, ((i - 1) * 2) + 1),
					zindex = menu.basezindex + 10,
					color = parameters.color:lerp(Color3.fromRGB(math.clamp(parameters.color.r * 255 - 33, 0, 255), math.clamp(parameters.color.g * 255 - 33, 0, 255), math.clamp(parameters.color.b * 255 - 33, 0, 255)), i / 5),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})
				menu.openclose[1 + #menu.openclose] = this.color[i]
			end

			function myflag:setcolor(new)
				myflag.color = new
				for i = 1, 5 do
					local segment = this.color[i]
					segment.color = new:lerp(Color3.fromRGB(math.clamp(new.r * 255 - 20, 0, 255), math.clamp(new.g * 255 - 20, 0, 255), math.clamp(new.b * 255 - 20, 0, 255)), (i - 1) / 5)
				end
				myflag.changed:Fire()
			end

			function myflag:settransparency(new)
				myflag.transparency = new
				myflag.changed:Fire()
			end

			function myflag:setAnimation(new)
				myflag.animation = new

				if this.animationLoop then
					this.animationLoop:Disconnect()
					this.animationLoop = nil
				end

				-- hard coded cuz FUCK you
				-- funny how evie legit did animations like this better than me x3
				if myflag.animation.rainbow then
					this.animationLoop = runservice.Stepped:Connect(function()
						local oldhue, oldsat, oldval = Color3.toHSV(myflag.color)
						myflag:setcolor(Color3.fromHSV((tick() * (myflag.animationSpeed.rainbow / 100) - math.floor(tick() * (myflag.animationSpeed.rainbow / 100))), oldsat, oldval))
					end)
				elseif myflag.animation.linear then
					this.animationLoop = runservice.Stepped:Connect(function()
						local percentage = (tick() * (myflag.animationSpeed.linear / 100) - math.floor(tick() * (myflag.animationSpeed.linear / 100))) 
						if percentage > 0.5 then
							percentage = percentage - 0.5
							percentage = percentage * 2
							myflag:setcolor(myflag.animationKeyFrames.linear["keyframe 2"].color:Lerp(myflag.animationKeyFrames.linear["keyframe 1"].color, percentage))
							if myflag.transparency then
								local a = myflag.animationKeyFrames.linear["keyframe 2"].transparency
								local b = myflag.animationKeyFrames.linear["keyframe 1"].transparency
								local c = percentage
								myflag:settransparency(a + (b - a)*c)
							end
						else
							percentage = percentage * 2
							myflag:setcolor(myflag.animationKeyFrames.linear["keyframe 1"].color:Lerp(myflag.animationKeyFrames.linear["keyframe 2"].color, percentage))
							if myflag.transparency then
								local a = myflag.animationKeyFrames.linear["keyframe 1"].transparency
								local b = myflag.animationKeyFrames.linear["keyframe 2"].transparency
								local c = percentage
								myflag:settransparency(a + (b - a)*c)
							end
						end
					end)
				elseif myflag.animation.oscillating then
					this.animationLoop = runservice.Stepped:Connect(function()
						local percentage = (tick() * (myflag.animationSpeed.oscillating / 100) - math.floor(tick() * (myflag.animationSpeed.oscillating / 100)))
						if percentage > 0.5 then
							percentage = percentage - 0.5
							myflag:setcolor(myflag.animationKeyFrames.oscillating["keyframe 2"].color:Lerp(myflag.animationKeyFrames.oscillating["keyframe 1"].color, math.sin(percentage * math.pi)))
							if myflag.transparency then
								local a = myflag.animationKeyFrames.oscillating["keyframe 2"].transparency
								local b = myflag.animationKeyFrames.oscillating["keyframe 1"].transparency
								local c = math.sin(percentage * math.pi)
								myflag:settransparency(a + (b - a)*c)
							end
						else
							myflag:setcolor(myflag.animationKeyFrames.oscillating["keyframe 1"].color:Lerp(myflag.animationKeyFrames.oscillating["keyframe 2"].color, math.sin(percentage * math.pi)))
							if myflag.transparency then
								local a = myflag.animationKeyFrames.oscillating["keyframe 1"].transparency
								local b = myflag.animationKeyFrames.oscillating["keyframe 2"].transparency
								local c = math.sin(percentage * math.pi)

								myflag:settransparency(a + (b - a)*c)
							end
						end
					end)
				elseif myflag.animation.strobe then
					this.animationLoop = runservice.Stepped:Connect(function()
						local percentage = (tick() * (myflag.animationSpeed.strobe / 100) - math.floor(tick() * (myflag.animationSpeed.strobe / 100)))
						if percentage > 0.5 then
							myflag:setcolor(myflag.animationKeyFrames.strobe["keyframe 2"].color)
							if myflag.transparency then
								myflag:settransparency(myflag.animationKeyFrames.strobe["keyframe 2"].transparency)
							end
						else
							myflag:setcolor(myflag.animationKeyFrames.strobe["keyframe 1"].color)
							if myflag.transparency then
								myflag:settransparency(myflag.animationKeyFrames.strobe["keyframe 1"].transparency)
							end
						end
					end)
				elseif myflag.animation.sawtooth then
					this.animationLoop = runservice.Stepped:Connect(function()
						local percentage = (tick() * (myflag.animationSpeed.sawtooth / 100) - math.floor(tick() * (myflag.animationSpeed.sawtooth / 100)))
						myflag:setcolor(myflag.animationKeyFrames.sawtooth["keyframe 1"].color:Lerp(myflag.animationKeyFrames.sawtooth["keyframe 2"].color, percentage))
						if myflag.transparency then
							local a = myflag.animationKeyFrames.sawtooth["keyframe 1"].transparency
							local b = myflag.animationKeyFrames.sawtooth["keyframe 2"].transparency
							local c = percentage
							myflag:settransparency(a + (b - a)*c)
						end
					end)
				end
			end

			function myflag:setAnimationKeyFrames(new)
				for t, kf in next, new do
					myflag.animationKeyFrames[t] = kf
				end
			end

			function myflag:setAnimationSpeed(new)
				for t, s in next, new do
					myflag.animationSpeed[t] = s
				end
			end

			myflag:setcolor(parameters.color)
			if myflag.transparency then
				myflag:settransparency(parameters.transparency)
			end

			this.outline.clicked:Connect(function()
				if menu.uiopen == false or menu.isadropdownopen or menu.isacolorpickeropen then return end
				menu:callcolorpicker(name, myflag, utilities.mouse.position, myflag.transparency)
			end)

			this.outline.clicked2:Connect(function()
				if menu.uiopen == false or menu.isadropdownopen or menu.isacolorpickeropen then return end
				menu:callcolorcopypaste(myflag, utilities.mouse.position)
			end)

			this.bounds = newvec2(28, 0)
			targetobj.accessories[name] = this
		end

		function menu:createkeybind(parameters)
			local targetobj = menu.elements[parameters.tab][parameters.subsection][parameters.object]
			if not targetobj.accessories then
				return
			end
			local name = parameters.name
			local flag = parameters.flag
			local this = {}
			this.dropdown = {}
			this.dropdownopened = false
			menu.flags[flag] = {}
			local myflag = menu.flags[flag]
			this.myflag = myflag
			myflag.__index = menu.flags[flag]
			myflag.type = "keybind"
			myflag.value = parameters.value
			myflag.tab = parameters.tab
			myflag.name = name
			myflag.section = parameters.subsection
			myflag.object = parameters.object
			myflag.parentflag = parameters.parentflag
			myflag.activation = "always"
			myflag.key = nil
			myflag.changed = utilities.signal.new()

			local offset = baseoffset + 16

			for i, v in next, (targetobj.accessories) do
				offset = offset + v.bounds.x -- get the bounds of the current accessories in the thing
			end

			this.outline = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = targetobj.hitbox,
				anchorpoint = newvec2(1, 0.5),
				size = newudim2(0, 40, 0, 16),
				position = newudim2(1, -offset, 0.5, 0),
				zindex = menu.basezindex + 7,
				color = menucolors.a,
				visible = true,
				thickness = 1,
				activated = true,
				filled = false,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.outline
			menu.activations[1 + #menu.activations] = this.outline
			this.updating = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = this.outline,
				anchorpoint = newvec2(0.5, 0.5),
				size = newudim2(1, 0, 1, 0),
				position = newudim2(0.5, 0, 0.5, 0),
				zindex = menu.basezindex + 8,
				color = menu.accent,
				visible = false,
				thickness = 0,
				filled = true,
				name = "okay",
			})
			menu.accents[1 + #menu.accents] = this.updating

			this.container = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = this.outline,
				anchorpoint = newvec2(0.5, 0.5),
				size = newudim2(1, -2, 1, -2),
				position = newudim2(0.5, 0, 0.5, 0),
				zindex = menu.basezindex + 9,
				color = menucolors.c,
				visible = true,
				thickness = 0,
				filled = true,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.container
			this.title = DrawingFunction("text", {
				parent = this.outline,
				anchorpoint = newvec2(0, 0),
				size = 13, -- x3
				font = Drawing.Fonts.Plex,
				position = newudim2(0.5, -((7)/2), 0.5, -7),
				zindex = menu.basezindex + 10,
				color = Color3.fromRGB(255, 255, 255),
				visible = true,
				outline = false,
				outlinecolor = Color3.fromRGB(12, 12, 12),
				text = "E",
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.title
			for i, v in next, ({"hold", "toggle", "hold off", "always"}) do
				this.dropdown[v] = {}
				this.dropdown[v].outline = DrawingFunction("frame", { -- for getting the bounds of the thing
					parent = this.outline,
					anchorpoint = newvec2(0, 0),
					size = newudim2(0, 64, 0, 22),
					position = newudim2(-1, 16, 1, ((i - 1) * 20) + 2),
					zindex = menu.basezindex + 11,
					color = menucolors.a,
					visible = false,
					thickness = 0,
					filled = true,
					activated = true,
					name = "okay",
				})
				menu.activations[1 + #menu.activations] = this.dropdown[v].outline
				this.dropdown[v].container = DrawingFunction("frame", { -- for getting the bounds of the thing
					parent = this.dropdown[v].outline,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, -2, 1, -2),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 12,
					color = menucolors.c,
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				this.dropdown[v].title = DrawingFunction("text", {
					parent = this.dropdown[v].outline,
					anchorpoint = newvec2(0, 0.5),
					size = 13, -- x3
					font = Drawing.Fonts.Plex,
					position = newudim2(0, 4, 0.5, 0),
					zindex = menu.basezindex + 13,
					color = Color3.fromRGB(255, 255, 255),
					visible = true,
					outline = false,
					outlinecolor = Color3.fromRGB(12, 12, 12),
					text = v,
					name = "okay",
				})

				this.dropdown[v].outline.clicked:Connect(function()
					myflag:setactivation(v)
					for i, v in next, (this.dropdown) do
						v.outline.visible = false
					end
					menu.isadropdownopen = false
				end)
			end

			this.singleupdate = function()
				if not myflag.key then 
					myflag.value = false
				end -- we dont even have a key.....
				if myflag.activation == "always" then
					myflag.value = true
				else
					myflag.value = false
				end
			end

			function myflag:setkey(new)
				if not new or new == "NONE" then -- no key !
					myflag.key = nil
					this.title.text = "NONE"
					this.title.position = newudim2(0.5, -((4*7)/2), 0.5, -7)
				else
					local key = tostring(new)
					myflag.key = key
					this.title.text = string.sub(string.upper(key:sub(14)), 1, 5)
				end
				this.singleupdate()
			end

			function myflag:setactivation(new)
				myflag.activation = new
				for i, v in next, (this.dropdown) do
					v.title.color = (myflag.activation == v.title.text) and menu.accent or Color3.fromRGB(255, 255, 255)
				end
				this.singleupdate()
			end
			myflag:setactivation("always")

			function myflag:setvalue(new)
				myflag.value = new
				this.singleupdate()
			end

			this.outline.clicked2:Connect(function()
				if menu.uiopen == false or menu.isadropdownopen or menu.isacolorpickeropen then return end
				this.dropdownopened = not this.dropdownopened
				menu.isadropdownopen = this.dropdownopened
				for i, v in next, (this.dropdown) do
					v.outline.visible = this.dropdownopened
					v.title.color = (myflag.activation == v.title.text) and menu.accent or Color3.fromRGB(255, 255, 255)
					v.outline.position = v.outline.position
				end
			end)

			local keyupdater
			this.outline.clicked:Connect(function()
				if menu.uiopen == false or menu.isadropdownopen or menu.isacolorpickeropen then return end
				this.updating.visible = true
				keyupdater = userinputservice.InputBegan:Connect(function(Input, gameProcessed)
					if userinputservice:GetFocusedTextBox() then return end
					if Input.UserInputType == Enum.UserInputType.Keyboard then
						if Input.KeyCode.Value == 27 or Input.KeyCode.Value == 8 then 
							myflag:setkey(nil)
						else
							myflag:setkey(Input.KeyCode)
						end
						this.updating.visible = false
						if keyupdater then
							keyupdater:Disconnect()
							keyupdater = nil
						end
					end
				end)
			end)
			myflag:setkey(parameters.value)

			userinputservice.InputBegan:Connect(function(Input, gameProcessed)
				if userinputservice:GetFocusedTextBox() then return end
				if not myflag.key then 
					myflag.value = false
				end -- we dont even have a key.....
				if myflag.activation == "always" then
					myflag.value = true
				end
				if myflag.activation == "always" or not myflag.key then
					return 
				end
				if Input.UserInputType == Enum.UserInputType.Keyboard then
					if tostring(Input.KeyCode) == myflag.key then
						if myflag.activation == "toggle" then
							myflag.value = not myflag.value
							myflag.changed:Fire()
						end
						if myflag.activation == "hold" then
							myflag.value = true
							myflag.changed:Fire()
						end
						if myflag.activation == "hold off" then
							myflag.value = false
							myflag.changed:Fire()
						end
					end
				end
			end)

			userinputservice.InputEnded:Connect(function(Input, gameProcessed)
				if userinputservice:GetFocusedTextBox() then return end
				if not myflag.key then 
					myflag.value = false
				end -- we dont even have a key.....
				if myflag.activation == "always" then
					myflag.value = true
				end
				if myflag.activation == "always" or not myflag.key then
					return 
				end
				if myflag.activation == "always" then
					myflag.value = true
				end
				if Input.UserInputType == Enum.UserInputType.Keyboard then
					if tostring(Input.KeyCode) == myflag.key then
						if myflag.activation == "hold" then
							myflag.value = false
							myflag.changed:Fire()
						end
						if myflag.activation == "hold off" then
							myflag.value = true
							myflag.changed:Fire()
						end
					end
				end
			end)


			this.bounds = newvec2(44, 0)
			targetobj.accessories[name] = this
		end

		function menu:createslider(parameters)
			local tab = parameters.tab
			local subsection = parameters.subsection
			local targetsection = menu.directory[tab][subsection]
			local name = parameters.name
			local flag = parameters.flag
			local minimum = parameters.minimum
			local tooltip = parameters.tooltip
			local maximum = parameters.maximum
			local suffix = parameters.suffix ~= nil and parameters.suffix or ""
			local customtext = parameters.custom ~= nil and parameters.custom or {}

			local this = {}
			local offset = baseoffset + 0
			menu.flags[flag] = {}
			local myflag = menu.flags[flag]
			this.myflag = myflag -- mypenis
			myflag.__index = menu.flags[flag]
			myflag.type = "slider"
			myflag.name = name
			myflag.value = parameters.value
			myflag.element = this
			myflag.changed = utilities.signal.new()

			for i, v in next, (menu.elements[tab][subsection]) do
				if type(v) == "table" then
					offset = offset + v.bounds.y
				end
			end

			this.holder = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = targetsection,
				anchorpoint = newvec2(0.5, 0),
				size = newudim2(1, 0, 0, 24),
				position = newudim2(0.5, 0, 0, offset),
				zindex = menu.basezindex + 6,
				color = Color3.fromRGB(255, 255, 255),
				visible = true,
				thickness = 0,
				filled = true,
				transparency = 0,
				name = "okay",
			})

			this.title = DrawingFunction("text", {
				parent = this.holder,
				anchorpoint = newvec2(0, 0),
				size = 13, -- x3
				font = Drawing.Fonts.Plex,
				position = newudim2(0, 16, 0, 8),
				zindex = menu.basezindex + 7,
				color = parameters.detected and Color3.fromRGB(255, 106, 79) or Color3.fromRGB(255, 255, 255),
				visible = true,
				outline = false,
				outlinecolor = Color3.fromRGB(12, 12, 12),
				text = name,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.title
			this.sliderback = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = this.holder,
				anchorpoint = newvec2(0, 0),
				size = newudim2(1, -32, 0, 6),
				position = newudim2(0, 16, 0, 24),
				zindex = menu.basezindex + 7,
				color = menucolors.b,
				visible = true,
				thickness = 0,
				filled = true,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.sliderback
			this.sliderbackoutline = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = this.sliderback,
				anchorpoint = newvec2(0.5, 0.5),
				size = newudim2(1, 2, 1, 2),
				position = newudim2(0.5, 0, 0.5, 0),
				zindex = menu.basezindex + 6,
				color = menucolors.d,
				visible = true,
				thickness = 1,
				filled = false,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.sliderbackoutline

			this.slider = {}
			for i = 1, 6 do
				this.slider[i] = DrawingFunction("frame", { -- for getting the bounds of the thing
					parent = this.sliderback,
					anchorpoint = newvec2(0, 0),
					size = newudim2(0, 6, 0, 1),
					position = newudim2(0, 0, 0, i),
					zindex = menu.basezindex + 9,
					color = menu.accent:lerp(Color3.fromRGB(math.clamp((menu.accent.r * 255) - 5, 0, 255), math.clamp((menu.accent.g * 255) - 5, 0, 255), math.clamp((menu.accent.b * 255) - 5, 0, 255)), (i - 1) / 5),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})
				menu.openclose[1 + #menu.openclose] = this.slider[i]
			end

			menu.accents[1 + #menu.accents] = this.slider

			this.hitbox = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = this.sliderback,
				anchorpoint = newvec2(0.5, 0.5),
				size = newudim2(1, 0, 1, 10),
				position = newudim2(0.5, 0, 0.5, 0),
				zindex = menu.basezindex + 7,
				color = Color3.fromRGB(255, 255, 255),
				visible = true,
				thickness = 0,
				transparency = 0,
				activated = true,
				filled = true,
				name = "okay",
			})
			menu.activations[1 + #menu.activations] = this.hitbox

			this.valuetitle = DrawingFunction("text", {
				parent = this.sliderback,
				anchorpoint = newvec2(0, 0),
				size = 13, -- x3
				font = Drawing.Fonts.Plex,
				position = newudim2(1, -((2 * 7)/2), 0, 0),
				zindex = menu.basezindex + 9,
				color = Color3.fromRGB(255, 255, 255),
				visible = true,
				outline = false,
				outlinecolor = Color3.fromRGB(12, 12, 12),
				text = "0°",
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.valuetitle

			this.addtext = DrawingFunction("text", {
				parent = this.sliderback,
				anchorpoint = newvec2(1, 0),
				size = 13, -- x3
				font = Drawing.Fonts.Plex,
				position = newudim2(1, 3, 0.5, -7),
				zindex = menu.basezindex + 9,
				color = Color3.fromRGB(255, 255, 255),
				visible = true,
				outline = false,
				outlinecolor = Color3.fromRGB(12, 12, 12),
				activated = true,
				text = "+",
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.addtext

			this.subtext = DrawingFunction("text", {
				parent = this.sliderback,
				anchorpoint = newvec2(0, 0),
				size = 13, -- x3
				font = Drawing.Fonts.Plex,
				position = newudim2(0, -10, 0.5, -7),
				zindex = menu.basezindex + 9,
				color = Color3.fromRGB(255, 255, 255),
				visible = true,
				outline = false,
				outlinecolor = Color3.fromRGB(12, 12, 12),
				text = "-",
				activated = true,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.subtext

			local textupdateconnection -- so u can click on the value text and manually enter a number
			function myflag:setvalue(new)
				if new == nil then
					new = 0
				end
				local newtext = tostring(new)
				if textupdateconnection then -- we r typing
					newtext = newtext .. "|"
				else
					new = clamp(new, minimum, maximum)
				end
				newtext = tostring(new)
				if customtext[newtext] then
					this.valuetitle.text = customtext[newtext]
				else
					this.valuetitle.text = newtext .. suffix
				end
				for i, v in next, this.slider do
					v.position = newudim2((((clamp(new, minimum, maximum) - minimum)) / (maximum - minimum)), 0, 0, i - 1) -- s3x
					local tostart = v.absoluteposition.x - this.sliderback.absoluteposition.x
					local scalederrr = -tostart / this.sliderback.absolutesize.x
					v.size = newudim2(scalederrr, 0, 0, 1)
				end
				this.valuetitle.position = this.slider[#this.slider].position + newudim2(0, -((#this.valuetitle.text * 7)/2), 0, 0)
				myflag.value = new
				myflag.changed:Fire()
			end

			function myflag:setMax(new)
				maximum = new
			end

			function myflag:setMin(new)
				minimum = new
			end

			local connection
			this.hitbox.clicked:Connect(function()
				if menu.uiopen == false or menu.isadropdownopen or menu.isacolorpickeropen then return end
				connection = runservice.Stepped:Connect(function()
					local relative = utilities.mouse.position.x
					local mousebound = utilities.mouse.position.x - this.hitbox.absoluteposition.x - 1
					mousebound = clamp(mousebound, 0, this.hitbox.absolutesize.x)
					local result = mousebound
					result = clamp(result, 0, this.hitbox.absolutesize.x)
					result = floor(0.5 + (((maximum - minimum) / this.hitbox.absolutesize.x) * mousebound) + minimum)
					myflag:setvalue(result)
					if this.hitbox.holding == false or menu.uiopen == false then
						connection:Disconnect()
						connection = nil
						return
					end
				end)
			end)

			this.addtext.mouseenter:Connect(function()
				this.addtext.color = menu.accent
			end)

			this.addtext.mouseleave:Connect(function()
				this.addtext.color = Color3.fromRGB(255, 255, 255)
			end)

			this.subtext.mouseenter:Connect(function()
				this.subtext.color = menu.accent
			end)

			this.subtext.mouseleave:Connect(function()
				this.subtext.color = Color3.fromRGB(255, 255, 255)
			end)

			this.addtext.clicked:Connect(function()
				myflag:setvalue(myflag.value + 1)
			end)

			this.subtext.clicked:Connect(function()
				myflag:setvalue(myflag.value - 1)
			end)

			myflag:setvalue(parameters.value)

			if tooltip then
				this.hitbox.mouseenter:Connect(function()
					menu:calltooltip(tooltip, this.hitbox, newvec2(-4, 2))
				end)
			end

			this.bounds = newvec2(0, 36 + boundoffset)
			menu.elements[tab][subsection][name] = this
			menu.elements[tab][subsection].updateScrollBarLength()
		end

		function menu:createdropdown(parameters)
			local tab = parameters.tab
			local subsection = parameters.subsection
			local targetsection = menu.directory[tab][subsection]
			local name = parameters.name
			local flag = parameters.flag
			local tooltip = parameters.tooltip
			local multichoice = parameters.multichoice

			local this = {}
			this.dropdownopened = false
			this.valuecontainer = {}
			local offset = baseoffset + 0
			menu.flags[flag] = {}
			local myflag = menu.flags[flag]
			this.myflag = myflag -- mypenis
			myflag.__index = menu.flags[flag]
			myflag.type = "dropdown"
			myflag.value = {}
			myflag.name = name
			myflag.changed = utilities.signal.new()

			for i, v in next, (menu.elements[tab][subsection]) do
				if type(v) == "table" then
					offset = offset + v.bounds.y
				end
			end

			for i, v in next, (parameters.values) do
				local name = v[1]
				local state = v[2]
				myflag.value[name] = state
			end

			this.holder = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = targetsection,
				anchorpoint = newvec2(0.5, 0),
				size = newudim2(1, 0, 0, 24),
				position = newudim2(0.5, 0, 0, offset),
				zindex = menu.basezindex + 6,
				color = Color3.fromRGB(255, 255, 255),
				visible = true,
				thickness = 0,
				filled = true,
				transparency = 0,
				name = "okay",
			})

			this.title = DrawingFunction("text", {
				parent = this.holder,
				anchorpoint = newvec2(0, 0),
				size = 13, -- x3
				font = Drawing.Fonts.Plex,
				position = newudim2(0, 16, 0, 8),
				zindex = menu.basezindex + 7,
				color = Color3.fromRGB(255, 255, 255),
				visible = true,
				outline = false,
				outlinecolor = Color3.fromRGB(12, 12, 12),
				text = name,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.title
			this.selection = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = this.holder,
				anchorpoint = newvec2(0.5, 0),
				size = newudim2(1, -30, 0, 16),
				position = newudim2(0.5, 0, 0, 24),
				zindex = menu.basezindex + 7,
				color = menucolors.c,
				visible = true,
				thickness = 0,
				filled = true,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.selection
			this.selectiontext = DrawingFunction("text", {
				parent = this.selection,
				anchorpoint = newvec2(0, 0),
				size = 13, -- x3
				font = Drawing.Fonts.Plex,
				position = newudim2(0, 2, 0.5, -7),
				zindex = menu.basezindex + 8,
				color = Color3.fromRGB(255, 255, 255),
				visible = true,
				outline = false,
				outlinecolor = Color3.fromRGB(12, 12, 12),
				text = "",
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.selectiontext
			this.icon = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = this.selection,
				anchorpoint = newvec2(0.5, 0.5),
				size = newudim2(1, 2, 1, 2),
				position = newudim2(0.5, 0, 0.5, 0),
				zindex = menu.basezindex + 7,
				color = menucolors.c,
				visible = true,
				thickness = 0,
				filled = true,
				transparency = 0,
				activated = true,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.icon
			menu.activations[1 + #menu.activations] = this.icon

			this.icontext = DrawingFunction("text", {
				parent = this.icon,
				anchorpoint = newvec2(0, 0),
				size = 13, -- x3
				font = Drawing.Fonts.Plex,
				position = newudim2(1, -10, 0.5, -7),
				zindex = menu.basezindex + 8,
				color = Color3.fromRGB(255, 255, 255),
				visible = true,
				outline = false,
				outlinecolor = Color3.fromRGB(12, 12, 12),
				text = "+",
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.icontext
			this.selectionoutline = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = this.selection,
				anchorpoint = newvec2(0.5, 0.5),
				size = newudim2(1, 2, 1, 2),
				position = newudim2(0.5, 0, 0.5, 0),
				zindex = menu.basezindex + 6,
				color = menucolors.d,
				visible = true,
				thickness = 1,
				filled = false,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.selectionoutline

			this.scrollerBar = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = this.selection,
				anchorpoint = newvec2(0, 0),
				size = newudim2(0, 3, 8 / #parameters.values, 0),
				position = newudim2(1, -3, 0, 20),
				zindex = menu.basezindex + 18,
				color = menu.accent,
				visible = false,
				filled = true,
				name = "okay",
			})
			menu.accents[1 + #menu.accents] = this.scrollerBar

			function myflag:setvalue(new)
				myflag.value = new
				local maximumchars = floor(this.selection.absolutesize.x / 6.5) - 4 - 2 -- suck
				local selected = ""
				local selections = 0
				for i, v in next, (myflag.value) do
					if v then
						if selections > 0 then
							selected = selected .. ", "
						end
						selected = selected .. i
						selections = selections + 1
					end
				end
				for i, v in next, this.valuecontainer do
					v.selectiontext.color = myflag.value[v.selectiontext.text] and menu.accent or Color3.new(1, 1, 1)
				end

				local needsdotdotdot = false
				if string.len(selected) > maximumchars then
					needsdotdotdot = true
				end
				selected = string.sub(selected, 0, maximumchars) .. (needsdotdotdot and "..." or "" )
				if selections == 0 then
					this.selectiontext.text = "none"
				else
					this.selectiontext.text = selected
				end 
				myflag.changed:Fire()
			end

			this.selection.getpropertychangedsignal:Connect(function(prop, val)
				if prop == "absolutesize" then
					myflag:setvalue(myflag.value)
				end
			end)
			
			local numCreated = 0
			for val, v in next, (parameters.values) do
				if numCreated >= 8 then
					break
				end
				local temporary = {}
				local val = v[1] -- so that its in order
				temporary.value = val
				temporary.selectionoutline = DrawingFunction("frame", { -- for getting the bounds of the thing
					parent = this.selection,
					anchorpoint = newvec2(0.5, 0),
					size = newudim2(1, 2, 0, 22),
					position = newudim2(0.5, 0, 0, ((1 + #this.valuecontainer) * 20) -2),
					zindex = menu.basezindex + 14,
					color = menucolors.d,
					visible = false,
					thickness = 0,
					filled = true,
					name = "okay",
				})
				temporary.selection = DrawingFunction("frame", { -- for getting the bounds of the thing
					parent = temporary.selectionoutline,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, -2, 1, -2),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 15,
					color = menucolors.c,
					visible = true,
					thickness = 0,
					filled = true,
					activated = true,
					name = "okay",
				})
				menu.activations[1 + #menu.activations] = temporary.selection
				temporary.selectiontext = DrawingFunction("text", {
					parent = temporary.selection,
					anchorpoint = newvec2(0, 0.5),
					size = 13, -- x3
					font = Drawing.Fonts.Plex,
					position = newudim2(0, 2, 0.5, 0),
					zindex = menu.basezindex + 16,
					color = Color3.fromRGB(255, 255, 255),
					visible = true,
					outline = false,
					outlinecolor = Color3.fromRGB(12, 12, 12),
					text = val,
					name = "okay",
				})
				temporary.selection.clicked:Connect(function()
					local thisVal = temporary.selectiontext.text
					if parameters.multichoice == false then
						for i, v in next, (myflag.value) do
							myflag.value[i] = (thisVal == i) -- suck my nutz
						end
					else
						if not myflag.value then
							myflag.value[thisVal] = false
						end
						myflag.value[thisVal] = not myflag.value[thisVal] -- suck my nutz
					end
					myflag:setvalue(myflag.value)
				end)
				this.valuecontainer[1 + #this.valuecontainer] = temporary
				numCreated = numCreated + 1
			end
			local currentScrollLevel = 0
			if #parameters.values > 8 then
				local scrollUpConnection
				local scrollDownConnection
				local function updateScroll()
					this.scrollerBar.size = newudim2(0, 3, 8 / #parameters.values, 0)
					local currentY = math.floor(currentScrollLevel / #parameters.values * 170)
					currentY = math.clamp(currentY, 1, (170) - this.scrollerBar.absolutesize.y - 1)
					this.scrollerBar.position = newudim2(1, -3, 0, currentY + 20)

					for i = 1, 8 do
						local pointStartVis = currentScrollLevel + i
						local ref = this.valuecontainer[i]
						local flagRef = parameters.values[pointStartVis]
						
						ref.selectiontext.text = flagRef[1]
						ref.selectiontext.color = myflag.value[flagRef[1]] and menu.accent or Color3.new(1, 1, 1)
					end
				end

				scrollUpConnection = utilities.mouse.scrollup:Connect(function(d)
					if (menu.isadropdownopen and this.dropdownopened == false) or menu.isacolorpickeropen or menu.uiopen == false then return end
					currentScrollLevel = math.clamp(currentScrollLevel - d, 0, #parameters.values - 8)
					updateScroll()
				end)
				scrollDownConnection = utilities.mouse.scrolldown:Connect(function(d)
					if (menu.isadropdownopen and this.dropdownopened == false) or menu.isacolorpickeropen or menu.uiopen == false then return end
					currentScrollLevel = math.clamp(currentScrollLevel - d, 0, #parameters.values - 8)
					updateScroll()
				end)
			end

			this.icon.clicked:Connect(function()
				if (menu.isadropdownopen and this.dropdownopened == false) or menu.isacolorpickeropen or menu.uiopen == false then return end
				this.dropdownopened = not this.dropdownopened
				this.icontext.text = (this.dropdownopened == true) and "-" or "+"
				menu.isadropdownopen = this.dropdownopened

				for i, v in next, (this.valuecontainer) do
					v.selectionoutline.visible = this.dropdownopened
					v.selectionoutline.position = v.selectionoutline.position
					v.selectionoutline.size = v.selectionoutline.size
				end
				for i = 1, 8 do
					local pointStartVis = currentScrollLevel + i
					local ref = this.valuecontainer[i]
					local flagRef = parameters.values[pointStartVis]
					
					if not (ref and ref.selectiontext) then continue end 

					ref.selectiontext.text = flagRef[1]
					ref.selectiontext.color = myflag.value[flagRef[1]] and menu.accent or Color3.new(1, 1, 1)
				end
				if #parameters.values > 8 then
					this.scrollerBar.visible = this.dropdownopened
				end
			end)

			if tooltip then
				this.icon.mouseenter:Connect(function()
					if menu.uiopen == false or menu.isadropdownopen or menu.isacolorpickeropen or menu.uiopen == false then return end
					menu:calltooltip(tooltip, this.icon, newvec2(-4, 2))
				end)
			end

			local vals = {}
			for i, v in next, (parameters.values) do
				local name = v[1]
				local state = v[2]
				vals[name] = state
			end

			myflag:setvalue(vals)

			this.bounds = newvec2(0, 38 + boundoffset)
			menu.elements[tab][subsection][name] = this
			menu.elements[tab][subsection].updateScrollBarLength()
		end

		function menu:createbutton(parameters)
			local tab = parameters.tab
			local subsection = parameters.subsection
			local targetsection = menu.directory[tab][subsection]
			local confirmation = parameters.confirmation ~= nil and parameters.confirmation or nil
			local name = parameters.name
			local flag = parameters.flag
			local this = {}
			menu.flags[flag] = {}
			local myflag = menu.flags[flag]
			this.myflag = myflag -- mypenis
			myflag.__index = menu.flags[flag]
			myflag.type = "button"
			myflag.name = name
			myflag.pressed = utilities.signal.new()

			local offset = baseoffset + 10

			for i, v in next, (menu.elements[tab][subsection]) do
				if type(v) == "table" then
					offset = offset + v.bounds.y
				end
			end

			this.hitbox = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = targetsection,
				anchorpoint = newvec2(0.5, 0),
				size = newudim2(1, -28, 0, 20),
				position = newudim2(0.5, 0, 0, offset),
				zindex = menu.basezindex + 7,
				color = menucolors.d,
				visible = true,
				thickness = 1,
				filled = false,
				activated = true,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.hitbox
			menu.activations[1 + #menu.activations] = this.hitbox
			this.container = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = this.hitbox,
				anchorpoint = newvec2(0.5, 0.5),
				size = newudim2(1, -2, 1, -2),
				position = newudim2(0.5, 0, 0.5, 0),
				zindex = menu.basezindex + 8,
				color = menucolors.c,
				visible = true,
				thickness = 0,
				filled = true,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.container

			this.title = DrawingFunction("text", {
				parent = this.container,
				anchorpoint = newvec2(0, 0),
				size = 13, -- x3
				font = Drawing.Fonts.Plex,
				position = newudim2(0.5, -((#name * 7)/2), 0.5, -7),
				zindex = menu.basezindex + 9,
				color = parameters.detected and Color3.fromRGB(255, 106, 79) or Color3.fromRGB(255, 255, 255),
				visible = true,
				outline = false,
				text = name,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.title

			local lastactivation
			local connection
			this.hitbox.clicked:Connect(function()
				if menu.uiopen == false or menu.isadropdownopen or menu.isacolorpickeropen then return end
				if confirmation then
					if this.title.text ~= "confirm?" then
						this.title.text = "confirm?"
						this.title.position = newudim2(0.5, -((#this.title.text * 7)/2), 0.5, -7)
						this.title.color = menu.accent
						lastactivation = tick()
						connection = runservice.Stepped:Connect(function()
							if tick() - lastactivation > 2 then
								this.title.text = name
								this.title.color = Color3.new(1, 1, 1)
								lastactivation = tick()
								connection:Disconnect()
								connection = nil
							end
						end)
					else
						myflag.pressed:Fire()
						this.title.text = name
						this.title.color = Color3.new(1, 1, 1)
						lastactivation = tick()
						connection:Disconnect()
						connection = nil
						lastactivation = tick()
					end
				else
					myflag.pressed:Fire()
				end
				this.container.color = menucolors.a
				task.wait(0.05)
				this.container.color = menucolors.c
			end)

			this.bounds = newvec2(0, 24 + boundoffset)
			menu.elements[tab][subsection][name] = this -- keep a record of this fuck
			menu.elements[tab][subsection].updateScrollBarLength()
		end

		function menu:createtextbox(parameters)
			local tab = parameters.tab
			local subsection = parameters.subsection
			local targetsection = menu.directory[tab][subsection]
			local name = parameters.text
			local flag = parameters.flag
			local this = {}
			menu.flags[flag] = {}
			local myflag = menu.flags[flag]
			this.myflag = myflag -- mypenis
			myflag.__index = menu.flags[flag]
			myflag.type = "textbox"
			myflag.value = name
			myflag.name = name
			myflag.changed = utilities.signal.new()

			local offset = baseoffset + 10

			for i, v in next, (menu.elements[tab][subsection]) do
				if type(v) == "table" then
					offset = offset + v.bounds.y
				end
			end
			this.hitbox = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = targetsection,
				anchorpoint = newvec2(0.5, 0),
				size = newudim2(1, -28, 0, 20),
				position = newudim2(0.5, 0, 0, offset),
				zindex = menu.basezindex + 7,
				color = menucolors.d,
				visible = true,
				thickness = 0,
				filled = true,
				activated = true,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.hitbox
			menu.activations[1 + #menu.activations] = this.hitbox
			this.container = DrawingFunction("frame", { -- for getting the bounds of the thing
				parent = this.hitbox,
				anchorpoint = newvec2(0.5, 0.5),
				size = newudim2(1, -2, 1, -2),
				position = newudim2(0.5, 0, 0.5, 0),
				zindex = menu.basezindex + 8,
				color = menucolors.b,
				visible = true,
				thickness = 0,
				filled = true,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.container
			this.title = DrawingFunction("text", {
				parent = this.container,
				anchorpoint = newvec2(0, 0),
				size = 13, -- x3
				font = Drawing.Fonts.Plex,
				position = newudim2(0, 4, 0.5, -7),
				zindex = menu.basezindex + 9,
				color = Color3.fromRGB(255, 255, 255),
				visible = true,
				outline = false,
				outlinecolor = menucolors.d,
				text = name,
				name = "okay",
			})
			menu.openclose[1 + #menu.openclose] = this.title
			local textupdateconnection

			function myflag:setvalue(new)
				myflag.value = new
				this.title.text = myflag.value
				if textupdateconnection then -- currently typing...
					this.title.color = menu.accent
					this.title.text = this.title.text .. "|"
				end
				myflag.changed:Fire()
			end

			this.hitbox.clicked:Connect(function()
				if menu.uiopen == false or menu.isadropdownopen or menu.isacolorpickeropen then return end

				if textupdateconnection then
					textupdateconnection:Disconnect()
					textupdateconnection = nil
					this.title.text = this.title.text:gsub("|", "")
					this.title.color = Color3.new(1, 1, 1)
				end

				this.title.color = menu.accent
				this.title.text = this.title.text .. "|"
				textupdateconnection = userinputservice.InputBegan:Connect(function(Input, gameProcessed)
					if Input.UserInputType == Enum.UserInputType.Keyboard then
						if Input.KeyCode.Value == 27 or Input.KeyCode.Value == 13 then -- escape or enter pressed -> close the thing
							textupdateconnection:Disconnect()
							textupdateconnection = nil
							this.title.text = this.title.text:gsub("|", "")
							this.title.color = Color3.new(1, 1, 1)
						elseif Input.KeyCode.Value == 8 then -- backspace -> subtract the text by 1
							if userinputservice:IsKeyDown(Enum.KeyCode.LeftControl) or userinputservice:IsKeyDown(Enum.KeyCode.RightControl) then
								myflag:setvalue("")
							else
								myflag:setvalue(myflag.value:sub(0, -2)) -- remove the last char
							end
						elseif Input.KeyCode.Value == 32 then -- spacebar
							myflag:setvalue(myflag.value .. " ") -- remove the last char
						elseif Input.KeyCode.Value == 118 and (userinputservice:IsKeyDown(Enum.KeyCode.LeftControl) or userinputservice:IsKeyDown(Enum.KeyCode.RightControl)) then -- the v key
							this.title.text = this.title.text:gsub("|", "")
							this.title.color = Color3.new(1, 1, 1)
							textupdateconnection:Disconnect()
							textupdateconnection = nil
							myflag:setvalue(utilities.getclipboard())
						else
							local key = tostring(Input.KeyCode):sub(14)
							if table.find(menu.validkeys, key) or menu.validnumberkeys[key] then
								if menu.validnumberkeys[key] then
									key = menu.validnumberkeys[key]
								end
								if userinputservice:IsKeyDown(Enum.KeyCode.LeftShift) or userinputservice:IsKeyDown(Enum.KeyCode.RightShift) then
									key = string.upper(key)
								else
									key = string.lower(key)
								end
								myflag:setvalue(myflag.value .. key)
							end
						end
					end
				end)
			end)

			this.bounds = newvec2(0, 24 + boundoffset)
			menu.elements[tab][subsection][name] = this -- keep a record of this fuck
			menu.elements[tab][subsection].updateScrollBarLength()
		end

		local baseOffsetX = 16
		local baseOffsetY = 16

		menu.currentnotifications = {}
		menu.notificationmanagement = runservice.RenderStepped:Connect(function(dt)
			local sorted = {}
			local prioritiesgroups = {}

			-- sort the fucker

			table.sort(menu.currentnotifications, function(a, b) return a.priority > b.priority end)

			for i, v in next, menu.currentnotifications do
				if v.ignoreanimations then
				else
					if not prioritiesgroups[v.priority] then
						prioritiesgroups[v.priority] = {}
					end
					local thisGroup = prioritiesgroups[v.priority]
					thisGroup[1 + #thisGroup] = v
				end
			end

			for priority, notifs in next, prioritiesgroups do
				table.sort(notifs, function(a, b) return a.created < b.created end)
			end

			for priority, notifs in next, prioritiesgroups do
				for lifepriority, notif in next, notifs do
					sorted[1 + #sorted] = notif
				end
			end

			-- this positions it accordingly
			local currentLevel = 0
			for i = 1, #sorted do
				local notification = sorted[i]

				if notification.alivetime > notification.lifetime then -- manage removing the notif once its lifetime has expired
					notification.container.visible = false

					notification.container.Drawingobject:Remove()
					notification.outline1.Drawingobject:Remove()
					notification.outline2.Drawingobject:Remove()

					notification.container.Drawingobject = nil
					notification.outline1.Drawingobject = nil
					notification.outline2.Drawingobject = nil

					table.clear(notification.container)
					table.clear(notification.outline1)
					table.clear(notification.outline2)

					notification.container.Drawingobject = {}
					notification.outline1.Drawingobject = {}
					notification.outline2.Drawingobject = {}

					for k, n in next, menu.currentnotifications do
						if notification == n then
							table.clear(notification)
							table.remove(menu.currentnotifications, k)
						end
					end
				else
					notification.container.visible = true
					-- manage x position
					if notification.alivetime < 1 then -- manage x position coming out of the closet
						local percentageMoved = notification.alivetime / 1
						local projectedMovePercentage = (1 / (-2.71828 ^ (percentageMoved * 8))) + 1
						notification.container.position = newudim2(0, -240 + (projectedMovePercentage * 240) + baseOffsetX, 0, 0)
					elseif notification.alivetime > notification.lifetime - 0.5 then  -- manage x position going back into the closet
						local percentageMoved = 2 * (notification.alivetime - (notification.lifetime - 0.5))
						local projectedMovePercentage = (1 / (-2.71828 ^ (percentageMoved * 1))) + 1
						notification.container.position = newudim2(0, baseOffsetX - (projectedMovePercentage * 120), 0, 0)
					else
						notification.container.position = newudim2(0, baseOffsetX, 0, 0)
					end

					-- manage y position
					notification.container.position = notification.container.position + newudim2(0, 0, 0, baseOffsetY + currentLevel)
					currentLevel = currentLevel + 8 + notification.container.absolutesize.y

					-- manage fade
					if notification.alivetime < 1 then -- manage fade coming out of the closet
						local fade = notification.alivetime / 1

						notification.container.transparency = fade
						notification.outline1.transparency = fade
						notification.outline2.transparency = fade
						notification.title.transparency = fade

					elseif notification.alivetime > notification.lifetime - 0.5 then -- manage fade going back into the closet
						local fade = 1 - (2 * (notification.alivetime - (notification.lifetime - 0.5)))

						notification.container.transparency = fade
						notification.outline1.transparency = fade
						notification.outline2.transparency = fade
						notification.title.transparency = fade
					else
						notification.container.transparency = 1
						notification.outline1.transparency = 1
						notification.outline2.transparency = 1
						notification.title.transparency = 1
					end

					notification.alivetime = notification.alivetime + dt
				end
			end
		end)

		function menu:createnotification(param)
			local this = {}
			this.container = DrawingFunction("frame", {
				parent = utilities.base,
				anchorpoint = newvec2(0, 0),
				size = newudim2(0, 100, 0, 100),
				position = newudim2(32, 0, 32, 0),
				zindex = menu.basezindex + -4,
				color = parameters.colors.a,
				visible = false,
				thickness = 1,
				transparency = 1,
				filled = true,
				name = "okay",
			})
			this.outline1 = DrawingFunction("frame", {
				parent = this.container,
				anchorpoint = newvec2(0.5, 0.5),
				size = newudim2(1, 2, 1, 2),
				position = newudim2(0.5, 0, 0.5, 0),
				zindex = menu.basezindex + 5,
				color = parameters.colors.c,
				visible = true,
				thickness = 1,
				filled = false,
				name = "okay",
			})
			this.outline2 = DrawingFunction("frame", {
				parent = this.containeroutline,
				anchorpoint = newvec2(0.5, 0.5),
				size = newudim2(1, 2, 1, 2),
				position = newudim2(0.5, 0, 0.5, 0),
				zindex = menu.basezindex + 4,
				color = parameters.colors.a,
				visible = true,
				thickness = 1,
				filled = false,
				name = "okay",
			})
			this.title = DrawingFunction("text", {
				parent = this.container,
				anchorpoint = newvec2(0, 0),
				size = 13, -- x3
				font = Drawing.Fonts.Plex,
				position = newudim2(0, 8, 0, 4),
				zindex = menu.basezindex + 20,
				color = Color3.fromRGB(255, 255, 255),
				visible = true,
				outline = false,
				outlinecolor = Color3.fromRGB(12, 12, 12),
				text = "example notif",
				name = "okay",
			})

			-- text editing stuffs (copied from tooltip)
			local maxWidth = 36
			local text = param.text
			do -- WARNING !! ALAN CODE AHEAD!!
				local split = text:split("")
				local lastspaceidx = 0 -- the text idx that the last space is
				local charinline = 0
				for i, v in next, (split) do
					charinline = charinline + 1
					if v == " " then
						lastspaceidx = i
					end
					if charinline >= maxWidth then
						split[lastspaceidx] = "\n" -- insert a thing
						charinline = 0
					end
				end
				text = ""
				for i, v in next, (split) do
					text = text .. v
				end
			end
			local split = text:split("\n")
			local textlinelength = {}
			local yLeng = 0
			for i, v in next, (split) do
				local textBound = Vector2.new()
				do -- FATAL !
					local getTextBoundsOfBullshit = Drawing.new("Text")
					getTextBoundsOfBullshit.Visible = true
					getTextBoundsOfBullshit.Font = Drawing.Fonts.Plex
					getTextBoundsOfBullshit.Size = 13
					getTextBoundsOfBullshit.Text = v
					textBound = getTextBoundsOfBullshit.TextBounds
					getTextBoundsOfBullshit.Visible = false
					getTextBoundsOfBullshit:Remove()
					getTextBoundsOfBullshit = nil
				end

				textlinelength[i] = textBound.x -- getting the number of characters each line and getting the biggest one to properly size the thing
				yLeng = yLeng + textBound.y
			end
			table.sort(textlinelength, function(a, b) return a > b end)
			local longestthing = textlinelength[1]

			this.container.size = newudim2(0, longestthing + 16, 0, yLeng + 8)
			this.title.text = text
			this.alivetime = 0
			this.lifetime = param.lifetime
			this.priority = param.priority
			this.ignoreanimations = param.ignoreanimations
			this.created = tick()

			menu.currentnotifications[1 + #menu.currentnotifications] = this

			return this
		end

		local colorPickerType = 2
		do
			do
				local copyPasteMenu = {}
				copyPasteMenu.outline = DrawingFunction("frame", {
					parent = utilities.base,
					anchorpoint = newvec2(0, 0),
					size = newudim2(0, 42, 0, 32),
					position = newudim2(0, 100, 0, 100),
					zindex = menu.basezindex + 18,
					color = Color3.fromRGB(0, 0, 0),
					visible = false,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				copyPasteMenu.container = DrawingFunction("frame", {
					parent = copyPasteMenu.outline,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, -2, 1, -2),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 18,
					color = Color3.fromRGB(46, 46, 46),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				copyPasteMenu.copyTitle = DrawingFunction("text", {
					parent = copyPasteMenu.container,
					anchorpoint = newvec2(0, 0),
					size = 13, -- x3
					font = Drawing.Fonts.Plex,
					position = newudim2(0, 2, 0, 0),
					zindex = menu.basezindex + 19,
					color = Color3.fromRGB(255, 255, 255),
					visible = true,
					outline = false,
					outlinecolor = Color3.fromRGB(12, 12, 12),
					text = "copy",
					name = "okay",
				})

				copyPasteMenu.pasteTitle = DrawingFunction("text", {
					parent = copyPasteMenu.container,
					anchorpoint = newvec2(0, 0),
					size = 13, -- x3
					font = Drawing.Fonts.Plex,
					position = newudim2(0, 2, 0, copyPasteMenu.copyTitle.absolutesize.y + 2),
					zindex = menu.basezindex + 19,
					color = Color3.fromRGB(255, 255, 255),
					visible = true,
					outline = false,
					outlinecolor = Color3.fromRGB(12, 12, 12),
					text = "paste",
					name = "okay",
				})

				copyPasteMenu.copyDetection = DrawingFunction("frame", {
					parent = copyPasteMenu.container,
					anchorpoint = newvec2(0, 0),
					size = newudim2(1, 0, 0.5, 0),
					position = newudim2(0, 0, 0, 0),
					zindex = menu.basezindex + 18,
					color = Color3.fromRGB(0, 0, 0),
					visible = true,
					thickness = 0,
					activated = true,
					transparency = 0,
					filled = true,
					name = "okay",
				})

				copyPasteMenu.pasteDetection = DrawingFunction("frame", {
					parent = copyPasteMenu.container,
					anchorpoint = newvec2(0, 0),
					size = newudim2(1, 0, 0.5, 0),
					position = newudim2(0, 0, 0.5, 0),
					zindex = menu.basezindex + 18,
					color = Color3.fromRGB(0, 0, 0),
					visible = true,
					thickness = 0,
					activated = true,
					transparency = 0,
					filled = true,
					name = "okay",
				})

				copyPasteMenu.copyDetection.clicked:Connect(function()
					if copyPasteMenu.focusedon then
						local v = copyPasteMenu.focusedon
						local val = {v.color.r, v.color.g, v.color.b, v.transparency}
						local keyFrameFix = {}
						for n, kfs in next, v.animationKeyFrames do
							keyFrameFix[n] = {}
							for idx, d in next, kfs do
								keyFrameFix[n][idx] =  {d.color.r, d.color.g, d.color.b, d.transparency}
							end
						end
						local animations = {
							animation = v.animation,
							animationKeyFrames = keyFrameFix,
							speeds = v.animationSpeed
						}
						local comp = {val, animations}
						local result = json.encode(comp)
						colorpickerClipBoard = result
					end
					copyPasteMenu.outline.visible = false
					if copyPasteMenu.outofboundscloseconnection then
						copyPasteMenu.outofboundscloseconnection:Disconnect()
						copyPasteMenu.outofboundscloseconnection = nil
					end
					menu.isacolorpickeropen = false
				end)
				copyPasteMenu.pasteDetection.clicked:Connect(function()
					local clipboard = colorpickerClipBoard
					if copyPasteMenu.focusedon and colorpickerClipBoard then
						local ff = copyPasteMenu.focusedon
						local value = json.decode(clipboard)
						ff:setcolor(Color3.new(value[1][1], value[1][2], value[1][3]))

						if value[1][4] then
							ff:settransparency(value[1][4])
						end
						local keyFrameFix = {}
						for n, kfs in next, value[2].animationKeyFrames do
							keyFrameFix[n] = {}
							for idx, d in next, kfs do
								keyFrameFix[n][idx] = {
									color = Color3.new(d[1], d[2], d[3]),
									transparency = d[4],
								}
							end
						end
						ff:setAnimation(value[2].animation)
						ff:setAnimationSpeed(value[2].speeds)
						ff:setAnimationKeyFrames(keyFrameFix)
					end
					copyPasteMenu.outline.visible = false
					if copyPasteMenu.outofboundscloseconnection then
						copyPasteMenu.outofboundscloseconnection:Disconnect()
						copyPasteMenu.outofboundscloseconnection = nil
					end
					menu.isacolorpickeropen = false
				end)

				function menu:callcolorcopypaste(flag, position)
					if not flag then return end

					copyPasteMenu.outline.visible = true
					copyPasteMenu.outline.position = newudim2(0, position.x - 1, 0, position.y - 1)
					copyPasteMenu.outline.position = newudim2(0, position.x, 0, position.y)

					copyPasteMenu.focusedon = flag

					menu.isacolorpickeropen = true

					copyPasteMenu.outofboundscloseconnection = utilities.mouse.mousebutton1down:Connect(function()
						if utilities.mousechecks.inbounds(copyPasteMenu.outline, utilities.mouse.position) == false then -- uh oh..

							copyPasteMenu.outline.visible = false
							menu.isacolorpickeropen = false

							if copyPasteMenu.outofboundscloseconnection then
								copyPasteMenu.outofboundscloseconnection:Disconnect()
								copyPasteMenu.outofboundscloseconnection = nil
							end
						end
					end)
				end
			end
			if colorPickerType == 1 then
				menu.colorpicker = {} -- would rather make 1 that moves around instead of do this for EVERY color picker, probably shouldve done this with dropdowns and what not but i got lazy

				menu.colorpicker.outline = DrawingFunction("frame", {
					parent = utilities.base,
					anchorpoint = newvec2(0, 0),
					size = newudim2(0, 194, 0, 208),
					position = newudim2(0, 100, 0, 100),
					zindex = menu.basezindex + 18,
					color = Color3.fromRGB(0, 0, 0),
					visible = false,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.container = DrawingFunction("frame", {
					parent = menu.colorpicker.outline,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, -2, 1, -2),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 18,
					color = Color3.fromRGB(46, 46, 46),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.title = DrawingFunction("text", {
					parent = menu.colorpicker.container,
					anchorpoint = newvec2(0, 0),
					size = 13, -- x3
					font = Drawing.Fonts.Plex,
					position = newudim2(0, 4, 0, 2),
					zindex = menu.basezindex + 19,
					color = Color3.fromRGB(255, 255, 255),
					visible = true,
					outline = false,
					outlinecolor = Color3.fromRGB(12, 12, 12),
					text = "Color Picker",
					name = "okay",
				})

				menu.colorpicker.pickeroutline = DrawingFunction("frame", {
					parent = menu.colorpicker.outline,
					anchorpoint = newvec2(0, 0),
					size = newudim2(0, 172, 0, 172),
					position = newudim2(0, 4, 0, 18),
					zindex = menu.basezindex + 18,
					color = Color3.fromRGB(0, 0, 0),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.pickercontainer = DrawingFunction("frame", {
					parent = menu.colorpicker.pickeroutline,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, -2, 1, -2),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 19,
					color = Color3.new(1, 0, 0),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.picker = DrawingFunction("frame", {
					parent = menu.colorpicker.pickercontainer,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, 0, 1, 0),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 20,
					transparency = 0,
					color = Color3.new(1, 1, 1),
					visible = true,
					activated = true,
					name = "okay",
				})
				menu.activations[1 + #menu.activations] = menu.colorpicker.picker

				do
					local parentedTo = menu.colorpicker.picker
					local smoothGradient = {}
					local xRes = 6
					local yRes = 6
					for xDim = 1, parentedTo.absolutesize.x / xRes do
						smoothGradient[xDim] = {}
						for yDim = 1, parentedTo.absolutesize.y / yRes do
							smoothGradient[xDim][yDim] = utilities:draw("frame", {
								parent = parentedTo,
								anchorpoint = newvec2(0, 0),
								size = newudim2(0, xRes, 0, yRes),
								position = newudim2(0, (xDim - 1) * xRes, 0, (yDim - 1) * yRes),
								zindex = parentedTo.zindex + 1,
								color = Color3.fromHSV(0, 0, 1 - ((yDim - 1) * yRes) / parentedTo.absolutesize.y),
								transparency = 1 - ((xDim - 1) * xRes) / parentedTo.absolutesize.x,
								visible = true,
								name = "okay",
							})
						end
					end
				end

				menu.colorpicker.pickerselection = DrawingFunction("frame", {
					parent = utilities.base,
					anchorpoint = newvec2(0, 0),
					size = newudim2(0, 1, 0, 1),
					position = newudim2(0, 0, 0, 0),
					zindex = menu.basezindex + 22,
					color = Color3.new(1, 1, 1),
					visible = false,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.pickerselectionoutline = DrawingFunction("frame", {
					parent = menu.colorpicker.pickerselection,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, 2, 1, 2),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 21,
					color = Color3.fromRGB(0, 0, 0),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.hueoutline = DrawingFunction("frame", {
					parent = menu.colorpicker.outline,
					anchorpoint = newvec2(0, 0),
					size = newudim2(0, 12, 0, 172),
					position = newudim2(0, 178, 0, 18),
					zindex = menu.basezindex + 18,
					color = Color3.fromRGB(0, 0, 0),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.huecontainer = DrawingFunction("frame", {
					parent = menu.colorpicker.hueoutline,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, -2, 1, -2),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 19,
					color = Color3.fromRGB(0, 0, 0),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.hue = DrawingFunction("frame", {
					parent = menu.colorpicker.huecontainer,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, 0, 1, 0),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 20,
					transparency = 0,
					visible = true,
					activated = true,
					name = "okay",
				})
				menu.activations[1 + #menu.activations] = menu.colorpicker.hue

				do
					local parentedTo = colorReference.hue
					local smoothGradient = {}
					local yRes = 6
					for yDim = 1, parentedTo.absolutesize.y / yRes do
						smoothGradient[yDim] = utilities:draw("frame", {
							parent = parentedTo,
							anchorpoint = newvec2(0, 0),
							size = newudim2(1, 0, 0, yRes),
							position = newudim2(0, 0, 0, (yDim - 1) * yRes),
							zindex = parentedTo.zindex + 1,
							color = Color3.fromHSV(1 - ((yDim - 1) * yRes) / parentedTo.absolutesize.y, 1, 1),
							visible = true,
							name = "okay",
						})
					end
				end

				menu.colorpicker.hueselection = DrawingFunction("frame", {
					parent = utilities.base,
					anchorpoint = newvec2(0, 0),
					size = newudim2(0, 14, 0, 2),
					position = newudim2(0, 0, 0, 0),
					zindex = menu.basezindex + 22,
					color = Color3.new(1, 1, 1),
					visible = false,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.hueselectionoutline = DrawingFunction("frame", {
					parent = menu.colorpicker.hueselection,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, 2, 1, 2),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 21,
					color = Color3.fromRGB(0, 0, 0),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.transparencyoutline = DrawingFunction("frame", {
					parent = menu.colorpicker.outline,
					anchorpoint = newvec2(0, 0),
					size = newudim2(0, 172, 0, 12),
					position = newudim2(0, 4, 0, 192),
					zindex = menu.basezindex + 18,
					color = Color3.fromRGB(0, 0, 0),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.transparencycontainer = DrawingFunction("frame", {
					parent = menu.colorpicker.transparencyoutline,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, 0, 1, 0),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 19,
					color = Color3.new(1, 1, 1),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.transparencypicker = DrawingFunction("frame", {
					parent = menu.colorpicker.transparencycontainer,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, 0, 1, 0),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 20,
					transparency = 0,
					visible = true,
					activated = true,
					name = "okay",
				})
				menu.activations[1 + #menu.activations] = menu.colorpicker.transparencypicker

				do
					local parentedTo = menu.colorpicker.transparencypicker
					local smoothGradient = {}
					local xRes = 6
					for xDim = 1, parentedTo.absolutesize.x / xRes do
						smoothGradient[xDim] = utilities:draw("frame", {
							parent = parentedTo,
							anchorpoint = newvec2(0, 0),
							size = newudim2(0, xRes, 1, 0),
							position = newudim2(0, (xDim - 1) * xRes, 0, 0),
							zindex = parentedTo.zindex + 1,
							color = Color3.fromHSV(0, 0, ((xDim - 1) * xRes) / parentedTo.absolutesize.x),
							visible = true,
							name = "okay",
						})                      
					end
				end

				menu.colorpicker.transparencyselection = DrawingFunction("frame", {
					parent = utilities.base,
					anchorpoint = newvec2(0, 0),
					size = newudim2(0, 2, 0, 14),
					position = newudim2(0, 0, 0, 0),
					zindex = menu.basezindex + 22,
					color = Color3.new(1, 1, 1),
					visible = false,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.transparencyselectionoutline = DrawingFunction("frame", {
					parent = menu.colorpicker.transparencyselection,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, 2, 1, 2),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 21,
					color = Color3.fromRGB(0, 0, 0),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.outline.visible = false

				menu.colorpicker.focusedon = nil

				-- how 2 pick color
				menu.colorpicker.picker.clicked:Connect(function()
					local oldhue = abs(1 - (clamp(menu.colorpicker.hueselection.absoluteposition.y, menu.colorpicker.hue.absoluteposition.y, menu.colorpicker.hue.absoluteposition.y + menu.colorpicker.hue.absolutesize.y) - menu.colorpicker.picker.absoluteposition.y) / menu.colorpicker.picker.absolutesize.y)

					local xpos = clamp(utilities.mouse.position.x, menu.colorpicker.picker.absoluteposition.x, menu.colorpicker.picker.absoluteposition.x + menu.colorpicker.picker.absolutesize.x)
					local ypos = clamp(utilities.mouse.position.y, menu.colorpicker.picker.absoluteposition.y, menu.colorpicker.picker.absoluteposition.y + menu.colorpicker.picker.absolutesize.y)
					menu.colorpicker.pickerselection.position = newudim2(0, xpos, 0, ypos)
					-- quick maths

					local sat = clamp((xpos - menu.colorpicker.picker.absoluteposition.x) / menu.colorpicker.picker.absolutesize.x, 0, 1)
					local val = clamp(abs(1 - (ypos - menu.colorpicker.picker.absoluteposition.y) / menu.colorpicker.picker.absolutesize.y), 0, 1)

					menu.colorpicker.focusedon:setcolor(Color3.fromHSV(oldhue, sat, val))

					menu.colorpicker.updater = utilities.mouse.moved:Connect(function()
						local xpos = clamp(utilities.mouse.position.x, menu.colorpicker.picker.absoluteposition.x, menu.colorpicker.picker.absoluteposition.x + menu.colorpicker.picker.absolutesize.x)
						local ypos = clamp(utilities.mouse.position.y, menu.colorpicker.picker.absoluteposition.y, menu.colorpicker.picker.absoluteposition.y + menu.colorpicker.picker.absolutesize.y)
						menu.colorpicker.pickerselection.position = newudim2(0, xpos, 0, ypos)
						-- quick maths

						local sat = clamp((xpos - menu.colorpicker.picker.absoluteposition.x) / menu.colorpicker.picker.absolutesize.x, 0, 1)
						local val = clamp(abs(1 - (ypos - menu.colorpicker.picker.absoluteposition.y) / menu.colorpicker.picker.absolutesize.y), 0, 1)

						menu.colorpicker.focusedon:setcolor(Color3.fromHSV(oldhue, sat, val))
					end)
				end)

				menu.colorpicker.hue.clicked:Connect(function()
					local old = menu.colorpicker.focusedon.color
					local oldhue, oldsat, oldval = Color3.toHSV(old)

					local xpos = clamp(utilities.mouse.position.x, menu.colorpicker.hue.absoluteposition.x, menu.colorpicker.hue.absoluteposition.x + menu.colorpicker.hue.absolutesize.x)
					local ypos = clamp(utilities.mouse.position.y, menu.colorpicker.hue.absoluteposition.y, menu.colorpicker.hue.absoluteposition.y + menu.colorpicker.hue.absolutesize.y)
					menu.colorpicker.hueselection.position = newudim2(0, menu.colorpicker.hue.absoluteposition.x - 2, 0, ypos)

					local hue = abs(1 - (ypos - menu.colorpicker.picker.absoluteposition.y) / menu.colorpicker.picker.absolutesize.y)

					menu.colorpicker.focusedon:setcolor(Color3.fromHSV(hue, oldsat, oldval))
					menu.colorpicker.pickercontainer.color = Color3.fromHSV(hue, 1, 1)

					menu.colorpicker.updater = utilities.mouse.moved:Connect(function()
						local xpos = clamp(utilities.mouse.position.x, menu.colorpicker.hue.absoluteposition.x, menu.colorpicker.hue.absoluteposition.x + menu.colorpicker.hue.absolutesize.x)
						local ypos = clamp(utilities.mouse.position.y, menu.colorpicker.hue.absoluteposition.y, menu.colorpicker.hue.absoluteposition.y + menu.colorpicker.hue.absolutesize.y)
						menu.colorpicker.hueselection.position = newudim2(0, menu.colorpicker.hue.absoluteposition.x - 2, 0, ypos)

						local hue = abs(1 - (ypos - menu.colorpicker.picker.absoluteposition.y) / menu.colorpicker.picker.absolutesize.y)

						menu.colorpicker.focusedon:setcolor(Color3.fromHSV(hue, oldsat, oldval))
						menu.colorpicker.pickercontainer.color = Color3.fromHSV(hue, 1, 1)
					end)
				end)

				menu.colorpicker.transparencypicker.clicked:Connect(function()
					local xpos = clamp(utilities.mouse.position.x, menu.colorpicker.transparencypicker.absoluteposition.x, menu.colorpicker.transparencypicker.absoluteposition.x + menu.colorpicker.transparencypicker.absolutesize.x)
					local ypos = clamp(utilities.mouse.position.y, menu.colorpicker.transparencypicker.absoluteposition.y, menu.colorpicker.transparencypicker.absoluteposition.y + menu.colorpicker.transparencypicker.absolutesize.y)
					menu.colorpicker.transparencyselection.position = newudim2(0, xpos, 0, menu.colorpicker.transparencypicker.absoluteposition.y - 1)

					local transparency = (xpos - menu.colorpicker.transparencypicker.absoluteposition.x) / menu.colorpicker.transparencypicker.absolutesize.x
					menu.colorpicker.focusedon:settransparency(transparency)

					menu.colorpicker.updater = utilities.mouse.moved:Connect(function()
						local xpos = clamp(utilities.mouse.position.x, menu.colorpicker.transparencypicker.absoluteposition.x, menu.colorpicker.transparencypicker.absoluteposition.x + menu.colorpicker.transparencypicker.absolutesize.x)
						local ypos = clamp(utilities.mouse.position.y, menu.colorpicker.transparencypicker.absoluteposition.y, menu.colorpicker.transparencypicker.absoluteposition.y + menu.colorpicker.transparencypicker.absolutesize.y)
						menu.colorpicker.transparencyselection.position = newudim2(0, xpos, 0, menu.colorpicker.transparencypicker.absoluteposition.y - 1)

						local transparency = (xpos - menu.colorpicker.transparencypicker.absoluteposition.x) / menu.colorpicker.transparencypicker.absolutesize.x
						menu.colorpicker.focusedon:settransparency(transparency)
					end)
				end)

				utilities.mouse.mousebutton1up:Connect(function()
					if menu.colorpicker.updater then 
						menu.colorpicker.updater:Disconnect()
					end
				end)

				function menu:callcolorpicker(name, flag, position, transparency)
					if not flag then return end
					local old = flag.color
					local oldhue, oldsat, oldval = Color3.toHSV(old)

					menu.colorpicker.outline.visible = true
					menu.isacolorpickeropen = true
					menu.colorpicker.outline.position = newudim2(0, position.x, 0, position.y)
					menu.colorpicker.title.text = name
					menu.colorpicker.pickercontainer.color = Color3.fromHSV(oldhue, 1, 1)

					if transparency then
						menu.colorpicker.outline.size = newudim2(0, 194, 0, 208)
					else
						menu.colorpicker.outline.size = newudim2(0, 194, 0, 196)
					end

					menu.colorpicker.hueselection.visible = true
					menu.colorpicker.pickerselection.visible = true

					menu.colorpicker.transparencyoutline.visible = transparency ~= nil and true or false
					menu.colorpicker.transparencyselection.visible = transparency ~= nil and true or false

					menu.colorpicker.hueselection.position = newudim2(0, -2, 0, abs(1 - oldhue) * menu.colorpicker.hue.absolutesize.y) + newudim2(0, menu.colorpicker.hue.absoluteposition.x, 0, menu.colorpicker.hue.absoluteposition.y)
					menu.colorpicker.pickerselection.position = newudim2(0, oldsat * menu.colorpicker.picker.absolutesize.x, 0, abs(oldval - 1) * menu.colorpicker.picker.absolutesize.y) + newudim2(0, menu.colorpicker.picker.absoluteposition.x, 0, menu.colorpicker.picker.absoluteposition.y)

					menu.colorpicker.transparencypicker.position = menu.colorpicker.transparencypicker.position
					menu.colorpicker.transparencycontainer.position = menu.colorpicker.transparencycontainer.position

					if transparency then
						menu.colorpicker.transparencyselection.position = newudim2(0, transparency * menu.colorpicker.transparencypicker.absolutesize.x, 0, -1) + newudim2(0, menu.colorpicker.transparencypicker.absoluteposition.x, 0, menu.colorpicker.transparencypicker.absoluteposition.y)
					end

					menu.colorpicker.focusedon = flag

					if transparency then
						menu.colorpicker.transparencyselection.position = newudim2(0, transparency * menu.colorpicker.transparencypicker.absolutesize.x, 0, -1) + newudim2(0, menu.colorpicker.transparencypicker.absoluteposition.x, 0, menu.colorpicker.transparencypicker.absoluteposition.y)
					end
					-- thing
					menu.colorpicker.outofboundscloseconnection = utilities.mouse.mousebutton1down:Connect(function()
						if utilities.mousechecks.inbounds(menu.colorpicker.outline, utilities.mouse.position) == false then -- uh oh..
							if menu.colorpicker.updater then
								menu.colorpicker.updater:Disconnect()
							end

							menu.colorpicker.outline.visible = false
							menu.colorpicker.transparencyselection.visible = false
							menu.colorpicker.hueselection.visible = false
							menu.colorpicker.pickerselection.visible = false
							menu.isacolorpickeropen = false

							if menu.colorpicker.outofboundscloseconnection then
								menu.colorpicker.outofboundscloseconnection:Disconnect()
								menu.colorpicker.outofboundscloseconnection = nil
							end
						end
					end)
				end
			else
				do
					local colorReference = {} -- would rather make 1 that moves around instead of do this for EVERY color picker, probably shouldve done this with dropdowns and what not but i got lazy

					colorReference.outline = DrawingFunction("frame", {
						parent = utilities.base,
						anchorpoint = newvec2(0, 0),
						size = newudim2(0, 194, 0, 208),
						position = newudim2(0, 100, 0, 100),
						zindex = menu.basezindex + 18 + 13,
						color = Color3.fromRGB(0, 0, 0),
						visible = false,
						thickness = 0,
						filled = true,
						name = "okay",
					})

					colorReference.container = DrawingFunction("frame", {
						parent = colorReference.outline,
						anchorpoint = newvec2(0.5, 0.5),
						size = newudim2(1, -2, 1, -2),
						position = newudim2(0.5, 0, 0.5, 0),
						zindex = menu.basezindex + 18 + 13,
						color = Color3.fromRGB(46, 46, 46),
						visible = true,
						thickness = 0,
						filled = true,
						name = "okay",
					})

					colorReference.title = DrawingFunction("text", {
						parent = colorReference.container,
						anchorpoint = newvec2(0, 0),
						size = 13, -- x3
						font = Drawing.Fonts.Plex,
						position = newudim2(0, 4, 0, 2),
						zindex = menu.basezindex + 19 + 13,
						color = Color3.fromRGB(255, 255, 255),
						visible = true,
						outline = false,
						outlinecolor = Color3.fromRGB(12, 12, 12),
						text = "Color Picker",
						name = "okay",
					})

					colorReference.pickeroutline = DrawingFunction("frame", {
						parent = colorReference.outline,
						anchorpoint = newvec2(0, 0),
						size = newudim2(0, 172, 0, 172),
						position = newudim2(0, 4, 0, 18),
						zindex = menu.basezindex + 18 + 13,
						color = Color3.fromRGB(0, 0, 0),
						visible = true,
						thickness = 0,
						filled = true,
						name = "okay",
					})

					colorReference.pickercontainer = DrawingFunction("frame", {
						parent = colorReference.pickeroutline,
						anchorpoint = newvec2(0.5, 0.5),
						size = newudim2(1, -2, 1, -2),
						position = newudim2(0.5, 0, 0.5, 0),
						zindex = menu.basezindex + 19 + 13,
						color = Color3.new(1, 0, 0),
						visible = true,
						thickness = 0,
						filled = true,
						name = "okay",
					})

					colorReference.picker = DrawingFunction("frame", {
						parent = colorReference.pickercontainer,
						anchorpoint = newvec2(0.5, 0.5),
						size = newudim2(1, 0, 1, 0),
						position = newudim2(0.5, 0, 0.5, 0),
						zindex = menu.basezindex + 20 + 13,
						transparency = 0,
						color = Color3.new(1, 1, 1),
						visible = true,
						activated = true,
						name = "okay",
					})
					menu.activations[1 + #menu.activations] = colorReference.picker

					do
						local parentedTo = colorReference.picker
						local smoothGradient = {}
						local xRes = 6
						local yRes = 6
						for xDim = 1, parentedTo.absolutesize.x / xRes do
							smoothGradient[xDim] = {}
							for yDim = 1, parentedTo.absolutesize.y / yRes do
								smoothGradient[xDim][yDim] = utilities:draw("frame", {
									parent = parentedTo,
									anchorpoint = newvec2(0, 0),
									size = newudim2(0, xRes, 0, yRes),
									position = newudim2(0, (xDim - 1) * xRes, 0, (yDim - 1) * yRes),
									zindex = parentedTo.zindex + 1,
									color = Color3.fromHSV(0, 0, 1 - ((yDim - 1) * yRes) / parentedTo.absolutesize.y),
									transparency = 1 - ((xDim - 1) * xRes) / parentedTo.absolutesize.x,
									visible = true,
									name = "okay",
								})
							end
						end
					end

					colorReference.pickerselection = DrawingFunction("frame", {
						parent = utilities.base,
						anchorpoint = newvec2(0, 0),
						size = newudim2(0, 1, 0, 1),
						position = newudim2(0, 0, 0, 0),
						zindex = menu.basezindex + 22 + 13,
						color = Color3.new(1, 1, 1),
						visible = false,
						thickness = 0,
						filled = true,
						name = "okay",
					})

					colorReference.pickerselectionoutline = DrawingFunction("frame", {
						parent = colorReference.pickerselection,
						anchorpoint = newvec2(0.5, 0.5),
						size = newudim2(1, 2, 1, 2),
						position = newudim2(0.5, 0, 0.5, 0),
						zindex = menu.basezindex + 21 + 13,
						color = Color3.fromRGB(0, 0, 0),
						visible = true,
						thickness = 0,
						filled = true,
						name = "okay",
					})

					colorReference.hueoutline = DrawingFunction("frame", {
						parent = colorReference.outline,
						anchorpoint = newvec2(0, 0),
						size = newudim2(0, 12, 0, 172),
						position = newudim2(0, 178, 0, 18),
						zindex = menu.basezindex + 18 + 13,
						color = Color3.fromRGB(0, 0, 0),
						visible = true,
						thickness = 0,
						filled = true,
						name = "okay",
					})

					colorReference.huecontainer = DrawingFunction("frame", {
						parent = colorReference.hueoutline,
						anchorpoint = newvec2(0.5, 0.5),
						size = newudim2(1, -2, 1, -2),
						position = newudim2(0.5, 0, 0.5, 0),
						zindex = menu.basezindex + 19 + 13,
						color = Color3.fromRGB(0, 0, 0),
						visible = true,
						thickness = 0,
						filled = true,
						name = "okay",
					})

					colorReference.hue = DrawingFunction("frame", {
						parent = colorReference.huecontainer,
						anchorpoint = newvec2(0.5, 0.5),
						size = newudim2(1, 0, 1, 0),
						position = newudim2(0.5, 0, 0.5, 0),
						zindex = menu.basezindex + 20 + 13,
						transparency = 0,
						visible = true,
						activated = true,
						name = "okay",
					})
					menu.activations[1 + #menu.activations] = colorReference.hue

					do
						local parentedTo = colorReference.hue
						local smoothGradient = {}
						local yRes = 6
						for yDim = 1, parentedTo.absolutesize.y / yRes do
							smoothGradient[yDim] = utilities:draw("frame", {
								parent = parentedTo,
								anchorpoint = newvec2(0, 0),
								size = newudim2(1, 0, 0, yRes),
								position = newudim2(0, 0, 0, (yDim - 1) * yRes),
								zindex = parentedTo.zindex + 1,
								color = Color3.fromHSV(1 - ((yDim - 1) * yRes) / parentedTo.absolutesize.y, 1, 1),
								visible = true,
								name = "okay",
							})
						end
					end

					colorReference.hueselection = DrawingFunction("frame", {
						parent = utilities.base,
						anchorpoint = newvec2(0, 0),
						size = newudim2(0, 14, 0, 2),
						position = newudim2(0, 0, 0, 0),
						zindex = menu.basezindex + 22 + 13,
						color = Color3.new(1, 1, 1),
						visible = false,
						thickness = 0,
						filled = true,
						name = "okay",
					})

					colorReference.hueselectionoutline = DrawingFunction("frame", {
						parent = colorReference.hueselection,
						anchorpoint = newvec2(0.5, 0.5),
						size = newudim2(1, 2, 1, 2),
						position = newudim2(0.5, 0, 0.5, 0),
						zindex = menu.basezindex + 21 + 13,
						color = Color3.fromRGB(0, 0, 0),
						visible = true,
						thickness = 0,
						filled = true,
						name = "okay",
					})

					colorReference.transparencyoutline = DrawingFunction("frame", {
						parent = colorReference.outline,
						anchorpoint = newvec2(0, 0),
						size = newudim2(0, 172, 0, 12),
						position = newudim2(0, 4, 0, 192),
						zindex = menu.basezindex + 18 + 13,
						color = Color3.fromRGB(0, 0, 0),
						visible = true,
						thickness = 0,
						filled = true,
						name = "okay",
					})

					colorReference.transparencycontainer = DrawingFunction("frame", {
						parent = colorReference.transparencyoutline,
						anchorpoint = newvec2(0.5, 0.5),
						size = newudim2(1, 0, 1, 0),
						position = newudim2(0.5, 0, 0.5, 0),
						zindex = menu.basezindex + 19 + 13,
						color = Color3.new(1, 1, 1),
						visible = true,
						thickness = 0,
						filled = true,
						name = "okay",
					})

					colorReference.transparencypicker = DrawingFunction("frame", {
						parent = colorReference.transparencycontainer,
						anchorpoint = newvec2(0.5, 0.5),
						size = newudim2(1, 0, 1, 0),
						position = newudim2(0.5, 0, 0.5, 0),
						zindex = menu.basezindex + 20 + 13,
						transparency = 0,
						visible = true,
						activated = true,
						name = "okay",
					})
					menu.activations[1 + #menu.activations] = colorReference.transparencypicker

					do
						local parentedTo = colorReference.transparencypicker
						local smoothGradient = {}
						local xRes = 6
						for xDim = 1, parentedTo.absolutesize.x / xRes do
							smoothGradient[xDim] = utilities:draw("frame", {
								parent = parentedTo,
								anchorpoint = newvec2(0, 0),
								size = newudim2(0, xRes, 1, 0),
								position = newudim2(0, (xDim - 1) * xRes, 0, 0),
								zindex = parentedTo.zindex + 1,
								color = Color3.fromHSV(0, 0, ((xDim - 1) * xRes) / parentedTo.absolutesize.x),
								visible = true,
								name = "okay",
							})                      
						end
					end

					colorReference.transparencyselection = DrawingFunction("frame", {
						parent = utilities.base,
						anchorpoint = newvec2(0, 0),
						size = newudim2(0, 2, 0, 14),
						position = newudim2(0, 0, 0, 0),
						zindex = menu.basezindex + 22 + 13,
						color = Color3.new(1, 1, 1),
						visible = false,
						thickness = 0,
						filled = true,
						name = "okay",
					})

					colorReference.transparencyselectionoutline = DrawingFunction("frame", {
						parent = colorReference.transparencyselection,
						anchorpoint = newvec2(0.5, 0.5),
						size = newudim2(1, 2, 1, 2),
						position = newudim2(0.5, 0, 0.5, 0),
						zindex = menu.basezindex + 21 + 13,
						color = Color3.fromRGB(0, 0, 0),
						visible = true,
						thickness = 0,
						filled = true,
						name = "okay",
					})

					colorReference.outline.visible = false

					colorReference.focusedon = nil

					-- how 2 pick color
					colorReference.picker.clicked:Connect(function()
						local oldhue = abs(1 - (clamp(colorReference.hueselection.absoluteposition.y, colorReference.hue.absoluteposition.y, colorReference.hue.absoluteposition.y + colorReference.hue.absolutesize.y) - colorReference.picker.absoluteposition.y) / colorReference.picker.absolutesize.y)

						local xpos = clamp(utilities.mouse.position.x, colorReference.picker.absoluteposition.x, colorReference.picker.absoluteposition.x + colorReference.picker.absolutesize.x)
						local ypos = clamp(utilities.mouse.position.y, colorReference.picker.absoluteposition.y, colorReference.picker.absoluteposition.y + colorReference.picker.absolutesize.y)
						colorReference.pickerselection.position = newudim2(0, xpos, 0, ypos)
						-- quick maths

						local sat = clamp((xpos - colorReference.picker.absoluteposition.x) / colorReference.picker.absolutesize.x, 0, 1)
						local val = clamp(abs(1 - (ypos - colorReference.picker.absoluteposition.y) / colorReference.picker.absolutesize.y), 0, 1)

						colorReference.focusedon:setcolor(Color3.fromHSV(oldhue, sat, val))                            

						colorReference.updater = utilities.mouse.moved:Connect(function()
							local xpos = clamp(utilities.mouse.position.x, colorReference.picker.absoluteposition.x, colorReference.picker.absoluteposition.x + colorReference.picker.absolutesize.x)
							local ypos = clamp(utilities.mouse.position.y, colorReference.picker.absoluteposition.y, colorReference.picker.absoluteposition.y + colorReference.picker.absolutesize.y)
							colorReference.pickerselection.position = newudim2(0, xpos, 0, ypos)
							-- quick maths

							local sat = clamp((xpos - colorReference.picker.absoluteposition.x) / colorReference.picker.absolutesize.x, 0, 1)
							local val = clamp(abs(1 - (ypos - colorReference.picker.absoluteposition.y) / colorReference.picker.absolutesize.y), 0, 1)

							colorReference.focusedon:setcolor(Color3.fromHSV(oldhue, sat, val))
						end)
					end)

					colorReference.hue.clicked:Connect(function()
						local old = colorReference.focusedon.color
						local oldhue, oldsat, oldval = Color3.toHSV(old)

						local xpos = clamp(utilities.mouse.position.x, colorReference.hue.absoluteposition.x, colorReference.hue.absoluteposition.x + colorReference.hue.absolutesize.x)
						local ypos = clamp(utilities.mouse.position.y, colorReference.hue.absoluteposition.y, colorReference.hue.absoluteposition.y + colorReference.hue.absolutesize.y)
						colorReference.hueselection.position = newudim2(0, colorReference.hue.absoluteposition.x - 2, 0, ypos)

						local hue = abs(1 - (ypos - colorReference.picker.absoluteposition.y) / colorReference.picker.absolutesize.y)

						colorReference.focusedon:setcolor(Color3.fromHSV(hue, oldsat, oldval))
						colorReference.pickercontainer.color = Color3.fromHSV(hue, 1, 1)

						colorReference.updater = utilities.mouse.moved:Connect(function()
							local xpos = clamp(utilities.mouse.position.x, colorReference.hue.absoluteposition.x, colorReference.hue.absoluteposition.x + colorReference.hue.absolutesize.x)
							local ypos = clamp(utilities.mouse.position.y, colorReference.hue.absoluteposition.y, colorReference.hue.absoluteposition.y + colorReference.hue.absolutesize.y)
							colorReference.hueselection.position = newudim2(0, colorReference.hue.absoluteposition.x - 2, 0, ypos)

							local hue = abs(1 - (ypos - colorReference.picker.absoluteposition.y) / colorReference.picker.absolutesize.y)

							colorReference.focusedon:setcolor(Color3.fromHSV(hue, oldsat, oldval))
							colorReference.pickercontainer.color = Color3.fromHSV(hue, 1, 1)
						end)
					end)

					colorReference.transparencypicker.clicked:Connect(function()
						local xpos = clamp(utilities.mouse.position.x, colorReference.transparencypicker.absoluteposition.x, colorReference.transparencypicker.absoluteposition.x + colorReference.transparencypicker.absolutesize.x)
						local ypos = clamp(utilities.mouse.position.y, colorReference.transparencypicker.absoluteposition.y, colorReference.transparencypicker.absoluteposition.y + colorReference.transparencypicker.absolutesize.y)
						colorReference.transparencyselection.position = newudim2(0, xpos, 0, colorReference.transparencypicker.absoluteposition.y - 1)

						local transparency = (xpos - colorReference.transparencypicker.absoluteposition.x) / colorReference.transparencypicker.absolutesize.x
						colorReference.focusedon:settransparency(transparency)                           
						colorReference.updater = utilities.mouse.moved:Connect(function()
							local xpos = clamp(utilities.mouse.position.x, colorReference.transparencypicker.absoluteposition.x, colorReference.transparencypicker.absoluteposition.x + colorReference.transparencypicker.absolutesize.x)
							local ypos = clamp(utilities.mouse.position.y, colorReference.transparencypicker.absoluteposition.y, colorReference.transparencypicker.absoluteposition.y + colorReference.transparencypicker.absolutesize.y)
							colorReference.transparencyselection.position = newudim2(0, xpos, 0, colorReference.transparencypicker.absoluteposition.y - 1)

							local transparency = (xpos - colorReference.transparencypicker.absoluteposition.x) / colorReference.transparencypicker.absolutesize.x
							colorReference.focusedon:settransparency(transparency)
						end)
					end)

					utilities.mouse.mousebutton1up:Connect(function()
						if colorReference.updater then 
							colorReference.updater:Disconnect()
						end
					end)

					function menu:oldcallcolorpicker(name, flag, position, transparency)
						if not flag then return end
						local old = flag.color
						local oldhue, oldsat, oldval = Color3.toHSV(old)

						colorReference.outline.visible = true
						colorReference.outline.position = newudim2(0, position.x, 0, position.y)
						colorReference.title.text = name
						colorReference.pickercontainer.color = Color3.fromHSV(oldhue, 1, 1)

						if transparency then
							colorReference.outline.size = newudim2(0, 194, 0, 208)
						else
							colorReference.outline.size = newudim2(0, 194, 0, 196)
						end

						colorReference.hueselection.visible = true
						colorReference.pickerselection.visible = true

						colorReference.transparencyoutline.visible = transparency ~= nil and true or false
						colorReference.transparencyselection.visible = transparency ~= nil and true or false

						colorReference.hueselection.position = newudim2(0, -2, 0, abs(1 - oldhue) * colorReference.hue.absolutesize.y) + newudim2(0, colorReference.hue.absoluteposition.x, 0, colorReference.hue.absoluteposition.y)
						colorReference.pickerselection.position = newudim2(0, oldsat * colorReference.picker.absolutesize.x, 0, abs(oldval - 1) * colorReference.picker.absolutesize.y) + newudim2(0, colorReference.picker.absoluteposition.x, 0, colorReference.picker.absoluteposition.y)

						colorReference.transparencypicker.position = colorReference.transparencypicker.position
						colorReference.transparencycontainer.position = colorReference.transparencycontainer.position

						if transparency then
							colorReference.transparencyselection.position = newudim2(0, transparency * colorReference.transparencypicker.absolutesize.x, 0, -1) + newudim2(0, colorReference.transparencypicker.absoluteposition.x, 0, colorReference.transparencypicker.absoluteposition.y)
						end

						colorReference.focusedon = flag

						if transparency then
							colorReference.transparencyselection.position = newudim2(0, transparency * colorReference.transparencypicker.absolutesize.x, 0, -1) + newudim2(0, colorReference.transparencypicker.absoluteposition.x, 0, colorReference.transparencypicker.absoluteposition.y)
						end
						-- thing
						colorReference.outofboundscloseconnection = utilities.mouse.mousebutton1down:Connect(function()
							if utilities.mousechecks.inbounds(colorReference.outline, utilities.mouse.position) == false then -- uh oh..
								if colorReference.updater then
									colorReference.updater:Disconnect()
								end

								colorReference.outline.visible = false
								colorReference.transparencyselection.visible = false
								colorReference.hueselection.visible = false
								colorReference.pickerselection.visible = false

								if colorReference.outofboundscloseconnection then
									colorReference.outofboundscloseconnection:Disconnect()
									colorReference.outofboundscloseconnection = nil
								end
							end
						end)
					end
					menu.oldcolorpicker = colorReference
				end


				menu.colorpicker = {} -- would rather make 1 that moves around instead of do this for EVERY color picker, probably shouldve done this with dropdowns and what not but i got lazy

				menu.colorpicker.proportions = {
					mainSize = {x = 240, y = 240},
					secondaryBarWidth = 14,
				}

				menu.colorpicker.outline = DrawingFunction("frame", {
					parent = utilities.base,
					anchorpoint = newvec2(0, 0),
					size = newudim2(0, menu.colorpicker.proportions.mainSize.x, 0, menu.colorpicker.proportions.mainSize.y),
					position = newudim2(0, 100, 0, 100),
					zindex = menu.basezindex + 18,
					color = Color3.fromRGB(0, 0, 0),
					visible = false,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.title = DrawingFunction("text", {
					parent = menu.colorpicker.outline,
					anchorpoint = newvec2(0, 0),
					size = 13, -- x3
					font = Drawing.Fonts.Plex,
					position = newudim2(0, 4, 0, 2),
					zindex = menu.basezindex + 21,
					color = Color3.fromRGB(255, 255, 255),
					visible = true,
					outline = false,
					outlinecolor = Color3.fromRGB(12, 12, 12),
					text = "Color Picker",
					name = "okay",
				})

				menu.colorpicker.titleBack = DrawingFunction("frame", {
					parent = menu.colorpicker.outline,
					anchorpoint = newvec2(0, 0),
					size = newudim2(1, 0, 0, 18),
					position = newudim2(0, 0, 0, 0),
					zindex = menu.basezindex + 19,
					color = Color3.fromRGB(0, 0, 0),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.titleFront = DrawingFunction("frame", {
					parent = menu.colorpicker.titleBack,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, -2, 1, -2),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 20,
					color = Color3.fromRGB(46, 46, 46),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.secondTabBack = DrawingFunction("frame", {
					parent = menu.colorpicker.outline,
					anchorpoint = newvec2(1, 0),
					size = newudim2(0, 68, 0, 18),
					position = newudim2(1, 0, 0, 0),
					zindex = menu.basezindex + 21,
					color = Color3.fromRGB(0, 0, 0),
					visible = true,
					thickness = 0,
					filled = true,
					activated = true,
					name = "okay",
				})

				menu.colorpicker.secondTabFront = DrawingFunction("frame", {
					parent = menu.colorpicker.secondTabBack,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, -2, 1, -2),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 22,
					color = Color3.fromRGB(46, 46, 46),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.secondTabTitle = DrawingFunction("text", {
					parent = menu.colorpicker.secondTabFront,
					anchorpoint = newvec2(0, 0),
					size = 13, -- x3
					font = Drawing.Fonts.Plex,
					position = newudim2(0, 2, 0, 1),
					zindex = menu.basezindex + 23,
					color = Color3.fromRGB(255, 255, 255),
					visible = true,
					outline = false,
					outlinecolor = Color3.fromRGB(12, 12, 12),
					text = "animation",
					name = "okay",
				})

				menu.colorpicker.firstTabBack = DrawingFunction("frame", {
					parent = menu.colorpicker.outline,
					anchorpoint = newvec2(1, 0),
					size = newudim2(0, 40, 0, 18),
					position = newudim2(1, -menu.colorpicker.secondTabBack.absolutesize.x + 1, 0, 0),
					zindex = menu.basezindex + 21,
					color = Color3.fromRGB(0, 0, 0),
					visible = true,
					thickness = 0,
					activated = true,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.firstTabFront = DrawingFunction("frame", {
					parent = menu.colorpicker.firstTabBack,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, -2, 1, -2),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 22,
					color = Color3.fromRGB(46, 46, 46),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.firstTabTitle = DrawingFunction("text", {
					parent = menu.colorpicker.firstTabFront,
					anchorpoint = newvec2(0, 0),
					size = 13, -- x3
					font = Drawing.Fonts.Plex,
					position = newudim2(0, 2, 0, 1),
					zindex = menu.basezindex + 23,
					color = Color3.fromRGB(255, 255, 255),
					visible = true,
					outline = false,
					outlinecolor = Color3.fromRGB(12, 12, 12),
					text = "color",
					name = "okay",
				})

				menu.colorpicker.container = DrawingFunction("frame", {
					parent = menu.colorpicker.outline,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, -2, 1, -2),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 18,
					color = Color3.fromRGB(46, 46, 46),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.pickeroutline = DrawingFunction("frame", {
					parent = menu.colorpicker.container,
					anchorpoint = newvec2(0, 0),
					size = newudim2(0, 212, 0, 212),
					position = newudim2(0, 4, 0, 22),
					zindex = menu.basezindex + 18,
					color = Color3.fromRGB(0, 0, 0),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.pickercontainer = DrawingFunction("frame", {
					parent = menu.colorpicker.pickeroutline,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, -2, 1, -2),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 19,
					color = Color3.new(1, 0, 0),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.picker = DrawingFunction("frame", {
					parent = menu.colorpicker.pickercontainer,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, 0, 1, 0),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 20,
					transparency = 0,
					color = Color3.new(1, 1, 1),
					visible = true,
					activated = true,
					name = "okay",
				})
				menu.activations[1 + #menu.activations] = menu.colorpicker.picker

				do
					local parentedTo = menu.colorpicker.picker
					local smoothGradient = {}
					local xRes = 6
					local yRes = 6
					for xDim = 1, parentedTo.absolutesize.x / xRes do
						smoothGradient[xDim] = {}
						for yDim = 1, parentedTo.absolutesize.y / yRes do
							smoothGradient[xDim][yDim] = utilities:draw("frame", {
								parent = parentedTo,
								anchorpoint = newvec2(0, 0),
								size = newudim2(0, xRes, 0, yRes),
								position = newudim2(0, (xDim - 1) * xRes, 0, (yDim - 1) * yRes),
								zindex = parentedTo.zindex + 1,
								color = Color3.fromHSV(0, 0, 1 - ((yDim - 1) * yRes) / parentedTo.absolutesize.y),
								transparency = 1 - ((xDim - 1) * xRes) / parentedTo.absolutesize.x,
								visible = true,
								name = "okay",
							})
						end
					end
				end


				menu.colorpicker.pickerselection = DrawingFunction("frame", {
					parent = utilities.base,
					anchorpoint = newvec2(0, 0),
					size = newudim2(0, 1, 0, 1),
					position = newudim2(0, 0, 0, 0),
					zindex = menu.basezindex + 22,
					color = Color3.new(1, 1, 1),
					visible = false,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.pickerselectionoutline = DrawingFunction("frame", {
					parent = menu.colorpicker.pickerselection,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, 2, 1, 2),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 21,
					color = Color3.fromRGB(0, 0, 0),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.hueoutline = DrawingFunction("frame", {
					parent = menu.colorpicker.pickeroutline,
					anchorpoint = newvec2(0, 0.5),
					size = newudim2(0, menu.colorpicker.proportions.secondaryBarWidth, 1, 0),
					position = newudim2(1, 4, 0.5, 0),
					zindex = menu.basezindex + 18,
					color = Color3.fromRGB(0, 0, 0),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.huecontainer = DrawingFunction("frame", {
					parent = menu.colorpicker.hueoutline,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, -2, 1, -2),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 19,
					color = Color3.fromRGB(0, 0, 0),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.hue = DrawingFunction("frame", {
					parent = menu.colorpicker.huecontainer,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, 0, 1, 0),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 20,
					transparency = 0,
					visible = true,
					activated = true,
					name = "okay",
				})
				menu.activations[1 + #menu.activations] = menu.colorpicker.hue

				do
					local parentedTo = menu.colorpicker.hue
					local smoothGradient = {}
					local yRes = 6
					for yDim = 1, parentedTo.absolutesize.y / yRes do
						smoothGradient[yDim] = utilities:draw("frame", {
							parent = parentedTo,
							anchorpoint = newvec2(0, 0),
							size = newudim2(1, 0, 0, yRes),
							position = newudim2(0, 0, 0, (yDim - 1) * yRes),
							zindex = parentedTo.zindex + 1,
							color = Color3.fromHSV(1 - ((yDim - 1) * yRes) / parentedTo.absolutesize.y, 1, 1),
							visible = true,
							name = "okay",
						})
					end
				end

				menu.colorpicker.hueselection = DrawingFunction("frame", {
					parent = utilities.base,
					anchorpoint = newvec2(0, 0),
					size = newudim2(0, menu.colorpicker.proportions.secondaryBarWidth + 2, 0, 2),
					position = newudim2(0, 0, 0, 0),
					zindex = menu.basezindex + 22,
					color = Color3.new(1, 1, 1),
					visible = false,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.hueselectionoutline = DrawingFunction("frame", {
					parent = menu.colorpicker.hueselection,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, 2, 1, 2),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 21,
					color = Color3.fromRGB(0, 0, 0),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.transparencyoutline = DrawingFunction("frame", {
					parent = menu.colorpicker.pickeroutline,
					anchorpoint = newvec2(0.5, 0),
					size = newudim2(1, 0, 0, menu.colorpicker.proportions.secondaryBarWidth),
					position = newudim2(0.5, 0, 1, 4),
					zindex = menu.basezindex + 18,
					color = Color3.fromRGB(0, 0, 0),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.transparencycontainer = DrawingFunction("frame", {
					parent = menu.colorpicker.transparencyoutline,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, -2, 1, -2),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 19,
					color = Color3.new(1, 1, 1),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.transparencypicker = DrawingFunction("frame", {
					parent = menu.colorpicker.transparencycontainer,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, 0, 1, 0),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 20,
					transparency = 0,
					visible = true,
					activated = true,
					name = "okay",
				})
				menu.activations[1 + #menu.activations] = menu.colorpicker.transparencypicker

				do
					local parentedTo = menu.colorpicker.transparencypicker
					local smoothGradient = {}
					local xRes = 6
					for xDim = 1, parentedTo.absolutesize.x / xRes do
						smoothGradient[xDim] = utilities:draw("frame", {
							parent = parentedTo,
							anchorpoint = newvec2(0, 0),
							size = newudim2(0, xRes, 1, 0),
							position = newudim2(0, (xDim - 1) * xRes, 0, 0),
							zindex = parentedTo.zindex + 1,
							color = Color3.fromHSV(0, 0, ((xDim - 1) * xRes) / parentedTo.absolutesize.x),
							visible = true,
							name = "okay",
						})                      
					end
				end

				menu.colorpicker.transparencyselection = DrawingFunction("frame", {
					parent = utilities.base,
					anchorpoint = newvec2(0, 0),
					size = newudim2(0, 2, 0, menu.colorpicker.proportions.secondaryBarWidth + 2),
					position = newudim2(0, 0, 0, 0),
					zindex = menu.basezindex + 22,
					color = Color3.new(1, 1, 1),
					visible = false,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				menu.colorpicker.transparencyselectionoutline = DrawingFunction("frame", {
					parent = menu.colorpicker.transparencyselection,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, 2, 1, 2),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 21,
					color = Color3.fromRGB(0, 0, 0),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})
				menu.colorpicker.outline.visible = false

				menu.colorpicker.focusedon = nil

				-- animation tab fuckin thingy (FUCK CREAM)
				menu.colorpicker.secondContainer = DrawingFunction("frame", {
					parent = menu.colorpicker.outline,
					anchorpoint = newvec2(0.5, 0.5),
					size = newudim2(1, -2, 1, -2),
					position = newudim2(0.5, 0, 0.5, 0),
					zindex = menu.basezindex + 18,
					color = Color3.fromRGB(46, 46, 46),
					visible = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})

				-- fuck me dead :c
				menu.colorpicker.animationSelection = {}
				menu.colorpicker.fakeDropdown = nil
				menu.colorpicker.fakeDropdownFlag = nil
				menu.colorpicker.fakeVals = {{"none", true}, {"rainbow", false}, {"linear", false}, {"oscillating", false}, {"sawtooth", false}, {"strobe", false}}
				do
					local targetsection = menu.colorpicker.secondContainer
					local name = "animation"
					local multichoice = false

					local this = {}
					this.dropdownopened = false
					this.valuecontainer = {}
					this.textrecord = {}

					local myflag = menu.colorpicker.animationSelection
					myflag.__index = myflag
					myflag.type = "dropdown"
					myflag.name = name
					myflag.value = {}
					myflag.changed = utilities.signal.new()

					for i, v in next, (menu.colorpicker.fakeVals) do
						local name = v[1]
						local state = v[2]
						myflag.value[name] = state
					end

					this.holder = DrawingFunction("frame", { -- for getting the bounds of the thing
						parent = targetsection,
						anchorpoint = newvec2(0, 0),
						size = newudim2(1, 0, 0, 24), -- WHAT THE FUCL<K>!?#?!#?!@?#!?#?!@?#$!@?H$???
						position = newudim2(0, 0, 0, 12),
						zindex = menu.basezindex + 19,
						color = Color3.fromRGB(255, 255, 255),
						visible = true,
						thickness = 0,
						filled = true,
						transparency = 0,
						name = "okay",
					})
					--hey guys vader here, today we're in need of emotional support

					this.title = DrawingFunction("text", {
						parent = this.holder,
						anchorpoint = newvec2(0, 0),
						size = 13, -- x3
						font = Drawing.Fonts.Plex,
						position = newudim2(0, 16, 0, 8),
						zindex = menu.basezindex + 20,
						color = Color3.fromRGB(255, 255, 255),
						visible = true,
						outline = false,
						outlinecolor = Color3.fromRGB(12, 12, 12),
						text = name,
						name = "okay",
					})

					this.selection = DrawingFunction("frame", { -- for getting the bounds of the thing
						parent = this.holder,
						anchorpoint = newvec2(0.5, 0),
						size = newudim2(1, -30, 0, 16),
						position = newudim2(0.5, 0, 0, 24),
						zindex = menu.basezindex + 20,
						color = menucolors.c,
						visible = true,
						thickness = 0,
						filled = true,
						name = "okay",
					})

					this.selectiontext = DrawingFunction("text", {
						parent = this.selection,
						anchorpoint = newvec2(0, 0.5),
						size = 13, -- x3
						font = Drawing.Fonts.Plex,
						position = newudim2(0, 2, 0.5, -1),
						zindex = menu.basezindex + 21,
						color = Color3.fromRGB(255, 255, 255),
						visible = true,
						outline = false,
						outlinecolor = Color3.fromRGB(12, 12, 12),
						text = "",
						name = "okay",
					})

					this.icon = DrawingFunction("frame", { -- for getting the bounds of the thing
						parent = this.selection,
						anchorpoint = newvec2(0.5, 0.5),
						size = newudim2(1, 2, 1, 2),
						position = newudim2(0.5, 0, 0.5, 0),
						zindex = menu.basezindex + 20,
						color = menucolors.c,
						visible = true,
						thickness = 0,
						filled = true,
						transparency = 0,
						activated = true,
						name = "okay",
					})
					menu.activations[1 + #menu.activations] = this.icon

					this.icontext = DrawingFunction("text", {
						parent = this.icon,
						anchorpoint = newvec2(0, 0.5),
						size = 13, -- x3
						font = Drawing.Fonts.Plex,
						position = newudim2(1, -10, 0.5, -2),
						zindex = menu.basezindex + 21,
						color = Color3.fromRGB(255, 255, 255),
						visible = true,
						outline = false,
						outlinecolor = Color3.fromRGB(12, 12, 12),
						text = "+",
						name = "okay",
					})

					this.selectionoutline = DrawingFunction("frame", { -- for getting the bounds of the thing
						parent = this.selection,
						anchorpoint = newvec2(0.5, 0.5),
						size = newudim2(1, 2, 1, 2),
						position = newudim2(0.5, 0, 0.5, 0),
						zindex = menu.basezindex + 19,
						color = menucolors.d,
						visible = true,
						thickness = 1,
						filled = false,
						name = "okay",
					})

					local maximumchars = floor(this.selection.absolutesize.x / 6.5) - 4 -- suck

					function myflag:setvalue(new)
						myflag.value = new
						local selected = ""
						local selections = 0
						for idx, vals in next, (this.valuecontainer) do
							local i = vals.value
							local v = myflag.value[i]
							if not v then
								myflag.value[i] = false
							end
							if v then
								if selections > 0 then
									selected = selected .. ", "
								end
								selected = selected .. i
								selections = selections + 1
								this.textrecord[i].color = menu.accent
							else
								this.textrecord[i].color = Color3.new(255, 255, 255)
							end
						end
						selected = string.sub(selected, 0, maximumchars)
						if selections == 0 then
							this.selectiontext.text = "none"
						else
							this.selectiontext.text = selected
						end 
						myflag.changed:Fire()

						-- ok so when this shit updates, update the flag thats focused
						if menu.colorpicker.focusedon and menu.colorpicker.focusedon.setAnimation then
							menu.colorpicker.focusedon:setAnimation(new)
						end
					end

					for val, v in next, (menu.colorpicker.fakeVals) do
						local temporary = {}
						local val = v[1] -- so that its in order
						temporary.value = val
						temporary.selectionoutline = DrawingFunction("frame", { -- for getting the bounds of the thing
							parent = this.selection,
							anchorpoint = newvec2(0.5, 0),
							size = newudim2(1, 2, 0, 22),
							position = newudim2(0.5, 0, 0, ((1 + #this.valuecontainer) * 20) -2),
							zindex = menu.basezindex + 27,
							color = menucolors.d,
							visible = false,
							thickness = 0,
							filled = true,
							name = "okay",
						})
						temporary.selection = DrawingFunction("frame", { -- for getting the bounds of the thing
							parent = temporary.selectionoutline,
							anchorpoint = newvec2(0.5, 0.5),
							size = newudim2(1, -2, 1, -2),
							position = newudim2(0.5, 0, 0.5, 0),
							zindex = menu.basezindex + 28,
							color = menucolors.c,
							visible = true,
							thickness = 0,
							filled = true,
							activated = true,
							name = "okay",
						})
						menu.activations[1 + #menu.activations] = temporary.selection
						temporary.selectiontext = DrawingFunction("text", {
							parent = temporary.selection,
							anchorpoint = newvec2(0, 0.5),
							size = 13, -- x3
							font = Drawing.Fonts.Plex,
							position = newudim2(0, 2, 0.5, 0),
							zindex = menu.basezindex + 29,
							color = Color3.fromRGB(255, 255, 255),
							visible = true,
							outline = false,
							outlinecolor = Color3.fromRGB(12, 12, 12),
							text = val,
							name = "okay",
						})
						this.textrecord[val] = temporary.selectiontext
						temporary.selection.clicked:Connect(function()
							if menu.uiopen == false then return end
							for i, v in next, (myflag.value) do
								myflag.value[i] = (val == i) -- suck my nutz
							end
							myflag:setvalue(myflag.value)
						end)
						this.valuecontainer[1 + #this.valuecontainer] = temporary
					end

					this.icon.clicked:Connect(function()
						if menu.uiopen == false then return end
						this.dropdownopened = not this.dropdownopened
						this.icontext.text = (this.dropdownopened == true) and "-" or "+"
						menu.isadropdownopen = this.dropdownopened
						for i, v in next, (this.valuecontainer) do
							v.selectionoutline.visible = this.dropdownopened
							v.selectionoutline.position = v.selectionoutline.position
							v.selectionoutline.size = v.selectionoutline.size
							if v.value and myflag.value[v.value] then
								local val = myflag.value[v.value]
								this.textrecord[v.value].color = (val == true) and menu.accent or Color3.fromRGB(255, 255, 255)
							end
						end
					end)

					local vals = {}
					for i, v in next, (menu.colorpicker.fakeVals) do
						local name = v[1]
						local state = v[2]
						vals[name] = state
					end

					myflag:setvalue(vals)
					menu.colorpicker.fakeDropdown = this
					menu.colorpicker.fakeDropdownFlag = myflag
				end

				menu.colorpicker.animationPanels = {}
				-- switch out the panels based on what is selected
				local first = true
				for i, v in next, menu.colorpicker.fakeVals do
					local name = v[1]
					local state = v[2]

					menu.colorpicker.animationPanels[name] = {}
					menu.colorpicker.animationPanels[name].offset = 54
					menu.colorpicker.animationPanels[name].panel = DrawingFunction("frame", {
						parent = menu.colorpicker.secondContainer,
						anchorpoint = newvec2(0, 0),
						size = newudim2(1, 0, 1, 0),
						position = newudim2(0, 0, 0, 0),
						zindex = menu.basezindex + 18,
						color = Color3.fromRGB(0, 0, 0),
						visible = false,
						transparency = 0, -- hide it
						thickness = 0,
						filled = true,
						name = "okay",
					})

					if first then
						menu.colorpicker.animationPanels[name].panel.visible = true
						first = false
					end

					menu.colorpicker.animationSelection.changed:Connect(function()
						for i2, v2 in next, menu.colorpicker.animationSelection.value do
							if name == i2 then
								menu.colorpicker.animationPanels[name].panel.visible = v2
								menu.colorpicker.animationPanels[name].panel.position = menu.colorpicker.animationPanels[name].panel.position + newudim2(0, 1, 0, 1)
								menu.colorpicker.animationPanels[name].panel.position = menu.colorpicker.animationPanels[name].panel.position - newudim2(0, 1, 0, 1)
							end
						end
					end)
				end
				-- hey guys vader here, today we're becoming alan
				menu.colorpicker.animationPanelElements = {
					none = {},
					rainbow = {
						{
							type = "slider",
							name = "speed",
							max = 1000,
							min = 1,
							suffix = "%"
						}
					},
					linear = {
						{
							type = "color",
							name = "keyframe 1"
						},
						{
							type = "color",
							name = "keyframe 2"
						},
						{
							type = "slider",
							name = "speed",
							max = 1000,
							min = 1,
							suffix = "%"
						}
					},
					oscillating = {
						{
							type = "color",
							name = "keyframe 1"
						},
						{
							type = "color",
							name = "keyframe 2"
						},
						{
							type = "slider",
							name = "speed",
							max = 1000,
							min = 1,
							suffix = "%"
						}
					},
					sawtooth = {
						{
							type = "color",
							name = "keyframe 1"
						},
						{
							type = "color",
							name = "keyframe 2"
						},
						{
							type = "slider",
							name = "speed",
							max = 1000,
							min = 1,
							suffix = "%"
						}
					},
					strobe = {
						{
							type = "color",
							name = "keyframe 1"
						},
						{
							type = "color",
							name = "keyframe 2"
						},
						{
							type = "slider",
							name = "speed",
							max = 1000,
							min = 1,
							suffix = "%"
						}
					}
				}
				menu.colorpicker.elementReference = {}
				menu.colorpicker.flagReference = {}
				for name, elements in next, menu.colorpicker.animationPanelElements do

					menu.colorpicker.elementReference[name] = {}
					menu.colorpicker.flagReference[name] = {}
					local sectionReference = menu.colorpicker.elementReference[name]

					local section = menu.colorpicker.animationPanels[name]
					local targetsection = section.panel
					local currentOffset = section.offset

					for i, data in next, elements do
						menu.colorpicker.elementReference[name][data.name] = {}

						local fakeFlag = {}

						if data.type == "slider" then
							local flag = fakeFlag
							local minimum = data.min
							local maximum = data.max
							local suffix = data.suffix ~= nil and data.suffix or ""
							local customtext = {}

							local this = {}
							local offset = currentOffset - 10
							local myflag = fakeFlag -- mypenis

							myflag.__index = fakeFlag
							myflag.type = "slider"
							myflag.value = data.min
							myflag.changed = utilities.signal.new()

							this.holder = DrawingFunction("frame", { -- for getting the bounds of the thing
								parent = targetsection,
								anchorpoint = newvec2(0, 0),
								size = newudim2(1, 0, 0, 24),
								position = newudim2(0, 0, 0, offset),
								zindex = menu.basezindex + 6 + 12,
								color = Color3.fromRGB(255, 255, 255),
								visible = true,
								thickness = 0,
								filled = true,
								transparency = 0,
								name = "okay",
							})

							targetsection.getpropertychangedsignal:Connect(function(prop, val)
								if prop == "visible" then
									this.holder.position = newudim2(0, 0, 0, offset)
								end
							end)

							this.title = DrawingFunction("text", {
								parent = this.holder,
								anchorpoint = newvec2(0, 0),
								size = 13, -- x3
								font = Drawing.Fonts.Plex,
								position = newudim2(0, 16, 0, 8),
								zindex = menu.basezindex + 7 + 12,
								color = parameters.detected and Color3.fromRGB(255, 106, 79) or Color3.fromRGB(255, 255, 255),
								visible = true,
								outline = false,
								outlinecolor = Color3.fromRGB(12, 12, 12),
								text = data.name,
								name = "okay",
							})

							this.sliderback = DrawingFunction("frame", { -- for getting the bounds of the thing
								parent = this.holder,
								anchorpoint = newvec2(0, 0),
								size = newudim2(1, -32, 0, 6),
								position = newudim2(0, 16, 0, 24),
								zindex = menu.basezindex + 7 + 12,
								color = menucolors.b,
								visible = true,
								thickness = 0,
								filled = true,
								name = "okay",
							})

							this.sliderbackoutline = DrawingFunction("frame", { -- for getting the bounds of the thing
								parent = this.sliderback,
								anchorpoint = newvec2(0.5, 0.5),
								size = newudim2(1, 2, 1, 2),
								position = newudim2(0.5, 0, 0.5, 0),
								zindex = menu.basezindex + 6 + 12,
								color = menucolors.d,
								visible = true,
								thickness = 1,
								filled = false,
								name = "okay",
							})

							this.slider = {}
							for i = 1, 6 do
								this.slider[i] = DrawingFunction("frame", { -- for getting the bounds of the thing
									parent = this.sliderback,
									anchorpoint = newvec2(0, 0),
									size = newudim2(0, 6, 0, 1),
									position = newudim2(0, 0, 0, i),
									zindex = menu.basezindex + 9 + 12,
									color = menu.accent:lerp(Color3.fromRGB(math.clamp((menu.accent.r * 255) - 5, 0, 255), math.clamp((menu.accent.g * 255) - 5, 0, 255), math.clamp((menu.accent.b * 255) - 5, 0, 255)), (i - 1) / 5),
									visible = true,
									thickness = 0,
									filled = true,
									name = "okay",
								})
							end

							menu.accents[1 + #menu.accents] = this.slider

							this.hitbox = DrawingFunction("frame", { -- for getting the bounds of the thing
								parent = this.sliderback,
								anchorpoint = newvec2(0.5, 0.5),
								size = newudim2(1, 0, 1, 10),
								position = newudim2(0.5, 0, 0.5, 0),
								zindex = menu.basezindex + 7 + 12,
								color = Color3.fromRGB(255, 255, 255),
								visible = true,
								thickness = 0,
								transparency = 0,
								activated = true,
								filled = true,
								name = "okay",
							})
							menu.activations[1 + #menu.activations] = this.hitbox

							this.valuetitle = DrawingFunction("text", {
								parent = this.sliderback,
								anchorpoint = newvec2(0.5, 0),
								size = 13, -- x3
								font = Drawing.Fonts.Plex,
								position = newudim2(1, 0, 0, 0),
								zindex = menu.basezindex + 9 + 12,
								color = Color3.fromRGB(255, 255, 255),
								visible = true,
								outline = false,
								outlinecolor = Color3.fromRGB(12, 12, 12),
								text = "0°",
								name = "okay",
							})

							this.addtext = DrawingFunction("text", {
								parent = this.sliderback,
								anchorpoint = newvec2(1, 0.5),
								size = 13, -- x3
								font = Drawing.Fonts.Plex,
								position = newudim2(1, 10, 0.5, -2),
								zindex = menu.basezindex + 9 + 12,
								color = Color3.fromRGB(255, 255, 255),
								visible = true,
								outline = false,
								outlinecolor = Color3.fromRGB(12, 12, 12),
								activated = true,
								text = "+",
								name = "okay",
							})

							this.subtext = DrawingFunction("text", {
								parent = this.sliderback,
								anchorpoint = newvec2(0, 0.5),
								size = 13, -- x3
								font = Drawing.Fonts.Plex,
								position = newudim2(0, -10, 0.5, -2),
								zindex = menu.basezindex + 9 + 12,
								color = Color3.fromRGB(255, 255, 255),
								visible = true,
								outline = false,
								outlinecolor = Color3.fromRGB(12, 12, 12),
								text = "-",
								activated = true,
								name = "okay",
							})

							local textupdateconnection -- so u can click on the value text and manually enter a number
							function myflag:setvalue(new)
								if new == nil then
									new = 0
								end
								local newtext = tostring(new)
								if textupdateconnection then -- we r typing
									newtext = newtext .. "|"
								else
									new = clamp(new, minimum, maximum)
								end
								newtext = tostring(new)
								if customtext[newtext] then
									this.valuetitle.text = customtext[newtext]
								else
									this.valuetitle.text = newtext .. suffix
								end
								for i, v in next, this.slider do
									v.position = newudim2((((clamp(new, minimum, maximum) - minimum)) / (maximum - minimum)), 0, 0, i - 1) -- s3x
									local tostart = v.absoluteposition.x - this.sliderback.absoluteposition.x
									local scalederrr = -tostart / this.sliderback.absolutesize.x
									v.size = newudim2(scalederrr, 0, 0, 1)
								end
								this.valuetitle.position = this.slider[#this.slider].position + newudim2(0, 0, 0, 0)
								myflag.value = new
								myflag.changed:Fire()

								if menu.colorpicker.focusedon then
									menu.colorpicker.focusedon.animationSpeed[name] = new
								end
							end

							local connection
							this.hitbox.clicked:Connect(function()
								if menu.uiopen == false or menu.isadropdownopen then return end
								connection = runservice.Stepped:Connect(function()
									local relative = utilities.mouse.position.x
									local mousebound = utilities.mouse.position.x - this.hitbox.absoluteposition.x - 1
									mousebound = clamp(mousebound, 0, this.hitbox.absolutesize.x)
									local result = mousebound
									result = clamp(result, 0, this.hitbox.absolutesize.x)
									result = floor(0.5 + (((maximum - minimum) / this.hitbox.absolutesize.x) * mousebound) + minimum)
									myflag:setvalue(result)
									if this.hitbox.holding == false or menu.uiopen == false then
										connection:Disconnect()
										connection = nil
										return
									end
								end)
							end)

							this.addtext.mouseenter:Connect(function()
								this.addtext.color = menu.accent
							end)

							this.addtext.mouseleave:Connect(function()
								this.addtext.color = Color3.fromRGB(255, 255, 255)
							end)

							this.subtext.mouseenter:Connect(function()
								this.subtext.color = menu.accent
							end)

							this.subtext.mouseleave:Connect(function()
								this.subtext.color = Color3.fromRGB(255, 255, 255)
							end)

							this.addtext.clicked:Connect(function()
								myflag:setvalue(myflag.value + 1)
							end)

							this.subtext.clicked:Connect(function()
								myflag:setvalue(myflag.value - 1)
							end)

							myflag:setvalue(parameters.value)

							this.offsetted = currentOffset

							currentOffset = currentOffset + 36

							sectionReference[name] = this
						elseif data.type == "color" then
							local this = {}
							local dn = {}
							local myflag = dn

							currentOffset = currentOffset

							myflag.__index = dn
							myflag.type = "toggle"
							myflag.value = false
							myflag.changed = utilities.signal.new()

							this.hitbox = DrawingFunction("frame", { -- for getting the bounds of the thing
								parent = targetsection,
								anchorpoint = newvec2(0, 0),
								size = newudim2(1, 0, 0, 14),
								position = newudim2(0, 0, 0, currentOffset),
								zindex = menu.basezindex + 6 + 12,
								color = Color3.fromRGB(255, 255, 255),
								visible = true,
								thickness = 0,
								filled = true,
								transparency = 0,
								name = "okay",
							})

							this.toggle = DrawingFunction("frame", { -- for getting the bounds of the thing
								parent = this.hitbox,
								anchorpoint = newvec2(0, 0.5),
								size = newudim2(0, 8, 0, 8),
								position = newudim2(0, 8, 0.5, 0),
								zindex = menu.basezindex + 7 + 12,
								color = Color3.fromRGB(76, 76, 76),
								visible = false,
								thickness = 0,
								filled = true,
								name = "okay",
							})

							this.toggleoutline = DrawingFunction("frame", { -- for getting the bounds of the thing
								parent = this.toggle,
								anchorpoint = newvec2(0.5, 0.5),
								size = newudim2(1, 2, 1, 2),
								position = newudim2(0.5, 0, 0.5, 0),
								zindex = menu.basezindex + 6 + 12,
								color = Color3.fromRGB(0, 0, 0),
								visible = false,
								thickness = 1,
								filled = false,
								name = "okay",
							})

							this.toggled = DrawingFunction("frame", { -- for getting the bounds of the thing
								parent = this.toggle,
								anchorpoint = newvec2(0, 0),
								size = newudim2(1, 0, 1, 0),
								position = newudim2(0, 0, 0, 0),
								zindex = menu.basezindex + 7 + 12,
								color = menu.accent,
								visible = false,
								thickness = 0,
								filled = true,
								name = "okay",
							})

							this.title = DrawingFunction("text", {
								parent = this.hitbox,
								anchorpoint = newvec2(0, 0.5),
								size = 13, -- x3
								font = Drawing.Fonts.Plex,
								position = newudim2(0, 16, 0.5, -1),
								zindex = menu.basezindex + 6 + 12,   
								color = parameters.detected and Color3.fromRGB(255, 106, 79) or Color3.fromRGB(255, 255, 255),
								visible = true,
								outline = false,
								outlinecolor = Color3.fromRGB(12, 12, 12),
								text = data.name,
								name = "okay",
							})

							this.realhitbox = DrawingFunction("frame", { -- for getting the bounds of the thing
								parent = this.hitbox,
								anchorpoint = newvec2(0, 0.5),
								size = newudim2(0, 32 + this.title.absolutesize.x, 1, 0),
								position = newudim2(0, 0, 0.5, 0),
								zindex = menu.basezindex + 8 + 12,
								color = Color3.fromRGB(255, 255, 255),
								visible = true,
								thickness = 0,
								filled = true,
								transparency = 0,
								name = "okay",
							})

							this.accessories = {} -- color pickers and what not

							currentOffset = currentOffset + 14

							do
								local parameters = {
									name = data.name,
									flag = fakeFlag,
									color = Color3.new(1, 1, 1),
									transparency = 0
								}
								local targetobj = this
								if not targetobj.accessories then
									return
								end
								local flag = parameters.flag
								local colorThis = {}

								local myflag = fakeFlag
								myflag.__index = fakeFlag
								myflag.type = "color"
								myflag.color = parameters.color
								myflag.transparency = parameters.transparency
								myflag.changed = utilities.signal.new()

								colorThis.outline = DrawingFunction("frame", { -- for getting the bounds of the thing
									parent = this.hitbox,
									anchorpoint = newvec2(1, 0.5),
									size = newudim2(0, 24, 0, 12),
									position = newudim2(1, -14, 0.5, 0),
									zindex = menu.basezindex + 8 + 12,
									color = Color3.fromRGB(12, 12, 12),
									visible = true,
									thickness = 0,
									activated = true,
									filled = true,
									name = "okay",
								})

								colorThis.color = {}
								for i = 1, 5 do
									colorThis.color[i] = DrawingFunction("frame", { -- for getting the bounds of the thing
										parent = colorThis.outline,
										anchorpoint = newvec2(0.5, 0),
										size = newudim2(1, -2, 0, 2),
										position = newudim2(0.5, 0, 0, (i - 1) * 2 + 1),
										zindex = menu.basezindex + 10 + 12,
										color = parameters.color:lerp(Color3.fromRGB(math.clamp(parameters.color.r * 255 - 33, 0, 255), math.clamp(parameters.color.g * 255 - 33, 0, 255), math.clamp(parameters.color.b * 255 - 33, 0, 255)), i / 5),
										visible = true,
										thickness = 0,
										filled = true,
										name = "okay",
									}) 
								end

								function myflag:setcolor(new)
									myflag.color = new
									for i = 1, 5 do
										local segment = colorThis.color[i]
										segment.color = new:lerp(Color3.fromRGB(math.clamp(new.r * 255 - 20, 0, 255), math.clamp(new.g * 255 - 20, 0, 255), math.clamp(new.b * 255 - 20, 0, 255)), (i - 1) / 5)
									end
									myflag.changed:Fire()

									if menu.colorpicker.focusedon then
										menu.colorpicker.focusedon.animationKeyFrames[name][data.name].color = new
									end
								end

								function myflag:settransparency(new)
									myflag.transparency = new
									myflag.changed:Fire()

									if menu.colorpicker.focusedon then
										menu.colorpicker.focusedon.animationKeyFrames[name][data.name].transparency = new
									end
								end

								myflag:setcolor(parameters.color)
								if myflag.transparency then
									myflag:settransparency(parameters.transparency)
								end

								colorThis.outline.clicked:Connect(function()
									if menu.uiopen == false or menu.isadropdownopen then return end
									menu:oldcallcolorpicker(data.name, fakeFlag, utilities.mouse.position, menu.colorpicker.focusedon.transparency and fakeFlag.transparency or nil)
								end)

								colorThis.bounds = newvec2(28, 0)

								colorThis.outline.visible = true

								sectionReference[data.name] = colorThis
							end
						end

						menu.colorpicker.flagReference[name][data.name] = fakeFlag
					end
				end

				menu.colorpicker.firstTabBack.clicked:Connect(function()
					if not menu.colorpicker.focusedon then return end
					menu.colorpicker.container.visible = true
					menu.colorpicker.secondContainer.visible = false

					local transparency = menu.colorpicker.focusedon.transparency
					if transparency then
						menu.colorpicker.transparencyoutline.visible = true
						menu.colorpicker.transparencyselection.visible = true
						menu.colorpicker.transparencyoutline.position = menu.colorpicker.transparencyoutline.position
						menu.colorpicker.transparencyselection.position = newudim2(0, transparency * menu.colorpicker.transparencypicker.absolutesize.x, 0, -2) + newudim2(0, menu.colorpicker.transparencypicker.absoluteposition.x, 0, menu.colorpicker.transparencypicker.absoluteposition.y)
					else
						menu.colorpicker.transparencyoutline.visible = false
						menu.colorpicker.transparencyselection.visible = false
					end

					menu.colorpicker.hueselection.visible = true
					menu.colorpicker.pickerselection.visible = true

					menu.colorpicker.firstTabFront.color = Color3.new(0, 0, 0)
					menu.colorpicker.secondTabFront.color = Color3.fromRGB(46, 46, 46)
				end)

				menu.colorpicker.secondTabBack.clicked:Connect(function()
					if not menu.colorpicker.focusedon then return end
					menu.colorpicker.container.visible = false
					menu.colorpicker.secondContainer.visible = true
					menu.colorpicker.secondContainer.position = menu.colorpicker.secondContainer.position + newudim2(0, -1, 0, 0)
					menu.colorpicker.secondContainer.position = menu.colorpicker.secondContainer.position + newudim2(0, 1, 0, 0)

					menu.colorpicker.transparencyselection.visible = false

					menu.colorpicker.hueselection.visible = false
					menu.colorpicker.pickerselection.visible = false

					menu.colorpicker.firstTabFront.color = Color3.fromRGB(46, 46, 46)
					menu.colorpicker.secondTabFront.color = Color3.new(0, 0, 0)

					menu.colorpicker.fakeDropdown.holder.position = newudim2(0, 0, 0, 12)

					for i, v in next,  menu.colorpicker.animationPanels do
						v.panel.position = v.panel.position + newudim2(0, 0, 0, 1)
						v.panel.position = v.panel.position - newudim2(0, 0, 0, 1)
					end
				end)

				-- how 2 pick color
				menu.colorpicker.picker.clicked:Connect(function()
					local oldhue = abs(1 - (clamp(menu.colorpicker.hueselection.absoluteposition.y, menu.colorpicker.hue.absoluteposition.y, menu.colorpicker.hue.absoluteposition.y + menu.colorpicker.hue.absolutesize.y) - menu.colorpicker.picker.absoluteposition.y) / menu.colorpicker.picker.absolutesize.y)

					local xpos = clamp(utilities.mouse.position.x, menu.colorpicker.picker.absoluteposition.x, menu.colorpicker.picker.absoluteposition.x + menu.colorpicker.picker.absolutesize.x)
					local ypos = clamp(utilities.mouse.position.y, menu.colorpicker.picker.absoluteposition.y, menu.colorpicker.picker.absoluteposition.y + menu.colorpicker.picker.absolutesize.y)
					menu.colorpicker.pickerselection.position = newudim2(0, xpos, 0, ypos)
					-- quick maths

					local sat = clamp((xpos - menu.colorpicker.picker.absoluteposition.x) / menu.colorpicker.picker.absolutesize.x, 0, 1)
					local val = clamp(abs(1 - (ypos - menu.colorpicker.picker.absoluteposition.y) / menu.colorpicker.picker.absolutesize.y), 0, 1)

					menu.colorpicker.focusedon:setcolor(Color3.fromHSV(oldhue, sat, val))  

					menu.colorpicker.updater = utilities.mouse.moved:Connect(function()
						local xpos = clamp(utilities.mouse.position.x, menu.colorpicker.picker.absoluteposition.x, menu.colorpicker.picker.absoluteposition.x + menu.colorpicker.picker.absolutesize.x)
						local ypos = clamp(utilities.mouse.position.y, menu.colorpicker.picker.absoluteposition.y, menu.colorpicker.picker.absoluteposition.y + menu.colorpicker.picker.absolutesize.y)
						menu.colorpicker.pickerselection.position = newudim2(0, xpos, 0, ypos)
						-- quick maths

						local sat = clamp((xpos - menu.colorpicker.picker.absoluteposition.x) / menu.colorpicker.picker.absolutesize.x, 0, 1)
						local val = clamp(abs(1 - (ypos - menu.colorpicker.picker.absoluteposition.y) / menu.colorpicker.picker.absolutesize.y), 0, 1)

						menu.colorpicker.focusedon:setcolor(Color3.fromHSV(oldhue, sat, val))
					end)
				end)

				menu.colorpicker.hue.clicked:Connect(function()
					local old = menu.colorpicker.focusedon.color
					local oldhue, oldsat, oldval = Color3.toHSV(old)

					local xpos = clamp(utilities.mouse.position.x, menu.colorpicker.hue.absoluteposition.x, menu.colorpicker.hue.absoluteposition.x + menu.colorpicker.hue.absolutesize.x)
					local ypos = clamp(utilities.mouse.position.y, menu.colorpicker.hue.absoluteposition.y, menu.colorpicker.hue.absoluteposition.y + menu.colorpicker.hue.absolutesize.y)
					menu.colorpicker.hueselection.position = newudim2(0, menu.colorpicker.hue.absoluteposition.x - 2, 0, ypos)

					local hue = abs(1 - (ypos - menu.colorpicker.picker.absoluteposition.y) / menu.colorpicker.picker.absolutesize.y)

					menu.colorpicker.focusedon:setcolor(Color3.fromHSV(hue, oldsat, oldval))
					menu.colorpicker.pickercontainer.color = Color3.fromHSV(hue, 1, 1)

					menu.colorpicker.updater = utilities.mouse.moved:Connect(function()
						local xpos = clamp(utilities.mouse.position.x, menu.colorpicker.hue.absoluteposition.x, menu.colorpicker.hue.absoluteposition.x + menu.colorpicker.hue.absolutesize.x)
						local ypos = clamp(utilities.mouse.position.y, menu.colorpicker.hue.absoluteposition.y, menu.colorpicker.hue.absoluteposition.y + menu.colorpicker.hue.absolutesize.y)
						menu.colorpicker.hueselection.position = newudim2(0, menu.colorpicker.hue.absoluteposition.x - 2, 0, ypos)

						local hue = abs(1 - (ypos - menu.colorpicker.picker.absoluteposition.y) / menu.colorpicker.picker.absolutesize.y)

						menu.colorpicker.focusedon:setcolor(Color3.fromHSV(hue, oldsat, oldval))
						menu.colorpicker.pickercontainer.color = Color3.fromHSV(hue, 1, 1)
					end)
				end)

				menu.colorpicker.transparencypicker.clicked:Connect(function()
					local xpos = clamp(utilities.mouse.position.x, menu.colorpicker.transparencypicker.absoluteposition.x, menu.colorpicker.transparencypicker.absoluteposition.x + menu.colorpicker.transparencypicker.absolutesize.x)
					local ypos = clamp(utilities.mouse.position.y, menu.colorpicker.transparencypicker.absoluteposition.y, menu.colorpicker.transparencypicker.absoluteposition.y + menu.colorpicker.transparencypicker.absolutesize.y)
					menu.colorpicker.transparencyselection.position = newudim2(0, xpos, 0, menu.colorpicker.transparencypicker.absoluteposition.y - 2)

					local transparency = (xpos - menu.colorpicker.transparencypicker.absoluteposition.x) / menu.colorpicker.transparencypicker.absolutesize.x
					menu.colorpicker.focusedon:settransparency(transparency)

					menu.colorpicker.updater = utilities.mouse.moved:Connect(function()
						local xpos = clamp(utilities.mouse.position.x, menu.colorpicker.transparencypicker.absoluteposition.x, menu.colorpicker.transparencypicker.absoluteposition.x + menu.colorpicker.transparencypicker.absolutesize.x)
						local ypos = clamp(utilities.mouse.position.y, menu.colorpicker.transparencypicker.absoluteposition.y, menu.colorpicker.transparencypicker.absoluteposition.y + menu.colorpicker.transparencypicker.absolutesize.y)
						menu.colorpicker.transparencyselection.position = newudim2(0, xpos, 0, menu.colorpicker.transparencypicker.absoluteposition.y - 2)

						local transparency = (xpos - menu.colorpicker.transparencypicker.absoluteposition.x) / menu.colorpicker.transparencypicker.absolutesize.x
						menu.colorpicker.focusedon:settransparency(transparency)
					end)
				end)

				utilities.mouse.mousebutton1up:Connect(function()
					if menu.colorpicker.updater then 
						menu.colorpicker.updater:Disconnect()
					end
				end)

				function menu:callcolorpicker(name, flag, position, transparency)
					if not flag then return end
					local old = flag.color
					local oldhue, oldsat, oldval = Color3.toHSV(old)

					menu.colorpicker.container.visible = true
					menu.colorpicker.secondContainer.visible = false
					menu.colorpicker.transparencyselection.visible = true
					menu.colorpicker.hueselection.visible = true
					menu.colorpicker.pickerselection.visible = true

					menu.colorpicker.firstTabFront.color = Color3.new(0, 0, 0)
					menu.colorpicker.secondTabFront.color = Color3.fromRGB(46, 46, 46)

					menu.colorpicker.outline.visible = true
					menu.isacolorpickeropen = true
					menu.colorpicker.outline.position = newudim2(0, position.x, 0, position.y)
					menu.colorpicker.title.text = name
					menu.colorpicker.pickercontainer.color = Color3.fromHSV(oldhue, 1, 1)

					if transparency then
						menu.colorpicker.outline.size = newudim2(0, menu.colorpicker.proportions.mainSize.x, 0, menu.colorpicker.proportions.mainSize.y + menu.colorpicker.proportions.secondaryBarWidth + 2)
					else
						menu.colorpicker.outline.size = newudim2(0, menu.colorpicker.proportions.mainSize.x, 0, menu.colorpicker.proportions.mainSize.y)
					end

					menu.colorpicker.hueselection.visible = true
					menu.colorpicker.pickerselection.visible = true

					menu.colorpicker.transparencyoutline.visible = transparency ~= nil and true or false
					menu.colorpicker.transparencyselection.visible = transparency ~= nil and true or false

					menu.colorpicker.hueselection.position = newudim2(0, -2, 0, abs(1 - oldhue) * menu.colorpicker.hue.absolutesize.y) + newudim2(0, menu.colorpicker.hue.absoluteposition.x, 0, menu.colorpicker.hue.absoluteposition.y)
					menu.colorpicker.pickerselection.position = newudim2(0, oldsat * menu.colorpicker.picker.absolutesize.x, 0, abs(oldval - 1) * menu.colorpicker.picker.absolutesize.y) + newudim2(0, menu.colorpicker.picker.absoluteposition.x, 0, menu.colorpicker.picker.absoluteposition.y)

					menu.colorpicker.focusedon = flag

					if transparency then
						menu.colorpicker.transparencyoutline.position = menu.colorpicker.transparencyoutline.position
						menu.colorpicker.transparencyselection.position = newudim2(0, transparency * menu.colorpicker.transparencypicker.absolutesize.x, 0, -2) + newudim2(0, menu.colorpicker.transparencypicker.absoluteposition.x, 0, menu.colorpicker.transparencypicker.absoluteposition.y)
					end
					-- thing
					menu.colorpicker.outofboundscloseconnection = utilities.mouse.mousebutton1down:Connect(function()
						if utilities.mousechecks.inbounds(menu.oldcolorpicker.outline, utilities.mouse.position) == false and utilities.mousechecks.inbounds(menu.colorpicker.outline, utilities.mouse.position) == false then -- uh oh..
							if menu.colorpicker.updater then
								menu.colorpicker.updater:Disconnect()
							end

							menu.colorpicker.outline.visible = false
							menu.colorpicker.transparencyselection.visible = false
							menu.colorpicker.hueselection.visible = false
							menu.colorpicker.pickerselection.visible = false
							menu.isacolorpickeropen = false

							if menu.colorpicker.outofboundscloseconnection then
								menu.colorpicker.outofboundscloseconnection:Disconnect()
								menu.colorpicker.outofboundscloseconnection = nil
							end

							do
								local myflag = menu.colorpicker.animationSelection
								local this = menu.colorpicker.fakeDropdown
								this.dropdownopened = false
								this.icontext.text = (this.dropdownopened == true) and "-" or "+"
								menu.isadropdownopen = false
								for i, v in next, (this.valuecontainer) do
									v.selectionoutline.visible = this.dropdownopened
									v.selectionoutline.position = v.selectionoutline.position
									v.selectionoutline.size = v.selectionoutline.size
									if v.value and myflag.value[v.value] then
										local val = myflag.value[v.value]
										this.textrecord[v.value].color = (val == true) and menu.accent or Color3.fromRGB(255, 255, 255)
									end
								end
							end
						end
					end)

					-- animation section fix
					menu.colorpicker.fakeDropdownFlag:setvalue(flag.animation)

					-- keyframe fix
					for element, keyframes in next, flag.animationKeyFrames do
						for keyindex, data in next, keyframes do
							menu.colorpicker.flagReference[element][keyindex]:setcolor(data.color)
							if data.transparency then
								menu.colorpicker.flagReference[element][keyindex]:settransparency(data.transparency)
							end
						end
					end

					-- slider fix
					for element, value in next, flag.animationSpeed do
						menu.colorpicker.flagReference[element]["speed"]:setvalue(value)
					end
				end

				menu:callcolorpicker(
					"Evie <3", 
					{
						color = Color3.new(1, 1, 1),
						animation = {
							none = true,
							rainbow = false,
							linear = false,
							oscillating = false, 
							strobe = false
						},
						animationKeyFrames = {
							linear = {
								["keyframe 1"] = {
									color = Color3.new(),
									transparency = 1
								},
								["keyframe 2"] = {
									color = Color3.new(),
									transparency = 1
								}
							},
							oscillating = {
								["keyframe 1"] = {
									color = Color3.new(),
									transparency = 1
								},
								["keyframe 2"] = {
									color = Color3.new(),
									transparency = 1
								}
							},
							strobe = {
								["keyframe 1"] = {
									color = Color3.new(),
									transparency = 1
								},
								["keyframe 2"] = {
									color = Color3.new(),
									transparency = 1
								}
							},
						}, -- color and transparency
						animationSpeed = {
							rainbow = 100,
							linear = 100,
							oscillating = 100,
							strobe = 100
						},
					}, 
					newvec2(), 
					nil
				)
				do
					if menu.colorpicker.updater then
						menu.colorpicker.updater:Disconnect()
					end

					menu.colorpicker.outline.visible = false
					menu.colorpicker.transparencyselection.visible = false
					menu.colorpicker.hueselection.visible = false
					menu.colorpicker.pickerselection.visible = false
					menu.isacolorpickeropen = false

					if menu.colorpicker.outofboundscloseconnection then
						menu.colorpicker.outofboundscloseconnection:Disconnect()
						menu.colorpicker.outofboundscloseconnection = nil
					end

					do
						local myflag = menu.colorpicker.animationSelection
						local this = menu.colorpicker.fakeDropdown
						this.dropdownopened = false
						this.icontext.text = (this.dropdownopened == true) and "-" or "+"
						menu.isadropdownopen = false
						for i, v in next, (this.valuecontainer) do
							v.selectionoutline.visible = this.dropdownopened
							v.selectionoutline.position = v.selectionoutline.position
							v.selectionoutline.size = v.selectionoutline.size
							if v.value and myflag.value[v.value] then
								local val = myflag.value[v.value]
								this.textrecord[v.value].color = (val == true) and menu.accent or Color3.fromRGB(255, 255, 255)
							end
						end
					end
				end
			end
		end

		function menu:setsize(size)
			menu.objects.backborder.size = newudim2(0, math.clamp(size.x, parameters.size.x, 1/0), 0, math.clamp(size.y, parameters.size.y, 1/0))
		end

		function menu:savestate() -- configs!!
			local state = {}
			for i, v in next, (menu.flags) do
				if i:match("config") or i:match("playerlist") then -- ignore the configs!!
				else
					local kind = v.type
					if kind == "toggle" or kind == "slider" or kind == "textbox" then
						local val = {v.value}
						state[i] = {kind, val}
					elseif kind == "color" then
						local val = {v.color.r, v.color.g, v.color.b, v.transparency}
						local keyFrameFix = {}
						for n, kfs in next, v.animationKeyFrames do
							keyFrameFix[n] = {}
							for idx, d in next, kfs do
								keyFrameFix[n][idx] =  {d.color.r, d.color.g, d.color.b, d.transparency}
							end
						end
						local animations = {
							animation = v.animation,
							animationKeyFrames = keyFrameFix,
							speeds = v.animationSpeed
						}
						state[i] = {kind, {val, animations}}
					elseif kind == "dropdown" then
						local val = {}
						for i, v in next, (v.value) do
							val[i] = v
						end
						state[i] = {kind, val}
					elseif kind == "keybind" then
						local val = {v.key ~= "NONE" and v.key or "NONE", v.activation}
						state[i] = {kind, val}
					end
				end
			end
			state.menusize = {x = menu.objects.backborder.absolutesize.x, y = menu.objects.backborder.absolutesize.y}
			state.panelsize = {}
			for tab, columns in next, menu.subsections do
				if tab ~= "players" then
					state.panelsize[tab] = {}
					for column, panels in next, columns do
						for panel, data in next, panels do
							local sz = data.panelResize.getSize()
							local ps = data.panelReposition.getPosition()

							state.panelsize[tab][panel] = {
								size = {
									scalex = sz.X.Scale,
									scaley = sz.Y.Scale,
									offsetx = sz.X.Offset,
									offsety = sz.Y.Offset
								},
								position = {
									scalex = ps.X.Scale,
									scaley = ps.Y.Scale,
									offsetx = ps.X.Offset,
									offsety = ps.Y.Offset,
									side = data.panelReposition.getSide()
								}
							}
						end
					end
				end
			end

			return json.encode(state)
		end

		function menu:loadstate(state)
			local state = json.decode(state)
			for i, v in next, (state) do
				if i == "menusize" then
					menu:setsize(Vector2.new(v.x, v.y))
				elseif i == "panelsize" then
					for tab, columns in next, menu.subsections do
						if tab ~= "players" then
							for column, panels in next, columns do
								for panel, data in next, panels do
									if v[tab] and v[tab][panel] then
										local configData = v[tab][panel]
										local menuPanel = data
										if menuPanel then
											menuPanel.panelReposition.setSide(configData.position.side)
										end
									end
								end
							end
						end
					end
					for tab, columns in next, menu.subsections do
						if tab ~= "players" then
							for column, panels in next, columns do
								for panel, data in next, panels do
									if v[tab] and v[tab][panel] then
										local configData = v[tab][panel]
										local menuPanel = data
										if menuPanel then
											menuPanel.panelReposition.setPosition(newudim2(configData.position.scalex, configData.position.offsetx, configData.position.scaley, configData.position.offsety))
										end
									end
								end
							end
						end
					end
					for tab, columns in next, menu.subsections do
						if tab ~= "players" then
							for column, panels in next, columns do
								for panel, data in next, panels do
									if v[tab] and v[tab][panel] then
										local configData = v[tab][panel]
										local menuPanel = data
										if menuPanel then
											menuPanel.panelResize.setSize(newudim2(configData.size.scalex, configData.size.offsetx, configData.size.scaley, configData.size.offsety))
										end
									end
								end
							end
						end
					end
				else
					local ff = menu.flags[i]
					if ff then
						local kind = v[1]
						local value = v[2]
						if kind == "toggle" or kind == "slider" or kind == "textbox" then
							ff:setvalue(value[1])
						elseif kind == "dropdown" then
							ff:setvalue(value)
						elseif kind == "color" then
							ff:setcolor(Color3.new(value[1][1], value[1][2], value[1][3]))
							if value[1][4] then
								ff:settransparency(value[1][4])
							end
							local keyFrameFix = {}
							for n, kfs in next, value[2].animationKeyFrames do
								keyFrameFix[n] = {}
								for idx, d in next, kfs do
									keyFrameFix[n][idx] = {
										color = Color3.new(d[1], d[2], d[3]),
										transparency = d[4],
									}
								end
							end
							ff:setAnimation(value[2].animation)
							ff:setAnimationSpeed(value[2].speeds)
							ff:setAnimationKeyFrames(keyFrameFix)
						elseif kind == "keybind" then
							ff:setkey(value[1])
							ff:setactivation(value[2])
						end
					end                        
				end               
			end
		end

		menu.uiopen = true

		menu.animations = {}
		menu.targetrans = Instance.new("NumberValue")
		menu.targetrans.Value = 1
		function menu:updatemenuanimations() -- thing
			for i, v in next, menu.animations do
				v:Disconnect()
			end
			table.clear(menu.animations)
			for i, v in next, (menu.openclose) do
				if v.transparency and v.transparency > 0 then
					if v.transparency == 1 then
						menu.animations[1 + #menu.animations] = menu.targetrans.Changed:Connect(function()
							v.Drawingobject.Opacity = menu.targetrans.Value
						end)
					else
						menu.animations[1 + #menu.animations] = menu.targetrans.Changed:Connect(function()
							v.Drawingobject.Opacity = v.transparency * menu.targetrans.Value
						end)
					end
				end
			end
		end

		menu.uiopen = false

		local openereses = tweenservice:Create(menu.targetrans, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {Value = 1})
		local closeereses = tweenservice:Create(menu.targetrans, TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Value = 0})

		function menu:openui()
			menu.uiopen = true
			menu.objects.backborder.position = newudim2(0, menu.objects.backborder.absoluteposition.x, 0, menu.objects.backborder.absoluteposition.y) -- ez fix
			openereses:Play()
		end

		function menu:closeui()
			menu.uiopen = false

			do
				if menu.colorpicker.updater then
					menu.colorpicker.updater:Disconnect()
				end

				menu.colorpicker.outline.visible = false
				menu.colorpicker.transparencyselection.visible = false
				menu.colorpicker.hueselection.visible = false
				menu.colorpicker.pickerselection.visible = false
				menu.isacolorpickeropen = false

				if menu.colorpicker.outofboundscloseconnection then
					menu.colorpicker.outofboundscloseconnection:Disconnect()
					menu.colorpicker.outofboundscloseconnection = nil
				end

				do
					local myflag = menu.colorpicker.animationSelection
					local this = menu.colorpicker.fakeDropdown
					this.dropdownopened = false
					this.icontext.text = (this.dropdownopened == true) and "-" or "+"
					menu.isadropdownopen = false
					for i, v in next, (this.valuecontainer) do
						v.selectionoutline.visible = this.dropdownopened
						v.selectionoutline.position = v.selectionoutline.position
						v.selectionoutline.size = v.selectionoutline.size
						if v.value and myflag.value[v.value] then
							local val = myflag.value[v.value]
							this.textrecord[v.value].color = (val == true) and menu.accent or Color3.fromRGB(255, 255, 255)
						end
					end
				end
			end

			closeereses:Play()
		end

		menu:closeui()

		return menu
	end
	uilibrary = uilib
end

-- services
local workspace			        = game:GetService("Workspace")
local soundService			    = game:GetService("SoundService")
local lighting			        = game:GetService("Lighting")
local players			        = game:GetService("Players")
local runService		        = game:GetService("RunService")
local virtualUser               = game:service("VirtualUser")
local userInputService	        = game:GetService("UserInputService")
local httpService		        = game:GetService("HttpService")
local replicatedStorage	        = game:GetService("ReplicatedStorage")
local userSettings		        = UserSettings():GetService("UserGameSettings")
local tweenService 		        = game:GetService("TweenService")
local physicsService	        = game:GetService("PhysicsService")
local proximityPromptService    = game:GetService("ProximityPromptService")
local networkClient		        = game:GetService("NetworkClient")

-- common objects
local math                      = math
local string                    = string
local table                     = table
local Rect                      = Rect
local camera			        = workspace.CurrentCamera
local viewportSize		        = camera.ViewportSize
local RemoteEvent 				= replicatedStorage.RemoteEvent
local localPlayer		        = players.LocalPlayer
local mouse				        = localPlayer:GetMouse()
local newVec3                   = Vector3.new
local emptyVec3			        = newVec3()
local vector3Zero               = Vector3.zero
local dot3d                     = vector3Zero.Dot
local xz				        = Vector3.one - Vector3.yAxis
local newVec2                   = Vector2.new
local emptyVec2			        = newVec2()
local newCframe                 = CFrame.new
local emptyCf			        = newCframe()
local pointToObjectSpace        = newCframe().PointToObjectSpace
local rayCast                   = workspace.Raycast
local next                      = next
local localPing                 = game:GetService("Stats").PerformanceStats.Ping:GetValue()
local localPingUpdate; localPingUpdate = runService.RenderStepped:Connect(function() 
	localPing = game:GetService("Stats").PerformanceStats.Ping:GetValue()
end)

-- constants
local nan				        = math.sqrt(-1)
local inf				        = 1/0
local smallestNumber	        = -1.7*10^308
local highestNumber		        = -smallestNumber
local pi				        = math.pi
local tau				        = 2*pi
local toDeg				        = 180/pi
local toRad				        = pi/180

-- third party modules
local janitor                   = nil

-- modules
local pfModules                 = {} -- cache for all of pf's modules
local playerInfo                = {} -- pinfo module, similar to bloxsense
local currentInfo               = {} -- our info, firerate, gun name etc
local hooks                     = {} -- ur idea assah
local tickbase                  = {} -- tickbase module, i wanna be able to do shit like tickbase:GetTick(), tickbase:Shift()
local networking                = {} -- easier network hooking
local heap                      = {} -- self explanatory
local pathfinding               = {} -- self explanatory
local mathematics               = {} -- mathmodule
local rayCaster                 = {} -- kinda skidded from pf but not really
local spring                    = {} -- spring module
local signal                    = {} -- signal module
local gunHandler                = {} -- handle gun stat requests & modify them

-- cheat funcs
local legit                     = {} -- legitbot
local rage                      = {} -- ragebot
local esp                       = {} -- esp
local visuals                   = {} -- visuals
local esp                       = {} -- esp
local misc                      = {} -- misc
local sharedHooks               = {} -- misc hooks needed for different cheat funcs (e.g. network hook)
local scriptLib                 = {}

-- variables relating to resolution
local gc                        = getgc(false) -- since pf updated we only need one function
local pfImport                  = nil

-- cache
local cache = {
	images = {
		grenade = "",
		exclamation = ""
	}
}

do
	coroutine.wrap(function() local a = crypt.base64.decode("iVBORw0KGgoAAAANSUhEUgAAACEAAAApCAYAAAC7t0ACAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAOGSURBVFhH7ZjPSxRhHMa32NAs+oEGBVGyhGghHhQMEgLpJxgF1aHIOgSeyjxEdQgK8lBRQYeipD8gIugghEEHoR9UaEkHlc0WraAiQ7FDWkp9npnXbWdmd2dG14jwgWef7/tj3nne77wz78xGZvEvYY7RaSORSDwaHx8vnJiYqC8rK+s01YEQ2ERPT09lXl7edsJFdo0DIxg4h7bD5yUlJaes2oAIZEKzRFbCN5zsq1XpxBI4HI1GR9E9sCIWiyXUEAS+JkwG7hLetmt8UQMfYKLZLvpjrtGMwMAQEiUDSvFRqzI7OuAJOwyGUAszHo//IuXnTTEjMLyVfjfIRoupygrfTKSCgb+Z0A+fYb0d+iOUCRA3mhWY7dLtyoLea6qyIqyJeUaDYAA22mF2hDURM+oLk40istFgqjIilAkGXYjk2yUnaFvvop4d7egZu0dmhF2Yl5Equ/QHnKiYtjWwLYUH4Cgc9MtG2MvRBr/boQcD3JIXJkn5JqzFYDc8ZvXIAN/nBLPQOtAq3wFXMeBbZvdMbZMwmSgnbBobGxua3MA49jFtX2iroNiAuYeqdyOjCQY4yQCNDBClGCf+oHqK/dI0qKFPIe1aM0XE94iVhSbKvfAdG9shdXTDY4KTL0W0G2qGTxloWHFI5HNsKcfK2E+0Ay1HN5ANz8aWbk1cgj/g/SkaELQgu9BbcAgDm9F+9Ioa3XCYIAubkDqY9tpNAdraXyjAVAFSrV1Z5VQ4TOD0CHxpijkBJ9ca+gS1wHvZlTVRBxwmOKAWahHlFIzZx+T0oNMDzIOkCXMrDkKlMNfo0w9mspsAMdzOhAFBl0OXe7lVcsF9ObpNOBP4CNPuO+6FudaEfxUOEzOMFUY9SJrQc53Lodf6nIMMa28ZMUUP3Jl4DdMunmmiGCPWJwM636pJgdtEK51KTZwraDGuJhPWUxjVk9MBt4kWOq3DSNr7eYqoYszrqL5flInF0lQ4TLAu1PEirIZpb6cw4ITFiHjNqgCapAmTcGdCRprp+IpwN5yOEa2tjbzk7DKTywiPCYGDDiN34H4YdqHKeCVZ0FfYwSB/E6Q1IWDkOKJddQtah06+QXugtJv2nRQ1gfdKO2MkXwlou4p8Qj2mAn2LmveMbQywj8HHUJ2kAF1AfRnxE7QVdqaeOBWMcZr+y+h71n15Qn0QC+avAr0CRlJfamfxnyAS+Q0Lj2qxxRaW/gAAAABJRU5ErkJggg==") cache.images.grenade = a end)()
	coroutine.wrap(function() local b = crypt.base64.decode("iVBORw0KGgoAAAANSUhEUgAAALIAAAGrCAYAAABkJM2PAAANI0lEQVR4nO3d22pc1x2A8W25xJVqrBgCuakhJXUDfYi8QG9DrtIHCaEUTAN5gt6WlBIHjENk4pDEyI6dRI6FLUeUIIuxZR3GkuXRqCNpRrM1h73LRDvIOms0o1n/w/e7yp1WzKfRWnutWTuKAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA4MCp0APohddff73vo48++tvp06ffDD2WTtVqtZn333//H4VCYSP0WNBDr7zySt/PP//8zzRNk9SGZHx8/N+vvfZaX+h/W/TQwMDAQOjyTsJ77713LvS/rST8VuvlYlp4VIQMEwgZJhAyTCBkmEDIMIGQYQIhwwRChgmEDBMIGSYQMkwgZJhAyDCBkGECIcMEQoYJhAwTCBkmEDJMIGSYQMgwgZBhAiHDBEKGCYQMEwgZJhAyTCBkmEDIMIGQYQIhwwRChgmEDBMIGSYQMkwgZJhAyDCBkGECIcMEQoYJhAwTCBkmEDJMIGSYQMgwgZBhAiHDBEKGCYQMEwgZJhAyTCBkmEDIMIGQYQIhwwRChgmEDBMIGSYQMkwgZJhAyDCBkGECIcMEQoYJhAwTCBkmEDJMIGSYQMgwgZBhAiHDBEJWqlwuJ6HHIMmp0AM4aQMDA/2VSmWp9Z+hx9JNfX19fWmapqHHIYWHT+TWJ9dy6EF02XroAUjjIeRmFEVLoQfRZSuhByCNl5ALoQfRZYtRFDGteIn5kKvVanrjxo1K6HF02XzoAUhjPuTWeqhcLldDj6Obvv766zXWeduZDzljao5cLBbj0GOQxkvIz0MPoMusTZU65iXkhdAD6LJ86AFI4yLkoaGhtdBj6LLF0AOQxkXIlUoltvS4amJiohR6DNK4CLm1PrIU8tjYGIu9HbyE/CLbqrYgYbG3GyHrU7f2OLEbXIR8/fr1cq1WszK1aERR9L/Qg5DGRcitbeo0TTdCj6MbkiRpxnHMYm8H8+eRfxXH8dSZM2f+EHocnSqVSqXz58+fDz0OaVx8Imes7O5xFnkPnkK2cmKsGHoAErkJ+bPPPlsNPYYusXa2uivchFytVq1sIlj5y9JVbkK28uz1m2++KYceg0SeQjax2CsUClb+snSVp5CtHOW0MtfvKjchX7161UoAVn4hu8pNyHEc14yctyDkPbgJOYqitezAjWqTk5NW/rJ0laeQWwdtaqEH0an79++z2NuDp5BbGwnaI2j9RTF1tUG3uAn5zp071cXFxWbocXSoynVZe3MTcqPRaB3l1P6JHGdzfezgJuSM6gPpzWZzo16vs7O3B28hq97dm5mZqbPY25u3kLVfbMJCbx+uQh4dHdX+Z9naheVd4yrkXC6n/dsV3DC0D1chG3h09Sz0AKTyFrLqT7Th4WHtU6MT4y3kmdAD6MTi4qKJKw1OgquQ7927p/0TjQND+3AV8uPHj2vZy3G04gjnPlyFnD2H1byhwBdP9+Et5LLmC05yuRxTi314C7mkeZ45OjrKYm8frkKenZ3dmJ+f13q4PrbwDZeT4irkYrGYlkolrSGvZlMj7MFVyBmtu3tlDg3tz2PIKlf+zWaz0mw2NT9xOVEeQ1Z5lPOnn36q5XI55sj7cBfy3bt3tT61UPvYsBfchTw1NaX1zzP3Ih/AXcjZs2SNuBf5AB5D1npegbPIB/AYssrF3q1bt3iGfAB3IY+MjKh8a+j8/Dzb0wdwF/L09PSG0qOcWp+29IS7kBXfn6Z1bt8THkNeV/q1epU7kr3iMeSqxquzpqammFocwF3IhUKhMTk5qW1qkd69e5fF3gHchVypVJKlpSVtUVSVLlB7xl3IGW1HOVu7etp++XrKa8jadslKfDvkYF5DVvUoK0mSVUI+mMuQv/vuO1VTi5s3b268ePHCwqvVTozLkGdnZ7Ud5VS5rd5LLkNWuNgz8UL4k+Q1ZG2LPc4iH8JryNq2e1UtTkNwGfLt27dVTS1u377NK8kO4TLkfD5f17RTls/n2Qw5hMuQs4g1fcpxYOgQXkNuKFtAaZvT9xwh68Bi7xAuQ67X68mzZ8/U/Lmenp5WtTgNwWXI1Wo1ffjwoZbdveSHH37gnMUhXIbckqaplk/k1vZ0GnoQ0rkNWdECaoGQD0fI8i0R8uHchjw9Pa3iDrg0TZcJ+XBuQx4ZGVHxBdQrV66s1+t1Qj6E25CznT0NgXAv8hF4DlnLJgNnkY/Ac8jPlXwiL4YegAZuQ3769GkpTVPxIadp+jz0GDRwG/K9e/dqSZKI/0Ln5cuXNZ3SC8ZtyBnpkaTKXwLfM95Dln57fcLbTo/Ge8jSn1w0lR03DcZ1yE+ePJF+vWzr3PSL0IPQwHXIP/74o+j5ZxzHyejoKFOLI3AdsvTFXqPRaCwsLDRCj0MD7yFLX+zxaXxE3kOWPv+UvhgVw3XIuVxO+mKP7ekjch3y6Oio6KOcMzMzGt8+FYTrkLMjkmJvHPr+++9F/6JJ4j3kReHv5hD9VEUS7yEvC3+lQTH0ALRwHfLc3NxatVqV/JyW7ekjch3yxMRErfXevdDjOABnkY/IdcgZsfPQTz75RMslMsERchTNhR7APpppmkqev4tCyHLnoY3s1b04AvchP3r0SOqTgdbJPOk7j2K4D/nBgwdSj3JWCfno3Ics9bUGxWKx8ejRIy5nOSJCFvrOvUqlUi8UCmK3z6UhZLknzMQ+FpTIfcgTExNSF3tarr0VwX3IY2NjUhd7Uv9SiOQ+5OwxVy30IHbK5/Mq7m+WgpCjqJS9p0OUO3fusBnSBkLe/IKnxGhY7LXBfci1Wq3caDQkzpOlfzFWFPchj4+P16empiSeSeaC7za4DzkjcXePT+Q2EPImcfdHfPrppxJ/ucQi5E3Sntk2ms2mxOmOWIS8ea5B2nw05oLv9hByFEWff/65tMdvZYnPtiUj5E3SntmuChyTaIS8SdQBnbm5uVo+n+f7em0g5E2i5sjLy8u1UqnEWeQ2EHJrQlouS3tmy7SiTYQcRdG1a9ekLfZETXU0IORNdWGXGUp7ri0eIW9qfclzJfQgfjU/P89Z5DYR8qaqpJBv3brFt6fbRMibRznjOI4lvXhG0lhUIOQoimZnZxvj4+OS5shSr/ESi5C3SNoSJuQ2EfIWSUc5JY1FBULeIuZT8MqVK5L+OqhAyJmVlRUpIdfq9Trb020i5MwXX3wh5UlBWfgLekQi5C1S/pyvSLwwRjpC3iLlxTMFofdsiEbIW0Scb5icnIw5wtk+Qs6USiURi72FhYXWK9PS0OPQhpAz169fl7LY4yzyMRDylkTI3FTkDfrSEfKWhpCXz4iYq2tDyFvqEl5i/vz5c84iHwMhZ5rNZn11dXU59DiGh4clTG/UIeTMyspKMjIyIiEiKRszqhDydhIiYo58DIS8nYRrAUQ8z9aGkLeTsE3NJ/IxEPJLisVi8IiuXr0qYXqjDiG/5Kuvvgod0UYcx0ngMahEyNuFDrl1hJNzFsdAyNuFvsywmG2Vo02EvF3oOXI+2ypHmwh5u6DfXh4fH1+v1+tMLY6BkF9y7dq1oEc5nzx5Ums0+EA+DkJ+ydraL0eBQy74pJyJVoeQdwu54MsH/NmqEfJ2aeAFHzcMHRMh7xZsm7pQKHAW+ZgI+SVpmkZDQ0PB5sg3btyQdCOoKoS8Q6VSCbXgSgXsLKpFyLuF+t5eIuQYqUqEvFuoOXIi4TuDWhHybqFeDZYIOOsBK955552/pAHEcVzt7+8P/b+vFp/IO6yvr8chTqClaVqtViV891UnQt6t9Sw3xCWCwa8i0IyQd1sKdNE2XzrtACHvVgh0JphzFh0g5B2Gh4fXW5e19Prnjo2NcQtnBwh5h42NjV8WXr3+uRMTE7xuoQOEvLcQCy/OIneAkPcWYndvLsDPNOM3oQcg0cLCwrevvvrqb3v8M//by59nzanQA5Do7Nmzff39/T39tymVSglfPAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOOHqfuS33nrr4uXLly8NDg5qfMVofOnSpb9//PHHk6EHgoAuXLjw+6dPn+ZCvJ63W+I4fvzuu+9eCP1vKZGbd4hcvHjxT2+88cYfQ4+jE2fOnHnz7bff/nPocUjkJmTYRsgwgZBhAiHDBEKGCYQMEwgZJhAyTCBkmEDIMIGQYQIhwwRChgmEDBMIGSYQMkwgZJhAyDCBkGECIcMEQoYJhAwTCBkmEDJMIGSYQMgwgZBhAiHDBEKGCYQMEwgZJhAyTCBkmEDIMIGQYQIhwwRChgmEDBMIGSYQMkwgZJhAyDCBkGECIcMETyE3oyhKQw+iU2tra0noMSCgc+fO9Q8PD/8nTdMkVerLL78cOnv27O9C/1tKdCr0AHqpFfOHH37418HBwcHQY2nX8vLy+gcffPCvSqWyHnosAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQCD/BxTbdEHAKPlOAAAAAElFTkSuQmCC") cache.images.exclamation = b end)()
end

do
	networkClient:SetOutgoingKBPSLimit(0)
	for i, v in next, getconnections(localPlayer.Idled) do 
		v:Disable()
	end
end

local skyBoxes = {
	["purple clouds"] = {
		SkyboxLf = "rbxassetid://151165191",
		SkyboxBk = "rbxassetid://151165214",
		SkyboxDn = "rbxassetid://151165197",
		SkyboxFt = "rbxassetid://151165224",
		SkyboxRt = "rbxassetid://151165206",
		SkyboxUp = "rbxassetid://151165227",
	},
	["cloudy skies"] = {
		SkyboxLf = "rbxassetid://151165191",
		SkyboxBk = "rbxassetid://151165214",
		SkyboxDn = "rbxassetid://151165197",
		SkyboxFt = "rbxassetid://151165224",
		SkyboxRt = "rbxassetid://151165206",
		SkyboxUp = "rbxassetid://151165227",
	},
	["purple nebula"] = {
		SkyboxLf = "rbxassetid://159454286",
		SkyboxBk = "rbxassetid://159454299",
		SkyboxDn = "rbxassetid://159454296",
		SkyboxFt = "rbxassetid://159454293",
		SkyboxRt = "rbxassetid://159454300",
		SkyboxUp = "rbxassetid://159454288",
	},
	["purple and blue"] = {
		SkyboxLf = "rbxassetid://149397684",
		SkyboxBk = "rbxassetid://149397692",
		SkyboxDn = "rbxassetid://149397686",
		SkyboxFt = "rbxassetid://149397697",
		SkyboxRt = "rbxassetid://149397688",
		SkyboxUp = "rbxassetid://149397702",
	},
	["vivid Skies"] = {
		SkyboxLf = "rbxassetid://271042310",
		SkyboxBk = "rbxassetid://271042516",
		SkyboxDn = "rbxassetid://271077243",
		SkyboxFt = "rbxassetid://271042556",
		SkyboxRt = "rbxassetid://271042467",
		SkyboxUp = "rbxassetid://271077958",
	},
	["twighlight"] = {
		SkyboxLf = "rbxassetid://264909758",
		SkyboxBk = "rbxassetid://264908339",
		SkyboxDn = "rbxassetid://264907909",
		SkyboxFt = "rbxassetid://264909420",
		SkyboxRt = "rbxassetid://264908886",
		SkyboxUp = "rbxassetid://264907379",
	},
	["vaporwave"] = {
		SkyboxLf = "rbxassetid://1417494402",
		SkyboxBk = "rbxassetid://1417494030",
		SkyboxDn = "rbxassetid://1417494146",
		SkyboxFt = "rbxassetid://1417494253",
		SkyboxLf = "rbxassetid://1417494402",
		SkyboxRt = "rbxassetid://1417494499",
		SkyboxUp = "rbxassetid://1417494643",
	},
	["clouds"] = {
		SkyboxLf = "rbxassetid://570557620",
		SkyboxBk = "rbxassetid://570557514",
		SkyboxDn = "rbxassetid://570557775",
		SkyboxFt = "rbxassetid://570557559",
		SkyboxLf = "rbxassetid://570557620",
		SkyboxRt = "rbxassetid://570557672",
		SkyboxUp = "rbxassetid://570557727",
	},
	["night sky"] = {
		SkyboxBk = "rbxassetid://12064107",
		SkyboxDn = "rbxassetid://12064152",
		SkyboxFt = "rbxassetid://12064121",
		SkyboxLf = "rbxassetid://12063984",
		SkyboxRt = "rbxassetid://12064115",
		SkyboxUp = "rbxassetid://12064131"
	},
	["setting sun"] = {
		SkyboxBk = "rbxassetid://626460377",
		SkyboxDn = "rbxassetid://626460216",
		SkyboxFt = "rbxassetid://626460513",
		SkyboxLf = "rbxassetid://626473032",
		SkyboxRt = "rbxassetid://626458639",
		SkyboxUp = "rbxassetid://626460625"
	},
	["fade blue"] = {
		SkyboxBk = "rbxassetid://153695414",
		SkyboxDn = "rbxassetid://153695352",
		SkyboxFt = "rbxassetid://153695452",
		SkyboxLf = "rbxassetid://153695320",
		SkyboxRt = "rbxassetid://153695383",
		SkyboxUp = "rbxassetid://153695471"
	},
	["elegant morning"] = {
		SkyboxBk = "rbxassetid://153767241",
		SkyboxDn = "rbxassetid://153767216",
		SkyboxFt = "rbxassetid://153767266",
		SkyboxLf = "rbxassetid://153767200",
		SkyboxRt = "rbxassetid://153767231",
		SkyboxUp = "rbxassetid://153767288"
	},
	["neptune"] = {
		SkyboxBk = "rbxassetid://218955819",
		SkyboxDn = "rbxassetid://218953419",
		SkyboxFt = "rbxassetid://218954524",
		SkyboxLf = "rbxassetid://218958493",
		SkyboxRt = "rbxassetid://218957134",
		SkyboxUp = "rbxassetid://218950090"
	},
	["redshift"] = {
		SkyboxBk = "rbxassetid://401664839",
		SkyboxDn = "rbxassetid://401664862",
		SkyboxFt = "rbxassetid://401664960",
		SkyboxLf = "rbxassetid://401664881",
		SkyboxRt = "rbxassetid://401664901",
		SkyboxUp = "rbxassetid://401664936"
	},
	["aesthetic night"] = {
		SkyboxBk = "rbxassetid://1045964490",
		SkyboxDn = "rbxassetid://1045964368",
		SkyboxFt = "rbxassetid://1045964655",
		SkyboxLf = "rbxassetid://1045964655",
		SkyboxRt = "rbxassetid://1045964655",
		SkyboxUp = "rbxassetid://1045962969"
	}
}
local skyboxDropDown = {}
for i, v in next, (skyBoxes) do
	local okay = {i, i == "purple clouds" and true or false}
	skyboxDropDown[1 + #skyboxDropDown] = okay
end

local forcefieldanimations = {
    ["off"] = "rbxassetid://0",
    ["web"] = "rbxassetid://301464986",
    ["webbed"] = "rbxassetid://2179243880",
    ["scanning"] = "rbxassetid://5843010904",
	["pixelated"] = "rbxassetid://140652787",
    ["swirl"] = "rbxassetid://8133639623",
    ["checkerboard"] = "rbxassetid://5790215150",
    ["christmas"] = "rbxassetid://6853532738",
    ["player"] = "rbxassetid://4494641460",
    ["shield"] = "rbxassetid://361073795",
    ["dots"] = "rbxassetid://5830615971",
    ["bubbles"] = "rbxassetid://1461576423",
    ["matrix"] = "rbxassetid://10713189068",
    ["honeycomb"] = "rbxassetid://179898251",
    ["groove"] = "rbxassetid://10785404176",
    ["cloud"] = "rbxassetid://5176277457",
    ["sky"] = "rbxassetid://1494603972",
    ["smudge"] = "rbxassetid://6096634060",
    ["scrapes"] = "rbxassetid://6248583558",
    ["galaxy"] = "rbxassetid://1120738433",
    ["galaxies"] = "rbxassetid://5101923607",
    ["stars"] = "rbxassetid://598201818",
    ["rainbow"] = "rbxassetid://10037165803",
    ["wires"] = "rbxassetid://14127933",
    ["camo"] = "rbxassetid://3280937154",
    ["hexagon"] = "rbxassetid://6175083785",
    ["particles"] = "rbxassetid://1133822388",
    ["triangular"] = "rbxassetid://4504368932",
    ["wall"] = "rbxassetid://4271279"
}

local forcefieldAnimationsDropDown = {}
for i, v in next, (forcefieldanimations) do
	local okay = {i, i == "off" and true or false}
	forcefieldAnimationsDropDown[1 + #forcefieldAnimationsDropDown] = okay
end

local rawHitSounds = {
    ["AR2 Head"] = "2062016772",
    ["AR2 Body"] = "2062015952",
    ["AR2 Limb"] = "6659353525",
    ["BB HitM"] = "4645745735",
    ["BB Kill"] = "2636743632",
    ["PD Head"] = "4585351098",
    ["PD Body"] = "4585364605",
    ["Neverlose"] = "8726881116",
    ["Gamesense"] = "4817809188",
    ["Baimware"] = "3124331820",
    ["Steve"] = "4965083997",
    ["Skeet"] = "4753603610",
    ["Body"] = "3213738472",
    ["Ding"] = "7149516994",
    ["Mario"] = "2815207981",
    ["Mario 2"] = "5709456554",
    ["Minecraft"] = "6361963422",
    ["Among Us"] = "5700183626",
    ["Button"] = "12221967",
    ["Oof"] = "4792539171",
    ["Osu"] = "7149919358",
    ["Osu Combobreak"] = "3547118594",
    ["Bambi"] = "8437203821",
    ["Click"] = "8053704437",
    ["Snow"] = "6455527632",
    ["Stone"] = "3581383408",
    ["Rust"] = "1255040462",
    ["Splat"] = "12222152",
    ["Bell"] = "6534947240",
    ["Slime"] = "6916371803",
    ["Saber"] = "8415678813",
    ["Bat"] = "3333907347",
    ["Bubble"] = "6534947588",
    ["Pick"] = "1347140027",
    ["Pop"] = "198598793",
    ["EmptyGun"] = "203691822",
    ["Bamboo"] = "3769434519",
    ["Stomp"] = "200632875",
    ["Bag"]  = "364942410",
    ["HitMarker"] = "8543972310",
    ["LaserSlash"] = "199145497",
    ["RailGunF"] = "199145534",
    ["Bruh"] = "4275842574", 
    ["Crit"] = "296102734",
    ["Bonk"] = "3765689841",
    ["Clink"] = "711751971",
    ["CoD"] = "160432334",
    ["Lazer Beam"] = "130791043",
    ["Windows XP Error"] = "160715357",
    ["Windows XP Ding"] = "489390072",
    ["HL Med Kit"] = "4720445506",
    ["HL Door"] = "4996094887",
    ["HL Crowbar"] = "546410481",
    ["HL Revolver"] = "1678424590",
    ["HL Elevator"] = "237877850",
    ["TF2 HitSound"] = "3455144981",
    ["TF2 Squasher"] = "3466981613",
    ["TF2 Retro"] = "3466984142",
    ["TF2 Space"] = "3466982899",
    ["TF2 Vortex"] = "3466980212",
    ["TF2 Beepo"] = "3466987025",
    ["TF2 Bat"] = "3333907347",
    ["TF2 Pow"] = "679798995",
    ["TF2 You Suck"] = "1058417264",
    ["Quake Hitsound"] = "4868633804",
    ["Fart"] = "131314452",
    ["Fart2"] = "6367774932",
    ["FortniteGuns"] = "3008769599",
    ["Crickets"] = "2101148",
    ["ScreamingKid"] = "5980352978",
    ["BitchBot"] = "5709456554",
    ["BitchBot Head"] = "5043539486",
    ["BitchBot Body"] = "3744371342",
    ["Minecraft Experience "] = "1053296915",
    ["BameWare"] = "7898991882",
    ["Fatality"] = "7347423703",
    ["Fatality MKX"] = "6721975770",
    ["Fatality Original"] = "158012252",
    ["Doublekill 1"] = "1950547222",
    ["Doublekill 2"] = "130819307",
    ["Killing Spree 1"] = "723054723",
    ["Killing Spree 2"] = "937898383",
    ["Sit Dog"] = "7349055654",
    ["Csgo"] = "7269900245",
    ["Bop"] = "8829676038",
    ["Grenade Hit"] = "5684745272",
    ["KillTrocity"] = "6818544945",
    ["Double Kill"] = "6818527307",
    ["Triple kill"] = "6818526855",
    ["Over Kill"] = "6818526995",
    ["Kill Tacular"] = "6818527070",
    ["Kill Imanjaro"] = "6818527258",
    ["Kill Tastrophe"] = "6818526916",
    ["Kill Pocalypse"] = "6818527144",
    ["Kill Ionaire"] = "6818527200",
    ["Killing Spree"] = "6822465178",
    ["Killing Frenzy"] = "6822465319",
    ["Carrier Kill"] = "7139067012",
    ["Clutch Kill"] = "7379106527",
    ["Taco Bell"] = "5689199277",
    ["Kombat"] = "8527433497",
    ["Headshot"] = "8418469749",
    ["Elevator"] = "8322227967"
}

local cheatHitSounds = {}
for i, v in next, rawHitSounds do
	cheatHitSounds[string.lower(i)] = v
end

local cheatHitSoundsDropDown = {{"custom", true}}
for i, v in next, cheatHitSounds do
	cheatHitSoundsDropDown[1 + #cheatHitSoundsDropDown] = {i, false}
end

-- main ui setup
local ui
local uiflags
-- filesystem setup
local cheat_path                        = "vader haxx"
local game_path                         = "phantom forces"
local config_path                       = "configurations"
local scripts_path                      = "scripts"

do
	local workspace                     = game:GetService("Workspace")
	local camera			            = workspace.CurrentCamera
	local stats                         = game:GetService("Stats")
	local runservice                    = game:GetService("RunService")
	local players                       = game:GetService("Players")
	local localplayer                   = players.LocalPlayer
	local mouse                         = localplayer:GetMouse()
	local httpservice                   = game:GetService("HttpService")

	-- initiate ui
	do
		ui = uilibrary:start({
			size = Vector2.new(560, 740),
			name = "vader haxx",
			accent = Color3.fromRGB(255, 200, 69),
			colors = {
				a = Color3.fromRGB(0, 0, 0),
				b = Color3.fromRGB(56, 56, 56),
				c = Color3.fromRGB(46, 46, 46),
				d = Color3.fromRGB(12, 12, 12),
				e = Color3.fromRGB(21, 21, 21),
				f = Color3.fromRGB(84, 84, 84),
				g = Color3.fromRGB(54, 54, 54),
			},
			tabs = {
				"legit",
				"rage",
				"esp",
				"visuals",
				"misc",
				"players",
				"config",
			}
		})
		ui:createnotification({text = "initializing...", lifetime = 3, priority = 0})
	end

	do
		if not isfolder(cheat_path) then
			makefolder(cheat_path)
		end

		if not isfolder(cheat_path .. "/" .. game_path) then
			makefolder(cheat_path .. "/" .. game_path)
		end

		if not isfolder(cheat_path .. "/" .. game_path .. "/" .. config_path) then
			makefolder(cheat_path .. "/" .. game_path .. "/" .. config_path)
		end

		if not isfolder(cheat_path .. "/" .. game_path .. "/" .. scripts_path) then
			makefolder(cheat_path .. "/" .. game_path .. "/" .. scripts_path)
		end

		if not isfile(cheat_path .. "/" .. game_path .. "/" .. "custom chat spammer messages.txt") then
			writefile(cheat_path .. "/" .. game_path .. "/" .. "custom chat spammer messages.txt", "hey user, edit your custom messages or dont use it at all\ndear user, set up your custom messages or dont use it")
		end

		if not isfile(cheat_path .. "/" .. game_path .. "/" .. "custom kill messages.txt") then
			writefile(cheat_path .. "/" .. game_path .. "/" .. "custom kill messages.txt", "hey user, edit your custom kill messages or dont use it at all\ndear user, set up your custom kill messages or dont use it")
		end

		if not isfile(cheat_path .. "/" .. game_path .. "/" .. "relations.json") then
			writefile(cheat_path .. "/" .. game_path .. "/" .. "relations.json", json.encode({}))
		end

		function ui.getconfigs()
			local Configs = {}
			local CfgFolder = cheat_path .. "/" .. game_path .. "/" .. config_path
			for i, v in next, (listfiles(CfgFolder)) do
				Configs[1 + #Configs] = {string.sub(v, #CfgFolder + 2, 256):sub(0, -5), (#Configs == 0) and true or false}
			end
			return Configs
		end
	end
	
	-- sub panel setup
	do
		ui:createsubsection({tab = "legit", name = "aim assist", length = 1, side = 1})
		ui:createsubsection({tab = "legit", name = "trigger bot", length = 0.5, side = 2})
		ui:createsubsection({tab = "legit", name = "bullet redirection", length = 0.5, side = 2}) 
		
		ui:createsubsection({tab = "rage", name = "aimbot", length = 0.315, side = 1})
		ui:createsubsection({tab = "rage", name = "hack vs. hack", length = 0.685, side = 1})
		ui:createsubsection({tab = "rage", name = "anti aimbot", length = 0.64, side = 2})
		ui:createsubsection({tab = "rage", name = "misc", length = 0.36, side = 2})

		ui:createsubsection({tab = "esp", name = "enemy", length = 0.7, side = 1})
		ui:createsubsection({tab = "esp", name = "dropped", length = 0.3, side = 1})
		ui:createsubsection({tab = "esp", name = "team", length = 0.45, side = 2})
		ui:createsubsection({tab = "esp", name = "esp settings", length = 0.55, side = 2})

		ui:createsubsection({tab = "visuals", name = "local", length = 0.6, side = 1})
		ui:createsubsection({tab = "visuals", name = "viewmodel", length = 0.4, side = 1})
		ui:createsubsection({tab = "visuals", name = "camera", length = 0.43, side = 2})
		ui:createsubsection({tab = "visuals", name = "world", length = 0.57, side = 2})

		ui:createsubsection({tab = "misc", name = "movement", length = 0.6, side = 1})
		ui:createsubsection({tab = "misc", name = "weapon modifications", length = 0.4, side = 1})
		ui:createsubsection({tab = "misc", name = "extra", length = 1, side = 2})

		ui:createsubsection({tab = "config", name = "other", length = 0.26, side = 1})
		ui:createsubsection({tab = "config", name = "ui", length = 0.48, side = 1})
		ui:createsubsection({tab = "config", name = "extra", length = 0.26, side = 1})
		ui:createsubsection({tab = "config", name = "scripts", length = 1, side = 2})
	end

	-- feature set up
	do
		-- legit features
		do
			ui:createtoggle({tab = "legit", subsection = "aim assist", name = "enabled", flag = "legit_aimassist", value = false, tooltip = "master switch for aim assist, helps with aiming by moving your mouse for you based on the below settings"})
			ui:createslider({tab = "legit", subsection = "aim assist", name = "fov", suffix = "°", flag = "legit_aimassistfov", value = 20, minimum = 0, maximum = 90, tooltip = "the maximum fov of the aim assist, enemies within this fov will be considered to be aimed at by the aim assist"})
			ui:createslider({tab = "legit", subsection = "aim assist", name = "speed", suffix = "%", flag = "legit_aimassistsmoothing", value = 50, minimum = 1, maximum = 100, custom = {["100"] = "inst."}, tooltip = "how fast the assist will help aim at the target"})
			ui:createdropdown({tab = "legit", subsection = "aim assist", name = "smoothing", flag = "legit_aimassistsmoothingtype", values = {{"linear", true}, {"exponential", false}}, multichoice = false, tooltip = "the type of smoothing of the aim aim assist"})
			ui:createslider({tab = "legit", subsection = "aim assist", name = "randomisation", flag = "legit_aimassistrandomisation", value = 5, minimum = 0, maximum = 20, custom = {["0"] = "off"}, tooltip = "the randomisation of where the aim assist will be trying to aim at"})
			--ui:createslider({tab = "legit", subsection = "aim assist", name = "deadzone fov", suffix = "/10°", flag = "legit_aimassistdeadzonefov", value = 1, minimum = 0, maximum = 50, custom = {["0"] = "off"}, tooltip = "the deadzone of the aim assist"})
			ui:createslider({tab = "legit", subsection = "aim assist", name = "enemy switching delay", suffix = "ms", flag = "legit_aimassistswitchdelay", value = 100, minimum = 0, maximum = 2000, custom = {["0"] = "off"}, tooltip = "how long the aim assist will wait before locking onto a new player"})
			ui:createslider({tab = "legit", subsection = "aim assist", name = "maximum lock-on time", suffix = "ms", flag = "legit_aimassistlockontime", value = 1000, minimum = 1, maximum = 2001, custom = {["2001"] = "inf"}, tooltip = "how long the aim assist will aim at a single target"})
			ui:createslider({tab = "legit", subsection = "aim assist", name = "accuracy", suffix = "%", flag = "legit_aimassistaccuracy", value = 90, minimum = 0, maximum = 100, tooltip = "the chance that the hitscan priority will be considered before anything else"})
			ui:createdropdown({tab = "legit", subsection = "aim assist", name = "activation", flag = "legit_aimassistactivation", values = {{"mouse 1", true}, {"mouse 2", false}, {"always", false}}, multichoice = false, tooltip = "the aim assist will be actively aiming whilst this action is performed"})
			ui:createdropdown({tab = "legit", subsection = "aim assist", name = "target priority", flag = "legit_aimassisttargpriority", values = {{"closest", true}, {"enemy look direction", false}}, multichoice = false, tooltip = "the player that the aim assist will consider aiming at first"})
			ui:createdropdown({tab = "legit", subsection = "aim assist", name = "hitscan priority", flag = "legit_aimassistpriority", values = {{"closest", true}, {"head", false}, {"body", false}}, multichoice = false, tooltip = "the hitbox that the aim assist will consider aiming at first"})
			ui:createdropdown({tab = "legit", subsection = "aim assist", name = "hitscan points", flag = "legit_aimassistpoints", values = {{"head", true}, {"body", true}, {"arms", false}, {"legs", false}}, multichoice = true, tooltip = "the hitboxes that the aim assist will consider at all"})
			ui:createtoggle({tab = "legit", subsection = "aim assist", name = "require mouse movement", flag = "legit_aimonmousemove", value = false, tooltip = "requires you to be moving your mouse for the aim assist to assist your aim"})
			ui:createtoggle({tab = "legit", subsection = "aim assist", name = "require mouse nearing enemy", flag = "legit_aimonmousemoveatenemy", value = false, tooltip = "requires you to be moving your mouse towards the enemy for the aim assist to assist your aim"})
			ui:createtoggle({tab = "legit", subsection = "aim assist", name = "use barrel fov", flag = "legit_aimassistbarrelfov", value = false, tooltip = "bases fov from your barrel direction instead of camera direction"})
			ui:createtoggle({tab = "legit", subsection = "aim assist", name = "adjust for bullet drop", flag = "legit_bulletcompensation", value = false, tooltip = "will predict the bullet drop to a target once found and will compensate for it"})
			ui:createslider({tab = "legit", subsection = "aim assist", name = "drop prediction inaccuracy", suffix = "%", flag = "legit_bulletdropaccuracy", value = 90, minimum = 0, maximum = 100, tooltip = "how accurate the bullet drop adjustment is"})
			ui:createtoggle({tab = "legit", subsection = "aim assist", name = "adjust for target movement", flag = "legit_movementcompensation", value = false, tooltip = "will predict the movement of the target and will compensate for it"})
			ui:createslider({tab = "legit", subsection = "aim assist", name = "target prediction inaccuracy", suffix = "%", flag = "legit_movementtaccuracy", value = 80, minimum = 0, maximum = 100, tooltip = "how accurate the movement prediction adjustment is"})
			ui:createtoggle({tab = "legit", subsection = "aim assist", name = "adjust for barrel angle", flag = "legit_barrelcompensation", value = false, tooltip = "will predict where the bullet will be based off of your barrel and will assist you in pointing your barrel towards the enemy, helps with quickscoping and recoil control"})
			ui:createslider({tab = "legit", subsection = "aim assist", name = "barrel adjustment inaccuracy", suffix = "%", flag = "legit_barrelaccuracy", value = 60, minimum = 0, maximum = 100, tooltip = "how accurate the barrel angle adjustment is"})

			ui:createtoggle({tab = "legit", subsection = "bullet redirection", name = "silent aim", flag = "legit_bulletredirection", value = false, tooltip = "master switch for silent aim, helps with aiming by automatically redirecting bullets based on the below settings"})
			ui:createslider({tab = "legit", subsection = "bullet redirection", name = "silent aim fov", suffix = "°", flag = "legit_bulletredirectionfov", value = 15, minimum = 0, maximum = 90, tooltip = "the maximum fov of the silent aim, enemies within this fov will be considered and aimed at by the silent aim"})
			ui:createslider({tab = "legit", subsection = "bullet redirection", name = "spread", suffix = "/10st", flag = "legit_bulletredirectiondeviation", value = 8, minimum = 0, maximum = 80, custom = {["0"] = "off"}, tooltip = "shoots around your enemy rather than the direct center of the hitbox to prevent shooting in a perfect line every time which can look blatant. the slider will determine (in studs) how much spread there will be at exactly 100 studs, scales linearly with distance. at 200 studs the amount of spread doubles and at 50 studs the amount is halved"})
			ui:createslider({tab = "legit", subsection = "bullet redirection", name = "hit chance", suffix = "%", flag = "legit_bulletredirectionhitchance", value = 30, minimum = 0, maximum = 100, tooltip = "the chance that the silent aim will attempt to redirect a bullet"})
			ui:createslider({tab = "legit", subsection = "bullet redirection", name = "accuracy", suffix = "%", flag = "legit_bulletredirectionaccuracy", value = 70, minimum = 0, maximum = 100, tooltip = "the chance that the hitscan priority will be considered before anything else"})
			ui:createdropdown({tab = "legit", subsection = "bullet redirection", name = "hitscan priority", flag = "legit_bulletredirectionpriority", values = {{"closest", false}, {"head", false}, {"body", false}}, multichoice = false, tooltip = "the hitbox that the silent aim will consider aiming at first"})
			ui:createdropdown({tab = "legit", subsection = "bullet redirection", name = "hitscan points", flag = "legit_bulletredirectionpoints", values = {{"head", false}, {"body", false}, {"arms", false}, {"legs", false}}, multichoice = true, tooltip = "the hitboxes that the silent aim will consider at all "})
			ui:createtoggle({tab = "legit", subsection = "bullet redirection", name = "use barrel fov", flag = "legit_silentbarrelfov", value = false, tooltip = "bases fov from your barrel instead of camera"})
			ui:createtoggle({tab = "legit", subsection = "bullet redirection", name = "auto wallbang", flag = "legit_bulletredirectionwallbang", value = false, tooltip = "will target enemies that can be wallbanged"})
			--ui:createtoggle({tab = "legit", subsection = "bullet redirection", name = "instant hit", flag = "legit_silentinstanthit", value = false, tooltip = "instantly hits your shots. not garunteed to be undetected"})

			ui:createtoggle({tab = "legit", subsection = "trigger bot", name = "enabled", flag = "legit_triggerbot", value = false, tooltip = "master switch for trigger bot, helps with shooting by automatically clicking when an enemy intersects your bullet path"})
			ui:createkeybind({tab = "legit", subsection = "trigger bot", object = "enabled", name = "trigger bot key", flag = "legit_triggerbotkey", parentflag = "legit_triggerbot", value = Enum.KeyCode.M})
			ui:createslider({tab = "legit", subsection = "trigger bot", name = "reaction time", suffix = "ms", flag = "legit_triggerbotspeed", value = 120, minimum = 0, maximum = 400, custom = {["0"] = "off"}, tooltip = "how long an enemy must intersect your bullet path before automatically clicking"})
			ui:createdropdown({tab = "legit", subsection = "trigger bot", name = "triggerbot hitboxes", flag = "legit_triggerbotpoints", values = {{"head", true}, {"body", true}, {"arms", false}, {"legs", false}}, multichoice = true, tooltip = "the hitboxes that the triggerbot will automatically click on"})
			ui:createtoggle({tab = "legit", subsection = "trigger bot", name = "auto wallbang", flag = "legit_triggerbotautowall", value = false, tooltip = "will automatically click when someone can be wallbanged by your bullet path"})
			ui:createtoggle({tab = "legit", subsection = "trigger bot", name = "magnet triggerbot", flag = "legit_magnet", value = false, tooltip = "master switch for the magnet, helps with aiming by applying a custom fov, smoothing and hitscan priority to the aim assist on triggerbot keybind"})
			ui:createslider({tab = "legit", subsection = "trigger bot", name = "magnet fov", suffix = "°", flag = "legit_magnetfov", value = 80, minimum = 0, maximum = 180, tooltip = "the maximum fov of the aim assist when the magnet triggerbot is active"})
			ui:createslider({tab = "legit", subsection = "trigger bot", name = "magnet speed", suffix = "%", flag = "legit_magnetsmoothing", value = 10, minimum = 0, maximum = 100, tooltip = "the smoothness of the aim assist when the magnet triggerbot is active"})
			ui:createdropdown({tab = "legit", subsection = "trigger bot", name = "magnet priority", flag = "legit_magnetnpriority", values = {{"closest", true}, {"head", false}, {"body", false}}, multichoice = false, tooltip = "the hitscan priority of the aim assist when the magnet triggerbot is active"})
		end

		-- rage features
		do
			ui:createtoggle({tab = "rage", subsection = "aimbot", name = "enabled", flag = "rage_enabled", value = false, tooltip = "master switch for the aimbot, helps with aiming by instantly aiming at an enemy once they are available to be aimed at and hit"})
			ui:createkeybind({tab = "rage", subsection = "aimbot", object = "enabled", name = "enabled key", flag = "rage_enabledkey", parentflag = "rage_enabled", value = Enum.KeyCode.E})
			ui:createtoggle({tab = "rage", subsection = "aimbot", name = "silent aim", flag = "rage_silentaim", value = false, tooltip = "the aimbot will not be locally visible"})
			ui:createtoggle({tab = "rage", subsection = "aimbot", name = "rotate viewmodel", flag = "rage_rotateviewmodel", value = false, tooltip = "rotates the viewmodel to point towards where the aimbot is aiming at"})
			ui:createslider({tab = "rage", subsection = "aimbot", name = "aimbot fov", suffix = "°", flag = "rage_aimbotfov", value = 90, minimum = 1, maximum = 181, custom = {["181"] = "ign."}, tooltip = "the maximum fov of the aimbot, all enemies within this fov will be considered"})
			ui:createslider({tab = "rage", subsection = "aimbot", name = "autowall fps", flag = "rage_autowallfps", value = 30, minimum = 0, maximum = 30, tooltip = "determines the accuracy of the autowall. lower values can increase performance but can decrease quality"})
			ui:createtoggle({tab = "rage", subsection = "aimbot", name = "auto shoot", flag = "rage_autofire", value = false, tooltip = "the aimbot will automatically shoot for you once it starts aiming"})
			ui:createtoggle({tab = "rage", subsection = "aimbot", name = "auto wall", flag = "rage_autowall", value = false, tooltip = "the aimbot will consider enemies that can be wallbanged"})
			ui:createdropdown({tab = "rage", subsection = "aimbot", name = "hitscan priority", flag = "rage_hitscanpriority", values = {{"head", true}, {"torso", false}}, multichoice = false, tooltip = "the hitbox that the aimbot will shoot at"})

			ui:createtoggle({tab = "rage", subsection = "misc", name = "damage prediction", flag = "rage_damagepred", value = false, tooltip = "the aimbot will ignore a player after attempting to deal fatal damage until after it is confirmed that attempting to deal fatal damage has failed to kill them, useful for conserving ammo"})
			-- rage_firepositionscanning
			-- rage_firepositionscanningradius
			ui:createtoggle({tab = "rage", subsection = "misc", name = "tp scanning", flag = "rage_firepositionscanning", value = false, tooltip = "the aimbot will scan for the best position to shoot the enemy from, teleport you there, shoot, and then teleport you back to your original position", detected = true})
			ui:createslider({tab = "rage", subsection = "misc", name = "tp scanning radius", suffix = "st", flag = "rage_firepositionscanningradius", value = 25, minimum = 1, maximum = 50, tooltip = "how close an enemy must be to you for the tp scanning to activate"})	
			ui:createtoggle({tab = "rage", subsection = "misc", name = "knife bot", flag = "rage_knifebot", value = false, tooltip = "the aimbot will aim with the knife, requires the aimbot to be enabled and its keybind to be active, reuses the aimbot fov"})
			ui:createkeybind({tab = "rage", subsection = "misc", object = "knife bot", name = "knife key", flag = "rage_knifekey", parentflag = "rage_knifebot", value = Enum.KeyCode.F})
			ui:createtoggle({tab = "rage", subsection = "misc", name = "disregard walls on knife", flag = "rage_knifebotignorewalls", value = false, tooltip = "the aimbot will aim with the knife even if an enemy is behind a wall"})
			ui:createdropdown({tab = "rage", subsection = "misc", name = "knife bot type", flag = "rage_knifebottype", values = {{"aura", true}, {"infinite aura", false}}, multichoice = false, tooltip = "aura targets everyone within the knife range, super teleports to the enemy if possible to do so and infinite aura utilizes artificial intelligence to teleport you to the enemy resulting in a much longer knife range"})
			ui:createslider({tab = "rage", subsection = "misc", name = "knife bot radius", suffix = "st", flag = "rage_knifeshift", value = 12, minimum = 1, maximum = 20, tooltip = "how close an enemy must be to you for the knife bot to stab them automatically"})
			ui:createtoggle({tab = "rage", subsection = "misc", name = "teleport grenades", flag = "rage_nadetp", value = false, tooltip = "requires speed check bypass, teleports grenades according to the below settings"})
			ui:createtoggle({tab = "rage", subsection = "misc", name = "cancel grenades", flag = "rage_nadecanceltp", value = false, tooltip = "will return a grenade if a valid target is not found"})
			ui:createdropdown({tab = "rage", subsection = "misc", name = "grenade target selection", flag = "rage_nadetptype", values = {{"closest to crosshair", true}, {"closest to player", false}}, multichoice = false, tooltip = "closest to crosshair teleports grenades to the closest enemy to your crosshair. closest to player teleports grenades to the enemy closest to you"})
			
			ui:createtoggle({tab = "rage", subsection = "hack vs. hack", name = "teleporting", flag = "rage_repupdatecontrol", value = false, tooltip = "the aimbot and knife bot may teleport you to increase the possibilites of aiming at an enemy, highly recommended for hack versus hack as it greatly increases the effectiveness of the aimbot", detected = false})
			ui:createtoggle({tab = "rage", subsection = "hack vs. hack", name = "anti aimbot correction", flag = "rage_resolver", value = false, tooltip = "automatically corrects player model interpolation that has desynced from their true position allowing you to see exactly where they are according to the game. note that this will allow the aimbot to attempt resolving anybody using fake position"})
			ui:createslider({tab = "rage", subsection = "hack vs. hack", name = "maximum hitscanning points", flag = "rage_maxawalls", value = 64, minimum = 8, maximum = 200, tooltip = "the amount of points the ragebot will consider at a time, higher values decrease fps but make the aimbot more thorough"})
			ui:createdropdown({tab = "rage", subsection = "hack vs. hack", name = "sorting selection", flag = "rage_sorting", values = {{"favor high damage", true}, {"favor fewer movements", false}, {"favor safety", false}}, multichoice = false, tooltip = "the aimbot will choose from where to shoot the enemy which favors this option best, favor high damage is better for hurting enemies more, favor fewer movments is better for preventing ping spikes and teleporting as little as possible"})
			ui:createdropdown({tab = "rage", subsection = "hack vs. hack", name = "hitscan selection", flag = "rage_hitscanselection", values = {{"nearest", false}, {"clamping", false}, {"enemy move", false}, {"local move", false}, {"out of cover", false}}, multichoice = true, tooltip = "the autowall hitscan points that the aimbot will force. nearest will forcefully scan the nearest origin to the enemy, recommended for use with enemy position pathfinding. clamping will forcefully scan origins that are more in the direction of the enemy than not. enemy move will forcefully scan origins that are the same direction as the enemies movement. local move will forcefully scan origins that are the same direction as your movement, recommended for aggressive play"})
			ui:createslider({tab = "rage", subsection = "hack vs. hack", name = "hitscan selection bias", suffix = "%", flag = "rage_hitscanselectbias", value = 25, minimum = 1, maximum = 50, tooltip = "the strength of the bias for hitscan selection. for example, at 1%, nearest will only select the nearest 1% of origins and points, at 50%, it will only select from the nearest 50% of origins and points"})
			ui:createtoggle({tab = "rage", subsection = "hack vs. hack", name = "autowall hitscan", flag = "rage_autowallhitscan", value = false, tooltip = "the aimbot will consider multiple spots from which it may attempt to shoot an enemy from from rather than just your camera"})
			ui:createdropdown({tab = "rage", subsection = "hack vs. hack", name = "autowall hitscan points", flag = "rage_hitscanpoints", values = {{"cardinal", false}, {"random", false}, {"circle", false}, {"corner", false}, {"snake", false}}, multichoice = true, tooltip = "the directions that the aimbot will consider in its autowall hitscan"})
			ui:createslider({tab = "rage", subsection = "hack vs. hack", name = "autowall hitscan distance", suffix = "st", flag = "rage_hitscandistance", value = 16, minimum = 1, maximum = 16, tooltip = "the maximum distance the autowall hitscan will be from your camera in studs"})
			ui:createslider({tab = "rage", subsection = "hack vs. hack", name = "autowall hitscan increments", flag = "rage_hitscanincrementdistance", value = 40, minimum = 1, maximum = 40, tooltip = "the amount of places in between 0 and your autowall hitscan distance that will be considered by the aimbot"})
			ui:createslider({tab = "rage", subsection = "hack vs. hack", name = "autowall hitscan teleport threshold", suffix = "st", flag = "rage_hitscandistancebeforeteleport", value = 8, minimum = 1, maximum = 16, tooltip = "the maximum distance the autowall hitscan will be from your camera in studs before teleporting, higher values may miss but can shoot more often. recommedned to keep it at 8-9 for hvh and 4 or under to garuntee being undetected"})
			ui:createtoggle({tab = "rage", subsection = "hack vs. hack", name = "path-finding assisted", flag = "rage_pathfinded", value = false, tooltip = "may lower fps dramatically but will allow the autowall hitscan to use artificial intelligence to more efficiently choose extra origination points, works best on maps with plenty of open space but with obstacles in the way"})
			ui:createdropdown({tab = "rage", subsection = "hack vs. hack", name = "path-finding hitscan points", flag = "rage_pathfindingpoints", values = {{"enemy position", false}, {"cardinal", false}}, multichoice = true, tooltip = "the extra origination points that the aimbot will try to pathfind, cardinals help the autowall hitscan cardinal mode to find more points to shoot from and enemy positions pathfinds right up to the enemy, nearly garunteeing a kill as you are teleporting next to them"})
			ui:createslider({tab = "rage", subsection = "hack vs. hack", name = "path-finding processing time", suffix = "%", flag = "rage_pathfindingtime", value = 100, minimum = 10, maximum = 1000, tooltip = "multiples how much time the pathfind will spend searching. higher than 100% will decrease fps but will give further reach. lower than 100% will increase fps but will give less reach"})
			ui:createslider({tab = "rage", subsection = "hack vs. hack", name = "path-finding node size", suffix = "st", flag = "rage_pathfindingnodesize", value = 4, minimum = 1, maximum = 20, tooltip = "how large each step of the pathfinding will be, higher values are faster but less likely to successfully find a path"})
			ui:createdropdown({tab = "rage", subsection = "hack vs. hack", name = "path-finding algorithim", flag = "rage_pathfindingtype", values = {{"a*", false}, {"bfs", false}}, multichoice = true, tooltip = "the search algorithim the aimbot will use"})
			ui:createtoggle({tab = "rage", subsection = "hack vs. hack", name = "wait for enemy to load", flag = "rage_waitforspawn", value = false, tooltip = "the aimbot will only consider an enemy once they have fully spawned, doesnt kill as fast but misses less"})
			ui:createtoggle({tab = "rage", subsection = "hack vs. hack", name = "hitbox shifting", flag = "rage_multipoint", value = false, tooltip = "the aimbot will attempt to shift hitboxes around to increase the possibilities of aiming at an enemy"})
			ui:createdropdown({tab = "rage", subsection = "hack vs. hack", name = "hitbox shifting points", flag = "rage_multipointpoints", values = {{"cardinal", false}, {"random", false}}, multichoice = true, tooltip = "the directions that the hitboxes may be shifted in"})
			ui:createslider({tab = "rage", subsection = "hack vs. hack", name = "hitbox shifting distance", suffix = "st", flag = "rage_multipointdistance", value = 10, minimum = 1, maximum = 20, tooltip = "the distance in studs that each hitbox is shifted by, higher values increase the chance of missing but can be shot at more often"})
			ui:createslider({tab = "rage", subsection = "hack vs. hack", name = "hitbox shifting increments", flag = "rage_multipointincrment", value = 4, minimum = 1, maximum = 12, tooltip = "the amount of places in between 0 and your hitbox shifting distance that will be considered by the aimbot"})
			ui:createslider({tab = "rage", subsection = "hack vs. hack", name = "maximum backtrack", suffix = "ms", flag = "rage_maxbacktrack", custom = {["0"] = "off"}, value = 1000, minimum = 0, maximum = 3000, tooltip = "the window of time for the aimbot to consider shooting at previous positions. higher values increase the chance of missing"})
			ui:createslider({tab = "rage", subsection = "hack vs. hack", name = "backtrack samples", flag = "rage_backtracksamples", value = 4, minimum = 1, maximum = 24, tooltip = "the amount of backtrack points that will be sampled at a time, increases how thorough the aimbot is in finding a target but can decrease fps"})
			
			ui:createtoggle({tab = "rage", subsection = "anti aimbot", name = "enabled", flag = "rage_antiaim", value = false, tooltip = "master switch for the anti aim, cosmetic effect"})
			ui:createdropdown({tab = "rage", subsection = "anti aimbot", name = "pitch", flag = "rage_antiaimpitch", values = {{"off", true}, {"up", false}, {"zero", false}, {"down", false}, {"default", false}, {"default up", false}, {"45 up", false}, {"45 down", false}, {"random", false}, {"bob", false}, {"roll forward", false}, {"roll backward", false}, {"shaky", false}}, multichoice = false, tooltip = "forces your player to look at a certain level"})
			ui:createdropdown({tab = "rage", subsection = "anti aimbot", name = "yaw", flag = "rage_antiaimyaw", values = {{"off", true}, {"forward", false}, {"backward", false}, {"random", false}, {"spin", false}, {"sway spin", false}, {"cycle spin", false}, {"robotic spin", false}, {"glitch spin", false}}, multichoice = false, tooltip = "forces your player to look at a certain yaw angle"})
			ui:createslider({tab = "rage", subsection = "anti aimbot", name = "yaw angle", suffix = "°", flag = "rage_antiaimyawdeg", value = 0, minimum = 0, maximum = 360 * 8, tooltip = "fine tunes the yaw option"})
			ui:createdropdown({tab = "rage", subsection = "anti aimbot", name = "yaw jitter", flag = "rage_antiaimyawjitter", values = {{"off", true}, {"step", false}, {"random", false}}, multichoice = false, tooltip = "adds jittering to the yaw option"})
			ui:createslider({tab = "rage", subsection = "anti aimbot", name = "yaw jitter angle", suffix = "°", flag = "rage_antiaimyawjitterdeg", value = 0, minimum = 0, maximum = 360 * 8, tooltip = "fine tunes the jittering option"})
			ui:createdropdown({tab = "rage", subsection = "anti aimbot", name = "force stance", flag = "rage_antiaimforcestance", values = {{"off", true}, {"stand", false}, {"crouch", false}, {"prone", false}}, multichoice = false, tooltip = "forces your player to assume the following stance"})
			ui:createtoggle({tab = "rage", subsection = "anti aimbot", name = "lower arms", flag = "rage_lowerarms", value = false, tooltip = "forces the sprinting state for your player model"})
			ui:createtoggle({tab = "rage", subsection = "anti aimbot", name = "tilt neck", flag = "rage_necktilt", value = false, tooltip = "forces the aiming state for your player model"})
			ui:createtoggle({tab = "rage", subsection = "anti aimbot", name = "fake position", flag = "rage_desync", value = false, tooltip = "will cause the server to report incorrect data to other players on where you are, heavily limits everyone else's ability to hit you. disables teleporting and fire rate modification"})
			ui:createslider({tab = "rage", subsection = "anti aimbot", name = "maximum fake position", suffix = "st", flag = "rage_desyncst", value = 26, minimum = 1, maximum = 80, tooltip = "the limit of how incorrect the data on where you are may be"})
			ui:createslider({tab = "rage", subsection = "anti aimbot", name = "fake position delay", suffix = "ms", flag = "rage_desyncms", value = 20, minimum = 0, maximum = 1000, tooltip = "the delay of when the incorrect the data on where you are may be is sent"})
			ui:createtoggle({tab = "rage", subsection = "anti aimbot", name = "instant fake flick", flag = "rage_instantdesync", value = false, tooltip = "some cheats may struggle to hit fake position more with this enabled"})
			ui:createtoggle({tab = "rage", subsection = "anti aimbot", name = "spawn protection", flag = "spawn_protection", values = false, tooltip = "This will enable spawn protection."})
			ui:createslider({tab = "rage", subsection = "anti aimbot", name = "spawn protection duration", flag = "spawn_protection_duration", value = 2, minimum = 1, maximum = 10, tooltip = "This will set the spawn protection duration."})
		end

		-- esp features
		do
			ui:createtoggle({tab = "esp", subsection = "enemy", name = "enabled", flag = "enemy_esp", value = false, tooltip = "enables enemy esp"})

			ui:createtoggle({tab = "esp", subsection = "enemy", name = "bounding box", flag = "enemy_box", value = false, tooltip = "shows enemy boxes"})
			ui:createcolorpicker({tab = "esp", subsection = "enemy", object = "bounding box", name = "box", flag = "enemy_boxcolor", color = Color3.new(1, 0, 0)})
			ui:createtoggle({tab = "esp", subsection = "enemy", name = "filled bounding box", flag = "enemy_filledbox", value = false, tooltip = "filles enemy boxes"})
			ui:createcolorpicker({tab = "esp", subsection = "enemy", object = "filled bounding box", name = "filled box", flag = "enemy_filledboxcolor", color = Color3.new(1, 0, 0), transparency = 0.8})

			ui:createtoggle({tab = "esp", subsection = "enemy", name = "health bar", flag = "enemy_healthbar", value = false, tooltip = "shows enemy health bars"})
			ui:createcolorpicker({tab = "esp", subsection = "enemy", object = "health bar", name = "low health", flag = "enemy_lowhealth", color = Color3.fromRGB(255, 100, 100)})
			ui:createcolorpicker({tab = "esp", subsection = "enemy", object = "health bar", name = "full health", flag = "enemy_fullhealth", color = Color3.fromRGB(100, 255, 100)})
			ui:createtoggle({tab = "esp", subsection = "enemy", name = "gradient health bar", flag = "enemy_gradienthealthbar", value = false, tooltip = "health bars will appear as gradients"})
			ui:createtoggle({tab = "esp", subsection = "enemy", name = "health number", flag = "enemy_healthnumber", value = false, tooltip = "shows enemy health values"})
			ui:createcolorpicker({tab = "esp", subsection = "enemy", object = "health number", name = "health number", flag = "enemy_healthnumbercolor", color = Color3.new(1, 1, 1)})

			ui:createtoggle({tab = "esp", subsection = "enemy", name = "display name", flag = "enemy_name", value = false, tooltip = "shows enemy names"})
			ui:createcolorpicker({tab = "esp", subsection = "enemy", object = "display name", name = "name", flag = "enemy_namecolor", color = Color3.new(1, 1, 1)})

			ui:createtoggle({tab = "esp", subsection = "enemy", name = "rank", flag = "enemy_rank", value = false, tooltip = "shows enemy ranks"})
			ui:createcolorpicker({tab = "esp", subsection = "enemy", object = "rank", name = "rank", flag = "enemy_rankcolor", color = Color3.fromRGB(0, 219, 255)})

			ui:createtoggle({tab = "esp", subsection = "enemy", name = "held weapon", flag = "enemy_heldweapon", value = false, tooltip = "shows the enemies held weapon"})
			ui:createcolorpicker({tab = "esp", subsection = "enemy", object = "held weapon", name = "held weapon", flag = "enemy_heldweaponcolor", color = Color3.new(1, 1, 1)})

			ui:createtoggle({tab = "esp", subsection = "enemy", name = "distance", flag = "enemy_distance", value = false, tooltip = "shows the distance to the enemy"})
			ui:createcolorpicker({tab = "esp", subsection = "enemy", object = "distance", name = "distance", flag = "enemy_distancecolor", color = Color3.new(1, 1, 1)})

			ui:createtoggle({tab = "esp", subsection = "enemy", name = "exploiting", flag = "enemy_exploit", value = false, tooltip = "shows when a enemy is using a time exploit, usually involved with fire rate modification, teleporting and fake position. delta is the time difference between packet times, changes between this indicates tick shifting. delay is how far the packet time stamp is, consider this how time travelled someone is. choke is when the last packet was sent. typically indicating fake lag"})
			ui:createcolorpicker({tab = "esp", subsection = "enemy", object = "exploiting", name = "exploit flag", flag = "enemy_exploitcolor", color = Color3.new(1, 0, 0)})

			ui:createtoggle({tab = "esp", subsection = "enemy", name = "stance", flag = "enemy_stance", value = false, tooltip = "shows what stance a enemy has"})
			ui:createcolorpicker({tab = "esp", subsection = "enemy", object = "stance", name = "exploit flag", flag = "enemy_stancecolor", color = Color3.new(1, 1, 1)})

			ui:createtoggle({tab = "esp", subsection = "enemy", name = "visible", flag = "enemy_visible", value = false, tooltip = "shows if a enemy is visible"})
			ui:createcolorpicker({tab = "esp", subsection = "enemy", object = "visible", name = "visible flag", flag = "enemy_visiblecolor", color = Color3.new(1, 1, 1)})

			ui:createtoggle({tab = "esp", subsection = "enemy", name = "chams", flag = "enemy_chams", value = false, tooltip = "shows enemy chams"})
			ui:createcolorpicker({tab = "esp", subsection = "enemy", object = "chams", name = "inner cham", flag = "enemy_innerchamcolor", color = Color3.fromRGB(100, 0, 0), transparency = 155/255})
			ui:createcolorpicker({tab = "esp", subsection = "enemy", object = "chams", name = "outer cham", flag = "enemy_outerchamcolor", color = Color3.fromRGB(255, 0, 0), transparency = 0})

			ui:createtoggle({tab = "esp", subsection = "enemy", name = "skeleton", flag = "enemy_skeleton", value = false, tooltip = "shows enemy skeletons"})
			ui:createcolorpicker({tab = "esp", subsection = "enemy", object = "skeleton", name = "skeleton", flag = "enemy_skeletoncolor", color = Color3.fromRGB(236, 251, 136)})

			ui:createtoggle({tab = "esp", subsection = "enemy", name = "snap lines", flag = "enemy_snaplines", value = false, tooltip = "shows enemy snap lines"})
			ui:createcolorpicker({tab = "esp", subsection = "enemy", object = "snap lines", name = "snap line", flag = "enemy_snaplinescolor", color = Color3.new(1, 1, 1), transparency = 0})

			ui:createtoggle({tab = "esp", subsection = "enemy", name = "view angle", flag = "enemy_viewangle", value = false, tooltip = "shows a line in the direction the enemy is looking"})
			ui:createcolorpicker({tab = "esp", subsection = "enemy", object = "view angle", name = "view angle", flag = "enemy_viewanglecolor", color = Color3.new(1, 1, 1)})

			ui:createtoggle({tab = "esp", subsection = "enemy", name = "head dot", flag = "enemy_headdot", value = false, tooltip = "shows a circle at which shooting at will result in a headshot"})
			ui:createcolorpicker({tab = "esp", subsection = "enemy", object = "head dot", name = "head dot", flag = "enemy_headdotcolor", color = Color3.new(1, 0, 0)})

			ui:createtoggle({tab = "esp", subsection = "enemy", name = "out of view", flag = "enemy_oov", value = false, tooltip = "shows an arrow pointing towards an enemy if they are not in view"})
			ui:createcolorpicker({tab = "esp", subsection = "enemy", object = "out of view", name = "arrow", flag = "enemy_oovcolor", color = Color3.new(1, 1, 1)})

			ui:createslider({tab = "esp", subsection = "enemy", name = "arrow distance", suffix = "%", flag = "arrow_distance", value = 30, minimum = 1, maximum = 100})
			ui:createslider({tab = "esp", subsection = "enemy", name = "arrow size", suffix = "%", flag = "arrow_size", value = 30, minimum = 1, maximum = 100})
			ui:createtoggle({tab = "esp", subsection = "enemy", name = "dynamic arrow size", flag = "enemy_dynamicarrowsize", value = false, tooltip = "sizes the arrows based on distance"})
			ui:createtoggle({tab = "esp", subsection = "enemy", name = "show resolved flag", flag = "enemy_showresolvedflag", value = false, tooltip = "highlights enemies that have been successfully resolved"})
			ui:createcolorpicker({tab = "esp", subsection = "enemy", object = "show resolved flag", name = "resolved", flag = "enemy_resolvedflagcolor", color = Color3.fromRGB(237, 229, 62)})

			ui:createtoggle({tab = "esp", subsection = "dropped", name = "grenade warning", flag = "dropped_grenadewarning", value = false, tooltip = "predicts where nades will land and will display the danger level"})
			ui:createcolorpicker({tab = "esp", subsection = "dropped", object = "grenade warning", name = "low time", flag = "dropped_grenadehighcolor", color = Color3.fromRGB(255, 0, 0)})
			ui:createcolorpicker({tab = "esp", subsection = "dropped", object = "grenade warning", name = "high time", flag = "dropped_grenadelowcolor", color = Color3.fromRGB(0, 255, 0)})
			ui:createtoggle({tab = "esp", subsection = "dropped", name = "grenade lines", flag = "dropped_grenadelines", value = false, tooltip = "displays a line that maps how a grenade will travel"})
			ui:createcolorpicker({tab = "esp", subsection = "dropped", object = "grenade lines", name = "line start", flag = "dropped_grenadealinecolor", color = Color3.fromRGB(81, 75, 242)})
			ui:createcolorpicker({tab = "esp", subsection = "dropped", object = "grenade lines", name = "line end", flag = "dropped_grenadeblinecolor", color = Color3.fromRGB(237, 85, 103)})
			ui:createtoggle({tab = "esp", subsection = "dropped", name = "weapon names", flag = "dropped_weaponnames", value = false, tooltip = "shows weapon names"})
			ui:createcolorpicker({tab = "esp", subsection = "dropped", object = "weapon names", name = "weapon name", flag = "dropped_weaponnamecolor", color = Color3.fromRGB(255, 255, 255)})

			ui:createtoggle({tab = "esp", subsection = "team", name = "enabled", flag = "team_esp", value = false, tooltip = "enables team esp"})

			ui:createtoggle({tab = "esp", subsection = "team", name = "bounding box", flag = "team_box", value = false, tooltip = "shows team boxes"})
			ui:createcolorpicker({tab = "esp", subsection = "team", object = "bounding box", name = "box", flag = "team_boxcolor", color = Color3.new(0, 1, 0)})
			ui:createtoggle({tab = "esp", subsection = "team", name = "filled bounding box", flag = "team_filledbox", value = false, tooltip = "fills team boxes"})
			ui:createcolorpicker({tab = "esp", subsection = "team", object = "filled bounding box", name = "filled box", flag = "team_filledboxcolor", color = Color3.new(0, 1, 0), transparency = 0.8})

			ui:createtoggle({tab = "esp", subsection = "team", name = "health bar", flag = "team_healthbar", value = false, tooltip = "shows team health bars"})
			ui:createcolorpicker({tab = "esp", subsection = "team", object = "health bar", name = "low health", flag = "team_lowhealth", color = Color3.fromRGB(255, 100, 100)})
			ui:createcolorpicker({tab = "esp", subsection = "team", object = "health bar", name = "full health", flag = "team_fullhealth", color = Color3.fromRGB(100, 255, 100)})
			ui:createtoggle({tab = "esp", subsection = "team", name = "gradient health bar", flag = "team_gradienthealthbar", value = false, tooltip = "health bars will appear as gradients"})
			ui:createtoggle({tab = "esp", subsection = "team", name = "health number", flag = "team_healthnumber", value = false, tooltip = "shows enemy health values"})
			ui:createcolorpicker({tab = "esp", subsection = "team", object = "health number", name = "health number", flag = "team_healthnumbercolor", color = Color3.new(1, 1, 1)})

			ui:createtoggle({tab = "esp", subsection = "team", name = "display name", flag = "team_name", value = false, tooltip = "shows team names"})
			ui:createcolorpicker({tab = "esp", subsection = "team", object = "display name", name = "name", flag = "team_namecolor", color = Color3.new(1, 1, 1)})

			ui:createtoggle({tab = "esp", subsection = "team", name = "rank", flag = "team_rank", value = false, tooltip = "shows team ranks"})
			ui:createcolorpicker({tab = "esp", subsection = "team", object = "rank", name = "rank", flag = "team_rankcolor", color = Color3.fromRGB(0, 219, 255)})

			ui:createtoggle({tab = "esp", subsection = "team", name = "held weapon", flag = "team_heldweapon", value = false, tooltip = "shows teammate held weapon"})
			ui:createcolorpicker({tab = "esp", subsection = "team", object = "held weapon", name = "held weapon", flag = "team_heldweaponcolor", color = Color3.new(1, 1, 1)})

			ui:createtoggle({tab = "esp", subsection = "team", name = "distance", flag = "team_distance", value = false, tooltip = "shows the distance to teammate"})
			ui:createcolorpicker({tab = "esp", subsection = "team", object = "distance", name = "distance", flag = "team_distancecolor", color = Color3.new(1, 1, 1)})

			ui:createtoggle({tab = "esp", subsection = "team", name = "exploiting", flag = "team_exploit", value = false, tooltip = "shows when a enemy is using a time exploit, usually involved with fire rate modification, teleporting and fake position. delta is the time difference between packet times, changes between this indicates tick shifting. delay is how far the packet time stamp is, consider this how time travelled someone is. choke is when the last packet was sent. typically indicating fake lag"})
			ui:createcolorpicker({tab = "esp", subsection = "team", object = "exploiting", name = "exploit flag", flag = "team_exploitcolor", color = Color3.new(1, 0, 0)})

			ui:createtoggle({tab = "esp", subsection = "team", name = "stance", flag = "team_stance", value = false, tooltip = "shows what stance a teammate has"})
			ui:createcolorpicker({tab = "esp", subsection = "team", object = "stance", name = "stance flag", flag = "team_stance", color = Color3.new(1, 1, 1)})

			ui:createtoggle({tab = "esp", subsection = "team", name = "visible", flag = "team_visible", value = false, tooltip = "shows if a teammate is visible"})
			ui:createcolorpicker({tab = "esp", subsection = "team", object = "visible", name = "visible flag", flag = "team_visiblecolor", color = Color3.new(1, 1, 1)})

			ui:createtoggle({tab = "esp", subsection = "team", name = "chams", flag = "team_chams", value = false, tooltip = "shows teammate chams"})
			ui:createcolorpicker({tab = "esp", subsection = "team", object = "chams", name = "inner cham", flag = "team_innerchamcolor", color = Color3.fromRGB(0, 100, 0), transparency = 155/255})
			ui:createcolorpicker({tab = "esp", subsection = "team", object = "chams", name = "outer cham", flag = "team_outerchamcolor", color = Color3.fromRGB(0, 255, 0), transparency = 0})

			ui:createtoggle({tab = "esp", subsection = "team", name = "skeleton", flag = "team_skeleton", value = false, tooltip = "shows teammate skeletons"})
			ui:createcolorpicker({tab = "esp", subsection = "team", object = "skeleton", name = "skeleton", flag = "team_skeletoncolor", color = Color3.fromRGB(236, 251, 136)})

			ui:createtoggle({tab = "esp", subsection = "team", name = "view angle", flag = "team_viewangle", value = false, tooltip = "shows a line in the direction the teammate is looking"})
			ui:createcolorpicker({tab = "esp", subsection = "team", object = "view angle", name = "view angle", flag = "team_viewanglecolor", color = Color3.new(1, 1, 1)})

			ui:createtoggle({tab = "esp", subsection = "team", name = "head dot", flag = "team_headdot", value = false, tooltip = "shows a circle at which shooting at will result in a headshot"})
			ui:createcolorpicker({tab = "esp", subsection = "team", object = "head dot", name = "head dot", flag = "team_headdotcolor", color = Color3.new(0, 1, 0)})

			ui:createslider({tab = "esp", subsection = "esp settings", name = "max hp visiblity cap", suffix = "hp", flag = "espsettings_maxhp", value = 98, minimum = 0, maximum = 100, tooltip = "the highest a health value can be before showing health numbers"})
			ui:createdropdown({tab = "esp", subsection = "esp settings", name = "text font", flag = "espsettings_font", values = {{"Plex", true}, {"Monospace", false}, {"System", false}, {"UI", false}}, multichoice = false, tooltip = "the font of the main text"})
			ui:createdropdown({tab = "esp", subsection = "esp settings", name = "text case", flag = "espsettings_case", values = {{"lowercase", false}, {"UPPERCASE", false}, {"Normal", true}}, multichoice = false, tooltip = "the case of the main text"})
			ui:createslider({tab = "esp", subsection = "esp settings", name = "text size", flag = "espsettings_size", value = 13, minimum = 1, maximum = 40, tooltip = "the size of the main text"})
			ui:createdropdown({tab = "esp", subsection = "esp settings", name = "flag text font", flag = "espsettings_flagfont", values = {{"Plex", true}, {"Monospace", false}, {"System", false}, {"UI", false}}, multichoice = false, tooltip = "the font of the main text"})
			ui:createdropdown({tab = "esp", subsection = "esp settings", name = "flag text case", flag = "espsettings_flagcase", values = {{"lowercase", false}, {"UPPERCASE", false}, {"Normal", true}}, multichoice = false, tooltip = "the case of the main text"})
			ui:createslider({tab = "esp", subsection = "esp settings", name = "flag text size", flag = "espsettings_flagsize", value = 13, minimum = 1, maximum = 40, tooltip = "the size of the main text"})
			ui:createtoggle({tab = "esp", subsection = "esp settings", name = "highlight aimbot target", flag = "espsettings_showaimbottarget", value = false, tooltip = "shows the current aimbot target"})
			ui:createcolorpicker({tab = "esp", subsection = "esp settings", object = "highlight aimbot target", name = "aimbot target", flag = "espsettings_showaimbottargetcolor", color = Color3.new(1, 0, 0)})
			ui:createtoggle({tab = "esp", subsection = "esp settings", name = "highlight friendlies", flag = "espsettings_showfriendlies", value = false, tooltip = "shows the current aimbot target"})
			ui:createcolorpicker({tab = "esp", subsection = "esp settings", object = "highlight friendlies", name = "friendlies", flag = "espsettings_showfriendliescolor", color = Color3.fromRGB(120, 189, 245)})
			ui:createtoggle({tab = "esp", subsection = "esp settings", name = "highlight priorities", flag = "espsettings_showpriorities", value = false, tooltip = "shows the current aimbot target"})
			ui:createcolorpicker({tab = "esp", subsection = "esp settings", object = "highlight priorities", name = "priorities", flag = "espsettings_showprioritiescolor", color = Color3.fromRGB(245, 239, 120)})
		end
	

		-- visual features
		do
			ui:createtoggle({tab = "visuals", subsection = "local", name = "arm chams", flag = "visuals_armchams", value = false, tooltip = "changes the appearance of your arms"})
			ui:createcolorpicker({tab = "visuals", subsection = "local", object = "arm chams", name = "sleeve", flag = "visuals_sleevecolor", color = Color3.fromRGB(106, 136, 213), transparency = 1})
			ui:createcolorpicker({tab = "visuals", subsection = "local", object = "arm chams", name = "arm", flag = "visuals_armcolor", color = Color3.fromRGB(181, 179, 253), transparency = 1})
			ui:createslider({tab = "visuals", subsection = "local", name = "arm reflectance", flag = "visuals_armreflectance", value = 0, minimum = 0, maximum = 128})
			ui:createdropdown({tab = "visuals", subsection = "local", name = "arm material", flag = "visuals_armmaterial", values = {{"ghost", true}, {"flat", false}, {"foil", false}, {"custom", false}, {"reflective", false}}, multichoice = false})
			ui:createtoggle({tab = "visuals", subsection = "local", name = "weapon chams", flag = "visuals_weaponchams", value = false, tooltip = "changes the appearance of your weapon"})
			ui:createcolorpicker({tab = "visuals", subsection = "local", object = "weapon chams", name = "weapon", flag = "visuals_weaponcolor", color = Color3.fromRGB(106, 136, 213), transparency = 1})
			ui:createslider({tab = "visuals", subsection = "local", name = "weapon reflectance", flag = "visuals_weaponreflectance", value = 0, minimum = 0, maximum = 128})
			ui:createdropdown({tab = "visuals", subsection = "local", name = "weapon material", flag = "visuals_weaponmaterial", values = {{"ghost", true}, {"flat", false}, {"foil", false}, {"custom", false}, {"reflective", false}}, multichoice = false})
			ui:createtoggle({tab = "visuals", subsection = "local", name = "local chams", flag = "visuals_localchams", value = false, tooltip = "changes the appearance of your character in 3rd person"})
			ui:createcolorpicker({tab = "visuals", subsection = "local", object = "local chams", name = "local", flag = "visuals_localcolor", color = Color3.fromRGB(106, 136, 213), transparency = 1})
			ui:createdropdown({tab = "visuals", subsection = "local", name = "local material", flag = "visuals_localmaterial", values = {{"ghost", true}, {"flat", false}, {"foil", false}, {"custom", false}, {"reflective", false}}, multichoice = false})
			--ui:createtoggle({tab = "visuals", subsection = "local", name = "animate ghost arm", flag = "visuals_armanimation", value = false, tooltip = "allows your arms to have a visual animation if the material is ghost"})
			--ui:createtoggle({tab = "visuals", subsection = "local", name = "animate ghost weapon", flag = "visuals_weaponanimation", value = false, tooltip = "allows your weapon to have a visual animation if the material is ghost"})
			ui:createdropdown({tab = "visuals", subsection = "local", name = "arm animation", flag = "visuals_armanimationtype", values = forcefieldAnimationsDropDown, multichoice = false})
			ui:createdropdown({tab = "visuals", subsection = "local", name = "weapon animation", flag = "visuals_weaponanimationtype", values = forcefieldAnimationsDropDown, multichoice = false})
			ui:createdropdown({tab = "visuals", subsection = "local", name = "local animation", flag = "visuals_localanimationtype", values = forcefieldAnimationsDropDown, multichoice = false})

			ui:createslider({tab = "visuals", subsection = "camera", name = "camera fov", flag = "visuals_fov", value = 90, minimum = 10, maximum = 120, tooltip = "forces your camera fov to be a certain amount"})
			ui:createslider({tab = "visuals", subsection = "camera", name = "horizontal aspect ratio", flag = "visuals_aspectratiox", value = 100, minimum = 0, maximum = 120, tooltip = "forces your camera horizontal aspect ratio to be a certain amount"})
			ui:createslider({tab = "visuals", subsection = "camera", name = "vertical aspect ratio", flag = "visuals_aspectratioy", value = 100, minimum = 0, maximum = 120, tooltip = "forces your camera vertical aspect ratio to be a certain amount"})
			ui:createtoggle({tab = "visuals", subsection = "camera", name = "remove camera bob", flag = "visuals_camerabob", value = false, tooltip = "removes camera bobbing when moving"})
			ui:createtoggle({tab = "visuals", subsection = "camera", name = "remove ads fov", flag = "visuals_adsfov", value = false, tooltip = "removes fov effects when aiming"})
			ui:createtoggle({tab = "visuals", subsection = "camera", name = "remove visual suppresion", flag = "visuals_visualssuppresion", value = false, tooltip = "removes visual suppression effects when you get shot at"})
			ui:createtoggle({tab = "visuals", subsection = "camera", name = "reduce camera recoil", flag = "visuals_camerarecoil", value = false, tooltip = "reduces the amount of camera recoil"})
			ui:createslider({tab = "visuals", subsection = "camera", name = "camera recoil reduction", flag = "visuals_camerarecoilscale", value = 0, minimum = 0, maximum = 100, tooltip = "camera recoil reduction scale"})
			ui:createtoggle({tab = "visuals", subsection = "camera", name = "third person", flag = "visuals_thirdp", value = false, tooltip = "allows you to go into 3rd person"})
			ui:createkeybind({tab = "visuals", subsection = "camera", object = "third person", name = "third person key", flag = "visuals_thirdpkey", parentflag = "visuals_thirdp", value = Enum.KeyCode.H})
			ui:createslider({tab = "visuals", subsection = "camera", name = "third person distance", flag = "visuals_thirdpdistance", value = 100, minimum = 0, maximum = 240, tooltip = "how far away the camera is in third person"})

			ui:createtoggle({tab = "visuals", subsection = "viewmodel", name = "offset viewmodel", flag = "visuals_offsetviewmodel", value = false, tooltip = "offsets your viewmodel from its default position"})
			ui:createslider({tab = "visuals", subsection = "viewmodel", name = "offset x", flag = "visuals_offsetviewmodelx", value = 180, minimum = 0, maximum = 360})
			ui:createslider({tab = "visuals", subsection = "viewmodel", name = "offset y", flag = "visuals_offsetviewmodely", value = 180, minimum = 0, maximum = 360})
			ui:createslider({tab = "visuals", subsection = "viewmodel", name = "offset z", flag = "visuals_offsetviewmodelz", value = 180, minimum = 0, maximum = 360})
			ui:createslider({tab = "visuals", subsection = "viewmodel", name = "pitch", suffix = "°", flag = "visuals_offsetviewmodelp", value = 180, minimum = 0, maximum = 360})
			ui:createslider({tab = "visuals", subsection = "viewmodel", name = "yaw", suffix = "°", flag = "visuals_offsetviewmodelya", value = 180, minimum = 0, maximum = 360})
			ui:createslider({tab = "visuals", subsection = "viewmodel", name = "roll", suffix = "°", flag = "visuals_offsetviewmodelr", value = 180, minimum = 0, maximum = 360})
			ui:createtoggle({tab = "visuals", subsection = "viewmodel", name = "laser pointer", flag = "misc_customcrosshair", value = false, tooltip = "shows a custom crosshair"})
			ui:createtoggle({tab = "visuals", subsection = "viewmodel", name = "outline laser pointer", flag = "misc_customcrosshairoutline", value = false, tooltip = "outlines a custom crosshair"})
			ui:createcolorpicker({tab = "visuals", subsection = "viewmodel", object = "laser pointer", name = "laser pointer", flag = "misc_customcrosshaircolor", color = Color3.new(255, 255, 255)})
			ui:createslider({tab = "visuals", subsection = "viewmodel", name = "laser pointer width", flag = "misc_customcrosshairw", value = 20, minimum = 0, maximum = 100})
			ui:createslider({tab = "visuals", subsection = "viewmodel", name = "laser pointer length", flag = "misc_customcrosshairl", value = 20, minimum = 0, maximum = 100})
			ui:createslider({tab = "visuals", subsection = "viewmodel", name = "laser pointer length gap", flag = "misc_customcrosshairg", value = 20, minimum = 0, maximum = 100})
			ui:createslider({tab = "visuals", subsection = "viewmodel", name = "laser pointer width gap", flag = "misc_customcrosshairf", value = 20, minimum = 0, maximum = 100})
			ui:createslider({tab = "visuals", subsection = "viewmodel", name = "laser pointer thickness", flag = "misc_customcrosshairth", value = 1, minimum = 1, maximum = 100})
			ui:createslider({tab = "visuals", subsection = "viewmodel", name = "laser pointer rotation", flag = "misc_laserpointerrotation", value = 45, minimum = 0, maximum = 360})
			ui:createslider({tab = "visuals", subsection = "viewmodel", name = "laser pointer rotation speed", flag = "misc_laserpointerrotationspeed", value = 0, minimum = -360, maximum = 360})

			ui:createtoggle({tab = "visuals", subsection = "world", name = "ambient", flag = "visuals_ambient", value = false, tooltip = "changes the color of the world"})
			ui:createcolorpicker({tab = "visuals", subsection = "world", object = "ambient", name = "indoor", flag = "visuals_indoorcolor", color = Color3.fromRGB(117, 76, 236)})
			ui:createcolorpicker({tab = "visuals", subsection = "world", object = "ambient", name = "outdoor", flag = "visuals_outdoorcolor", color = Color3.fromRGB(117, 76, 236)})
			ui:createtoggle({tab = "visuals", subsection = "world", name = "force time", flag = "visuals_forcetime", value = false, tooltip = "forces the time of the world"})
			ui:createslider({tab = "visuals", subsection = "world", name = "time of day", flag = "visuals_time", value = 6, minimum = 0, maximum = 24})
			ui:createtoggle({tab = "visuals", subsection = "world", name = "local bullet tracers", flag = "visuals_bullettracers", value = false, tooltip = "creates a visual tracer of a bullets trajectory when a bullet is fired"})
			ui:createcolorpicker({tab = "visuals", subsection = "world", object = "local bullet tracers", name = "bullet tracers", flag = "visuals_bullettracercolor", color = Color3.fromRGB(201, 69, 54), transparency = 1})
			ui:createtoggle({tab = "visuals", subsection = "world", name = "enemy bullet tracers", flag = "visuals_bullettracers2", value = false, tooltip = "creates a visual tracer of a bullets trajectory when a bullet is fired"})
			ui:createcolorpicker({tab = "visuals", subsection = "world", object = "enemy bullet tracers", name = "bullet tracers", flag = "visuals_bullettracercolor2", color = Color3.fromRGB(201, 69, 54), transparency = 1})
			ui:createslider({tab = "visuals", subsection = "world", name = "bullet tracer time", suffix = "s", flag = "visuals_bulettracertime", value = 4, minimum = 0, maximum = 16})
			ui:createtoggle({tab = "visuals", subsection = "world", name = "hit chams", flag = "visuals_hitchams", value = false, tooltip = "creates a visual copy of an enemy when they have been shot"})
			ui:createslider({tab = "visuals", subsection = "world", name = "hit cham time", suffix = "s", flag = "visuals_hitchamtime", value = 2, minimum = 0, maximum = 12})
			ui:createcolorpicker({tab = "visuals", subsection = "world", object = "hit chams", name = "hit chams", flag = "visuals_hitchamcolor", color = Color3.fromRGB(106, 136, 213), transparency = 1})
			ui:createdropdown({tab = "visuals", subsection = "world", name = "hit chams material", flag = "visuals_hitchammaterial", values = {{"ghost", true}, {"flat", false}, {"foil", false}, {"custom", false}, {"glass", false}}, multichoice = false})
			ui:createtoggle({tab = "visuals", subsection = "world", name = "custom brightness", flag = "visuals_brightness", value = false, tooltip = "changes the brightness of the world"})
			ui:createdropdown({tab = "visuals", subsection = "world", name = "brightness mode", flag = "visuals_brightnesstype", values = {{"dimmed", true}, {"nightmode", false}, {"fullbright", false}}, multichoice = false})
			ui:createtoggle({tab = "visuals", subsection = "world", name = "teleporting lines", flag = "visuals_teleportlines", value = false, tooltip = "creates a line showing the teleporting done by the aimbot"})
			ui:createcolorpicker({tab = "visuals", subsection = "world", object = "teleporting lines", name = "teleport line", flag = "visuals_teleportlinecolor", color = Color3.fromRGB(168, 232, 65)})
			ui:createtoggle({tab = "visuals", subsection = "world", name = "show fake position", flag = "visuals_realshow", value = false, tooltip = "shows where your fake position is if you are desynced. yellow text means it is ready to be moved"})
			ui:createtoggle({tab = "visuals", subsection = "world", name = "show fov", flag = "visuals_showfov", value = false, tooltip = "shows fov circles"})
			ui:createcolorpicker({tab = "visuals", subsection = "world", object = "show fov", name = "aim assist fov", flag = "visuals_aimassistfovcolor", color = Color3.fromRGB(127, 72, 163), transparency = 1})
			ui:createcolorpicker({tab = "visuals", subsection = "world", object = "show fov", name = "triggerbot magnet fov", flag = "visuals_triggerbotmagnetcolor", color = Color3.fromRGB(100, 100, 100), transparency = 1})
			ui:createcolorpicker({tab = "visuals", subsection = "world", object = "show fov", name = "bullet redirection fov", flag = "visuals_bulletredirectioncolor", color = Color3.fromRGB(163, 72, 127), transparency = 1})
			ui:createcolorpicker({tab = "visuals", subsection = "world", object = "show fov", name = "aimbot fov", flag = "visuals_aimbotcolor", color = Color3.fromRGB(255, 60, 0), transparency = 1})
			ui:createtoggle({tab = "visuals", subsection = "world", name = "custom skybox", flag = "visuals_customsky", value = false, tooltip = "adds a custom sky to the world"})
			ui:createdropdown({tab = "visuals", subsection = "world", name = "skybox", flag = "visuals_skychoice", values = skyboxDropDown, multichoice = false})
			ui:createtoggle({tab = "visuals", subsection = "world", name = "custom bloom", flag = "visuals_custombloom", value = false, tooltip = "adds bloom to the world"})
			ui:createslider({tab = "visuals", subsection = "world", name = "bloom intensity", suffix = "%", flag = "visuals_bloomintensity", value = 10, minimum = 0, maximum = 100})
			ui:createslider({tab = "visuals", subsection = "world", name = "bloom size", suffix = "%", flag = "visuals_bloomsize", value = 10, minimum = 0, maximum = 100})
			ui:createslider({tab = "visuals", subsection = "world", name = "bloom threshold", suffix = "%", flag = "visuals_bloomthreshold", value = 10, minimum = 0, maximum = 100})
			ui:createtoggle({tab = "visuals", subsection = "world", name = "custom atmosphere", flag = "visuals_customatm", value = false, tooltip = "adds bloom to the world"})
			ui:createcolorpicker({tab = "visuals", subsection = "world", object = "custom atmosphere", name = "color", flag = "visuals_customatmcolor", color = Color3.fromRGB(117, 76, 236)})
			ui:createcolorpicker({tab = "visuals", subsection = "world", object = "custom atmosphere", name = "decay", flag = "visuals_customatmdecay", color = Color3.fromRGB(117, 76, 236)})
			ui:createslider({tab = "visuals", subsection = "world", name = "atmosphere density", suffix = "%", flag = "visuals_densityatm", value = 10, minimum = 0, maximum = 100})
			ui:createslider({tab = "visuals", subsection = "world", name = "atmosphere glare", suffix = "%", flag = "visuals_glareatm", value = 10, minimum = 0, maximum = 100})
			ui:createslider({tab = "visuals", subsection = "world", name = "atmosphere haze", suffix = "%", flag = "visuals_hazeatm", value = 10, minimum = 0, maximum = 100})
		end

		-- misc features
		do
			ui:createtoggle({tab = "misc", subsection = "movement", name = "elytra", flag = "misc_fly", value = false, tooltip = "manipulates your movement to be able to fly"})
			ui:createkeybind({tab = "misc", subsection = "movement", object = "elytra", name = "fly key", parentflag = "misc_fly", flag = "misc_flykey"})
			ui:createslider({tab = "misc", subsection = "movement", name = "elytra speed factor", suffix = "st/s", flag = "misc_flyspeedfactor", value = 60, minimum = 0, maximum = 400})
			ui:createtoggle({tab = "misc", subsection = "movement", name = "auto jump", flag = "misc_autojump", value = false, tooltip = "forces you to jump continuously when space is held"})
			ui:createtoggle({tab = "misc", subsection = "movement", name = "speed", flag = "misc_speed", value = false, tooltip = "manipulates your movement to be able to move faster"})
			ui:createkeybind({tab = "misc", subsection = "movement", object = "speed", name = "speed key", parentflag = "misc_speed", flag = "misc_speedkey"})
			ui:createdropdown({tab = "misc", subsection = "movement", name = "speed type", flag = "misc_speedtype", values = {{"always", true}, {"in air", false}}, multichoice = false})
			ui:createslider({tab = "misc", subsection = "movement", name = "speed factor", suffix = "st/s", flag = "misc_speedfactor", value = 60, minimum = 0, maximum = 400})
			ui:createtoggle({tab = "misc", subsection = "movement", name = "circle strafe", flag = "misc_circlestrafe", value = false, tooltip = "automatically strafes in a circle"})
			ui:createkeybind({tab = "misc", subsection = "movement", object = "circle strafe", name = "circle strafe key", parentflag = "misc_circlestrafe", flag = "misc_circlestrafekey"})
			ui:createslider({tab = "misc", subsection = "movement", name = "circle strafe radius", suffix = "st", flag = "misc_circlestraferadius", value = 8, minimum = 2, maximum = 20})
			--ui:createtoggle({tab = "misc", subsection = "movement", name = "no clip", flag = "misc_noclip", value = false, detected = true, tooltip = "allows you to fly through walls, will rubberband you if it failed to noclip. requires fly"})
			--ui:createkeybind({tab = "misc", subsection = "movement", object = "no clip", name = "no clip key", parentflag = "misc_noclip", flag = "misc_noclipkey"})
			ui:createtoggle({tab = "misc", subsection = "movement", name = "bypass speed checks", flag = "misc_bypassspeed", value = false, tooltip = "attempts to bypass the maximum speed limit on the server when your speed exceeds 60 st./sec", detected = false})
			ui:createtoggle({tab = "misc", subsection = "movement", name = "evie tick bypass", flag = "misc_evietickbypass", value = false, tooltip = "uses evie's ping hook instead of invadeds. use this if you're despawning with high firerate", detected = true})
			--ui:createtoggle({tab = "misc", subsection = "movement", name = "bypass flight checks", flag = "misc_bypassfly", value = false, tooltip = "attempts to bypass the flight check on the server, requires bypass speed checks", detected = true})
			ui:createtoggle({tab = "misc", subsection = "movement", name = "bypass fall damage", flag = "misc_bypassfall", value = false, tooltip = "allows you to fall any distance without taking damage"})
			ui:createtoggle({tab = "misc", subsection = "movement", name = "super jump", flag = "misc_superjump", value = false, tooltip = "allows you to jump higher"})
			ui:createslider({tab = "misc", subsection = "movement", name = "super jump strength", suffix = "%", flag = "misc_superjumpstrength", value = 200, minimum = 0, maximum = 4000})

			ui:createtoggle({tab = "misc", subsection = "weapon modifications", name = "enabled", flag = "misc_gunmods", value = false, tooltip = "allows the modification of your weapon statistics"})
			ui:createslider({tab = "misc", subsection = "weapon modifications", name = "fire rate scale", suffix = "%", flag = "misc_fireratescale", value = 100, minimum = 100, maximum = 10000, tooltip = "changes the speed that your weapon fires at"})
			ui:createslider({tab = "misc", subsection = "weapon modifications", name = "recoil scale", suffix = "%", flag = "misc_recoilscale", value = 100, minimum = 0, maximum = 100, tooltip = "changes the amount of recoil your weapon has"})
			ui:createtoggle({tab = "misc", subsection = "weapon modifications", name = "no weapon sway", flag = "misc_nosway", value = false, tooltip = "removes the gun moving around when you move your camera"})
			ui:createtoggle({tab = "misc", subsection = "weapon modifications", name = "no weapon bob", flag = "misc_nobob", value = false, tooltip = "removes the gun moving around when you walk around"})
			ui:createtoggle({tab = "misc", subsection = "weapon modifications", name = "no fire animation", flag = "misc_nofireanim", value = false, tooltip = "removes the gun firing animation, particularly useful for guns that require bolting"})
			ui:createtoggle({tab = "misc", subsection = "weapon modifications", name = "instant equip", flag = "misc_instantequip", value = false, tooltip = "removes the time it takes to equip your weapon"})
			ui:createtoggle({tab = "misc", subsection = "weapon modifications", name = "instant reload", flag = "misc_instantreload", value = false, tooltip = "removes the time it takes to reload your weapon"})
			ui:createtoggle({tab = "misc", subsection = "weapon modifications", name = "full auto", flag = "misc_fullauto", value = false, tooltip = "makes every gun fully automatic and able to continously shoot when mouse 1 is held"})

			ui:createtoggle({tab = "misc", subsection = "extra", name = "auto kick", flag = "misc_autokick", value = false, tooltip = "automatically kicks a random player from the server when you get kills"})
			ui:createtoggle({tab = "misc", subsection = "extra", name = "supress only", flag = "misc_supressonly", value = false, tooltip = "the cheat will not do damage"})
			ui:createtoggle({tab = "misc", subsection = "extra", name = "auto deploy", flag = "misc_autodeploy", value = false, tooltip = "the cheat will automatically deploy you"})
			ui:createtoggle({tab = "misc", subsection = "extra", name = "ignore friendlies", flag = "misc_ignorefriendlies", value = false, tooltip = "the cheat will ignore targetting friendlies"})
			ui:createtoggle({tab = "misc", subsection = "extra", name = "priorities only", flag = "misc_onlypriorities", value = false, tooltip = "the cheat will only target priorities"})
			ui:createdropdown({tab = "misc", subsection = "extra", name = "vote neutral", flag = "misc_voteneutral", values = {{"no", true}, {"yes", false}, {"none", false}}, multichoice = false})
			ui:createdropdown({tab = "misc", subsection = "extra", name = "vote priority", flag = "misc_votepriority", values = {{"no", true}, {"yes", false}, {"none", false}}, multichoice = false})
			ui:createdropdown({tab = "misc", subsection = "extra", name = "vote friendly", flag = "misc_votefriendly", values = {{"no", true}, {"yes", false}, {"none", false}}, multichoice = false})
			ui:createtoggle({tab = "misc", subsection = "extra", name = "hit sound", flag = "misc_hitsound", value = false, tooltip = "plays a certain sound when you hit someone"})    
			ui:createslider({tab = "misc", subsection = "extra", name = "hit sound volume", suffix = "%", flag = "misc_hitsoundlevel", value = 20, minimum = 0, maximum = 100})
			ui:createtextbox({tab = "misc", subsection = "extra", text = "6229978482", flag = "misc_hitsoundid"})
			ui:createdropdown({tab = "misc", subsection = "extra", name = "hit sounds", flag = "misc_hitsoundids", values = cheatHitSoundsDropDown, multichoice = false})
			ui:createtoggle({tab = "misc", subsection = "extra", name = "kill sound", flag = "misc_killsound", value = false, tooltip = "plays a certain sound when you kill someone"})
			ui:createslider({tab = "misc", subsection = "extra", name = "kill sound volume", suffix = "%", flag = "misc_killsoundlevel", value = 20, minimum = 0, maximum = 100})
			ui:createtextbox({tab = "misc", subsection = "extra", text = "5709456554", flag = "misc_killsoundid"})
			ui:createdropdown({tab = "misc", subsection = "extra", name = "kill sounds", flag = "misc_killsoundids", values = cheatHitSoundsDropDown, multichoice = false})
			ui:createtoggle({tab = "misc", subsection = "extra", name = "chat spammer", flag = "misc_chatspam", value = false, tooltip = "sends chat messages in quick succession"})
			ui:createdropdown({tab = "misc", subsection = "extra", name = "chat spammer messages", flag = "misc_chatspamchoice", values = {{"normal", true}, {"emojis", false}, {"custom", false}}, multichoice = false})
			ui:createtoggle({tab = "misc", subsection = "extra", name = "kill say", flag = "misc_killsay", value = false, tooltip = "sends chat messages after anyone is killed"})
			ui:createdropdown({tab = "misc", subsection = "extra", name = "kill say messages", flag = "misc_killsaychoice", values = {{"normal", true}, {"custom", false}}, multichoice = false})
			ui:createtoggle({tab = "misc", subsection = "extra", name = "kill streak sounds", flag = "misc_killstreak", value = false, tooltip = "plays a certain sound when you get a kill streak"})
			ui:createslider({tab = "misc", subsection = "extra", name = "kill streak volume", suffix = "%", flag = "misc_killstreaklevel", value = 20, minimum = 0, maximum = 100})
			ui:createtoggle({tab = "misc", subsection = "extra", name = "fake equip", flag = "misc_fakeequip", value = false, tooltip = "you will appear as if you are holding a different weapon"})
			ui:createdropdown({tab = "misc", subsection = "extra", name = "fake equip slot", flag = "misc_fakeequipslot", values = {{"primary", true}, {"secondary", false}, {"melee", false}}, multichoice = false})
		end

		-- settings features
		do
			ui:createtextbox({tab = "config", subsection = "other", text = "preset name", flag = "configname"})

			local newList = ui.getconfigs()
			for i, v in next, newList do
				ui.flags.configname:setvalue(v[1])
				break
			end

			ui:createdropdown({tab = "config", subsection = "other", name = "preset", flag = "configselection", values = newList, multichoice = false})
			ui:createbutton({tab = "config", subsection = "other", name = "save preset", flag = "saveconfig", confirmation = true})
			ui:createbutton({tab = "config", subsection = "other", name = "load preset", flag = "loadconfig", confirmation = true})
			ui:createbutton({tab = "config", subsection = "other", name = "delete preset", flag = "deleteconfig", confirmation = true})

			ui:createtoggle({tab = "config", subsection = "ui", name = "key binds", value = false, flag = "keybinds"})

			ui:createslider({tab = "config", subsection = "ui", name = "key binds horizonatal offset", flag = "keybindoffsetx", value = 0, minimum = 0, maximum = 4096})
			ui:createslider({tab = "config", subsection = "ui", name = "key binds vertical offset", flag = "keybindoffsety", value = 256, minimum = 0, maximum = 4096})

			ui:createtoggle({tab = "config", subsection = "ui", name = "water mark", value = true, flag = "watermark"})
			ui:createtextbox({tab = "config", subsection = "ui", text = "vader", flag = "wmtext1"})
			ui:createtextbox({tab = "config", subsection = "ui", text = " haxx", flag = "wmtext2"})
			ui:createtoggle({tab = "config", subsection = "ui", name = "ui accent", value = false, flag = "uiaccent"})
			ui:createcolorpicker({tab = "config", subsection = "ui", object = "ui accent", name = "accent", flag = "uiaccentcolor", color = ui.accent})
			for groupName, group in next, ui.colorGroups do
				ui:createtoggle({tab = "config", subsection = "ui", name = "ui color " .. groupName, value = false, flag = "uicolor" .. groupName})
				ui:createcolorpicker({tab = "config", subsection = "ui", object = "ui color " .. groupName, name = "color " .. groupName, flag = "uicolorpicker" .. groupName, color = ui.startingParameters.colors[groupName]})
			end
			ui:createbutton({tab = "config", subsection = "ui", name = "reset ui layout", flag = "resetuilayout", confirmation = true})

			ui:createbutton({tab = "config", subsection = "extra", name = "rejoin", flag = "rejoin", confirmation = true})
			ui:createbutton({tab = "config", subsection = "extra", name = "join a new game", flag = "joinnewgame", confirmation = true})
			ui:createbutton({tab = "config", subsection = "extra", name = "set clipboard game id", flag = "clipboardgameid", confirmation = true})
			ui:createbutton({tab = "config", subsection = "extra", name = "set clipboard teleport code", flag = "clipboardtpcode", confirmation = true})
			ui:createbutton({tab = "config", subsection = "extra", name = "set clipboard join code", flag = "clipboardjoincode", confirmation = true})
		end
	end

	-- config area setup
	do
		local function resetConfigs()
			local oldThis = ui.elements["config"]["other"]["preset"]
			local oldHolderPos = oldThis.holder.position
			local oldValues = ui.flags.configselection.value
			local lastSelection
			for i, v in next, oldValues do
				if v then
					lastSelection = i
				end
			end

			oldThis.holder.visible = false -- hey guys vader here, today we're making a memory leak
			ui.elements["config"]["other"]["preset"] = nil
			local newList = ui.getconfigs()
			local setNew = false
			for i, v in next, newList do
				if lastSelection == v[1] then -- if the last selcetion is in the new list
					setNew = true
					break
				end
			end
			if setNew then
				for i, v in next, newList do
					if lastSelection == v[1] then -- if the last selcetion is in the new list
						ui.flags.configname:setvalue(v[1])
						v[2] = true
					else
						v[2] = false
					end
				end
			end
			ui:createdropdown({tab = "config", subsection = "other", name = "preset", flag = "configselection", values = newList, multichoice = false})
			ui.elements["config"]["other"]["preset"].holder.position = oldHolderPos
			ui.flags.configselection.changed:Connect(function()
				local selected
				for i, v in next, (ui.flags.configselection.value) do
					if v then
						selected = i
					end
				end
				if not selected then return end
				ui.flags.configname:setvalue(selected)
			end)
			ui:updatemenuanimations()
		end

		-- update config selection
		ui.flags.configselection.changed:Connect(function()
			local selected
			for i, v in next, (ui.flags.configselection.value) do
				if v then
					selected = i
				end
			end
			if not selected then return end
			ui.flags.configname:setvalue(selected)
		end)

		-- save config button
		ui.flags.saveconfig.pressed:Connect(function()
			writefile(cheat_path .. "/" .. game_path .. "/" .. config_path .. "/" .. ui.flags.configname.value .. ".cfg", ui:savestate())
			ui:createnotification({text = "saved " .. ui.flags.configname.value .. ".cfg", lifetime = 5, priority = 0})
			resetConfigs()
		end)

		-- delete config button
		ui.flags.deleteconfig.pressed:Connect(function()
			local ConfigPath = cheat_path .. "/" .. game_path .. "/" .. config_path .. "/" .. ui.flags.configname.value .. ".cfg"
			if isfile(ConfigPath) then
				delfile(ConfigPath)
				ui:createnotification({text = "deleted " .. ui.flags.configname.value .. ".cfg", lifetime = 5, priority = 0})
			end
			resetConfigs()
		end)

		-- load config button
		ui.flags.loadconfig.pressed:Connect(function()
			local ConfigPath = cheat_path .. "/" .. game_path .. "/" .. config_path .. "/" .. ui.flags.configname.value .. ".cfg"
			if isfile(ConfigPath) then
				ui:loadstate(readfile(ConfigPath))
				ui:createnotification({text = "loaded " .. ui.flags.configname.value .. ".cfg", lifetime = 5, priority = 0})
			end
			resetConfigs()
		end)

		coroutine.wrap(function()
			repeat
				task.wait()
			until getgenv().vaderhaxx and getgenv().vaderhaxx.loaded
			task.wait()
			if isfile(cheat_path .. "/" .. game_path .. "/" .. config_path .. "/" .. "default.cfg") then
				ui:loadstate(readfile(cheat_path .. "/" .. game_path .. "/" .. config_path .. "/" .. "default.cfg"))
				ui:createnotification({text = "auto-loaded defualt.cfg", lifetime = 5, priority = 0})
			end
			writefile(cheat_path .. "/" .. game_path .. "/" .. config_path .. "/" .. "reset" .. ".cfg", ui:savestate())

			resetConfigs()
		end)()
	end

	-- color setup
	do
		-- update ui accents
		ui.flags.uiaccent.changed:Connect(function()
			ui.updateaccent()
		end)

		ui.flags.uiaccentcolor.changed:Connect(function()
			ui.updateaccent()
		end)

		for i, v in next, ui.startingParameters.colors do
			ui.flags["uicolor" .. i].changed:Connect(function()
				ui.updatecolors[i]()
			end)
			ui.flags["uicolorpicker" .. i].changed:Connect(function()
				ui.updatecolors[i]()
			end)
		end
	end
	
	-- extra 
	do
		ui.flags.rejoin.pressed:Connect(function()
			ui:createnotification({text = "rejoining...", lifetime = 5, priority = 0})
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
		end)
		ui.flags.joinnewgame.pressed:Connect(function()
			ui:createnotification({text = "joining a new game...", lifetime = 5, priority = 0})
			local thing = game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
			local jobid = thing.data[math.random(1, table.getn(thing.data))].id

			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, jobid)
		end)
		ui.flags.clipboardgameid.pressed:Connect(function()
			ui:createnotification({text = "set job id to clipboard!", lifetime = 5, priority = 0})
			setclipboard(game.JobId)
		end)
		ui.flags.clipboardtpcode.pressed:Connect(function()
			ui:createnotification({text = "set job id to clipboard!", lifetime = 5, priority = 0})
			setclipboard('game:GetService("TeleportService"):TeleportToPlaceInstance('..game.PlaceId..',"'..game.JobId..'")')
		end)
		ui.flags.clipboardjoincode.pressed:Connect(function()
			ui:createnotification({text = "set job id to clipboard!", lifetime = 5, priority = 0})
			setclipboard('Roblox.GameLauncher.joinGameInstance('..game.PlaceId..',"'..game.JobId..'")')
		end)
	end

	-- watermark setup
	do
		if oldWatermark == true then
			local this = {}
			this.container = utilities:draw("frame", {
				parent = utilities.base,
				anchorpoint = Vector2.new(1, 0),
				size = UDim2.new(0, 100, 0, 100),
				position = UDim2.new(32, 0, 32, 0),
				zindex = ui.basezindex + -4,
				color = Color3.new(0.0862745, 0.0862745, 0.0862745),
				visible = false,
				thickness = 1,
				transparency = 1,
				filled = true,
				name = "okay",
			})
			this.outline1 = utilities:draw("frame", {
				parent = this.container,
				anchorpoint = Vector2.new(0.5, 0.5),
				size = UDim2.new(1, 2, 1, 2),
				position = UDim2.new(0.5, 0, 0.5, 0),
				zindex = ui.basezindex + 5,
				color = Color3.new(0.262745, 0.262745, 0.262745),
				visible = true,
				thickness = 1,
				filled = false,
				name = "okay",
			})
			this.outline2 = utilities:draw("frame", {
				parent = this.containeroutline,
				anchorpoint = Vector2.new(0.5, 0.5),
				size = UDim2.new(1, 2, 1, 2),
				position = UDim2.new(0.5, 0, 0.5, 0),
				zindex = ui.basezindex + 4,
				color = Color3.new(0.0862745, 0.0862745, 0.0862745),
				visible = true,
				thickness = 1,
				filled = false,
				name = "okay",
			})

			local textobjs = 42
			this.textObject = {}
			for i = 1, textobjs do
				this.textObject[i] = utilities:draw("text", {
					parent = this.container,
					anchorpoint = Vector2.new(0, 0),
					size = 13, -- x3
					font = Drawing.Fonts.Plex,
					position = UDim2.new(0, 8 + ((i - 1) * 7), 0, 6),
					zindex = ui.basezindex + -4,
					color = Color3.fromRGB(255, 255, 255),
					visible = true,
					outline = false,
					text = " ",
					name = "okay",
				})
			end

			local statss = {
				framespersec = 0,
				memusage = math.floor(stats:GetTotalMemoryUsageMb()),
				instancecount = stats.InstanceCount,
			}

			runservice.RenderStepped:Connect(function()
				statss.framespersec = statss.framespersec + 1
			end)

			local lastthing = tick()
			local lastcolor = tick()
			local wmtext = ""
			local textthing = {}
			local hue = 0

			local months = {"Jan.","Feb.","Mar.","Apr.","May","Jun.","Jul.","Aug.","Sep.","Oct.","Nov.","Dec."}
			local daysinmonth = {31,28,31,30,31,30,31,31,30,31,30,31}

			local function getDate()
				local time = os.time()
				local year = math.floor(time/60/60/24/365.25+1970)
				local day = math.ceil(time/60/60/24%365.25)
				local month
				for i=1, #daysinmonth do
					if day > daysinmonth[i] then
						day = day - daysinmonth[i]
					else
						month = i
						break
					end
				end
				return month, day, year
			end

			local wtf = tick()
			runservice.RenderStepped:Connect(function(dt)
				local result = ui.startWatermark and ui.flags.watermark and ui.flags.watermark.value or false
				if this.container.visible ~= result then
					this.container.visible = result
				end

				if this.container.visible == false then return end

				local gayresult = UDim2.new(1, -100, 0, 42)
				if this.container.position ~= gayresult then
					this.container.position = gayresult
				end

				hue = hue + (dt * 5) -- el speed$$

				if tick() - lastthing > 1 then -- optimized$$$$$
					local seconds = os.date("*t") ["sec"]
					local minutes = os.date("*t") ["min"]
					local hours = os.date("*t") ["hour"]

					if tonumber(seconds) <= 9 then
						seconds = "0"..seconds
					end
					if tonumber(minutes) <= 9 then
						minutes = "0"..minutes
					end
					if tonumber(hours) <= 9 then
						hours = "0"..hours
					end

					lastthing = tick()
					statss.memusage = math.floor(stats:GetTotalMemoryUsageMb())
					statss.instancecount = stats.InstanceCount
					--wmtext = "[ vader haxx ] BETA" .. " | " .. statss.framespersec .. " fps" .. " | " .. hours..":"..minutes..":"..seconds
					local month, day, year = getDate()
					wmtext = "[ " .. ui.flags.wmtext1.value .. ui.flags.wmtext2.value .. " ] BETA" .. " | " .. tostring(months[month]) .. " " .. tostring(day) .. " " .. tostring(year)	
					statss.framespersec = 0
					this.container.size = UDim2.new(0, (#wmtext * 7) + 16, 0, 26)


					textthing = wmtext:split("")

					for i = 1, textobjs do
						local v = this.textObject[i]
						local addhue = 0
						if not textthing[i] then
							v.Drawingobject.Text = ""
						else
							if i >= 6 + #ui.flags.wmtext1.value + #ui.flags.wmtext2.value and i <= 10 + #ui.flags.wmtext1.value + #ui.flags.wmtext2.value then
								addhue = addhue + 10 -- now add a bit for the next fucken character
								v.Drawingobject.Color = Color3.fromHSV(((addhue + hue / 60) + (i / 60)) % 1, 0.58, 1) -- fully saturated made it look pasted so i toned that down a notch
							elseif i >= 3 + #ui.flags.wmtext1.value and i <= 3 + #ui.flags.wmtext1.value + #ui.flags.wmtext2.value then
								--v.Drawingobject.Color = Color3.fromRGB(191, 255, 107)
								v.Drawingobject.Color = ui.accent
							else
								v.Drawingobject.Color = Color3.new(1, 1, 1)
							end

							v.Drawingobject.Text = textthing[i]
						end
					end

					return
				end

				textthing = wmtext:split("")

				if tick() - wtf > 1/19 then
					wtf = tick()
					for i = 1, textobjs do
						local v = this.textObject[i]
						local addhue = 0
						if not textthing[i] then
							v.Drawingobject.Text = ""
						else
							if i >= 6 + #ui.flags.wmtext1.value + #ui.flags.wmtext2.value and i <= 10 + #ui.flags.wmtext1.value + #ui.flags.wmtext2.value then
								addhue = addhue + 10 -- now add a bit for the next fucken character
								v.Drawingobject.Color = Color3.fromHSV(((addhue + hue / 60) + (i / 60)) % 1, 0.58, 1) -- fully saturated made it look pasted so i toned that down a notch
							elseif i >= 3 + #ui.flags.wmtext1.value and i <= 3 + #ui.flags.wmtext1.value + #ui.flags.wmtext2.value then
								--v.Drawingobject.Color = Color3.fromRGB(191, 255, 107)
								v.Drawingobject.Color = ui.accent
							else
								v.Drawingobject.Color = Color3.new(1, 1, 1)
							end

							v.Drawingobject.Text = textthing[i]
						end
					end
				end
			end)
		else
			ui.objects.watermarkback = utilities:draw("frame", {
				parent = utilities.base,
				anchorpoint = Vector2.new(1, 0),
				size = UDim2.new(0, 420, 0, 28),
				position = UDim2.new(1, 0, 0, 92),
				zindex = ui.basezindex + -5,
				color = Color3.fromRGB(46, 46, 46),
				visible = false,
				thickness = 0,
				filled = true,
				name = "okay",
			})
			ui.startWatermark = false
			ui.objects.watermarktextobjects = {}
			local textobjs = 56
			for i = 1, textobjs do
				ui.objects.watermarktextobjects[i] = utilities:draw("text", {
					parent = ui.objects.watermarkback,
					anchorpoint = Vector2.new(0, 0.5),
					size = 13, -- x3
					font = Drawing.Fonts.Plex,
					position = UDim2.new(0, 8 + ((i - 1) * 7), 0.5, 0),
					zindex = ui.basezindex + -4,
					color = Color3.fromRGB(255, 255, 255),
					visible = true,
					outline = false,
					text = " ",
					name = "okay",
				})
			end

			local statss = {
				framespersec = 0,
				memusage = math.floor(stats:GetTotalMemoryUsageMb()),
				instancecount = stats.InstanceCount,
			}

			runservice.RenderStepped:Connect(function()
				statss.framespersec = statss.framespersec + 1
			end)

			local lastthing = tick()
			local lastcolor = tick()
			local wmtext = ""
			local textthing = ""
			local hue = 0
			runservice.RenderStepped:Connect(function(dt)
				local result = ui.startWatermark and ui.flags.watermark and ui.flags.watermark.value or false
				if ui.objects.watermarkback.visible ~= result then
					ui.objects.watermarkback.visible = result
				end

				if ui.objects.watermarkback.visible == false then return end

				local gayresult = UDim2.new(1, 0, 0, ui.flags.watermarkoffset and ui.flags.watermarkoffset.value or 256)
				if ui.objects.watermarkback.position ~= gayresult then
					ui.objects.watermarkback.position = gayresult
				end

				if tick() - lastthing > 1 then -- optimized$$$$$
					lastthing = tick()
					statss.memusage = math.floor(stats:GetTotalMemoryUsageMb())
					statss.instancecount = stats.InstanceCount
					wmtext = "vader haxx" .. " | " .. statss.framespersec .. " fps | " .. statss.memusage .. " mb | " .. statss.instancecount .. " objects"
					statss.framespersec = 0
				end
				hue = hue + (dt * 20) -- el speed$$
				textthing = wmtext:split("")
			end)

			local addhue = 0
			for i = 1, textobjs do
				local v = ui.objects.watermarktextobjects[i]
				local thislast = tick()
				addhue = addhue + 1/360 -- now add a bit for the next fucken character
				runservice.Stepped:Connect(function(u, dt)
					if tick() - thislast < 1/20 then
						return
					end
					thislast = tick()
					if not textthing[i] then
						v.Drawingobject.Text = ""
						return
					end
					v.Drawingobject.Color = Color3.fromHSV(((addhue + hue / 60) + (i / 60)) % 1, 0.58, 1) -- fully saturated made it look pasted so i toned that down a notch
					v.Drawingobject.Text = textthing[i]
				end)
			end
		end
	end
	-- resizing setup
	do
		-- resizing function
		ui.objects.resizedetection.clicked:Connect(function()
			if not ui.uiopen then return end
			local connection connection = runservice.RenderStepped:Connect(function()
				if not ui.objects.resizedetection.holding then
					connection:Disconnect()
					connection = nil
					return
				end
				local final = Vector2.new(utilities.mouse.position.x - ui.objects.backborder.absoluteposition.x, utilities.mouse.position.y - ui.objects.backborder.absoluteposition.y)
				ui:setsize(final)
			end)
		end)

		ui.flags.resetuilayout.pressed:Connect(function()
			for tab, columns in next, ui.subsections do
				if tab ~= "players" then
					for column, panels in next, columns do
						for panel, data in next, panels do
							data.panelReposition.resetSide()
						end
					end
				end
			end
			for tab, columns in next, ui.subsections do
				if tab ~= "players" then
					for column, panels in next, columns do
						for panel, data in next, panels do
							data.panelReposition.resetPosition()
						end
					end
				end
			end
			for tab, columns in next, ui.subsections do
				if tab ~= "players" then
					for column, panels in next, columns do
						for panel, data in next, panels do
							data.panelResize.resetSize()
						end
					end
				end
			end
		end)
	end

	-- dragging setup
	do
		-- dragging function
		ui.objects.dragdetection.clicked:Connect(function()
			local relative = utilities.mouse.position - ui.objects.dragdetection.absoluteposition
			local connection connection = runservice.RenderStepped:Connect(function()
				if not ui.objects.dragdetection.holding then
					connection:Disconnect()
					connection = nil
					return
				end
				local result = Vector2.new(mouse.x, mouse.y + 36) - relative

				ui.objects.backborder.position = UDim2.new(result.x / camera.ViewportSize.x, 0, result.y / camera.ViewportSize.y, 0)
			end)
		end)
	end
	
	-- player list setup
	-- -sighs-
	-- hey guys, vader here, today we're getting depression (totally real)
	-- i love evie <3
	do
		local playerListTab = ui.tabs["players"]
		local playerMemory = {}
		ui.playerListRanks = {}
		ui.playerListStatus = playerMemory
		if playerListTab ~= nil then
			local reDrawPlayerList = function() end
			local playerFocused

			if isfile(cheat_path .. "/" .. game_path .. "/" .. "relations.json") then
				local oldMemory = readfile(cheat_path .. "/" .. game_path .. "/" .. "relations.json")
				local decoded = json.decode(oldMemory)

				for i, v in next, decoded do
					playerMemory[tonumber(i)] = v
				end
			end

			local currentlyShowing = {}
			local currentScrollLevel = 0
			local rows = {}

			ui:createsubsection({tab = "players", name = "options", length = 0.34, side = 1, ignoreScrolling = true, ignoreResizing = true, ignoreMoving = true})
			ui:createsubsection({tab = "players", name = "players", length = 0.66, side = 1, ignoreScrolling = true, ignoreResizing = true, ignoreMoving = true})

			local usernameText = ui.DrawingFunction("text", {
				parent = ui.subsections.players[1].options.container,
				anchorpoint = Vector2.new(0, 0),
				size = 13,
				font = Drawing.Fonts.Plex,
				position = UDim2.new(0, 16, 0, 10),
				zindex = ui.basezindex + 8,
				color = Color3.fromRGB(255, 255, 255),
				visible = true,
				outline = false,
				outlinecolor = Color3.fromRGB(12, 12, 12),
				text = "player: ",
				name = "okay",
			})
			ui.openclose[1 + #ui.openclose] = usernameText
			local nextIndex = 1 + #ui.elements["players"]["options"]
			ui.elements["players"]["options"][nextIndex] = {
				bounds = Vector2.new(0, 18)
			}   
			ui:createdropdown({tab = "players", subsection = "options", name = "status", flag = "playerlist_status", values = {{"neutral", true}, {"priority", false}, {"friendly", false}}, multichoice = false})
			ui:createbutton({tab = "players", subsection = "options", name = "copy profile", flag = "copyprofile", confirmation = true})
			ui:createbutton({tab = "players", subsection = "options", name = "votekick", flag = "votekick", confirmation = true})

			ui.flags.copyprofile.pressed:Connect(function()
				if playerFocused then
					setclipboard(string.format("https://web.roblox.com/users/%s/profile", playerFocused.UserId))
				end
			end)

			ui.flags.votekick.pressed:Connect(function()
				if playerFocused then
					getgenv().vaderhaxx.modules.cheat.networking.send("modcmd", string.format("/votekick:%s:cheats", playerFocused.Name))
				end
			end)

			ui.flags.playerlist_status.changed:Connect(function()
				local vals = ui.flags.playerlist_status.value
				if playerFocused then
					if not playerMemory[playerFocused.UserId] then
						playerMemory[playerFocused.UserId] = {}
					end
					local reference = playerMemory[playerFocused.UserId]
					reference.neutral = vals.neutral
					reference.priority = vals.priority
					reference.friendly = vals.friendly

					-- no need to save neutral players
					for i, v in next, playerMemory do
						if v.neutral then
							playerMemory[i] = nil
						end
					end

					local copied = {}
					for i, v in next, playerMemory do
						copied[tostring(i)] = v
					end

					if isfile(cheat_path .. "/" .. game_path .. "/" .. "relations.json") then
						writefile(cheat_path .. "/" .. game_path .. "/" .. "relations.json", json.encode(copied))
					end
				end
				reDrawPlayerList()
			end)

			-- width correction
			for i, v in next, {"players", "options"} do
				local size = ui.subsections.players[1][v].maincontainer.size
				ui.subsections.players[1][v].maincontainer.size = UDim2.new(1, 0, size.Height.Scale, 0)
			end
			ui.subsections.players[1]["players"].maincontainer.size = UDim2.new(1, 0, 0, ui.subsections.players[1]["players"].maincontainer.absolutesize.y)
			local mainHolder = {}
			mainHolder.outline = ui.DrawingFunction("frame", {
				parent = ui.directory.players.players,
				anchorpoint = Vector2.new(0.5, 0),
				size = UDim2.new(1, -16, 1, -20), -- what the FUCK?????
				position = UDim2.new(0.5, 0, 0, 12),
				zindex = ui.basezindex + 5,
				color = Color3.fromRGB(0, 0, 0),
				visible = true,
				thickness = 1,
				filled = false,
				name = "okay",
			})
			ui.openclose[1 + #ui.openclose] = mainHolder.outline

			mainHolder.container = ui.DrawingFunction("frame", {
				parent = mainHolder.outline,
				anchorpoint = Vector2.new(0.5, 0.5),
				size = UDim2.new(1, -2, 1, -2),
				position = UDim2.new(0.5, 0, 0.5, 0),
				zindex = ui.basezindex + 6,
				color = Color3.fromRGB(12, 12, 12),
				visible = true,
				thickness = 0,
				filled = true,
				name = "okay",
			})
			ui.openclose[1 + #ui.openclose] = mainHolder.container

			local eachSize = 48
			for i = 1, 8 do
				local thisRow = {}
				thisRow.outline = ui.DrawingFunction("frame", {
					parent = mainHolder.container,
					anchorpoint = Vector2.new(0.5, 0),
					size = UDim2.new(1, -2, 0, eachSize),
					position = UDim2.new(0.5, 0, 0, ((i - 1) * eachSize) + 2), -- the fuck is wrong with this shitty 1 pixel fix???
					zindex = ui.basezindex + 5,
					color = Color3.fromRGB(0, 0, 0),
					visible = true,
					thickness = 1,
					filled = false,
					name = "okay",
				})
				ui.openclose[1 + #ui.openclose] = thisRow.outline

				thisRow.container = ui.DrawingFunction("frame", {
					parent = thisRow.outline,
					anchorpoint = Vector2.new(0.5, 0.5),
					size = UDim2.new(1, -2, 1, -2),
					position = UDim2.new(0.5, 0, 0.5, 0),
					zindex = ui.basezindex + 6,
					color = Color3.fromRGB(21, 21, 21),
					visible = true,
					activated = true,
					thickness = 0,
					filled = true,
					name = "okay",
				})
				ui.openclose[1 + #ui.openclose] = thisRow.container

				thisRow.container.clicked:Connect(function()
					playerFocused = currentlyShowing[i]
					if playerFocused then
						usernameText.text = "player: " .. playerFocused.Name
						local status = {
							neutral = true,
							priority = false,
							friendly = false,
						}
						if playerMemory[playerFocused.UserId] then
							for i, v in next, playerMemory[playerFocused.UserId] do
								status[i] = v
							end
						end
						ui.flags.playerlist_status:setvalue(status)
						reDrawPlayerList()
					end
				end)    

				thisRow.avatarOutline = ui.DrawingFunction("frame", {
					parent = thisRow.container,
					anchorpoint = Vector2.new(0, 0.5),
					size = UDim2.new(0, 44, 0, 44),
					position = UDim2.new(0, 1, 0.5, 0),
					zindex = ui.basezindex + 7,
					color = Color3.fromRGB(16, 16, 16),
					visible = true,
					thickness = 1,
					filled = false,
					name = "okay",
				})
				ui.openclose[1 + #ui.openclose] = thisRow.avatarOutline

				thisRow.avatarImage = ui.DrawingFunction("image", {
					parent = thisRow.avatarOutline,
					anchorpoint = Vector2.new(0.5, 0.5),
					size = UDim2.new(1, -2, 1, -2),
					position = UDim2.new(0.5, 0, 0.5, 0),
					zindex = ui.basezindex + 8,
					visible = true,
					name = "okay",
				})
				ui.openclose[1 + #ui.openclose] = thisRow.avatarImage

				local charsUsed = 6
				thisRow.usernameText = ui.DrawingFunction("text", {
					parent = thisRow.container,
					anchorpoint = Vector2.new(0, 0.5),
					size = 13, -- x3
					font = Drawing.Fonts.Plex,
					position = UDim2.new(0, 4 + (7 * charsUsed), 0.5, -1),
					zindex = ui.basezindex + 7,   
					color = Color3.fromRGB(255, 255, 255),
					visible = true,
					outline = false,
					outlinecolor = Color3.fromRGB(12, 12, 12),
					text = "username text here 1",
					name = "okay",
				})
				ui.openclose[1 + #ui.openclose] = thisRow.usernameText

				charsUsed = charsUsed + 20

				thisRow.usernameDivideText = ui.DrawingFunction("text", {
					parent = thisRow.container,
					anchorpoint = Vector2.new(0, 0.5),
					size = 13, -- x3
					font = Drawing.Fonts.Plex,
					position = UDim2.new(0, 4 + (7 * charsUsed), 0.5, -1),
					zindex = ui.basezindex + 7,   
					color = Color3.fromRGB(255, 255, 255),
					visible = true,
					outline = false,
					outlinecolor = Color3.fromRGB(12, 12, 12),
					text = " | ",
					name = "okay",
				})
				ui.openclose[1 + #ui.openclose] = thisRow.usernameDivideText

				charsUsed = charsUsed + 3

				thisRow.rankText = ui.DrawingFunction("text", {
					parent = thisRow.container,
					anchorpoint = Vector2.new(0, 0.5),
					size = 13, -- x3
					font = Drawing.Fonts.Plex,
					position = UDim2.new(0, 4 + (7 * charsUsed), 0.5, -1),
					zindex = ui.basezindex + 7,   
					color = Color3.fromRGB(255, 255, 255),
					visible = true,
					outline = false,
					outlinecolor = Color3.fromRGB(12, 12, 12),
					text = "rank 9999",
					name = "okay",
				})
				ui.openclose[1 + #ui.openclose] = thisRow.rankText

				charsUsed = charsUsed + 7

				thisRow.rankDivideText = ui.DrawingFunction("text", {
					parent = thisRow.container,
					anchorpoint = Vector2.new(0, 0.5),
					size = 13, -- x3
					font = Drawing.Fonts.Plex,
					position = UDim2.new(0, 4 + (7 * charsUsed), 0.5, -1),
					zindex = ui.basezindex + 7,   
					color = Color3.fromRGB(255, 255, 255),
					visible = true,
					outline = false,
					outlinecolor = Color3.fromRGB(12, 12, 12),
					text = " | ",
					name = "okay",
				})
				ui.openclose[1 + #ui.openclose] = thisRow.rankDivideText

				charsUsed = charsUsed + 3

				thisRow.statusText = ui.DrawingFunction("text", {
					parent = thisRow.container,
					anchorpoint = Vector2.new(0, 0.5),
					size = 13, -- x3
					font = Drawing.Fonts.Plex,
					position = UDim2.new(0, 4 + (7 * charsUsed), 0.5, -1),
					zindex = ui.basezindex + 7,   
					color = Color3.fromRGB(255, 70, 60),
					visible = true,
					outline = false,
					outlinecolor = Color3.fromRGB(12, 12, 12),
					text = "priority",
					name = "okay",
				})
				ui.openclose[1 + #ui.openclose] = thisRow.statusText

				charsUsed = charsUsed + 6

				thisRow.statusDivideText = ui.DrawingFunction("text", {
					parent = thisRow.container,
					anchorpoint = Vector2.new(0, 0.5),
					size = 13, -- x3
					font = Drawing.Fonts.Plex,
					position = UDim2.new(0, 4 + (7 * charsUsed), 0.5, -1),
					zindex = ui.basezindex + 7,   
					color = Color3.fromRGB(255, 255, 255),
					visible = true,
					outline = false,
					outlinecolor = Color3.fromRGB(12, 12, 12),
					text = " | ",
					name = "okay",
				})
				ui.openclose[1 + #ui.openclose] = thisRow.statusDivideText

				charsUsed = charsUsed + 3

				thisRow.teamText = ui.DrawingFunction("text", {
					parent = thisRow.container,
					anchorpoint = Vector2.new(0, 0.5),
					size = 13, -- x3
					font = Drawing.Fonts.Plex,
					position = UDim2.new(0, 4 + (7 * charsUsed), 0.5, -1),
					zindex = ui.basezindex + 7,
					color = Color3.fromRGB(119, 255, 60),
					visible = true,
					outline = false,
					outlinecolor = Color3.fromRGB(12, 12, 12),
					text = "team",
					name = "okay",
				})
				ui.openclose[1 + #ui.openclose] = thisRow.teamText

				rows[1 + #rows] = thisRow
			end
			local moderators = {}
			local function isPlayerInGroupAndRank(player, groupId, requiredRank)
				-- Check if the player is in the specified group
				local inGroup = false
			
				-- Get the player's groups asynchronously
				local success, groups = pcall(function()
					return player:GetGroupsAsync()
				end)
			
				if success then
					-- Loop through the player's groups to find the specified group
					for _, groupInfo in pairs(groups) do
						if groupInfo.Id == groupId then
							inGroup = true
							break
						end
					end
					
					-- If the player is in the group, check their rank
					if inGroup then
						-- Get the player's rank in the group
						local playerRank = player:GetRankInGroup(groupId)
						
						-- Check if the player's rank is equal to or greater than the required rank
						if playerRank and playerRank >= requiredRank then
							return true  -- Player is in the group and has the required rank
						end
					end
				end
			
				return false  -- Player is not in the group or doesn't have the required rank
			end
			local asyncwaiting = false
			function reDrawPlayerList()
				local plrs = {}
				for _, player in pairs(players:GetPlayers()) do
					if player == localplayer then
						continue
					end

					plrs[#plrs + 1] = player
				end
				coroutine.wrap(function()
					for _, player in pairs(players:GetPlayers()) do
						if player == localplayer then
							continue
						end
						
						if ui.imagecache[player.UserId] then
							continue
						end
						
						ui.imagecache[player.UserId] = base64.decode("/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/2wBDAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/wAARCAAqACoDAREAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD+X+gAoAKACgAoAKACgBCQASeABkn0AoA8tj8VeMtYivNY8N6LpMug2k9zFbrqFzPHqWrJZu0c8tqIswQK7o6wrNksRg7jkAA7vQNZt/EGj2OsWqvHDew+Z5UmPMhkVmjmhcjgtFKjoSOG27hwaANigAoAKAM7VdV03RrN73VryCytFIRpZ2wGd87Y0UAvJIwBIjjVnIDHGFJAB89x+KIdHivNH8N+MtMi0G7nuZbZ9Q0TW5NS0lL12knitGis/InVHd3habBBYdGySAeueBdS8LvpNtovh3VUvxpduFlWRZILxi8jNLcyW88cUgWWd2YsqGNC6pu5XIB3NABQAUAeXePfPj13wbevo2p63pmn3Gq3V5aadYtflZxbQx2Mrx8R7o5nLp5jrwrsgZlxQBa/4T2MdPBPjX/wQL/8kUAYkWoTa3478MalZeGfEGkJb2+r2uqXmpaSbOOaCWzL2kUkyNIrKk8bbfNZNruioSWIAB7FQAUAFABQAUAFABQAUAFABQAUAFABQAUAf//Z")
						
						if disableImageLoading then
							continue
						end
						
						local data, content
						local success, err = pcall(function()
							task.wait(math.random() * 2)
							data = game:HttpGetAsync("https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. player.UserId .. "&size=48x48&format=Png&isCircular=false")
						end)

						if not success then
							ui.imagecache[player.UserId] = nil
							continue
						end

						success, err = pcall(function()
							local decoded = json.decode(data)
							task.wait(math.random() * 2)
							content = game:HttpGetAsync(decoded.data[1].imageUrl)
							table.clear(decoded)
						end)
						
						if success then
							ui.imagecache[player.UserId] = content
						else
							ui.imagecache[player.UserId] = nil
						end
					end
				end)()
				table.clear(currentlyShowing)
				for i, v in next, plrs do
					local correspondingListIndex = i - currentScrollLevel
					local rowData = rows[correspondingListIndex]

					if not rowData then
						continue
					end

					if rowData.avatarImage.data ~= ui.imagecache[v.UserId] then
						rowData.avatarImage.data = ui.imagecache[v.UserId] or ""
					end

					rowData.usernameText.text = v.Name
					rowData.usernameText.color = Color3.fromRGB(255, 255, 255)

					local superUsers = pfModules.SuperUsers
					local isMod = moderators[v.UserId] or isPlayerInGroupAndRank(v, 1103278, 17827696)
					if not moderators[v.UserId] then
						moderators[v.UserId] = isMod
					end
					if isMod or superUsers and superUsers[v.UserId] then
						rowData.usernameText.color = Color3.fromRGB(255, 106, 79)
					end

					local ffs = ui.playerListRanks[v.Name]
					if ffs then
						rowData.rankText.text = "rank  " .. ui.playerListRanks[v.Name]
					else
						rowData.rankText.text = "rank  0"
					end

					local theirStatus = "neutral"
					if playerMemory[v.UserId] then
						for st, is in next, playerMemory[v.UserId] do
							if is == true then
								theirStatus = st
								break
							end
						end
					end
					rowData.statusText.text = theirStatus
					rowData.statusText.color = theirStatus == "neutral" and Color3.new(1, 1, 1) or theirStatus == "priority" and Color3.fromRGB(245, 239, 120) or Color3.fromRGB(120, 189, 245)

					rowData.teamText.text = v.TeamColor == localplayer.TeamColor and "team" or "enemy"
					rowData.teamText.color = v.TeamColor == localplayer.TeamColor and Color3.fromRGB(119, 255, 60) or Color3.fromRGB(255, 70, 60)

					currentlyShowing[correspondingListIndex] = v
				end
				for i = 1, 8 do
					local correspondingListIndex = i + currentScrollLevel

					if not plrs[correspondingListIndex] then
						local rowData = rows[i]

						rowData.avatarImage.data = ""

						rowData.usernameText.text = "-"
						rowData.rankText.text = "rank -"

						local theirStatus = "-"
						rowData.statusText.text = theirStatus
						rowData.statusText.color = Color3.new(1, 1, 1)

						rowData.teamText.text = "-"
						rowData.teamText.color = Color3.new(1, 1, 1)
						currentlyShowing[i] = nil
					end
				end
			end
			reDrawPlayerList()
			local last = 0
			runservice.Stepped:Connect(function()
				if tick() - last > 1/5 then
					last = tick()
					reDrawPlayerList()
				end
			end)

			utilities.mouse.scrollup:Connect(function()
				if utilities.mousechecks.inbounds(mainHolder.outline, utilities.mouse.position) and mainHolder.outline.Drawingobject.Visible then
					currentScrollLevel = math.max(currentScrollLevel - 1, 0)
				end
			end)
			utilities.mouse.scrolldown:Connect(function()
				if utilities.mousechecks.inbounds(mainHolder.outline, utilities.mouse.position) and mainHolder.outline.Drawingobject.Visible then
					currentScrollLevel = math.min(currentScrollLevel + 1, #(players:GetPlayers()) - 3)
				end
			end)

			players.PlayerRemoving:Connect(function(player)
				if ui.imagecache[player.UserId] then
					table.remove(ui.imagecache, player.UserId)
				end
			end)
		end
	end
	-- animation setup
	do
		-- setup ui animations
		ui:updatemenuanimations()
	end
end

-- keybinds list setup
local keybindsui
do
	local workspace                     = game:GetService("Workspace")
	local camera			            = workspace.CurrentCamera
	local stats                         = game:GetService("Stats")
	local runservice                    = game:GetService("RunService")
	local players                       = game:GetService("Players")
	local localplayer                   = players.LocalPlayer
	local mouse                         = localplayer:GetMouse()

	-- initiate key binds ui
	do
		local started = uilibrary:start({
			size = Vector2.new(200, 64),
			name = "vader haxx",
			basezindex = 10000,
			accent = Color3.fromRGB(255, 200, 69),
			colors = {
				a = Color3.fromRGB(0, 0, 0),
				b = Color3.fromRGB(56, 56, 56),
				c = Color3.fromRGB(46, 46, 46),
				d = Color3.fromRGB(12, 12, 12),
				e = Color3.fromRGB(21, 21, 21),
				f = Color3.fromRGB(84, 84, 84),
				g = Color3.fromRGB(54, 54, 54),
			},
			tabs = {
				"keybinds",
			}
		})
		keybindsui = started
	end
	-- dragging setup
	--do
	--    -- dragging function
	--    keybindsui.objects.dragdetection.clicked:Connect(function()
	--        local relative = utilities.mouse.position - keybindsui.objects.dragdetection.absoluteposition
	--        local connection connection = runservice.Stepped:Connect(function()
	--            if not keybindsui.objects.dragdetection.holding then
	--                connection:Disconnect()
	--                connection = nil
	--                return
	--            end
	--            local result = Vector2.new(mouse.x, mouse.y + 36) - relative
	--           
	--            keybindsui.objects.backborder.position = UDim2.new(result.x / camera.ViewportSize.x, 0, result.y / camera.ViewportSize.y, 0)
	--        end)
	--    end)
	--end

	-- key binds ui
	do
		keybindsui.objects.backborder.position = UDim2.new(0, 0, 0.5, 0)

		local keybinders = {}
		for i, v in next, ui.flags do -- oh god kill me please :skull:
			if v.type == "keybind" then
				keybinders[1 + #keybinders] = v
			end
		end

		local keytexts = {}
		for i = 1, #keybinders do
			local txt = utilities:draw("text", {
				parent = keybindsui.tabs["keybinds"],
				anchorpoint = Vector2.new(0, 0),
				size = 13, -- x3
				font = Drawing.Fonts.Plex,
				position = UDim2.new(0, -8, 0, ((i - 1) * 18) -12),
				zindex = keybindsui.tabs["keybinds"].zindex + 1,
				color = Color3.fromRGB(255, 255, 255),
				visible = false,
				outline = false,
				text = "",
				name = "okay",
			})
			keytexts[i] = txt
		end

		local function singlekeybindupdate()
			local currentkeys = {}
			for i2, v2 in next, keybinders do
				if v2.value == true then
					local parentthatleft = v2.parentflag
					if ui.flags[parentthatleft].value == true then
						currentkeys[1 + #currentkeys] = v2
					end
				end
			end
			local FUCKYOU = Vector2.new(200, 64)
			for i2, v2 in next, keytexts do
				v2.visible = false
			end
			for i2, v2 in next, currentkeys do
				local keynig = v2.key
				local keyastext = "NONE"
				if keynig and keynig ~= "NONE" then
					keyastext = string.sub(string.upper(keynig:sub(14)), 1, 5)
				end
				local thingtoshow = ""
				if v2.object == "enabled" then
					thingtoshow = v2.section .. ":" .. v2.activation
				else
					thingtoshow = v2.object .. ":" .. v2.activation
				end
				keytexts[i2].text = "[ " .. keyastext .. " ] " .. thingtoshow
				keytexts[i2].visible = true
				local xbound = keytexts[i2].absolutesize.x + 64 -- ????????????????????? bitch??
				FUCKYOU = FUCKYOU + Vector2.new(xbound > FUCKYOU.x and xbound - FUCKYOU.x or 0, 18)
			end
			keybindsui:setsize(FUCKYOU)
		end

		local oldcreatekeybind = ui.createkeybind
		ui.createkeybind = function(self, ...)
			local arg = {...}
			local param = arg[1]
			local func = oldcreatekeybind(self, ...)

			local flagRef = ui.flags[param.flag]

			flagRef.changed:Connect(function()
				singlekeybindupdate()
			end)
			ui.flags[flagRef.parentflag].changed:Connect(function()
				singlekeybindupdate()
			end)

			keybinders[1 + #keybinders] = flagRef

			local txt = utilities:draw("text", {
				parent = keybindsui.tabs["keybinds"],
				anchorpoint = Vector2.new(0, 0),
				size = 13, -- x3
				font = Drawing.Fonts.Plex,
				position = UDim2.new(0, -8, 0, ((#keytexts - 1) * 18) -12),
				zindex = keybindsui.tabs["keybinds"].zindex + 1,
				color = Color3.fromRGB(255, 255, 255),
				visible = false,
				outline = false,
				text = "",
				name = "okay",
			})
			keytexts[1 + #keytexts] = txt
			return func
		end

		for i, v in next, keybinders do
			v.changed:Connect(function()
				singlekeybindupdate()
			end)
			ui.flags[v.parentflag].changed:Connect(function()
				singlekeybindupdate()
			end)
		end

		singlekeybindupdate()

		keybindsui.objects.backborder.visible = false
		ui.flags.keybinds.changed:Connect(function()
			keybindsui.objects.backborder.visible = ui.flags.keybinds.value
			singlekeybindupdate()
		end)
	end
end
-- accent colors
do
	ui.oldaccent = ui.accent
	ui.updatecolors = {}
	local savedColors = {}
	for i, v in next, ui.startingParameters.colors do
		savedColors[i] = v
	end
	for i, v in next, ui.startingParameters.colors do
		ui.updatecolors[i] = function()
			local targetColor = ui.flags["uicolor" .. i].value and ui.flags["uicolorpicker" .. i].color or savedColors[i]
			for k, menuObject in next, {ui, keybindsui} do
				for i, v in next, menuObject.colorGroups[i] do
					v.color = targetColor
				end
			end
			ui.startingParameters.colors[i] = targetColor
		end
	end
	ui.updateaccent = function()
		if not ui.uiopen then
			return
		end 

		if ui.flags.uiaccent.value then
			ui.accent = ui.flags.uiaccentcolor.color
		else
			ui.accent = ui.oldaccent
		end
		for k, menuObject in next, {ui, keybindsui} do
			for i, v in next, (menuObject.accents) do
				if v.color then -- this is an object, not a table
					v.color = ui.accent
				else
					if v[2] == "tabs" or v[2] == "sliders" then
						if v[2] == "tabs" then
							for i2, v2 in next, (v[1]) do
								v2.color = ui.accent:lerp(Color3.fromRGB(math.clamp((ui.accent.r * 255) - 100, 0, 255), math.clamp((ui.accent.g * 255) - 100, 0, 255), math.clamp((ui.accent.b * 255) - 100, 0, 255)), (i2 - 1) / #v)
							end
						else
							for i2, v2 in next, (v[1]) do
								v2.color = ui.accent:lerp(Color3.fromRGB(math.clamp((ui.accent.r * 255) - 5, 0, 255), math.clamp((ui.accent.g * 255) - 5, 0, 255), math.clamp((ui.accent.b * 255) - 5, 0, 255)), (i2 - 1) / (#v - 1))
							end
						end
					else
						for i2, v2 in next, (v) do
							v2.color = ui.accent:lerp(Color3.fromRGB(math.clamp((ui.accent.r * 255) - 30, 0, 255), math.clamp((ui.accent.g * 255) - 30, 0, 255), math.clamp((ui.accent.b * 255) - 30, 0, 255)), (i2 - 1) / (#v - 1))
						end
					end
				end
			end
		end
	end
end

-- import the janitor
do
	-- Compiled with L+ C Edition
	-- Janitor
	-- Original by Validark
	-- Modifications by pobammer
	-- roblox-ts support by OverHash and Validark
	-- LinkToInstance fixed by Elttob.
	-- Cleanup edge cases fixed by codesenseAye.

	local GetPromiseLibrary = function() return false end
		--[[ 	A wrapper for an `RBXScriptConnection`. Makes the Janitor clean up when the instance is destroyed. This was created by Corecii.  	@class RbxScriptConnection ]] 
        local RbxScriptConnection = {} 
        RbxScriptConnection.Connected = true 
        RbxScriptConnection.__index = RbxScriptConnection  
        --[[ 	@prop Connected boolean 	@within RbxScriptConnection  	Whether or not this connection is still connected.  	Disconnects the signal. ]] 
        function RbxScriptConnection:Disconnect() 	
            if self.Connected then 		
                self.Connected = false 		
                self.Connection:Disconnect() 	
            end 
        end  
        function RbxScriptConnection._new(RBXScriptConnection: RBXScriptConnection) 	
            return setmetatable({ 		
                Connection = RBXScriptConnection 	
            }, RbxScriptConnection) 
        end  
        function RbxScriptConnection:__tostring() 	
            return "RbxScriptConnection" 
        end  
		local function Symbol(Name: string) 	
            local self = newproxy(true) 	
            local Metatable = getmetatable(self) 	

            function Metatable.__tostring() 		
                return Name 	
            end  	

            return self 
        end  

	local FoundPromiseLibrary, Promise = GetPromiseLibrary()

	local IndicesReference = Symbol("IndicesReference")
	local LinkToInstanceIndex = Symbol("LinkToInstanceIndex")

	local INVALID_METHOD_NAME = "Object is a %s and as such expected `true` for the method name and instead got %s. Traceback: %s"
	local METHOD_NOT_FOUND_ERROR = "Object %s doesn't have method %s, are you sure you want to add it Traceback: %s"
	local NOT_A_PROMISE = "Invalid argument #1 to 'Janitor:AddPromise' (Promise expected, got %s (%s)) Traceback: %s"

    --[[
        Janitor is a light-weight, flexible object for cleaning up connections, instances, or anything. This implementation covers all use cases,
        as it doesn't force you to rely on naive typechecking to guess how an instance should be cleaned up.
        Instead, the developer may specify any behavior for any object.

        @class Janitor
    ]]
	local Janitor = {}
	Janitor.ClassName = "Janitor"
	Janitor.CurrentlyCleaning = true
	Janitor[IndicesReference] = nil
	Janitor.__index = Janitor

    --[[
        @prop CurrentlyCleaning boolean
        @within Janitor

        Whether or not the Janitor is currently cleaning up.
    ]]

	local TypeDefaults = {
		["function"] = true,
		thread = true,
		RBXScriptConnection = "Disconnect"
	}

    --[[
        Instantiates a new Janitor object.
        @return Janitor
    ]]
	function Janitor.new()
		return setmetatable({
			CurrentlyCleaning = false,
			[IndicesReference] = nil
		}, Janitor)
	end

    --[[
        Determines if the passed object is a Janitor. This checks the metatable directly.

        @param Object any -- The object you are checking.
        @return boolean -- `true` if `Object` is a Janitor.
    ]]
	function Janitor.Is(Object: any): boolean
		return type(Object) == "table" and getmetatable(Object) == Janitor
	end

	function Janitor:Add(Object: T, MethodName: StringOrTrue, Index: any): T
		if Index then
			self:Remove(Index)

			local This = self[IndicesReference]
			if not This then
				This = {}
				self[IndicesReference] = This
			end

			This[Index] = Object
		end

		local TypeOf = typeof(Object)
		local NewMethodName = MethodName or TypeDefaults[TypeOf] or "Destroy"

		if TypeOf == "function" or TypeOf == "thread" then
			if NewMethodName ~= true then
				--warn(string.format(INVALID_METHOD_NAME, TypeOf, tostring(NewMethodName), debug.traceback(nil, 2)))
			end
		else
			if not (Object)[NewMethodName] then
				--warn(string.format(METHOD_NOT_FOUND_ERROR, tostring(Object), tostring(NewMethodName), debug.traceback(nil, 2)))
			end
		end

		self[Object] = NewMethodName
		return Object
	end

	function Janitor:AddPromise(PromiseObject)
		if FoundPromiseLibrary then
			if not Promise.is(PromiseObject) then
				error(string.format(NOT_A_PROMISE, typeof(PromiseObject), tostring(PromiseObject), debug.traceback(nil, 2)))
			end

			if PromiseObject:getStatus() == Promise.Status.Started then
				local Id = newproxy(false)
				local NewPromise = self:Add(Promise.new(function(Resolve, _, OnCancel)
					if OnCancel(function()
							PromiseObject:cancel()
						end) then
						return
					end

					Resolve(PromiseObject)
				end), "cancel", Id)

				NewPromise:finallyCall(self.Remove, self, Id)
				return NewPromise
			else
				return PromiseObject
			end
		else
			return PromiseObject
		end
	end

	function Janitor:Remove(Index: any)
		local This = self[IndicesReference]

		if This then
			local Object = This[Index]

			if Object then
				local MethodName = self[Object]

				if MethodName then
					if MethodName == true then
						if type(Object) == "function" then
							Object()
						else
							task.cancel(Object)
						end
					else
						local ObjectMethod = Object[MethodName]
						if ObjectMethod then
							ObjectMethod(Object)
						end
					end

					self[Object] = nil
				end

				This[Index] = nil
			end
		end

		return self
	end

	function Janitor:RemoveList(...)
		local This = self[IndicesReference]
		if This then
			local Length = select("#", ...)
			if Length == 1 then
				return self:Remove(...)
			else
				for Index = 1, Length do
					-- MACRO
					local Object = This[select(Index, ...)]
					if Object then
						local MethodName = self[Object]

						if MethodName then
							if MethodName == true then
								if type(Object) == "function" then
									Object()
								else
									task.cancel(Object)
								end
							else
								local ObjectMethod = Object[MethodName]
								if ObjectMethod then
									ObjectMethod(Object)
								end
							end

							self[Object] = nil
						end

						This[Index] = nil
					end
				end
			end
		end

		return self
	end

	function Janitor:Get(Index: any): any
		local This = self[IndicesReference]
		return (This) and (This[Index]) or (nil)
	end

	local function GetFenv(self)
		return function()
			for Object, MethodName in next, self do
				if Object ~= IndicesReference then
					return Object, MethodName
				end
			end
		end
	end

	function Janitor:Cleanup()
		if not self.CurrentlyCleaning then
			self.CurrentlyCleaning = nil

			local Get = GetFenv(self)
			local Object, MethodName = Get()

			while Object and MethodName do -- changed to a while loop so that if you add to the janitor inside of a callback it doesn't get untracked (instead it will loop continuously which is a lot better than a hard to pindown edgecase)
				if MethodName == true then
					if type(Object) == "function" then
						Object()
					else
						task.cancel(Object)
					end
				else
					local ObjectMethod = Object[MethodName]
					if ObjectMethod then
						ObjectMethod(Object)
					end
				end

				self[Object] = nil
				Object, MethodName = Get()
			end

			local This = self[IndicesReference]
			if This then
				table.clear(This)
				self[IndicesReference] = {}
			end

			self.CurrentlyCleaning = false
		end
	end

	function Janitor:Destroy()
		self:Cleanup()
		table.clear(self)
		setmetatable(self, nil)
	end

	Janitor.__call = Janitor.Cleanup

	function Janitor:LinkToInstance(Object: Instance, AllowMultiple: boolean): RBXScriptConnection
		local IndexToUse = AllowMultiple and newproxy(false) or LinkToInstanceIndex

		return self:Add(Object.Destroying:Connect(function()
			self:Cleanup()
		end), "Disconnect", IndexToUse)
	end

	function Janitor:LegacyLinkToInstance(Object: Instance, AllowMultiple: boolean): RbxScriptConnection
		local Connection
		local IndexToUse = AllowMultiple and newproxy(false) or LinkToInstanceIndex
		local IsNilParented = Object.Parent == nil
		local ManualDisconnect = setmetatable({}, RbxScriptConnection)

		local function ChangedFunction(_DoNotUse, NewParent)
			if ManualDisconnect.Connected then
				_DoNotUse = nil
				IsNilParented = NewParent == nil

				if IsNilParented then
					task.defer(function()
						if not ManualDisconnect.Connected then
							return
						elseif not Connection.Connected then
							self:Cleanup()
						else
							while IsNilParented and Connection.Connected and ManualDisconnect.Connected do
								task.wait()
							end

							if ManualDisconnect.Connected and IsNilParented then
								self:Cleanup()
							end
						end
					end)
				end
			end
		end

		Connection = Object.AncestryChanged:Connect(ChangedFunction)
		ManualDisconnect.Connection = Connection

		if IsNilParented then
			ChangedFunction(nil, Object.Parent)
		end

		Object = nil
		return self:Add(ManualDisconnect, "Disconnect", IndexToUse)
	end

	function Janitor:LinkToInstances(...)
		local ManualCleanup = Janitor.new()
		for _, Object in ipairs({...}) do
			ManualCleanup:Add(self:LinkToInstance(Object, true), "Disconnect")
		end

		return ManualCleanup
	end

	function Janitor:__tostring()
		return "Janitor"
	end

	table.freeze(Janitor)
	janitor = Janitor
end

-- pfmodules setup
do
	for i, v in getupvalue(getrenv().shared.require, 1)._cache do
		pfModules[i] = v.module or nil
	end
end

-- setup hooks modules
do
	hooks.list = {}
	hooks.janitor = janitor.new()

	function hooks.init()
		-- Add a cleanup function
		hooks.janitor:Add(function()
			-- Reverse every hook
			local list = hooks.list
			for i = 1, #list do
				list[i].reverse()
				list[i] = nil
			end
		end)
	end

	local proxy = function(func) 
		return function(...)
			return func(...);
		end
	end

	function hooks.replace(old, new)
		local hook = {
			new = new,
			old = old,
			pointer = old
		}

		-- Add functions to hook
		function hook.apply()
			hook.old = hookfunc(hook.pointer, function(...)
				return hook.new(...)
			end)
		end
		function hook.reverse()
			hook.old = hookfunc(hook.pointer, hook.old)
		end

		hook.apply()
		table.insert(hooks.list, hook)
		return hook
	end

	function hooks.trampoline(source, key, new)
		local hook = {
			new = new,
			key = key,
			old = source[key],
			source = source,
		}

		-- Add functions to hook
		function hook.apply()
			hook.source[hook.key] = hook.new
		end
		function hook.reverse()
			hook.source[hook.key] = hook.old
		end

		hook.apply()
		table.insert(hooks.list, hook)
		return hook
	end

	hooks.init()
end

-- math module
do
	function mathematics.truncateNumber(number, decimalPlaces)
		local d = 10^decimalPlaces
		return math.floor(number*d)/d
	end

	function mathematics.map(x, start0, stop0, start1, stop1)
		return (x - start0)/(stop0 - start0)*(stop1 - start1) + start1
	end

	function mathematics.safeUnit(vec, epsilon)
		--will safely unitize a vector3or2 if the magnitude is lower than epsilon (this function makes sure that it doesnt return nan)
		local magnitude = vec.magnitude
		if magnitude > (epsilon or 1e-10) then
			return vec/magnitude
		end
		return typeof(vec) == "Vector2" and emptyVec2 or emptyVec3
	end

	function mathematics.angleBetweenVector3(originCf, vec2)
		local directional = CFrame.new(originCf.p, originCf.p + vec2)
		local ang = Vector3.new(directional:ToOrientation()) - Vector3.new(originCf:ToOrientation())
		return ang.Magnitude
	end

	function mathematics.pitchYawToLookVec(pitch, yaw)
		local cx = math.cos(pitch)
		return newVec3(-cx*math.sin(yaw), math.sin(pitch), -cx*math.cos(yaw))
	end

	function mathematics.lookVecToPitchYaw(lookVec)
		local x, y, z = lookVec.x, lookVec.y, lookVec.z
		return math.atan2(y, (x*x + z*z)^0.5), math.atan2(-x, -z)
	end

	--Vector2s
	function mathematics.angleBetweenVector2(vec1, vec2)
		--trust me i hate arccos
		local ang = math.acos(mathematics.safeUnit(vec1):Dot(mathematics.safeUnit(vec2)))
		if ang < 0 then
			ang = tau - ang
		end
		return ang  
	end

	function mathematics.rotationMatrix(vec, angle)
		--https://en.wikipedia.org/wiki/Rotation_matrix
		local mag = vec.Magnitude
		vec = mathematics.safeUnit(vec)
		local co, si = math.cos(angle), math.sin(angle)
		local x, y = vec.x, vec.y
		return mathematics.safeUnit(newVec2(x*co - y*si, x*si + y*co))*mag
	end

	function mathematics.normalizeAngle(angle)
		return ((angle + pi) % (2*pi)) - pi
	end

	local fov
	local viewportX, viewportY
	local frustumYScale
	local frustumXScale
	local rScaleX, rScaleY

	local function refresh()
		viewportSize = camera.ViewportSize
		fov = camera.FieldOfView * toRad
		viewportX, viewportY = viewportSize.x, viewportSize.y
		frustumYScale = math.tan(fov/2)
		frustumXScale = viewportX/viewportY * frustumYScale
		rScaleX = (1 + frustumXScale*frustumXScale)^0.5
		rScaleY = (1 + frustumYScale*frustumYScale)^0.5
	end

	refresh()
	camera:GetPropertyChangedSignal("FieldOfView"):Connect(refresh)
	camera:GetPropertyChangedSignal("ViewportSize"):Connect(refresh)

	function mathematics.worldToViewportPoint(worldPosition, clampEdge, clampOffset)
		local projectedPosition = pointToObjectSpace(camera.CFrame, worldPosition)
		local pX, pY, pZ = projectedPosition.x, projectedPosition.y, -projectedPosition.z
		local screenX = viewportX * (0.5 + pX/(2*pZ*frustumXScale))
		local screenY = viewportY * (0.5 - pY/(2*pZ*frustumYScale))
		if not clampEdge then
			return newVec3(screenX, screenY, pZ), pZ > 0 and screenX >= 0 and screenX <= viewportX and screenY >= 0 and screenY <= viewportY
		end
		local onScreen = pZ > 0 and screenX >= 0 and screenX <= viewportX and screenY >= 0 and screenY <= viewportY
		if onScreen then
			return newVec3(screenX, screenY, pZ), true
		end
		local widthEdge, heightEdge = pX < 0 and clampOffset or viewportX - clampOffset, -pY < 0 and clampOffset or viewportY - clampOffset
		local m = 0.5*(pY*viewportX + pX*viewportY)
		local newY = (m - pY*widthEdge)/pX
		if newY > clampOffset and newY < (viewportY - clampOffset) then
			return newVec3(widthEdge, newY, pZ), false
		else
			return newVec3((m - pX*heightEdge)/pY, heightEdge, pZ), false
		end
	end


	function mathematics.worldToScreenPoint(pos)
		local cframe = camera.CFrame
		local v = camera.ViewportSize
		local vx, vy = v.X, v.Y

		local y_scale = math.tan(math.rad(camera.FieldOfView/2))
		local x_scale = y_scale*vx/vy
		local cx, cy, cz, rx, ux, bx, ry, uy, by, rz, uz, bz = cframe:GetComponents()
		local px, py, pz = pos.X, pos.Y, pos.Z
		local d = -bz*ry*ux + by*rz*ux + bz*rx*uy - bx*rz*uy - by*rx*uz + bx*ry*uz

		if d == 0 then
			return
		end

		local Px = (-((cz - pz)*(by*ux - bx*uy)) + bz*(cy*ux - py*ux - cx*uy + px*uy) + by*(cx - px)*uz + bx*(-cy + py)*uz)/d
		local Py = ((cz - pz)*(by*rx - bx*ry) + bz*(-cy*rx + py*rx + cx*ry - px*ry) + by*(-cx + px)*rz + bx*(cy - py)*rz)/d
		local Pz = (cz*ry*ux - pz*ry*ux - cy*rz*ux + py*rz*ux - cz*rx*uy + pz*rx*uy + cx*rz*uy - px*rz*uy + (cy*rx - py*rx + (-cx + px)*ry)*uz)/d


		local sx = vx*(0.5 + Px/(2*-Pz*x_scale))
		local sy = vy*(0.5 - Py/(2*-Pz*y_scale))

		local on_screen = -Pz > 0 and sx >= 0 and sx <= vx and sy >= 0 and sy <= vy

		return newVec3(sx, sy, -Pz), on_screen
	end

	--scales the camera's frustum size according to the radius, useful to know if a character is fully offscreen or no
	function mathematics.spherePoint(worldPosition, radius)
		local projectedPosition = pointToObjectSpace(camera.CFrame, worldPosition)
		local pX, pY, pZ = projectedPosition.x, projectedPosition.y, -projectedPosition.z
		local rX = rScaleX*radius
		local rY = rScaleY*radius
		return -pZ*frustumXScale < pX+rX and pX-rX < pZ*frustumXScale and -pZ*frustumYScale < pY+rY and pY-rY < pZ*frustumYScale and pZ > -radius
	end

	function mathematics.solveQuadratic(a0, a1, a2)
		local d2 = a1*a1 - 4*a2*a0
		if d2 < 0 then
			return
		else
			local d = d2^0.5
			if a1 >= 0 then
				return (-a1 - d)/(2*a2), (2*a0)/(-a1 - d)
			else
				return (2*a0)/(-a1 + d), (-a1 + d)/(2*a2)
			end
		end
	end

	function mathematics.solveTrajectory(initialPosition, gravityVector, targetPosition, bulletSpeed)
		local relativePosition = targetPosition - initialPosition
		local gravityVector = gravityVector * -1
		local t1, t2 = mathematics.solveQuadratic(dot3d(relativePosition, relativePosition), dot3d(relativePosition, gravityVector) - bulletSpeed*bulletSpeed, dot3d(gravityVector, gravityVector) * 0.25)
		if t1 and t1 > 0 then
			t1 = t1^0.5
			return gravityVector*0.5*t1 + relativePosition/t1, t1
		end
		if t2 and t2 > 0 then
			t2 = t2^0.5
			return gravityVector*0.5*t2 + relativePosition/t2, t2
		end
	end

	function mathematics.trajectory(origin, acceleration, target, speed, extra)
        local invertedAcc = -acceleration
        local targetOriginDiff = target - origin
        local a = invertedAcc:Dot(invertedAcc)
        local b = 4 * targetOriginDiff:Dot(targetOriginDiff)
        local c = 4 * (invertedAcc:Dot(targetOriginDiff) + speed * speed)
        local cam = c / (2 * a)
        local sqrtPart = math.sqrt(cam * (cam) - b / a)
        local time = math.sqrt((cam - sqrtPart < 0) and cam + sqrtPart or cam - sqrtPart)
        
        return invertedAcc * time / 2 + (extra or emptyVec3) + targetOriginDiff / time, time
    end

	function mathematics.raySphereIntersection(origin, direction, center, radius)
		local u = direction.Unit
		local p = origin - center

		local udp = u:Dot(p)
		local d = udp*udp - (p:Dot(p) - radius*radius)
		if d < 0 then
			return false
		end
		d = d^0.5
		local t0 = -udp - d
		local t1 = -udp + d

		return origin + direction*t0, origin + direction*t1
	end
end

-- hooking module
do
	local networkHookList = {}
	local networkListenerList = {}
	local realSend, realCall;

	function networking.send(request: string, ...)
		realSend.old(pfModules.NetworkClient, request, ...)
	end

	function networking.addHook(request: string, priority: number, callback)
		-- Get/create hooklist
		local hookList = networkHookList[request]
		if not hookList then
			hookList = {}
			networkHookList[request] = hookList
		end

		-- Insert callback into hooklist
		hookList[#hookList + 1] = {
			priority    = priority;
			callback    = callback;
			--traceback   = debug.traceback()
		}

		-- Sort hookList by priority
		table.sort(hookList, function(a, b)
			return a.priority > b.priority
		end)
	end

	-- lizzie's t key is extremely fucked rn x3
	-- tee hee
	function networking.addListener(request: string, priority: number, callback)
		-- Get/create hooklist
		local listenerList = networkListenerList[request]
		if not listenerList then
			listenerList = {}
			networkListenerList[request] = listenerList
		end

		-- Insert callback into hooklist
		listenerList[#listenerList + 1] = {
			priority    = priority;
			callback    = callback;
			--traceback   = debug.traceback()
		}

		-- Sort hookList by priority
		table.sort(listenerList, function(a, b)
			return a.priority > b.priority
		end)
	end 

	-- Actual network hook
	realSend = hooks.trampoline(pfModules.NetworkClient, "send", function(self, request, ...)
		-- Create args and pass them through callback
		local args = {...}
		local hookList = networkHookList[request]
		if hookList then
			-- Go through every hook in the list!
			for i = 1, #hookList do
				-- Attempt to call this hook's callback
				local hook = hookList[i]
				if hook.callback(args) then
					return nil
				end
			end
		end


		return realSend.old(self, request, unpack(args))
	end)

	-- Listetner hook x3 :3
	realCall = RemoteEvent.OnClientEvent:Connect(function(request, ...)
		local listenerList = networkListenerList[request]
		local args = {...}
		if listenerList then
			for i = 1, #listenerList do
				-- Attempt to call this hook's callback
				local hook = listenerList[i]
				if hook.callback(args) then
					return
				end

				--local success, error = pcall(hook.callback, args)
				--if not success then
				--    -- Are we really supposed to let the cheat crumble if one hook fails? No!
				--    warn(string.format(
				--        "Non-fatal error in hook for request \"%s\"\nError:%s\nTraceback:%s",
				--        request,
				--        error,
				--        hook.traceback
				--    ))
				--    continue
				--end

				--if error then
				--    return
				--end
			end
		end
	end)

	-- if ur feeling extra fruity make a hook module for it like the one above
	-- fine, i might rewrite the networking module or use my cw one
	-- but that can be done when ur not working on it x3
	-- x3
	-- LIZZIELIZZIELIZZIELIZZIELIZZIELIZZIELIZZIELIZZIELIZZIELIZZIELIZZIELIZZIELIZZIELIZZIELIZZIELIZZIELIZZIELIZZIELIZZIELIZZIELIZZIELIZZIELIZZIELIZZIELIZZIE
end

-- raycast module
do
	rayCaster.physicsIgnore = {workspace.Terrain, workspace.Players, workspace.Ignore, camera}

	function rayCaster.rayCast(origin, direction, ignoreListWorkingEnvironment, ignoreFunc, keepIgnoreListChanges, ignoreWater)
		local resultFinal
		local initialIgnoreListLength = #ignoreListWorkingEnvironment

		local params = RaycastParams.new()
		params.FilterDescendantsInstances = ignoreListWorkingEnvironment
		params.IgnoreWater = ignoreWater and true or false

		while true do
			local result = rayCast(workspace, origin, direction, params)
			if ignoreFunc and result and ignoreFunc(result.Instance) then
				ignoreListWorkingEnvironment[#ignoreListWorkingEnvironment+1] = result.Instance
				params.FilterDescendantsInstances = ignoreListWorkingEnvironment
			else
				resultFinal = result
				break
			end
		end

		if not keepIgnoreListChanges then
			for i = #ignoreListWorkingEnvironment, initialIgnoreListLength + 1, -1 do
				ignoreListWorkingEnvironment[i] = nil
			end
		end

		return resultFinal
	end

	function rayCaster.raycastSingleExit(origin, direction, part)
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Whitelist
		params.FilterDescendantsInstances = {part}

		local resultFinal = rayCast(workspace, origin + direction, -direction, params)

		return resultFinal
	end

	function rayCaster.bulletIgnored(instance)
		return instance.CanCollide == false or instance.Transparency == 1
	end
end

-- heap module
do
	local function siftUp(heap, comp, idx)
		while idx > 1 do
			local parent = math.floor(idx*0.5)
			if not comp(heap[idx], heap[parent]) then
				break
			end
			heap[parent], heap[idx] = heap[idx], heap[parent]
			idx = parent
		end
	end
	local function siftDown(heap, comp, idx)
		local last = #heap
		while true do
			local min = idx
			local child = 2*idx

			for c = child, child + 1 do
				if c <= last and comp(heap[c], heap[min]) then
					min = c
				end
			end

			if min == idx then
				break
			end

			heap[idx], heap[min] = heap[min], heap[idx]
			idx = min
		end
	end

	function heap.newHeap(comp)
		local item = {}
		local ref = {}
		local this = {}
		local n = 0

		function this:insert(value)
			n = n + 1
			item[n] = value
			ref[value] = true
			if n > 1 then
				siftUp(item, comp, n)
			end
		end
		function this:pop()
			if n <= 0 then return nil end
			local value = item[1]
			item[1] = table.remove(item, n)
			ref[value] = nil
			n = n - 1
			if n > 0 then
				siftDown(item, comp, 1)
			end
			return value
		end
		function this:exist(value)
			return ref[value] ~= nil
		end
		function this:clear()
			table.clear(item)
			table.clear(ref)
		end
		function this:empty()
			return n == 0
		end

		return this
	end
end

-- pathfinding module
do
	local function manhattanDistance(a, b)
		--return m_abs(a.X - b.X) + m_abs(a.Y - b.Y) + m_abs(a.Z - b.Z)
		return (b - a).Magnitude
	end

	local function reconstructPath(list, current)
		local path = {current}
		local prev = list[current]
		while prev do
			table.insert(path, 1, prev)
			prev = list[prev]
		end
		return path
	end

	function pathfinding.canTraverse(origin, direction)
		local result = nil
		local param = RaycastParams.new()
		param.IgnoreWater = true
		local ignore_list = table.clone(rayCaster.physicsIgnore)
		local stop = false

		while not stop do
			param.FilterDescendantsInstances = ignore_list
			result = rayCast(workspace, origin, direction, param)
			if not result then return end
			local instance = result and result.Instance
			stop = instance and instance.CanCollide == true or false or instance and instance.Transparency == 1
			ignore_list[1 + #ignore_list] = instance
		end

		return result
	end

	function pathfinding.visualizePath(waypoints, c)
		local objects = {}
		for i = 1, #waypoints - 1 do
			local p0 = waypoints[i]
			local p1 = waypoints[i + 1]

			local part = Instance.new("Part")
			part.Size = newVec3(0.09, 0.09, (p1 - p0).Magnitude - 0.01)
			part.CFrame = CFrame.lookAt(p0 + (p1 - p0)*0.5, p1)
			part.Transparency = 0.4
			part.CanCollide = false
			part.Anchored = true
			part.Parent = workspace.Ignore
			local adorn = Instance.new("BoxHandleAdornment")
			adorn.Size = part.Size + newVec3(0.01, 0.01, 0.01)
			adorn.Adornee = part
			adorn.Color3 = c
			adorn.AlwaysOnTop = true
			adorn.ZIndex = 2
			adorn.Parent = localPlayer.PlayerGui
			table.insert(objects, part)
		end

		return function()
			for i = #objects, 1, -1 do
				local part = table.remove(objects, i)
				part:Destroy()
			end
		end
	end

	function pathfinding.lerpPos(start, goal, step)
		local waypoints = {}
		local dir = (goal - start)
		local mag = dir.Magnitude
		local unitDir = dir.unit
		local stepsRequired = mag / step
		local remainder = stepsRequired % 1
		local lerps = stepsRequired - remainder

		waypoints[1] = start

		for i = 1, lerps do
			waypoints[i + 1] = start:Lerp(goal, (i * step) / mag)
		end

		if remainder > 0 then
			waypoints[2 + lerps] = goal
		end
		return waypoints
	end

	function pathfinding.bestFirstSearch(origin, target, param)
		param = param or {}
		local max_dist = param.max_dist or 1/0
		local min_dist = param.min_dist or 1
		local step_dist = param.step_dist or 1
		local max_fails = param.max_fails or 1/0

		if (target - origin).Magnitude >= max_dist then
			return
		end

		local dir = (target - origin).Unit
		local fails = 0
		local list = {}

		local queue = heap.newHeap(function(a, b)
			return manhattanDistance(a, target) < manhattanDistance(b, target)
		end)
		local visited = {[origin] = true}
		local dir_list = {
			newVec3(0, 1, 0),
			newVec3(0, -1, 0),
			newVec3(1, 0, 0),
			newVec3(-1, 0, 0),
			newVec3(0, 0, -1),
			newVec3(0, 0, 1)
		}
		table.sort(dir_list, function(a, b)
			return a:Dot(dir) > b:Dot(dir)
		end)
		queue:insert(origin)

		while not queue:empty() do
			local current_node = queue:pop()
			local scanned_any = false
			for i = 1, 6 do
				local direction = dir_list[i]*step_dist
				local cast = pathfinding.canTraverse(current_node, direction)
				if not cast then
					local neighbor = current_node + direction
					if not visited[neighbor] then
						scanned_any = true
						list[neighbor] = current_node
						if manhattanDistance(target, neighbor) <= min_dist then
							return reconstructPath(list, neighbor)
						else
							visited[neighbor] = true
							queue:insert(neighbor)
						end
					end
				end                
			end
			if not scanned_any then
				fails = fails + 1
			end
			if fails >= max_fails then
				break
			end
		end
	end

	function pathfinding.floorBestFirstSearch(origin, target, param)
		param = param or {}
		local max_dist = param.max_dist or 1/0
		local min_dist = param.min_dist or 1
		local step_dist = param.step_dist or 1
		local max_fails = param.max_fails or 1/0

		if (target - origin).Magnitude >= max_dist then
			return
		end

		local dir = (target - origin).Unit
		local fails = 0
		local list = {}

		local queue = heap.newHeap(function(a, b)
			return manhattanDistance(a, target) < manhattanDistance(b, target)
		end)
		local visited = {[origin] = true}
		local dir_list = {
			newVec3(0, 1, 0),
			newVec3(0, -1, 0),
			newVec3(1, 0, 0),
			newVec3(-1, 0, 0),
			newVec3(0, 0, -1),
			newVec3(0, 0, 1)
		}
		table.sort(dir_list, function(a, b)
			return a:Dot(dir) > b:Dot(dir)
		end)
		queue:insert(origin)

		while not queue:empty() do
			local current_node = queue:pop()
			local scanned_any = false
			for i = 1, 6 do
				local direction = dir_list[i]*step_dist

				local proposed = direction + current_node
				local able = workspace:FindPartOnRayWithWhitelist(Ray.new(proposed, newVec3(0, -4, 0)), {workspace.Map}, true)
				if not able then -- spider hack
					for d, z in next, {newVec3(2, 0, 0), newVec3(-2, 0, 0), newVec3(0, 0, 2), newVec3(0, 0, -2)} do
						if not able then
							able = workspace:FindPartOnRayWithWhitelist(Ray.new(proposed, z), {workspace.Map}, true)
						end
					end
				end

				if able then
					local cast = pathfinding.canTraverse(current_node, direction)
					if not cast then
						local neighbor = current_node + direction
						if not visited[neighbor] then
							scanned_any = true
							list[neighbor] = current_node
							if manhattanDistance(target, neighbor) <= min_dist then
								return reconstructPath(list, neighbor)
							else
								visited[neighbor] = true
								queue:insert(neighbor)
							end
						end
					end
				end
			end
			if not scanned_any then
				fails = fails + 1
			end
			if fails >= max_fails then
				break
			end
		end
	end

	function pathfinding.vadAStar(param)
		local tries = 0
		local start = param.start
		local goal = param.goal

		local step = param.parameters.step or 5
		local maxTries = param.parameters.trials or 500
		local maxTime = param.parameters.maxtime
		local heuristicCoef = param.parameters.weighting or 1
		local sufficientDist = param.parameters.mindist or step/2

		local close = {}
		local open = {}
		local gScore = {}
		local fScore = {}
		local successors = {}
		local base_dirs = {
			newVec3(0, 1, 0),
			newVec3(0, -1, 0),
			newVec3(1, 0, 0),
			newVec3(-1, 0, 0),
			newVec3(0, 0, -1),
			newVec3(0, 0, 1)
		}

		for i, v in next, base_dirs do
			successors[1 + #successors] = v * step
		end

		local allsuccessors = #successors

		open[start] = {parents = 0, parent = start, fScore = highestNumber}
		gScore[start] = 0

		local started = tick()
		while true do
			local currentNode
			local nodeData

			local lowest = inf
			for node, dataNode in next, open do
				if dataNode.fScore < lowest then
					lowest, currentNode = dataNode.fScore, node
				end
			end
			nodeData = open[currentNode]

			if not nodeData then
				return
			end

			close[currentNode] = open[currentNode]
			open[currentNode] = nil

			local outOfTime = tick() - started > maxTime

			for i = 1, allsuccessors do
				local dir = successors[i]

				if dir ~= (nodeData.parent - currentNode) then
					local rayResult 
					local param = RaycastParams.new()
					param.IgnoreWater = true
					local ignore_list = {rayCaster.physicsIgnore}
					local stop

					while not stop do
						param.FilterDescendantsInstances = ignore_list
						rayResult = rayCast(workspace, currentNode, dir, param)
						if not rayResult then break end
						local instance = rayResult and rayResult.Instance
						stop = instance and instance.CanCollide and instance.Name ~= "Window" or nil
						ignore_list[1 + #ignore_list] = instance
					end

					if rayResult then
						tries+=1
					else
						local position = currentNode + dir
						local toGoalDistance = (goal - position).Magnitude
						local goalReached = toGoalDistance <= sufficientDist

						if not (tries >= maxTries) and not goalReached and not outOfTime then
							local g = gScore[currentNode] + step -- the cost of moving along this path
							local h = toGoalDistance * heuristicCoef
							local f = g + h -- g + h

							local existingG = gScore[position]
							if not existingG or g < existingG then
								local copied = {}

								copied.parents = nodeData.parents + 1
								copied.parent = currentNode
								copied.fScore = f

								open[position] = copied
								gScore[position] = g
							end
						else
							local stepsHere = (gScore[currentNode] / step) + 1

							local data = {
								distance = 0,
								waypoints = {},
								_tries = tries,
								_time = 0
							}

							data.endpoint = position

							local tothere = {}
							local reconstructed = {}

							table.insert(tothere, position)
							table.insert(tothere, currentNode)

							reconstructed[stepsHere] = position
							reconstructed[stepsHere - 1] = currentNode

							local waypoints = 2

							data.distance = step * 2

							for traceStep = 1, (nodeData.parents) do
								local thisIndex = tothere[waypoints]
								local nextClose = close[thisIndex]
								tothere[1 + #tothere] = nextClose.parent

								reconstructed[stepsHere - traceStep] = nextClose.parent

								data.distance = data.distance + step
								waypoints = waypoints + 1
							end

							data.waypoints = reconstructed
							data._tries = tries
							data._time = tick() - started
							return goalReached, data
						end
					end
				end
			end
		end
	end

	function pathfinding.floorAStar(param)
		local tries = 0
		local start = param.start
		local goal = param.goal

		local step = param.parameters.step or 5
		local maxTries = param.parameters.trials or 500
		local maxTime = param.parameters.maxtime
		local heuristicCoef = param.parameters.weighting or 1
		local sufficientDist = param.parameters.mindist or step/2

		local close = {}
		local open = {}
		local gScore = {}
		local successors = {}
		local base_dirs = {
			newVec3(0, 1, 0),
			newVec3(0, -1, 0),
			newVec3(1, 0, 0),
			newVec3(-1, 0, 0),
			newVec3(0, 0, -1),
			newVec3(0, 0, 1)
		}

		for i, v in next, base_dirs do
			successors[1 + #successors] = v * step
		end

		local allsuccessors = #successors

		open[start] = {parents = 0, parent = start, fScore = highestNumber}
		gScore[start] = 0

		local started = tick()
		while true do
			local currentNode
			local nodeData

			local lowest = inf
			for node, dataNode in next, open do
				if dataNode.fScore < lowest then
					lowest, currentNode = dataNode.fScore, node
				end
			end
			nodeData = open[currentNode]

			if not nodeData then
				return
			end

			close[currentNode] = open[currentNode]
			open[currentNode] = nil

			local outOfTime = tick() - started > maxTime

			for i = 1, allsuccessors do
				local dir = successors[i]

				if dir ~= (nodeData.parent - currentNode) then
					-- make sure we can move here at all without flying
					local proposed = dir + currentNode
					local able = workspace:FindPartOnRayWithWhitelist(Ray.new(proposed, newVec3(0, -4, 0)), {workspace.Map}, true)
					if not able then -- spider hack
						for d, z in next, {newVec3(2, 0, 0), newVec3(-2, 0, 0), newVec3(0, 0, 2), newVec3(0, 0, -2)} do
							if not able then
								able = workspace:FindPartOnRayWithWhitelist(Ray.new(proposed, z), {workspace.Map}, true)
							end
						end
					end

					if not able then
						continue
					end

					local rayResult
					local param = RaycastParams.new()
					param.IgnoreWater = true
					local ignore_list = {rayCaster.physicsIgnore}
					local stop

					while not stop do
						param.FilterDescendantsInstances = ignore_list
						rayResult = rayCast(workspace, currentNode, dir, param)
						if not rayResult then break end
						local instance = rayResult and rayResult.Instance
						stop = instance and instance.CanCollide and instance.Name ~= "Window" or nil
						ignore_list[1 + #ignore_list] = instance
					end

					if rayResult then
						continue
					end

					local position = currentNode + dir
					local toGoalDistance = (goal - position).Magnitude
					local goalReached = toGoalDistance <= sufficientDist

					if (tries >= maxTries) or goalReached or outOfTime then
						local stepsHere = (gScore[currentNode] / step) + 1

						local data = {
							distance = 0,
							waypoints = {},
							_tries = tries,
							_time = 0
						}

						data.endpoint = position

						local tothere = {}
						local reconstructed = {}

						table.insert(tothere, position)
						table.insert(tothere, currentNode)

						reconstructed[stepsHere] = position
						reconstructed[stepsHere - 1] = currentNode

						local waypoints = 2

						data.distance = step * 2

						for traceStep = 1, (nodeData.parents) do
							local thisIndex = tothere[waypoints]
							local nextClose = close[thisIndex]
							tothere[1 + #tothere] = nextClose.parent

							reconstructed[stepsHere - traceStep] = nextClose.parent

							data.distance = data.distance + step
							waypoints = waypoints + 1
						end

						data.waypoints = reconstructed
						data._tries = tries
						data._time = tick() - started
						return goalReached, data
					end
					local g = gScore[currentNode] + step -- the cost of moving along this path
					local h = toGoalDistance * heuristicCoef
					local f = g + h -- g + h

					local existingG = gScore[position]
					if not existingG or g < existingG then
						local copied = {}

						copied.parents = nodeData.parents + 1
						copied.parent = currentNode
						copied.fScore = f

						open[position] = copied
						gScore[position] = g
					end                               
				end
			end
		end
	end

	local function truncate(vec)
		return newVec3(math.floor(vec.X), math.floor(vec.Y), math.floor(vec.Z))
	end

	function pathfinding.intAStar(param)
		--TODO: FIXES THIS SHIT IT CAUSES DESPAWN
		local start = param.start--truncate(param.start)
		local goal = param.goal--truncate(param.goal)

		local step = param.parameters.step or 5
		local maxTries = param.parameters.trials or 500
		local maxTime = param.parameters.maxtime --Function calls n shit
		local heuristicCoef = param.parameters.weighting or 1
		local sufficientDist = param.parameters.mindist or step/2
		local gayMode = param.gay

		local came_from = {}
		local g_score = {[start] = 0}
		local f_score = {[start] = manhattanDistance(start, goal)}
		local open_set = heap.newHeap(function(a, b)
			local f_a = f_score[a] or 1/0
			local f_b = f_score[b] or 1/0
			return f_a < f_b
		end)
		open_set:insert(start)

		local directions_list = {
			newVec3(0, 1, 0),
			newVec3(0, -1, 0),
			newVec3(1, 0, 0),
			newVec3(-1, 0, 0),
			newVec3(0, 0, -1),
			newVec3(0, 0, 1)
		}

		local tries = 0
		local started = tick()
		while not open_set:empty() do
			local current = open_set:pop()
			if current == goal or (current - goal).Magnitude <= sufficientDist then
				local data = {
					distance = 0,
					waypoints = reconstructPath(came_from, current),
					_tries = tries,
					_time = 0
				}
				data.endpoint = current
				data.distance = #data.waypoints * step
				data._time = tick() - started
				return true, data
			elseif tick() - started > maxTime or tries > maxTries then
				break
			end
			for i = 1, 6 do
				local dir = directions_list[i]*step
				local neighbor = current + dir--truncate(current + dir)
				if pathfinding.canTraverse(current, neighbor - current) then
					tries += 1
					continue
				end
				local g = (g_score[current] or 1/0) + step
				if g < (g_score[neighbor] or 1/0) then
					came_from[neighbor] = current
					g_score[neighbor] = g
					f_score[neighbor] = (gayMode and 0 or g) + manhattanDistance(neighbor, goal)*(gayMode and 1 or heuristicCoef)
					if not open_set:exist(neighbor) then open_set:insert(neighbor) end
				end
			end
		end
	end

	function pathfinding.aStar(param)
		return pathfinding.vadAStar(param)
	end

	function pathfinding.optimizePath(path, step)
		local new_path = {}
		local current_idx = 1
		local path_amount = #path

		while current_idx <= path_amount - 1 do
			local origin_to_test = path[current_idx]
			for i = path_amount, current_idx + 1, -1 do
				local pos = path[i]
				if not pathfinding.canTraverse(origin_to_test, pos - origin_to_test) then
					local lerped = pathfinding.lerpPos(origin_to_test, pos, step)
					table.move(lerped, 1, #lerped, #new_path + 1, new_path)
					current_idx = i
					break
				end
			end
			current_idx += 1
		end

		return new_path
	end        
end

-- spring module
do
	-- skidded !
	local Spring = {}

	function Spring.new(initial, clock)
		local target = initial or 0
		clock = clock or os.clock
		return setmetatable({
			_clock = clock,
			_time0 = clock(),
			_position0 = target,
			_velocity0 = 0*target,
			_target = target,
			_damper = 1,
			_speed = 1
		}, Spring)
	end

	function Spring:Impulse(velocity)
		self.Velocity = self.Velocity + velocity
	end

	function Spring:TimeSkip(delta)
		local now = self._clock()
		local position, velocity = self:_positionVelocity(now+delta)
		self._position0 = position
		self._velocity0 = velocity
		self._time0 = now
	end

	function Spring:__index(index)
		if Spring[index] then
			return Spring[index]
		elseif index == "Value" or index == "Position" or index == "p" then
			local position, _ = self:_positionVelocity(self._clock())
			return position
		elseif index == "Velocity" or index == "v" then
			local _, velocity = self:_positionVelocity(self._clock())
			return velocity
		elseif index == "Target" or index == "t" then
			return self._target
		elseif index == "Damper" or index == "d" then
			return self._damper
		elseif index == "Speed" or index == "s" then
			return self._speed
		elseif index == "Clock" then
			return self._clock
		else
			error(("%q is not a valid member of Spring"):format(tostring(index)), 2)
		end
	end

	function Spring:__newindex(index, value)
		local now = self._clock()

		if index == "Value" or index == "Position" or index == "p" then
			local _, velocity = self:_positionVelocity(now)
			self._position0 = value
			self._velocity0 = velocity
			self._time0 = now
		elseif index == "Velocity" or index == "v" then
			local position, _ = self:_positionVelocity(now)
			self._position0 = position
			self._velocity0 = value
			self._time0 = now
		elseif index == "Target" or index == "t" then
			local position, velocity = self:_positionVelocity(now)
			self._position0 = position
			self._velocity0 = velocity
			self._target = value
			self._time0 = now
		elseif index == "Damper" or index == "d" then
			local position, velocity = self:_positionVelocity(now)
			self._position0 = position
			self._velocity0 = velocity
			self._damper = value
			self._time0 = now
		elseif index == "Speed" or index == "s" then
			local position, velocity = self:_positionVelocity(now)
			self._position0 = position
			self._velocity0 = velocity
			self._speed = value < 0 and 0 or value
			self._time0 = now
		elseif index == "Clock" then
			local position, velocity = self:_positionVelocity(now)
			self._position0 = position
			self._velocity0 = velocity
			self._clock = value
			self._time0 = value()
		else
			error(("%q is not a valid member of Spring"):format(tostring(index)), 2)
		end
	end

	function Spring:_positionVelocity(now)
		local p0 = self._position0
		local v0 = self._velocity0
		local p1 = self._target
		local d = self._damper
		local s = self._speed

		local t = s*(now - self._time0)
		local d2 = d*d

		local h, si, co
		if d2 < 1 then
			h = math.sqrt(1 - d2)
			local ep = math.exp(-d*t)/h
			co, si = ep*math.cos(h*t), ep*math.sin(h*t)
		elseif d2 == 1 then
			h = 1
			local ep = math.exp(-d*t)/h
			co, si = ep, ep*t
		else
			h = math.sqrt(d2 - 1)
			local u = math.exp((-d + h)*t)/(2*h)
			local v = math.exp((-d - h)*t)/(2*h)
			co, si = u + v, u - v
		end

		local a0 = h*co + d*si
		local a1 = 1 - (h*co + d*si)
		local a2 = si/s

		local b0 = -s*si
		local b1 = s*si
		local b2 = h*co - d*si

		return a0*p0 + a1*p1 + a2*v0, b0*p0 + b1*p1 + b2*v0
	end

	spring = Spring
end

-- signal module
do
	signal = utilities.signal
end

-- tickbase module
do
	tickbase.tickShift = 0
	tickbase.minTick = 0
	function tickbase:getMinimumTickBase()
		return tickbase.minTick or tickbase:getTickBase()
	end
	function tickbase:getTickBase()
		return pfModules.GameClock.getTime()-- + self.tickShift   
	end
	function tickbase:shift(time)
		self.tickShift = self.tickShift-- + time
		return pfModules.GameClock.getTime() --+ self.tickShift
	end
	tickbase.outGoingTickArgs = {
        equip = 2,
        newbullets = 3,
        bullethit = 6,
        knifehit = 4,
        newgrenade = 3,
        spotplayers = 2,
        updatesight = 3,
    }
	for request, arg in next, tickbase.outGoingTickArgs do
		networking.addHook(request, 0, function(args)
			args[arg] = tickbase:getTickBase()
			tickbase.minTick = args[arg]
		end)
	end
	networking.addHook("ping", 0, function(args)
		--[[if tickbase.tickShift ~= 0 then
			coroutine.wrap(function()
				task.wait()
				local waitTime = ui.flags.misc_evietickbypass.value and -80000 or -tickbase.tickShift
				for i, v in next, args do
					v = v + waitTime
				end
				networking.send("ping", unpack(args))
			end)()
			return true
		end]]
	end)
end

-- player information module
do
	-- local vars
	local repEvents = pfModules.ReplicationEvents
	local charTable = getupvalue(pfModules.ReplicationInterface.getEntry, 1)
	local statusEvents = pfModules.PlayerStatusEvents

	playerInfo.list = {}
	playerInfo.janitor = janitor.new()

	function playerInfo.init()
		-- Bind to entryadded connection
		playerInfo.janitor:Add(repEvents.onEntryAdded:Connect(playerInfo.track))
		playerInfo.janitor:Add(repEvents.onEntryRemoved:Connect(playerInfo.remove))

		-- Track existing players
		for player in next, charTable do
			playerInfo.track(player)
		end

		-- Update status of tracker on spawn and death
		playerInfo.janitor:Add(statusEvents.onPlayerSpawned:Connect(function(plr: Player, spawnPos: Vector3)
			local tracker = playerInfo.list[plr]
			if not (tracker) then
				return
			end

			-- update stats
			tracker.position = spawnPos
			tracker.alive = true
			tracker.health = 100
			tracker.velocity = Vector3.zero
			tracker.stance = "stand"
			tracker.aiming = false
			tracker.sprint = false

			-- use of .replicator here is okay because it's in the pinfo module
			tracker.character = tracker.replicator._thirdPersonObject._characterModelHash

			tracker.spawned:Fire()

			-- Insert updates
			tracker.updates[1 + #tracker.updates] = {
				position = spawnPos,
				angles = newVec2,
				time = pfModules.GameClock.getTime(),
				receivedTime = tick()
			}
		end))

		playerInfo.janitor:Add(statusEvents.onPlayerDied:Connect(function(plrdata: table)
			-- Get tracker
			local tracker = playerInfo.list[plrdata.victim]
			if not (tracker) then return end

			-- Update health & alive
			tracker.alive = false
			tracker.health = 0
			tracker.velocity = Vector3.zero
			tracker.stance = "stand"
			tracker.aiming = false
			tracker.sprint = false
			tracker.character = nil
			tracker.position = nil
			tracker.misses = 0

			for i, v in next, tracker.updates do
				table.clear(v)
			end

			table.clear(tracker.updates)

			tracker.died:Fire()
		end))
	end

	function playerInfo.track(plr: Player)
		local replicator = charTable[plr]
		if not replicator then return end

		local janitor = janitor.new()
		local newTracker = {
			plr = plr,
			janitor = janitor,
			character = replicator._thirdPersonObject and replicator._thirdPersonObject._characterModelHash,
			alive = replicator._alive,
			health = 100,
			position = emptyVec3,
			angles = emptyVec2,
			lastTick = 0,
			updates = {},
			velocity = emptyVec3,
			weapon = "???",
			rank = 0,
			resolving = false,
			exploiting = false,
			enemy = replicator._isEnemy, -- change
			violationLevel = 0,
			misses = 0,
			predictedDamage = 0,
			aiming = false,
			sprint = false,
			stance = "standing",
			replicator = replicator,
		}

		newTracker.spawned = signal.new()
		newTracker.died = signal.new()

		local repHook
		repHook = hooks.trampoline(replicator, "updateReplication", function(...)
			local oldPos, oldTime = newTracker.position, newTracker.lastTick
			repHook.old(...)
			local newPos, newAngles, newTime = replicator._receivedPosition, replicator._lookangles.p, replicator._receivedFrameTime
			newTracker.position, newTracker.angles, newTracker.lastTick = newPos, newAngles, newTime
			newTracker.updates[1 + #newTracker.updates] = {position = newPos, angles = newAngles, time = newTime, receivedTime = tick()}

			local deltaTick = newTime - oldTime
			if #newTracker.updates > 1 and (deltaTick < 1/180 or newTime == oldTime or deltaTick > 1 or newTime > (pfModules.GameClock.getTime() + 10)) then
				newTracker.exploiting, newTracker.violationLevel = true, math.clamp(newTracker.violationLevel + 10, 0, 1000)
			else
				newTracker.exploiting = false
			end
			
			if math.abs(newAngles.x) > (math.pi / 2) * 1.1 then
				newTracker.violationLevel = math.clamp(newTracker.violationLevel + 10, 0, 1000)
			end

			if #newTracker.updates > 2 then
				local lastRecieved = newTracker.updates[#newTracker.updates].receivedTime
				local lastLastRecieved = newTracker.updates[#newTracker.updates - 1].receivedTime
				local lastLastLastRecieved = newTracker.updates[#newTracker.updates - 2].receivedTime
				if lastRecieved - lastLastRecieved >= 3 or lastLastRecieved - lastLastLastRecieved >= 3 then
					newTracker.resolving = true
				else
					newTracker.resolving = false
					newTracker.misses = 0
					if ui.flags.rage_resolver.value and #newTracker.updates > 1 and not newTracker.resolving then
						local lerpFrom = newTracker.updates[#newTracker.updates - 1]
						local lerpTo = newTracker.updates[#newTracker.updates]
						local lerpedFor = 0
						local interpolateLoop; interpolateLoop = runService.Heartbeat:Connect(function(dt)
							if not (lerpTo.receivedTime and lerpFrom.receivedTime) then 
								return 
							end

							if not newTracker.alive or newTracker.resolving or lerpedFor >= lerpTo.receivedTime - lerpFrom.receivedTime then
								if newTracker.resolving then
									newTracker.replicator:resetSprings(newTracker.position)
								end
								interpolateLoop:Disconnect()
								interpolateLoop = nil
								return
							end
							replicator:resetSprings(lerpFrom.position:lerp(lerpTo.position, lerpedFor / (lerpTo.receivedTime - lerpFrom.receivedTime)))
							lerpedFor = lerpedFor + dt
						end)
					end
				end
			end
		end)

		local leaderBoardUpval = getupvalue(pfModules.LeaderboardInterface.addEntry, 1)
		local leaderBoardData = leaderBoardUpval[plr] and leaderBoardUpval[plr]._textMapping
		janitor:Add(runService.Stepped:Connect(function(uptime, delta)
			newTracker.health = replicator:getHealth()

			if replicator._thirdPersonObject and replicator._thirdPersonObject._stancespring and replicator._thirdPersonObject._aimspring and replicator._thirdPersonObject._sprintspring then
				newTracker.weapon, newTracker.stance, newTracker.aiming, newTracker.sprint =
					replicator._thirdPersonObject._weaponname,
				(replicator._thirdPersonObject._stancespring.t == 0 and "stand") or (replicator._thirdPersonObject._stancespring.t == 0.5 and "crouch") or "prone",
				(replicator._thirdPersonObject._aimspring.t == 1),
				(replicator._thirdPersonObject._sprintspring.t == 1)
			end

			newTracker.velocity = replicator._posspring.v

			if newTracker.alive and #newTracker.updates > 1 and tick() - newTracker.updates[#newTracker.updates].receivedTime > 1 then
				newTracker.exploiting, newTracker.violationLevel = true, math.clamp(newTracker.violationLevel + (10 * delta), 0, 1000)
			end

			if not newTracker.exploiting then
				newTracker.violationLevel = math.clamp(newTracker.violationLevel - ((1000 / 60) * delta), 0, 1000)
			end

			newTracker.enemy = replicator._isEnemy

			if not newTracker.alive then
				newTracker.misses = 0
			end

			if newTracker.resolving then
				newTracker.replicator:resetSprings(newTracker.position)
			end

			if leaderBoardData then
				newTracker.rank, ui.playerListRanks[plr.Name] = leaderBoardData.Rank.Text, newTracker.rank
			end
		end))

		playerInfo.list[plr] = newTracker
	end

	function playerInfo.remove(plr: Player)
		local tracker = playerInfo.list[plr]
		if not (tracker) then
			return
		end

		-- Remove tracker from list & clean up all of their connections
		playerInfo.list[plr] = nil 
		tracker.janitor:Cleanup()
	end

	-- init function exists because it looks nice
	playerInfo.init()
end

-- local info
do
	-- Ty gaslighter
	-- Local Variables
	local weaponCO = pfModules.WeaponControllerObject
	local weaponCI = pfModules.WeaponControllerInterface

	local oldSpawn
	local oldDespawn
	local oldSwapWeapon

	-- Methods
	function currentInfo.heldWeapon()
		local controller = weaponCI.getActiveWeaponController()
		return controller and controller._activeWeaponRegistry[controller._activeWeaponIndex] or nil
	end

	function currentInfo.getWeaponInfo()
		return weaponCI.getActiveWeaponController()
	end
end

-- legitbot
do
	local oldParticle; 
	local bulletBinds = {}

	legit.bulletBinds = bulletBinds
	legit.currentTarget = {}
	legit.hitGroups = {
		head = {"Head"},
		body = {"Torso"},
		arms = {"Left Arm", "Right Arm"},
		legs = {"Left Leg", "Right Leg"}
	}
	legit.previousAimPlayer = {
		player = localPlayer,
		tick = tick()
	}
	legit.originParams = RaycastParams.new()
	legit.originParams.FilterType = Enum.RaycastFilterType.Blacklist    

	legit.getEnemies = function()
		local plrList = playerInfo.list
		local enemyList = {} 
		for plr, data in next, plrList do
			-- stupid way of making sure they've finished spawning
			if data.alive and data.enemy and data.health > 0 and (data.character.Torso.Position - data.character.Head.Position).Magnitude < 3 then
				if ui.flags.misc_ignorefriendlies.value and ui.playerListStatus and ui.playerListStatus[data.plr.UserId] and ui.playerListStatus[data.plr.UserId].friendly == true then
				else
					if ui.flags.misc_onlypriorities.value then
						if ui.playerListStatus and ui.playerListStatus[data.plr.UserId] and ui.playerListStatus[data.plr.UserId].priority == true then
							enemyList[1 + #enemyList] = data
						end
					else
						enemyList[1 + #enemyList] = data
					end
				end
			end
		end

		return enemyList
	end
	legit.filterEnemies = function(enemies, maxFov, minFov, origin, originDirection)
		local enemyList = {}
		for plr, data in next, enemies do
			local char = data.character
			if char then
				local centerMass = char.Torso
				local lookAtEnemy = CFrame.new(origin, centerMass.Position).LookVector.unit
				local angle = toDeg * mathematics.angleBetweenVector3(CFrame.new(origin, origin + originDirection), lookAtEnemy)

				if angle < maxFov and angle > minFov then
					enemyList[plr] = data
				end
			end
		end

		return enemyList
	end
	legit.prioritizeEnemies = function(enemies, origin, originDirection, targetting)
		local sortList = {}
		local enemyList = {}

		if targetting == "closest" then
			for plr, data in next, enemies do
				local char = data.character
				local centerMass = char.Head
				local lookAtEnemy = centerMass.Position - origin
				local angle = toDeg * mathematics.angleBetweenVector3(CFrame.new(origin, origin + originDirection), lookAtEnemy)

				sortList[1 + #sortList] = {
					plr = data.plr,
					data = data,
					sort = angle
				}
			end
		else
			for plr, data in next, enemies do
				local char = data.character
				local centerMass = char.Head
				local lookAtMe = centerMass.CFrame.LookVector
				local angle = toDeg * mathematics.angleBetweenVector3(CFrame.new(origin, origin - originDirection), lookAtMe)

				sortList[1 + #sortList] = {
					plr = data.plr,
					data = data,
					sort = angle
				}
			end
		end

		table.sort(sortList, function(a, b)
			return a.sort < b.sort
		end)

		local withPriority = {}
		for i, data in next, sortList do
			if ui.playerListStatus and ui.playerListStatus[data.plr.UserId] and ui.playerListStatus[data.plr.UserId].priority == true then
				withPriority[1 + #withPriority] = data.data
				table.remove(sortList, i)
			end
		end
		for i, v in next, sortList do
			withPriority[1 + #withPriority] = v.data
		end

		return withPriority
	end
	legit.getScanPoints = function(enemy, hitboxes, origin, originDirection, accuracy, priority)
		local char = enemy.character
		local scanPoints = {}
		local hitParts = {}

		-- made to work with a list like this {head = true, body = false, arms = true, etc etc} (just like the dropdowns in vade hack ui lib)
		for i, v in next, hitboxes do
			local group = legit.hitGroups[i]
			if not group or not v then
				continue
			end
			for name, corresponding in next, group do
				local bodyPart = char[corresponding]
				if not bodyPart then
					continue
				end
				hitParts[1 + #hitParts] = bodyPart
			end
		end

		if math.random(100) <= accuracy then
			if priority["closest"] then
				local sortList = {}
				for i, part in next, hitParts do
					local toPart = CFrame.new(origin, part.Position).LookVector.unit
					local angle = toDeg * mathematics.angleBetweenVector3(CFrame.new(origin, origin + originDirection), toPart)

					sortList[1 + #sortList] = {
						part = part,
						angle = angle
					}
				end

				table.sort(sortList, function(a, b)
					return a.angle < b.angle
				end)

				for i = 1, #sortList do
					local instance = sortList[i].part
					scanPoints[1 + #scanPoints] = {
						part = instance,
						position = instance.Position
					}
				end
			else
				for i, v in next, priority do
					local group = legit.hitGroups[i]
					if not group or not v then
						continue
					end
					for name, corresponding in next, group do
						local priorityPart = char[corresponding]
						if not priorityPart then
							continue
						end
						if priorityPart then
							scanPoints[1 + #scanPoints] = {
								part = priorityPart,
								position = priorityPart.Position
							}
						end
					end
				end
			end
		end

		local notPriority = {}
		for i, part in next, hitParts do
			if part == priorityPart then
				continue
			end
			notPriority[1 + #notPriority] = part
		end

		local j, temp
		for i = #notPriority, 1, -1 do
			j = math.random(i)
			temp = notPriority[i]
			notPriority[i] = notPriority[j]
			notPriority[j] = temp
		end

		for i = 1, #notPriority do
			local part = notPriority[i]
			scanPoints[1 + #scanPoints] = {
				part = part,
				position = part.Position
			}
		end

		return scanPoints
	end
	legit.scan = function(scanPoints, origin, autowall)
		-- i can add a wallbang check to this later lolz
		local points = {}

		local heldWeapon = currentInfo.heldWeapon()

		if not heldWeapon then return end

		local heldWeaponStats = heldWeapon._weaponData
		local bulletAcceleration = pfModules.PublicSettings.bulletAcceleration
		local bulletSpeed = heldWeaponStats.bulletspeed
		local penetrationPower = autowall and heldWeaponStats.penetrationdepth or 0
		local simTime = 1/60

		for i, data in next, scanPoints do
			local part = data.part
			local position = data.position

			local trajectory, bulletTime = mathematics.solveTrajectory(origin, bulletAcceleration, position, bulletSpeed)

			if not bulletTime or not trajectory then
				continue
			end

			local canHit = pfModules.BulletCheck(origin, position, trajectory, bulletAcceleration, penetrationPower, simTime)

			if not canHit then
				continue
			end

			points[1 + #points] = {
				part        = part;
				position    = position;
				velocity    = trajectory;
			}
		end

		return points
	end
	-- highly pasted !
	legit.moveMouse = function(delta)
		local activeCamera = pfModules.CameraInterface.getActiveCamera("MainCamera")

		local coef = activeCamera._sensitivityMult * math.atan(math.tan(activeCamera._baseFov * (math.pi / 180) / 2) / 2.72 ^ activeCamera._magSpring.p) / (32 * math.pi)
		local x = activeCamera._angles.x - coef * delta.y
		x = x > activeCamera._maxAngle and activeCamera._maxAngle or x < activeCamera._minAngle and activeCamera._minAngle or x
		local y = activeCamera._angles.y - coef * delta.x
		local newangles = newVec3(x, y, 0)
		activeCamera._delta = newangles - activeCamera._angles
		activeCamera._angles = newangles
	end
	legit.getBarrel = function()
		-- I hate this but I better get used to it eh?
		local activeCamera = pfModules.CameraInterface.getActiveCamera("MainCamera")
		local cameraPos = activeCamera._cframe.p
		local currentGun = currentInfo.heldWeapon()
		local originCFrame = (currentGun:isAiming() and currentGun:getActiveAimStat("sightpart") or currentGun._barrelPart).CFrame

		-- Raycasting
		local raycastParams = legit.originParams
		raycastParams.FilterDescendantsInstances = { workspace.Players, workspace.Terrain, workspace.Ignore, workspace.CurrentCamera }
		local raycastResult = workspace:Raycast(cameraPos, originCFrame.Position - cameraPos, raycastParams)

		-- Calculate the final position4
		local finalPos = (raycastResult and raycastResult.Position) or originCFrame.Position
		local finalNormal = (raycastResult and raycastResult.Normal) or originCFrame.LookVector
		local ended = finalPos + 0.01 * finalNormal
		return CFrame.lookAt(ended, ended + originCFrame.LookVector)
	end
	--
	--    logic flowchart:
	--    do we have a target?
	--    if yes
	--        are we able to aim at it
	--        if yes
	--            aim at person
	--            return, preventing a new target from being found

	--    find a new target
	--

	-- Processors
	legit.processSilentAim = function(bulletArgs)
		-- No need to redirect the bullet, sorry nerd.
		if not ui.flags.legit_bulletredirection.value then
			return
		end

		-- Hitchance
		if math.random() > ui.flags.legit_bulletredirectionhitchance.value / 100 then
			return
		end

		-- Are we alive?
		local charObject = pfModules.CharacterInterface.getCharacterObject()
		if not charObject then
			return
		end

		-- Get local scanning data
		local activeCamera = pfModules.CameraInterface.getActiveCamera("MainCamera")
		local bulletOrigin = legit.getBarrel()

		-- held Weapon
		local heldWeapon = currentInfo.heldWeapon()

		local heldWeaponStats = heldWeapon._weaponData
		local bulletAcceleration = pfModules.PublicSettings.bulletAcceleration
		local bulletSpeed = heldWeaponStats.bulletspeed

		-- Get enemy pool and scan them all!
		local enemyPool = legit.getEnemies()
		local filteredPool = legit.filterEnemies(enemyPool, ui.flags.legit_bulletredirectionfov.value, 0, ui.flags.legit_silentbarrelfov.value and bulletOrigin.p or activeCamera._cframe.p, ui.flags.legit_silentbarrelfov.value and bulletOrigin.LookVector.unit or activeCamera._cframe.LookVector.unit)
		local prioritizedPool = legit.prioritizeEnemies(filteredPool, bulletOrigin.p, bulletOrigin.LookVector.unit, "closest")
		for plr, data in next, prioritizedPool do
			-- Get points to scan and resul of scan

			local scanPoints = legit.getScanPoints(data, ui.flags.legit_bulletredirectionpoints.value, bulletOrigin.p, bulletOrigin.LookVector.unit, 100, ui.flags.legit_bulletredirectionpriority.value)
			--if not ui.flags.legit_silentinstanthit.value then
			-- movement correction
			for i, pointData in next, scanPoints do
				local trajectory, bulletTime = mathematics.solveTrajectory(bulletOrigin.p, bulletAcceleration, pointData.position, bulletSpeed)
				pointData.position = pointData.position + (data.velocity * bulletTime)
			end
			--end

			-- fake spread
			for i, pointData in next, scanPoints do
				local fakeSpreadAmount = ui.flags.legit_bulletredirectiondeviation.value / 10
				local range = (pointData.position - bulletOrigin.p).Magnitude

				local fakeVec = {}
				for axis = 1, 3 do
					fakeVec[1 + #fakeVec] = math.random() * (math.random(2) == 2 and 1 or -1)
				end

				local fakeSpread = newVec3(unpack(fakeVec)).unit * (range / 100) * fakeSpreadAmount

				pointData.position = pointData.position + fakeSpread
			end

			-- gas is a niglet becuz the origin was supposed to always be locked to the barrel, this coon made it camera based if use barrel fov wasnt enabled (u can see it in semis vid ROFL)
			local hittablePoints = legit.scan(scanPoints, bulletOrigin.p, ui.flags.legit_bulletredirectionwallbang.value)
			local prioritizedPoint = hittablePoints and hittablePoints[1]
			if prioritizedPoint then
				-- Return formatted data
				return {
					part        = prioritizedPoint.part.Name;
					player      = plr;
					origin      = bulletOrigin.Position;
					hitpos      = prioritizedPoint.position;
					--instant     = ui.flags.legit_silentinstanthit.value;
					velocity    = prioritizedPoint.velocity;
				}
			end
		end
	end
	legit.processAimAssist = function(deltaTime)
		local charObject = pfModules.CharacterInterface.getCharacterObject()
		if not charObject then
			legit.currentTarget = {}
			return
		end

		-- as much as i hate how nested this is, i cba to make like 69 vars to see if the next step can be completed
		-- also as much as i could try to return this shit if a condition isnt met, that would really interfere with the logic
		-- i tried to make it relativly easy to follow tho so sorry!



		if legit.currentTarget and legit.currentTarget.player then
			local targetData = legit.currentTarget
			local enemy = targetData.pInfo
			if enemy.alive and enemy.enemy and enemy.health > 0 and (legit.currentTarget.player == legit.previousAimPlayer.player or tick() - legit.previousAimPlayer.tick > (ui.flags.legit_aimassistswitchdelay.value / 1000)) and (tick() - targetData.aimTick < (ui.flags.legit_aimassistlockontime.value / 1000) or ui.flags.legit_aimassistlockontime.value > 2000 or targetData.isMagnet) then
				local activeCamera = pfModules.CameraInterface.getActiveCamera("MainCamera")
				local camCf = camera.CFrame
				local bulletOrigin = legit.getBarrel()
				local heldWeapon = currentInfo.heldWeapon()
				local heldWeaponStats = heldWeapon._weaponData
				local bulletAcceleration = pfModules.PublicSettings.bulletAcceleration
				local bulletSpeed = heldWeaponStats.bulletspeed
				local isMagnet = targetData.isMagent

				local origin = camCf.p
				local originDirection = ui.flags.legit_aimassistbarrelfov.value and bulletOrigin.LookVector.unit or camCf.LookVector.unit

				-- a bit of manual work to skip doing getScanPoints, also ensures that the aim assist will keep aiming at the same hitbox and player until it cant anymore.
				-- saves some performace too!
				local result = legit.scan({{part = targetData.part, position = targetData.part.Position}}, origin, false)

				if result and result[1] then
					local aimTarget = result[1]

					local activation = ui.flags.legit_aimassistactivation.value

					if aimTarget then
						local aimPart = aimTarget.part
						local randomisation = ui.flags.legit_aimassistrandomisation.value
						local ranomisedPosition = aimTarget.position + newVec3(math.noise(time() * 0.1, 100) * randomisation, math.noise(time() * 0.1, 200) * randomisation, math.noise(time() * 0.1, 300) * randomisation)
						local aimPosition = camCf.p + (CFrame.new(camCf.p, ranomisedPosition).LookVector.unit) -- fixing it for the adjust for ... modules

						local movedBy = aimTarget.position
						if ui.flags.legit_movementcompensation.value then -- correct for moving targets
							local trajectory, bulletTime = mathematics.solveTrajectory(camCf.p, bulletAcceleration, aimTarget.position, bulletSpeed)
							local errorInCompensation = 1 + ((ui.flags.legit_movementtaccuracy.value / 100) * math.sin((1 + math.random()) * tick() + 2 * math.random()))
							local movingVelocity = enemy.velocity
							local compensatedPoint = aimTarget.position + (movingVelocity * bulletTime)
							movedBy = compensatedPoint
							aimPosition = camCf.p + ((CFrame.new(camCf.p, compensatedPoint).LookVector.unit * errorInCompensation).unit)
						end

						if ui.flags.legit_bulletcompensation.value then -- correct for bullet drop (voodoo shit)
							local trajectory, bulletTime = mathematics.solveTrajectory(camCf.p, bulletAcceleration, movedBy, bulletSpeed)
							local errorInCompensation = 1 + ((ui.flags.legit_bulletdropaccuracy.value / 100) * math.sin((1 + math.random()) * tick() + 2 * math.random()))
							aimPosition = camCf.p + ((camCf.LookVector.unit + ((trajectory.unit - camCf.LookVector.unit) * errorInCompensation)).unit)
						end

						if ui.flags.legit_barrelcompensation.value then -- correct for barrel angle (?????????????????????????????) (BROKEN ?!?!?!)
							local barrelVector = bulletOrigin.LookVector
							local errorInCompensation = 1 + ((ui.flags.legit_barrelaccuracy.value / 100) * math.sin((1 + math.random()) * tick() + 2 * math.random()))
							aimPosition = camCf.p + ((aimPosition - camCf.p).unit - (barrelVector.unit - camCf.LookVector.unit)).unit
						end

						local lockVector = CFrame.new(camCf.p, aimPosition).LookVector.unit

						local outsideDeadzone = true
						local posOnScreen, vis = camera:WorldToScreenPoint(aimPosition)
						posOnScreen = newVec2(posOnScreen.x, posOnScreen.y)

						local aimActive = isMagnet or ((activation["mouse 1"] == true and userInputService:IsMouseButtonPressed(0)) or (activation["mouse 2"] == true and userInputService:IsMouseButtonPressed(1)) or activation["always"] == true) and ui.uiopen == false

						if outsideDeadzone and (not ui.flags.legit_aimonmousemove.value or userInputService:GetMouseDelta().Magnitude > 0.01) and (not ui.flags.legit_aimonmousemoveatenemy.value or (legit.currentTarget.lastPosOnScreen and newVec2(posOnScreen.x - mouse.x, posOnScreen.y - mouse.y).Magnitude < newVec2(legit.currentTarget.lastPosOnScreen.x - mouse.x, legit.currentTarget.lastPosOnScreen.y - mouse.y).Magnitude)) and aimActive then
							local speed = ui.flags.legit_aimassistsmoothing.value
							if posOnScreen and vis then 
								legit.previousAimPlayer.player = legit.currentTarget.player
								legit.previousAimPlayer.tick = tick()

								if speed == 100 then
									local lockMove = newVec2(posOnScreen.x - mouse.x, posOnScreen.y - mouse.y)
									legit.moveMouse(lockMove * 1/20)
								else
									assistVector = newVec2(posOnScreen.x - mouse.x, posOnScreen.y - mouse.y) * deltaTime

									if ui.flags.legit_aimassistsmoothingtype.value["linear"] then
										local unitVec = assistVector.Unit
										local newVec = assistVector.Magnitude > assistVector.Magnitude and unitVec or assistVector / 50
										assistVector = newVec * speed
									else
										assistVector = assistVector * (speed / 25)
									end

									legit.moveMouse(assistVector)
								end
							end
						end
						legit.currentTarget.lastPosOnScreen = posOnScreen
						return
					end
				end
			end
		end

		legit.currentTarget = {}

		-- assuming we didnt aim for whatever reason, we get a new target
		if ui.flags.legit_aimassist.value then
			local enemyPool = legit.getEnemies()

			local activeCamera = pfModules.CameraInterface.getActiveCamera("MainCamera")
			local bulletOrigin = ui.flags.legit_aimassistbarrelfov.value and legit.getBarrel() or activeCamera._cframe
			local isMagnet = ui.flags.legit_triggerbot.value and ui.flags.legit_magnet.value and ui.flags.legit_triggerbotkey.value

			local activation = ui.flags.legit_aimassistactivation.value
			local aimActive = isMagnet or ((activation["mouse 1"] == true and userInputService:IsMouseButtonPressed(0)) or (activation["mouse 2"] == true and userInputService:IsMouseButtonPressed(1)) or activation["always"] == true) and ui.uiopen == false

			if not aimActive then
				return
			end

			--local filteredPool = legit.filterEnemies(enemyPool, isMagnet and ui.flags.legit_magnetfov.value or ui.flags.legit_aimassistfov.value, isMagnet and 0 or ui.flags.legit_aimassistdeadzonefov.value, bulletOrigin.p, bulletOrigin.LookVector.unit)
			local filteredPool = legit.filterEnemies(enemyPool, isMagnet and ui.flags.legit_magnetfov.value or ui.flags.legit_aimassistfov.value, 0, bulletOrigin.p, bulletOrigin.LookVector.unit)
			local prioritizedPool = legit.prioritizeEnemies(filteredPool, bulletOrigin.p, bulletOrigin.LookVector.unit, ui.flags.legit_aimassisttargpriority.value.closest and "closest" or "enemy look direction")
			for plr, data in next, prioritizedPool do
				local scanPoints = legit.getScanPoints(data, isMagnet and ui.flags.legit_triggerbotpoints.value or ui.flags.legit_aimassistpoints.value, bulletOrigin.p, bulletOrigin.LookVector.unit, isMagnet and 100 or ui.flags.legit_aimassistaccuracy.value, isMagnet and ui.flags.legit_magnetnpriority.value or ui.flags.legit_aimassistpriority.value)

				local result = legit.scan(scanPoints, bulletOrigin.p, false)
				if result and result[1] then
					legit.currentTarget.player = data.plr
					legit.currentTarget.pInfo = data
					legit.currentTarget.part = result[1].part
					legit.currentTarget.isMagnet = isMagnet
					legit.currentTarget.aimTick = tick()
					return
				end
			end
		end
	end

	-- this is really fucked but i didnt know a better way to do this
	legit.triggerPhysicalStorage = Instance.new("Folder", workspace.Ignore)
	legit.processTriggerBot = function(deltaTime)
		legit.triggerPhysicalStorage:ClearAllChildren()

		local charObject = pfModules.CharacterInterface.getCharacterObject()
		local heldWeapon = currentInfo.heldWeapon()
		if not charObject or not ui.flags.legit_triggerbot.value or not ui.flags.legit_triggerbotkey.value or not heldWeapon or heldWeapon:getWeaponType() == "Melee" then
			legit.triggerTarget = {}
			return
		end

		local simulateInstances
		local instantenous = (ui.flags.legit_triggerbotspeed.value == 0)

		if legit.triggerTarget and legit.triggerTarget.tick and ui.flags.legit_triggerbotspeed.value > 0 then
			if tick() - legit.triggerTarget.tick > ui.flags.legit_triggerbotspeed.value / 1000 then
				simulateInstances = {{legit.triggerTarget.pInfo, legit.triggerTarget.part}}
				instantenous = true
				legit.triggerTarget = {}
			else
				return
			end
		end

		if not simulateInstances then
			local allEnemies = legit.getEnemies()
			local enemyPool = {}
			for i, v in next, allEnemies do
				enemyPool[1 + #enemyPool] = v
			end
			if #enemyPool > 0 then
				simulateInstances = {}
			else
				legit.triggerTarget = {}
				return
			end
			for i, data in next, enemyPool do
				for group, toggled in next, ui.flags.legit_triggerbotpoints.value do
					if not toggled then
						continue
					end

					for e, name in next, legit.hitGroups[group] do
						local part = data.character[name]
						if part then
							simulateInstances[1 + #simulateInstances] = {data, part}
						end
					end
				end
			end
		end

		if not simulateInstances then
			return
		end

		-- dear god Invaded what did u do this time girl
		do
			local fakeInstances = {}
			local fakeHits = {}
			for i, v in next, simulateInstances do
				local plr = v[1]
				local part = v[2]

				local fakePart = Instance.new("Part")
				fakePart.Parent = legit.triggerPhysicalStorage
				fakePart.Anchored = true
				fakePart.CFrame = part.CFrame
				fakePart.Size = part.Size
				fakePart.Name = "fakeHit"
				fakePart.CanCollide = false
				fakePart.Transparency = 1
				fakePart.Velocity = emptyVec3

				fakeInstances[fakePart] = {
					pInfo = plr,
					part = part,
					startPos = part.Position
				}
				fakeHits[1 + #fakeHits] = fakePart
			end

			do
				local barrel = legit.getBarrel()
				local weaponData = heldWeapon._weaponData 

				local ignore_list = table.clone(rayCaster.physicsIgnore)
				local simulation_elapsed = 0
				local step_size = 1/30
				local bullet_position = barrel.p
				local bullet_velocity = barrel.LookVector.unit * weaponData.bulletspeed
				local penetration_remaining = ui.flags.legit_triggerbotautowall.value and weaponData.penetrationdepth or 0
				local acceleration = pfModules.PublicSettings.bulletAcceleration
				local landing_time = 1.5

				while simulation_elapsed < landing_time do
					local dt = math.min(step_size, landing_time - simulation_elapsed)
					local velocity = dt * bullet_velocity + dt * dt / 2 * acceleration
					local enter_cast = rayCaster.rayCast(bullet_position, velocity, ignore_list, rayCaster.bulletIgnored, true)

					do
						-- velocity fix
						for part, realData in next, fakeInstances do
							part.Position = realData.startPos + (realData.pInfo.velocity * simulation_elapsed)
						end

						-- check if we intersected
						local fakeHit, fakePos = workspace:FindPartOnRayWithWhitelist(Ray.new(bullet_position, (enter_cast and enter_cast.Position or (bullet_position + velocity)) - bullet_position), fakeHits)
						if fakeHit then
							local theirData = fakeInstances[fakeHit]
							if theirData then

								legit.triggerPhysicalStorage:ClearAllChildren()

								if instantenous then
									legit.triggerTarget = {}
									coroutine.wrap(function() -- are you fucking stupid??????????
										mouse1press()
										task.wait(1/60)
										mouse1release()
									end)()
								else
									legit.triggerTarget.pInfo = theirData.pInfo
									legit.triggerTarget.part = theirData.part
									legit.triggerTarget.tick = tick()
								end

								return
							end
						end
					end

					if not enter_cast then
						bullet_velocity += dt*acceleration
						bullet_position += velocity
						simulation_elapsed += dt
						continue
					end

					local instance = enter_cast.Instance
					local enter_pos = enter_cast.Position
					local vel_unit = velocity.Unit

					local exit_cast = rayCaster.raycastSingleExit(enter_pos, penetration_remaining*vel_unit, instance)

					if not exit_cast then
						break
					end

					local penetrated = vel_unit:Dot(exit_cast.Position - enter_pos)
					if penetrated > penetration_remaining then
						return
					end
					penetration_remaining -= penetrated
					if penetration_remaining <= 0 then
						return
					end

					local scaled_dt = velocity:Dot(enter_pos - bullet_position) / velocity:Dot(velocity) * dt
					bullet_position = enter_pos + 0.01 * (bullet_position - enter_pos).unit
					bullet_velocity += dt*acceleration
					simulation_elapsed += scaled_dt

					ignore_list[1 + #ignore_list] = instance
				end
			end

			legit.triggerPhysicalStorage:ClearAllChildren()
		end
	end
	runService.RenderStepped:Connect(function(dt)
		legit.processTriggerBot(dt)
	end)

	-- Particle hook
	oldParticle = hooks.replace(pfModules.BulletInterface.newBullet, function(bulletArgs)
		-- Is this my bullet?
		if not bulletArgs.thirdperson then
			-- Find networked data
			local boundData
			local networkedData
			for i, v in next, getstack(3) do
				-- Skip this index if it's not going to become a newbullets request
				if not (typeof(v) == "table" and typeof(v.camerapos) == "Vector3") then
					continue
				end

				-- Create bind & add bind to list if we haven't already
				networkedData = v
				break
			end

			-- Try to get a legit silent aim target
			local currentTarget = networkedData and legit.processSilentAim(bulletArgs) or nil
			if currentTarget then
				-- Create bind
				boundData = bulletBinds[networkedData]
				if not boundData then
					boundData = {
						part        = currentTarget.part;
						player      = currentTarget.player;
						origin      = currentTarget.origin;
						hitpos      = currentTarget.hitpos;
						instant     = currentTarget.instant;
						velocity    = currentTarget.velocity;
					}
					
					bulletBinds[networkedData] = boundData
				end

				-- Modify data
				bulletArgs.position = boundData.origin
				bulletArgs.velocity = boundData.velocity
				bulletArgs.onplayerhit = (not boundData.instant) and bulletArgs.onplayerhit or nil
			end
		end

		-- Call old particle
		return oldParticle.old(bulletArgs)
	end)

	-- Newbullets hook
	networking.addHook("newbullets", -1, function(args)
		-- Get bound data
		local networkedData = args[2]
		local boundData = bulletBinds[networkedData]
		if not boundData then
			return
		end

		-- Modify velocity
		local bullets = networkedData.bullets 
		networkedData.firepos = boundData.origin
		--networkedData.camerapos = boundData.origin - (boundData.velocity * 2)
		for i = 1, #bullets do
			bullets[i][1] = boundData.velocity
		end

		-- No need to send data, pf can do all the heavy lifting
		if not boundData.instant then
			return
		end

		-- Instantly hit them
		networking.send("newbullets", args[1], networkedData, args[2])
		visuals.onNewBullets({networkedData, args[2]})
		for i = 1, #bullets do
			networking.send("bullethit", boundData.player, boundData.hitpos, boundData.part, bullets[i][2])
			visuals.onBulletHit({boundData.player, boundData.hitpos, boundData.part, bullets[i][2]})
		end

		-- Visuals
		pfModules.AudioSystem.PlaySound("hitmarker", nil, 1, 1.5)
		pfModules.HudCrosshairsInterface.fireHitmarker(boundData.part == "Head")

		-- Block old packet
		return true
	end)
end

-- ragebot
do
	-- why the FUCK does this remind of supremacy
	-- i didnt exactly use this coding style for everything, it was just for the rage
	-- because pf constantly patches things and changes things so i made this super
	-- modular and flexible so i can change things quickly and easily
	rage.cycleNumber = 1
	rage.lastPositionScan = tick()
	-- coon stuff becuz raspy changed sum stuff :sad: (wasnt supposed to be here originally, it was hard locked to bullshit)
	rage.maxTeleport = function() return 1 end
	rage.shiftTick = function() return 3 end
	rage.cancelFlyBypass = function() return true end
	rage.bruteForceLevels = {}

	for i = 1, 200 do
		rage.bruteForceLevels[i] = math.random()
	end

	do
		local lastBruteForcePlaces = tick()
		runService.RenderStepped:Connect(function()
			if tick() - lastBruteForcePlaces > 1 then
				for i = 1, 200 do
					rage.bruteForceLevels[i] = math.random()
				end
				lastBruteForcePlaces = tick()
			end
		end)
	end

	-- ANYWAY
	rage.currentTarget = {}
	rage.lastTarget = {}
	rage.baseFirePos = emptyVec3
	rage.baseAngles = emptyVec3
	rage.baseAngles2 = emptyVec3
	rage.detectionThreshold = {
		spreadAngle = 90,
		firePos = 10
	}
	rage.cardinals = {
		newVec3(0, 1, 0),
		newVec3(0, -1, 0),  
		newVec3(1, 0, 0),
		newVec3(-1, 0, 0),
		newVec3(0, 0, -1),
		newVec3(0, 0, 1)
	}
	rage.teleporting = nil
	rage.teleportfailed = false
	--- heyyy my luv <3
	--- i see u reading thru this trying to paste it
	rage.fakeShoot = function(data)
		local movements = data.teleports
		local lastRepPos = movements and movements[#movements] or data.base
		local shotFrom = data.shotFrom
		local shotAt = data.shotAt
		local shotPlayer = data.player
		local shotPart = data.part
		local trajectory = data.trajectory

		local HudStatusInterface = pfModules.HudStatusInterface
		local HudSpottingInterface = pfModules.HudSpottingInterface
		local effectsModule = pfModules.Effects
		local soundModules = pfModules.AudioSystem
		local activeCamera = pfModules.CameraInterface.getActiveCamera("MainCamera")
		local charObject = pfModules.CharacterInterface.getCharacterObject()
		local heldWeapon = currentInfo.heldWeapon()
		local weaponStat = heldWeapon._weaponData
		local fireCount = heldWeapon._fireCount
		local pellets = weaponStat.type == "SHOTGUN" and weaponStat.pelletcount or 1
		local uniqueId = heldWeapon.uniqueId

		local bulletData = {
			-- originally, i didnt firepos scan more than 4 studs so it always applied this bypass, after the grand patch, the firepos cap was increased and the bypass blocks ur shot so its off if u firepos scan more than 4 studs ?????
			camerapos = (shotFrom - lastRepPos).Magnitude > 4 and (lastRepPos + ((shotFrom - lastRepPos).unit * 2) - trajectory.unit * 2) or shotFrom - trajectory.unit,
			firepos = shotFrom,
			bullets = {}
		}

		for pellet = 1, pellets do
			fireCount = fireCount + 1
			bulletData.bullets[1 + #bulletData.bullets] = {
				trajectory,
				fireCount
			}
		end
		heldWeapon._fireCount = fireCount

		if movements then
			networking.send("stance", "crouch")
			rage.traverseTeleports(movements, false, rage.cancelFlyBypass())
		end
		-- rage_firepositionscanning
		-- rage_firepositionscanningradius
		if ui.flags.rage_firepositionscanning.value then
			local oldpos = shotFrom
			local newpos = rage.firePositionScanning(shotFrom, shotAt, ui.flags.rage_firepositionscanningradius.value)
			data.shotFrom = newpos
			local dist = (oldpos - newpos).Magnitude
			networking.send("repupdate", data.shotFrom, rage.baseAngles, rage.baseAngles2, tickbase:getTickBase())

			local trajectory, bulletTime = mathematics.trajectory(newpos, pfModules.PublicSettings.bulletAcceleration, shotAt, weaponStat.bulletspeed)
			if trajectory and bulletTime then
				local canHit = pfModules.BulletCheck(newpos, shotAt, trajectory, pfModules.PublicSettings.bulletAcceleration, weaponStat.penetrationdepth, bulletTime)
				if canHit then
					pfModules.NetworkClient:send("newbullets", uniqueId, bulletData, tickbase:getTickBase())
					task.wait()
					networking.send("repupdate", newpos, rage.baseAngles, rage.baseAngles2, tickbase:getTickBase())
				else
					data.shotFrom = oldpos
					pfModules.NetworkClient:send("newbullets", uniqueId, bulletData, tickbase:getTickBase())
				end
			else
				data.shotFrom = oldpos
				pfModules.NetworkClient:send("newbullets", uniqueId, bulletData, tickbase:getTickBase())
			end

		else
			pfModules.NetworkClient:send("newbullets", uniqueId, bulletData, tickbase:getTickBase())
		end

		-- IMPORTANT !!!!! i used to tickbase:shift(data.bulletTime) then instant send bullethit, but to avoid detection after the time travel patch, i delay bullet hit
		
		-- garuntee the hit on our targetted player, then try to collat
		coroutine.wrap(function()
			task.wait(data.bulletTime)
			for i, v in next, bulletData.bullets do
				pfModules.NetworkClient:send("bullethit", uniqueId, shotPlayer, shotAt, shotPart, v[2], tickbase:getTickBase())
			end
			for idx, plrData in next, rage.getEnemies() do
				if plrData.plr == shotPlayer then
					continue
				end
				-- dammit vader why are u such a girly girl
				if not plrData.updates or #plrData.updates < 0 then
					continue
				end	
				local canHit = false
				local theirFrames = rage.resolvePosition(plrData.updates, {bruteForce = false, misses = 0})
				for frame, frameData in next, theirFrames do
					if (frameData.position - shotAt).Magnitude <= 6 then
						canHit = true
						break
					end
				end
				if not canHit then
					continue
				end
				for i, v in next, bulletData.bullets do
					pfModules.NetworkClient:send("bullethit", uniqueId, plrData.plr, shotAt, shotPart, v[2], tickbase:getTickBase())
				end		
			end
		end)()
		
		if movements then
			rage.traverseTeleports(movements, true, rage.cancelFlyBypass())
			networking.send("stance", charObject._movementMode)
		end

		-- this is all pasted from pf's source
		local HudCrosshairsInterface = pfModules.HudCrosshairsInterface
		local crossSize = HudCrosshairsInterface.getCrossSize()
		local charStability = charObject.stability
		local spring = charObject._masteraimspring
		local aimSpr = spring and spring.p or emptyVec3

		heldWeapon:impulseSprings(aimSpr)
		HudCrosshairsInterface.fireImpulse(heldWeapon:getWeaponStat("crossexpansion") * (1 - aimSpr))

		if not heldWeapon:getWeaponStat("nomuzzleeffects") then
			effectsModule.muzzleflash(heldWeapon._barrelPart, heldWeapon:getWeaponStat("hideflash"), 0.9)
            if not heldWeapon:getWeaponStat("hideflash") then
                charObject:fireMuzzleLight()
            end;
		end
		if not heldWeapon:getWeaponStat("hideminimap") then
			HudSpottingInterface.goingLoud()
		end

		local particleTrajectory, particleBulletTime = mathematics.solveTrajectory(heldWeapon._barrelPart.Position, pfModules.PublicSettings.bulletAcceleration, shotAt, weaponStat.bulletspeed)
		coroutine.wrap(function()
			runService.Stepped:Wait()
			for i = 1, pellets do
				-- comes from barrel
				pfModules.BulletInterface.newBullet({
					position = heldWeapon._barrelPart.Position,
					velocity = particleTrajectory,
					acceleration = pfModules.PublicSettings.bulletAcceleration,
					color = weaponStat.bulletcolor or Color3.new(0.7843137254901961, 0.27450980392156865, 0.27450980392156865), 
					size = 0.2,
					bloom = 0.005,
					brightness = 400,
					life = pfModules.PublicSettings.bulletLifeTime,
					visualorigin = heldWeapon._barrelPart.Position,
					physicsignore =  table.clone(rayCaster.physicsIgnore),
					penetrationdepth = weaponStat.penetrationdepth,
					ontouch = pfModules.HitDetectionInterface.hitDetection,
					extra = {
						bulletTicket = fireCount - (i - 1)
					}
				})
				HudCrosshairsInterface.fireHitmarker(shotPart == "Head")
				soundModules.playSound("hitmarker", nil, 1, 1, 1.5)
			end
			soundModules.playSoundId(heldWeapon:getWeaponStat("firesoundid"), 2, heldWeapon:getWeaponStat("firevolume"), heldWeapon:getWeaponStat("firepitch"), heldWeapon._barrelPart, nil, 0, 0.05)
			if heldWeapon:getWeaponStat("sniperbass") then
				soundModules.play("1PsniperBass", 1, 1, 0.75)
				soundModules.play("1PsniperEcho", 1, 1, 1)
			end
		end)()

		heldWeapon._magCount = heldWeapon._magCount - 1
		heldWeapon._nShots = heldWeapon._nShots + 1

		HudStatusInterface.updateAmmo(heldWeapon)

		heldWeapon._nextShot = pfModules.GameClock.getTime()

		local before = heldWeapon._nextShot

		if heldWeapon._burst <= 0 and heldWeapon:getWeaponStat("firecap") and heldWeapon:getFiremode() ~= true then
			heldWeapon._nextShot = pfModules.GameClock.getTime() + 60 / heldWeapon:getWeaponStat("firecap")
		elseif heldWeapon:getWeaponStat("autoburst") and heldWeapon._auto and heldWeapon._nShots < heldWeapon:getWeaponStat("autoburst") then
			heldWeapon._nextShot = heldWeapon._nextShot + 60 / heldWeapon:getWeaponStat("burstfirerate")
		elseif heldWeapon:isAiming() and heldWeapon:getActiveAimStat("aimedfirerate") then
			heldWeapon._nextShot = heldWeapon._nextShot + 60 / heldWeapon:getActiveAimStat("aimedfirerate")
		else
			heldWeapon._nextShot = heldWeapon._nextShot + 60 / heldWeapon:getFirerate()
		end

		local after = heldWeapon._nextShot
		local delta = after - before

        if ui.flags.misc_gunmods.value and ui.flags.misc_fireratescale.value ~= 100 and not rage.fakePosition.working then
			local oldDelta = delta
			delta = delta / (ui.flags.misc_fireratescale.value / 100)
			local tickbaseshift = (oldDelta - delta)
			tickbase:shift(tickbaseshift)
        end

		heldWeapon._nextShot = before + delta

		if heldWeapon._magCount == 0 then
			heldWeapon._burst = 0;
			heldWeapon._auto = false;
			if heldWeapon.reload then
				task.spawn(heldWeapon.reload, heldWeapon)
			end
		end
	end
	-- fucking BROKEN ! ! !!!! (integer cannot code)
	rage.autoWall = function(origin, launching_velocity, acceleration, landing_time, maximum_penetration, step_size)
        if landing_time ~= landing_time or math.abs(landing_time) == 1/0 or landing_time >= 2 then return end
        local ignore_list = table.clone(rayCaster.physicsIgnore)
        local passed_a_wall = false
        local simulation_elapsed = 0
        local step_size = step_size or 1/30 --Compromise abit teehee
        local bullet_position = origin
        local bullet_velocity = launching_velocity
        local penetration_remaining = maximum_penetration

        while simulation_elapsed < landing_time do
            local dt = math.min(step_size, landing_time - simulation_elapsed)
            local velocity = bullet_velocity*dt + acceleration*dt*dt/2
            local enter_cast = rayCaster.rayCast(bullet_position, velocity, ignore_list, bullet_ignores, true)
            if enter_cast then
                local instance = enter_cast.Instance
                local enter_pos = enter_cast.Position
                local vel_unit = velocity.Unit
                
                local exit_cast = rayCaster.raycastSingleExit(enter_pos, penetration_remaining*vel_unit, instance)
                
                if not exit_cast then
                    return
                end

                penetration_remaining = penetration_remaining - vel_unit:Dot(exit_cast.Position - enter_pos)
                if penetration_remaining < 0 then
                    return
                end
                passed_a_wall = true

                local scaled_dt = dt*velocity:Dot(enter_pos - bullet_position)/velocity:Dot(velocity)
                bullet_velocity += scaled_dt*acceleration
                bullet_position = enter_pos + 0.01*(bullet_position - enter_pos).Unit
                simulation_elapsed += scaled_dt
                table.insert(ignore_list, instance)
            else
                bullet_velocity += dt*acceleration
                bullet_position += velocity
                simulation_elapsed += dt
            end
        end

        return true, passed_a_wall, penetration_remaining
    end

	-- traverse my NUT !!!
	rage.traverseTeleports = function(movements, inversed, cancelflybypass)
		--[[rage.teleportfailed = false

		rage.teleporting = {
			movements = not cancelflybypass and misc.floorTeleports(movements) or movements,
			inversed = inversed,
			cancelflybypass = cancelflybypass,
			traversing = inversed and #movements or 1,
			teleported = false
		}

		repeat task.wait() until not rage.teleporting

		return rage.teleportfailed]]

        for instruction = inversed and #movements or 1, inversed and 1 or #movements, inversed and -1 or 1 do
            local args = {movements[instruction], rage.baseAngles, rage.baseAngles2, tickbase:shift(rage.shiftTick())}
            if cancelflybypass ~= true then
                misc.bypassFly(args)
                args[4] = tickbase:getTickBase()
            end
            networking.send("repupdate", unpack(args))
            visuals.thirdPerson.animations.repupdate({args[1], args[2], args[3], args[4]})
        end
    end
	-- $$$ used to have a delay in it because i was worried about sending too many packets and exploding my ping
	rage.canTeleport = function()
		return ui.flags.rage_repupdatecontrol.value
	end
	--
	--    options = {
	--        autowallHitscan = boolean,
	--        teleportingThreshold = number,
	--        autowallHitscanDistance = number,
	--        cardinalDirections = boolean,
	--        randomDirections = boolean,
	--        circleDirections = boolean,
	--        canTeleport = boolean,
	--        pathfinding = boolean,
	--        pathfindEnemyPosition = boolean,
	--        pathfindingAlgorithim = string,
	--        pathfindFailedCardinal = boolean,
	--        pathfindingError = number,
	--        maximumHitboxShift = number,
	--        maximumWallBang = number,
	--        pathfindingProcessTime = number,
	--    }
	-- prolly couldve been split up into more functions like rage.getScanOrigins.cardinal(base, args etc)
	-- tldr; get EVERY FUCKING ORIGIN U CAN THINK OF !!!!!!!
	-- prolly shouldve added smarter stuff in here like the bounce off a wall shit forever in random directions or the hug a wall to reach the end of the maze every time thing
	rage.getScanOrigins = function(base, enemyBase, options)
		local origins = {{base}} -- format is {shoot from here, teleports there if any}
		if not options.autowallHitScan then
			return origins
		end

		local cardinals = rage.cardinals
		local numCardinals = #rage.cardinals

		local noTeleportMaxOffset = math.clamp(options.autowallHitscanDistance, 1, options.teleportingThreshold)
		local noTeleportMinOffset = 1

		if options.cardinalDirections then
			for i = 1, numCardinals do
				local direction = cardinals[i].unit
				origins[1 + #origins] = {base + (direction * noTeleportMaxOffset)}
				for offsets = 1, options.autowallHitScanIncrement - 1 do
					origins[1 + #origins] = {base + (direction * noTeleportMaxOffset * math.random())}
				end
			end
		end

		if options.randomDirections then
			for i = 1, numCardinals do
				local direction = newVec3((math.random() * 2) - 1, (math.random() * 2) - 1, (math.random() * 2) - 1).unit
				origins[1 + #origins] = {base + (direction * noTeleportMaxOffset)}
				for offsets = 1, options.autowallHitScanIncrement - 1 do
					origins[1 + #origins] = {base + (direction * noTeleportMaxOffset * math.random())}
				end
			end
		end

		if options.canTeleport and options.autowallHitscanDistance > options.teleportingThreshold then
			local teleportMinOffset = options.teleportingThreshold
			local teleportMaxOffset = options.autowallHitscanDistance

			local teleportOrigins = {}
			local failedTeleportOrigins = {}

			if options.cardinalDirections then
				for i = 1, numCardinals do
					local direction = cardinals[i]
					teleportOrigins[1 + #teleportOrigins] = base + (direction * teleportMaxOffset)
				end
			end

			if options.randomDirections then
				for i = 1, numCardinals do
					local direction = newVec3((math.random() * 2) - 1, (math.random() * 2) - 1, (math.random() * 2) - 1).unit
					teleportOrigins[1 + #teleportOrigins] = base + (direction * teleportMaxOffset)
				end
			end

			for i = 1, #teleportOrigins do
				local projectedEndPoint = teleportOrigins[i]
				if not projectedEndPoint or projectedEndPoint ~= projectedEndPoint then
					continue
				end

				local toProjectedEndPoint = projectedEndPoint - base
				local toProjectedEndPointDirection = toProjectedEndPoint.unit
				local cannotTraverse = pathfinding.canTraverse(base, toProjectedEndPoint)

				if cannotTraverse then
					failedTeleportOrigins[1 + #failedTeleportOrigins] = projectedEndPoint
				end

				local fromWallOffset = 3
				local canTraverseTo = cannotTraverse and cannotTraverse.Position - (toProjectedEndPointDirection * fromWallOffset) or projectedEndPoint
				local traversalMagnitude = (canTraverseTo - base).Magnitude

				if cannotTraverse then
					origins[1 + #origins] = {canTraverseTo + (toProjectedEndPointDirection * (noTeleportMaxOffset - fromWallOffset)), {base, canTraverseTo}}
				else
					origins[1 + #origins] = {canTraverseTo + (noTeleportMaxOffset * toProjectedEndPointDirection), {base, canTraverseTo}}
				end

				if traversalMagnitude < options.teleportingThreshold then
					continue
				end

				origins[1 + #origins] = {canTraverseTo, {base, canTraverseTo}}
				for increment = 1, options.autowallHitScanIncrement - 1 do
					local incrementedTo = base + (toProjectedEndPointDirection * math.random() * traversalMagnitude)
					origins[1 + #origins] = {incrementedTo, {base, incrementedTo}}
				end
			end

			if options.circleDirections then
				for circle = 1, 8 do
					local launchAngle = math.random(360)
					local previousPosition = base
					local offsets = {previousPosition}
					local circleIncrementLength = math.random() * teleportMaxOffset * (math.random(2) == 1 and -1 or 1)

					local angleStep = math.random(1, 60)
					local forAngles = 360 / angleStep

					local xSkew = math.random() * (math.random(2) == 1 and -1 or 1)
					local ySkew = math.random() * (math.random(2) == 1 and -1 or 1)

					local changeY = 0

					for angle = 1, forAngles do
						local curAngle = toRad * ((angle * angleStep) + launchAngle)
						local curPosition = newVec3(math.sin(curAngle) * xSkew, math.random(2) == 2 and -1 or 1 * changeY, math.cos(curAngle) * ySkew).unit * angleStep

						if curPosition ~= curPosition then -- happens???
							break
						end

						local cannotTraverse = pathfinding.canTraverse(previousPosition, curPosition)

						if cannotTraverse or (angleStep * angle) > teleportMaxOffset then
							break
						end

						local ended = previousPosition + curPosition

						offsets[1 + #offsets] = ended
						origins[1 + #origins] = {ended, table.clone(offsets)}
						previousPosition = ended
					end
				end
			end

			if options.cornerDirections then
				for i = 1, 8 do
					local launchAngle = math.random(360) * toRad
					local offsets = {base}

					local cannotTraverse = false
					local tries = 0
					local endPoint
					local previousPoint = base

					while tries < 60 do
						tries = tries + 1
						launchAngle = launchAngle + (toRad * 90)
						local curPosition = previousPoint + newVec3(math.sin(launchAngle), 0, math.cos(launchAngle))
						local cannotPreviousToCur = pathfinding.canTraverse(previousPoint, curPosition)
						if not cannotPreviousToCur then
							offsets[1 + #offsets] = curPosition
							endPoint = curPosition
							previousPoint = curPosition
						end

						if pathfinding.canTraverse(base, curPosition) then
							break
						end
					end

					if endPoint then
						origins[1 + #origins] = {endPoint, offsets}
					end
				end
			end

			if options.snakeDirections then
				for i = 1, 8 do
					local offsets = {base}

					local cannotTraverse = false
					local tries = 0
					local endPoint
					local previousPoint = base

					while tries < 60 do
						tries = tries + 1
						local launchAngle = math.random(360) * toRad
						local curPosition = previousPoint + newVec3(math.sin(launchAngle), 0, math.cos(launchAngle))
						local cannotPreviousToCur = pathfinding.canTraverse(previousPoint, curPosition)
						if not cannotPreviousToCur then
							offsets[1 + #offsets] = curPosition
							endPoint = curPosition
							previousPoint = curPosition
						end

						if pathfinding.canTraverse(base, curPosition) then
							break
						end
					end

					if endPoint then
						origins[1 + #origins] = {endPoint, offsets}
					end
				end
			end

			-- this is pretty bad but idc
			if options.noFly then
				local noFlyOrigins = {}
				for i, v in next, origins do
					local teleports = v[2]
					local remove = false
					local lerpedThere
					if teleports then
						lerpedThere = pathfinding.optimizePath(teleports, rage.maxTeleport())
						for step, instruction in next, lerpedThere do
							local floor = workspace:FindPartOnRayWithWhitelist(Ray.new(instruction, newVec3(0, -4, 0)), {workspace.Map.MapParts}, true)
							if not floor then
								remove = true
								break
							end
						end
					end
					if remove == false then
						noFlyOrigins[1 + #noFlyOrigins] = {v[1], lerpedThere}
					end
				end
				table.clear(origins)
				origins = noFlyOrigins
			end

			if options.pathfinding then
				local pathfindedOrigins = {}
				local nodeSize = 2
				local simTime = options.pathfindingProcessTime

				if options.pathfindEnemyPosition then
					if options.pathfindingAlgorithim["a*"] then
						local pathfindFunc = options.noFly and pathfinding.floorAStar or pathfinding.vadAStar
						local result, data = pathfindFunc({
							start = base,
							goal = enemyBase, -- literal godmode $$$$$
							parameters = {
								step = nodeSize,
								trials = inf,
								weighting = 400,
								mindist = options.teleportingThreshold + options.maximumHitboxShift,
								maxtime = simTime,
							}
						})
						if data then
							pathfindedOrigins[1 + #pathfindedOrigins] = {data.waypoints[#data.waypoints], data.waypoints}
						end
					end
					if options.pathfindingAlgorithim["bfs"] then
						local pathfindFunc = options.noFly and pathfinding.floorBestFirstSearch or pathfinding.bestFirstSearch
						local path = pathfindFunc(base, enemyBase, {
							step_dist = nodeSize,
							min_dist = options.teleportingThreshold + options.maximumHitboxShift,
							max_fails = 50
						})
						if path then
							pathfindedOrigins[1 + #pathfindedOrigins] = {path[#path], path}
						end
					end
				end

				if options.pathfindFailedCardinal then
					local toAttempt = {}
					if #failedTeleportOrigins < 2 then
						table.move(failedTeleportOrigins, 1, #failedTeleportOrigins, #toAttempt + 1, toAttempt)
					else
						for i = 1, 1 do
							local rand = math.random(#failedTeleportOrigins)
							toAttempt[1 + #toAttempt] = failedTeleportOrigins[rand]
							failedTeleportOrigins[rand] = nil
						end
					end
					for i = 1, #toAttempt do
						local couldhave = toAttempt[i]
						if options.pathfindingAlgorithim["a*"] then
							local pathfindFunc = options.noFly and pathfinding.floorAStar or pathfinding.vadAStar
							local result, data = pathfindFunc({
								start = base,
								goal = couldhave,
								parameters = {
									step = nodeSize,
									trials = inf,
									weighting = 400,
									mindist = options.pathfindingError,
									maxtime = simTime,
								}
							})
							if data then
								pathfindedOrigins[1 + #pathfindedOrigins] = {data.waypoints[#data.waypoints], data.waypoints}
							end
						end
						if options.pathfindingAlgorithim["bfs"] then
							local pathfindFunc = options.noFly and pathfinding.floorBestFirstSearch or pathfinding.bestFirstSearch
							local path = pathfindFunc(base, enemyBase, {
								step_dist = nodeSize,
								min_dist = options.pathfindingError,
								max_fails = 50
							})
							if path then
								pathfindedOrigins[1 + #pathfindedOrigins] = {path[#path], path}
							end
						end
					end
				end                        

				for i = 1, #pathfindedOrigins do
					local waypoints = pathfindedOrigins[i][2]

					local num = #waypoints
					if num > 1 then
						local toThere = {}
						for instruction = 1, num do
							toThere[1 + #toThere] = waypoints[instruction]
							origins[1 + #origins] = {waypoints[instruction], table.clone(toThere)}
						end
					end

					local ended = waypoints[#waypoints]
					local offsetToEnemyVec = (enemyBase - ended)
					local offsetToEnemyVecDir = offsetToEnemyVec.unit
					local offsetToEnemyVecMag = offsetToEnemyVec.Magnitude

					-- firepos scan towards them
					origins[1 + #origins] = {ended + (offsetToEnemyVecDir * math.clamp(offsetToEnemyVecMag, 0, options.teleportingThreshold)), waypoints}
				end
			end
		end

		return origins
	end
	-- ok!
	-- what is this bullshit... (i made this getting worried cream would paste fake pos after i media'd him and his users while fake pos'd)
	rage.oldResolvePosition = function(records, additionalData)
		local records = table.clone(records)
		if #records < 2 then -- they must be spawning, give ragebot the spawning location, otherwise forget it, they also cant really fuck these up so no resolving needed
			return records, false
		end

		local myTick = tick()
		local resolved = {}

		-- the latest record is added later
		for i = #records, 2, -1 do -- keep in mind this only works up to literally 3 seconds
			local frame = records[i]
			if (myTick - frame.receivedTime) > 3 then -- prolly should consider ping but care factor
				break
			end
			resolved[1 + #resolved] = table.clone(frame)
		end

		-- okay there are lc'd records we can copy down or we arent resolving them at all
		if additionalData.bruteForce ~= true or #resolved > 0 then
			return resolved, false
		end

		-- okay they must be doing some REAL weird shit if we cant find a normally lc'd position
		if additionalData.misses < 1 then -- okay maybe they arent desynced so shoot their last pos
			return {records[#records]}, true
		end

		-- okay their latest records missed, brute force around their last record
		-- i wonder if evie looks thru this shit and wonders what the fuck its doing
		local centerPos = records[#records].position
		local radius = 6
		local targetLayer = math.clamp(2 + math.floor(math.max(additionalData.misses - 1, 0) % 4), 2, 6) -- each shot will focus on a different ring
		local maxLayer = 6
		local minLayer = 2
		local coveragePercentage = 50

		local bruteForced = {}
		local totalPossiblePoints = 0

		-- way more complicated than it needed to be lolz (im so sorry)
		for layer = minLayer, maxLayer do

			bruteForced[layer] = {}

			local sphereVolume = 4/3 * math.pi * radius^3
			local totalVolume = 4/3 * math.pi * (radius * layer)^3
			local coveredVolume = totalVolume * coveragePercentage / 100

			local presphereVolume = 4/3 * math.pi * radius^3
			local pretotalVolume = 4/3 * math.pi * (radius * (layer - 1))^3
			local precoveredVolume = pretotalVolume * coveragePercentage / 100

			local num_points = math.floor((coveredVolume - precoveredVolume) / sphereVolume)

			local singleIncrement = 1 / num_points
			local currentIncrement = 0

			for j = 1, num_points do
				local theta = currentIncrement * math.pi * 2
				local phi = math.acos(currentIncrement * 2 - 1)
				local r = radius * layer
				local x = centerPos.x + r * math.sin(phi) * math.cos(theta)
				local y = centerPos.y + r * math.cos(phi)
				local z = centerPos.z + r * math.sin(phi) * math.sin(theta)

				local proposed = newVec3(x, y, z)
				local hit, pos = workspace:FindPartOnRayWithWhitelist(Ray.new(centerPos, proposed - centerPos), {workspace.Map.MapParts}, true)
				if not hit then
					bruteForced[layer][j] = proposed
				end

				currentIncrement = currentIncrement + singleIncrement
			end

			totalPossiblePoints = totalPossiblePoints + num_points
		end

		local bruteForceRecord = table.clone(records[#records])
		local bruteForcePosition
		do
			local targetBruteForceLayer = bruteForced[targetLayer]
			bruteForcePosition = #targetBruteForceLayer > 0 and targetBruteForceLayer[#targetBruteForceLayer > 2 and math.random(#targetBruteForceLayer) or 1] or nil
		end

		local copied = {}
		for i, v in next, bruteForced do
			for i2, v2 in next, v do
				copied[1 + #copied] = v2
			end
		end

		do
			bruteForcePosition = #copied > 0 and copied[#copied > 2 and math.random(#copied) or 1]
		end

		if additionalData.misses > totalPossiblePoints then -- good lord just quit missing already :sad:
			local randVec = newVec3(math.random() * 2 - 1, math.random() * 2 - 1, math.random() * 2 - 1) * math.random(6, 36)
			local hit, pos = workspace:FindPartOnRayWithWhitelist(Ray.new(centerPos, randVec), {workspace.Map.MapParts}, true)
			bruteForcePosition = ((pos - centerPos).Magnitude * math.random()) * randVec.unit
		end

		bruteForceRecord.position = bruteForcePosition or bruteForceRecord.position
		return {bruteForceRecord}, true       
	end

	-- post grand patch fake pos resolver $
	rage.resolvePosition = function(records, additionalData)
		if #records < 2 then -- they must be spawning, give ragebot the spawning location, otherwise forget it, they also cant really fuck these up so no resolving needed
			return records, false
		end

		local myTick = tick()
		local resolved = {}

		-- the latest record is added later
		for i = #records, 2, -1 do -- keep in mind this only works up to literally 3 seconds
			local frame = records[i]
			local nextFrame = records[i - 1]
			-- if fake pos or is outside of time window, stop
			if (myTick - frame.receivedTime) > (3 - (localPing * 2 / 1000)) then -- prolly should consider ping but care factor
				break
			end
			resolved[1 + #resolved] = frame
		end

		local case
		do
			local frame = records[#records]
			local nextFrame = records[#records - 1]
			local nextNextFrame = records[#records - 2]
			
			if frame.receivedTime - nextFrame.receivedTime > 3 then -- instant
				case = 1

				local difference_left_side = math.abs(frame.time - pfModules.GameClock.getTime())
				local difference_right_side = math.abs(nextFrame.time - pfModules.GameClock.getTime())
				local max_allowed_difference = 0.05 * math.min(difference_left_side, difference_right_side)
				local is_within_5_percent = math.abs(difference_left_side - difference_right_side) <= max_allowed_difference

				if not is_within_5_percent then
					case = 3
				end
			elseif nextNextFrame and frame.receivedTime - nextFrame.receivedTime < 3 and nextFrame.receivedTime - nextNextFrame.receivedTime > 3 then -- non instant
				case = 2
			end
		end

		-- okay there are lc'd records we can copy down or we arent resolving them at all
		if not case and #resolved > 0 then
			return resolved, false
		end

		-- okay they must be doing some REAL weird shit if we cant find a normally lc'd position
		if additionalData.bruteForce ~= true or additionalData.misses < 1 then -- okay maybe they arent desynced so shoot their last pos
			return {records[#records]}, false
		end

		-- instant fake flick
		if case == 1 then
			-- unless they backdoored pf, this is sufficient
			local firstDir = math.random() > 0.5 and 1 or -1
			local relDir = 1
			local rayUpPos = nil
			for i = 1, 2 do
				local rayUpHit, relrayUpPos = workspace:FindPartOnRayWithWhitelist(Ray.new(records[#records].position, Vector3.new(0, firstDir * 200, 0)), {workspace.Map}, true)
				if (relrayUpPos - records[#records].position).Magnitude > 6 then -- fail  
					rayUpPos = relrayUpPos
					relDir = firstDir
				end
				firstDir = firstDir * -1
			end

			if not rayUpPos then
				-- okay we're fucked
				return rage.oldResolvePosition(records, additionalData)
			end

			local increments = math.floor((rayUpPos - records[#records].position).Magnitude / 6)

			local num = additionalData.misses
			local min = 1
			local max = increments

			local range = max - min + 1  -- The range of values, including both min and max
			local clamped = math.clamp(math.round((rage.bruteForceLevels[num] or math.random()) * max), min, max)
			
			-- basically shoot higher and higher and higher then lower and lower and lower then higher and higher and higher

			local guessRecord = table.clone(records[#records])
			guessRecord.position = guessRecord.position + (clamped * Vector3.new(0, 6, 0) * relDir)
			return {guessRecord}, true
		elseif case == 2 then
			-- non instant fake flick
			-- unless they backdoored pf, this is sufficient

			local rayUpHit, rayUpPos = workspace:FindPartOnRayWithWhitelist(Ray.new(records[#records].position, (records[#records - 1].position - records[#records].position).unit * 200), {workspace.Map}, true)

			if (rayUpPos - records[#records].position).Magnitude < 4 then
				-- okay we're fucked
				return rage.oldResolvePosition(records, additionalData)
			end

			local increments = math.floor((rayUpPos - records[#records].position).Magnitude / 6)
			local dir = (rayUpPos - records[#records].position).unit * 6
			
			local num = additionalData.misses
			local min = 1
			local max = increments

			local range = max - min + 1  -- The range of values, including both min and max
			local clamped = math.clamp(math.round((rage.bruteForceLevels[num] or math.random()) * max), min, max)

			-- basically shoot higher and higher and higher then lower and lower and lower then higher and higher and higher

			local guessRecord = table.clone(records[#records])
			guessRecord.position = guessRecord.position + (clamped * dir)
			return {guessRecord}, true
		elseif case == 3 then
			-- case 2 but we cant check their flick direction
			local guessRecord = table.clone(records[#records - 1])
			return {guessRecord}, true
		end
	end

	--
	--    shiftHitbox = boolean,
	--    cardinalShift = boolean,
	--    randomShift = boolean,
	--    maximumShift = number
	--
	-- same deal with getScanOrigins, collect as many as possible, dont care abt logic yet
	rage.getScanPoints = function(enemyBase, options)
		local base = enemyBase
		local points = {{base}}

		if not options.shiftHitbox then
			return points
		end

		local shiftDirections = {}
		local pullMagnitude = options.maximumHitboxShift

		if options.cardinalShift then
			for i, v in next, rage.cardinals do
				shiftDirections[1 + #shiftDirections] = v.unit
			end
		end

		if options.randomShift then
			for i = 1, #rage.cardinals do
				shiftDirections[1 + #shiftDirections] = newVec3((math.random() * 2) - 1, (math.random() * 2) - 1, (math.random() * 2) - 1).unit
			end
		end

		local collisions = {workspace.Map}
		for i = 1, #shiftDirections do
			local shiftDir = shiftDirections[i]

			do
				local thePoint = base + (shiftDir * pullMagnitude)
				local enterHit, enterPos = workspace:FindPartOnRayWithWhitelist(Ray.new(thePoint, base - thePoint), collisions)
				if not enterHit then
					points[1 + #points] = {thePoint}
				else
					local exitHit, exitPos = workspace:FindPartOnRayWithWhitelist(Ray.new(enterPos, thePoint - enterPos), collisions)
					if not exitHit then
						points[1 + #points] = {thePoint}
					end
				end
			end

			for pull = 1, options.shiftHitboxIncrements - 1 do
				do
					local thePoint = base + (shiftDir * math.random() * pullMagnitude)
					local enterHit, enterPos = workspace:FindPartOnRayWithWhitelist(Ray.new(thePoint, base - thePoint), collisions)
					if not enterHit then
						points[1 + #points] = {thePoint}
					else
						local exitHit, exitPos = workspace:FindPartOnRayWithWhitelist(Ray.new(enterPos, thePoint - enterPos), collisions)
						if not exitHit then
							points[1 + #points] = {thePoint}
						end
					end
				end
			end
		end

		return points
	end
	--
	--  options = {  
	--      throughWalls = boolean,
	--      maxDistance = number,
	--      aimPart = string,
	--      maximumPeople = number,
	--      hits = number
	--  }
	--
	rage.knifeAura = function(base, enemies, options)
		local peopleAttacked = 0
		for i, enemy in next, enemies do
			local enemyBase = enemy.updates[#enemy.updates].position
			local range = (enemyBase - base).Magnitude

			if range > options.maxRange then
				continue    
			end

			if not options.throughWalls and pathfinding.canTraverse(base, enemyBase - base) then
				continue
			end

			for hit = 1, options.hits do
				pfModules.NetworkClient:send("knifehit", enemy.plr, options.aimPart, enemyBase, tickbase:getTickBase())
			end

			pfModules.HudCrosshairsInterface.fireHitmarker(options.aimPart == "Head")

			peopleAttacked = peopleAttacked + 1
			if peopleAttacked > options.maximumPeople then
				break
			end
		end
		return peopleAttacked > 0
	end
	--
	--    options = {
	--        throughWalls = boolean,
	--        pathfinded = boolean,
	--        knifeRadius = number,
	--        simTime = number,
	--        nodeSize = number,
	--    }
	--
	rage.processKnifeBot = function(base, enemies, options)
		local knifed = rage.knifeAura(base, enemies, {
			throughWalls = options.throughWalls,
			maxRange = options.knifeRadius,
			aimPart = "Head",
			maximumPeople = inf,
			hits = 4,
		})
		if knifed then
			return
		end
		local charObject = pfModules.CharacterInterface.getCharacterObject()
		if options.pathfinded then
			rage.cycleNumber = rage.cycleNumber + 1
			local nextEnemyIndex = rage.cycleNumber
			if nextEnemyIndex > #enemies then
				nextEnemyIndex = 1
				rage.cycleNumber = 1
			end
			local enemy = enemies[rage.cycleNumber]
			local result, data = pathfinding.aStar({
				start = base,
				goal = enemy.updates[#enemy.updates].position,
				parameters = {
					step = options.nodeSize,
					trials = inf,
					weighting = 400,
					mindist = options.knifeRadius,
					maxtime = options.simTime,
				}
			})
			if result then
				networking.send("stance", "crouch")
				local movements = pathfinding.optimizePath(data.waypoints, rage.maxTeleport())
				rage.traverseTeleports(movements, false, rage.cancelFlyBypass())
				rage.knifeAura(movements[#movements], enemies, {
					throughWalls = options.throughWalls,
					maxRange = options.knifeRadius,
					aimPart = "Head",
					maximumPeople = inf,
					hits = 4,
				})
				rage.traverseTeleports(movements, true, rage.cancelFlyBypass())
				networking.send("stance", charObject._movementMode)
			end
		end
	end
	--
	--    additionalData = {
	--        enemyMove = vec3,
	--        localMove = vec3,
	--        autoWallTime = number,
	--        preference = string,
	--        teleportingThreshold = number,
	--        sorting = table
	--    }
	--
	-- great sorting vaderr i bet it hits p
	-- tldr; consider all the thousands of combinations of origins and points and only autowall the most relevant ones (or attempt to :sad:)
	-- shouldve prolly used funcs here i.e. rage.scanning.sortNearest(points, origins, heursitci)
	-- OLD AF RAGE.SCAN ALSO REALLY BAD ! ! ! ! !! ! ! ! !  ! ! ! !
	-- no longer the case lmao
	rage.scan = function(base, enemyBase, origins, points, weaponData, options, additionalData)
		local results = {}
		local scanGroups = {} -- group of origins and points to scan
		local simTime = options.autoWallTime
		local bulletSpeed = weaponData.bulletspeed
		local bulletAcceleration = pfModules.PublicSettings.bulletAcceleration
		local penetrationPower = weaponData.penetrationdepth

		local divisions = 1
		for i, v in next, options.sorting do
			if v then
				divisions = divisions + 1
			end
		end

		if options.sorting["nearest"] then
			local scanOrigins = {}
			local scanPoints = {}

			for i = 1, #origins do
				local v = origins[i]
				local heuristic = (enemyBase - v[1]).Magnitude
				origins[i] = {v, heuristic}
			end

			table.sort(origins, function(a, b)
				return a[2] < b[2]
			end)

			local selected = math.min(options.maximumHitscanningPoints / divisions, #origins)
			for i = 1, selected do
				local data = origins[i]
				if data then
					scanOrigins[1 + #scanOrigins] = data[1]
					table.remove(origins, i)
				end
			end

			for i = 1, #origins do
				local v = origins[i]
				origins[i] = v[1]
			end

			local nearestBase = enemyBase
			local nearestShift = scanOrigins[1][1] - enemyBase

			local allBases = additionalData.enemyRecords
			for i, v in next, allBases do
				if (scanOrigins[1][1] - v).Magnitude < nearestShift.Magnitude then
					nearestBase = v
					nearestShift = scanOrigins[1][1] - v
				end
			end

			local maximumShift = options.maximumHitboxShift
			if nearestShift.Magnitude <= maximumShift then
				scanPoints[1 + #scanPoints] = {scanOrigins[1][1]}
			else
				scanPoints[1 + #scanPoints] = {enemyBase + ((base - enemyBase).unit * maximumShift)}
			end

			scanGroups[1 + #scanGroups] = {
				scanOrigins,
				scanPoints,
			}
		end

		if options.sorting["clamping"] then
			local scanOrigins = {}
			local scanPoints = {}

			local ideal = emptyVec3
			local toEnemy = (enemyBase - base).unit
			if toEnemy ~= toEnemy then
				if toEnemy.x ~= 0 then
					ideal = ideal + ((toEnemy.x > 0 and -1 or 1) * newVec3(1, 0, 0))
				end
				if toEnemy.y ~= 0 then
					ideal = ideal + ((toEnemy.y > 0 and -1 or 1) * newVec3(0, 1, 0))
				end
				if toEnemy.z ~= 0 then
					ideal = ideal + ((toEnemy.z > 0 and -1 or 1) * newVec3(0, 0, 1))
				end
			end                    

			for i = 1, #origins do
				local v = origins[i]
				local heuristic = (v[1] - base).unit:Dot(ideal)
				origins[i] = {v, heuristic}
			end

			table.sort(origins, function(a, b)
				return a[2] > b[2]
			end)

			local selected = math.min(options.maximumHitscanningPoints / divisions, #origins)
			for i = 1, selected do
				local index = #origins > 4 and math.ceil(math.random() * options.sortingBias * #origins) or i
				local data = origins[index]
				if data then
					scanOrigins[1 + #scanOrigins] = data[1]
					table.remove(origins, i)
				end
			end

			for i = 1, #origins do
				local v = origins[i]
				origins[i] = v[1]
			end

			for i = 1, #points do
				local v = points[i]
				local heuristic = (v[1] - enemyBase).unit:Dot(ideal)
				points[i] = {v, heuristic}
			end

			table.sort(points, function(a, b)
				return a[2] > b[2]
			end)

			local selected = math.min(1, #points)
			for i = 1, selected do
				local index = #points > 4 and math.ceil(math.random() * options.sortingBias * #points) or i
				local data = points[index]
				if data then
					scanPoints[1 + #scanPoints] = data[1]
					table.remove(points, index)
				end
			end

			for i = 1, #points do
				local v = points[i]
				points[i] = v[1]
			end

			scanGroups[1 + #scanGroups] = {
				scanOrigins,
				scanPoints,
			}
		end

		if options.sorting["enemy move"] and additionalData.enemyMove.unit == additionalData.enemyMove.unit then
			local movementDirection = additionalData.enemyMove.unit

			local scanOrigins = {}
			local scanPoints = {}

			for i = 1, #origins do
				local v = origins[i]
				local heuristic = (v[1] - base).unit:Dot(movementDirection)
				origins[i] = {v, heuristic}
			end

			table.sort(origins, function(a, b)
				return a[2] > b[2]
			end)

			local selected = math.min(options.maximumHitscanningPoints / divisions, #origins)
			for i = 1, selected do
				local index = #origins > 4 and math.ceil(math.random() * options.sortingBias * #origins) or i
				local data = origins[index]
				if data then
					scanOrigins[1 + #scanOrigins] = data[1]
					table.remove(origins, i)
				end
			end

			for i = 1, #origins do
				local v = origins[i]
				origins[i] = v[1]
			end

			for i = 1, #points do
				local v = points[i]
				local heuristic = (v[1] - enemyBase).unit:Dot(movementDirection)
				points[i] = {v, heuristic}
			end

			table.sort(points, function(a, b)
				return a[2] > b[2]
			end)

			local selected = math.min(1, #points)
			for i = 1, selected do
				local index = #points > 4 and math.ceil(math.random() * options.sortingBias * #points) or i
				local data = points[index]
				if data then
					scanPoints[1 + #scanPoints] = data[1]
					table.remove(points, index)
				end
			end

			for i = 1, #points do
				local v = points[i]
				points[i] = v[1]
			end

			scanGroups[1 + #scanGroups] = {
				scanOrigins,
				scanPoints,
			}

		end

		if options.sorting["local move"] and additionalData.localMove.unit == additionalData.localMove.unit then
			local movementDirection = additionalData.localMove.unit

			local scanOrigins = {}
			local scanPoints = {}

			for i = 1, #origins do
				local v = origins[i]
				local heuristic = (v[1] - base).unit:Dot(movementDirection)
				origins[i] = {v, heuristic}
			end

			table.sort(origins, function(a, b)
				return a[2] > b[2]
			end)

			local selected = math.min(options.maximumHitscanningPoints / divisions, #origins)
			for i = 1, selected do
				local index = #origins > 4 and math.ceil(math.random() * options.sortingBias * #origins) or i
				local data = origins[index]
				if data then
					scanOrigins[1 + #scanOrigins] = data[1]
					table.remove(origins, i)
				end
			end

			for i = 1, #origins do
				local v = origins[i]
				origins[i] = v[1]
			end

			for i = 1, #points do
				local v = points[i]
				local heuristic = (v[1] - enemyBase).unit:Dot(movementDirection)
				points[i] = {v, heuristic}
			end

			table.sort(points, function(a, b)
				return a[2] > b[2]
			end)

			local selected = math.min(1, #points)
			for i = 1, selected do
				local index = #points > 4 and math.ceil(math.random() * options.sortingBias * #points) or i
				local data = points[index]
				if data then
					scanPoints[1 + #scanPoints] = data[1]
					table.remove(points, index)
				end
			end

			for i = 1, #points do
				local v = points[i]
				points[i] = v[1]
			end

			scanGroups[1 + #scanGroups] = {
				scanOrigins,
				scanPoints,
			}

		end

		if options.sorting["out of cover"] and #additionalData.coverPoints > 1 then
			local scanOrigins = {}
			local scanPoints = {}               

			for i = 1, #origins do
				local v = origins[i]

				local minDistance = math.huge
				local minAlignment

				for _, coverPoint in next, additionalData.coverPoints do
					minAlignment = v[1] - coverPoint
					local distance = (minAlignment).Magnitude
					minDistance = math.min(minDistance, distance)
				end

				local heuristic = minAlignment and (v[1] - base).unit:Dot(minAlignment.unit) or 0
				origins[i] = {v, heuristic}
			end

			table.sort(origins, function(a, b)
				return a[2] > b[2]
			end)

			local selected = math.min(options.maximumHitscanningPoints / divisions, #origins)
			for i = 1, selected do
				local index = #origins > 4 and math.ceil(math.random() * options.sortingBias * #origins) or i
				local data = origins[index]
				if data then
					scanOrigins[1 + #scanOrigins] = data[1]
					table.remove(origins, i)
				end
			end

			for i = 1, #origins do
				local v = origins[i]
				origins[i] = v[1]
			end

			for i = 1, #points do
				local v = points[i]
				local minDistance = math.huge

				for _, coverPoint in next, additionalData.coverPoints do
					local distance = (v[1] - coverPoint).Magnitude
					minDistance = math.min(minDistance, distance)
				end

				local heuristic = minDistance
				points[i] = {v, heuristic}
			end

			table.sort(points, function(a, b)
				return a[2] > b[2]
			end)

			local selected = math.min(1, #points)
			for i = 1, selected do
				local index = #points > 4 and math.ceil(math.random() * 0.25 * #points) or i
				local data = points[index]
				if data then
					scanPoints[1 + #scanPoints] = data[1]
					table.remove(points, index)
				end
			end

			for i = 1, #points do
				local v = points[i]
				points[i] = v[1]
			end

			scanGroups[1 + #scanGroups] = {
				scanOrigins,
				scanPoints,
			}
		end

		-- fully random, always have this one
		do
			for i = 1, options.maximumHitscanningPoints / divisions do
				local scanOrigins = {}
				local scanPoints = {}
	
				-- Shuffle origins randomly
				for i = #origins, 2, -1 do
					local j = math.random(i)
					origins[i], origins[j] = origins[j], origins[i]
				end
	
				local selectedOrigins = math.min(1, #origins)
				for i = 1, selectedOrigins do
					local data = origins[i]
					if data then
						scanOrigins[1 + #scanOrigins] = {data[1]}
					end
				end
	
				-- Shuffle points randomly
				for i = #points, 2, -1 do
					local j = math.random(i)
					points[i], points[j] = points[j], points[i]
				end
	
				local selectedPoints = math.min(1, #points)
				for i = 1, selectedPoints do
					local data = points[i]
					if data then
						scanPoints[1 + #scanPoints] = {data[1]}
					end
				end
	
				scanGroups[1 + #scanGroups] = {
					scanOrigins,
					scanPoints,
				}
			end
		end

		for groupIndex = 1, #scanGroups do
			local groupData = scanGroups[groupIndex]
			local scanOrigins = groupData[1]
			local scanPoints = groupData[2]

			for scanPointIndex = 1, #scanPoints do
				local pointData = scanPoints[scanPointIndex]
				local shootAt = pointData[1]

				for scanOriginIndex = 1, #scanOrigins do
					local originData = scanOrigins[scanOriginIndex]
					local shootFrom = originData[1]
					local moveBy = originData[2]

					if type(shootAt) == "table" or type(shootFrom) == "table" then 
						continue
					end 

					local distance = (shootAt - shootFrom).Magnitude
					
					if distance > 0 then
						local trajectory, bulletTime = mathematics.trajectory(shootFrom, bulletAcceleration, shootAt, bulletSpeed)

						if trajectory and bulletTime then
							local canHit = pfModules.BulletCheck(shootFrom, shootAt, trajectory, bulletAcceleration, penetrationPower, simTime)
							--local canHit = rage.autoWall(shootFrom, trajectory, bulletAcceleration, bulletTime, penetrationPower, simTime)

							if canHit then
								results[#results + 1] = {
									shotFrom = shootFrom,
									shotAt = shootAt,
									trajectory = trajectory,
									bulletTime = bulletTime,
									distance = distance,
									teleports = moveBy,
								}
							end
						end
					else
						local adjustedShootAt = shootAt + (enemyBase - base).unit * 0.01
						local trajectory, bulletTime = mathematics.trajectory(shootFrom, bulletAcceleration, adjustedShootAt, bulletSpeed)

						results[#results + 1] = {
							shotFrom = shootFrom,
							shotAt = adjustedShootAt,
							trajectory = trajectory,
							bulletTime = bulletTime,
							distance = distance,
							teleports = moveBy,
						}
					end
				end
			end
		end        

		if not results[1] then
			return
		end

		if options.preference["favor high damage"] then
			table.sort(results, function(a, b)
				return a.distance < b.distance
			end)
		elseif options.preference["favor fewer movements"] then
			table.sort(results, function(a, b)
                local amove = a.teleports
                local bmove = b.teleports

                local adist = a.dist
                local bdist = b.dist

                if not a.dist then
                    a.dist = 0
                    if amove then
                        adist = 0
                        local movements = amove
                        for instruction = 1, #movements do
                            local curinstruction = movements[instruction]
                            if instruction > 1 then
                                adist = adist + (curinstruction - movements[instruction - 1]).Magnitude
                            end
                        end
                        a.dist = adist
                    end
                end
                
                if not b.dist then
                    b.dist = 0
                    if bmove then
                        bdist = 0
                        local movements = bmove
                        for instruction = 1, #movements do
                            local curinstruction = movements[instruction]
                            if instruction > 1 then
                                bdist = bdist + (curinstruction - movements[instruction - 1]).Magnitude
                            end
                        end
                        b.dist = bdist
                    end
                end
                
                return a.dist < b.dist
            end)
		elseif options.preference["favor safety"] then
			table.sort(results, function(a, b)
				local aDistToEnemyBase = (a.shotAt - enemyBase).Magnitude
				local bDistToEnemyBase = (b.shotAt - enemyBase).Magnitude

				return aDistToEnemyBase < bDistToEnemyBase
			end)
		end        

		local besthit = results[1]

		return besthit
	end
	-- le get
	rage.getEnemies = function()
		local plrList = playerInfo.list
		local enemyList = {}
		for plr, data in next, plrList do
			if data.alive and data.enemy then
				if ui.flags.misc_ignorefriendlies.value and ui.playerListStatus and ui.playerListStatus[data.plr.UserId] and ui.playerListStatus[data.plr.UserId].friendly == true then
				else
					if ui.flags.misc_onlypriorities.value then
						if ui.playerListStatus and ui.playerListStatus[data.plr.UserId] and ui.playerListStatus[data.plr.UserId].priority == true then
							enemyList[1 + #enemyList] = data
						end
					else
						enemyList[1 + #enemyList] = data
					end
				end
			end
		end

		return enemyList
	end
	-- le fileter
	rage.filterEnemies = function(enemies, maxFov, origin, originDirection)
		-- fov
		local enemyList = {}
		for plr, data in next, enemies do
			local char = data.character
			if char then
				local centerMass = char.Torso
				local lookAtEnemy = CFrame.new(origin, centerMass.Position).LookVector.unit
				local angle = toDeg * mathematics.angleBetweenVector3(CFrame.new(origin, origin + originDirection), lookAtEnemy)

				if angle < maxFov then
					enemyList[1 + #enemyList] = data
				end
			end
		end

		return enemyList
	end
	--
	--    options = {
	--        favorHackers = boolean,
	--        hitPart = string,
	--    }
	--
	-- okay process whatever we have
	rage.processAimBot = function(base, localVelocity, enemySet, weaponData, options)
		local enemyPassed = enemySet

		for i, enemy in next, enemyPassed do
			if not enemy.updates or #enemy.updates < 1 then
				continue
			end

			local enemyRecords, isResolving = rage.resolvePosition(enemy.updates, {misses = math.floor(enemy.misses), bruteForce = options.resolver})

			if #enemyRecords < 1 then -- ??? tf is this edge case
				enemyRecords = {enemy.updates[#enemy.updates]}
			end

			if isResolving then
				enemy.position = enemyRecords[1].position
			end
			local enemyBase = enemyRecords[1].position
			local origins = rage.getScanOrigins(base, enemyBase, options)

			local points = {}
			local allBases = {}
			-- STUPID AND TOO LONG AND CRINGE AND POORLY WRITTEN!
			local pointsFromFrame = rage.getScanPoints(enemyBase, options)
			for k, point in next, pointsFromFrame do
				points[1 + #points] = point
			end
			allBases[1 + #allBases] = enemyBase
			if options.maximumBackTrack > 0 then
				-- tldr, sample 4 backtrack points equally spaced apart
				local myTick = tick()
				local withinTime = {}
				local samples = {}
				for i, v in next, enemyRecords do
					-- dont backtrack the last record, its the spawning record
					if myTick - v.receivedTime > options.maximumBackTrack then
						break
					end
					withinTime[1 + #withinTime] = v
				end

				for i = 1, math.min(#withinTime, options.backtrackSamples) do
					local randIndex = #withinTime > 1 and math.random(#withinTime) or 1
					samples[1 + #samples] = withinTime[randIndex]
					table.remove(withinTime, randIndex)
				end

				for i, v in next, samples do
					local pointsFromFrame = rage.getScanPoints(v.position, options)
					for k, point in next, pointsFromFrame do
						points[1 + #points] = point
					end
					allBases[1 + #allBases] = v.position
				end
			end

			local coverPoints = {}
			local random = math.random
			local tries = 0
			local maxRadius = 10
			local numPoints = 4

			while #coverPoints < numPoints and tries < 64 do
				local angle = random() * 2 * math.pi
				local radius = random() * maxRadius
				local x = enemyBase.x + radius * math.cos(angle)
				local y = enemyBase.y
				local z = enemyBase.z + radius * math.sin(angle)

				local point = Vector3.new(x, y, z)

				local isBehindCover
				do
					local ray = Ray.new(enemyBase, (point - enemyBase).unit * (point - enemyBase).Magnitude)
					local hit = workspace:FindPartOnRayWithWhitelist(ray, {workspace.Map})
					isBehindCover = hit ~= nil
				end

				if isBehindCover then
					table.insert(coverPoints, point)
				end

				tries = tries + 1
			end				

			local results = rage.scan(base, enemyBase, origins, points, weaponData, options, {
				enemyMove = enemy.velocity,
				localMove = localVelocity,
				coverPoints = coverPoints,
				enemyRecords = allBases,
			})

			if results then
				return results, enemy
			end
		end
	end
	--
	--    options = {
	--        autoFire = boolean,
	--        silentAim = boolean,
	--      hitPart = string
	--    }
	--
	-- process ...?
	rage.processResult = function(base, results, enemy, weaponData, options)
		local activeCamera = pfModules.CameraInterface.getActiveCamera("MainCamera")

		rage.currentTarget.player = enemy.plr
		rage.currentTarget.pInfo = enemy
		rage.currentTarget.part = enemy.character[options.hitbox]
		rage.currentTarget.results = results
		rage.lastTarget = rage.currentTarget

		if options.autoFire == true then
			rage.fakeShoot({
				base = base,
				teleports = results.teleports,
				shotFrom = results.shotFrom,
				shotAt = results.shotAt,
				trajectory = results.trajectory,
				part = options.hitbox,
				bulletTime = results.bulletTime,
				player = enemy.plr
			})
		end

		local displacement = results.distance
		local heldWeaponStats = weaponData._weaponData
		local bs = heldWeaponStats.multtorso
		local hs = heldWeaponStats.multhead

		local damageGraph = heldWeaponStats.damageGraph

		local numPoints = #damageGraph

		local baseDamage = 0
		if displacement < damageGraph[1].distance then
			baseDamage = damageGraph[1].damage
		elseif displacement > damageGraph[numPoints].distance then
			baseDamage = damageGraph[numPoints].damage
		else
			for i = 1, numPoints - 1 do
				local range0, range1 = damageGraph[i].distance, damageGraph[i + 1].distance
				local damage0, damage1 = damageGraph[i].damage, damageGraph[i + 1].damage

				-- Check if the displacement is within the current range
				if displacement >= range0 and displacement <= range1 then
					-- Perform linear interpolation
					local t = (displacement - range0) / (range1 - range0)
					baseDamage = damage0 + t * (damage1 - damage0)
				end
			end
		end

		local predictedDamage = baseDamage * (options.hitbox == "Head" and hs or (options.hitbox == "Torso" and bs or 1)) * (heldWeaponStats.type == "SHOTGUN" and heldWeaponStats.pelletcount or 1)
		
		--print(enemy.plr, options.hitbox, displacement, predictedDamage)

		if options.autoFire == true then
			enemy.misses = enemy.misses + math.clamp(predictedDamage / enemy.health, 0, 1) -- PASTED ! (this was stupid but it worked for resolver misses or whatever when auto-fire was turned off by the user)
			-- reminder this gets reset automatically if they arent fake pos'd
		end
		
		enemy.predictedDamage = enemy.predictedDamage + predictedDamage
		task.spawn(function()
			task.wait((localPing * 2) / 1000)
			task.wait(results.bulletTime)
			task.wait(1/60)
			if enemy and enemy.predictedDamage then
				enemy.predictedDamage = enemy.predictedDamage - predictedDamage
			end
		end)

		-- re-scan this dude next ragebot think because we didnt deal lethal damage to them, keep doing this until we've done lethal damage, then try to shoot the next person
		if not options.autoFire or enemy.predictedDamage < enemy.health then
			rage.cycleNumber = rage.cycleNumber - 1
		end
		
		-- pointless but i want this
		if not options.silentAim then
			activeCamera:setLookVector((results.shotAt - activeCamera._cframe.p).unit)
		end
	end

	-- credit below is evieee
	rage.firePositionScanning = function(origin, target, maxdist)
		-- get our cardidididinals
		if tick() - rage.lastPositionScan < 1/60 then
			return rage.baseFirePos
		end

		local directions = {
			Vector3.new(1,0,0),
			Vector3.new(-1,0,0),
			Vector3.new(0,0,1),
			Vector3.new(0,0,-1),
		}

		-- up is probably our best vector so we will add bias for it
		local passes = 0
		local randomVector = math.random() > 0.5 and Vector3.new(0,1,0) or directions[math.random(1,#directions)]
		randomVector = randomVector * math.random(6, maxdist)

		if not pathfinding.canTraverse(origin, origin + randomVector) then
			repeat
				if passes > 10 then
					return origin -- fail!
				end

				randomVector = math.random() > 0.5 and Vector3.new(0,1,0) or directions[math.random(1,#directions)]
				randomVector = randomVector * math.random(6, maxdist)
				passes = passes + 1
			until pathfinding.canTraverse(origin, origin + randomVector)
		end

		rage.lastPositionScan = tick()

		return origin + randomVector
	end

	-- auto loop stuffs
	rage.think = function(options, playerStatus, heldWeapon, deltaTime)
		-- not even enabled
		if not options.enabled then
			rage.currentTarget = {}
			return
		end

		-- ur not alive
		local charObject = pfModules.CharacterInterface.getCharacterObject()
		if not charObject then
			rage.currentTarget = {}
			return
		end

		-- patience is a virtue.
		if pfModules.RoundSystemClientInterface.roundLock then
			rage.currentTarget = {}
			return
		end

		if not heldWeapon then
			rage.currentTarget = {}
			return
		end

		local activeCamera = pfModules.CameraInterface.getActiveCamera("MainCamera")
		local enemySet = rage.getEnemies()

		-- yeaaaa we killed everyone lol, vaderhaxx is just too good
		if #enemySet < 1 then
			rage.currentTarget = {}
			return
		end

		if rage.teleporting then
			rage.currentTarget = {}
			return
		end

		-- filter out dudes that are out of fov (if we have an fov cap)
		local sortedSet = options.maximumFov == 181 and enemySet or rage.filterEnemies(enemySet, options.maximumFov, activeCamera._cframe.p, activeCamera._cframe.LookVector.unit)

		-- knifebot or shootbot>?!> ?>!?
		if heldWeapon:getWeaponType() == "Melee" then
			if not options.knifeEnable then
				return
			end
			return rage.processKnifeBot(rage.baseFirePos, sortedSet, {
				throughWalls = options.knifeThroughWalls,
				pathfinded = options.knifePathfinded,
				knifeRadius = options.knifeRadius,
				simTime = 1/20,
				nodeSize = 4,
			})
		else
			-- what are u shooting??!?! air??!
			if heldWeapon._magCount == 0 and heldWeapon.reload then
				task.spawn(heldWeapon.reload, heldWeapon)
				rage.currentTarget = {}
				return
			end

			-- nope ! !
			if heldWeapon._nextShot and pfModules.GameClock.getTime() <= heldWeapon._nextShot then
				return
			else
				rage.currentTarget = {}
			end

			-- this is bad because it delays shot on spawn, so if the user doesnt care abt equip time then skip it
			if options.waitForEquip and not heldWeapon:isEquipped() then
				rage.currentTarget = {}
				return
			end

			-- idk pasted from bbot v2
			if not heldWeapon:isState("chambered") then
				rage.currentTarget = {}
				return
			end

			-- ok who ISNT damage predicted' (json wont stop screaming at me for this :sad:)
			local filteredSet = {}
			for i, data in next, sortedSet do
				if options.predictDamage == false or data.predictedDamage < data.health then
					filteredSet[1 + #filteredSet] = data
				end
			end

			-- ok so the first person in the enemyPassed table that can be shot, will be shot, so this order is important
			local enemyPassed = {}

			-- ok so try to shoot priority players first
			if #filteredSet > 0 then
				local priorities = {}
				for i, data in next, filteredSet do
					if playerStatus and playerStatus[data.plr.UserId] and playerStatus[data.plr.UserId].priority == true then
						priorities[1 + #priorities] = {data, i}
					end
				end
				if #priorities > 1 then
					local rand = priorities[#priorities > 1 and math.random(#priorities) or 1]
					enemyPassed[1 + #enemyPassed] = rand[1]
					table.remove(filteredSet, rand[2])
				end
			end

			-- then try to shoot cheaters
			if #filteredSet > 0 then
				table.sort(filteredSet, function(a, b)
					return a.violationLevel > b.violationLevel
				end)
				if filteredSet[1] and filteredSet[1].violationLevel >= 100 then
					enemyPassed[1 + #enemyPassed] = filteredSet[1]
					table.remove(filteredSet, 1)
				end
			end

			-- then try to shoot spawning players (NEVER ADDED ! ! ! ! ! ! WAS POINTLESS ANYYWAY)

			-- then a cycle thru the remaining players
			if #filteredSet > 0 then
				for i = 1, 1 do
					rage.cycleNumber = rage.cycleNumber + 1
					local nextEnemyIndex = rage.cycleNumber
					if nextEnemyIndex > #filteredSet then
						nextEnemyIndex = 1
						rage.cycleNumber = 1
					end

					enemyPassed[1 + #enemyPassed] = filteredSet[nextEnemyIndex]
					table.remove(filteredSet, nextEnemyIndex)
				end
			end

			if options.waitForSpawn then
				for i, v in next, enemyPassed do
					if #v.updates < 1 then
						table.remove(enemyPassed, i)
					end
				end
			end

			-- what :sad: ??? we've been hit by a cosmic ray
			if #enemyPassed < 1 then
				rage.currentTarget = {}
				return
			end

			-- thats WAY too many options lady vadurrrr - Invaded#5143
			local result, enemy = rage.processAimBot(rage.baseFirePos, charObject._velocity, enemyPassed, {bulletspeed = options.bulletSpeed, penetrationdepth = options.maximumWallBang}, options)

			-- fail !
			if not result then
				return
			end

			-- un-fail
			rage.processResult(rage.baseFirePos, result, enemy, heldWeapon, options)
			return
		end
	end

	do
		local options = {}
		rage.rageLoop = runService.RenderStepped:Connect(function(deltaTime)
			-- yup, pass the values from the ui into the think functions
			-- this is the only way the rage knows what the ui lib values are so i kinda like that its
			-- all in one place like this
			-- this also means u can make a script that just has ur own rage config, no need to change the ui values or whatever

			local heldWeapon = currentInfo.heldWeapon()

			if not heldWeapon then
				return
			end

			local heldWeaponData = heldWeapon._weaponData

			-- transfer ui values and other args to the options table
			do
				options.enabled = ui.flags.rage_enabled.value and ui.flags.rage_enabledkey.value
				options.maximumFov = ui.flags.rage_aimbotfov.value
				options.knifeEnable = ui.flags.rage_knifebot.value and ui.flags.rage_knifekey.value
				options.knifeRadius = ui.flags.rage_knifeshift.value
				options.knifeThroughWalls = ui.flags.rage_knifebotignorewalls.value
				options.knifePathfinded = ui.flags.rage_knifebottype.value["infinite aura"] and rage.canTeleport()
				options.waitForEquip = not (ui.flags.misc_gunmods.value and ui.flags.misc_instantequip.value)
				options.autowallHitScan = ui.flags.rage_autowallhitscan.value
				options.teleportingThreshold = ui.flags.rage_hitscandistancebeforeteleport.value
				options.autowallHitScanIncrement = ui.flags.rage_hitscanincrementdistance.value
				options.noFly = false
				options.maximumHitscanningPoints = ui.flags.rage_maxawalls.value
				options.autowallHitscanDistance = ui.flags.rage_hitscandistance.value
				options.cardinalDirections = ui.flags.rage_hitscanpoints.value["cardinal"]
				options.randomDirections = ui.flags.rage_hitscanpoints.value["random"]
				options.circleDirections = ui.flags.rage_hitscanpoints.value["circle"]
				options.cornerDirections = ui.flags.rage_hitscanpoints.value["corner"]
				options.snakeDirections = ui.flags.rage_hitscanpoints.value["snake"]
				options.canTeleport = rage.canTeleport()
				options.pathfinding = ui.flags.rage_pathfinded.value
				options.sorting = ui.flags.rage_hitscanselection.value
				options.sortingBias = ui.flags.rage_hitscanselectbias.value
				options.pathfindEnemyPosition = ui.flags.rage_pathfindingpoints.value["enemy position"]
				options.pathfindingAlgorithim = ui.flags.rage_pathfindingtype.value
				options.pathfindFailedCardinal = ui.flags.rage_pathfindingpoints.value["cardinal"]
				options.pathfindingError = 8
				options.maximumWallBang = ui.flags.rage_autowall.value and heldWeaponData.penetrationdepth or 0
				options.bulletSpeed = heldWeaponData.bulletspeed
				options.pathfindingProcessTime = math.min(1/60, deltaTime)
				options.shiftHitbox = ui.flags.rage_multipoint.value
				options.shiftHitboxIncrements = ui.flags.rage_multipointincrment.value
				options.maximumHitboxShift = ui.flags.rage_multipointdistance.value / 2
				options.cardinalShift = ui.flags.rage_multipointpoints.value["cardinal"]
				options.randomShift = ui.flags.rage_multipointpoints.value["random"]
				options.autoWallTime = 1 / ui.flags.rage_autowallfps.value
				options.waitForSpawn = ui.flags.rage_waitforspawn.value
				options.preference = ui.flags.rage_sorting.value
				options.maximumBackTrack = ui.flags.rage_maxbacktrack.value / 1000
				options.backtrackSamples = ui.flags.rage_backtracksamples.value
				options.resolver = ui.flags.rage_resolver.value
				options.autoFire = ui.flags.rage_autofire.value
				options.predictDamage = ui.flags.rage_damagepred.value
				options.silentAim = ui.flags.rage_silentaim.value
				options.hitbox = ui.flags.rage_hitscanpriority.value["head"] and "Head" or "Torso"
			end
			rage.think(
				options,
				ui.playerListStatus,
				heldWeapon,
				dt
			) 
			return
		end)
	end

	rage.teleportGrenade = function(args, base, enemyPool, grenadeData)
		local charObject = pfModules.CharacterInterface.getCharacterObject()

		for i = 1, #enemyPool do
			local data = enemyPool[i]
			if not data then
				continue
			end
			local latestPos = data.updates[#data.updates].position
			if not latestPos then
				continue
			end
			local result, data = pathfinding.aStar({
				start = base,
				goal = latestPos,
				parameters = {
					step = 2,
					trials = inf,
					weighting = 400,
					mindist = 4,
					maxtime = 1/20
				}
			})

			if result then
				local waypoints = data.waypoints
				local movements = waypoints

				networking.send("stance", "crouch")
				rage.traverseTeleports(movements, false, rage.cancelFlyBypass())

				args[1] = latestPos
				args[2] = newVec3(0, 1, 0)
				args[3] = tickbase:getTickBase()
				args[4] = -(tickbase:getTickBase() + 0.05)
				networking.send("newgrenade", unpack(args))

				rage.traverseTeleports(movements, true, rage.cancelFlyBypass())
				networking.send("stance", charObject._movementMode)

				return true
			end
		end
		return false
	end

	--
	--    options = {
	--        canTeleport = true/false,
	--        returnFailedGrenade = true/false,
	--        sorting = {
	--            {
	--                closest to crosshair = true/false
	--            }
	--            {
	--                closest to player = true/false
	--            }
	--        }
	--    }
	--
	rage.processGrenadeTeleport = function(args, base, enemyPool, origin, originDirection, options)
		local gunInfo = currentInfo.getWeaponInfo()
		local grenadeInfo = gunInfo._activeWeaponRegistry[4]

		if not options.canTeleport or #enemyPool < 1 or grenadeInfo._spareCount < 0 then
			if options.returnFailedGrenade then
				coroutine.wrap(function()
					task.wait()
					grenadeInfo._spareCount = grenadeInfo._spareCount + 1
					local thisIsStupid = {}
					thisIsStupid.__index = thisIsStupid
					thisIsStupid.getWeaponType = function()
						return "Grenade"
					end
					thisIsStupid.getSpareCount = function()
						return grenadeInfo._spareCount
					end
					pfModules.HudStatusInterface.updateAmmo(thisIsStupid)
				end)()
			end
			return true
		end

		local sortList = {}
		if options.sorting["closest to player"] then
			for i, data in next, enemyPool do
				local char = data.character
				if char then
					local centerMass = char.Torso
					local dist = (centerMass.Position - base).Magnitude

					sortList[1 + #sortList] = {
						plr = data.plr,
						data = data,
						sort = dist
					}
				end
			end
		else
			for i, data in next, enemyPool do
				local char = data.character
				if char then
					local centerMass = char.Torso
					local lookAtEnemy = CFrame.new(origin, centerMass.Position).LookVector.unit
					local angle = toDeg * mathematics.angleBetweenVector3(CFrame.new(origin, origin + originDirection), lookAtEnemy)

					sortList[1 + #sortList] = {
						plr = data.plr,
						data = data,
						sort = angle
					}
				end
			end
		end

		table.sort(sortList, function(a, b)
			return a.sort < b.sort
		end)

		local prioritizedPool = {}
		for i = 1, #sortList do
			local data = sortList[i].data
			prioritizedPool[1 + #prioritizedPool] = data
		end

		local result = rage.teleportGrenade(args, base, prioritizedPool, grenadeInfo)

		if not result and options.returnFailedGrenade then
			coroutine.wrap(function()
				task.wait()
				grenadeInfo._spareCount = grenadeInfo._spareCount + 1
				local thisIsStupid = {}
				thisIsStupid.__index = thisIsStupid
				thisIsStupid.getWeaponType = function()
					return "Grenade"
				end
				thisIsStupid.getSpareCount = function()
					return grenadeInfo._spareCount
				end                    
				pfModules.HudStatusInterface.updateAmmo(thisIsStupid)
			end)()
			return true
		end

		return result
	end

	rage.onNewGrenade = function(args)
		if not ui.flags.rage_nadetp.value then
			return
		end
		return rage.processGrenadeTeleport(args, rage.baseFirePos, rage.getEnemies(), camera.CFrame.p, camera.CFrame.LookVector.unit, {
			canTeleport = rage.canTeleport(),
			sorting = ui.flags.rage_nadetptype.value,
			returnFailedGrenade = ui.flags.rage_nadecanceltp.value
		})
	end
	-- auto shoot done right
	rage.firearmObjectShootHook = hooks.trampoline(pfModules.FirearmObject, "shoot", function(self, ...)
		if rage.currentTarget.results and not ui.flags.rage_autofire.value and pfModules.GameClock.getTime() > self._nextShot and self:isEquipped() and self:isState("chambered") and self._magCount > 0 then
			rage.processResult(rage.baseFirePos, rage.currentTarget.results, rage.currentTarget.pInfo, self, {
				autoFire = true,
				silentAim = ui.flags.rage_silentaim.value,
				hitbox = ui.flags.rage_hitscanpriority.value["head"] and "Head" or "Torso",
			})
			return
		end
		rage.firearmObjectShootHook.old(self, ...)
	end)
	-- dude..... stop making it bad Invaded#5143.
	rage.jitterAngles = {
		flip = false,
		yaw = {
			off = function(jitterAngle)
				return 0
			end,
			step = function(jitterAngle)
				return (rage.jitterAngles.flip and -jitterAngle or jitterAngle)
			end,
			random = function(jitterAngle)
				return math.random() * (math.random(2) == 2 and 1 or -1) * jitterAngle
			end
		},
		getJitter = function(jitterAngle, jitterType)
			rage.jitterAngles.flip = not rage.jitterAngles.flip
			return rage.jitterAngles.yaw[jitterType](jitterAngle)
		end
	}
	rage.baseAntiAimAngles = {
		yawStart = tick(),
		pitch = {
			off = function(pitchAngle)
				return pitchAngle
			end,
			up = function(pitchAngle)
				return 2
			end,
			down = function(pitchAngle)
				return -2
			end,
			zero = function(pitchAngle)
				return 0
			end,
			default = function(pitchAngle)
				local activeCamera = pfModules.CameraInterface.getActiveCamera("MainCamera")
				return activeCamera._minAngle * 0.92
			end,
			["default up"] = function(pitchAngle)
				local activeCamera = pfModules.CameraInterface.getActiveCamera("MainCamera")
				return activeCamera._minAngle * -0.92
			end,
			["45 up"] = function(pitchAngle)
				local activeCamera = pfModules.CameraInterface.getActiveCamera("MainCamera")
				return activeCamera._minAngle * -0.5
			end,
			["45 down"] = function(pitchAngle)
				local activeCamera = pfModules.CameraInterface.getActiveCamera("MainCamera")
				return activeCamera._minAngle * 0.5
			end,
			random = function(pitchAngle)
				return (math.random() * (math.random(2) == 2 and -1 or 1)) * 2
			end,
			bob = function(pitchAngle)
				return math.sin(tick() * 10) * 2
			end,
			["roll forward"] = function(pitchAngle)
				return 2 * math.sin(((((2 * pi / 2) / pi)) * math.atan(1/math.tan((pi * 1.24 * tick()/1)))))
			end,
			["roll backward"] = function(pitchAngle)
				return 2 * math.sin(((((2 * pi / 2) / pi)) * math.atan(1/math.tan((pi * 1.24 * tick()/1)))))
			end,
			["shaky"] = function(pitchAngle)
				local speed = 2
				return math.sin(math.sin(math.sin(math.sin(tick() * pi * speed * 4) + tick() * pi * speed * 2) + tick() * pi * speed) * 2) * 2
			end,
		},
		getPitch = function(pitchAngle, type)
			return rage.baseAntiAimAngles.pitch[type](pitchAngle)
		end,
		yaw = {
			off = function(yawAngle, yawAdd)
				return yawAngle
			end,
			forward = function(yawAngle, yawAdd)
				return yawAngle + yawAdd
			end,
			backward = function(yawAngle, yawAdd)
				return yawAngle - pi + yawAdd
			end,
			random = function(yawAngle, yawAdd)
				return yawAngle + (math.random() * (math.random(2) == 2 and -1 or 1) * 360 * toRad * yawAdd)
			end,
			spin = function(yawAngle, yawAdd)
				return ((tick() - rage.baseAntiAimAngles.yawStart) * yawAdd)
			end,
			["sway spin"] = function(yawAngle, yawAdd)
				return ((tick() - rage.baseAntiAimAngles.yawStart) * yawAdd) + (math.floor(((tick() - rage.baseAntiAimAngles.yawStart) * yawAdd) / pi) * pi * (yawAdd / pi))
			end,
			["cycle spin"] = function(yawAngle, yawAdd)
				return mathematics.normalizeAngle(((tick() - rage.baseAntiAimAngles.yawStart) * yawAdd)) * 2
			end,
			["robotic spin"] = function(yawAngle, yawAdd)
				return (tick() * yawAngle) - (math.sin(tick() * yawAngle * pi))
			end,
			["glitch spin"] = function(yawAngle, yawAdd)
				return 16478887
			end,
		},
		getYaw = function(yawAngle, yawAddAngle, baseType, jitterAngle, jitterType)
			return rage.baseAntiAimAngles.yaw[baseType](yawAngle, toRad * yawAddAngle) + rage.jitterAngles.getJitter(toRad * jitterAngle, jitterType)
		end
	}
	rage.fakePosition = {
		inStorage = {},
		currentChoke = tick(),
		working = false,
		maxChoke = 3,
		freestanding = function(base, minimumDistance, freestandingDistance)
			local canFreestandBy = {}
			local directions = {}

			for x = -1, 1 do
				for z = -1, 1 do
					if x == 0 and z == 0 then
						continue
					end
					local thisVector = newVec3(x, 0, z).unit
					directions[1 + #directions] = thisVector
				end
			end

			for _, dir in next, directions do
				local traverseDirection = dir * freestandingDistance
				local cannotTraverse = pathfinding.canTraverse(base, traverseDirection + dir)

				local traverseTo = cannotTraverse and (cannotTraverse.Position - traverseDirection.unit) or base + traverseDirection
				local canFreestand = (traverseTo - base)
				local freestandMag = canFreestand.Magnitude

				if freestandMag < minimumDistance then
					continue
				end

				canFreestandBy[1 + #canFreestandBy] = canFreestand
			end

			table.sort(canFreestandBy, function(a, b)
				return a.Magnitude > b.Magnitude
			end)

			return canFreestandBy
		end,
		legacyOnRepupdate = function(args)    
			local fakePosition
			local realPosition     
			local projectedPosition = args[1]

			if tick() - rage.fakePosition.currentChoke <= rage.fakePosition.maxChoke then
				return true
			end

			rage.fakePosition.currentChoke = tick()

			-- this is how i can walk around a lil with this
			if not rage.fakePosition.fakePosition then -- our first time doing this
				fakePosition = args[1]
				local freestandingVectors = rage.fakePosition.freestanding(fakePosition, 0, ui.flags.rage_desyncst.value)
				local freestandingVector = freestandingVectors[math.random(#freestandingVectors)]
				realPosition = fakePosition + freestandingVector
			else
				local toPreviousVector = rage.fakePosition.fakePosition - projectedPosition
				local launchVector = toPreviousVector.unit * -1
				local launchPosition = launchVector + projectedPosition
				if (projectedPosition - rage.fakePosition.fakePosition).Magnitude < 3.5 or pathfinding.canTraverse(rage.fakePosition.fakePosition, projectedPosition - rage.fakePosition.fakePosition) or pathfinding.canTraverse(projectedPosition, launchVector) then -- if we cant move without risking getting hit or we dont have line of sight then re do the same thing
					fakePosition = rage.fakePosition.fakePosition

					local freestandingVectors = rage.fakePosition.freestanding(fakePosition, 0, ui.flags.rage_desyncst.value)
					local freestandingVector = freestandingVectors[math.random(#freestandingVectors)]

					realPosition = fakePosition + freestandingVector
				else -- else set the fake to now and the real in between previous and real, due to tickbase shifting, our body ends up being delayed and goes to the realposition, this is bad, this will fix it
					fakePosition = projectedPosition
					realPosition = launchPosition
				end
			end

			networking.send("repupdate", realPosition, args[2], args[2], tickbase:getTickBase())
			networking.send("repupdate", fakePosition, args[2], args[3], tickbase:shift(2))

			rage.fakePosition.realPosition = realPosition
			rage.fakePosition.fakePosition = fakePosition

			rage.baseFirePos = fakePosition
			rage.baseAngles = args[2]
			rage.baseAngles2 = args[3]

			visuals.thirdPerson.animations.repupdate({realPosition, args[2], args[3], tickbase:getTickBase()})

			return true
		end,
		-- i pray to god this works
		onRepupdate = function(args)
			if ui.flags.rage_instantdesync.value then
				local desyncst = math.min(ui.flags.rage_desyncst.value, 999)
				local fakePosition
				local realPosition

				local firstDir = math.random() > 0.5 and 1 or -1
				local rayUpPos = nil
				local relDir = 0
				for i = 1, 2 do
					local rayUpHit, relrayUpPos = workspace:FindPartOnRayWithWhitelist(Ray.new(args[1], Vector3.new(0, firstDir * desyncst, 0)), {workspace.Map}, true)
					relrayUpPos = relrayUpPos - Vector3.new(0, 2 * firstDir, 0)
					if (relrayUpPos - args[1]).Magnitude > 1 then -- fail  
						rayUpPos = relrayUpPos
						relDir = firstDir
					end
					firstDir = firstDir * -1
				end
				
				if not rayUpPos or args[1] ~= rage.baseFirePos then -- fail
					return false
				end

				fakePosition = args[1]
				realPosition = rayUpPos

				if tick() - rage.fakePosition.currentChoke <= rage.fakePosition.maxChoke then
					return true
				end

				rage.fakePosition.currentChoke = tick()

				local randDist = ((realPosition - fakePosition).Magnitude - desyncst) * math.random()
				realPosition = fakePosition + newVec3(0, relDir * desyncst, 0) + newVec3(0, relDir * randDist, 0)
				networking.send("repupdate", realPosition, args[2], args[3], tickbase:getTickBase())

				coroutine.wrap(function()
					task.wait(1/ui.flags.rage_desyncms.value)
					networking.send("repupdate", fakePosition + newVec3(0, math.random() * 0.05, 0), args[2], args[3], tickbase:getTickBase())
				end)()

				rage.fakePosition.realPosition = realPosition
				rage.fakePosition.fakePosition = fakePosition

				rage.baseFirePos = fakePosition
				rage.baseAngles = args[2]
				rage.baseAngles2 = args[3]

				visuals.thirdPerson.animations.repupdate({realPosition, args[2], args[3], tickbase:getTickBase()})

				return true
			else
				local desyncst = math.min(ui.flags.rage_desyncst.value, 999)
				local fakePosition
				local realPosition
	
				local firstDir = math.random() > 0.5 and 1 or -1
				local rayUpPos = nil
				local relDir = 0
				for i = 1, 2 do
					local rayUpHit, relrayUpPos = workspace:FindPartOnRayWithWhitelist(Ray.new(args[1], Vector3.new(0, firstDir * desyncst, 0)), {workspace.Map}, true)
					relrayUpPos = relrayUpPos - Vector3.new(0, 2 * firstDir, 0)
					if (relrayUpPos - args[1]).Magnitude > 1 then -- fail  
						rayUpPos = relrayUpPos
						relDir = firstDir
					end
					firstDir = firstDir * -1
				end
	
				if not rayUpPos or args[1] ~= rage.baseFirePos then -- fail  
					return false
				end
	
				fakePosition = args[1]
				realPosition = rayUpPos
	
				if tick() - rage.fakePosition.currentChoke <= rage.fakePosition.maxChoke then
					return true
				end
	
				rage.fakePosition.currentChoke = tick()

	

				local newVectors = rage.fakePosition.freestanding(fakePosition, 0, desyncst)

				local newVector = newVectors[math.random(#newVectors)]

				 -- ok this is great and all but we need to make sure we dont get stuck in a wall
				local passes = 0

				repeat
					if passes > 10 then
						-- method fail :frown:
						return false
					end

					newVector = newVectors[math.random(#newVectors)]
					realPosition = fakePosition + newVector
					task.wait()
					--ui:createnotification({text = "waiting on valid traversal position", lifetime = 0.5, priority = 0})
					passes = passes + 1
				until pathfinding.canTraverse(fakePosition, realPosition + fakePosition)

				realPosition = realPosition + Vector3.new(0, (math.pi / 2 * (math.random() * 0.05)), 0)
				networking.send("repupdate", realPosition, args[2], args[3], tickbase:getTickBase())

				coroutine.wrap(function()
					task.wait(1/ui.flags.rage_desyncms.value)
					--ui:createnotification({text = "fake position choked", lifetime = 1, priority = 0})
					networking.send("repupdate", fakePosition, args[2], args[3], tickbase:getTickBase())
				end)()
	
				rage.fakePosition.realPosition = realPosition
				rage.fakePosition.fakePosition = fakePosition
	
				rage.baseFirePos = fakePosition
				rage.baseAngles = args[2]
				rage.baseAngles2 = args[3]
	
				visuals.thirdPerson.animations.repupdate({realPosition, args[2], args[3], tickbase:getTickBase()})
	
				return true
			end
		end,
	}

	rage.lowerArms = {
		-- this used to lower arms really far down for no reason at all
		--onRepupdate = function()
		--    local gunInfo = currentInfo.getWeaponInfo()
		--    local weaponNumber = gunInfo._activeWeaponIndex
		--    
		--    networking.send("equip", weaponNumber == 3 and 1 or 3)
		--    networking.send("equip", weaponNumber)
		--end,
		onSprint = function(args)
			args[1] = true
		end,
	}
	rage.tiltNeck = {
		onAim = function(args)
			args[1] = true
		end,
	}
	rage.forceStance = {
		onStance = function(args, stance)
			args[1] = stance
		end
	}

	misc.noclipping = {
		freeCam = false,
	}
	-- noclibbing
	rage.onRepupdate = function(args)
        --[[if ui.flags.misc_noclip.value and ui.flags.misc_noclipkey.value and ui.flags.misc_fly.value and ui.flags.misc_flykey.value then
            if misc.noclipping.freeCam ~= true then
                misc.noclipping.startedFrom = rage.baseFirePos
                misc.noclipping.freeCam = true
                ui:createnotification({text = "starting noclip. you are in free camera mode", lifetime = 5, priority = 0})
            end
            args[1] = misc.noclipping.startedFrom
        else
            if misc.noclipping.freeCam == true then
                misc.noclipping.freeCam = false
                
                local startedFrom = misc.noclipping.startedFrom
                local success, teleports = misc.noClip(startedFrom, args[1])
                
                misc.noclipping.startedFrom = nil
                
                if success == true then
                    local charObject = pfModules.CharacterInterface.getCharacterObject()
                    
                    networking.send("stance", "crouch")
                    rage.traverseTeleports(teleports, false, true)
                    networking.send("stance", charObject._movementMode)
                    
                    networking.send("repupdate", args[1], rage.baseAngles, rage.baseAngles2, tickbase:getTickBase())
                    args[4] = tickbase:shift(1/90)

                    localPlayer.Character.HumanoidRootPart.Position = args[1]

                    ui:createnotification({text = "noclipped!", lifetime = 5, priority = 0})
                else
                    localPlayer.Character.HumanoidRootPart.Position = startedFrom
                    args[1] = startedFrom
                    ui:createnotification({text = "failed to noclip", lifetime = 5, priority = 0})
                end
            end
        end]]

		--[[if rage.teleporting then
			visuals.thirdPerson.animations.repupdate({args[1], args[2], args[3], args[4]})
			if not rage.teleporting.teleported then
				rage.teleporting.teleported = true

				networking.send("repupdate", rage.teleporting.movements[rage.teleporting.traversing], args[2], args[3], args[4])

				rage.teleporting.traversing += rage.teleporting.inversed and -1 or 1

				if rage.teleporting.traversing > (rage.teleporting.inversed and 1 or #rage.teleporting.movements) then
					rage.baseFirePos = args[1]

					networking.send("repupdate", args[1], args[2], args[3], args[4])
				else
					networking.send("repupdate", rage.teleporting.movements[rage.teleporting.traversing], args[2], args[3], args[4])
				end

				return true
			else
				if rage.teleporting.traversing > (rage.teleporting.inversed and 1 or #rage.teleporting.movements) then
					local charObject = pfModules.CharacterInterface.getCharacterObject()
					local rootPart = charObject and charObject._rootPart

					if rootPart then
						rootPart.Position = rage.baseFirePos
					end

					rage.teleporting = nil
				end

				if rage.teleporting then
					rage.teleporting.teleported = false
				end
				return true
			end
		end]]

		if tickbase.tickShift > 0 then
			tickbase.tickShift -= 1
			return true
		end

		local blockNext = false
		if ui.flags.rage_antiaim.value then
			local pitch = args[2].x
			local yaw = args[2].y

			local pitchChoices = ui.flags.rage_antiaimpitch.value
			local pitchChoice = "off"
			for i, v in next, pitchChoices do
				if v then 
					pitchChoice = i 
					break
				end
			end

			local newPitch = rage.baseAntiAimAngles.getPitch(pitch, pitchChoice)

			local yawChoices = ui.flags.rage_antiaimyaw.value
			local yawChoice = "off"
			for i, v in next, yawChoices do
				if v then 
					yawChoice = i
					break
				end
			end

			local yawJitterChoices = ui.flags.rage_antiaimyawjitter.value
			local yawJitterChoice = "off"
			for i, v in next, yawJitterChoices do
				if v then 
					yawJitterChoice = i
					break
				end
			end

			local newYaw = rage.baseAntiAimAngles.getYaw(yaw, ui.flags.rage_antiaimyawdeg.value, yawChoice, ui.flags.rage_antiaimyawjitterdeg.value, yawJitterChoice)

			args[2] = newVec3(newPitch, newYaw)

			--if ui.flags.rage_lowerarms.value then
			--    rage.lowerArms.onRepupdate()
			--end

			if ui.flags.rage_desync.value then
				blockNext = rage.fakePosition.onRepupdate(args)
			end
		end
		if not blockNext then
			if ui.flags.misc_bypassspeed.value then
				if rage.baseFirePos and rage.baseFirePos ~= emptyVec3 then
					networking.send("repupdate", rage.baseFirePos, args[2], args[3], args[4])
					tickbase.tickShift += 1
				end
			end			

			rage.baseFirePos = args[1]
			rage.baseAngles = args[2]
			rage.baseAngles2 = args[3]
		end
		rage.fakePosition.working = blockNext
		return blockNext
	end

	rage.onSpawn = function(args)
		misc.noclipping.freeCam = false
		misc.noclipping.startedFrom = nil
		rage.fakePosition.fakePosition = nil
		table.clear(rage.fakePosition.inStorage)
	end

	rage.onStance = function(args)
		local selection = "off"
		for i, v in next, ui.flags.rage_antiaimforcestance.value do
			if v == true then
				selection = i
			end
		end
		if selection ~= "off" and ui.flags.rage_antiaim.value then
			rage.forceStance.onStance(args, selection)
		end
	end

	rage.onSprint = function(args)
		if ui.flags.rage_lowerarms.value and ui.flags.rage_antiaim.value then
			rage.lowerArms.onSprint(args)
		end
	end

	rage.onAim = function(args)
		if ui.flags.rage_necktilt.value and ui.flags.rage_antiaim.value then
			rage.tiltNeck.onAim(args)
		end
	end

	rage.onEquip = function(args)
		if ui.flags.misc_fakeequip.value and args[3] ~= 3 then
			args[1] = ui.flags.misc_fakeequipslot.value["primary"] and 1 or ui.flags.misc_fakeequipslot.value["secondary"] and 2 or ui.flags.misc_fakeequipslot.value["melee"] and 3
		end
	end

	function rage.handleFakeEquip(action, args)
		if ui.flags.misc_fakeequip.value then
			local weaponIndex = currentInfo.getWeaponInfo()._activeWeaponIndex
			local equipSlot = ui.flags.misc_fakeequipslot.value
			networking.send("equip", weaponIndex, tickbase:getTickBase())
			visuals.thirdPerson.animations.equip({weaponIndex})
			networking.send(action, unpack(args))
			networking.send("equip", equipSlot["primary"] and 1 or equipSlot["secondary"] and 2 or equipSlot["melee"] and 3, tickbase:getTickBase())
			visuals.thirdPerson.animations.equip({equipSlot["primary"] and 1 or equipSlot["secondary"] and 2 or equipSlot["melee"] and 3})
			return true
		end
	end
	rage.onOutgoingNewBullets = function(args)
		return rage.handleFakeEquip("newbullets", args)
	end
	rage.onSwapWeapon = function(args)
		return rage.handleFakeEquip("swapweapon", args)
	end
	rage.onGetAmmo = function(args)
		return rage.handleFakeEquip("getammo", args)
	end
	rage.onReload = function(args)
		return rage.handleFakeEquip("reload", args)
	end

	-- detect certain cheats
	rage.onClientNewBullets = function(args)
		local fromPlayer = args[1].player
		local pInfo = playerInfo.list[fromPlayer]

		if not pInfo or not pInfo.updates or #pInfo.updates < 1 then
			return
		end

		-- check for tp scanning by comparing their last rep to their fire pos, if its too far they had to have tp'd for this bullet to go thru
		if (args[1].firepos - pInfo.updates[#pInfo.updates].position).Magnitude > rage.detectionThreshold.firePos then
			pInfo.violationLevel = pInfo.violationLevel + 300
		end

		-- check if all the pellets have the exact same spread (shotgun only)
		local theSame = false
		local startingTrajectory
		for i, v in next, args[1].bullets do
			if not startingTrajectory then
				startingTrajectory = v.Velocity
			else
				if v.velocity == startingTrajectory then
					theSame = true
				end
			end
		end

		if theSame then
			pInfo.violationLevel = pInfo.violationLevel + 300
		end

		if startingTrajectory then
			-- this is a bit inconistent but check if their bullet went where they were looking
			local theirLookVec = mathematics.pitchYawToLookVec(pInfo.angles.x, pInfo.angles.y)
			local angle = toDeg * math.abs(mathematics.angleBetweenVector3(CFrame.new(pInfo.character.Head.Position, pInfo.character.Head.Position + theirLookVec.unit), startingTrajectory.unit))
			if #pInfo.updates > 2 and angle > rage.detectionThreshold.spreadAngle then
				pInfo.violationLevel = pInfo.violationLevel + 300
			end
		end
	end
	-- rel

	rage.LocalSpawner = pfModules.CharacterEvents.onSpawned:Connect(function(args1, ...)
		rage.onSpawn()
		rage.baseFirePos = emptyVec3
		rage.teleporting = nil
		task.wait()
		pfModules.NetworkClient:send("stance", "stand")
		pfModules.NetworkClient:send("sprint", false)
		pfModules.NetworkClient:send("aim", false)
		pfModules.NetworkClient:send("equip", 1, tickbase:getTickBase())
	end)

	

	do
		local lastSpawn = 0
		local lastNotification = 0
		local spawnProtectionRemaining = 0
	
		networking.addListener("spawn", 10002023, function(args)    
			if not ui.flags.spawn_protection.value then
				return
			end

			lastSpawn = tick()
			spawnProtectionRemaining = ui.flags.spawn_protection_duration.value
			--ui:createnotification({text = "Spawn protection enabled for " .. spawnProtectionRemaining .. " seconds.", lifetime = 1, priority = 1})
		end)
	
		networking.addHook("repupdate", 10000, function(args)
			if not ui.flags.spawn_protection.value then
				return
			end
			
			if tick() - lastSpawn < ui.flags.spawn_protection_duration.value then
				if tick() - lastNotification >= 1 then
					--ui:createnotification({text = spawnProtectionRemaining .. " seconds of spawn protection remaining.", lifetime = 1, priority = 1})
	
					lastNotification = tick()
					spawnProtectionRemaining = spawnProtectionRemaining - 1
				end
	
				return true
			end
		end)
	end

	networking.addListener("newbullets", -1, rage.onClientNewBullets)
	networking.addHook("equip", -1, rage.onEquip)
	networking.addHook("reload", -1, rage.onReload)
	networking.addHook("swapweapon", -1, rage.onSwapWeapon)
	networking.addHook("getammo", -1, rage.onGetAmmo)
	networking.addHook("newbullets", -100, rage.onOutgoingNewBullets)
	networking.addHook("repupdate", -1, rage.onRepupdate)
	-- networking.addHook("spawn", 0, rage.onSpawn)
	networking.addHook("stance", 0, rage.onStance)
	networking.addHook("aim", 0, rage.onAim)
	networking.addHook("sprint", 0, rage.onSprint)
	networking.addHook("newgrenade", -1, rage.onNewGrenade)
end

-- esp
do
	-- skidded from bloxsense v3 (integer wrote the framework or whatever i just wrote a new bounding box for pf and added new flags n shit)
	esp.espData = {}
	esp.physicalFolder = Instance.new("Folder", game.CoreGui)
	esp.allDrawingObjects = {}
	esp.createDrawing = function(type, prop)
		local obj = Drawing.new(type)
		Drawings[1 + #Drawings] = obj
		if prop then
			for index,value in next, prop do
				obj[index] = value
			end
		end
		obj.ZIndex = -1
		table.insert(esp.allDrawingObjects, obj)
		return obj
	end
	esp.mainTexts = {"nameText", "weaponText", "distanceText", "healthText"}
	esp.flagTexts = {"rankText", "exploitText", "stanceText", "visibleText"}
	esp.boneLines = {"Headbone", "Right Armbone", "Left Armbone", "Right Legbone", "Left Legbone"}
	esp.gradentHealthBarSegments = 20
	esp.defaultProperties = {
		outlineBox = {
			Visible = false,
			Opacity = 0.7,
			Color = Color3.fromRGB(10, 10, 10),
			Thickness = 3,
			Filled = false
		},
		box = {
			Visible = false,
			Opacity = 1,
			Color = Color3.fromRGB(255, 255, 255),
			Thickness = 1,
			Filled = false
		},
		boxFilled = {
			Visible = false,
			Opacity = 0.1,
			Color = Color3.fromRGB(255, 255, 255),
			Filled = true
		},
		healthBarBack = {
			Visible = false,
			Opacity = 0.7,
			Color = Color3.fromRGB(10, 10, 10),
			Thickness = 1,
			Filled = true
		},
		healthBarOutline = {
			Visible = false,
			Opacity = 0.7,
			Color = Color3.fromRGB(10, 10, 10),
			Filled = false,
			Thickness = 1,
		},
		healthBar = {
			Visible = false,
			Opacity = 1,
			Color = Color3.fromRGB(0, 255, 0),
			Thickness = 1,
			Filled = true
		},
		mainText = {
			Visible = false,
			Size = 13,
			Font = Drawing.Fonts.Plex,
			Color = Color3.fromRGB(255, 255, 255),
			Opacity = 1,
			Centered = true,
			Outlined = true
		},
		flagText = {
			Visible = false,
			Size = 13,
			Font = Drawing.Fonts.Plex,
			Color = Color3.fromRGB(255, 255, 255),
			Opacity = 1,
			Centered = true,
			Outlined = true
		},
		headDot = {
			Visible = false,
			Opacity = 1,
			Filled = true,
		},
		bone = {
			Thickness = 1,
			Color = Color3.fromRGB(255, 255, 255),
			Opacity = 1,
			Visible = false
		},
		viewAngleLine = {
			Thickness = 1,
			Color = Color3.fromRGB(255, 255, 255),
			Opacity = 1,
			Visible = false
		},
		oofArrow = {
			Visible = false,
			Filled = true,
			Color = Color3.fromRGB(255, 0, 255),
			Opacity = 1
		},
		oofArrowOutline = {
			Visible = false,
			Filled = true,
			Color = Color3.fromRGB(255, 0, 255),
			Opacity = 1,
		},
		snapLine = {
			Thickness = 1,
			Color = Color3.fromRGB(255, 255, 255),
			Opacity = 1,
			Visible = false
		},
	}

	esp.initializeDrawingObjects = function(onScreen, offScreen, general)
		-- box
		onScreen.outlineBox         = {
			object = esp.createDrawing("Square", esp.defaultProperties.outlineBox),
			originalTransparency = esp.defaultProperties.outlineBox.Opacity
		}
		onScreen.box                = {
			object = esp.createDrawing("Square", esp.defaultProperties.box),
			originalTransparency = esp.defaultProperties.box.Opacity
		}

		onScreen.boxFilled          = {
			object = esp.createDrawing("Square", esp.defaultProperties.boxFilled),
			originalTransparency = esp.defaultProperties.boxFilled.Opacity
		}

		-- health bar
		onScreen.healthBarBack   = {
			object = esp.createDrawing("Square", esp.defaultProperties.healthBarBack),
			originalTransparency = esp.defaultProperties.healthBarBack.Opacity
		}
		onScreen.healthBarOutline  = {
			object = esp.createDrawing("Square", esp.defaultProperties.healthBarOutline),
			originalTransparency = esp.defaultProperties.healthBarOutline.Opacity
		}
		onScreen.healthBar          = {
			object = esp.createDrawing("Square", esp.defaultProperties.healthBar),
			originalTransparency = esp.defaultProperties.healthBar.Opacity
		}

		for i = 1, esp.gradentHealthBarSegments do
			onScreen["healthBarSegment" .. i]       = {
				object = esp.createDrawing("Square", esp.defaultProperties.healthBar),
				originalTransparency = esp.defaultProperties.healthBar.Opacity
			}
		end

		-- main text
		for i, v in next, esp.mainTexts do
			onScreen[v]             = {
				object = esp.createDrawing("Text", esp.defaultProperties.mainText),
				originalTransparency = esp.defaultProperties.mainText.Opacity
			}
		end

		-- flag text
		for i, v in next, esp.flagTexts do
			onScreen[v]             = {
				object = esp.createDrawing("Text", esp.defaultProperties.flagText),
				originalTransparency = esp.defaultProperties.mainText.Opacity
			}
		end

		-- oof arrow
		offScreen.oofArrow          = {
			object = esp.createDrawing("Triangle", esp.defaultProperties.oofArrow),
			originalTransparency = esp.defaultProperties.oofArrow.Opacity
		}
		offScreen.oofArrowOutline    = {
			object = esp.createDrawing("Triangle", esp.defaultProperties.oofArrowOutline),
			originalTransparency = esp.defaultProperties.oofArrowOutline.Opacity
		}

		-- view angle line
		onScreen.viewAngleLine = {
			object = esp.createDrawing("Line", esp.defaultProperties.viewAngleLine),
			originalTransparency = esp.defaultProperties.viewAngleLine.Opacity
		}

		-- head dot
		onScreen.HeadDot = {
			object = esp.createDrawing("Quad", esp.defaultProperties.headDot),
			originalTransparency = esp.defaultProperties.headDot.Opacity
		}

		-- snap line
		general.snapLine            = {
			object = esp.createDrawing("Line", esp.defaultProperties.snapLine),
			originalTransparency = esp.defaultProperties.snapLine.Opacity
		}

		-- bones
		for i, v in next, esp.boneLines do
			onScreen[v]             = {
				object = esp.createDrawing("Line", esp.defaultProperties.bone),
				originalTransparency = esp.defaultProperties.bone.Opacity
			}
		end
	end

	esp.getBoundingBox = function(headCf, rootCf, llegCf, rlegCf, cacheTable)
		if cacheTable and headCf then      
			cacheTable.rootCf = rootCf
			cacheTable.HeadCf = headCf
			cacheTable.rlegCf = rlegCf
			cacheTable.llegCf = llegCf
		else
			rootCf = cacheTable.rootCf
			headCf = cacheTable.HeadCf
			rlegCf = cacheTable.rlegCf
			llegCf = cacheTable.llegCf
		end

		-- real
		local cfupvec = rootCf.p + rootCf.UpVector * 2
		local upvec = rootCf.p + Vector3.new(0, cfupvec.y - rootCf.p.y, 0) + camera.CFrame.UpVector * 0.55

		local cfdownvec = rootCf.p - rootCf.UpVector * 3
		local cfdownvec = rootCf.p + Vector3.new(0, cfdownvec.y - rootCf.p.y, 0)

		local legdown = (rlegCf.p - rlegCf.UpVector + llegCf.p - llegCf.UpVector) / 2

		local bovec = (legdown.y < cfdownvec.y and cfdownvec - Vector3.new(0, cfdownvec.y, 0) + Vector3.new(0, legdown.y, 0) or cfdownvec) - camera.CFrame.UpVector * 0.64

		local top = mathematics.worldToViewportPoint(upvec)
		local bottom = mathematics.worldToViewportPoint(bovec)

		local center = (top + bottom) / 2
		local height = math.abs(top.y - bottom.y)
		local width = height / 1.64
		local size = Vector2.new(math.floor(width), math.floor(height))
		local pos = Vector2.new(math.floor(center.x - size.x / 2), math.floor(center.y - size.y / 2))

		return Rect.new(pos, pos + size)
	end

	esp.apply = function(player)
		local this = {}

		repeat task.wait()
		until playerInfo.list and playerInfo.list[player]

		this.pInfo = playerInfo.list[player]
		this.DrawingObjects = {
			draw = {
				drawOnScreen    = {},
				drawOffScreen   = {},
				drawGeneral     = {}, --everything in general will always draw if the condition is met
			},
			stoppedRenderingOnScreen    = true,
			stoppedRenderingOffScreen   = true,
			lastData = {
				limbs = {}
			}, -- to preserve pos and rotation
		}

		this.transparencyEvent = Instance.new("BindableEvent")
		this.healthPercentageSpring = spring.new()
		this.healthPercentageSpring.s = 24
		this.timePassed = 0
		this.chamsObjects = {}
		this.chamsTransConnections = {}
		this.updateNextChams = false -- homo!!
		this.transConnections = {}

		esp.initializeDrawingObjects(this.DrawingObjects.draw.drawOnScreen, this.DrawingObjects.draw.drawOffScreen, this.DrawingObjects.draw.drawGeneral)

		for _, container in next, this.DrawingObjects.draw do
			for i, v in next, container do
				table.insert(this.transConnections, this.transparencyEvent.Event:Connect(function(transparency)
					v.object.Opacity = v.originalTransparency * (1 - transparency)
				end))
			end
		end

		this.addChams = function(character)
			local ded = false

			repeat
				task.wait()
				ded = this and this.pInfo and this.pInfo.alive
			until not this or not this.pInfo or #this.pInfo.updates > 2 or this.pInfo.alive == false

			if ded == false then 
				return
			end

			local section = this and this.pInfo and this.pInfo.enemy and "enemy" or "team"

			for i, v in next, character do
				if not v:IsA("BasePart") then
					continue
				end
				local isHead = v == this.pInfo.character["Head"]
				local inner = Instance.new(isHead and "CylinderHandleAdornment" or "BoxHandleAdornment")
				local outline = inner:Clone()

				inner.Name = "inner"
				inner.AlwaysOnTop = true
				inner.Color3 = ui.flags[section .. "_innerchamcolor"].color
				inner.Transparency = ui.flags[section .. "_innerchamcolor"].transparency
				inner.Visible = (ui.flags[section .. "_chams"].value and ui.flags[section .. "_esp"].value) and true or false
				inner.ZIndex = 2
				inner.Adornee = v
				inner.Parent = v

				outline.Name = "outer"
				outline.AlwaysOnTop = false
				outline.Color3 = ui.flags[section .. "_outerchamcolor"].color
				outline.Transparency = ui.flags[section .. "_outerchamcolor"].transparency
				outline.Visible = inner.Visible
				outline.ZIndex = -1
				outline.Adornee = v
				outline.Parent = v

				if isHead then
					inner.CFrame = CFrame.Angles(math.pi / 2, 0, 0)
					inner.Radius = v.Size.x * 0.6 + 0.001
					inner.Height = v.Size.y * 1.3 + 0.001

					outline.CFrame = inner.CFrame
					outline.Radius = v.Size.x * 0.6 + 0.15
					outline.Height = v.Size.y * 1.3 + 0.15
				else
					inner.Size = v.Size + newVec3(0.001, 0.001, 0.001)
					outline.Size = v.Size + newVec3(0.15, 0.15, 0.15)
				end

				table.insert(this.chamsObjects, inner)
				table.insert(this.chamsObjects, outline)
			end
			
			local section = this.pInfo.enemy and "enemy" or "team"
			local show = (ui.flags[section .. "_chams"].value and ui.flags[section .. "_esp"].value) and true or false
			local model = this.pInfo.replicator and this.pInfo.replicator._thirdPersonObject and this.pInfo.replicator._thirdPersonObject._characterModel or nil
			if not model then
				return
			end
			local charHash = this.pInfo.character
			for i, v in next, model:GetChildren() do
				if not (v == charHash.Head or v == charHash.Torso or v == charHash["Left Arm"] or v == charHash["Right Arm"] or v == charHash["Right Leg"] or v == charHash["Left Leg"]) then
					for i2, v2 in next, v:GetChildren() do
						if v2:IsA("MeshPart") or v2:IsA("BasePart") then
							v2.Transparency = show == true and 1 or 0
						end
					end
				end
			end
		end

		this.removeChams = function()
			for i = #this.chamsObjects, 1, -1 do
				local object = this.chamsObjects[i]
				if not object then
					continue
				end
				object:Destroy()
				object = nil
			end
			table.clear(this.chamsObjects)
		end

		local lastShow = false
		this.updateChams = function()
			if this.chamsObjects and this.pInfo then
				local section = this.pInfo.enemy and "enemy" or "team"
				local show = (ui.flags[section .. "_chams"].value and ui.flags[section .. "_esp"].value) and true or false
				for i = 1, #this.chamsObjects do
					local v = this.chamsObjects[i]
					v.Visible = show
					if not this.updateNextChams then
						if v.Name == "inner" then
							v.Color3 = ui.flags[section .. "_innerchamcolor"].color
							v.Transparency = ui.flags[section .. "_innerchamcolor"].transparency
						elseif v.Name == "outer" then
							v.Color3 = ui.flags[section .. "_outerchamcolor"].color
							v.Transparency = ui.flags[section .. "_outerchamcolor"].transparency
						end
					end
				end

				local model = this.pInfo.replicator and this.pInfo.replicator._thirdPersonObject and this.pInfo.replicator._thirdPersonObject._characterModel or nil
				if not model or lastShow == show then
					return
				end
				local charHash = this.pInfo.character
				for i, v in next, model:GetChildren() do
					if not string.lower(v.Name):find("external") and not (v == charHash.Head or v == charHash.Torso or v == charHash["Left Arm"] or v == charHash["Right Arm"] or v == charHash["Right Leg"] or v == charHash["Left Leg"]) then
						for i2, v2 in next, v:GetChildren() do
							if v2:IsA("MeshPart") or v2:IsA("BasePart") then
								v2.Transparency = show == true and 1 or 0
							end
						end
					end
				end
			end
			lastShow = show
		end

		-- auto update the chams when needed
		for i, section in next, {"team", "enemy"} do
			ui.flags[section .. "_esp"].changed:Connect(this.updateChams)
			ui.flags[section .. "_chams"].changed:Connect(this.updateChams)
			ui.flags[section .. "_innerchamcolor"].changed:Connect(this.updateChams)
			ui.flags[section .. "_outerchamcolor"].changed:Connect(this.updateChams)
		end
		localPlayer:GetPropertyChangedSignal("TeamColor"):Connect(function()
			if not this or not this.updateChams then
				return
			end
			this.updateChams()
			task.wait()
			this.updateChams()
		end)
		player:GetPropertyChangedSignal("TeamColor"):Connect(function()
			this.updateChams()
			task.wait() -- idk whats wrong with this
			this.updateChams()
		end)

		local textShading = 0.96 -- looks better or smth idk 
		local uiFlags = ui.flags
		this.renderOnScreen = function(info)
			local health = info.health
			local maxHealth = info.maxHealth
			local pInfo = this.pInfo
			local section = this.pInfo.enemy and "enemy" or "team"

			local bounds = info.boundingRect

			local mainTextCase = uiFlags.espsettings_case.value["lowercase"] and "lowercase" or uiFlags.espsettings_case.value["UPPERCASE"] and "UPPERCASE" or "Normal"
			local mainTextSize = uiFlags.espsettings_size.value
			local mainTextFont = Drawing.Fonts[uiFlags.espsettings_font.value["Plex"] and "Plex" or uiFlags.espsettings_font.value["UI"] and "UI" or uiFlags.espsettings_font.value["Monospace"] and "Monospace" or "System"]
			local flagTextCase = uiFlags.espsettings_flagcase.value["lowercase"] and "lowercase" or uiFlags.espsettings_flagcase.value["UPPERCASE"] and "UPPERCASE" or "Normal"
			local flagTextSize = uiFlags.espsettings_flagsize.value
			local flagTextFont = Drawing.Fonts[uiFlags.espsettings_flagfont.value["Plex"] and "Plex" or uiFlags.espsettings_flagfont.value["UI"] and "UI" or uiFlags.espsettings_flagfont.value["Monospace"] and "Monospace" or "System"]

			local objects = this.DrawingObjects.draw.drawOnScreen

			if info.character then
				for i, v in next, info.character do
					this.DrawingObjects.lastData.limbs[i] = v.Position
				end
			end

			-- skeleton
			local bones = {
				["Head"] = objects.Headbone.object,
				["Right Arm"] = objects["Right Armbone"].object,
				["Left Arm"] = objects["Left Armbone"].object,
				["Right Leg"] = objects["Right Legbone"].object,
				["Left Leg"] = objects["Left Legbone"].object
			}
			
			if uiFlags[section .. "_skeleton"].value and #this.pInfo.updates > 3 then
				local screenpoints = {}

				for i, v in next, (this.DrawingObjects.lastData.limbs) do
					local screenpoint = mathematics.worldToViewportPoint(v)
					screenpoints[i] = newVec2(math.floor(screenpoint.x), math.floor(screenpoint.y))
				end

				for i, v in next, (bones) do
					v.Visible = true
					v.Color = uiFlags[section .. "_skeletoncolor"].color
					v.To = screenpoints.Torso
					v.From = screenpoints[i]
				end
			else
				for i, v in next, (bones) do
					v.Visible = false
				end
			end

			-- box
			local box = objects.box.object
			local boxOutline = objects.outlineBox.object
			local boxFill = objects.boxFilled.object
			if uiFlags[section .. "_box"].value then
				box.Visible = false
				boxFill.Visible = false
				boxOutline.Visible = false

				box.Position = bounds.Min
				box.Size = bounds.Max - bounds.Min

				boxOutline.Position = box.Position
				boxOutline.Size = box.Size

				box.Color = uiFlags[section .. "_boxcolor"].color

				if uiFlags[section .. "_filledbox"].value then
					boxFill.Position = box.Position + newVec2(math.floor(box.Thickness / 2) + 1, math.floor(box.Thickness / 2) + 1)
					boxFill.Size = box.Size - newVec2(box.Thickness + 1, box.Thickness + 1)
					boxFill.Color = uiFlags[section .. "_filledboxcolor"].color
					boxFill.Opacity = 1 - uiFlags[section .. "_filledboxcolor"].transparency
					boxFill.Visible = true
				else
					boxFill.Visible = false
				end

				box.Visible = true
				boxOutline.Visible = true
			else
				box.Visible = false
				boxFill.Visible = false
				boxOutline.Visible = false
			end

			-- health bar
			this.healthPercentageSpring.t = health/maxHealth
			local healthBar = objects.healthBar.object
			local healthBarBack = objects.healthBarBack.object
			local healthBarOutline = objects.healthBarOutline.object
			local healthNumber = objects.healthText.object
			if uiFlags[section .. "_healthbar"].value then
				local hpMax = uiFlags[section .. "_fullhealth"].color
				local hpLow = uiFlags[section .. "_lowhealth"].color

				local healthPercentage = this.healthPercentageSpring.p
				local fullSize = bounds.Height
				local chunk = fullSize * healthPercentage

				healthBar.Size = newVec2(2, chunk)
				healthBar.Position = bounds.Min + newVec2(-4 - 2, fullSize - chunk)
				healthBarBack.Size = newVec2(2 + 2, fullSize + 2)
				healthBarBack.Position = bounds.Min + newVec2(-4 - 2 - 1, -1)

				healthBarOutline.Size = healthBarBack.Size
				healthBarOutline.Position = healthBarBack.Position

				healthBar.Color = hpLow:Lerp(hpMax, healthPercentage)

				local isGradient = uiFlags[section .. "_gradienthealthbar"].value

				healthBar.Visible = not isGradient
				healthBarBack.Visible = true
				healthBarOutline.Visible = true

				if isGradient then
					local sizePerSegment = math.ceil(fullSize / esp.gradentHealthBarSegments)
					local maxSegments = fullSize / sizePerSegment + 1
					local minSegments = chunk / sizePerSegment + 1
					local skipped = maxSegments - minSegments

					local healthPos = healthBar.Position
					local healthSizeX = healthBar.Size.x
					local healthSizeY = healthBar.Size.y

					for i = 1, esp.gradentHealthBarSegments do
						local segment = objects["healthBarSegment" .. i].object

						local projectedPosMin = newVec2(0, (i-1) * sizePerSegment)
						local ProjectedPosMax = projectedPosMin + newVec2(0, sizePerSegment)

						if projectedPosMin.y > chunk then
							segment.Visible = false
							continue
						end

						segment.Visible = true
						segment.Position = healthPos + projectedPosMin
						segment.Size = newVec2(healthSizeX, ProjectedPosMax.y - healthSizeY > 0 and sizePerSegment - (ProjectedPosMax.y - healthSizeY) or sizePerSegment)
						segment.Color = hpMax:Lerp(hpLow, (i + skipped)/maxSegments)
					end
				else
					if objects["healthBarSegment1"].object.Visible == true then
						for i = 1, esp.gradentHealthBarSegments do
							objects["healthBarSegment" .. i].object.Visible = false
						end 
					end
				end

				local projectedHealth = math.round(this.healthPercentageSpring.p * 100)
				if uiFlags[section .. "_healthnumber"].value and projectedHealth <= uiFlags.espsettings_maxhp.value then
					healthNumber.Text = tostring(projectedHealth)
					local offset = (2 * this.healthPercentageSpring.p) - 1 -- will make sure it is contained within the box dimensions at all times
					healthNumber.Position = healthBar.Position + newVec2(-healthBar.Size.x - (healthNumber.TextBounds.X/2) - 1, -healthNumber.TextBounds.Y/2) + newVec2(0, (offset * (healthNumber.Size + 1) * 0.25))
					healthNumber.Color = Color3.new(1, 1, 1)
					healthNumber.OutlineColor = Color3.new(math.clamp(healthNumber.Color.r - textShading, 0, 1), math.clamp(healthNumber.Color.g - textShading, 0, 1), math.clamp(healthNumber.Color.b - textShading, 0, 1))
					healthNumber.Visible = true
				else
					healthNumber.Visible = false
				end
			else
				healthBar.Visible = false
				healthBarBack.Visible = false
				healthBarOutline.Visible = false
				healthNumber.Visible = false

				if objects["healthBarSegment1"].object.Visible == true then
					for i = 1, esp.gradentHealthBarSegments do
						objects["healthBarSegment" .. i].object.Visible = false
					end
				end
			end

			-- main text

			-- name text
			local nameTag = objects.nameText.object
			if uiFlags[section .. "_name"].value then
				nameTag.Color = uiFlags[section .. "_namecolor"].color
				nameTag.OutlineColor = Color3.new(math.clamp(nameTag.Color.r - textShading, 0, 1), math.clamp(nameTag.Color.g - textShading, 0, 1), math.clamp(nameTag.Color.b - textShading, 0, 1))
				nameTag.Text = mainTextCase == "lowercase" and player.Name:lower() or mainTextCase == "UPPERCASE" and player.Name:upper() or player.Name
				nameTag.Position = bounds.Min + newVec2(math.floor(bounds.Width / 2), -2 - nameTag.TextBounds.y)
				nameTag.Size = mainTextSize
				nameTag.Font = mainTextFont
				nameTag.Visible = true
			else
				nameTag.Visible = false
			end

			-- weapon text

			local heldWeapon = objects.weaponText.object

			if info.weapon then
				local wepname = info.weapon
				local splitwepname = string.split(wepname:lower(), "")
				splitwepname[1] = splitwepname[1]:upper()
				for i, char in next, splitwepname do
					if ((char == " " or char == "-") and i < #splitwepname) then
						splitwepname[i + 1] = splitwepname[i + 1]:upper()
					end
				end
				local fixedwepname = table.concat(splitwepname)

				this.DrawingObjects.lastData.weapon = mainTextCase == "lowercase" and fixedwepname:lower() or mainTextCase == "UPPERCASE" and fixedwepname:upper() or fixedwepname
			end

			if uiFlags[section .. "_heldweapon"].value then
				heldWeapon.Text = this.DrawingObjects.lastData.weapon
				heldWeapon.Size = mainTextSize
				heldWeapon.Font = mainTextFont
				heldWeapon.Position = bounds.Min + newVec2(math.floor(bounds.Width / 2), bounds.Height + 2)
				heldWeapon.Color = uiFlags[section .. "_heldweaponcolor"].color
				heldWeapon.OutlineColor = Color3.new(math.clamp(heldWeapon.Color.r - textShading, 0, 1), math.clamp(heldWeapon.Color.g - textShading, 0, 1), math.clamp(heldWeapon.Color.b - textShading, 0, 1))
				heldWeapon.Visible = true
			else
				heldWeapon.Visible = false
			end

			-- distance text
			local distanceTag = objects.distanceText.object
			if uiFlags[section .. "_distance"].value then
				local pos = bounds.Min + newVec2(math.floor(bounds.Width / 2), bounds.Height + 2)
				if objects.weaponText.object.Visible then
					pos = objects.weaponText.object.Position + newVec2(0, objects.weaponText.object.TextBounds.y)
				end
				local dist = mathematics.truncateNumber((this.DrawingObjects.lastData.HeadCf.p - camera.CFrame.p).Magnitude, 1)
				if math.floor(dist) == dist then
					dist = tostring(dist) .. ".0"
				end
				distanceTag.Text = dist .. (mainTextCase == "lowercase" and " st" or mainTextCase == "UPPERCASE" and " ST" or " St")
				distanceTag.Position = pos
				distanceTag.Size = mainTextSize
				distanceTag.Font = mainTextFont
				distanceTag.Color = uiFlags[section .. "_distancecolor"].color
				distanceTag.OutlineColor = Color3.new(math.clamp(distanceTag.Color.r - textShading, 0, 1), math.clamp(distanceTag.Color.g - textShading, 0, 1), math.clamp(distanceTag.Color.b - textShading, 0, 1))
				distanceTag.Visible = true
			else
				distanceTag.Visible = false
			end             


			-- flag text

			local flagoffset = 0
			-- rank text
			local rankTag = objects.rankText.object
			if uiFlags[section .. "_rank"].value then
				rankTag.Size = flagTextSize
				rankTag.Font = flagTextFont
				rankTag.Color = uiFlags[section .. "_rankcolor"].color
				rankTag.OutlineColor = Color3.new(math.clamp(rankTag.Color.r - textShading, 0, 1), math.clamp(rankTag.Color.g - textShading, 0, 1), math.clamp(rankTag.Color.b - textShading, 0, 1))
				local text = "Lvl " .. pInfo.rank
				rankTag.Text = flagTextCase == "lowercase" and text:lower() or flagTextCase == "UPPERCASE" and text:upper() or text
				rankTag.Position = bounds.Min + newVec2(math.floor(bounds.Width) + (rankTag.TextBounds.X / 2) + 2, -3 + flagoffset)
				flagoffset = flagoffset + rankTag.TextBounds.Y
				rankTag.Visible = true
			else
				rankTag.Visible = false
			end

			-- exploit text
			local exploitTag = objects.exploitText.object
			if uiFlags[section .. "_exploit"].value and pInfo.exploiting and pInfo.updates and #pInfo.updates > 2 then
				exploitTag.Size = flagTextSize
				exploitTag.Font = flagTextFont
				exploitTag.Color = uiFlags[section .. "_exploitcolor"].color
				exploitTag.OutlineColor = Color3.new(math.clamp(exploitTag.Color.r - textShading, 0, 1), math.clamp(exploitTag.Color.g - textShading, 0, 1), math.clamp(exploitTag.Color.b - textShading, 0, 1))
				local text = "Exploiting (Delta: " .. tostring(mathematics.truncateNumber(pInfo.updates[#pInfo.updates].time - pInfo.updates[#pInfo.updates - 1].time, 2)) .. " Delay: " .. tostring(mathematics.truncateNumber(pInfo.updates[#pInfo.updates].time - pfModules.GameClock.getTime(), 2)) .. " Choke: " .. tostring(mathematics.truncateNumber(pInfo.updates[#pInfo.updates].receivedTime - tick(), 2)) .. ")"
				exploitTag.Text = flagTextCase == "lowercase" and text:lower() or flagTextCase == "UPPERCASE" and text:upper() or text
				exploitTag.Visible = true
				exploitTag.Position = bounds.Min + newVec2(math.floor(bounds.Width) + (exploitTag.TextBounds.X / 2) + 2, -3 + flagoffset)
				flagoffset = flagoffset + exploitTag.TextBounds.Y
			else
				exploitTag.Visible = false
			end

			-- stance text
			local stanceTag = objects.stanceText.object
			if uiFlags[section .. "_stance"].value then
				stanceTag.Size = flagTextSize
				stanceTag.Font = flagTextFont
				stanceTag.Color = uiFlags[section .. "_stancecolor"].color
				stanceTag.OutlineColor = Color3.new(math.clamp(stanceTag.Color.r - textShading, 0, 1), math.clamp(stanceTag.Color.g - textShading, 0, 1), math.clamp(stanceTag.Color.b - textShading, 0, 1))
				local stance = pInfo.stance
				stance = stance ~= "prone" and stance .. "ing" or "proning"
				local text = (string.sub(stance, 1, 1)):upper()..string.sub(stance, 2, -1)
				stanceTag.Text = flagTextCase == "lowercase" and text:lower() or flagTextCase == "UPPERCASE" and text:upper() or text
				stanceTag.Visible = true
				stanceTag.Position = bounds.Min + newVec2(math.floor(bounds.Width) + (stanceTag.TextBounds.X / 2) + 2, -3 + flagoffset)

				flagoffset = flagoffset + stanceTag.TextBounds.Y
			else
				stanceTag.Visible = false
			end

			-- visible text
			local visibleTag = objects.visibleText.object
			if uiFlags[section .. "_visible"].value then
				local vis = 0
				local limbs = #this.DrawingObjects.lastData.limbs
				local dn = (1 / limbs) -- each limb thats visible increases the opacity
				for i, v in next, (this.DrawingObjects.lastData.limbs) do
					local hit, pos = workspace:FindPartOnRayWithWhitelist(Ray.new(camera.CFrame.p, v - camera.CFrame.p), {workspace.Map}, true)
					if pos == v then
						vis = vis + dn
					end
				end
				visibleTag.Size = flagTextSize
				visibleTag.Font = flagTextFont
				visibleTag.Color = uiFlags[section .. "_visiblecolor"].color
				visibleTag.OutlineColor = Color3.new(math.clamp(visibleTag.Color.r - textShading, 0, 1), math.clamp(visibleTag.Color.g - textShading, 0, 1), math.clamp(visibleTag.Color.b - textShading, 0, 1))
				local text = "Visible"
				visibleTag.Text = flagTextCase == "lowercase" and text:lower() or flagTextCase == "UPPERCASE" and text:upper() or text
				visibleTag.Visible = true
				visibleTag.Opacity = vis
				visibleTag.Position = bounds.Min + newVec2(math.floor(bounds.Width) + (visibleTag.TextBounds.X / 2) + 2, -3 + flagoffset)
				flagoffset = flagoffset + visibleTag.TextBounds.Y
			else
				visibleTag.Visible = false
			end

			-- view angle line
			local viewAngleLine = objects.viewAngleLine.object
			if uiFlags[section .. "_viewangle"].value then
				local headScreen = mathematics.worldToViewportPoint(this.DrawingObjects.lastData.HeadCf.p)
				local inFrontOfHeadScreen = mathematics.worldToViewportPoint(this.DrawingObjects.lastData.HeadCf.p + (this.DrawingObjects.lastData.HeadCf.LookVector.unit * 4))

				viewAngleLine.From = newVec2(math.floor(headScreen.x), math.floor(headScreen.y))
				viewAngleLine.To = newVec2(math.floor(inFrontOfHeadScreen.x), math.floor(inFrontOfHeadScreen.y))
				viewAngleLine.Color = uiFlags[section .. "_viewanglecolor"].color
				viewAngleLine.Visible = true
			else
				viewAngleLine.Visible = false
			end

			-- head dot
			local headDot = objects.HeadDot.object
			if uiFlags[section .. "_headdot"].value then
				local compensatedVec = this.DrawingObjects.lastData.HeadCf.p
				local heldWeapon = currentInfo.heldWeapon()

				if heldWeapon and heldWeapon._weaponData and heldWeapon._weaponData.bulletspeed then
					local bulletAcceleration = pfModules.PublicSettings.bulletAcceleration
					local weaponData = heldWeapon._weaponData
					local bulletSpeed = weaponData.bulletspeed
					local camPos = camera.CFrame.p
					local firstTrajectory, firstBulletTime = mathematics.solveTrajectory(camPos, bulletAcceleration, this.DrawingObjects.lastData.HeadCf.p, bulletSpeed)
					compensatedVec = camPos + firstTrajectory
					if this.pInfo.velocity.Magnitude > 0 then
						local secondTrajectory, secondBulletTime = mathematics.solveTrajectory(camPos, bulletAcceleration, this.DrawingObjects.lastData.HeadCf.p + (this.pInfo.velocity * firstBulletTime), bulletSpeed)
						compensatedVec = camPos + secondTrajectory
					end
				end
				local headDotScreen = mathematics.worldToViewportPoint(compensatedVec)
				local centerScreenPos = newVec2(math.floor(headDotScreen.x), math.floor(headDotScreen.y))
				local spreadOutPixel = 3

				headDot.PointA = centerScreenPos + newVec2(0, spreadOutPixel)
				headDot.PointB = centerScreenPos + newVec2(-spreadOutPixel, 0)
				headDot.PointC = centerScreenPos + newVec2(0, -spreadOutPixel)
				headDot.PointD = centerScreenPos + newVec2(spreadOutPixel, 0)

				headDot.Color = uiFlags[section .. "_headdotcolor"].color
				headDot.Visible = true
			else
				headDot.Visible = false
			end

			local customColorOver
			if uiFlags.espsettings_showaimbottarget.value and rage and rage.currentTarget and rage.currentTarget.player == player then
				customColorOver = uiFlags.espsettings_showaimbottargetcolor.color
			elseif uiFlags.espsettings_showaimbottarget.value and legit and legit.currentTarget and legit.currentTarget.player == player then
				customColorOver = uiFlags.espsettings_showaimbottargetcolor.color
			elseif uiFlags.enemy_showresolvedflag.value and this.pInfo.resolving then
				customColorOver = uiFlags.enemy_resolvedflagcolor.color
			elseif uiFlags.espsettings_showfriendlies.value and ui.playerListStatus and ui.playerListStatus[player.UserId] and ui.playerListStatus[player.UserId].friendly == true then
				customColorOver = uiFlags.espsettings_showfriendliescolor.color
			elseif uiFlags.espsettings_showpriorities.value and ui.playerListStatus and ui.playerListStatus[player.UserId] and ui.playerListStatus[player.UserId].priority == true then
				customColorOver = uiFlags.espsettings_showprioritiescolor.color
			end

			if customColorOver then
				local color = customColorOver
				for i, v in next, this.chamsObjects do
					if v.Name == "inner" then
						v.Color3 = Color3.fromRGB(math.clamp((color.R * 255) - 75, 0, 255), math.clamp((color.G * 255) - 75, 0, 255), math.clamp((color.B * 255) - 75, 0, 255))
					else
						v.Color3 = color
					end
				end
				this.updateNextChams = true
				for i, v in next, this.DrawingObjects.draw.drawOnScreen do
					if v.object == objects.outlineBox.object or v.object == objects.healthBarOutline.object or v.object == objects.healthBarBack.object then
					elseif v.object == objects.nameText.object or v.object == objects.distanceText.object or v.object == objects.weaponText.object or v.object == objects.rankText.object or v.object == objects.exploitText.object or v.object == objects.stanceText.object or v.object == objects.visibleText.object then
						v.object.Color = color
						v.object.OutlineColor = Color3.new(math.clamp(v.object.Color.r - textShading, 0, 1), math.clamp(v.object.Color.g - textShading, 0, 1), math.clamp(v.object.Color.b - textShading, 0, 1))
					else
						v.object.Color = color
					end
				end
			else
				if this.updateNextChams then
					this.updateNextChams = nil
					this.updateChams()
				end
			end

			--make visible
			this.DrawingObjects.stoppedRenderingOnScreen = false

			if not this.DrawingObjects.stoppedRenderingOffScreen then
				this.DrawingObjects.stoppedRenderingOffScreen = true
				for i,v in next, this.DrawingObjects.draw.drawOffScreen do
					v.object.Visible = false
				end
			end
		end
		local outlineSize = 4
		this.renderOffScreen = function(info)
			local pos = CFrame.lookAt(camera.CFrame.p, camera.CFrame.p + camera.CFrame.LookVector * newVec3(1, 0, 1)):PointToObjectSpace(info.position)

			--arrow
			local oofArrow = this.DrawingObjects.draw.drawOffScreen.oofArrow.object
			local oofArrowOutline = this.DrawingObjects.draw.drawOffScreen.oofArrowOutline.object
			if ui.flags.enemy_oov.value and this.pInfo.enemy then
				local cf = camera.CFrame
				local v = info.position - cf.p
				local r = cf.RightVector
				local u = cf.UpVector
				local b = -cf.LookVector
				local angle = math.atan2(v:Dot(r:Cross(u)), v:Dot(u:Cross(b)))

				local cx, sy = math.cos(angle), math.sin(angle)
				local cx1, sy1 = math.cos(angle + pi/2), math.sin(angle + pi/2)
				local cx2, sy2 = math.cos(angle + pi/2*3), math.sin(angle + pi/2*3)

				local viewport = camera.ViewportSize
				local bigger = math.max(viewport.x, viewport.y)
				local smaller = math.min(viewport.x, viewport.y)
				local arrowSize = math.clamp(ui.flags.enemy_dynamicarrowsize.value and mathematics.map((info.position - camera.CFrame.p).Magnitude, 1, 100, 30, 10) or (ui.flags.arrow_size.value / 2) + 5, 5, 55)
				local arrowPercentage = ui.flags.arrow_distance.value

				local arrowOrigin = viewport/2 + (newVec2(cx, sy) * newVec2(bigger * arrowPercentage/200, smaller * arrowPercentage/200))

				oofArrow.PointA = arrowOrigin + newVec2(arrowSize*2 * cx, arrowSize*2 * sy)
				oofArrow.PointB = arrowOrigin + newVec2(arrowSize * cx1, arrowSize * sy1)
				oofArrow.PointC = arrowOrigin + newVec2(arrowSize * cx2, arrowSize * sy2)

				local customColorOver
				if ui.flags.espsettings_showaimbottarget.value and rage and rage.currentTarget and rage.currentTarget.player == player then
					customColorOver = ui.flags.espsettings_showaimbottargetcolor.color
				elseif ui.flags.espsettings_showaimbottarget.value and legit and legit.currentTarget and legit.currentTarget.player == player then
					customColorOver = ui.flags.espsettings_showaimbottargetcolor.color
				elseif ui.flags.enemy_showresolvedflag.value and this.pInfo.resolving then
					customColorOver = ui.flags.enemy_resolvedflagcolor.color
				elseif ui.flags.espsettings_showfriendlies.value and ui.playerListStatus and ui.playerListStatus[player.UserId] and ui.playerListStatus[player.UserId].friendly == true then
					customColorOver = ui.flags.espsettings_showfriendliescolor.color
				elseif ui.flags.espsettings_showpriorities.value and ui.playerListStatus and ui.playerListStatus[player.UserId] and ui.playerListStatus[player.UserId].priority == true then
					customColorOver = ui.flags.espsettings_showprioritiescolor.color
				end

				oofArrow.Color = customColorOver or ui.flags.enemy_oovcolor.color

				do
					oofArrowOutline.PointA = arrowOrigin + newVec2(arrowSize*2 * cx, arrowSize*2 * sy)
					oofArrowOutline.PointB = arrowOrigin + newVec2(arrowSize * cx1, arrowSize * sy1)
					oofArrowOutline.PointC = arrowOrigin + newVec2(arrowSize * cx2, arrowSize * sy2)
				end

				oofArrowOutline.Color = Color3.fromRGB(oofArrow.Color.R*255*0.5, oofArrow.Color.G*255*0.5, oofArrow.Color.B*255*0.5)

				local trans = ((math.cos(tick() * 2 * pi) * (0.75 - (0.25 * (math.cos(tick() * 2 * pi))))) / 2) + 0.75
				this.DrawingObjects.draw.drawOffScreen.oofArrow.originalTransparency = trans
				this.DrawingObjects.draw.drawOffScreen.oofArrowOutline.originalTransparency = trans

				oofArrow.Opacity = trans
				oofArrowOutline.Opacity = trans

				oofArrow.Visible = true
				oofArrowOutline.Visible = false
			else
				oofArrowOutline.Visible = false
				oofArrow.Visible = false
			end


			this.DrawingObjects.stoppedRenderingOffScreen = false

			if not this.DrawingObjects.stoppedRenderingOnScreen then
				this.DrawingObjects.stoppedRenderingOnScreen = true
				for i,v in next, this.DrawingObjects.draw.drawOnScreen do
					v.object.Visible = false
				end
			end
		end

		this.renderGeneral = function(info)
			local snapLine = this.DrawingObjects.draw.drawGeneral.snapLine.object
			local pos, onScreen = mathematics.worldToViewportPoint(info.position)
			local viewportSize = camera.ViewportSize

			if not onScreen then
				local angle
				local centerX, centerY = viewportSize.x/2, viewportSize.y/2
				if pos.z > 0 then
					angle = math.atan2(pos.y - centerY, pos.x - centerX)
				else
					angle = math.atan2(centerY - pos.y, centerX - pos.x)
				end

				local x = math.cos(angle)
				local y = math.sin(angle)
				local slope = y/x
				local xEdge, yEdge = viewportSize.x, viewportSize.y
				if y < 0 then
					yEdge = 0
				end

				if x < 0 then
					xEdge = 0
				end

				local newY = slope*xEdge + centerY - slope*centerX
				if newY > 0 and newY < viewportSize.y then
					pos = newVec2(xEdge, newY)
				else
					pos = newVec2((yEdge - centerY + slope*centerX)/slope, yEdge)
				end
			end

			local section = (this.pInfo.enemy and "enemy" or "team")
			if section == "enemy" and ui.flags[section .. "_snaplines"].value then
				local trans = (1 - ui.flags[section .. "_snaplinescolor"].transparency) * (onScreen and 1 or 0.5)
				snapLine.From = newVec2(math.floor(viewportSize.x / 2), math.floor(viewportSize.y - 50))
				snapLine.To = newVec2(pos.x, pos.y)
				snapLine.Opacity = trans
				snapLine.Color = ui.flags[section .. "_snaplinescolor"].color
				snapLine.Visible = true
			else
				snapLine.Visible = false
			end
		end

		this.onSpawned = function()
			if this.step then
				this.step:Disconnect()
				this.step = nil
			end
			this.transparencyEvent:Fire(0)
			this.fadefinished = false
			this.timePassed = 1

			this.step = runService.Stepped:Connect(function(upTime, deltaTime)
				if not this or not this.pInfo then
					this.step:Disconnect()
					this.step = nil
					return
				end
				local char = this.pInfo.character
				if char and this.pInfo.alive and this.pInfo.updates and #this.pInfo.updates > 0 then
					if not this.fadefinished then
						if this.timePassed > 0 then
							this.timePassed = math.clamp(this.timePassed - (deltaTime * 4), 0, 1)
							this.transparencyEvent:Fire(mathematics.map(this.timePassed, 0, 1, 0, 1))
						else
							this.timePassed = 0
							this.fadefinished = true
							this.transparencyEvent:Fire(mathematics.map(this.timePassed, 0, 1, 0, 1))
						end
					end
					
					if (char.Head.CFrame.p - char.Torso.CFrame.p).Magnitude > 4 or (char.Head.CFrame.p - char["Left Leg"].CFrame.p).Magnitude > 6 or (char.Head.CFrame.p - char["Right Leg"].CFrame.p).Magnitude > 6 or #this.pInfo.updates <= 2 then
						char = {
							Head = {
								CFrame = CFrame.new(this.pInfo.updates[#this.pInfo.updates].position + newVec3(0, 1.4, 0)),
								Position = this.pInfo.updates[#this.pInfo.updates].position + newVec3(0, 1.4, 0)
							},
							Torso = {
								CFrame = CFrame.new(this.pInfo.updates[#this.pInfo.updates].position),
								Position = this.pInfo.updates[#this.pInfo.updates].position
							},
							["Left Arm"] = {
								CFrame = CFrame.new(this.pInfo.updates[#this.pInfo.updates].position),
								Position = this.pInfo.updates[#this.pInfo.updates].position
							},
							["Right Arm"] = {
								CFrame = CFrame.new(this.pInfo.updates[#this.pInfo.updates].position),
								Position = this.pInfo.updates[#this.pInfo.updates].position
							},
							["Left Leg"] = {
								CFrame = CFrame.new(this.pInfo.updates[#this.pInfo.updates].position - newVec3(0, 1.6, 0)),
								Position = this.pInfo.updates[#this.pInfo.updates].position - newVec3(0, 1.6, 0)
							},
							["Right Leg"] = {
								CFrame = CFrame.new(this.pInfo.updates[#this.pInfo.updates].position - newVec3(0, 1.6, 0)),
								Position = this.pInfo.updates[#this.pInfo.updates].position - newVec3(0, 1.6, 0)
							}
						}
					end

					local headcf = char.Head.CFrame
					local torsocf = char.Torso.CFrame

					local llegcf = char["Left Leg"].CFrame
					local rlegcf = char["Right Leg"].CFrame

					local section = this.pInfo.enemy and "enemy" or "team"
					local health, maxHealth = math.clamp(this.pInfo.health, 0, 100), 100

					this.DrawingObjects.lastData.health = health
					this.DrawingObjects.lastData.maxHealth = maxHealth

					if ui.flags[section .. "_esp"].value then
						local onScreen = mathematics.spherePoint(torsocf.p, math.clamp((camera.CFrame.p - torsocf.p).Magnitude - 1e5, 0, 4))
						if onScreen then
							this.renderOnScreen({
								boundingRect = esp.getBoundingBox(headcf, torsocf, llegcf, rlegcf, this.DrawingObjects.lastData), 
								character = char,
								weapon = this.pInfo.weapon,
								health = health,
								maxHealth = maxHealth,
								rank = this.pInfo.rank,
							})
						else
							this.renderOffScreen({
								position = headcf.p
							})
						end
						this.renderGeneral({
							position = headcf.p
						})
					else
						if not this.DrawingObjects.stoppedRenderingOnScreen then
							this.DrawingObjects.stoppedRenderingOnScreen = true
							for i,v in next, this.DrawingObjects.draw.drawOnScreen do
								v.object.Visible = false
							end
						end
						if not this.DrawingObjects.stoppedRenderingOffScreen then
							this.DrawingObjects.stoppedRenderingOffScreen = true
							for i,v in next, this.DrawingObjects.draw.drawOffScreen do
								v.object.Visible = false
							end
						end
						for i,v in next, this.DrawingObjects.draw.drawGeneral do
							v.object.Visible = false
						end
					end
				end
			end)
		end

		this.onDied = function()
			if this.step then
				this.step:Disconnect()
				this.step = nil
			end

			this.timePassed = 0
			this.fadefinished = false

			this.step = runService.Stepped:Connect(function(upTime, deltaTime)
				local section = this.pInfo and this.pInfo.enemy and "enemy" or "team"
				if not ui.flags[section .. "_esp"].value or this.timePassed >= 1 then
					if this.step then
						this.step:Disconnect()
						this.step = nil
					end
					if not this or not this.DrawingObjects then
						return
					end

					this.transparencyEvent:Fire(0)
					this.fadefinished = true
					this.DrawingObjects.lastData = {limbs = {}}

					if this.DrawingObjects.draw and this.DrawingObjects.draw.drawOnScreen then
						for i,v in next, this.DrawingObjects.draw.drawOnScreen do
							v.object.Visible = false
						end
					end
					if this.DrawingObjects.draw and this.DrawingObjects.draw.drawOffScreen then
						for i,v in next, this.DrawingObjects.draw.drawOffScreen do
							v.object.Visible = false
						end
					end
					if this.DrawingObjects.draw and this.DrawingObjects.draw.drawGeneral then
						for i,v in next, this.DrawingObjects.draw.drawGeneral do
							v.object.Visible = false
						end
					end
					this.DrawingObjects.stoppedRenderingOffScreen = true
					this.DrawingObjects.stoppedRenderingOnScreen = true

					for i = #this.chamsTransConnections, 1, -1 do
						local con = table.remove(this.chamsTransConnections, i)
						if con then
							con:Disconnect()
							con = nil
						end
					end

					for i = #this.chamsObjects, 1, -1 do
						local object = table.remove(this.chamsObjects, i)
						if object then
							object:Destroy()
							object = nil
						end
					end
				else
					this.timePassed = this.timePassed + (deltaTime * 4)
					if not this or not this.transparencyEvent then
						if this and this.step then
							this.step:Disconnect()
							this.step = nil
						end
						return
					end
					this.transparencyEvent:Fire(mathematics.map(this.timePassed, 0, 1, 0, 1))
					if this.DrawingObjects.lastData.HeadCf then
						local onScreen = mathematics.spherePoint(this.DrawingObjects.lastData.rootCf.p, math.clamp((camera.CFrame.p - this.DrawingObjects.lastData.rootCf.p).Magnitude - 1e5, 0, 4))
						if onScreen then
							this.renderOnScreen({
								boundingRect = esp.getBoundingBox(nil, nil, nil, nil, this.DrawingObjects.lastData),
								health = 0,
								maxHealth = this.DrawingObjects.lastData.maxHealth,
								rank = this.pInfo.rank,
							})
						else
							this.renderOffScreen({
								position = this.DrawingObjects.lastData.HeadCf.p
							})
						end
						this.renderGeneral({
							position = this.DrawingObjects.lastData.HeadCf.p
						})
					else
						if not this.DrawingObjects.stoppedRenderingOnScreen then
							this.DrawingObjects.stoppedRenderingOnScreen = true
							for i,v in next, this.DrawingObjects.draw.drawOnScreen do
								v.object.Visible = false
							end
						end
						if not this.DrawingObjects.stoppedRenderingOffScreen then
							this.DrawingObjects.stoppedRenderingOffScreen = true
							for i,v in next, this.DrawingObjects.draw.drawOffScreen do
								v.object.Visible = false
							end
						end
						for i,v in next, this.DrawingObjects.draw.drawGeneral do
							v.object.Visible = false
						end
					end
				end
			end)
		end

		this.pInfo.spawned:Connect(function()
			this.onSpawned()
			this.addChams(this.pInfo.character)
		end)
		this.pInfo.died:Connect(function()
			this.onDied()
			this.removeChams()
		end)

		if this.pInfo.alive and this.pInfo then
			this.onSpawned()
			this.addChams(this.pInfo.character)
		end
		esp.espData[player] = this
	end

	esp.remove = function(player)
		local this = esp.espData[player]
		if not this then return end
		this.removeChams()
		this.pInfo = table.clone(this.pInfo)
		if this.pInfo and this.pInfo.alive then
			this.onDied()
			repeat task.wait() until this.fadefinished == true
		end
		for i,v in next, this.DrawingObjects.draw.drawOnScreen do
			v.object:Remove()
			v.object = nil
			table.clear(v)
		end
		for i,v in next, this.DrawingObjects.draw.drawOffScreen do
			v.object:Remove()
			v.object = nil
			table.clear(v)
		end
		for i,v in next, this.DrawingObjects.draw.drawGeneral do
			v.object:Remove()
			v.object = nil
			table.clear(v)
		end
		for i = #this.chamsTransConnections, 1, -1 do
			local con = table.remove(this.chamsTransConnections, i)
			if con then
				con:Disconnect()
				con = nil
			end
		end
		for i = #this.transConnections, 1, -1 do
			local con = table.remove(this.transConnections, i)
			if con then
				con:Disconnect()
				con = nil
			end
		end
		this.transparencyEvent:Destroy()
		this.healthPercentageSpring = nil
		table.clear(this)
		this = nil          
	end

	for i, v in next, players:GetPlayers() do
		if v ~= localPlayer then
			task.spawn(esp.apply, v)
		end
	end

	players.PlayerAdded:Connect(esp.apply)
	players.PlayerRemoving:Connect(esp.remove)
	-- garbage

	-- dropped esp
	do

		local function createTextLabel()
			local textLabel = Drawing.new("Text")
			Drawings[#Drawings + 1] = textLabel
			textLabel.Visible = false
			textLabel.Font = Drawing.Fonts.Plex
			textLabel.Size = 13
			textLabel.Centered = true
			textLabel.Outlined = true
			return textLabel
		end

		local function createWeaponTexts(num)
			local result = {}
			for _ = 1, num do
				result[#result + 1] = {namelabel = createTextLabel(), ammolabel = createTextLabel()}
			end
			return result
		end

		esp.dropped = {
			texts = createWeaponTexts(60),
			droppedLocation = workspace.Ignore.GunDrop,
			loop = runService.Stepped:Connect(function()
				local texts = esp.dropped.texts
				local weapons = {}
				for i, v in next, esp.dropped.droppedLocation:GetChildren() do
					if v:FindFirstChild("Gun") and v:FindFirstChild("Slot1") then
						weapons[i] = {
							name = v.Gun.Value,
							ammo = 0,
							position = v.Slot1.Position
						}
					end
				end

				for i, text in next, texts do
					local name, ammo = text.namelabel, text.ammolabel
					local weapon = weapons[i]
					if weapon and ui.flags.dropped_weaponnames.value then
						local distance = (camera.CFrame.p - weapon.position).Magnitude
						local opacity = math.clamp(1 - (1 / 80 * (distance - 80)), 0, 1)
						if opacity > 0 then
							local screenpos = mathematics.worldToViewportPoint(weapon.position, true, 50)
							name.Text = "[ " .. weapon.name .. " ]"
							name.Color = ui.flags.dropped_weaponnamecolor.color
							name.Position = newVec2(screenpos.x, screenpos.y)
							name.Opacity = opacity
						end
						name.Visible = opacity > 0
					else
						name.Visible = false
						ammo.Visible = false
					end
				end
			end)
		}
	end
end

-- visuals
do
	-- local chams
	visuals.materials = {
		ghost = Enum.Material.ForceField,
		flat = Enum.Material.Neon,
		foil = Enum.Material.Foil,
		custom = Enum.Material.SmoothPlastic,
		reflective = Enum.Material.Glass
	}
	visuals.textures = forcefieldanimations
	visuals.basepartProperties = {"Color", "Material", "Reflectance"}
	visuals.viewmodelStorage = {}
	visuals.playerModelStorage = {}

	visuals.saveViewmodel = function()
		for _, v in next, (camera:GetDescendants()) do
			local isBasePart = v:IsA("BasePart")
			local isMesh = isBasePart and v:IsA("MeshPart")
			local isSpecialMesh = isBasePart and v:IsA("SpecialMesh")
			local isUnionOperator = v:IsA("UnionOperation")
			local isTexture = v:IsA("Texture")

			if not (isBasePart or isMesh or isSpecialMesh or isUnionOperator or isTexture) then
				continue
			end

			local properties = {}

			if not (isSpecialMesh or isTexture) then
				properties.Color = v.Color
				properties.Material = v.Material
				properties.Reflectance = v.Reflectance
			end

			if isMesh then
				properties.TextureID = v.TextureID
			end
			if isSpecialMesh then
				properties.TextureId = v.TextureId
			else
				properties.Transparency = v.Transparency
			end
			if isUnionOperator then
				properties.UsePartColor = v.UsePartColor
			end
			if isTexture then
				properties.Texture = v.Texture
				properties.Transparency = v.Transparency
			end

			visuals.viewmodelStorage[v] = properties
		end
	end

	visuals.reverseViewmodel = function()
		for obj, properties in pairs(visuals.viewmodelStorage) do
			for key, value in pairs(properties) do
				obj[key] = value
			end
			visuals.viewmodelStorage[obj] = nil
		end
	end

	visuals.updateViewmodelchams = function()
		for _, model in next, (camera:GetChildren()) do
			if model:IsA("AudioListener") then
                continue
            end
            
            local isArm = (model:FindFirstChild("Sleeves") and true or false)
			local doSkip = visuals.thirdPerson.inThirdPerson or (isArm and ui.flags.visuals_armchams.value) or (not isArm and ui.flags.visuals_weaponchams.value)

			if not doSkip then
				continue
			end

			local setMaterial = isArm and ui.flags.visuals_armmaterial.value or ui.flags.visuals_weaponmaterial.value
			local setReflectance = isArm and ui.flags.visuals_armreflectance.value or ui.flags.visuals_weaponreflectance.value

			for matKey, matValue in pairs(setMaterial) do
				setMaterial = matValue and visuals.materials[matKey] or setMaterial
			end

			local fakeTexture = setMaterial == Enum.Material.ForceField and "rbxassetid://0" or ""
			local setTexture = isArm and setMaterial == Enum.Material.ForceField and ui.flags.visuals_armanimationtype.value.off ~= true and ui.flags.visuals_armanimationtype.value or not isArm and setMaterial == Enum.Material.ForceField and ui.flags.visuals_weaponanimationtype.value.off ~= true and ui.flags.visuals_weaponanimationtype.value    
			if setTexture then
				for g, c in next, setTexture do
					if c then
						setTexture = visuals.textures[g]
					end
				end
			else
				setTexture = ""
			end      

			for _, part in next, (model:GetChildren()) do
				local isMesh = part:IsA("MeshPart")
				local isSpecialMesh = part:IsA("SpecialMesh")
				local isBasePart = part:IsA("BasePart")
				local isTexture = part:IsA("Texture")
				local isUnionOperator = part:IsA("UnionOperation")

				if part.Transparency == 1 then
					continue
				end

				local setColor = isArm and (part.Name ~= "Sleeves" and ui.flags.visuals_armcolor.color or ui.flags.visuals_sleevecolor.color) or ui.flags.visuals_weaponcolor.color
				local setAlpha = 1 - (visuals.thirdPerson.inThirdPerson and 0 or (isArm and (isMesh and ui.flags.visuals_armcolor.transparency or ui.flags.visuals_sleevecolor.transparency) or ui.flags.visuals_weaponcolor.transparency))

				if isUnionOperator then
					part.UsePartColor = true
				end

				if not (isSpecialMesh or isTexture) then
					part.Color = setColor
					part.Transparency = setAlpha
					part.Material = setMaterial
					part.Reflectance = setReflectance
				end
				if isMesh then
					part.TextureID = setTexture
				elseif isSpecialMesh then
					part.TextureId = setTexture 
					part.VertexColor = newVec3(setColor.r, setColor.g, setColor.b)
				end
				if isTexture then
					part.Texture = fakeTexture
					part.Transparency = setAlpha
				end

				for _, child in next, (part:GetChildren()) do
					local isChildMesh = child:IsA("MeshPart")
					local isChildSpecialMesh = child:IsA("SpecialMesh")
					local isChildBasePart = child:IsA("BasePart")
					local isChildTexture = child:IsA("Texture")

					if isChildTexture then
						child.Texture = fakeTexture
					elseif isChildMesh then
						child.TextureID = setTexture
					elseif isChildSpecialMesh then
						child.TextureId = setTexture
						child.VertexColor = newVec3(setColor.r, setColor.g, setColor.b)
					elseif isChildBasePart then
						child.Color = setColor
						child.Transparency = setAlpha
						child.Material = setMaterial
						child.Reflectance = setReflectance
					end
				end
			end
		end
	end
	visuals.savePlayerchams = function()
		local model = visuals.thirdPerson and visuals.thirdPerson.replicationObject and visuals.thirdPerson.replicationObject._thirdPersonObject and visuals.thirdPerson.replicationObject._thirdPersonObject._characterModel
		if not model then
			return
		end

		for _, v in next, (model:GetDescendants()) do
			local isBasePart = v:IsA("BasePart")
			local isMesh = v:IsA("MeshPart")
			local isSpecialMesh = v:IsA("SpecialMesh")
			local isTexture = v:IsA("Texture")

			if not (isBasePart or isMesh or isSpecialMesh or isTexture) then
				continue
			end

			local properties = {}

			if not (isSpecialMesh or isTexture) then
				for _, prop in next, (visuals.basepartProperties) do
					properties[prop] = v[prop]
				end
				properties.Transparency = v.Transparency
			end

			if isMesh then
				properties.TextureID = v.TextureID
				properties.Transparency = v.Transparency
			end
			if isSpecialMesh then
				properties.TextureId = v.TextureId
				properties.VertexColor = v.VertexColor
			end
			if isTexture then
				properties.Texture = v.Texture
				properties.Transparency = v.Transparency
			end

			visuals.playerModelStorage[v] = properties
		end
	end

	visuals.reversePlayerchams = function()
		local model = visuals.thirdPerson and visuals.thirdPerson.replicationObject and visuals.thirdPerson.replicationObject._thirdPersonObject and visuals.thirdPerson.replicationObject._thirdPersonObject._characterModel
		if not model then
			return
		end

		for _, v in next, (model:GetDescendants()) do
			local oldProperties = visuals.playerModelStorage[v]
			if oldProperties then
				for prop, val in pairs(oldProperties) do
					v[prop] = val
				end
				visuals.playerModelStorage[v] = nil
			end
		end
	end

	visuals.updatePlayerchams = function()
		local physicalModel = visuals.thirdPerson and visuals.thirdPerson.replicationObject and visuals.thirdPerson.replicationObject._thirdPersonObject and visuals.thirdPerson.replicationObject._thirdPersonObject._characterModel
		local model = visuals.thirdPerson and visuals.thirdPerson.replicationObject and visuals.thirdPerson.replicationObject._thirdPersonObject and visuals.thirdPerson.replicationObject._thirdPersonObject._characterModelHash
		local heldWeapon = currentInfo.heldWeapon()

		if not model or (not ui.flags.visuals_localchams.value and not (heldWeapon and heldWeapon._aiming)) then
			return
		end

		local isScopeBlend = heldWeapon and heldWeapon._aiming or false

		if not (isScopeBlend or ui.flags.visuals_localchams.value) then
			return
		end

		for _, v in next, (physicalModel:GetChildren()) do
			if string.lower(v.Name):find("external") then
				continue
			end

			local isMesh = v:IsA("MeshPart")
			local isSpecialMesh = v:IsA("SpecialMesh")
			local isBasePart = v:IsA("BasePart")

			local setColor = ui.flags.visuals_localcolor.color
			local setAlpha = ui.flags.visuals_localchams.value and (1 - (ui.flags.visuals_localcolor.transparency * (isScopeBlend and 0.44 or 1))) or 0.64
			local setMaterial = ui.flags.visuals_localmaterial.value
			for g, c in next, setMaterial do
				if c then
					setMaterial = visuals.materials[g]
				end
			end
			local setReflectance = 0

			local fakeTexture = setMaterial == Enum.Material.ForceField and "rbxassetid://0" or ""
			local setTexture = setMaterial == Enum.Material.ForceField and ui.flags.visuals_localanimationtype.value
			if setTexture then
				for g, c in next, setTexture do
					if c then
						setTexture = visuals.textures[g]
					end
				end
			else
				setTexture = ""
			end

			if model and not (v == model.Head or v == model.Torso or v == model["Left Arm"] or v == model["Right Arm"] or v == model["Right Leg"] or v == model["Left Leg"]) then
				for _, v2 in next, (v:GetChildren()) do
					local isChildMesh = v2:IsA("MeshPart")
					local isChildSpecialMesh = v2:IsA("SpecialMesh")
					local isChildBasePart = v2:IsA("BasePart")

					if isChildMesh or isChildBasePart then
						if ui.flags.visuals_localchams.value then
							v2.Color = setColor
							v2.Transparency = setAlpha
							v2.Material = setMaterial
						else
							v2.Transparency = setAlpha
						end
					end
				end
				continue
			end

			if ui.flags.visuals_localchams.value then
				if isMesh then
					v.TextureID = setTexture
				elseif isSpecialMesh then
					v.TextureId = setTexture
					v.VertexColor = newVec3(setColor.r, setColor.g, setColor.b)
				elseif isBasePart then
					v.Color = setColor
					v.Transparency = setAlpha
					v.Material = setMaterial
					v.Reflectance = setReflectance
				end
			else
				if isBasePart then
					v.Transparency = setAlpha
				end
			end

			for _, child in next, (v:GetChildren()) do
				local isChildMesh = child:IsA("MeshPart")
				local isChildSpecialMesh = child:IsA("SpecialMesh")
				local isChildBasePart = child:IsA("BasePart")
				local isChildTexture = child:IsA("Texture")

				if ui.flags.visuals_localchams.value then
					if isChildTexture then
						child.Texture = fakeTexture
					elseif isChildMesh then
						child.TextureID = setTexture
					elseif isChildSpecialMesh then
						child.TextureId = setTexture
						child.VertexColor = newVec3(setColor.r, setColor.g, setColor.b)
					elseif isChildBasePart then
						child.Color = setColor
						child.Transparency = setAlpha
						child.Material = setMaterial
						child.Reflectance = setReflectance
					end
				else
					if isChildBasePart then
						child.Transparency = setAlpha
					elseif isChildTexture then
						child.Transparency = setAlpha
					end
				end
			end
		end
	end
	camera.ChildAdded:Connect(function(child)
		visuals.reverseViewmodel()
		visuals.saveViewmodel()
		visuals.updateViewmodelchams()
	end)
	local armWeaponChamsToListen = {
		"visuals_weaponchams",
		"visuals_armchams",
		"visuals_armmaterial",
		"visuals_weaponmaterial",
		"visuals_armreflectance",
		"visuals_weaponreflectance",
		"visuals_armanimationtype",
		"visuals_weaponanimationtype"
	}
	local armWeaponChamsToListenThrottled = {
		"visuals_armcolor",
		"visuals_sleevecolor",
		"visuals_weaponcolor",
	}
	visuals.alreadyUpdated = tick()
	for i, v in next, armWeaponChamsToListenThrottled do
		ui.flags[v].changed:Connect(function()
			if tick() - visuals.alreadyUpdated < 1/60 or visuals.thirdPerson.inThirdPerson then
				return
			end

			local heldWeapon = currentInfo.heldWeapon()
			if heldWeapon and heldWeapon._isHidden == true then
				return
			end

			visuals.reverseViewmodel()
			visuals.saveViewmodel()
			visuals.updateViewmodelchams()
			visuals.alreadyUpdated = tick()
		end)
	end
	for i, v in next, armWeaponChamsToListen do
		ui.flags[v].changed:Connect(function()

			local heldWeapon = currentInfo.heldWeapon()
			if heldWeapon and heldWeapon._isHidden == true or visuals.thirdPerson.inThirdPerson then
				return
			end

			visuals.reverseViewmodel()
			visuals.saveViewmodel()
			visuals.updateViewmodelchams()
		end)
	end
	local localChamsToListen = {
		"visuals_localchams",
		"visuals_localcolor",
		"visuals_localmaterial",
		"visuals_localanimationtype"
	}
	for i, v in next, localChamsToListen do
		ui.flags[v].changed:Connect(function()
			visuals.reversePlayerchams()
			visuals.savePlayerchams()
			visuals.updatePlayerchams()
		end)
	end

	visuals.scopeBlendSetAimHook = hooks.trampoline(pfModules.FirearmObject, "setAim", function(self, ...)
		visuals.scopeBlendSetAimHook.old(self, ...)

		visuals.reversePlayerchams()
		visuals.savePlayerchams()
		visuals.updatePlayerchams()
	end)

	visuals.showModelHook = hooks.trampoline(pfModules.FirearmObject, "showModel", function(self, ...)
		visuals.showModelHook.old(self, ...)

		visuals.reverseViewmodel()
		visuals.saveViewmodel()
		visuals.updateViewmodelchams()
	end)

	-- offset viewmodel n stuffs
	-- all half-pasted from bbot
	do
		local lastAimAssistProcess = tick()
		local function processViewModelOffset(hook, self, ...)
			local charObject = pfModules.CharacterInterface.getCharacterObject()
			local activeCamera = pfModules.CameraInterface.getActiveCamera("MainCamera")
			local shakeCFrame = activeCamera:getShakeCFrame()

			if rage.currentTarget.results and ui.flags.rage_rotateviewmodel.value then
				local oldpos = activeCamera._shakeCFrame
				activeCamera._shakeCFrame = CFrame.lookAt(oldpos.p, rage.currentTarget.results.shotAt)
			end

			if ui.flags.visuals_offsetviewmodel.value then
				local a = hook == visuals.viewmodelOffsetFireArmHook and 1 - self._aimArmSpring.p or 1
				local offset = CFrame.Angles(
					math.rad(ui.flags.visuals_offsetviewmodelp.value - 180) * a,
					math.rad(ui.flags.visuals_offsetviewmodelya.value - 180) * a,
					math.rad(ui.flags.visuals_offsetviewmodelr.value - 180) * a
				)
				offset *= CFrame.new(
					math.rad(ui.flags.visuals_offsetviewmodelx.value - 180) * a,
					math.rad(ui.flags.visuals_offsetviewmodely.value - 180) * a,
					math.rad(ui.flags.visuals_offsetviewmodelz.value - 180) * a
				)
				activeCamera._shakeCFrame = activeCamera._shakeCFrame * offset
			end

			local oldCharSpeed
			local oldCharDistance
			local oldCharVelocity
			if ui.flags.misc_gunmods.value and ui.flags.misc_nobob.value then
				oldCharDistance, oldCharSpeed, oldCharVelocity = charObject:getWalkValues()

				charObject._distance = 0
				charObject._speed = 0
				charObject._velocity = emptyVec3
			end

			hook.old(self, ...)

			if visuals and hook == visuals.viewmodelOffsetFireArmHook and legit and legit.processAimAssist and legit.processTriggerBot then
				legit.processAimAssist(tick() - lastAimAssistProcess)
				lastAimAssistProcess = tick()
			end

			if oldCharDistance and oldCharSpeed and oldCharVelocity then
				charObject._distance = oldCharDistance
				charObject._speed = oldCharSpeed
				charObject._velocity = oldCharVelocity
			end

			activeCamera._shakeCFrame = shakeCFrame
		end

		visuals.viewmodelOffsetFireArmHook = hooks.trampoline(pfModules.FirearmObject, "step", function(self, ...)
			processViewModelOffset(visuals.viewmodelOffsetFireArmHook, self, ...)
		end)

		visuals.viewmodelOffsetMeleeHook = hooks.trampoline(pfModules.MeleeObject, "step", function(self, ...)
			processViewModelOffset(visuals.viewmodelOffsetMeleeHook, self, ...)
		end)

		visuals.viewmodelOffsetGrenadeHook = hooks.trampoline(pfModules.GrenadeObject, "step", function(self, ...)
			processViewModelOffset(visuals.viewmodelOffsetGrenadeHook, self, ...)
		end)
	end

	-- remove camera bobbing, supression and recoil
	visuals.mainCameraObjectStepHook = hooks.trampoline(pfModules.MainCameraObject, "step", function(self, ...)
		self._suppressionSpring.p = ui.flags.visuals_visualssuppresion.value and emptyVec3 or self._suppressionSpring.p

		local charObject = pfModules.CharacterInterface.getCharacterObject()
		local charSpeed
		if charObject then
			charSpeed = charObject._speed
			charObject._speed = ui.flags.visuals_camerabob.value and 0 or charSpeed
			-- idk why more ppl dont do this, its so simple and intuitive
		end

		visuals.mainCameraObjectStepHook.old(self, ...)

		if charObject and charSpeed then
			charObject._speed = charSpeed
		end
	end)

	visuals.mainCameraObjectapplyImpulseHook = hooks.trampoline(pfModules.MainCameraObject, "applyImpulse", function(self, ...)
		local args = {...}

		if ui.flags.visuals_camerarecoil.value then
			args[1] = args[1] * (1 - (ui.flags.visuals_camerarecoilscale.value / 100))
		end

		return visuals.mainCameraObjectapplyImpulseHook.old(self, unpack(args))
	end)

	-- the fuck is wrong with this bruh
	-- override fov
	visuals.weaponControllerObjectHook = hooks.trampoline(pfModules.WeaponControllerObject, "step", function(self, ...)
		local charObject = pfModules.CharacterInterface.getCharacterObject()
		local charFov
		if charObject then
			charFov = charObject.unaimedfov
			charObject.unaimedfov = ui.flags.visuals_fov.value
		end

		visuals.weaponControllerObjectHook.old(self, ...)

		if charObject and charFov then
			charObject.unaimedfov = charFov
		end
	end)

	-- remove ads fov
	visuals.mainCameraObjectSetMagHook = hooks.trampoline(pfModules.MainCameraObject, "setMagnification", function(self, ...)
		local args = {...}

		local activeCamera = pfModules.CameraInterface.getActiveCamera("MainCamera")
		local baseFov = activeCamera:getBaseFov()

		args[1] = ui.flags.visuals_adsfov.value and math.tan(baseFov * math.pi / 360) / math.tan(ui.flags.visuals_fov.value * math.pi / 360) or args[1]
		visuals.mainCameraObjectSetMagHook.old(self, unpack(args))
	end)

	-- third person
	visuals.thirdPerson = {}
	do
		local localTracker = {}
		visuals.thirdPerson.fakePosition = emptyVec3
		visuals.thirdPerson.inThirdPerson = false

		ui.flags.visuals_thirdp.changed:Connect(function()
			visuals.reverseViewmodel()
			visuals.saveViewmodel()
			visuals.updateViewmodelchams()
		end)
		ui.flags.visuals_thirdpkey.changed:Connect(function()
			visuals.reverseViewmodel()
			visuals.saveViewmodel()
			visuals.updateViewmodelchams()
		end)

		visuals.thirdPerson.replicationObject = pfModules.ReplicationObject.new(cloneref(localPlayer))

		visuals.thirdPerson.timesincelast3p = 0
		local setPosition = emptyVec3
		visuals.thirdPerson.step = runService.Stepped:Connect(function(upTime, deltaTime)
			visuals.thirdPerson.inThirdPerson = (ui.flags.visuals_thirdp.value and ui.flags.visuals_thirdpkey.value) or false
			local charObject = pfModules.CharacterInterface.getCharacterObject()
			local rootPart = charObject and charObject._rootPart

			if visuals.thirdPerson.inThirdPerson then
				local thingy = math.clamp((1 / (-2.71828 ^ (8 * math.clamp(visuals.thirdPerson.timesincelast3p, 0, 2)))) + 1, 0, 1) * ui.flags.visuals_thirdpdistance.value / 10
				-- what the actual fuck
				visuals.thirdPerson.targetCameraDistance = thingy

				if visuals.thirdPerson.timesincelast3p == 0 and charObject then
					visuals.thirdPerson.replicationObject._posspring.v = emptyVec3
					visuals.thirdPerson.replicationObject._posspring.p = rootPart.Position
					visuals.thirdPerson.replicationObject._posspring.t = rootPart.Position
				end

				visuals.thirdPerson.timesincelast3p = visuals.thirdPerson.timesincelast3p + deltaTime

				visuals.reverseViewmodel()
				visuals.saveViewmodel()
				visuals.updateViewmodelchams()
			else
				visuals.thirdPerson.timesincelast3p = 0
				visuals.thirdPerson.targetCameraDistance = 0
			end

			-- uncomment this stuff if u dont want the 3rd person model position interpolated

			if visuals.thirdPerson.thirdPersonObject then
				visuals.thirdPerson.replicationObject:step(2, true)
			end
			visuals.thirdPerson.replicationObject:resetSprings(setPosition)

			--visuals.thirdPerson.replicationObject._posspring.v = emptyVec3
			--visuals.thirdPerson.replicationObject._posspring.p = setPosition
			--visuals.thirdPerson.replicationObject._posspring.t = setPosition     

			if not visuals.thirdPerson.inThirdPerson then
				
				visuals.thirdPerson.replicationObject._posspring.v = emptyVec3
				visuals.thirdPerson.replicationObject._posspring.p = newVec3(0, -10000, 0)
				visuals.thirdPerson.replicationObject._posspring.t = newVec3(0, -10000, 0)
			end
			


			setPosition = (visuals.thirdPerson.inThirdPerson and misc and misc.noclipping and misc.noclipping.startedFrom) and misc.noclipping.startedFrom or (visuals.thirdPerson.inThirdPerson and rage.fakePosition.working) and rage.fakePosition.realPosition --[[or (visuals.thirdPerson.inThirdPerson and ui.flags.misc_bypassspeed.value) and rage.baseFirePos]] or (visuals.thirdPerson.inThirdPerson and charObject) and rootPart.Position or newVec3(0, -10000, 0)

			local model = visuals.thirdPerson and visuals.thirdPerson.replicationObject and visuals.thirdPerson.replicationObject._thirdPersonObject and visuals.thirdPerson.replicationObject._thirdPersonObject._characterModel
			if model then
				model.Parent = workspace.Ignore
			end
		end)

		-- stability fail, this is just this way so vaderhaxx can work on just abt any executor
		do
			local function isCameraCFrame(self, k)
				return self == camera and k == "CFrame"
			end

			local function clampThirdPersonDistance(v)
				if visuals.thirdPerson.thirdPersonObject and visuals.thirdPerson.inThirdPerson then
					local ray = Ray.new(v.p, (v * CFrame.new(0, 0, visuals.thirdPerson.targetCameraDistance).p) - v.p)
					local hitPart, hitPos, hitNormal = workspace:FindPartOnRayWithWhitelist(ray, { workspace.Map }, true)
					local distance = (hitPos - v.p).Magnitude - (hitPart and 0.15 or 0)
					v = v * CFrame.new(0, 0, distance)
				end

				return v
			end

			local function applyAspectRatio(v)
				local ratioy = ui.flags.visuals_aspectratioy.value / 100
				local ratiox = ui.flags.visuals_aspectratiox.value / 100

				local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = v:GetComponents()

				r01, r11, r21 = r01 * ratioy, r11 * ratioy, r21 * ratioy
				r00, r10, r20 = r00 * ratiox, r10 * ratiox, r20 * ratiox

				return CFrame.new(x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22)
			end

			local oldNewindex; oldNewindex = hookfunction(getrawmetatable(camera).__newindex, newcclosure(function(self, k, v)
				if isCameraCFrame(self, k) then
					v = clampThirdPersonDistance(v)
					v = applyAspectRatio(v)
				end
				return oldNewindex(self, k, v)
			end))
		end

		local function spawnThirdPerson()
			-- yea this is terrible but care factor (there is a bug where it fails to swap weapons)
			local fakeReplicationObject = table.clone(visuals.thirdPerson.replicationObject)
			fakeReplicationObject._player = localPlayer

			visuals.thirdPerson.replicationObject.spawn(fakeReplicationObject, nil, pfModules.ActiveLoadoutUtils.getActiveLoadoutData(pfModules.PlayerDataClientInterface.getPlayerData()))

			visuals.thirdPerson.replicationObject._thirdPersonObject = fakeReplicationObject._thirdPersonObject
			visuals.thirdPerson.thirdPersonObject = visuals.thirdPerson.replicationObject._thirdPersonObject

			visuals.reversePlayerchams()
			visuals.savePlayerchams()
			visuals.updatePlayerchams()
		end

		local function despawnThirdPerson()
			local thirdPersonModel = visuals.thirdPerson.replicationObject:despawn()
			if thirdPersonModel and thirdPersonModel.Destroy then
				thirdPersonModel:Destroy()
			end
			visuals.thirdPerson.thirdPersonObject = nil
			visuals.thirdPerson.previousArgs = nil
		end
			
		local charObject = pfModules.CharacterInterface.getCharacterObject()

		if charObject then
			spawnThirdPerson()
		end

        pfModules.CharacterEvents.onSpawned:Connect(function()
			table.clear(localTracker)

			spawnThirdPerson()

			visuals.reversePlayerchams()    
			visuals.savePlayerchams()
			visuals.updatePlayerchams()
        end)
		
		pfModules.CharacterEvents.onDespawned:Connect(function()
			despawnThirdPerson()
		end)

		-- certain actions the client performs has corresponding animations for the third person model
		visuals.thirdPerson.animations = {
			["aim"] = function(args)
				if not visuals.thirdPerson.thirdPersonObject then
					return
				end
				visuals.thirdPerson.thirdPersonObject:setAim(args[1])
			end,
			["sprint"] = function(args)
				if not visuals.thirdPerson.thirdPersonObject then
					return
				end
				visuals.thirdPerson.thirdPersonObject:setSprint(args[1])
			end,
			["stance"] = function(args)
				if not visuals.thirdPerson.thirdPersonObject then
					return
				end
				visuals.thirdPerson.thirdPersonObject:setStance(args[1])
			end,
			["stab"] = function(args)
				if not visuals.thirdPerson.thirdPersonObject then
					return
				end
				visuals.thirdPerson.thirdPersonObject:stab()
			end,
			["newbullets"] = function(args)
				if not visuals.thirdPerson.thirdPersonObject then
					return
				end
				visuals.thirdPerson.thirdPersonObject:kickWeapon(false, nil, 0, 0)
			end,
			["equip"] = function(args)
				if not visuals.thirdPerson.thirdPersonObject then
					return
				end
				
				do
					-- inventory update
					local current_loadout = pfModules.ActiveLoadoutUtils.getActiveLoadoutData(pfModules.PlayerDataClientInterface.getPlayerData())

					for i, v in next, current_loadout do
						visuals.thirdPerson.thirdPersonObject._replicationObject:swapWeapon(i, v)
					end
				end

				if args[1] > 2 then
					visuals.thirdPerson.thirdPersonObject:equipMelee()
				else
					visuals.thirdPerson.thirdPersonObject:equip(args[1])    
				end
			end,
			["repupdate"] = function(args)
				if not visuals.thirdPerson.thirdPersonObject then
					return
				end
				--[[localTracker[1 + #localTracker] = {
					receivedTime = tick(),
					position = args[1]
				}

				if #localTracker > 1 then
					local lerpFrom = localTracker[#localTracker - 1]
					local lerpTo = localTracker[#localTracker]
					local lerpedFor = 0
					local interpolateLoop; interpolateLoop = runService.Heartbeat:Connect(function(dt)
						visuals.thirdPerson.replicationObject:resetSprings(lerpFrom.position:lerp(lerpTo.position, math.min(1, lerpedFor / (lerpTo.receivedTime - lerpFrom.receivedTime))))
						if not visuals.thirdPerson.thirdPersonObject or lerpedFor > lerpTo.receivedTime - lerpFrom.receivedTime then
							interpolateLoop:Disconnect()
							interpolateLoop = nil
							return
						end
						lerpedFor = lerpedFor + dt
					end)
				end]]
				visuals.thirdPerson.previousArgs = args
			end,
		}
		for request, func in next, visuals.thirdPerson.animations do
			networking.addHook(request, -100, function(args)
				if visuals.thirdPerson.thirdPersonObject then
					func(args)
				end
			end)
		end

		-- $$$$$$$$
		--networking.addListener("bulkplayerupdate", 0, function()
		local lastBulkUpdate = tick()
		runService.RenderStepped:Connect(function()
			if tick() - lastBulkUpdate < 1/20 then
				return
			end
			lastBulkUpdate = tick()
			local args = visuals.thirdPerson.previousArgs
			if args and visuals and visuals.thirdPerson and visuals.thirdPerson.replicationObject and visuals.thirdPerson.replicationObject._smoothReplication then
				local ts = pfModules.GameClock.getTime()
				visuals.thirdPerson.replicationObject._smoothReplication:receive(ts, ts, {
					t = ts,
					position = args[1],
					velocity = emptyVec3,
					angles = args[2],
					barrelAngles = args[3],
					breakcount = 0,
				}, false)
			end
		end)
	end
	-- this broke at some point, cba to fix it
	Instance.new("BloomEffect", camera)
	visuals.updateWorldColor = function()
		local maplighting = lighting:FindFirstChild("MapLighting")

		if ui.flags.visuals_ambient.value then
			lighting.OutdoorAmbient = ui.flags.visuals_outdoorcolor.color
			lighting.Ambient = ui.flags.visuals_indoorcolor.color
		else
			if maplighting and maplighting:FindFirstChild("Brightness") then
				lighting.Ambient = maplighting.Ambient.Value
				lighting.OutdoorAmbient = maplighting.OutdoorAmbient.Value
			end
		end
		if ui.flags.visuals_forcetime.value then
			lighting.ClockTime = ui.flags.visuals_time.value
		end
		if ui.flags.visuals_brightness.value then
			if ui.flags.visuals_brightnesstype.value.fullbright == true then
				lighting.Brightness = 1
				lighting.GlobalShadows = false
			elseif ui.flags.visuals_brightnesstype.value.nightmode == true then
				lighting.Brightness = 0
			else
				if maplighting:FindFirstChild("Brightness") then
					lighting.Brightness = maplighting.Brightness.Value / 2
				end
			end
		else
			if maplighting and maplighting:FindFirstChild("Brightness") then
				lighting.Brightness = maplighting.Brightness.Value
				lighting.GlobalShadows = true
			end
		end
		camera.Bloom.Enabled = ui.flags.visuals_custombloom.value
		if ui.flags.visuals_custombloom.value then
			camera.Bloom.Intensity = ui.flags.visuals_bloomintensity.value / 100
			camera.Bloom.Size = ui.flags.visuals_bloomsize.value * 14 / 25
			camera.Bloom.Threshold = ui.flags.visuals_bloomthreshold.value / 400
		else
			camera.Bloom.Intensity = 0
			camera.Bloom.Size = 0
			camera.Bloom.Threshold = 0
		end
		local customAtmosphere = lighting:FindFirstChildOfClass("Atmosphere")
		if ui.flags.visuals_customatm.value then
			if customAtmosphere == nil then
				customAtmosphere = Instance.new("Atmosphere", lighting)
			end
			customAtmosphere.Color = ui.flags.visuals_customatmcolor.color
			customAtmosphere.Decay = ui.flags.visuals_customatmdecay.color
			customAtmosphere.Density = ui.flags.visuals_densityatm.value / 100
			customAtmosphere.Glare = ui.flags.visuals_glareatm.value / 10
			customAtmosphere.Haze = ui.flags.visuals_hazeatm.value / 10
		else
			if customAtmosphere then
				customAtmosphere.Density = 0
				customAtmosphere.Glare = 0
				customAtmosphere.Haze = 0
			end
		end
	end
	visuals.updateWorldColorLoop = runService.RenderStepped:Connect(visuals.updateWorldColor)

	visuals.skyboxes = skyBoxes

	function visuals.updatesky()
		if ui.flags.visuals_customsky.value then
			local sky = lighting:FindFirstChildOfClass("Sky")
			if sky == nil then
				sky = Instance.new("Sky", lighting)
			end
			local skyChoice
			for i, v in next, ui.flags.visuals_skychoice.value do
				if v == true then
					skyChoice = i
				end
			end
			if not skyChoice then return end
			for i, v in next, (visuals.skyboxes[skyChoice]) do
				sky[i] = v
			end
			return
		end
		if lighting:FindFirstChildOfClass("Sky") then
			lighting:FindFirstChildOfClass("Sky"):Destroy()
		end
	end

	ui.flags.visuals_customsky.changed:Connect(visuals.updatesky)
	ui.flags.visuals_skychoice.changed:Connect(visuals.updatesky)
	lighting.ChildAdded:Connect(visuals.updatesky)


	-- pasted from bloxsense v3 (asset stolen from bitch boob)
	visuals.bulletTracerObjects = {}
	visuals.bulletTracerIndex = 1
	do
		visuals.tracerParent = Instance.new("Part", workspace.Ignore)
		visuals.tracerParent.Anchored = true
		visuals.tracerParent.CanCollide = false
		visuals.tracerParent.Transparency = 1
	end
	do
		for i = 1, 10 do
			visuals.bulletTracerObjects[i] = {
				beam = Instance.new("Beam"),
				a0 = Instance.new("Attachment"),
				a1 = Instance.new("Attachment"),
				used = false
			}
		end
	end

	visuals.bulletTracer = function(origin, target, c, a, t)
		visuals.bulletTracerIndex = visuals.bulletTracerIndex + 1
		if visuals.bulletTracerIndex > 10 then
			for i = 1, 10 do
				visuals.bulletTracerObjects[i] = {
					beam = Instance.new("Beam"),
					a0 = Instance.new("Attachment"),
					a1 = Instance.new("Attachment"),
					used = false
				}
			end
			visuals.bulletTracerIndex = 1
		end
		local object = visuals.bulletTracerObjects[visuals.bulletTracerIndex]
		object.used = true

		object.a0.WorldPosition = origin
		object.a1.WorldPosition = target
		object.beam.Attachment0 = object.a0
		object.beam.Attachment1 = object.a1
		object.beam.FaceCamera = true
		--object.beam.LightInfluence = 1
		object.beam.LightEmission = 1
		object.beam.Color = ColorSequence.new(c.color)
		object.beam.Transparency = NumberSequence.new(math.abs(1 - a.transparency))
		object.beam.Texture = "rbxassetid://446111271"
		object.beam.TextureLength = 12
		object.beam.TextureSpeed = 8
		object.beam.ZOffset = 1
		object.beam.TextureMode = Enum.TextureMode.Wrap
		object.a0.Parent = visuals.tracerParent
		object.a1.Parent = visuals.tracerParent
		object.beam.Parent = visuals.tracerParent
		task.spawn(function()
			local originalSpeed = object.beam.TextureSpeed

			local passed = 0
			local fading = t
			while passed < fading do
				object.beam.TextureSpeed = originalSpeed - (6 * (passed / fading))

				local targetWidth = (1 * math.clamp((passed - (fading / 2)) / fading, 0, 1))

				object.beam.Width0 = 1 - targetWidth
				object.beam.Width1 = 1 - targetWidth

				object.beam.Color = ColorSequence.new(c.color)
				object.beam.Transparency = NumberSequence.new(math.abs(1 - a.transparency))

				passed = passed + task.wait()
			end

			object.beam.Destroy(object.beam)
			object.a0.Destroy(object.a0)
			object.a1.Destroy(object.a1)
			table.clear(object)
			visuals.bulletTracerObjects[visuals.bulletTracerIndex] = nil
			object = nil
		end)
	end
	-- unreal! $
	local function createInstance(type, properties)
		local instance = Instance.new(type)
		if properties then
			for i,v in next, properties do
				instance[i] = v
			end
		end
		return instance
	end
	-- this shows the bullet drop i think
	local function renderBullet(origin, initialVelocity, gravityVector, c, a, t)
		local cf = CFrame.lookAt(origin, origin + initialVelocity*Vector3.new(1, 0, 1))
		--TODO: FIGURE THIS OUT
		--Project the velocity vector into an XY PLANE
		local vx, vy = (initialVelocity.X*initialVelocity.X + initialVelocity.Z*initialVelocity.Z)^0.5, initialVelocity.Y
		local dummyPart = createInstance("Part", {
			CanCollide = false,
			Transparency = 1,
			Anchored = true,
			CFrame = cf*CFrame.Angles(0, math.pi/2, 0),
			Parent = workspace.Ignore
		})
		local parabola = createInstance("ParabolaAdornment", {
			Adornee = dummyPart,
			Parent = dummyPart,
			Thickness = 0.1,
			A = gravityVector.Y/(2*vx*vx),
			B = vy/vx,
			C = 0,
			Range = 2*math.abs(vx*vy/gravityVector.Y),
			Color3 = c,
			Transparency = a,
			Visible = true
		})

		task.wait(t / 2)
		local passed = 0
		local ending = t - (t / 2)
		local oldThickness = parabola.Thickness
		while passed < ending do
			parabola.Thickness = oldThickness - (oldThickness * (passed / ending))
			passed = passed + task.wait()
		end

		parabola:Destroy()
		dummyPart:Destroy()
	end

	visuals.onNewBullets = function(args)
		if ui.flags.visuals_bullettracers.value then
			for o, v in next, args[2].bullets do
				--task.spawn(renderBullet, args[1].firepos, v[1], pfModules.PublicSettings.bulletAcceleration, ui.flags.visuals_bullettracercolor.color, ui.flags.visuals_bullettracercolor.transparency, ui.flags.visuals_bulettracertime.value)
				visuals.bulletTracer(args[2].firepos, args[2].firepos + v[1] * pfModules.PublicSettings.bulletLifeTime, ui.flags.visuals_bullettracercolor, ui.flags.visuals_bullettracercolor, ui.flags.visuals_bulettracertime.value)
			end
		end
	end
	networking.addHook("newbullets", -10, visuals.onNewBullets)
	visuals.onClientNewBullets = function(args)
		local fromPlayer = args[1].player
		local pInfo = playerInfo.list[fromPlayer]

		if not pInfo or not pInfo.enemy then
			return
		end
		
		if ui.flags.visuals_bullettracers2.value then
			for o, v in next, args[1].bullets do
				--task.spawn(renderBullet, args[1].firepos, v.velocity, pfModules.PublicSettings.bulletAcceleration, ui.flags.visuals_bullettracercolor2.color, ui.flags.visuals_bullettracercolor2.transparency, ui.flags.visuals_bulettracertime.value)
				visuals.bulletTracer(args[1].firepos, args[1].firepos + v.velocity * pfModules.PublicSettings.bulletLifeTime, ui.flags.visuals_bullettracercolor2, ui.flags.visuals_bullettracercolor2, ui.flags.visuals_bulettracertime.value)
			end
		end
	end
	networking.addListener("newbullets", -1, visuals.onClientNewBullets)

	visuals.hitChams = function(plr, c, a, t)
		local pInfo = playerInfo.list[plr]
		if pInfo then
			local body = pInfo.character
			if body then
				local material = ui.flags.visuals_hitchammaterial.value
				local mat = material.ghost and Enum.Material.ForceField or
					material.flat and Enum.Material.Neon or
					material.foil and Enum.Material.Foil or
					material.custom and Enum.Material.SmoothPlastic or
					material.reflective and Enum.Material.Glass or
					material.metallic and Enum.Material.Metal

				local color = c
				local hit = tick()
				local life = t
				local death = hit + life

				for _, part in next, (body) do
					local copy = Instance.new("Part")
					copy.Parent = workspace.Ignore
					copy.Material = mat
					copy.Color = color.color
					copy.Anchored = true
					copy.CanCollide = false
					copy.Transparency = math.abs(1 - a.transparency)
					copy.CFrame = part.CFrame
					copy.Size = part.Size

					local loop
					loop = runService.Stepped:Connect(function()
						local percent = math.abs(1 - (death - tick()) / life)
						if percent >= 1 then
							loop:Disconnect()
							copy:Destroy()
							return
						end
						copy.Transparency = percent * a.transparency
					end)
				end
			end
		end
	end
	visuals.onBulletHit = function(args)
		if ui.flags.visuals_hitchams.value then
			visuals.hitChams(args[2], ui.flags.visuals_hitchamcolor, ui.flags.visuals_hitchamcolor, ui.flags.visuals_hitchamtime.value)
		end
	end
	networking.addHook("bullethit", -10, visuals.onBulletHit)

	visuals.grenadeWarning = {}
	visuals.grenadeWarning.onGrenade = function(path, grenadeData)
		local nadeimg = cache.images.grenade
		local warningimg = cache.images.exclamation

		local endpoint = path[#path].p
		local explode = path[#path].t - (localPing / 1000)
		local timeToExplode = explode

		local baseoutlinecolor = Color3.fromRGB(0, 0, 0)
		local basebackcolor = Color3.fromRGB(24, 24, 24)
		local basefrontcolor = Color3.fromRGB(12, 12, 12)
		local dangercolor = Color3.fromRGB(170, 10, 10)
		local baseradius = 24

		local nadeindicator = {}
		nadeindicator.Drawings = {
			verybackcircle = esp.createDrawing("Circle", { Thickness = 0, Filled = true, NumSides = 360, Radius = baseradius, Visible = true, Color = baseoutlinecolor }),
			backcircle = esp.createDrawing("Circle", { Thickness = 0, Filled = true, NumSides = 360, Radius = baseradius - 2, Visible = true, Color = basebackcolor }),
			lines = {},
			frontfrontcircle = esp.createDrawing("Circle", { Thickness = 0, Filled = true, NumSides = 360, Radius = baseradius - 4, Visible = true, Color = basefrontcolor }),
			frontcircle = esp.createDrawing("Circle", { Thickness = 0, Filled = true, NumSides = 360, Radius = baseradius - 6, Visible = true, Color = baseoutlinecolor }),
			img = esp.createDrawing("Image", { Visible = true, Size = newVec2(24, 30), Data = nadeimg }),
			warnimg = esp.createDrawing("Image", { Visible = false, Size = newVec2(16, 36), Data = warningimg })
		}

		local lines = nadeindicator.Drawings.lines
		local radiusDifference = nadeindicator.Drawings.backcircle.Radius - nadeindicator.Drawings.frontfrontcircle.Radius
		local circumference = math.pi * (2 * (baseradius - 4))
		local numLines = math.floor(circumference)

		for i = 1, numLines do
			lines[i] = esp.createDrawing("Line", { Thickness = 2, Visible = true, Color = Color3.fromRGB(255, 0, 0) })
		end

		-- Save the original colors
		local originalColors = {}
		for _, v in pairs({ nadeindicator.Drawings.verybackcircle, nadeindicator.Drawings.backcircle, nadeindicator.Drawings.frontfrontcircle, nadeindicator.Drawings.frontcircle }) do
			originalColors[v] = v.Color
		end

		nadeindicator.loop = runService.Stepped:Connect(function(upTime, deltaTime)
			explode = explode - deltaTime
			if explode < 0 then
				nadeindicator.loop:Disconnect()
				nadeindicator.loop = nil
				for _, Drawing in pairs(lines) do
					Drawing:Remove()
				end
				nadeindicator.Drawings.lines = nil
				for _, Drawing in pairs(nadeindicator.Drawings) do
					Drawing:Remove()
				end
				return
			end

			local charObject = pfModules.CharacterInterface.getCharacterObject()
			if not ui.flags.dropped_grenadewarning.value or not charObject then
				for _, v in pairs(nadeindicator.Drawings) do
					if v.Transparency ~= nil then
						v.Transparency = 0
					end
				end
				for _, v in pairs(nadeindicator.Drawings.lines) do
					if v.Transparency ~= nil then
						v.Transparency = 0
					end
				end
				return
			end

			local health = charObject:getHealth()
			local screenpos = mathematics.worldToViewportPoint(endpoint, true, 50)
			local centerpos = newVec2(math.floor(screenpos.x), math.floor(screenpos.y))
			local displacement = (endpoint - charObject._rootPart.Position).Magnitude
			local trans = math.abs(1 - math.clamp((displacement - 2 * grenadeData.range1) / (0.5 * grenadeData.range1), 0, 1))

			for i, v in next, nadeindicator.Drawings do
				if i == "lines" then
					for i2, v2 in next, v do
						v2.Transparency = trans
					end
				else
					v.Transparency = trans
				end
			end

			if trans <= 0 then
				return
			end

			local range0 = grenadeData.range0
            local range1 = grenadeData.range1
            local damage0 = grenadeData.damage0
            local damage1 = grenadeData.damage1

			local dmg = displacement < range0 and damage0 or (displacement < range1 and (damage1 - damage0) / (range1 - range0) * (displacement - range0) + damage0 or damage1)
			local percentdmg = math.min(dmg / health, 1)

			if workspace:FindPartOnRayWithWhitelist(Ray.new(charObject._rootPart.Position, endpoint - charObject._rootPart.Position), {workspace.Map}) or displacement >= grenadeData.range1 then
				percentdmg = 0
				dmg = 0
			end

			--print(dmg, health, displacement, range0, damage0, range1, damage1)

			local lerpcolor = ui.flags.dropped_grenadelowcolor.color:lerp(ui.flags.dropped_grenadehighcolor.color, 1 - (explode / timeToExplode))
			local toshow = math.floor(numLines * (1 - (explode / timeToExplode)))

			for i, line in next, (lines) do
				if i < toshow then
					line.Visible = false
				else
					line.Visible = true
				end
			end

			for i, line in next, (lines) do
				local mangle = (i / numLines) * 360
				local cx, cy = math.sin(toRad * mangle), math.cos(toRad * mangle)

				local lineLength = displacement < radiusDifference and displacement or radiusDifference
				line.From = centerpos + newVec2(math.floor(cx * (baseradius - 4)), math.floor(cy * (baseradius - 4)))
				line.To = centerpos + newVec2(math.floor(cx * (baseradius - 2)), math.floor(cy * (baseradius - 2)))
				line.Color = lerpcolor
			end

			for _, v in pairs({ nadeindicator.Drawings.verybackcircle, nadeindicator.Drawings.backcircle, nadeindicator.Drawings.frontfrontcircle, nadeindicator.Drawings.frontcircle }) do
				v.Color = originalColors[v]:lerp(dangercolor, percentdmg)
				v.Position = centerpos
				v.Visible = true
			end
			nadeindicator.Drawings.warnimg.Position = centerpos - newVec2(8, 18)
			nadeindicator.Drawings.img.Position = centerpos - newVec2(12, 15)

			if dmg > health then
				nadeindicator.Drawings.warnimg.Visible = true
				nadeindicator.Drawings.img.Visible = false
			else
				nadeindicator.Drawings.warnimg.Visible = false
				nadeindicator.Drawings.img.Visible = true
			end
		end)
	end
	visuals.grenadeLines = {}
	visuals.grenadeLines.onGrenade = function(args)
		local trajectory = args[3]
		local increments = #trajectory
		local lineacolor = ui.flags.dropped_grenadealinecolor.color
		local linebcolor = ui.flags.dropped_grenadeblinecolor.color

		for i2 = 2, increments + 1 do
			local framea = trajectory[i2]
			local frameb = trajectory[i2 - 1]
			local framec = trajectory[i2 + 1]
			local percent = (i2 - 1) / increments

			if not framea or not frameb then
				continue
			end

			local thisframe = framea.p
			local prevframe = frameb.p
			local thistime = framea.t

			local ind = Instance.new("Part", workspace.Ignore)
			ind.Anchored = true
			ind.CanCollide = false
			local length = (thisframe - prevframe).Magnitude
			ind.Size = Vector3.new(0.01, 0.01, length)
			ind.CFrame = CFrame.new(prevframe, thisframe)
			ind.Material = Enum.Material.Neon
			ind.Transparency = 1
			ind.Position = thisframe + ((prevframe - thisframe) / 2)

			local show = Instance.new("CylinderHandleAdornment", workspace.Ignore)
			show.AlwaysOnTop = true
			show.Transparency = 0
			show.Visible = ui.flags.dropped_grenadelines.value
			show.ZIndex = 2
			show.Adornee = ind
			show.Parent = workspace.Ignore
			show.Radius = 0.1

			ui.flags.dropped_grenadelines.changed:Connect(function()
				show.Visible = ui.flags.dropped_grenadelines.value
			end)

			ui.flags.dropped_grenadealinecolor.changed:Connect(function()
				lineacolor = ui.flags.dropped_grenadealinecolor.color
				show.Color3 = lineacolor:lerp(linebcolor, percent)
			end)

			ui.flags.dropped_grenadeblinecolor.changed:Connect(function()
				linebcolor = ui.flags.dropped_grenadeblinecolor.color
				show.Color3 = lineacolor:lerp(linebcolor, percent)
			end)

			local loop
			loop = runService.RenderStepped:Connect(function(deltaTime)
				thistime = thistime - deltaTime
				if thistime < 0 then
					show:Destroy()
					ind:Destroy()
					loop:Disconnect()
					return
				end

				local newLength = (thisframe - prevframe).Magnitude
				local function customLerp(a, b, alpha)
					return a + (b - a) * alpha
				end

				show.Height = customLerp(show.Height, newLength, 0.9)
			end)
		end
	end
	visuals.onClientNewGrenade = function(args)
		if (args[1].TeamColor ~= localPlayer.TeamColor or tostring(args[1]) == localPlayer.Name) then
			visuals.grenadeWarning.onGrenade(args[3], pfModules.ContentInterface.getWeaponData(args[2]))
			visuals.grenadeLines.onGrenade(args)
		end
	end
	networking.addListener("newgrenade", 0, visuals.onClientNewGrenade)
	-- this is the dumbest way of adding it but care hooker
	visuals.showTeleportLines = hooks.trampoline(rage, "traverseTeleports", function(waypoints, inversed, cancelFly)
		if ui.flags.visuals_teleportlines.value then

			local objects = {}
			for i = 1, #waypoints - 1 do
				local p0 = waypoints[i]
				local p1 = waypoints[i + 1]

				local part = Instance.new("Part")
				part.Size = newVec3(0.05, 0.05, (p1 - p0).Magnitude)
				part.CFrame = CFrame.lookAt(p0 + (p1 - p0)*0.5, p1)
				part.Transparency = 0.4
				part.CanCollide = false
				part.Anchored = true
				part.Parent = workspace.Ignore
				local adorn = Instance.new("BoxHandleAdornment")
				adorn.Size = part.Size + newVec3(0.01, 0.01, 0.01)
				adorn.Adornee = part
				adorn.Color3 = ui.flags.visuals_teleportlinecolor.color
				adorn.AlwaysOnTop = true
				adorn.ZIndex = 2
				adorn.Parent = workspace.Ignore
				table.insert(objects, part)
			end

			local function destroyPath()
				for i = #objects, 1, -1 do
					local part = table.remove(objects, i)
					part:Destroy()
				end
			end

			local spawned = tick()
			local countDownLoop; countDownLoop = runService.Stepped:Connect(function(u, dt)
				if tick() - spawned >= 10 then
					destroyPath()
					countDownLoop:Disconnect()
					countDownLoop = nil
					return
				end
			end)
		end

		return visuals.showTeleportLines.old(waypoints, inversed, cancelFly)
	end)

	-- fake indicator
	do
		local fakeindicator = {}
		fakeindicator.objects = {}
		fakeindicator.objects.text = esp.createDrawing("Text", {
			Visible = false,
			Font = Drawing.Fonts.Plex,
			Size = 13,
			Text = "FAKE",
			Centered = true,
			Outlined = true,
			Color = Color3.new(1, 1, 1)
		})

		fakeindicator.objects.backbar = esp.createDrawing("Square", {
			Visible = false,
			Color = Color3.fromRGB(0, 0, 0),
			Thickness = 0,
			Filled = true,
			Size = newVec2(32, 4)
		})

		fakeindicator.objects.bar = esp.createDrawing("Square", {
			Visible = false,
			Color = Color3.fromRGB(0, 255, 0),
			Thickness = 1,
			Filled = true,
			Size = newVec2(62, 2)
		})

		fakeindicator.loop = runService.Stepped:Connect(function()
			local charObject = pfModules.CharacterInterface.getCharacterObject()
			local rootPart = charObject and charObject._rootPart
			
			if ui.flags.visuals_realshow.value and charObject then
				for i, v in next, fakeindicator.objects do
					v.Visible = true
				end

				local fake = rage.fakePosition.working and rage.fakePosition.fakePosition or rootPart.Position
				local real = rootPart.Position
				local toflick = rage.fakePosition.working and math.clamp((1 - ((tick() - rage.fakePosition.currentChoke) / rage.fakePosition.maxChoke)), 0, 1) or 1


				fakeindicator.objects.text.Color = rage.fakePosition.working and Color3.new(1, 1, 1) or Color3.fromRGB(245, 239, 120)

				local screenpos = mathematics.worldToViewportPoint(fake, true, 50)
				screenpos = newVec2(math.floor(screenpos.x), math.floor(screenpos.y))

				fakeindicator.objects.text.Position = screenpos + newVec2(0, -2 - (fakeindicator.objects.text.Size))
				fakeindicator.objects.backbar.Position = screenpos + newVec2(-(fakeindicator.objects.backbar.Size.x / 2), 2 - (fakeindicator.objects.backbar.Size.y / 2))
				fakeindicator.objects.bar.Position = fakeindicator.objects.backbar.Position + newVec2(1, 1)

				fakeindicator.objects.bar.Size = newVec2(toflick * (fakeindicator.objects.backbar.Size.x - 2), (fakeindicator.objects.backbar.Size.y - 2))
				fakeindicator.objects.bar.Color = Color3.new(0.4, 1, 0.4):lerp(Color3.new(1, 0.4, 0.4), math.abs(1 - toflick))
			else
				for i, v in next, fakeindicator.objects do
					v.Visible = false
				end
			end
		end)
		visuals.fakeIndicator = fakeindicator
	end

	-- fov circles
	do -- show fov
		local fovCircles = {}
		fovCircles.objects = {}
		fovCircles.totalCircles = 4
		for i = 1, fovCircles.totalCircles do
			fovCircles.objects[1 + #fovCircles.objects] = esp.createDrawing("Circle", {
				Visible = false,
				Color = Color3.fromRGB(0, 0, 0),
				Transparency = 1,
				Thickness = 1,
				NumSides = 180,
				Radius = 20,
				Filled = false,
				Position = newVec2()
			})
		end
		for i = 1, fovCircles.totalCircles do
			fovCircles.objects[1 + #fovCircles.objects] = esp.createDrawing("Circle", {
				Visible = false,
				Color = Color3.fromRGB(0, 0, 0),
				Transparency = 0.25,
				Thickness = 3,
				NumSides = 180,
				ZIndex = -1,
				Radius = 20,
				Filled = false,
				Position = newVec2()
			})
		end
		fovCircles.update = function()
			if ui.flags.visuals_showfov.value then
				local screenSize = camera.ViewportSize
				local centerScreen = newVec2(math.floor(screenSize.x / 2), math.floor(screenSize.y / 2))
				local barrelScreen = centerScreen
				local camFov = camera.FieldOfView * 2
				screenSize = screenSize

				local charObject = pfModules.CharacterInterface.getCharacterObject()
				if charObject then
					local heldWeapon = currentInfo.heldWeapon()
					if heldWeapon:getWeaponType() == "Melee" then
					else
						if heldWeapon and pfModules.CameraInterface.getCameraType() == "MainCamera" and heldWeapon:getWeaponType() ~= "Melee" and heldWeapon._barrelPart then
							local startCf = legit.getBarrel()
							local heldWeaponData = heldWeapon._weaponData
							local origin = startCf.p
							local launching_velocity = startCf.LookVector.unit * heldWeaponData.bulletspeed
							local acceleration = pfModules.PublicSettings.bulletAcceleration
							local landing_time = 1.5
							local maximum_penetration = 0
							local step_size = 1/60

							do
								if landing_time ~= landing_time or math.abs(landing_time) == 1/0 or landing_time >= 2 then return end
								local ignore_list = {workspace.Terrain, workspace.Ignore, camera}
								local simulation_elapsed = 0
								local bullet_position = origin
								local bullet_velocity = launching_velocity
								local penetration_remaining = maximum_penetration

								local r1 = rayCaster.rayCast
								local r2 = rayCaster.raycastSingleExit 

								while simulation_elapsed < landing_time do
									local dt = math.min(step_size, landing_time - simulation_elapsed)
									local velocity = dt * bullet_velocity + dt * dt / 2 * acceleration
									local enter_cast = r1(bullet_position, velocity, ignore_list, rayCaster.bulletIgnored, true)

									if not enter_cast then
										bullet_velocity += dt*acceleration
										bullet_position += velocity
										simulation_elapsed += dt
										continue
									end

									local instance = enter_cast.Instance
									local enter_pos = enter_cast.Position
									local vel_unit = velocity.Unit

									bullet_position = enter_pos

									local exit_cast = r2(enter_pos, penetration_remaining*vel_unit, instance)

									if not exit_cast then -- too thick
										break
									end

									local penetrated = vel_unit:Dot(exit_cast.Position - enter_pos)
									if penetrated > penetration_remaining then
										break
									end
									penetration_remaining -= penetrated
									if penetration_remaining <= 0 then
										break
									end

									local scaled_dt = velocity:Dot(enter_pos - bullet_position) / velocity:Dot(velocity) * dt
									bullet_position = enter_pos + 0.01 * (bullet_position - enter_pos).unit
									bullet_velocity += dt*acceleration
									simulation_elapsed += scaled_dt

									table.insert(ignore_list, instance)
								end

								local onScreen = mathematics.worldToViewportPoint(bullet_position)
								barrelScreen = newVec2(math.floor(onScreen.x), math.floor(onScreen.y))
							end
						end
					end
				end

				do -- aim assist circle
					local thisCircle = fovCircles.objects[1]
					local thisOutlineCircle = fovCircles.objects[fovCircles.totalCircles + 1]
					if ui.flags.legit_aimassist.value then
						local isFromBarrel = ui.flags.legit_aimassistbarrelfov.value
						local thisFov = ui.flags.legit_aimassistfov.value
						local thisColor = ui.flags.visuals_aimassistfovcolor.color
						local thisTrans = ui.flags.visuals_aimassistfovcolor.transparency

						thisCircle.Transparency = thisTrans
						thisCircle.Color = thisColor
						thisCircle.Radius = thisFov / camFov * screenSize.x
						thisCircle.Visible = true

						if isFromBarrel == true then
							thisCircle.Position = barrelScreen
						else
							thisCircle.Position = centerScreen
						end

						thisOutlineCircle.Visible = true
						thisOutlineCircle.Radius = thisCircle.Radius
						thisOutlineCircle.Position = thisCircle.Position
						thisOutlineCircle.Transparency = thisCircle.Transparency / 4
					else
						thisCircle.Visible = false
						thisOutlineCircle.Visible = false
					end
				end

				do -- magnet triggerbots circle
					local thisCircle = fovCircles.objects[2]
					local thisOutlineCircle = fovCircles.objects[fovCircles.totalCircles + 2]
					if ui.flags.legit_triggerbot.value then
						local isFromBarrel = ui.flags.legit_aimassistbarrelfov.value
						local thisFov = ui.flags.legit_magnetfov.value
						local thisColor = ui.flags.visuals_triggerbotmagnetcolor.color
						local thisTrans = ui.flags.visuals_triggerbotmagnetcolor.transparency

						thisCircle.Transparency = thisTrans
						thisCircle.Color = thisColor
						thisCircle.Radius = thisFov / camFov * screenSize.x
						thisCircle.Visible = true

						if isFromBarrel then
							thisCircle.Position = barrelScreen
						else
							thisCircle.Position = centerScreen
						end

						thisOutlineCircle.Visible = true
						thisOutlineCircle.Radius = thisCircle.Radius
						thisOutlineCircle.Position = thisCircle.Position
						thisOutlineCircle.Transparency = thisCircle.Transparency / 4
					else
						thisCircle.Visible = false
						thisOutlineCircle.Visible = false
					end
				end

				do -- bullet redirection circle
					local thisCircle = fovCircles.objects[3]
					local thisOutlineCircle = fovCircles.objects[fovCircles.totalCircles + 3]
					if ui.flags.legit_bulletredirection.value then
						local isFromBarrel = ui.flags.legit_silentbarrelfov.value
						local thisFov = ui.flags.legit_bulletredirectionfov.value
						local thisColor = ui.flags.visuals_bulletredirectioncolor.color
						local thisTrans = ui.flags.visuals_bulletredirectioncolor.transparency

						thisCircle.Transparency = thisTrans
						thisCircle.Color = thisColor
						thisCircle.Radius = thisFov / camFov * screenSize.x
						thisCircle.Visible = true

						if isFromBarrel then
							thisCircle.Position = barrelScreen
						else
							thisCircle.Position = centerScreen
						end

						thisOutlineCircle.Visible = true
						thisOutlineCircle.Radius = thisCircle.Radius
						thisOutlineCircle.Position = thisCircle.Position
						thisOutlineCircle.Transparency = thisCircle.Transparency / 4
					else
						thisCircle.Visible = false
						thisOutlineCircle.Visible = false
					end
				end

				do -- aimbot circle
					local thisCircle = fovCircles.objects[4]
					local thisOutlineCircle = fovCircles.objects[fovCircles.totalCircles + 4]
					if ui.flags.rage_enabled.value then
						local isFromBarrel = false
						local thisFov = ui.flags.rage_aimbotfov.value
						local thisColor = ui.flags.visuals_aimbotcolor.color
						local thisTrans = ui.flags.visuals_aimbotcolor.transparency

						thisCircle.Transparency = thisTrans
						thisCircle.Color = thisColor
						thisCircle.Radius = thisFov / camFov * screenSize.x
						thisCircle.Visible = true

						if isFromBarrel then
							thisCircle.Position = barrelScreen
						else
							thisCircle.Position = centerScreen
						end

						thisOutlineCircle.Visible = true
						thisOutlineCircle.Radius = thisCircle.Radius
						thisOutlineCircle.Position = thisCircle.Position
						thisOutlineCircle.Transparency = thisCircle.Transparency / 4
					else
						thisCircle.Visible = false
						thisOutlineCircle.Visible = false
					end
				end
			else
				for i, circle in next, fovCircles.objects do
					circle.Visible = false
				end
			end
		end
		fovCircles.loop = runService.RenderStepped:Connect(function()
			fovCircles.update()
		end)
		visuals.fovCircles = fovCircles
	end
end

-- misc
do
	misc.lastRubberBand = 0 -- never used
	-- this is all functions to preserve the ragebot code style
	misc.speedHack = function(looking, keys)
		local travel = emptyVec3 
		if keys.forward then
			travel = travel + looking
		end
		if keys.backward then
			travel = travel - looking
		end
		if keys.right then
			travel = travel + newVec3(-looking.Z, 0, looking.X)
		end
		if keys.left then
			travel = travel + newVec3(looking.Z, 0, -looking.X)
		end
		local travelVec2 = newVec2(travel.X, travel.Z)
		local wishDirection = newVec3(travelVec2.x, 0, travelVec2.y).unit

		if wishDirection ~= wishDirection then
			return emptyVec3
		end
		return wishDirection
	end
	misc.flyHack = function(looking, keys)
		local travel = emptyVec3 
		if keys.forward then
			travel = travel + looking
		end
		if keys.backward then
			travel = travel - looking
		end
		if keys.right then
			travel = travel + newVec3(-looking.Z, 0, looking.X)
		end
		if keys.left then
			travel = travel + newVec3(looking.Z, 0, -looking.X)
		end

		local wishDirection = travel.unit

		if wishDirection ~= wishDirection then
			wishDirection = emptyVec3
		end

		if keys.up then
			travel = travel + newVec3(0, 1, 0)
		end

		if keys.down then
			travel = travel + newVec3(0, -1, 0)
		end

		wishDirection = travel.unit

		if wishDirection ~= wishDirection then
			return emptyVec3
		end
		return wishDirection
	end

	misc.timeOnFloor = 0
	misc.baseDir = 1

	misc.movementLoop = runService.RenderStepped:Connect(function(deltaTime)

		local charObject = pfModules.CharacterInterface.getCharacterObject()

		if not charObject then return end

		local humanoid = charObject and charObject._humanoid
        local rootPart = charObject and charObject._rootPart
		local myCframe = rootPart.CFrame
		local looking = camera.CFrame.LookVector

		local directions = {
			newVec3(0, 1.6, 0),
			newVec3(0, 1, 0),
			newVec3(0, 0.5, 0),
			newVec3(0, 0, 0),
			newVec3(0, -0.5, 0),
			newVec3(0, -1, 0),
			newVec3(0, -1.9, 0)
		}

		if humanoid.FloorMaterial == Enum.Material.Air then
			misc.timeOnFloor = 0
		else
			misc.timeOnFloor = misc.timeOnFloor + deltaTime
		end
		
		if charObject._climbing.t ~= 0 or userInputService:GetFocusedTextBox() ~= nil then
			return
		end

		if misc.timeOnFloor >= 0.08 and ui.flags.misc_autojump.value then
			misc.autoJump(humanoid, {
				up = userInputService:IsKeyDown(Enum.KeyCode.Space),
			})
		end

		if ui.flags.misc_fly.value and ui.flags.misc_flykey.value then
			local speed = math.clamp(ui.flags.misc_flyspeedfactor.value, 0, tick() - misc.lastRubberBand < 0.1 and 60 or 1/0)
			local moveIn = misc.flyHack(looking, {
				forward = userInputService:IsKeyDown(Enum.KeyCode.W),
				backward = userInputService:IsKeyDown(Enum.KeyCode.S),
				right = userInputService:IsKeyDown(Enum.KeyCode.D),
				left = userInputService:IsKeyDown(Enum.KeyCode.A),
				up = userInputService:IsKeyDown(Enum.KeyCode.Space),
				down = userInputService:IsKeyDown(Enum.KeyCode.LeftAlt),
			})

			local moveBy = moveIn * speed * deltaTime

			local isNoclipping = false --ui.flags.misc_noclip.value and ui.flags.misc_noclipkey.value
			if isNoclipping and charObject and charObject._humanoid then
				charObject._humanoid:ChangeState(11)
			else
				charObject._humanoid:ChangeState(Enum.HumanoidStateType.Running)
			end
			if isNoclipping then
				rootPart.Position = rootPart.Position + moveBy
				rootPart.Velocity = moveIn * speed
				rootPart.Anchored = true
				return
			end

			rootPart.Velocity = moveIn * speed
			rootPart.Anchored = true

			local currentPosition = rootPart.Position
			local newPosition = currentPosition + moveBy

			for _, offset in next, (directions) do
				local wallHit, positionOnWall, normalOnWall = workspace:FindPartOnRayWithWhitelist(Ray.new(currentPosition + offset, moveBy * 1.5), { workspace.Map }, true)

				if wallHit then
					-- Handle collision
					local normalProjection = moveBy - moveBy:Dot(normalOnWall) * normalOnWall
					newPosition = currentPosition + normalProjection

					break
				end
			end

			rootPart.Position = newPosition
			return
		else
			rootPart.Anchored = false
		end

		if ui.flags.misc_speed.value and ui.flags.misc_speedkey.value then
			local speed = math.clamp(ui.flags.misc_speedfactor.value, 0, tick() - misc.lastRubberBand < 0.1 and 60 or 1/0)

			-- a bit messed up but it worked pretty well
			if ui.flags.misc_circlestrafe.value and ui.flags.misc_circlestrafekey.value then
				local radius = ui.flags.misc_circlestraferadius.value
				local direction = misc.baseDir
				if userInputService:IsKeyDown(Enum.KeyCode.D) then
					direction = 1
				end
				if userInputService:IsKeyDown(Enum.KeyCode.A) then
					direction = -1
				end

				misc.baseDir = direction

				if not misc.angle then
					misc.angle = 0
				end

				local middleCircle = myCframe.p - newVec3(radius * math.cos(toRad * misc.angle), 0, radius * math.sin(toRad * misc.angle))
				local circumference = radius * 2 * pi
				local degreesPerSec = (speed / circumference) * 360
				local changeDegree = degreesPerSec * deltaTime

				misc.angle = misc.angle + (changeDegree * misc.baseDir)

				local moveTo = middleCircle + newVec3(radius * math.cos(toRad * misc.angle), 0, radius * math.sin(toRad * misc.angle))
				local moveIn = (moveTo - myCframe.p).unit
				local moveBy = moveIn * speed * deltaTime
				local wallHit, positionOnWall, normalOnWall = workspace:FindPartOnRayWithWhitelist(Ray.new(myCframe.p, moveBy), {workspace.Map}, true)
				if not wallHit then
					rootPart.Position = moveTo
				else
					misc.baseDir = misc.baseDir * -1
				end

				return
			else
				misc.angle = nil
			end

			if ui.flags.misc_speedtype.value["always"] or ui.flags.misc_speedtype.value["in air"] and humanoid.FloorMaterial == Enum.Material.Air then
				local moveIn = misc.speedHack(looking, {
					forward = userInputService:IsKeyDown(Enum.KeyCode.W),
					backward = userInputService:IsKeyDown(Enum.KeyCode.S),
					right = userInputService:IsKeyDown(Enum.KeyCode.D),
					left = userInputService:IsKeyDown(Enum.KeyCode.A),
				})

				local moveBy = moveIn * speed * deltaTime

				-- Collision avoidance for speed...
				for _, offset in next, directions do
					local wallHit, positionOnWall, normalOnWall = workspace:FindPartOnRayWithWhitelist(Ray.new(myCframe.p + offset - moveBy, moveBy * 1.5), {workspace.Map}, true)

					if wallHit then
						-- Handle collision
						local normalProjection = moveBy - moveBy:Dot(normalOnWall) * normalOnWall

						rootPart.Velocity = newVec3(0, rootPart.Velocity.y, 0) + (normalProjection * deltaTime)

						return
					end
				end

				rootPart.Velocity = newVec3(0, rootPart.Velocity.y, 0) + (moveIn * speed)
				return
			end
		end
	end)

	-- noclip cheat and hack
	do
		-- Function to get spawn plates
		function misc.getSpawnPlates()
			local map = workspace:FindFirstChild("Map")
			if not map then return end
			local spawns = map:FindFirstChild("Spawns")
			if not spawns then return end

			local allPlates = {}
			for i, v in next, game.Teams:GetChildren() do
				local teamName = tostring(v)
				local teamSpawns = spawns:FindFirstChild(teamName)
				if teamSpawns then
					for i2, v2 in next, teamSpawns:GetChildren() do
						allPlates[1 + #allPlates] = v2
					end
				end
			end

			return allPlates
		end

		-- Function to get nearest spawn plates
		function misc.getNearestSpawnPlates(start, spawnPlates)
			local nearestSpawnPlates = {}
			for i, v in next, spawnPlates do
				nearestSpawnPlates[1 + #nearestSpawnPlates] = {
					v,
					(v.Position - start).Magnitude,
				}
			end

			table.sort(nearestSpawnPlates, function(a, b) return a[2] < b[2] end)

			local sorted = {}
			for i, v in next, nearestSpawnPlates do
				sorted[1 + #sorted] = v[1]
			end
			return sorted
		end

		-- Function to find the intersection point of a line and a plane
		local function findIntersectionPoint(lineStart, lineDir, planePoint, planeNormal)
			local t = ((planePoint - lineStart):Dot(planeNormal)) / lineDir:Dot(planeNormal)
			return lineStart + lineDir * t
		end

		-- Function for the main logic
		function misc.noClip(start, goal)
			local charObject = pfModules.CharacterInterface.getCharacterObject()
			local inTheWay, canGo = workspace:FindPartOnRayWithWhitelist(Ray.new(start, goal - start), {workspace.Map})
			if not inTheWay then
				return true, pathfinding.optimizePath({start, goal}, rage.maxTeleport())
			end

			local firstresult, firstdata = pathfinding.vadAStar({
				start = start,
				goal = goal,
				parameters = {
					step = 4,
					trials = inf,
					weighting = 400,
					mindist = 2,
					maxtime = 1/90,
				}
			})

			if firstresult == true then
				local waypoints = firstdata.waypoints
				local inTheWayAgain, canGoAgain = workspace:FindPartOnRayWithWhitelist(Ray.new(waypoints[#waypoints], goal - waypoints[#waypoints]), {workspace.Map})
				if not inTheWayAgain then
					waypoints[1 + #waypoints] = goal
					local optimised = pathfinding.optimizePath(waypoints, rage.maxTeleport())
					return true, optimised
				end
			end

			local mySpawnPlates = getSpawnPlates()
			if not mySpawnPlates or #mySpawnPlates == 0 then return end
			local nearestSpawnPlates = getNearestSpawnPlates(goal, mySpawnPlates)

			for i = #nearestSpawnPlates, 1, -1 do
				local spawnPlate = nearestSpawnPlates[i]
				local spawnPlatePos = spawnPlate.Position
				local spawnPlateSize = spawnPlate.Size

				local result, data = pathfinding.vadAStar({
					start = start,
					goal = spawnPlatePos,
					parameters = {
						step = 2,
						trials = inf,
						weighting = 400,
						mindist = 2,
						maxtime = 1/40,
					}
				})

				if result == true then
					local waypoints = data.waypoints

					-- Calculate the intersection point with the spawn plate
					local lastWaypoint = waypoints[#waypoints]
					local intersectionPoint = findIntersectionPoint(lastWaypoint, goal - lastWaypoint, spawnPlatePos, Vector3.new(0, 1, 0))

					-- Check line of sight between lastWaypoint and intersectionPoint
					local _, lineOfSightCanGo = workspace:FindPartOnRayWithWhitelist(Ray.new(lastWaypoint, intersectionPoint - lastWaypoint), {workspace.Map})

					if lineOfSightCanGo then
						-- Check if the line passes through the spawn plate before anything else
						local _, canGo = workspace:FindPartOnRayWithWhitelist(Ray.new(intersectionPoint, goal - intersectionPoint), {spawnPlate})
						if canGo == spawnPlate then
							waypoints[1 + #waypoints] = intersectionPoint
							local optimised = pathfinding.optimizePath(waypoints, rage.maxTeleport())
							optimised[1 + #optimised] = goal
							return true, optimised
						end
					end
				end
			end

			return
		end
	end
	misc.floorTeleports = function(position)
		local furthestDown, pos = workspace:FindPartOnRayWithWhitelist(Ray.new(position, newVec3(0, -15000, 0)), {workspace.Map})

		if furthestDown and furthestDown.Transparency == 1 then
			return false
		end

		if furthestDown and (pos - position).Magnitude > 4 and (pos - position).Magnitude < 8 then
			local furthestDownPosition = pos + newVec3(0, 2, 0)
			local downThere = pathfinding.optimizePath({position, furthestDownPosition}, rage.maxTeleport())
			local onFloor = table.create(#downThere / 2, furthestDownPosition)
			local upThere = pathfinding.optimizePath({furthestDownPosition, position}, rage.maxTeleport())

			local full = {}

			for process, steps in next, {downThere, onFloor, upThere} do
				for i, v in next, steps do
					full[1 + #full] = v
				end
			end

			return full
		else
			return false
		end
	end
	misc.bypassFly = function(args) -- onRepupdate
		local shouldTeleport = misc.floorTeleports(args[1])
		if shouldTeleport then
			for instruction = 1, #shouldTeleport do
				networking.send("repupdate", shouldTeleport[instruction], rage.baseAngles, rage.baseAngles2, tickbase:shift(rage.shiftTick()))
			end
			
			return true
		end
		return false
	end
	--misc.repupdateLog = {}

	networking.addListener("correctposition", 0, function(args)
		--ui:createnotification({text = "rubber banded by server!", lifetime = 1, priority = 0})
		rage.baseFirePos = args[1]
		rage.teleporting = nil
		rage.teleportfailed = true
		misc.lastRubberBand = tick()
	end)

	misc.onFallDamage = function(args)
		if ui.flags.misc_bypassfall.value then
			return true
		end
		return false
	end
	misc.onSpawn = function()
		--misc.repupdateLog = {}
	end
	networking.addHook("falldamage", 0, misc.onFallDamage)
	--networking.addHook("spawn", 0, misc.onSpawn)
	misc.autoJump = function(humanoid, keys)
		if keys.up then
			if humanoid.FloorMaterial ~= Enum.Material.Air and humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
				humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end
	misc.playSound = function(id, level)
		pfModules.AudioSystem.playSoundId(
			"rbxassetid://" .. id,
			level / 10,
			1.0,
			1.0,
			workspace,
			nil,
			0,
			0.03
		)
	end
	misc.onBulletHit = function(args)
		if ui.flags.misc_hitsound.value then
			misc.playSound(ui.flags.misc_hitsoundid.value, ui.flags.misc_hitsoundlevel.value)
		end
	end

	ui.flags.misc_hitsoundids.changed:Connect(function()
		for i, v in next, ui.flags.misc_hitsoundids.value do
			if v == true then
				if i ~= "custom" then
					ui.flags.misc_hitsoundid:setvalue(cheatHitSounds[i])
					break
				end
			end
		end
	end)

	networking.addHook("bullethit", -10, misc.onBulletHit)
	-- ? ok dude im done
	misc.streakSounds = {
		["killx2"] = {
			{sounds = {1950547222, 130819307, 6818527307}}
		},
		["killx3"] = {
			{sounds = {6818526855}}
		},
		["killxn"] = {
			{sounds = {723054723, 937898383, 6822465178, 6822465319, 6818526916, 6818527144, 6818527200, 6818526995}}
		}
	}
	misc.laststreakType = nil
	misc.lastkillSound = ""
	misc.lastkillSoundTick = 0

	networking.addListener("smallaward", 0, function(args)
		-- killx2, killx3, killxn
		if ui.flags.misc_killstreak.value then
			local streak = args[1]:find("kill") and args[1]

			if streak then
				if (tick() - misc.lastkillSoundTick) > 1.25 then

					local sounds = misc.streakSounds[streak]
					if sounds then
						local sound = sounds[math.random(1, #sounds)]
						local soundId = sound.sounds[math.random(1, #sound.sounds)]
						if misc.lastkillSound == soundId then
							repeat
								soundId = sound.sounds[math.random(1, #sound.sounds)]
							until misc.lastkillSound ~= soundId
						end

						if misc.laststreakType ~= streak or streak == "killxn" then
							misc.playSound(soundId, ui.flags.misc_killstreaklevel.value)
							misc.lastkillSound = soundId
							misc.laststreakType = streak
							misc.lastkillSoundTick = tick()
						end
					end
				end
			end
		end
	end)

	misc.lastKills = 0
	misc.lastKick = 0
	misc.onUpdateLeaderBoard = function(args)
		if tostring(args[1]) ~= localPlayer.Name then
			return
		end
		if type(args[2]) ~= "table" or not args[2].Kills then
			return
		end
		if args[2].Kills > misc.lastKills then
			if ui.flags.misc_killsound.value then
				misc.playSound(ui.flags.misc_killsoundid.value, ui.flags.misc_killsoundlevel.value)
			end

			if ui.flags.misc_autokick.value and tick() - misc.lastKick > 40 then
				getgenv().vaderhaxx.modules.cheat.networking.send("modcmd", string.format("/votekick:%s:cheats", game.Players:GetPlayers()[math.random(1, #game.Players:GetPlayers())].Name))
				misc.lastKick = tick()
			end
		end
		misc.lastKills = args[2].Kills
	end
	ui.flags.misc_killsoundids.changed:Connect(function()
		for i, v in next, ui.flags.misc_killsoundids.value do
			if v == true then
				if i ~= "custom" then
					ui.flags.misc_killsoundid:setvalue(cheatHitSounds[i])
					break
				end
			end
		end
	end)
	networking.addListener("updatestats", -10, misc.onUpdateLeaderBoard)
	misc.chatspammessages = {
		normal = {
			"PF HAXX.LUA ⚠️ KILL ALL BACK IN PF ⚠️",
			"HEY ⚠️ GUYS LETS ALLOW PEOPLE ✅ TO SEND THE EXACT SAME TICK OVER AND OVER 🧠",
			"NEW PF TIME ⏰ TRAVEL UPDATE ⏰ YOU CAN NOW BE 24 HOURS AHEAD OF THE SERVER ⏫",
			"NEW PF TIME ⏰ TRAVEL UPDATE ⏰ YOU CAN NOW BE 24 HOURS BEHIND THE SERVER ⏬",
			"I LOVE HAVING 2 HOURS OF PING 😄, NVM MY TICK IS 2 HOURS ⏰ BEHIND THE SERVER 😭",
			"I LOVE ❤️ SENDING REPUPDATE 2000 TIMES PER SECOND 😭😭",
			"I GOT SENT BACK TO THE PRE-TELEPORTING AND PRE-SPEEDHACKING DAYS 🗿🗿 IN PF V6 😭 CORRECT POSITION ON TOP ✅",
			"PF'S SPEED RESTRICTIONS WORK ✅ - SAID NO ONE EVER ❌",
			"SINCE WHEN DOES NOSPREADING ⚠️ YOUR BULLETS BYPASS ✅ ANTI CHEATS, DONT ALL CHEATS DO THAT ALREADY???? ❌",
			"YO DUDE WHAT CHEAT IS THAT 😄",
			"THAT CHEAT LOOKS REALLY COOL ICL 😄",
			"CORRECT POSITION ❤️ PF MAKING IT EASIER TO SPEED HACK ONE STEP AT A TIME ✅",
			"😞😞 TICK REMOVED FROM THE KNIFEHIT PACKET 😞😞 LAG COMPENSATION OBLITERATED 😞😞 KICKED AGAIN",
			"REPUPDATE 🖥️ IS A PERFECTLY SECURE PACKET 🔒 WITH ABSOLUTELY NO EXPLOITS ❌",
			"I THOUGHT PF ❤️ WAS A SECURE GAME WITH LOTS OF RESTRICTIONS ❌ SENDING REPUPDATE A FEW THOUSAND TIMES PER FRAME ISNT ONE OF THEM 😭",
			"WHY ❓ IS SOME DUDE LEGIT CHEATING ⚠️ WITH A SPEED BYPASS ENABLED 😭",
			"ONE MODIFIED REPUPDATE PACKET ✅ BREAKING ALL OF PF'S ANTI CHEAT MEASURES WITH ONE PACKET 😭",
			"SORRY EVERYONE 😞 WE FORGOT TO CHECK FOR INF SPEED ON THE SERVER 🧠 LETTING EVERYONE SPEEDHACK ✅",
		},
		emojis = {
			"😭😭😭😭😭😭😭😭😭😭😭😭😭😭😭😭😭😭😭😭😭😭😭😭😭😭😭",
			"🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓🤓",
			"🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣🤣",
			"😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂😂",
			"😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡",
			"🤪🤪🤪🤪🤪🤪🤪🤪🤪🤪🤪🤪🤪🤪🤪🤪🤪🤪🤪🤪🤪🤪🤪🤪🤪🤪🤪",
			"🤫🤫🤫🤫🤫🤫🤫🤫🤫🤫🤫🤫🤫🤫🤫🤫🤫🤫🤫🤫🤫🤫🤫🤫🤫🤫🤫",
			"🤐🤐🤐🤐🤐🤐🤐🤐🤐🤐🤐🤐🤐🤐🤐🤐🤐🤐🤐🤐🤐🤐🤐🤐🤐🤐🤐",
			"🙄🙄🙄🙄🙄🙄🙄🙄🙄🙄🙄🙄🙄🙄🙄🙄🙄🙄🙄🙄🙄🙄🙄🙄🙄🙄🙄",
			"😒😒😒😒😒😒😒😒😒😒😒😒😒😒😒😒😒😒😒😒😒😒😒😒😒😒😒",
			"😔😔😔😔😔😔😔😔😔😔😔😔😔😔😔😔😔😔😔😔😔😔😔😔😔😔😔",
			"🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶🥶",
			"☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️☹️",
			"😲😲😲😲😲😲😲😲😲😲😲😲😲😲😲😲😲😲😲😲😲😲😲😲😲😲😲",
			"😳😳😳😳😳😳😳😳😳😳😳😳😳😳😳😳😳😳😳😳😳😳😳😳😳😳😳",
			"😯😯😯😯😯😯😯😯😯😯😯😯😯😯😯😯😯😯😯😯😯😯😯😯😯😯😯",
			"🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡🤡",
			"😞😞😞😞😞😞😞😞😞😞😞😞😞😞😞😞😞😞😞😞😞😞😞😞😞😞😞",
			"🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥",
		},
	}
	misc.chatSpammer = {
		lastWord = "",
		lastMessage = tick(),
		getMessagePool = function(choice)
			local messagePool
			for i, v in next, choice do
				if v == true then
					if i == "custom" then
						local texts = readfile(cheat_path .. "/" .. game_path .. "/" .. "custom chat spammer messages.txt")
						messagePool = string.split(texts, "\n")
					else
						messagePool = misc.chatspammessages[i]
					end
					break
				end
			end
			return messagePool
		end,
		single = function(messagePool)
			if tick() - misc.chatSpammer.lastMessage > 4 + math.random() then
				local word
				repeat
					word = messagePool[math.random(#messagePool)]
				until word ~= misc.lastWord
				ui:createnotification({text = "chat spammer: " .. word, lifetime = 6, priority = 0})
				pfModules.NetworkClient:send("sendChatMessage", word, false)
			end
		end,
		think = function()
			if not ui.flags.misc_chatspam.value then
				return
			end
			misc.chatSpammer.single(misc.chatSpammer.getMessagePool(ui.flags.misc_chatspamchoice.value))
		end
	}
	misc.chatSpammer.thinkLoop = runService.Stepped:Connect(misc.chatSpammer.think)
	networking.addHook("sendChatMessage", -10, function(args)
		table.foreach(args, warn)
		misc.chatSpammer.lastMessage = tick()
		misc.chatSpammer.lastWord = args[1]
	end)

	misc.killsays = {
		normal = {
			"[victim] TAP IN NOW ✔ POWERFUL MULTIHACK 📱 TELEPORTING [gun] 🔫",
			"DESYNC EXPLOIT 😱 PF REPUPDATE 😍 SECURING YOUR GAMES",
			"[victim] WASTED 🚀 [killer] STRIKES AGAIN!",
			"[victim] FACES THE WRATH OF [killer] 🌪️",
			"[killer] DOMINATES! [victim] LEFT IN SHOCK! 🥶",
			"[victim] RIPPED APART BY [killer]'s [gun] 🛡️",
			"[victim] MEETS THEIR DOOM FROM [killer]'s [gun] 🔥 [distance] AWAY!",
			"[victim] GOT OWNED BY [killer]! 💥",
			"[victim] TOASTED 🍞 BY [killer] USING [gun] FROM [distance]!",
			"[victim] FACES DESTRUCTION FROM [killer]'s [gun]! 🌋",
			"[victim] ANNOUNCES A DATE WITH [killer]'s [gun] 💔",
			"[victim] CRUSHED BY [killer] WITH [gun] FROM [distance]! 😵",
			"[victim] AWAITS THEIR DOOM AT THE HANDS OF [killer] 🕒",
			"[victim] DISMANTLED BY [killer] WITH [gun] 🚫",
			"[victim] FOUND THEIR MATCH IN [killer]! 💢",
			"[victim] SERVED ON A PLATTER BY [killer] 🍽️",
			"[victim] DEVOURED BY [killer] WITH [gun] 🦁",
			"[victim] MEETS FATE VIA [killer]'s [gun]! 💀",
			"[victim] PLAYS TAG WITH [killer] AND LOSES 🏷️",
			"[victim] ASTRONAUTICAL EXPLOSION COURTESY OF [killer] 🚀",
			"[victim] KNOCKED OUT OF EXISTENCE BY [killer]'s [gun] 💨",
			"[victim] MEETS THEIR MAKER WITH [killer]'s [gun] 🏹",
			"你的在最短luau spoofer的时间内发挥出最佳水平new release，才能获得胜利。.gg/bloxsense",
			"WHY ARE YOU 😡 CHEATING 😡 IN A KIDS GAME 😡",
			"DUDE! STOP CHEATING! - [victim]",
			"SECURE ❌ REMOTE EVENTS 🤓 NEW HACKFILE ✔ BYPASS 🔓 [victim] GOT OWNED 😂",
			"ENCRYPTED ❌ ONLINE TRANSACTIONS 💳 UNTRACEABLE ✔ FIREWALL 🔥 THIS [gun] IS CRAZY..",
			"PROTECTED ❌ DIGITAL ASSETS 💻 IMPENETRABLE ✔ CIPHER 🤫",
			"FORTIFIED ❌ CLOUD STORAGE ☁️ UNHACKABLE ✔ SHIELD 🔒",
			"SHIELDED ❌ DATA BREACHES 🔍 INDESTRUCTIBLE ✔ DEFENSE 🛡️",
			"ARMORED ❌ NETWORK SECURITY 🔐 UNPENETRABLE ✔ BARRIER 🚧",
			"PLAY FAIR ✅ NO CHEATS ❌ SKILL ONLY 💪 SPORTSMANSHIP 🤝",
		},
	}

	misc.killsay = {
		lastMessage = tick(),
		lastKillSay = "",
		-- misc_killsays
		getMessagePool = function(choice)
			local messagePool
			for i, v in next, choice do
				if v == true then
					if i == "custom" then
						local texts = readfile(cheat_path .. "/" .. game_path .. "/" .. "custom kill messages.txt")
						messagePool = string.split(texts, "\n")
					else
						messagePool = misc.killsays[i]
					end
					break
				end
			end
			return messagePool
		end,
		single = function(messagePool, killer, victim, gun, distance)
			if tick() - misc.chatSpammer.lastMessage > 4 + math.random() then
				local word
				repeat
					word = messagePool[math.random(#messagePool)]
				until word ~= misc.killsay.lastKillSay

				word = word:gsub("%[victim%]", victim)
				word = word:gsub("%[killer%]", killer)
				word = word:gsub("%[gun%]", gun)
				word = word:gsub("%[distance%]", distance)

				pfModules.NetworkClient:send("sendChatMessage", word, false)
			end
		end,
	}
	
	networking.addListener("killfeed", 1, function(args)
		local killer = args[1].Name

		if killer ~= localPlayer.Name then
			return
		end

		local victim = args[2].Name
		local distance = tostring(math.round(tonumber(args[3]))) .. " studs"
		local gun = tostring(args[4])

		if ui.flags.misc_killsay.value then
			misc.killsay.single(misc.killsay.getMessagePool(ui.flags.misc_killsaychoice.value), killer, victim, gun, distance)
		end
	end)
	
	-- laser pointer code
	do
		misc.laserPointer = {}
		misc.laserPointer.DrawingObjects = {}
		misc.laserPointer.DrawingObjects.outlines = {}
		for i = 1, 4 do
			misc.laserPointer.DrawingObjects.outlines[i] = esp.createDrawing("Line", {
				Thickness = 3,
				Color = Color3.fromRGB(0, 0, 0),
				Transparency = 1,
				Visible = true
			})
		end
		misc.laserPointer.DrawingObjects.objects = {}
		for i = 1, 4 do
			misc.laserPointer.DrawingObjects.objects[i] = esp.createDrawing("Line", {
				Thickness = 1,
				Color = Color3.fromRGB(255, 255, 255),
				Transparency = 1,
				Visible = true
			})
		end
		misc.laserPointer.currentaddedrotation = 0
		misc.laserPointer.currentrotation = 0
		misc.laserPointer.render = function(upTime, deltaTime)
			if not ui.flags.misc_customcrosshair.value then
				for i, v in next, misc.laserPointer.DrawingObjects.objects do
					v.Visible = false
					misc.laserPointer.DrawingObjects.outlines[i].Visible = false
				end
				return
			end

			local screenPos = newVec2(math.floor(camera.ViewportSize.x / 2), math.floor(camera.ViewportSize.y / 2))
			local heldWeapon = currentInfo.heldWeapon()

			if heldWeapon and pfModules.CameraInterface.getCameraType() == "MainCamera" and heldWeapon:getWeaponType() ~= "Melee" and heldWeapon._barrelPart then
				local startCf = legit.getBarrel()
				local heldWeaponData = heldWeapon._weaponData
				local origin = startCf.p
				local launching_velocity = startCf.LookVector.unit * heldWeaponData.bulletspeed
				local acceleration = pfModules.PublicSettings.bulletAcceleration
				local landing_time = 1.5
				local maximum_penetration = 0
				local step_size = 1/60

				do
					if landing_time ~= landing_time or math.abs(landing_time) == 1/0 or landing_time >= 2 then return end
					local ignore_list = {workspace.Terrain, workspace.Ignore, camera}
					local simulation_elapsed = 0
					local bullet_position = origin
					local bullet_velocity = launching_velocity
					local penetration_remaining = maximum_penetration

					local r1 = rayCaster.rayCast
					local r2 = rayCaster.raycastSingleExit 

					while simulation_elapsed < landing_time do
						local dt = math.min(step_size, landing_time - simulation_elapsed)
						local velocity = dt * bullet_velocity + dt * dt / 2 * acceleration
						local enter_cast = r1(bullet_position, velocity, ignore_list, rayCaster.bulletIgnored, true)

						if not enter_cast then
							bullet_velocity += dt*acceleration
							bullet_position += velocity
							simulation_elapsed += dt
						else
							local instance = enter_cast.Instance
							local enter_pos = enter_cast.Position
							local vel_unit = velocity.Unit

							bullet_position = enter_pos

							local exit_cast = r2(enter_pos, penetration_remaining*vel_unit, instance)

							if not exit_cast then -- too thick
								break
							end

							local penetrated = vel_unit:Dot(exit_cast.Position - enter_pos)
							if penetrated > penetration_remaining then
								break
							end
							penetration_remaining -= penetrated
							if penetration_remaining <= 0 then
								break
							end

							local scaled_dt = velocity:Dot(enter_pos - bullet_position) / velocity:Dot(velocity) * dt
							bullet_position = enter_pos + 0.01 * (bullet_position - enter_pos).unit
							bullet_velocity += dt*acceleration
							simulation_elapsed += scaled_dt

							table.insert(ignore_list, instance)
						end
					end

					local onScreen = mathematics.worldToViewportPoint(bullet_position)
					screenPos = newVec2(math.floor(onScreen.x), math.floor(onScreen.y))
				end
			end

			for i, v in next, misc.laserPointer.DrawingObjects.objects do
				v.Visible = ui.flags.misc_customcrosshair.value
				v.Color = ui.flags.misc_customcrosshaircolor.color
				v.Thickness = ui.flags.misc_customcrosshairth.value
				misc.laserPointer.DrawingObjects.outlines[i].Visible = v.Visible and ui.flags.misc_customcrosshairoutline.value or false
				misc.laserPointer.DrawingObjects.outlines[i].Thickness = v.Thickness + 2
			end

			local width = ui.flags.misc_customcrosshairw.value
			local length = ui.flags.misc_customcrosshairl.value
			local widthgap = ui.flags.misc_customcrosshairg.value
			local lengthgap = ui.flags.misc_customcrosshairf.value

			local rotation = ui.flags.misc_laserpointerrotation.value
			local rotationspeed = ui.flags.misc_laserpointerrotationspeed.value

			misc.laserPointer.currentaddedrotation = (rotationspeed ~= 0) and misc.laserPointer.currentaddedrotation + (rotationspeed * deltaTime) or 0
			misc.laserPointer.currentrotation = toRad * (rotation + misc.laserPointer.currentaddedrotation)
			-- LOOK AT IT
			-- THIS SHIT FUCKS MY GAME IF I ENABLE IT
			-- pls fix <3
			-- 1 nn cheat leake
			-- (fine tranny)
			-- >.<
			-- this is wrong btw
			local cx, sy = math.sin(misc.laserPointer.currentrotation), math.cos(misc.laserPointer.currentrotation)
			local from = (newVec2(cx, sy) * newVec2(widthgap, widthgap))
			local to = from + (newVec2(cx, sy) * newVec2(width, width))
			local outfrom = (newVec2(cx, sy) * newVec2(widthgap - 1, widthgap - 1))
			local outto = outfrom + (newVec2(cx, sy) * newVec2(width + 2, width + 2))

			local cx2, sy2 = math.sin(misc.laserPointer.currentrotation + pi/2), math.cos(misc.laserPointer.currentrotation + pi/2)
			local from2 = (newVec2(cx2, sy2) * newVec2(lengthgap, lengthgap))
			local to2 = from2 + (newVec2(cx2, sy2) * newVec2(length, length))
			local outfrom2 = (newVec2(cx2, sy2) * newVec2(lengthgap - 1, lengthgap - 1))
			local outto2 = outfrom2 + (newVec2(cx2, sy2) * newVec2(length + 2, length + 2))

			local a, a1 = misc.laserPointer.DrawingObjects.objects[1], misc.laserPointer.DrawingObjects.outlines[1]
			a.From = newVec2(screenPos.x - from.x, screenPos.y - from.y)
			a.To = newVec2(screenPos.x - to.x, screenPos.y - to.y)
			a1.From = newVec2(screenPos.x - outfrom.x, screenPos.y - outfrom.y)
			a1.To = newVec2(screenPos.x - outto.x, screenPos.y - outto.y)

			local b, b1 = misc.laserPointer.DrawingObjects.objects[2], misc.laserPointer.DrawingObjects.outlines[2]
			b.From = newVec2(screenPos.x + from.x, screenPos.y + from.y)
			b.To = newVec2(screenPos.x + to.x, screenPos.y + to.y)
			b1.From = newVec2(screenPos.x + outfrom.x, screenPos.y + outfrom.y)
			b1.To = newVec2(screenPos.x + outto.x, screenPos.y + outto.y)

			local c, c1 = misc.laserPointer.DrawingObjects.objects[3], misc.laserPointer.DrawingObjects.outlines[3]
			c.From = newVec2(screenPos.x - from2.x, screenPos.y - from2.y)
			c.To = newVec2(screenPos.x - to2.x, screenPos.y - to2.y)
			c1.From = newVec2(screenPos.x - outfrom2.x, screenPos.y - outfrom2.y)
			c1.To = newVec2(screenPos.x - outto2.x, screenPos.y - outto2.y)

			local d, d1 = misc.laserPointer.DrawingObjects.objects[4], misc.laserPointer.DrawingObjects.outlines[4]
			d.From = newVec2(screenPos.x + from2.x, screenPos.y + from2.y)
			d.To = newVec2(screenPos.x + to2.x, screenPos.y + to2.y)
			d1.From = newVec2(screenPos.x + outfrom2.x, screenPos.y + outfrom2.y)
			d1.To = newVec2(screenPos.x + outto2.x, screenPos.y + outto2.y)
		end
		misc.laserPointer.renderLoop = runService.Stepped:Connect(misc.laserPointer.render)
	end

	-- stupid !
	-- i would do this in a newbullets hook right before it becuz this will fuck the bullethit tick but they dont detect that so care hooker
	misc.firearmObjectFireRoundHook = hooks.trampoline(pfModules.FirearmObject, "fireRound", function(self, ...)
		local before = self._nextShot
		misc.firearmObjectFireRoundHook.old(self, ...)
		local after = self._nextShot

		local delta = after - before
        if ui.flags.misc_gunmods.value and ui.flags.misc_fireratescale.value ~= 100 and delta > 0 and not rage.fakePosition.working then
            local oldDelta = delta
			delta = delta / (ui.flags.misc_fireratescale.value / 100)
			local tickbaseshift = (oldDelta - delta)
			tickbase:shift(tickbaseshift)
        end
		self._nextShot = before + delta
	end)

	misc.jumpHook = hooks.trampoline(pfModules.CharacterObject, "jump", function(self, ...)
		local args = {...}
		if ui.flags.misc_superjump.value then
			args[1] = args[1] * (ui.flags.misc_superjumpstrength.value / 100)
		end
		return misc.jumpHook.old(self, unpack(args))
	end)

	misc.autoVote = function(player, statusTable, options)
		local voteOption = "neutral"
		local playerInVk

		for i, v in next, players:GetPlayers() do
			if v.Name == player then
				playerInVk = v
			end
		end

		if playerInVk and statusTable and statusTable[playerInVk.UserId] then
			if statusTable[playerInVk.UserId].priority == true then
				voteOption = "priority"
			elseif statusTable[playerInVk.UserId].friendly == true then
				voteOption = "friendly"
			end
		end

		local voteType
		local voteSelection = options[voteOption]
		if voteSelection then
			for i, v in next, voteSelection do
				if v == true then
					voteType = i
				end
			end
		end

		if playerInVk == localPlayer then
			voteType = "no"
		end

		if voteType and voteType ~= "none" then
			coroutine.wrap(function()
				task.wait()
				pfModules.VoteKickInterface.vote(voteType)
			end)()
		end
	end
	
	do
		local lastDeployAttempt = tick()
		misc.autodeploy = runService.Stepped:Connect(function(upTime, deltaTime)
			local charObject = pfModules.CharacterInterface.getCharacterObject()
			if not charObject and ui.flags.misc_autodeploy.value then
				if tick() - lastDeployAttempt > 5 then
					pfModules.NetworkClient:send("spawn")
					lastDeployAttempt = tick()
				end
			else
				lastDeployAttempt = 0
			end
		end)
		networking.addHook("spawn", 0, function() 
			if tick() - lastDeployAttempt < 5 or pfModules.CharacterInterface.getCharacterObject() then 
				return true 
			end
			lastDeployAttempt = tick() 
		end)
	end

	networking.addListener("startvotekick", 0, function(args)
		misc.autoVote(args[1], ui.playerListStatus, {
			neutral = ui.flags.misc_voteneutral.value,
			friendly = ui.flags.misc_votefriendly.value,
			priority = ui.flags.misc_votepriority.value
		})
	end)
end

-- gun handler (thank u gaslighter.)
do
	-- Local varz
	local binds = {}

	-- PURPOSE: Filler for when user (idiot) doesn't provide a mapping function
	function gunHandler.defaultMap(...)
		return ...
	end

	-- PURPOSE: Get list of keys to modify stats from
	function gunHandler.keysFrom(data)
		return typeof(data) == "string" and {data}
			or typeof(data) == "table" and #data > 0 and data
			or {}
	end

	-- PURPOSE: Create a bind to handle gun stat requests
	function gunHandler.createBind()
		local bind = {}
		local inner = {
			_onlyWhen = function() return true end;

			_mappings = {};
			_filterMaps = {};
		}

		function bind.map(keys, mapFn)
			table.insert(inner._mappings, {
				_keys = gunHandler.keysFrom(keys);
				_mapFn = typeof(mapFn) == "function" and mapFn or gunHandler.defaultMap;
			})
			return bind
		end

		function bind.onlyWhen(fn)
			if not (typeof(fn) == "function") then
				return
			end
			inner._onlyWhen = fn
			return bind
		end

		function bind.filterMap(keys: string, mapFn)
			table.insert(inner._filterMaps, {
				_keys = gunHandler.keysFrom(keys);
				_mapFn = typeof(mapFn) == "function" and mapFn or gunHandler.defaultMap;
			})
			return bind
		end

		function bind.activate()
			table.clear(bind)
			table.insert(binds, inner)
		end

		return bind
	end

	-- PURPOSE: No more BOILERPLATE!
	function gunHandler.mapsToFunctions(stat: string, mappings)
		local funcs = {}
		for j, k in next, mappings do
			-- Does this map relate to this stat
			if table.find(k._keys, stat) then
				-- Insert func
				table.insert(funcs, k._mapFn)
			end
		end
		return funcs
	end

	-- PURPOSE: Eliminate boilerplate while also fixing the problem of pf not just using one source for stat data
	function gunHandler.createStatHook(fnName: string)
		-- Not the best but it'll work
		local statHook; statHook = hooks.trampoline(pfModules.FirearmObject, fnName, function(weapon, stat: string)
			-- iterate through binds and update the current value
			local originalValue = statHook.old(weapon, stat)
			local currentValue = originalValue
			for i, v in next, binds do
				-- are we even going to be modifying our stats rn?
				if not v._onlyWhen() then
					continue
				end

				-- do normal mappings
				for _, func in next, gunHandler.mapsToFunctions(stat, v._mappings) do
					currentValue = func(currentValue, weapon, stat)
				end

				-- do filtered mappings
				for _, func in next, gunHandler.mapsToFunctions(stat, v._filterMaps) do
					local wishValue = func(currentValue, weapon, stat)
					currentValue = (wishValue ~= nil and typeof(wishValue) == typeof(currentValue)) and wishValue or currentValue
				end
			end

			-- Return modified value
			return currentValue
		end)
	end

	-- Hook the gun stat getterrrrr
	gunHandler.createStatHook("getWeaponStat")
	gunHandler.createStatHook("getActiveAimStat")
end

-- gun handler initialization (thank u gaslightingerrr)
do
	-- Really stylis?
	local animCache = {}
	local defaultAnim = {stdtimescale = 0, timescale = 0, resettime = 0}
	-- THE bind !
	gunHandler.createBind()
		.map("animations", function(animations)
			-- Get cached anims or modify them ourselves
			local modifiedAnims = animCache[animations]
			if not modifiedAnims then
			-- Shallow clone table and cache
			modifiedAnims = table.clone(animations)
			animCache[animations] = modifiedAnims
		end 

			-- Cache anims to our needs
			for name, data in next, modifiedAnims do
			-- No fire anim
			if name:find("onfire") then
				modifiedAnims[name] = (ui.flags.misc_nofireanim.value and defaultAnim or animations[name])
			end

			-- Instant Reload
			if name:find("reload") then
				modifiedAnims[name] = (ui.flags.misc_instantreload.value and defaultAnim or animations[name])
			end
		end

			return modifiedAnims
		end)

		.filterMap("equipspeed", function(currentValue)
			return (ui.flags.misc_instantequip.value) and 9e9 or nil
		end)

		.filterMap("hipfirespread", function(currentValue)
			return currentValue * ui.flags.misc_recoilscale.value / 100
		end)

		.filterMap("firemodes", function() -- incorrect func name 
			return (ui.flags.misc_fullauto.value) and {true, 3, 1} or nil
		end)

		.onlyWhen(function()
			return ui.flags.misc_gunmods.value
		end)

		.activate()
end

-- shared hooks
do
	-- god
	-- i wanna choke on her cock
	-- real
	sharedHooks.firearmObjectcanFireHook = hooks.trampoline(pfModules.FirearmObject, "canFire", function(self, ...)
		if ui.uiopen then
			return false
		end
		return sharedHooks.firearmObjectcanFireHook.old(self, ...)
	end)
	sharedHooks.firearmObjectimpulseSpringsHook = hooks.trampoline(pfModules.FirearmObject, "impulseSprings", function(self, ...)
		if not self.recoilHook then
			do
				local old = self._translationSprings.applyImpulse
				self._translationSprings.applyImpulse = function(self, ...)
					local args = {...}
					if ui.flags.misc_gunmods.value then
						args[2] = args[2] * ui.flags.misc_recoilscale.value / 100
					end
					return old(self, unpack(args))
				end
			end
			do
				local old = self._rotationSprings.applyImpulse
				self._rotationSprings.applyImpulse = function(self, ...)
					local args = {...}
					if ui.flags.misc_gunmods.value then
						args[2] = args[2] * ui.flags.misc_recoilscale.value / 100
					end
					return old(self, unpack(args))
				end
			end
			self.recoilHook = true
		end

		sharedHooks.firearmObjectimpulseSpringsHook.old(self, ...)
	end)
	sharedHooks.meleeObjectcanMeleeHook = hooks.trampoline(pfModules.MeleeObject, "canMelee", function(self, ...)
		if ui.uiopen then
			return false
		end
		return sharedHooks.meleeObjectcanMeleeHook.old(self, ...)
	end)

	sharedHooks.characterObjectStepHook = hooks.trampoline(pfModules.CharacterObject, "step", function(self, ...)
		sharedHooks.characterObjectStepHook.old(self, ...)
		if ui.flags.misc_gunmods.value and ui.flags.misc_nosway.value then
			self._swingspring.t = emptyVec3
			self._swingspring.s = 9999999999999999
			self._swingspring.d = 0.000001
		else
			self._swingspring.s = 10
			self._swingspring.d = 0.75
		end
	end)
	networking.addHook("bullethit", 100, function(args)
		if ui.flags.misc_supressonly.value then
			return true
		end
	end)
end

-- script lib
-- i see u reading thru this <3
do
	local scriptLib = {   
		modules = {
			game = pfModules,
			cheat = {
				playerInfo = playerInfo,
				currentInfo = currentInfo,
				hooks = hooks,
				tickbase = tickbase,
				networking = networking,
				heap = heap,
				pathfinding = pathfinding,
				mathematics = mathematics,
				rayCaster = rayCaster,
				spring = spring,
				signal = signal,
				gunHandler = gunHandler,
				encryption = encryption
			}
		},
		cheatFunctions = {
			legit = legit,
			rage = rage,
			esp = esp,
			visuals = visuals,
			misc = misc,
			sharedHooks = sharedHooks
		},
		menu = {
			keybindMenu = keybindsui,
			mainMenu = ui,
			utilities = utilities,
			Drawings = Drawings
		},  
		ui = uilibrary,
	}

	getgenv().vaderhaxx = scriptLib
end

local load_time = tick() - startLoad
do
	local allrender = {}
	local game = game
	local infopos = 400
	local stats = game:GetService("Stats")
	local DrawingModule = {}

	local function average(t)
		local sum = 0
		for _, v in pairs(t) do
			sum = sum + v
		end
		return sum / #t
	end

	local function round(num, numDecimalPlaces)
		local mult = 10 ^ (numDecimalPlaces or 0)
		return math.floor(num * mult + 0.5) / mult
	end

	DrawingModule.Draw = {
		OutlinedRect = function(visible, pos_x, pos_y, width, height, clr, tablename)
			local DrawingObject = Drawing.new("Square")
			DrawingObject.Visible = visible
			DrawingObject.Position = Vector2.new(pos_x, pos_y)
			DrawingObject.Size = Vector2.new(width, height)
			DrawingObject.Color = Color3.fromRGB(clr[1], clr[2], clr[3])
			DrawingObject.Filled = false
			DrawingObject.Thickness = 0
			DrawingObject.Transparency = clr[4] / 255
			table.insert(tablename, DrawingObject)
		end,

		FilledRect = function(visible, pos_x, pos_y, width, height, clr, tablename)
			local DrawingObject = Drawing.new("Square")
			DrawingObject.Visible = visible
			DrawingObject.Position = Vector2.new(pos_x, pos_y)
			DrawingObject.Size = Vector2.new(width, height)
			DrawingObject.Color = Color3.fromRGB(clr[1], clr[2], clr[3])
			DrawingObject.Filled = true
			DrawingObject.Thickness = 0
			DrawingObject.Transparency = clr[4] / 255
			table.insert(tablename, DrawingObject)
		end,

		Line = function(visible, thickness, start_x, start_y, end_x, end_y, clr, tablename)
			local DrawingObject = Drawing.new("Line")
			DrawingObject.Visible = visible
			DrawingObject.Thickness = thickness
			DrawingObject.From = Vector2.new(start_x, start_y)
			DrawingObject.To = Vector2.new(end_x, end_y)
			DrawingObject.Color = Color3.fromRGB(clr[1], clr[2], clr[3])
			DrawingObject.Transparency = clr[4] / 255
			table.insert(tablename, DrawingObject)
		end,

		OutlinedText = function(text, font, visible, pos_x, pos_y, size, centered, clr, clr2, tablename)
			local DrawingObject = Drawing.new("Text")
			DrawingObject.Text = text
			DrawingObject.Visible = visible
			DrawingObject.Position = Vector2.new(pos_x, pos_y)
			DrawingObject.Size = size
			DrawingObject.Centered = centered
			DrawingObject.Color = Color3.fromRGB(clr[1], clr[2], clr[3])
			DrawingObject.Transparency = clr[4] / 255
			DrawingObject.Outline = true
			DrawingObject.OutlineColor = Color3.fromRGB(clr2[1], clr2[2], clr2[3])
			DrawingObject.Font = font
			if not table.find(allrender, tablename) then
				table.insert(allrender, tablename)
			end
			if tablename then
				table.insert(tablename, DrawingObject)
			end
			return DrawingObject
		end
	}

	-- Other functions...
	do
		local function drawGraphLines(graph, direction, interval)
			DrawingModule.Draw.Line(
				false,
				3,
				graph.pos.x,
				graph.pos.y - 1,
				graph.pos.x,
				graph.pos.y + 82,
				{ 20, 20, 20, 225 },
				graph.sides
			)

			DrawingModule.Draw.Line(
				false,
				3,
				graph.pos.x,
				graph.pos.y + 80,
				graph.pos.x + 221,
				graph.pos.y + 80,
				{ 20, 20, 20, 225 },
				graph.sides
			)

			DrawingModule.Draw.Line(
				false,
				3,
				graph.pos.x,
				graph.pos.y,
				graph.pos.x - 6,
				graph.pos.y,
				{ 20, 20, 20, 225 },
				graph.sides
			)

			DrawingModule.Draw.Line(
				false,
				1,
				graph.pos.x,
				graph.pos.y,
				graph.pos.x,
				graph.pos.y + 80,
				{ 255, 255, 255, 225 },
				graph.sides
			)

			DrawingModule.Draw.Line(
				false,
				1,
				graph.pos.x,
				graph.pos.y + 80,
				graph.pos.x + 220,
				graph.pos.y + 80,
				{ 255, 255, 255, 225 },
				graph.sides
			)

			DrawingModule.Draw.Line(
				false,
				1,
				graph.pos.x,
				graph.pos.y,
				graph.pos.x - 5,
				graph.pos.y,
				{ 255, 255, 255, 225 },
				graph.sides
			)

			for i = 1, 20 do
				DrawingModule.Draw.Line(false, 1, 10, 10, 10, 10, { 255, 255, 255, 225 }, graph.graph)
			end

			DrawingModule.Draw.Line(false, 1, 10, 10, 10, 10, { 68, 255, 0, 255 }, graph.graph)
			DrawingModule.Draw.OutlinedText("avg: " .. interval, 2, false, 20, 20, 13, false, { 68, 255, 0, 255 }, { 10, 10, 10 }, graph.graph)
		end

		local function drawGraphElements(graph, direction, interval)
			DrawingModule.Draw.OutlinedText(
				direction .. " kbps: " .. interval,
				2,
				false,
				graph.pos.x - 1,
				graph.pos.y - 15,
				13,
				false,
				{ 255, 255, 255, 255 },
				{ 10, 10, 10 },
				graph.sides
			)

			DrawingModule.Draw.OutlinedText(
				tostring(interval),
				2,
				false,
				graph.pos.x - 21,
				graph.pos.y - 7,
				13,
				false,
				{ 255, 255, 255, 255 },
				{ 10, 10, 10 },
				graph.sides
			)

			DrawingModule.Draw.FilledRect(
				false,
				graph.pos.x - 1,
				graph.pos.y - 1,
				222,
				82,
				{ 10, 10, 10, 50 },
				graph.sides
			)

			drawGraphLines(graph, direction, interval)
		end
		local avgfps = 100

		local function updateFPS(dt, graphs)
			local fps = 1 / dt
			avgfps = (fps + avgfps * 49) / 50
			local CurrentFPS = math.floor(avgfps)

			local avg_color = ui.accent or DrawingModule.RGB(59, 214, 28)
			graphs.incoming.graph[21].Color = avg_color
			graphs.incoming.graph[22].Color = avg_color
			graphs.outgoing.graph[21].Color = avg_color
			graphs.outgoing.graph[22].Color = avg_color
		end

		local function updateNetworkData(incoming, outgoing)
			table.remove(incoming, 1)
			table.insert(incoming, stats.DataReceiveKbps)

			table.remove(outgoing, 1)
			table.insert(outgoing, stats.DataSendKbps)
		end

		local function drawGraph(graph, data, direction, maxNum)
			-- Drawing graph logic...
			local biggestnum = maxNum

			for i = 1, 21 do
				if math.ceil(data[i]) > biggestnum - maxNum / 2 then
					biggestnum = (math.ceil(data[i] / (maxNum / 2)) + 1) * (maxNum / 2)
				end
			end

			local numstr = tostring(biggestnum)
			graph.sides[2].Text = numstr
			graph.sides[2].Position = Vector2.new(graph.pos.x - ((#numstr + 1) * 7), graph.pos.y - 7)

			for i = 1, 20 do
				local line = graph.graph[i]

				line.From = Vector2.new(
					((i - 1) * 11) + graph.pos.x,
					graph.pos.y + 80 - math.floor(data[i] / biggestnum * 80)
				)

				line.To = Vector2.new(
					(i * 11) + graph.pos.x,
					graph.pos.y + 80 - math.floor(data[i + 1] / biggestnum * 80)
				)
			end

			local avgbar_h = average(data)

			graph.graph[21].From = Vector2.new(
				graph.pos.x + 1,
				graph.pos.y + 80 - math.floor(avgbar_h / biggestnum * 80)
			)
			graph.graph[21].To = Vector2.new(
				graph.pos.x + 220,
				graph.pos.y + 80 - math.floor(avgbar_h / biggestnum * 80)
			)

			graph.graph[21].Thickness = 2

			graph.graph[22].Position = Vector2.new(
				graph.pos.x + 222,
				graph.pos.y + 80 - math.floor(avgbar_h / biggestnum * 80) - 8
			)
			graph.graph[22].Text = "avg: " .. tostring(round(avgbar_h, 2))

			graph.sides[1].Text = direction .. " kbps: " .. tostring(round(data[21], 2))
		end

		local function updateOtherInfo(otherGraph)
			local drawnobjects = #Drawings

			for k, v in pairs(allrender) do
				drawnobjects = drawnobjects + #v
			end

			otherGraph[1].Text = string.format(
				"initiation time: %d ms\ndrawn objects: %d\ntick: %d\nfps: %d\nlatency: %d",
				load_time * 1000,
				drawnobjects,
				tick(),
				avgfps,
				game:GetService("Stats").PerformanceStats.Ping:GetValue()
			)
		end

		local function toggleVisibility(graphs, isVisible)
			for k, v in pairs(graphs) do
				if k ~= "other" then
					for k1, v1 in pairs(v) do
						if k1 ~= "pos" then
							for k2, v2 in pairs(v1) do
								v2.Visible = isVisible
							end
						end
					end
				end
			end

			for k, v in pairs(graphs.other) do
				v.Visible = isVisible
			end
		end

		-- Initialize network data
		local networkin = {
			incoming = {},
			outgoing = {},
		}

		for i = 1, 21 do
			networkin.incoming[i] = 20
			networkin.outgoing[i] = 2
		end

		local lasttick = tick()

		-- Initialize graph positions and structures
		local graphs = {
			incoming = {
				pos = { x = 35, y = infopos },
				sides = {},
				graph = {},
			},
			outgoing = {
				pos = { x = 35, y = infopos + 97 },
				sides = {},
				graph = {},
			},
			other = {},
		}

		DrawingModule.Draw.OutlinedText(
			"loading...",
			2,
			false,
			35,
			infopos + 180,
			13,
			false,
			{ 255, 255, 255, 255 },
			{ 10, 10, 10 },
			graphs.other
		)

		-- Draw incoming graph elements
		drawGraphElements(graphs.incoming, "incoming", 20)

		-- Draw outgoing graph elements
		drawGraphElements(graphs.outgoing, "outgoing", 5)

		-- Heartbeat function
		game:GetService("RunService").Heartbeat:Connect(function(dt)
			updateFPS(dt, graphs)

			if tick() - lasttick > 0.25 then
				updateNetworkData(networkin.incoming, networkin.outgoing)
				drawGraph(graphs.incoming, networkin.incoming, "incoming", 80)
				drawGraph(graphs.outgoing, networkin.outgoing, "outgoing", 10)
				updateOtherInfo(graphs.other)
				lasttick = tick()
			end
		end)

		local stat_menu = false

		-- Toggle stat menu with the Home key
		game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
			if input.KeyCode == Enum.KeyCode.Home then
				stat_menu = not stat_menu
				toggleVisibility(graphs, stat_menu)
			end
		end)
	end
end

-- post cheat loading ui setup
do
	ui.updateaccent()

	local userinputservice          = game:GetService("UserInputService")
	local runservice                = game:GetService("RunService")

	ui:closeui()

	ui.objects.backborder.position = ui.objects.backborder.position + UDim2.new(0, 1, 0, 1)
	ui.objects.backborder.position = ui.objects.backborder.position - UDim2.new(0, 1, 0, 1)
	ui.objects.backborder.visible = true
	-- stupid fix for some bullshit bug that doesnt even make sense?????????????????

	userinputservice.InputBegan:Connect(function(Input, gameProcessedEvent)
		if Input.UserInputType == Enum.UserInputType.Keyboard then
			if Input.KeyCode == Enum.KeyCode.Insert or Input.KeyCode == Enum.KeyCode.Delete or Input.KeyCode == Enum.KeyCode.Backquote then
				if ui.uiopen then
					ui:closeui()
				else
					ui:openui()
				end
			end
		end
	end)

	-- Mouse Fix
	local cursor = Drawing.new("Triangle")
	Drawings[1 + #Drawings] = cursor
	cursor.Filled = true
	cursor.Color = Color3.fromRGB(255, 255, 255)
	cursor.ZIndex = ui.basezindex + 1000

	-- Set the increase in area (25% larger)
	local areaIncreasePercentage = 0.25

	userinputservice.InputChanged:Connect(function(input, processed)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			local xy = userinputservice:GetMouseLocation()

			-- Set main cursor points
			cursor.PointA = Vector2.new(xy.x + 1, xy.y)
			cursor.PointB = Vector2.new(xy.x + 1, xy.y) + Vector2.new(0, 12)
			cursor.PointC = Vector2.new(xy.x + 1, xy.y) + Vector2.new(8, 8)
		end
	end)

	ui.flags.keybindoffsetx.changed:Connect(function()
		keybindsui.objects.backborder.position = UDim2.new(0, ui.flags.keybindoffsetx.value, 0, ui.flags.keybindoffsety.value)
	end)
	ui.flags.keybindoffsety.changed:Connect(function()
		keybindsui.objects.backborder.position = UDim2.new(0, ui.flags.keybindoffsetx.value, 0, ui.flags.keybindoffsety.value)
	end)

	runservice.Heartbeat:Connect(function()
		local behav = Enum.MouseBehavior.LockCenter
		local charObject = pfModules and pfModules.CharacterInterface and pfModules.CharacterInterface.getCharacterObject()
		if ui.uiopen or not charObject then
			behav = Enum.MouseBehavior.Default
		end
		userinputservice.MouseBehavior = behav
		cursor.Visible = ui.uiopen
		cursor.Color = ui.accent
	end)
end

getgenv().vaderhaxx.loaded = true
ui.startWatermark = true
for i = 1, 3 do
	task.wait()
end

ui:createnotification({text = "loaded in " .. tostring(mathematics.truncateNumber(load_time, 1)) .. "s !" , lifetime = 5, priority = 1})
ui:createnotification({text = "press insert, delete or backquote to open the menu!", lifetime = 5, priority = 1})
ui:openui()
]=]) -- replace with code below if u actually wanna run the cheat or smth (and u have synapse) xD
