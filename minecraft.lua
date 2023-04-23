packloaded = true
			if not game:IsLoaded() then repeat task.wait() until game:IsLoaded() end

local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request or function(tab)
if tab.Method == "GET" then
	return {
		Body = game:HttpGet(tab.Url, true),
		Headers = {},
		StatusCode = 200
	}
else
	return {
		Body = "bad exploit",
		Headers = {},
		StatusCode = 404
	}
end
end

local setthreadidentity = syn and syn.set_thread_identity or set_thread_identity or setidentity
local getthreadidentity = syn and syn.get_thread_identity or get_thread_identity or getidentity
local getasset = getsynasset or getcustomasset
local cachedthings2 = {}
local cachedsizes = {}

local betterisfile = function(file)
local suc, res = pcall(function() return readfile(file) end)
return suc and res ~= nil
end

local function removeTags(str)
str = str:gsub("<br%s*/>", "\n")
return (str:gsub("<[^<>]->", ""))
end

local cachedassets = {}
local function getcustomassetfunc(path)
if not betterisfile(path) then
	task.spawn(function()
		local textlabel = Instance.new("TextLabel")
		textlabel.Size = UDim2.new(1, 0, 0, 36)
		textlabel.Text = "Downloading "..path
		textlabel.BackgroundTransparency = 1
		textlabel.TextStrokeTransparency = 0
		textlabel.TextSize = 30
		textlabel.Font = Enum.Font.SourceSans
		textlabel.TextColor3 = Color3.new(1, 1, 1)
		textlabel.Position = UDim2.new(0, 0, 0, -36)
		textlabel.Parent = game:GetService("CoreGui").RobloxGui
		repeat task.wait() until betterisfile(path)
		textlabel:Remove()
	end)
	local req = requestfunc({
		Url = "https://raw.githubusercontent.com/trollfacenan/bedwarstexture/main/"..path,
		Method = "GET"
	})
	writefile(path, req.Body)
end
if cachedassets[path] == nil then
	cachedassets[path] = getasset(path) 
end
return cachedassets[path]
end

local function cachesize(image)
if not cachedsizes[image] then
	task.spawn(function()
		local thing = Instance.new("ImageLabel")
		thing.Image = getcustomassetfunc(image)
		thing.Size = UDim2.new(1, 0, 1, 0)
		thing.ImageTransparency = 0.999
		thing.BackgroundTransparency = 1
		thing.Parent = game:GetService("CoreGui").RobloxGui
		repeat task.wait() until thing.ContentImageSize ~= Vector2.new(0, 0)
		thing:Remove()
		cachedsizes[image] = 1
		cachedsizes[image] = thing.ContentImageSize.X / 256
	end)
end
end

local function downloadassets(path2)
local json = requestfunc({
	Url = "https://api.github.com/repos/trollfacenan/bedwarstexture/contents/"..path2,
	Method = "GET"
})
local decodedjson = game:GetService("HttpService"):JSONDecode(json.Body)
for i2, v2 in pairs(decodedjson) do
	if v2["type"] == "file" then
	   getcustomassetfunc(path2.."/"..v2["name"])
	end
end
end

if isfolder("bedwarsmodels") == false then
makefolder("bedwarsmodels")
end
downloadassets("bedwarsmodels")
if isfolder("bedwarssounds") == false then
makefolder("bedwarssounds")
end
downloadassets("bedwarssounds")

