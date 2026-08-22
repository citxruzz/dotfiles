-- remember_volume.lua

local utils = require 'mp.utils'

-- use mp.find_config_file to get a reliable path
local config_dir = mp.find_config_file("") or "."  -- fallback to current folder
local volume_file = utils.join_path(config_dir, "last_volume.txt")

-- load last volume
local function load_volume()
    local file = io.open(volume_file, "r")
    if file then
        local vol = file:read("*n")
        if vol then mp.set_property_number("volume", vol) end
        file:close()
    end
end

-- save current volume
local function save_volume()
    local vol = mp.get_property_number("volume")
    local file = io.open(volume_file, "w")
    if file then
        file:write(vol)
        file:close()
    end
end

mp.register_event("start-file", load_volume)
mp.register_event("shutdown", save_volume)
