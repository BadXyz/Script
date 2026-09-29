
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================

local INTERACT_DELAY = 0.25
local TELEPORT_OFFSET = Vector3.new(0, 3, 0)

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WildEggTakeGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

--==================================================
-- OPEN BUTTON
--==================================================

local OpenButton = Instance.new("TextButton")
OpenButton.Name = "OpenButton"
OpenButton.Size = UDim2.fromOffset(72, 34)

-- Posisi atas, dekat Settings
OpenButton.Position = UDim2.new(0.5, -175, 0, 14)

OpenButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
OpenButton.BackgroundTransparency = 0.05
OpenButton.Text = "🐟OPEN"
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.TextSize = 14
OpenButton.Font = Enum.Font.GothamBold
OpenButton.BorderSizePixel = 0
OpenButton.ZIndex = 100
OpenButton.Active = true
OpenButton.Parent = ScreenGui

local OpenCorner = Instance.new("UICorner")
OpenCorner.CornerRadius = UDim.new(0, 9)
OpenCorner.Parent = OpenButton

--==================================================
-- MAIN FRAME
--==================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(285, 345)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)

Main.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
Main.BorderSizePixel = 0
Main.Active = true
Main.Visible = true
Main.ZIndex = 10
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -55, 0, 42)
Title.Position = UDim2.fromOffset(12, 3)

Title.BackgroundTransparency = 1
Title.Text = "Ride A Fish🐟"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 11
Title.Parent = Main

--==================================================
-- CLOSE
--==================================================

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "Close"
CloseButton.Size = UDim2.fromOffset(38, 38)
CloseButton.Position = UDim2.new(1, -43, 0, 5)

CloseButton.BackgroundColor3 = Color3.fromRGB(190, 55, 55)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.ZIndex = 12
CloseButton.Parent = Main

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 9)
CloseCorner.Parent = CloseButton

--==================================================
-- SEARCH
--==================================================

local SearchBox = Instance.new("TextBox")
SearchBox.Name = "SearchBox"
SearchBox.Size = UDim2.new(1, -105, 0, 40)
SearchBox.Position = UDim2.fromOffset(10, 50)

SearchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SearchBox.BorderSizePixel = 0
SearchBox.PlaceholderText = "Search Egg..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.TextSize = 14
SearchBox.Font = Enum.Font.Gotham
SearchBox.ClearTextOnFocus = false
SearchBox.ZIndex = 11
SearchBox.Parent = Main

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 9)
SearchCorner.Parent = SearchBox

local SearchPadding = Instance.new("UIPadding")
SearchPadding.PaddingLeft = UDim.new(0, 10)
SearchPadding.PaddingRight = UDim.new(0, 8)
SearchPadding.Parent = SearchBox

--==================================================
-- REFRESH
--==================================================

local RefreshButton = Instance.new("TextButton")
RefreshButton.Name = "Refresh"
RefreshButton.Size = UDim2.fromOffset(85, 40)
RefreshButton.Position = UDim2.new(1, -95, 0, 50)

RefreshButton.BackgroundColor3 = Color3.fromRGB(55, 105, 180)
RefreshButton.Text = "🔄"
RefreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshButton.TextSize = 19
RefreshButton.Font = Enum.Font.GothamBold
RefreshButton.BorderSizePixel = 0
RefreshButton.ZIndex = 11
RefreshButton.Parent = Main

local RefreshCorner = Instance.new("UICorner")
RefreshCorner.CornerRadius = UDim.new(0, 9)
RefreshCorner.Parent = RefreshButton

--==================================================
-- STATUS
--==================================================

local Status = Instance.new("TextLabel")
Status.Name = "Status"
Status.Size = UDim2.new(1, -20, 0, 27)
Status.Position = UDim2.fromOffset(10, 94)

Status.BackgroundTransparency = 1
Status.Text = "Mencari telur..."
Status.TextColor3 = Color3.fromRGB(180, 180, 180)
Status.TextSize = 12
Status.Font = Enum.Font.Gotham
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.ZIndex = 11
Status.Parent = Main

--==================================================
-- EGG LIST
--==================================================

local EggList = Instance.new("ScrollingFrame")
EggList.Name = "EggList"
EggList.Size = UDim2.new(1, -20, 1, -132)
EggList.Position = UDim2.fromOffset(10, 123)

EggList.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
EggList.BorderSizePixel = 0
EggList.ScrollBarThickness = 5
EggList.ScrollBarImageTransparency = 0.25
EggList.CanvasSize = UDim2.new(0, 0, 0, 0)
EggList.AutomaticCanvasSize = Enum.AutomaticSize.Y
EggList.ZIndex = 11
EggList.Parent = Main

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 10)
ListCorner.Parent = EggList

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 5)
ListLayout.SortOrder = Enum.SortOrder.Name
ListLayout.Parent = EggList

local ListPadding = Instance.new("UIPadding")
ListPadding.PaddingTop = UDim.new(0, 6)
ListPadding.PaddingBottom = UDim.new(0, 6)
ListPadding.PaddingLeft = UDim.new(0, 6)
ListPadding.PaddingRight = UDim.new(0, 6)
ListPadding.Parent = EggList

