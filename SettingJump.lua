--// CUSTOM JUMP EDITOR
--// LocalScript
--// StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- SETTINGS
--==================================================

local MIN_SIZE = 40
local MAX_SIZE = 180
local SIZE_STEP = 5

local editing = false
local restoringSize = false

--==================================================
-- WAIT TOUCH GUI
--==================================================

local touchGui = playerGui:WaitForChild("TouchGui", 15)
if not touchGui then
	return
end

local touchFrame = touchGui:WaitForChild("TouchControlFrame", 15)
if not touchFrame then
	return
end

local jump = touchFrame:WaitForChild("JumpButton", 15)
if not jump then
	return
end

--==================================================
-- SAVE ORIGINAL / CUSTOM SIZE
--==================================================

local savedJumpSize = jump.AbsoluteSize.X

-- Pastikan ukuran awal tersimpan
if savedJumpSize < MIN_SIZE then
	savedJumpSize = 60
end

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
editButton.TextSize = 13
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
doneButton.Name = "DoneButton"
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
-- MINUS BUTTON
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

--==================================================
-- PLUS BUTTON
--==================================================

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
-- APPLY SAVED SIZE
--==================================================

local function applySavedSize()
	if not jump or not jump.Parent then
		return
	end

	if restoringSize then
		return
	end

	restoringSize = true

	jump.Size = UDim2.fromOffset(
		savedJumpSize,
		savedJumpSize
	)

	restoringSize = false
end

--==================================================
-- UPDATE RESIZE BUTTONS
--==================================================

local function updateResizeButtons()
	if not editing then
		return
	end

	if not jump or not jump.Parent then
		return
	end

	local pos = jump.AbsolutePosition
	local size = jump.AbsoluteSize

	local buttonWidth = 32
	local gap = 4

	local totalWidth =
		buttonWidth +
		gap +
		buttonWidth

	local centerX = pos.X + (size.X / 2)

	local startX =
		centerX -
		(totalWidth / 2)

	local y =
		pos.Y +
		size.Y +
		6

	minusButton.Position = UDim2.fromOffset(
		startX,
		y
	)

	plusButton.Position = UDim2.fromOffset(
		startX + buttonWidth + gap,
		y
	)
end

--==================================================
-- RESIZE JUMP
--==================================================

local function resizeJump(amount)
	local newSize = math.clamp(
		savedJumpSize + amount,
		MIN_SIZE,
		MAX_SIZE
	)

	savedJumpSize = newSize

	applySavedSize()

	task.defer(function()
		updateResizeButtons()
	end)
end

--==================================================
-- MINUS
--==================================================

minusButton.Activated:Connect(function()
	resizeJump(-SIZE_STEP)
end)

--==================================================
-- PLUS
--==================================================

plusButton.Activated:Connect(function()
	resizeJump(SIZE_STEP)
end)

--==================================================
-- DETECT ROBLOX RESETTING JUMP SIZE
--==================================================

jump:GetPropertyChangedSignal("Size"):Connect(function()

	if restoringSize then
		return
	end

	-- Kalau ukuran berubah bukan dari tombol +/-
	-- kembalikan ke ukuran custom yang tersimpan.
	task.defer(function()

		if not jump or not jump.Parent then
			return
		end

		local currentSize = jump.AbsoluteSize.X

		if math.abs(currentSize - savedJumpSize) > 1 then
			applySavedSize()
		end

		if editing then
			updateResizeButtons()
		end
	end)
end)

--==================================================
-- TAMBAHAN PROTEKSI SAAT JUMP DITEKAN
--==================================================

jump.Activated:Connect(function()

	-- Roblox kadang mengubah ukuran JumpButton
	-- ketika tombol ditekan.
	task.defer(function()
		applySavedSize()

		task.defer(function()
			applySavedSize()
		end)
	end)

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

		-- Pastikan ukuran tetap custom
		applySavedSize()

		jump.Active = true
		jump.ImageTransparency = 0.15

		task.defer(function()
			updateResizeButtons()
		end)

	else

		-- Saat keluar edit mode,
		-- tetap gunakan ukuran custom.
		applySavedSize()

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

		local delta =
			input.Position -
			editDragStart

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

	-- Simpan ukuran sebelum keluar
	savedJumpSize = math.clamp(
		savedJumpSize,
		MIN_SIZE,
		MAX_SIZE
	)

	applySavedSize()

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

		local delta =
			input.Position -
			jumpDragStart

		jump.Position = UDim2.new(
			jumpStartPos.X.Scale,
			jumpStartPos.X.Offset + delta.X,

			jumpStartPos.Y.Scale,
			jumpStartPos.Y.Offset + delta.Y
		)

		task.defer(function()
			updateResizeButtons()
		end)

	end
end)

jump.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.Touch
		or input.UserInputType == Enum.UserInputType.MouseButton1 then

		jumpDragging = false

	end
end)

--==================================================
-- UPDATE SAAT POSISI BERUBAH
--==================================================

jump:GetPropertyChangedSignal("Position"):Connect(function()

	if editing then
		task.defer(function()
			updateResizeButtons()
		end)
	end

end)

--==================================================
-- INITIALIZE
--==================================================

applySavedSize()

task.defer(function()
	updateResizeButtons()
end)

--==================================================
-- EXTRA SIZE PROTECTION
--==================================================

task.spawn(function()

	while gui.Parent do

		task.wait(0.25)

		if jump and jump.Parent then

			local currentSize = jump.AbsoluteSize.X

			if math.abs(currentSize - savedJumpSize) > 1 then
				applySavedSize()
			end

		end

	end

end)

game:GetService("StarterGui"):SetCore("SendNotification", { 
	Title = "SETTING JUMP";
	Text = "Setting Jump by: erhant";
	Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"})
Duration = 5;
