local startPos = Vector3.new(-4000,0,-4000)
local endPos = Vector3.new(4000,0,4000)
local rayLength = 1000
local thickness = 16
local voxelSize = 4

local function rayCast(start,finish, aimDistance, ignoreList)
	local hitPart, hitPos = game.Workspace:FindPartOnRayWithIgnoreList(Ray.new( start, (finish-start).unit * aimDistance), ignoreList, false)
	if hitPart and hitPart.ClassName ~= "Terrain" then
		table.insert(ignoreList, hitPart)
		return rayCast(start,finish, aimDistance, ignoreList)
	end
	return hitPos
end

for x = startPos.X, endPos.X, voxelSize do
	for z = startPos.Z, endPos.Z, voxelSize do
		local topRayPos = Vector3.new(x, rayLength, z)
		local bottomRayPos = Vector3.new(x, -rayLength, z)
		
		local topHitPos = rayCast(topRayPos, bottomRayPos, rayLength * 2, {})
		
		local bottomHitPos = rayCast(bottomRayPos, topRayPos, rayLength * 2, {})
		
		if topHitPos.Y > bottomRayPos.Y + thickness then
			for y = bottomHitPos.Y, topHitPos.Y - thickness, voxelSize do
				workspace.Terrain:FillBlock(
					CFrame.new(x, y, z), 
					Vector3.new(voxelSize + .5, voxelSize + .5, voxelSize + .5), 
					Enum.Material.Air
				)
			end
		end
	end
end
