local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

--==================================================
-- GUI
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AnimationCopier"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

--==================================================
-- MAIN
--==================================================

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 300, 0, 390)
Main.Position = UDim2.new(0.5, -150, 0.5, -195)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = Main

--==================================================
-- TITLE
--==================================================

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -55, 0, 45)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🎭ANIMATION COPIER ©erhant"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextScaled = true
Title.TextSize = 19
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Active = true
Title.Parent = Main

--==================================================
-- CLOSE BUTTON
--==================================================

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 40, 0, 35)
Close.Position = UDim2.new(1, -45, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(170, 55, 55)
Close.Text = "X"
Close.TextColor3 = Color3.new(1, 1, 1)
Close.TextSize = 16
Close.Font = Enum.Font.GothamBold
Close.Parent = Main

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 7)
CloseCorner.Parent = Close

--==================================================
-- SEARCH
--==================================================

local Search = Instance.new("TextBox")
Search.Size = UDim2.new(1, -20, 0, 40)
Search.Position = UDim2.new(0, 10, 0, 50)
Search.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Search.PlaceholderText = "Search username..."
Search.Text = ""
Search.TextColor3 = Color3.new(1, 1, 1)
Search.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
Search.TextSize = 14
Search.Font = Enum.Font.Gotham
Search.ClearTextOnFocus = false
Search.Parent = Main

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 7)
SearchCorner.Parent = Search

--==================================================
-- PLAYER LIST
--==================================================

local List = Instance.new("ScrollingFrame")
List.Size = UDim2.new(1, -20, 0, 210)
List.Position = UDim2.new(0, 10, 0, 100)
List.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
List.BorderSizePixel = 0
List.ScrollBarThickness = 4
List.CanvasSize = UDim2.new(0, 0, 0, 0)
List.Parent = Main

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 7)
ListCorner.Parent = List

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 5)
Layout.Parent = List

--==================================================
-- STATUS
--==================================================

local Selected = nil

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 25)
Status.Position = UDim2.new(0, 10, 0, 315)
Status.BackgroundTransparency = 1
Status.Text = "Pilih player"
Status.TextColor3 = Color3.fromRGB(180, 180, 180)
Status.TextSize = 13
Status.Font = Enum.Font.Gotham
Status.Parent = Main

--==================================================
-- COPY BUTTON
--==================================================

local CopyButton = Instance.new("TextButton")
CopyButton.Size = UDim2.new(1, -20, 0, 40)
CopyButton.Position = UDim2.new(0, 10, 0, 345)
CopyButton.BackgroundColor3 = Color3.fromRGB(45, 140, 70)
CopyButton.Text = "COPY ANIMATIONS"
CopyButton.TextColor3 = Color3.new(1, 1, 1)
CopyButton.TextSize = 14
CopyButton.Font = Enum.Font.GothamBold
CopyButton.Parent = Main

local CopyCorner = Instance.new("UICorner")
CopyCorner.CornerRadius = UDim.new(0, 7)
CopyCorner.Parent = CopyButton

--==================================================
-- REFRESH PLAYER LIST
--==================================================