local Flamework = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@flamework"].core.out).Flamework
local newupdate = game.Players.LocalPlayer.PlayerScripts.TS:FindFirstChild("ui") and true or false
repeat task.wait() until Flamework.isInitialized
local KnitClient = debug.getupvalue(require(game:GetService("Players").LocalPlayer.PlayerScripts.TS.knit).setup, 6)
local soundslist = require(game:GetService("ReplicatedStorage").TS.sound["game-sound"]).GameSound
local sounds = (newupdate and require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out).SoundManager or require(game:GetService("ReplicatedStorage").TS.sound["sound-manager"]).SoundManager)
local footstepsounds = require(game:GetService("ReplicatedStorage").TS.sound["footstep-sounds"])
local items = require(game:GetService("ReplicatedStorage").TS.item["item-meta"])
local itemtab = debug.getupvalue(items.getItemMeta, 1)
local maps = debug.getupvalue(require(game:GetService("ReplicatedStorage").TS.game.map["map-meta"]).getMapMeta, 1)
local defaultremotes = require(game:GetService("ReplicatedStorage").TS.remotes).default
local battlepassutils = require(game:GetService("ReplicatedStorage").TS["battle-pass"]["battle-pass-utils"]).BattlePassUtils
local inventoryutil = require(game:GetService("ReplicatedStorage").TS.inventory["inventory-util"]).InventoryUtil
local inventoryentity = require(game.ReplicatedStorage.TS.entity.entities["inventory-entity"]).InventoryEntity
local notification = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out.client.ui.notifications.components["notification-card"]).NotificationCard
local hotbartile = require(game:GetService("Players").LocalPlayer.PlayerScripts.TS.controllers.global.hotbar.ui["hotbar-tile"]).HotbarTile
local hotbaropeninventory = require(game:GetService("Players").LocalPlayer.PlayerScripts.TS.controllers.global.hotbar.ui["hotbar-open-inventory"]).HotbarOpenInventory
local hotbarpartysection = require(game:GetService("Players").LocalPlayer.PlayerScripts.TS.controllers.global.hotbar.ui.party["hotbar-party-section"]).HotbarPartySection
local hotbarspectatesection = require(game:GetService("Players").LocalPlayer.PlayerScripts.TS.controllers.global.hotbar.ui.spectate["hotbar-spectator-section"]).HotbarSpectatorSection
local hotbarcustommatchsection = require(game:GetService("Players").LocalPlayer.PlayerScripts.TS.controllers.global.hotbar.ui["custom-match"]["hotbar-custom-match-section"]).HotbarCustomMatchSection
local respawntimer = require(game:GetService("Players").LocalPlayer.PlayerScripts.TS.controllers.games.bedwars.respawn.ui["respawn-timer"])
local hotbarhealthbar = require(game:GetService("Players").LocalPlayer.PlayerScripts.TS.controllers.global.hotbar.ui.healthbar["hotbar-healthbar"]).HotbarHealthbar
local appcontroller = {closeApp = function() end}
if newupdate then
appcontroller = require(game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out.client.controllers["app-controller"]).AppController
end
local getQueueMeta = function() end
if newupdate then
local queuemeta = require(game:GetService("ReplicatedStorage").TS["game"]["queue-meta"]).QueueMeta
getQueueMeta = function(type)
	return queuemeta[type]
end
else
getQueueMeta = require(game:GetService("ReplicatedStorage").TS["game"]["queue-meta"]).getQueueMeta
end
local hud2
local hotbarapp = require(game:GetService("Players").LocalPlayer.PlayerScripts.TS.controllers.global.hotbar.ui["hotbar-app"]).HotbarApp
local hotbarapp2 = require(game:GetService("Players").LocalPlayer.PlayerScripts.TS.controllers.global.hotbar.ui["hotbar-app"])
local itemshopapp = require(game:GetService("Players").LocalPlayer.PlayerScripts.TS.controllers.games.bedwars.shop.ui["item-shop"]["bedwars-item-shop-app"])[(newupdate and "BedwarsItemShopAppBase" or "BedwarsItemShopApp")]
local teamshopapp = require(game:GetService("Players").LocalPlayer.PlayerScripts.TS.controllers.games.bedwars["generator-upgrade"].ui["bedwars-team-upgrade-app"]).BedwarsTeamUpgradeApp
local victorysection = require(game:GetService("Players").LocalPlayer.PlayerScripts.TS.controllers["game"].match.ui["victory-section"]).VictorySection
local battlepasssection = require(game:GetService("Players").LocalPlayer.PlayerScripts.TS.controllers.games.bedwars["battle-pass-progression"].ui["battle-pass-progession-app"]).BattlePassProgressionApp
local bedwarsshopitems = require(game:GetService("ReplicatedStorage").TS.games.bedwars.shop["bedwars-shop"]).BedwarsShop
local bedwarsbows = require(game:GetService("ReplicatedStorage").TS.games.bedwars["bedwars-bows"]).BedwarsBows
local roact = debug.getupvalue(hotbartile.render, 1)
local clientstore = (newupdate and require(game:GetService("Players").LocalPlayer.PlayerScripts.TS.ui.store).ClientStore or require(game.Players.LocalPlayer.PlayerScripts.TS.rodux.rodux).ClientStore)
local client = require(game:GetService("ReplicatedStorage").TS.remotes).default.Client
local colorutil = debug.getupvalue(hotbartile.render, 2)
local soundmanager = require(game:GetService("ReplicatedStorage").rbxts_include.node_modules["@easy-games"]["game-core"].out).SoundManager
local itemviewport = require(game:GetService("Players").LocalPlayer.PlayerScripts.TS.controllers.global.inventory.ui["item-viewport"]).ItemViewport
local empty = debug.getupvalue(hotbartile.render, 6)
local tween = debug.getupvalue(hotbartile.tweenPosition, 1)
local flashing = false
local realcode = ""
local oldrendercustommatch = hotbarcustommatchsection.render
local crosshairref = roact.createRef()
local beddestroyref = roact.createRef()
local trapref = roact.createRef()
local timerref = roact.createRef()
local startimer = false
local timernum = 0

