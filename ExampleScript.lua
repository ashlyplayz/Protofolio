--// These scripts won't work as they will be needing alot of instances


--// Services
local MarketplaceService = game:GetService("MarketplaceService")
local player = game.Players.LocalPlayer

--// UI
local Main = script.Parent

--// UI Buttons
local Bottom = script.Parent.BottomFrame
local Settings = Bottom.Settings
local Store = Bottom.Store

--// Other UI Frames
local SettingsFrame = Main.Settings
local Donations = Main.DonationHub
local Tween = game:GetService('TweenService')

--// Workspace GridStructure
local GridPart = workspace.GridTexture.Part


--// Add defined product ids.
local DonationProducts = {
	["25"] = 1;
}

--// Prompt to product
local function promptPurchase(productId)
	MarketplaceService:PromptProductPurchase(player, productId)
end

--// Local Bool Values
local SettingsToggle = true
local StoreToggle = true

--// On Mouse1 Connections
Settings.MouseButton1Down:Connect(function()
	--Main.Settings.Visible = not Main.Settings.Visible
		--// Making Bool = Not Bool
	SettingsToggle = not SettingsToggle
	if not SettingsToggle then
			--// Basically Animations
		if not StoreToggle then
			StoreToggle = true
				--// Tween
			Tween:Create(Donations, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = UDim2.new(2.1, 0, 0.5, 0)}):Play()
		end
		SettingsFrame.Position = UDim2.new(-1.5, 0, 0.5, 0)
		Tween:Create(SettingsFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
		wait(0.2)
	else
			--// Tween
		Tween:Create(SettingsFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = UDim2.new(2.1, 0, 0.5, 0)}):Play()
	end
end)

Store.MouseButton1Down:Connect(function()
	--Main.DonationHub.Visible = not Main.DonationHub.Visible
	StoreToggle = not StoreToggle
	if not StoreToggle then
			--// Basically Animations!
		if not SettingsToggle then
			SettingsToggle = true
				--// Tween
			Tween:Create(SettingsFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = UDim2.new(2.1, 0, 0.5, 0)}):Play()
		end
		Donations.Position = UDim2.new(-1.5, 0, 0.5, 0)
			--// Tween
		Tween:Create(Donations, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
		wait(0.2)
	else
			--// Tween
		Tween:Create(Donations, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = UDim2.new(2.1, 0, 0.5, 0)}):Play()
	end
end)

--// Tween & Button1
SettingsFrame.Background1.TextButton.MouseButton1Down:Connect(function()
	Tween:Create(SettingsFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = UDim2.new(2.1, 0, 0.5, 0)}):Play()
	SettingsToggle = true
end)

Donations.Background1.TextButton.MouseButton1Down:Connect(function()
	Tween:Create(Donations, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = UDim2.new(2.1, 0, 0.5, 0)}):Play()
	StoreToggle = true
end)

local Gridtoggle = true
--// Tween & Button1
SettingsFrame.Background2.ScrollingFrame.GridTextureSet.ToggleClick.MouseButton1Down:Connect(function()
	Gridtoggle = not Gridtoggle
	if not Gridtoggle then
		--GridPart.Parent = nil
		for i,v in ipairs(GridPart:GetChildren()) do
			task.spawn(function()
						--// Make the transparency 1 with animations and 0.25 timeline
				Tween:Create(v, TweenInfo.new(0.25), {Transparency = 1}):Play()
			end)
		end
		SettingsFrame.Background2.ScrollingFrame.GridTextureSet.ToggleClick.Toggle.BackgroundColor = BrickColor.new(21)
		SettingsFrame.Background2.ScrollingFrame.GridTextureSet.ToggleClick.Toggle.Button.Position = UDim2.new(0, 0, 0, 0)
	else
		--GridPart.Parent = workspace.GridTexture
		for i,v in ipairs(GridPart:GetChildren()) do
			task.spawn(function()
						-- redo to normal
				Tween:Create(v, TweenInfo.new(0.25), {Transparency = 0.65}):Play()
			end)
		end
		SettingsFrame.Background2.ScrollingFrame.GridTextureSet.ToggleClick.Toggle.BackgroundColor = BrickColor.new(37)
		SettingsFrame.Background2.ScrollingFrame.GridTextureSet.ToggleClick.Toggle.Button.Position = UDim2.new(0.5, 0, 0, 0)
	end
end)

