local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local PREFIX = "!"

-- Add trusted Roblox user IDs here. Only these players can run the commands.
local ADMIN_USER_IDS = {
	-- 123456789,
}

-- Default sky image. You can also set it per command with !sky <assetId>.
-- Use the numeric ID of an image you own, then paste it here.
local SKYBOX_IMAGE_ID = ""

local TANK_TAG = "ExplodableTank"

local adminIds = {}
for _, userId in ipairs(ADMIN_USER_IDS) do
	adminIds[userId] = true
end

local function isAdmin(player)
	return adminIds[player.UserId] == true
end

local function getRoot(player)
	local character = player.Character
	if not character then
		return nil
	end
	return character:FindFirstChild("HumanoidRootPart")
end

local function pullAll(admin)
	local adminRoot = getRoot(admin)
	if not adminRoot then
		return
	end

	local index = 0
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= admin then
			local root = getRoot(player)
			if root then
				index += 1
				local angle = index * math.rad(45)
				root.CFrame = adminRoot.CFrame * CFrame.new(math.cos(angle) * 5, 0, math.sin(angle) * 5)
			end
		end
	end
end

local function getTankPosition(tank)
	if tank:IsA("BasePart") then
		return tank.Position
	end
	if tank:IsA("Model") then
		return tank:GetPivot().Position
	end
	local basePart = tank:FindFirstChildWhichIsA("BasePart")
	if basePart then
		return basePart.Position
	end
	return nil
end

local function explodeTanks()
	local tanks = CollectionService:GetTagged(TANK_TAG)
	for _, tank in ipairs(tanks) do
		if tank:IsDescendantOf(Workspace) then
			local position = getTankPosition(tank)
			if position then
				local explosion = Instance.new("Explosion")
				explosion.Position = position
				explosion.BlastRadius = 12
				explosion.BlastPressure = 0
				explosion.DestroyJointRadiusPercent = 0
				explosion.Parent = Workspace
			end
		end
	end
end

local function applyOriginalTransparency(instance, hidden)
	if hidden then
		if instance:GetAttribute("OriginalTransparency") == nil then
			instance:SetAttribute("OriginalTransparency", instance.Transparency)
		end
		instance.Transparency = 1
	else
		local original = instance:GetAttribute("OriginalTransparency")
		if original ~= nil then
			instance.Transparency = original
			instance:SetAttribute("OriginalTransparency", nil)
		end
	end
end

local function setHidden(player, hidden)
	local character = player.Character
	if not character then
		return
	end

	for _, descendant in ipairs(character:GetDescendants()) do
		if descendant:IsA("BasePart") or descendant:IsA("Decal") or descendant:IsA("Texture") then
			applyOriginalTransparency(descendant, hidden)
		end
	end
end

local function normalizeImageId(imageId)
	if imageId == "" then
		return nil
	end
	if imageId:match("^rbxassetid://%d+$") then
		return imageId
	end
	local numericId = imageId:match("^%d+$")
	if numericId then
		return "rbxassetid://" .. numericId
	end
	return nil
end

local function setSky(imageId)
	local normalized = normalizeImageId(imageId)
	if not normalized then
		return
	end

	local sky = Lighting:FindFirstChildOfClass("Sky")
	if not sky then
		sky = Instance.new("Sky")
		sky.Parent = Lighting
	end

	sky.SkyboxBk = normalized
	sky.SkyboxDn = normalized
	sky.SkyboxFt = normalized
	sky.SkyboxLf = normalized
	sky.SkyboxRt = normalized
	sky.SkyboxUp = normalized
end

local function handleCommand(player, message)
	if not isAdmin(player) then
		return
	end
	if message:sub(1, #PREFIX) ~= PREFIX then
		return
	end

	local commandLine = message:sub(#PREFIX + 1)
	local command, argument = commandLine:match("^(%S+)%s*(.-)%s*$")
	if not command then
		return
	end

	command = command:lower()

	if command == "pullall" then
		pullAll(player)
	elseif command == "explode" then
		explodeTanks()
	elseif command == "hide" then
		setHidden(player, true)
	elseif command == "show" then
		setHidden(player, false)
	elseif command == "sky" then
		if argument ~= "" then
			setSky(argument)
		else
			setSky(SKYBOX_IMAGE_ID)
		end
	end
end

local function connectPlayer(player)
	player.Chatted:Connect(function(message)
		handleCommand(player, message)
	end)
end

Players.PlayerAdded:Connect(connectPlayer)
for _, player in ipairs(Players:GetPlayers()) do
	connectPlayer(player)
end