footstepsounds["BlockFootstepSound"][4] = "WOOL"
footstepsounds["BlockFootstepSound"]["WOOL"] = 4
for i,v in pairs(itemtab) do
if tostring(i):match"wool" then
	v.footstepSound = footstepsounds["BlockFootstepSound"]["WOOL"]
end
end

for i,v in pairs(listfiles("bedwarssounds")) do
local str = tostring(tostring(v):gsub('bedwarssounds\\', ""):gsub(".mp3", ""))
local item = soundslist[str]
if item then
	soundslist[str] = getcustomassetfunc(v)
end
end
for i,v in pairs(listfiles("bedwarsmodels")) do
if lplr.Character then else repeat task.wait() until lplr.Character end
local str = tostring(tostring(v):gsub('bedwarsmodels\\', ""):gsub(".png", ""))
local item = game:GetService("ReplicatedStorage").Items:FindFirstChild(str)
local item2 = lplr.Character:FindFirstChild(str)
if item then
	if isfile("bedwarsmodels/"..str..".mesh") then
		item.Handle.MeshId = getcustomassetfunc("bedwarsmodels/"..str..".mesh")
		item.Handle.TextureID = getcustomassetfunc("bedwarsmodels/"..str..".png")
		for i2,v2 in pairs(item.Handle:GetDescendants()) do
			if v2:IsA("MeshPart") then
				v2.Transparency = 1
			end
		end
	else
		for i2,v2 in pairs(item:GetDescendants()) do
			if v2:IsA("Texture") then
				v2.Texture = getcustomassetfunc(v)
			end
		end
	end
end
if item2 then
	if isfile("bedwarsmodels/"..str..".mesh") then
		item2.Handle.MeshId = getcustomassetfunc("bedwarsmodels/"..str..".mesh")
		item2.Handle.TextureID = getcustomassetfunc("bedwarsmodels/"..str..".png")
		for i2,v2 in pairs(item.Handle:GetDescendants()) do
			if v2:IsA("MeshPart") then
				v2.Transparency = 1
			end
		end
	else
		for i2,v2 in pairs(item2:GetDescendants()) do
			if v2:IsA("Texture") then
				v2.Texture = getcustomassetfunc(v)
			end
		end
	end