local TrailToggle = true
--// Tween & Button1
SettingsFrame.Background2.ScrollingFrame.PlanetTrailSets.ToggleClick.MouseButton1Down:Connect(function()
	TrailToggle = not TrailToggle
	if not TrailToggle then
			--// Making all the workspace.System folder trails to be false
		for i,v in ipairs(workspace.System:GetDescendants()) do
			if v:IsA('Trail') then
				v.Enabled = false
			end
		end
		SettingsFrame.Background2.ScrollingFrame.PlanetTrailSets.ToggleClick.Toggle.BackgroundColor = BrickColor.new(21)
		SettingsFrame.Background2.ScrollingFrame.PlanetTrailSets.ToggleClick.Toggle.Button.Position = UDim2.new(0, 0, 0, 0)
	else
			--// Making all the workspace.System folder trails to be true
		for i,v in ipairs(workspace.System:GetDescendants()) do
			if v:IsA('Trail') then
				v.Enabled = true
			end
		end
		SettingsFrame.Background2.ScrollingFrame.PlanetTrailSets.ToggleClick.Toggle.BackgroundColor = BrickColor.new(37)
		SettingsFrame.Background2.ScrollingFrame.PlanetTrailSets.ToggleClick.Toggle.Button.Position = UDim2.new(0.5, 0, 0, 0)
	end
end)

local Highlights = true
SettingsFrame.Background2.ScrollingFrame.PlanetHighlightTrails.ToggleClick.MouseButton1Down:Connect(function()
	Highlights = not Highlights
	if not Highlights then
			--// Making all the workspace.System folder highlights to be false
		for i,v in ipairs(workspace.System:GetDescendants()) do
			if v.Name == "Highlight" then
				v.Enabled = false
			end
		end
		SettingsFrame.Background2.ScrollingFrame.PlanetHighlightTrails.ToggleClick.Toggle.BackgroundColor = BrickColor.new(21)
		SettingsFrame.Background2.ScrollingFrame.PlanetHighlightTrails.ToggleClick.Toggle.Button.Position = UDim2.new(0, 0, 0, 0)
	else
			--// Making all the workspace.System folder highlights to be true
		for i,v in ipairs(workspace.System:GetDescendants()) do
			if v.Name == "Highlight" then
				v.Enabled = true
			end
		end
		SettingsFrame.Background2.ScrollingFrame.PlanetHighlightTrails.ToggleClick.Toggle.BackgroundColor = BrickColor.new(37)
		SettingsFrame.Background2.ScrollingFrame.PlanetHighlightTrails.ToggleClick.Toggle.Button.Position = UDim2.new(0.5, 0, 0, 0)
	end
end)

local NameToggle = true
SettingsFrame.Background2.ScrollingFrame.PlanetNamesSet.ToggleClick.MouseButton1Down:Connect(function()
	NameToggle = not NameToggle
	if not NameToggle then
			--// Making all the workspace.System folder bilboard/names to be false
		for i,v in ipairs(workspace.System:GetDescendants()) do
			if v.Name == "BillboardGui" then
				v.Enabled = false
			end
		end
		SettingsFrame.Background2.ScrollingFrame.PlanetNamesSet.ToggleClick.Toggle.BackgroundColor = BrickColor.new(21)
		SettingsFrame.Background2.ScrollingFrame.PlanetNamesSet.ToggleClick.Toggle.Button.Position = UDim2.new(0, 0, 0, 0)
	else
			--// Making all the workspace.System folder bilboard/names to be true
		for i,v in ipairs(workspace.System:GetDescendants()) do
			if v.Name == "BillboardGui" then
				v.Enabled = true
			end
		end
		SettingsFrame.Background2.ScrollingFrame.PlanetNamesSet.ToggleClick.Toggle.BackgroundColor = BrickColor.new(37)
		SettingsFrame.Background2.ScrollingFrame.PlanetNamesSet.ToggleClick.Toggle.Button.Position = UDim2.new(0.5, 0, 0, 0)
	end
end)