--==================================================
-- DRAG SYSTEM
--==================================================

local dragging = false
local dragStart
local startPosition

local function updateDrag(input)
	if not dragging then
		return
	end

	local delta = input.Position - dragStart

	Main.Position = UDim2.new(
		startPosition.X.Scale,
		startPosition.X.Offset + delta.X,
		startPosition.Y.Scale,
		startPosition.Y.Offset + delta.Y
	)
end

Main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPosition = Main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Main.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		UserInputService.InputChanged:Connect(function(changedInput)
			if changedInput == input then
				updateDrag(changedInput)
			end
		end)
	end
end)

--==================================================
-- OPEN / CLOSE
--==================================================

CloseButton.MouseButton1Click:Connect(function()
	Main.Visible = false
	OpenButton.Visible = true
end)

OpenButton.MouseButton1Click:Connect(function()
	Main.Visible = true
	OpenButton.Visible = false
end)

--==================================================
-- CHARACTER
--==================================================

local function getCharacter()
	return LocalPlayer.Character
		or LocalPlayer.CharacterAdded:Wait()
end

local function getRoot(character)
	if not character then
		return nil
	end

	return character:FindFirstChild("HumanoidRootPart")
		or character:FindFirstChild("UpperTorso")
		or character:FindFirstChild("Torso")
end

--==================================================
-- GET OBJECT CFRAME
--==================================================

local function getObjectCFrame(object)

	if not object then
		return nil
	end

	if object:IsA("BasePart") then
		return object.CFrame
	end

	if object:IsA("Model") then
		return object:GetPivot()
	end

	local part = object:FindFirstChildWhichIsA("BasePart", true)

	if part then
		return part.CFrame
	end

	return nil
end

--==================================================
-- TELEPORT
--==================================================

local function teleportTo(object)
	local character = getCharacter()
	local root = getRoot(character)

	if not root then
		return false
	end

	local cf = getObjectCFrame(object)

	if not cf then
		return false
	end

	root.CFrame = cf + TELEPORT_OFFSET

	return true
end

--==================================================
-- FIND WILD EGGS
--==================================================

local function getWildEggs()

	-- Jalur utama
	local EggRuntime = workspace:FindFirstChild("EggRuntime")

	if EggRuntime then
		local WildEggs = EggRuntime:FindFirstChild("WildEggs")

		if WildEggs then
			return WildEggs
		end
	end

	-- Cari recursive
	local found = workspace:FindFirstChild("WildEggs", true)

	if found then
		return found
	end

	-- Coba case-insensitive
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj.Name:lower() == "wildeggs" then
			return obj
		end
	end

	return nil
end

--==================================================
-- GET EGG LIST
--==================================================

local function getEggList()

	local WildEggs = getWildEggs()

	if not WildEggs then
		return {}
	end

	local eggs = {}

	for _, obj in ipairs(WildEggs:GetChildren()) do

		if obj:IsA("Model") then
			table.insert(eggs, obj)

		elseif obj:IsA("Folder") then

			-- Kalau Folder langsung berisi egg
			local hasPart = obj:FindFirstChildWhichIsA("BasePart", true)

			if hasPart then
				table.insert(eggs, obj)
			end
		end
	end

	table.sort(eggs, function(a, b)
		return a.Name:lower() < b.Name:lower()
	end)

	return eggs
end

--==================================================
-- FIND MY PLOT
--==================================================

local function findMyPlot()

	local myUserId = tonumber(LocalPlayer.UserId)

	for _, object in ipairs(workspace:GetDescendants()) do

		if object:IsA("Model") then

			-- Nama harus Player Pot...
			if object.Name:lower():match("^player pot") then

				local ownerId = object:GetAttribute("OwnerUserId")

				if ownerId ~= nil then

					if tonumber(ownerId) == myUserId then
						return object
					end

				end
			end
		end
	end

	return nil
end

--==================================================
-- FIND SPAWN PLAYER
--==================================================

local function findMySpawn()

	local plot = findMyPlot()

	if not plot then
		return nil
	end

	return plot:FindFirstChild("SpawnPlayer", true)
end

--==================================================
-- INTERACT
--==================================================

local function interactWith(object)

	local foundInteraction = false

	-- ProximityPrompt
	for _, item in ipairs(object:GetDescendants()) do

		if item:IsA("ProximityPrompt") then

			foundInteraction = true

			pcall(function()

				if typeof(fireproximityprompt) == "function" then
					fireproximityprompt(item)
				end

			end)

			task.wait(INTERACT_DELAY)
		end
	end

	-- ClickDetector
	for _, item in ipairs(object:GetDescendants()) do

		if item:IsA("ClickDetector") then

			foundInteraction = true

			pcall(function()

				if typeof(fireclickdetector) == "function" then
					fireclickdetector(item)
				end

			end)

			task.wait(INTERACT_DELAY)
		end
	end

	return foundInteraction
end