end
childaddedcon = lplr.Character.ChildAdded:Connect(function(iteme)
	if item2 then
		if isfile("bedwarsmodels/"..str..".mesh") then
			if not item2:FindFirstChild("Handle") then repeat task.wait() until item2:FindFirstChild("Handle") end
			item2.Handle.MeshId = getcustomassetfunc("bedwarsmodels/"..str..".mesh")
			item2.Handle.TextureID = getcustomassetfunc("bedwarsmodels/"..str..".png")
			for i2,v2 in pairs(item2.Handle:GetDescendants()) do
				if v2:IsA("MeshPart") then
					v2.Transparency = 1
				end
			end
		else
			for i2,v2 in pairs(item2:GetDescendants()) do
				if v2:IsA("Texture") then
					v2.Texture = getcustomassetfunc(v)
				end
			end
		end
	end
end)
charaddedcon = lplr.CharacterAdded:Connect(function()
	childadded:Disconnect()
	item2 = lplr.Character:FindFirstChild(str)
	if item2 then
		if isfile("bedwarsmodels/"..str..".mesh") then
			if not item2:FindFirstChild("Handle") then repeat task.wait() until item2:FindFirstChild("Handle") end
			item2.Handle.MeshId = getcustomassetfunc("bedwarsmodels/"..str..".mesh")
			item2.Handle.TextureID = getcustomassetfunc("bedwarsmodels/"..str..".png")
			for i2,v2 in pairs(item2.Handle:GetDescendants()) do
				if v2:IsA("MeshPart") then
					v2.Transparency = 1
				end
			end
		else
			for i2,v2 in pairs(item2:GetDescendants()) do
				if v2:IsA("Texture") then
					v2.Texture = getcustomassetfunc(v)
				end
			end
		end
	end
	childaddedcon = lplr.Character.ChildAdded:Connect(function(iteme)
		if item2 then
			if isfile("bedwarsmodels/"..str..".mesh") then
				if not item2:FindFirstChild("Handle") then repeat task.wait() until item2:FindFirstChild("Handle") end
				item2.Handle.MeshId = getcustomassetfunc("bedwarsmodels/"..str..".mesh")
				item2.Handle.TextureID = getcustomassetfunc("bedwarsmodels/"..str..".png")
				for i2,v2 in pairs(item2.Handle:GetDescendants()) do
					if v2:IsA("MeshPart") then
						v2.Transparency = 1
					end
				end
			else
				for i2,v2 in pairs(item2:GetDescendants()) do
					if v2:IsA("Texture") then
						v2.Texture = getcustomassetfunc(v)
					end
				end
			end
		end
	end)
end)
end
for i,v in pairs(getgc(true)) do
if type(v) == "table" and rawget(v, "wool_blue") and type(v["wool_blue"]) == "table" then
	for i2,v2 in pairs(v) do
		if isfile("bedwarsmodels/"..i2..".png") then
			if rawget(v2, "block") and rawget(v2["block"], "greedyMesh") then
				if #v2["block"]["greedyMesh"]["textures"] > 1 and isfile("bedwarsmodels/"..i2.."_side_1.png") then
					for i3,v3 in pairs(v2["block"]["greedyMesh"]["textures"]) do
						v2["block"]["greedyMesh"]["textures"][i3] = getcustomassetfunc("bedwarsmodels/"..i2.."_side_"..i3..".png")
					end
				else
				 v2["block"]["greedyMesh"]["textures"] = {
						[1] = getcustomassetfunc("bedwarsmodels/"..i2..".png")
				 }
				end
				if isfile("bedwars/"..i2.."_image.png") then
					v2["image"] = getcustomassetfunc("bedwarsmodels/"..i2.."_image.png")
				end
			else
				v2["image"] = getcustomassetfunc("bedwarsmodels/"..i2..".png")
			end
		end
	end
end
end
for a, e in pairs(workspace.Map:GetChildren()) do
if e.Name == "Blocks" and e:IsA("Folder") or e:IsA("Model") then
	for i, v in pairs(e:GetDescendants()) do
		if isfile("bedwarsmodels/"..v.Name..".png") then
			for i2,v2 in pairs(v:GetDescendants()) do
				if v2:IsA("Texture") then
					v2.Texture = getcustomassetfunc("bedwarsmodels/"..v.Name..".png")
				end
			end
		end
	end
end
end

workspace.DescendantAdded:Connect(function(v)
for a,e in pairs(workspace.Map:GetChildren()) do
	if e.Name == "Blocks" and e:IsA("Folder") then
		if v.Parent and isfile("bedwarsmodels/"..v.Name..".png") then
			for i2,v2 in pairs(e:GetDescendants()) do
				if v2:IsA("Texture") then
					v2.Texture = getcustomassetfunc("bedwarsmodels/"..v2.Name..".png")
				end
			end
			e.DescendantAdded:connect(function(v3)
				if v3:IsA("Texture") then
					v3.Texture = getcustomassetfunc("bedwarsmodels/"..v3.Name..".png")
				end
			end)
		end
		if v:IsA("Accessory") and isfile("bedwarsmodels/"..v.Name..".mesh") then
			task.spawn(function()
				local handle = v:WaitForChild("Handle")
				handle.MeshId = getcustomassetfunc("bedwarsmodels/"..v.Name..".mesh")
				handle.TextureID = getcustomassetfunc("bedwarsmodels/"..v.Name..".png")
				for i2,v2 in pairs(handle:GetDescendants()) do
					if v2:IsA("MeshPart") then
						v2.Transparency = 1
					end
				end
			end)
		end
	end
end
end)
		else
			createwarning("Attention!", "Disabled Next Game To Disable!", 10)
		end