local BeamToggle = true
SettingsFrame.Background2.ScrollingFrame.PlanetPositionBeam.ToggleClick.MouseButton1Down:Connect(function()
	BeamToggle = not BeamToggle
	if not BeamToggle then
			--// Making all the workspace.System folder beams/planetbeams name to be false
		for i,v in ipairs(workspace.System:GetDescendants()) do
			if v:IsA('Beam') and v.Parent.Name == "PlanetBeamLocation" then
				v.Enabled = false
			end
		end
		SettingsFrame.Background2.ScrollingFrame.PlanetPositionBeam.ToggleClick.Toggle.BackgroundColor = BrickColor.new(21)
		SettingsFrame.Background2.ScrollingFrame.PlanetPositionBeam.ToggleClick.Toggle.Button.Position = UDim2.new(0, 0, 0, 0)
	else
			--// Making all the workspace.System folder breams to be false
		for i,v in ipairs(workspace.System:GetDescendants()) do
			if v:IsA('Beam') and v.Parent.Name == "PlanetBeamLocation" then
				v.Enabled = true
			end
			SettingsFrame.Background2.ScrollingFrame.PlanetPositionBeam.ToggleClick.Toggle.BackgroundColor = BrickColor.new(37)
			SettingsFrame.Background2.ScrollingFrame.PlanetPositionBeam.ToggleClick.Toggle.Button.Position = UDim2.new(0.5, 0, 0, 0)
		end
	end
end)

local AxisToggle = true
SettingsFrame.Background2.ScrollingFrame.PlanetAxisSet.ToggleClick.MouseButton1Down:Connect(function()
	AxisToggle = not AxisToggle
	if not AxisToggle then
			--// Making all the workspace.System folder axis name (beams) to be false
		for i,v in ipairs(workspace.System:GetDescendants()) do
			if v:IsA('Beam') and v.Parent.Name == "Axis" then
				v.Enabled = false
			end
		end
	else
			--// Making all the workspace.System folder axis name (beams) to be true
		for i,v in ipairs(workspace.System:GetDescendants()) do
			if v:IsA('Beam') and v.Parent.Name == "Axis" then
				v.Enabled = true
			end
		end
	end
end)

local ArrowVis = false

-- Tween animations for the UI
Main.ArrowFrame.UpArrow.MouseButton1Down:Connect(function()
	ArrowVis = true
	if ArrowVis then
		Tween:Create(Main.ArrowFrame.UpArrow, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {ImageTransparency = 1}):Play()
		Tween:Create(Main.ArrowFrame.DownArrow, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {ImageTransparency = 0}):Play()
		Tween:Create(Main.BottomFrame.OpenTimeIncrement, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = UDim2.new(0.147, 0, -1.11, 0)}):Play()
		wait(0.25)
		Main.ArrowFrame.UpArrow.Visible = false
		Main.ArrowFrame.DownArrow.Visible = true
	end
end)

-- Tween animations for the UI
Main.ArrowFrame.DownArrow.MouseButton1Down:Connect(function()
	ArrowVis = false
	if not ArrowVis then
		Tween:Create(Main.ArrowFrame.UpArrow, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {ImageTransparency = 0}):Play()
		Tween:Create(Main.ArrowFrame.DownArrow, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {ImageTransparency = 1}):Play()
		Tween:Create(Main.BottomFrame.OpenTimeIncrement, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = UDim2.new(0.147, 0, 1.11, 0)}):Play()
		wait(0.25)
		Main.ArrowFrame.UpArrow.Visible = true
		Main.ArrowFrame.DownArrow.Visible = false	
	end
