--// CUSTOM JUMP EDITOR
--// LocalScript
--// StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- WAIT TOUCH GUI
--==================================================

local touchGui = playerGui:WaitForChild("TouchGui", 15)
if not touchGui then return end

local touchFrame = touchGui:WaitForChild("TouchControlFrame", 15)
if not touchFrame then return end

local jump = touchFrame:WaitForChild("JumpButton", 15)
if not jump then return end

--==================================================
-- SETTINGS
--==================================================

local MIN_SIZE = 40
local MAX_SIZE = 180
local SIZE_STEP = 5

local editing = false

--==================================================
-- MAIN GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "JumpEditor"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

--==================================================
-- EDIT BUTTON
--==================================================

local editButton = Instance.new("TextButton")
editButton.Name = "EditButton"
editButton.Size = UDim2.fromOffset(80, 42)
editButton.Position = UDim2.new(0, 15, 0.5, -21)
editButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
editButton.TextColor3 = Color3.new(1, 1, 1)
editButton.Text = "SettingJump"
editButton.TextSize = 16
editButton.Font = Enum.Font.GothamBold
editButton.Active = true
editButton.Parent = gui

local editCorner = Instance.new("UICorner")
editCorner.CornerRadius = UDim.new(0, 10)
editCorner.Parent = editButton

--==================================================
-- MODE EDIT LABEL
--==================================================

local label = Instance.new("TextLabel")
label.Size = UDim2.fromOffset(250, 42)
label.Position = UDim2.new(0.5, -125, 0, 20)
label.BackgroundTransparency = 0.15
label.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
label.TextColor3 = Color3.new(1, 1, 1)
label.Text = "MODE EDIT JUMP"
label.TextSize = 14
label.Font = Enum.Font.GothamBold
label.Visible = false
label.Parent = gui

local labelCorner = Instance.new("UICorner")
labelCorner.CornerRadius = UDim.new(0, 10)
labelCorner.Parent = label

--==================================================
-- DONE BUTTON
--==================================================

local doneButton = Instance.new("TextButton")
doneButton.Size = UDim2.fromOffset(80, 42)
doneButton.Position = UDim2.new(1, -95, 0.5, -21)
doneButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
doneButton.TextColor3 = Color3.new(1, 1, 1)
doneButton.Text = "DONE"
doneButton.TextSize = 16
doneButton.Font = Enum.Font.GothamBold
doneButton.Visible = false
doneButton.Parent = gui

local doneCorner = Instance.new("UICorner")
doneCorner.CornerRadius = UDim.new(0, 10)
doneCorner.Parent = doneButton

--==================================================
-- RESIZE BUTTONS
--==================================================

local minusButton = Instance.new("TextButton")
minusButton.Name = "MinusButton"
minusButton.Size = UDim2.fromOffset(32, 28)
minusButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
minusButton.TextColor3 = Color3.new(1, 1, 1)
minusButton.Text = "−"
minusButton.TextSize = 20
minusButton.Font = Enum.Font.GothamBold
minusButton.Visible = false
minusButton.Parent = gui

local minusCorner = Instance.new("UICorner")
minusCorner.CornerRadius = UDim.new(0, 8)
minusCorner.Parent = minusButton

local plusButton = Instance.new("TextButton")
plusButton.Name = "PlusButton"
plusButton.Size = UDim2.fromOffset(32, 28)
plusButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
plusButton.TextColor3 = Color3.new(1, 1, 1)
plusButton.Text = "+"
plusButton.TextSize = 20
plusButton.Font = Enum.Font.GothamBold
plusButton.Visible = false
plusButton.Parent = gui

local plusCorner = Instance.new("UICorner")
plusCorner.CornerRadius = UDim.new(0, 8)
plusCorner.Parent = plusButton

--==================================================
-- POSISI -/+ DI BAWAH JUMP
--==================================================

local function updateResizeButtons()
	if not editing then
		return
	end

	local pos = jump.AbsolutePosition
	local size = jump.AbsoluteSize

	local totalWidth = 32 + 4 + 32
	local centerX = pos.X + (size.X / 2)

	local y = pos.Y + size.Y + 6

	minusButton.Position = UDim2.fromOffset(
		centerX - (totalWidth / 2),
		y
	)

	plusButton.Position = UDim2.fromOffset(
		centerX + 4 - (totalWidth / 2) + 32,
		y
	)
end

--==================================================
-- RESIZE
--==================================================

local function resizeJump(amount)
	local currentSize = jump.AbsoluteSize.X

	local newSize = math.clamp(
		currentSize + amount,
		MIN_SIZE,
		MAX_SIZE
	)

	jump.Size = UDim2.fromOffset(
		newSize,
		newSize
	)

	task.defer(updateResizeButtons)
end

minusButton.Activated:Connect(function()
	resizeJump(-SIZE_STEP)
end)

plusButton.Activated:Connect(function()
	resizeJump(SIZE_STEP)
end)

--==================================================
-- MODE EDIT
--==================================================

local function setEditMode(state)
	editing = state

	label.Visible = state
	doneButton.Visible = state
	editButton.Visible = not state

	minusButton.Visible = state
	plusButton.Visible = state

	if state then
		jump.Active = true
		jump.ImageTransparency = 0.15

		task.defer(updateResizeButtons)
	else
		jump.ImageTransparency = 0
	end
end

--==================================================
-- EDIT BUTTON DRAG
--==================================================

local editDragging = false
local editDragStart
local editStartPos
local editMoved = false

editButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then

		editDragging = true
		editMoved = false

		editDragStart = input.Position
		editStartPos = editButton.Position
	end
end)

editButton.InputChanged:Connect(function(input)
	if not editDragging then
		return
	end

	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseMovement then

		local delta = input.Position - editDragStart

		if delta.Magnitude > 8 then
			editMoved = true
		end

		editButton.Position = UDim2.new(
			editStartPos.X.Scale,
			editStartPos.X.Offset + delta.X,

			editStartPos.Y.Scale,
			editStartPos.Y.Offset + delta.Y
		)
	end
end)

editButton.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then

		editDragging = false

		if not editMoved then
			setEditMode(true)
		end
	end
end)

--==================================================
-- DONE
--==================================================

doneButton.Activated:Connect(function()
	setEditMode(false)
end)

--==================================================
-- DRAG JUMP
--==================================================

local jumpDragging = false
local jumpDragStart
local jumpStartPos

jump.InputBegan:Connect(function(input)
	if not editing then
		return
	end

	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then

		jumpDragging = true

		jumpDragStart = input.Position
		jumpStartPos = jump.Position
	end
end)

jump.InputChanged:Connect(function(input)
	if not editing or not jumpDragging then
		return
	end

	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseMovement then

		local delta = input.Position - jumpDragStart

		jump.Position = UDim2.new(
			jumpStartPos.X.Scale,
			jumpStartPos.X.Offset + delta.X,

			jumpStartPos.Y.Scale,
			jumpStartPos.Y.Offset + delta.Y
		)

		task.defer(updateResizeButtons)
	end
end)

jump.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then

		jumpDragging = false
	end
end)

--==================================================
-- UPDATE POSISI SAAT UKURAN / POSISI BERUBAH
--==================================================

jump:GetPropertyChangedSignal("Position"):Connect(function()
	if editing then
		task.defer(updateResizeButtons)
	end
end)

jump:GetPropertyChangedSignal("Size"):Connect(function()
	if editing then
		task.defer(updateResizeButtons)
	end
end)

game:GetService("StarterGui"):SetCore("SendNotification", { 
	Title = "SETTING JUMP";
	Text = "Setting Jump by: erhant";
	Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"})
Duration = 5;