--==================================================
-- TAKE EGG
--==================================================

local busy = false

local function takeEgg(egg)

	if busy then
		return
	end

	busy = true

	Status.Text = "TP → " .. egg.Name

	-- TP ke egg
	local tpSuccess = teleportTo(egg)

	if not tpSuccess then

		Status.Text = "Gagal TP ke " .. egg.Name
		busy = false

		return
	end

	task.wait(0.4)

	-- Interaksi
	Status.Text = "Interaksi → " .. egg.Name

	local interacted = interactWith(egg)

	task.wait(0.4)

	-- Cari spawn sendiri
	Status.Text = "Mencari plot sendiri..."

	local spawnPlayer = findMySpawn()

	if spawnPlayer then

		Status.Text = "Kembali ke plot..."

		teleportTo(spawnPlayer)

		task.wait(0.3)

		if interacted then
			Status.Text = "Berhasil: " .. egg.Name
		else
			Status.Text = "TP berhasil, interaksi tidak ditemukan"
		end

	else

		Status.Text = "SpawnPlayer plot tidak ditemukan"
	end

	busy = false
end

--==================================================
-- CREATE EGG ROW
--==================================================

local function createEggRow(egg)

	local Row = Instance.new("Frame")
	Row.Name = egg.Name
	Row.Size = UDim2.new(1, -2, 0, 38)

	Row.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Row.BorderSizePixel = 0
	Row.ZIndex = 12
	Row.Parent = EggList

	local RowCorner = Instance.new("UICorner")
	RowCorner.CornerRadius = UDim.new(0, 7)
	RowCorner.Parent = Row

	-- Egg name
	local NameLabel = Instance.new("TextLabel")
	NameLabel.Size = UDim2.new(1, -75, 1, 0)
	NameLabel.Position = UDim2.fromOffset(8, 0)

	NameLabel.BackgroundTransparency = 1
	NameLabel.Text = egg.Name
	NameLabel.TextColor3 = Color3.fromRGB(235, 235, 235)
	NameLabel.TextSize = 12
	NameLabel.Font = Enum.Font.GothamMedium
	NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	NameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	NameLabel.ZIndex = 13
	NameLabel.Parent = Row

	-- TAKE
	local TakeButton = Instance.new("TextButton")
	TakeButton.Size = UDim2.fromOffset(58, 28)
	TakeButton.Position = UDim2.new(1, -64, 0.5, -14)

	TakeButton.BackgroundColor3 = Color3.fromRGB(50, 145, 80)
	TakeButton.Text = "TAKE"
	TakeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	TakeButton.TextSize = 11
	TakeButton.Font = Enum.Font.GothamBold
	TakeButton.BorderSizePixel = 0
	TakeButton.ZIndex = 13
	TakeButton.Parent = Row

	local TakeCorner = Instance.new("UICorner")
	TakeCorner.CornerRadius = UDim.new(0, 6)
	TakeCorner.Parent = TakeButton

	TakeButton.MouseButton1Click:Connect(function()
		takeEgg(egg)
	end)
end

--==================================================
-- CLEAR LIST
--==================================================

local function clearList()

	for _, child in ipairs(EggList:GetChildren()) do

		if child:IsA("Frame") then
			child:Destroy()
		end
	end
end

--==================================================
-- REFRESH LIST
--==================================================

local function refreshList()

	clearList()

	Status.Text = "Mencari telur..."

	local WildEggs = getWildEggs()

	if not WildEggs then

		Status.Text = "telur tidak ditemukan"
		return
	end

	local eggs = getEggList()

	local search = SearchBox.Text:lower()

	local count = 0

	for _, egg in ipairs(eggs) do

		if search == ""
			or egg.Name:lower():find(search, 1, true) then

			createEggRow(egg)
			count += 1
		end
	end

	Status.Text = "Ditemukan: " .. count .. " telur"
end

--==================================================
-- SEARCH
--==================================================

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
	refreshList()
end)

--==================================================
-- REFRESH BUTTON
--==================================================

RefreshButton.MouseButton1Click:Connect(function()

	RefreshButton.Text = "⏳"

	refreshList()

	task.wait(0.2)

	RefreshButton.Text = "🔄"
end)

--==================================================
-- AUTO REFRESH WILD EGGS
--==================================================

local function connectWildEggEvents()

	local WildEggs = getWildEggs()

	if not WildEggs then
		return
	end

	WildEggs.ChildAdded:Connect(function()

		task.wait(0.1)

		refreshList()
	end)

	WildEggs.ChildRemoved:Connect(function()

		task.wait(0.1)

		refreshList()
	end)
end

--==================================================
-- INITIAL
--==================================================

OpenButton.Visible = false

task.wait(1)

refreshList()

connectWildEggEvents()

-- Coba cari lagi beberapa kali karena object game
-- kadang muncul beberapa saat setelah character masuk.
task.spawn(function()

	for i = 1, 10 do

		task.wait(1)

		local WildEggs = getWildEggs()

		if WildEggs then

			refreshList()
			connectWildEggEvents()

			break
		end
	end
end)