end)

-- Basically updating the Leaderboard ui from the workspace.Donators folder
-- We are getting the children from the folder, then adding them to a table, then we are sorting the table by table.sort
-- after sorting we are reading the table and then making instances (template)
local function UpdateLeaderBoard()
	
	local d = {}
	local newDonators = {}
	local child = workspace.Donators:GetChildren()
	for l, o in pairs(child) do
		d[o.Name] = tonumber(o.Value)
	end
	for j,k in pairs(d) do
		local a = {User = j, Score = k}
		table.insert(newDonators, a)
	end
	table.sort(newDonators, function(a,b) return a.Score > b.Score end)
	for i2, v2 in pairs(Main.DonationHub.Background2.ScrollingFrame:GetChildren()) do
		if not v2:IsA('UIListLayout') then
			v2:Destroy()
		end
	end
	for i, v in pairs(newDonators) do
		--print(i,v)
		local Template;
		if i~=1 and i ~= 2 and i~=3 then
			Template =  Main.DonationHub.Background2.NormalTemplate:Clone()
		else
			Template =  Main.DonationHub.Background2.Template:Clone()
		end
		if i == 1 then
			Template.Rank.TextColor3 = Color3.fromRGB(255, 204, 0)
		end
		if i == 2 then
			Template.Rank.TextColor3 = Color3.fromRGB(77, 255, 0)
		end
		if i == 3 then
			Template.Rank.TextColor3 = Color3.fromRGB(0, 255, 238)
		end
		Template.Rank.Text = i
		Template.Name = i
		Template.PName.Text = v.User
		Template.Amount.Text = v.Score
		Template.Parent = Main.DonationHub.Background2.ScrollingFrame
		
		Template.Visible = true
	end
	
end

-- If a child is added to the folder, update again
workspace.Donators.ChildAdded:Connect(function()
	UpdateLeaderBoard()
end)

-- If a child is removed to the folder, update again
workspace.Donators.ChildRemoved:Connect(function()
	UpdateLeaderBoard()
end)

-- Update for the first time
UpdateLeaderBoard()

-- If a donations button is pressed, prompt purchase.
for i,v in pairs(Donations.Background2.ButtonList:GetChildren()) do
	if v:IsA('TextButton') then
		v.MouseButton1Down:Connect(function()
			promptPurchase(DonationProducts[v.Name])
		end)
	end
end


-- We added clickdetectors tot he system models, if the click detector is touched, we show specific info UI about the planet. (tween animations)
for j,k in pairs(workspace.System:GetChildren()) do
	if k:IsA('Model') then
		for i2,v2 in pairs(k:GetChildren()) do
			if v2.Name == "touch" then
				v2.ClickDetector.MouseClick:connect(function()
					print('Click', k.Name)
					for l,o in pairs(script.Parent.Planets:GetChildren()) do
						--Tween:Create(o, TweenInfo.new(0.05, Enum.EasingStyle.Bounce, Enum.EasingDirection.InOut), {Position = UDim2.new(2.15, 0,0.5, 0)}):Play()
						--wait(0.05)
						o.Visible = false
					end
					if script.Parent.Planets:FindFirstChild(k.Name) then
						--script.Parent.Planets[k.Name].Visible = true
						script.Parent.Planets[k.Name].Visible = true
						script.Parent.Planets[k.Name].Position = UDim2.new(-1.15, 0,0.5, 0)
						Tween:Create(script.Parent.Planets[k.Name], TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = UDim2.new(0.15, 0,0.5, 0)}):Play()
					end
				end)
			end
		end
	end
end

-- On pressing the (X) exit button in ui, exists
for l,o in pairs(script.Parent.Planets:GetChildren()) do
	for m, n in pairs(o:GetChildren()) do
		if n.Name == "Background1" then
			n.Exit.MouseButton1Down:connect(function()
				o.Visible = false
			end)
		end
	end
end
