local mp = require("mp")
local fast = false
mp.msg.info("hold.lua loaded")

function toggle_speed()
	mp.msg.info("toggle_speed() called")
	if fast then
		mp.set_property_number("speed", 1.0)
		mp.osd_message("Speed: 1x")
		fast = false
	else
		mp.set_property_number("speed", 2.0)
		mp.osd_message("Speed: 2x")
		fast = true
	end
end

mp.add_key_binding("g", "toggle_speed", toggle_speed)