local function RefreshList()

    for _, child in ipairs(List:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local SearchText = Search.Text:lower()
    local Count = 0

    for _, Player in ipairs(Players:GetPlayers()) do

        if Player ~= LocalPlayer then

            local Username = Player.Name:lower()
            local DisplayName = Player.DisplayName:lower()

            if SearchText == ""
                or Username:find(SearchText, 1, true)
                or DisplayName:find(SearchText, 1, true) then

                local Button = Instance.new("TextButton")

                Button.Size = UDim2.new(1, -10, 0, 38)
                Button.BackgroundColor3 =
                    Color3.fromRGB(45, 45, 45)

                Button.Text =
                    Player.DisplayName ..
                    "  @" ..
                    Player.Name

                Button.TextColor3 =
                    Color3.new(1, 1, 1)

                Button.TextSize = 13
                Button.Font = Enum.Font.Gotham
                Button.Parent = List

                local ButtonCorner =
                    Instance.new("UICorner")

                ButtonCorner.CornerRadius =
                    UDim.new(0, 6)

                ButtonCorner.Parent = Button

                Button.MouseButton1Click:Connect(function()

                    Selected = Player

                    Status.Text =
                        "Target: @" .. Player.Name

                    Status.TextColor3 =
                        Color3.fromRGB(100, 200, 255)

                end)

                Count += 1
            end
        end
    end

    List.CanvasSize =
        UDim2.new(0, 0, 0, Count * 43)
end

Search:GetPropertyChangedSignal("Text"):Connect(RefreshList)

Players.PlayerAdded:Connect(RefreshList)

Players.PlayerRemoving:Connect(function(Player)

    if Selected == Player then
        Selected = nil
        Status.Text = "Player has left"
    end

    RefreshList()
end)

RefreshList()

--==================================================
-- COPY ANIMATIONS
--==================================================

CopyButton.MouseButton1Click:Connect(function()

    if not Selected then
        Status.Text = "❌ Select the player first!"
        return
    end

    Character =
        LocalPlayer.Character
        or LocalPlayer.CharacterAdded:Wait()

    local TargetCharacter =
        workspace:FindFirstChild(Selected.Name)

    if not TargetCharacter then
        Status.Text =
            "❌ Player not found!"
        return
    end

    local TargetAnimate =
        TargetCharacter:FindFirstChild("Animate")

    local MyAnimate =
        Character:FindFirstChild("Animate")

    if not TargetAnimate then
        Status.Text =
            "❌ Target animation not found!"
        return
    end

    if not MyAnimate then
        Status.Text =
            "❌ Your animation was not found!"
        return
    end

    -- 8 animation categories
    local AnimationFolders = {
        "idle",
        "walk",
        "run",
        "jump",
        "fall",
        "climb",
        "swimidle",
        "swim"
    }

    local Copied = 0

    for _, FolderName in ipairs(AnimationFolders) do

        local TargetFolder =
            TargetAnimate:FindFirstChild(FolderName)

        local MyFolder =
            MyAnimate:FindFirstChild(FolderName)

        if TargetFolder and MyFolder then

            -- COPY ALL ANIMATIONS
            -- including Animation1, Animation2, etc.
            for _, TargetAnimation in
                ipairs(TargetFolder:GetChildren()) do

                if TargetAnimation:IsA("Animation") then

                    local MyAnimation =
                        MyFolder:FindFirstChild(
                            TargetAnimation.Name
                        )

                    if MyAnimation
                        and MyAnimation:IsA("Animation") then

                        MyAnimation.AnimationId =
                            TargetAnimation.AnimationId

                        Copied += 1

                        print(
                            "Copied:",
                            FolderName,
                            TargetAnimation.Name,
                            TargetAnimation.AnimationId
                        )
                    end
                end
            end
        end
    end

    Status.Text =
        "✅ Copied " .. Copied .. " animations!"

    Status.TextColor3 =
        Color3.fromRGB(100, 255, 130)
end)

--==================================================
-- OPEN BUTTON
--==================================================

local Open = Instance.new("TextButton")

Open.Size = UDim2.new(0, 65, 0, 40)

Open.Position =
    UDim2.new(0, 15, 0.5, -20)

Open.BackgroundColor3 =
    Color3.fromRGB(45, 120, 200)

Open.Text = "OPEN"

Open.TextColor3 =
    Color3.new(1, 1, 1)

Open.TextSize = 14

Open.Font =
    Enum.Font.GothamBold

Open.Visible = false

Open.Active = true

Open.Parent = ScreenGui

local OpenCorner =
    Instance.new("UICorner")

OpenCorner.CornerRadius =
    UDim.new(0, 8)

OpenCorner.Parent = Open

--==================================================
-- OPEN / CLOSE
--==================================================

Close.MouseButton1Click:Connect(function()

    Main.Visible = false
    Open.Visible = true

end)

Open.MouseButton1Click:Connect(function()

    Main.Visible = true
    Open.Visible = false

end)

--==================================================
-- DRAG SYSTEM
--==================================================

local function MakeDraggable(Object, DragArea)

    local Dragging = false
    local DragStart
    local StartPosition

    DragArea.InputBegan:Connect(function(Input)

        if Input.UserInputType ==
            Enum.UserInputType.MouseButton1
            or Input.UserInputType ==
            Enum.UserInputType.Touch then

            Dragging = true

            DragStart =
                Input.Position

            StartPosition =
                Object.Position

            Input.Changed:Connect(function()

                if Input.UserInputState ==
                    Enum.UserInputState.End then

                    Dragging = false

                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)

        if not Dragging then
            return
        end

        if Input.UserInputType ==
            Enum.UserInputType.MouseMovement
            or Input.UserInputType ==
            Enum.UserInputType.Touch then

            local Delta =
                Input.Position - DragStart

            Object.Position =
                UDim2.new(
                    StartPosition.X.Scale,
                    StartPosition.X.Offset + Delta.X,
                    StartPosition.Y.Scale,
                    StartPosition.Y.Offset + Delta.Y
                )
        end
    end)
end


MakeDraggable(Main, Title)

MakeDraggable(Open, Open)