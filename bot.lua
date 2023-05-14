-- Global variables
local target = nil
local cooldowns = {0, 0, 0}
-- local ticks_remaining_move = 0
-- local bullets = {}
local dirs = {{-1,-1},{-1,1},{1,-1},{1,1}}
local i = 1
local bullet_found = false
local in_zone_center = false

local x_dir = 1
local y_dir = 1


local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

-- Initialize bot
function bot_init(me)

end

-- Main bot function
function bot_main(me)

	--- MOVEMENT ----
	local me_pos = me:pos()
	
	for _, player in ipairs(me:visible()) do
		if player:type() == "small_proj" and vec.distance(me_pos, player:pos()) <= 7 then
			bullet_found = true						
			i = i + 1
			break	
		end					
	end
	
	
	if me_pos:x() == 0 then
	    x_dir = -x_dir
	end  
	
	if me_pos:x() == 500 then
	    x_dir = -x_dir
	end 
	
	if me_pos:y() == 500 then
	    y_dir = -y_dir
	end  
	
	if me_pos:y() == 0 then
	    y_dir = -y_dir
	end  
	
	me:move(vec.new(x_dir*1,y_dir*1))
	
	local codx = me:cod():x()
	local cody = me:cod():y()
	
	-- prioritize evading bullets, then moving to zone and finally moving normally
	if bullet_found then
		me:move(vec.new(x_dir*dirs[i%4+1][1],y_dir*dirs[i%4+1][2]))
		bullet_found = false
	elseif codx ~= -1 then
		if me_pos:x() == codx and me_pos:y() == cody then
			me:move(vec.new(0,1))
			-- moving_from_zone = true
		else
			me:move( vec.new( me:cod():x(),me:cod():y() ):sub(me:pos()) )
			-- moving_from_zone = false
		end
	else
		me:move(vec.new(x_dir*dirs[i%4+1][1],y_dir*dirs[i%4+1][2]))
	end

	
	--- SHOOTING ---
	
	-- Find the closest visible enemy
	local closest_enemy = nil
	local min_distance = math.huge
	for _, player in ipairs(me:visible()) do
		local dist = vec.distance(me_pos, player:pos())
		if dist < min_distance then
			min_distance = dist
			closest_enemy = player
		end
	end
	-- Set target to closest visible enemy
	local target = closest_enemy
	if target then 
		local direction = target:pos():sub(me_pos)
	end

	-- If target is within melee range and melee attack is not on cooldown, use melee attack
	if min_distance <= 2 and me:cooldown(2) == 0 then
		me:cast(2, direction)
		-- If target is not within melee range and projectile is not on cooldown, use projectile
		elseif me:cooldown(0) == 0 then
		me:cast(0, direction)
		-- Dash whenever possible
		elseif me:cooldown(1) == 0 then
		me:cast(1,direction)
	end	

end
