--========================================================--
-- PART + MODEL HIGHLIGHT + TP
-- OPTIMIZED SEARCH + COMPACT UI
--========================================================--
-- FITUR:
-- • Search Part / Model
-- • Tidak menampilkan daftar sebelum search
-- • Scan hanya saat diperlukan
-- • Maksimal hasil yang ditampilkan
-- • Interactable Only ON/OFF
-- • Highlight ON/OFF
-- • Disable All Highlight
-- • Color
-- • Refresh
-- • TP
-- • Open / Close
-- • Drag tanpa kamera ikut bergerak
-- • Mobile friendly
--========================================================--

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--========================================================--
-- SETTINGS
--========================================================--

local HIGHLIGHT_NAME = "CustomObjectHighlight"

-- Batasi jumlah hasil GUI
local MAX_RESULTS = 100

-- Minimal karakter sebelum pencarian
local MIN_SEARCH_LENGTH = 1

local currentColor = Color3.fromRGB(255, 0, 0)

local interactableOnly = false

local highlightedObjects = {}

local searchVersion = 0

--========================================================--
-- GUI
--========================================================--

local gui = Instance.new("ScreenGui")
gui.Name = "OptimizedPartHighlightGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

--========================================================--
-- OPEN BUTTON
--========================================================--

local openButton = Instance.new("TextButton")
openButton.Name = "OpenButton"
openButton.Size = UDim2.fromOffset(60, 34)
openButton.Position = UDim2.fromOffset(15, 180)
openButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
openButton.Text = "OPEN"
openButton.TextColor3 = Color3.new(1, 1, 1)
openButton.TextSize = 12
openButton.Font = Enum.Font.GothamBold
openButton.Parent = gui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 8)
openCorner.Parent = openButton

--========================================================--
-- MAIN FRAME
--========================================================--

local frame = Instance.new("Frame")
frame.Name = "MainFrame"

-- Lebih kecil
frame.Size = UDim2.fromOffset(300, 410)

frame.Position = UDim2.fromOffset(25, 80)

frame.BackgroundColor3 = Color3.fromRGB(27, 27, 27)
frame.BorderSizePixel = 0
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = frame

--========================================================--
-- TITLE BAR
--========================================================--

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -45, 1, 0)
title.Position = UDim2.fromOffset(10, 0)
title.BackgroundTransparency = 1
title.Text = "PART + MODEL"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 13
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

--========================================================--
-- CLOSE
--========================================================--

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.fromOffset(29, 29)
closeButton.Position = UDim2.new(1, -34, 0, 4)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 55, 55)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextSize = 12
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 7)
closeCorner.Parent = closeButton

--========================================================--
-- SEARCH
--========================================================--

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -16, 0, 32)
searchBox.Position = UDim2.fromOffset(8, 46)

searchBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

searchBox.PlaceholderText = "🔎 Cari Part / Model..."
searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)

searchBox.Text = ""
searchBox.TextColor3 = Color3.new(1, 1, 1)

searchBox.TextSize = 12
searchBox.Font = Enum.Font.Gotham

searchBox.ClearTextOnFocus = false

searchBox.Parent = frame

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 7)
searchCorner.Parent = searchBox

--========================================================--
-- INTERACTABLE
--========================================================--

local interactLabel = Instance.new("TextLabel")
interactLabel.Size = UDim2.fromOffset(105, 25)
interactLabel.Position = UDim2.fromOffset(8, 84)
interactLabel.BackgroundTransparency = 1

interactLabel.Text = "INTERACT ONLY"
interactLabel.TextColor3 = Color3.fromRGB(220, 220, 220)

interactLabel.TextSize = 9
interactLabel.Font = Enum.Font.GothamBold

interactLabel.TextXAlignment = Enum.TextXAlignment.Left

interactLabel.Parent = frame

local interactToggle = Instance.new("TextButton")
interactToggle.Size = UDim2.fromOffset(48, 24)
interactToggle.Position = UDim2.fromOffset(108, 84)

interactToggle.BackgroundColor3 = Color3.fromRGB(75, 75, 75)

interactToggle.Text = "OFF"
interactToggle.TextColor3 = Color3.new(1, 1, 1)

interactToggle.TextSize = 9
interactToggle.Font = Enum.Font.GothamBold

interactToggle.Parent = frame

local interactCorner = Instance.new("UICorner")
interactCorner.CornerRadius = UDim.new(0, 6)
interactCorner.Parent = interactToggle

--========================================================--
-- DISABLE ALL
--========================================================--

local disableAllButton = Instance.new("TextButton")
disableAllButton.Size = UDim2.fromOffset(105, 24)

disableAllButton.Position = UDim2.new(1, -113, 0, 84)

disableAllButton.BackgroundColor3 = Color3.fromRGB(180, 55, 55)

disableAllButton.Text = "DISABLE ALL"

disableAllButton.TextColor3 = Color3.new(1, 1, 1)

disableAllButton.TextSize = 9
disableAllButton.Font = Enum.Font.GothamBold

disableAllButton.Parent = frame

local disableCorner = Instance.new("UICorner")
disableCorner.CornerRadius = UDim.new(0, 6)
disableCorner.Parent = disableAllButton

--========================================================--
-- COLOR LABEL
--========================================================--

local colorLabel = Instance.new("TextLabel")
colorLabel.Size = UDim2.fromOffset(45, 24)
colorLabel.Position = UDim2.fromOffset(8, 116)

colorLabel.BackgroundTransparency = 1

colorLabel.Text = "COLOR"

colorLabel.TextColor3 = Color3.fromRGB(220, 220, 220)

colorLabel.TextSize = 9
colorLabel.Font = Enum.Font.GothamBold

colorLabel.TextXAlignment = Enum.TextXAlignment.Left

colorLabel.Parent = frame

--========================================================--
-- COLORS
--========================================================--

local colors = {
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(0, 255, 80),
    Color3.fromRGB(0, 140, 255),
    Color3.fromRGB(255, 220, 0),
    Color3.fromRGB(180, 0, 255),
    Color3.fromRGB(255, 255, 255)
}

local colorButtons = {}

for i, color in ipairs(colors) do

    local button = Instance.new("TextButton")

    button.Size = UDim2.fromOffset(25, 22)

    button.Position = UDim2.fromOffset(
        50 + ((i - 1) * 29),
        117
    )

    button.BackgroundColor3 = color

    button.Text = ""

    button.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = button

    colorButtons[i] = button

    button.Activated:Connect(function()

        currentColor = color

        for _, other in ipairs(colorButtons) do
            other.BorderSizePixel = 0
        end

        button.BorderSizePixel = 2
        button.BorderColor3 = Color3.new(1, 1, 1)

        for _, highlights in pairs(highlightedObjects) do

            for _, highlight in ipairs(highlights) do

                if highlight and highlight.Parent then

                    highlight.FillColor = currentColor
                    highlight.OutlineColor = currentColor

                end

            end

        end

    end)

end

colorButtons[1].BorderSizePixel = 2
colorButtons[1].BorderColor3 = Color3.new(1, 1, 1)

--========================================================--
-- REFRESH
--========================================================--

local refreshButton = Instance.new("TextButton")

refreshButton.Size = UDim2.fromOffset(55, 24)

refreshButton.Position = UDim2.new(1, -63, 0, 116)

refreshButton.BackgroundColor3 =
    Color3.fromRGB(55, 110, 180)

refreshButton.Text = "REFRESH"

refreshButton.TextColor3 = Color3.new(1, 1, 1)

refreshButton.TextSize = 8
refreshButton.Font = Enum.Font.GothamBold

refreshButton.Parent = frame

local refreshCorner = Instance.new("UICorner")
refreshCorner.CornerRadius = UDim.new(0, 6)
refreshCorner.Parent = refreshButton

--========================================================--
-- STATUS
--========================================================--

local statusLabel = Instance.new("TextLabel")

statusLabel.Size = UDim2.new(1, -16, 0, 22)

statusLabel.Position = UDim2.fromOffset(8, 145)

statusLabel.BackgroundTransparency = 1

statusLabel.Text =
    "Ketik nama untuk mencari..."

statusLabel.TextColor3 =
    Color3.fromRGB(150, 150, 150)

statusLabel.TextSize = 10

statusLabel.Font = Enum.Font.Gotham

statusLabel.TextXAlignment =
    Enum.TextXAlignment.Left

statusLabel.Parent = frame

--========================================================--
-- LIST
--========================================================--

local listFrame = Instance.new("ScrollingFrame")

listFrame.Name = "ObjectList"

listFrame.Size =
    UDim2.new(1, -16, 1, -176)

listFrame.Position =
    UDim2.fromOffset(8, 172)

listFrame.BackgroundColor3 =
    Color3.fromRGB(22, 22, 22)

listFrame.BorderSizePixel = 0

listFrame.ScrollBarThickness = 4

listFrame.ScrollBarImageColor3 =
    Color3.fromRGB(100, 100, 100)

listFrame.CanvasSize =
    UDim2.new(0, 0, 0, 0)

listFrame.AutomaticCanvasSize =
    Enum.AutomaticSize.Y

listFrame.Parent = frame

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 7)
listCorner.Parent = listFrame

local layout = Instance.new("UIListLayout")

layout.Padding = UDim.new(0, 4)

layout.SortOrder = Enum.SortOrder.Name

layout.Parent = listFrame

local padding = Instance.new("UIPadding")

padding.PaddingTop = UDim.new(0, 5)
padding.PaddingBottom = UDim.new(0, 5)
padding.PaddingLeft = UDim.new(0, 5)
padding.PaddingRight = UDim.new(0, 5)

padding.Parent = listFrame

--========================================================--
-- INTERACTION CHECK
--========================================================--

local function hasInteraction(object)

    for _, descendant in ipairs(object:GetDescendants()) do

        if descendant:IsA("ProximityPrompt") then
            return true
        end

        if descendant:IsA("ClickDetector") then
            return true
        end

        if descendant.ClassName == "TouchTransmitter" then
            return true
        end

    end

    if object:IsA("BasePart") then

        if object:FindFirstChildOfClass("ProximityPrompt") then
            return true
        end

        if object:FindFirstChildOfClass("ClickDetector") then
            return true
        end

    end

    return false

end

--========================================================--
-- GET PARTS
--========================================================--

local function getObjectParts(object)

    local parts = {}

    if object:IsA("BasePart") then

        table.insert(parts, object)

    elseif object:IsA("Model") then

        for _, descendant in ipairs(object:GetDescendants()) do

            if descendant:IsA("BasePart") then

                table.insert(parts, descendant)

            end

        end

    end

    return parts

end

--========================================================--
-- TELEPORT PART
--========================================================--

local function getTeleportPart(object)

    if object:IsA("BasePart") then
        return object
    end

    if object:IsA("Model") then

        if object.PrimaryPart then
            return object.PrimaryPart
        end

        for _, descendant in ipairs(object:GetDescendants()) do

            if descendant:IsA("BasePart") then
                return descendant
            end

        end

    end

    return nil

end

--========================================================--
-- ADD HIGHLIGHT
--========================================================--

local function addHighlight(object)

    if not object or not object.Parent then
        return
    end

    if highlightedObjects[object] then
        return
    end

    local highlights = {}

    for _, part in ipairs(getObjectParts(object)) do

        local old =
            part:FindFirstChild(HIGHLIGHT_NAME)

        if old then
            old:Destroy()
        end

        local highlight =
            Instance.new("Highlight")

        highlight.Name =
            HIGHLIGHT_NAME

        highlight.Adornee =
            part

        highlight.FillColor =
            currentColor

        highlight.FillTransparency =
            0.45

        highlight.OutlineColor =
            currentColor

        highlight.OutlineTransparency =
            0

        highlight.DepthMode =
            Enum.HighlightDepthMode.AlwaysOnTop

        highlight.Parent = part

        table.insert(
            highlights,
            highlight
        )

    end

    if #highlights > 0 then

        highlightedObjects[object] =
            highlights

    end

end

--========================================================--
-- REMOVE HIGHLIGHT
--========================================================--

local function removeHighlight(object)

    local highlights =
        highlightedObjects[object]

    if highlights then

        for _, highlight in ipairs(highlights) do

            if highlight then
                highlight:Destroy()
            end

        end

    end

    highlightedObjects[object] = nil

end

--========================================================--
-- DISABLE ALL
--========================================================--

local function disableAllHighlights()

    for object, highlights
        in pairs(highlightedObjects) do

        for _, highlight in ipairs(highlights) do

            if highlight then
                highlight:Destroy()
            end

        end

    end

    table.clear(highlightedObjects)

end

--========================================================--
-- TELEPORT
--========================================================--

local function teleportToObject(object)

    if not object or not object.Parent then
        return
    end

    local character =
        player.Character

    if not character then
        return
    end

    local root =
        character:FindFirstChild(
            "HumanoidRootPart"
        )

    if not root then
        return
    end

    local target =
        getTeleportPart(object)

    if not target then
        return
    end

    local offset =
        (target.Size.Y / 2) + 4

    root.CFrame =
        CFrame.new(
            target.Position
                + Vector3.new(
                    0,
                    offset,
                    0
                )
        )

end

--========================================================--
-- CLEAR LIST
--========================================================--

local function clearList()

    for _, child in ipairs(
        listFrame:GetChildren()
    ) do

        if child:IsA("Frame") then
            child:Destroy()
        end

    end

end

--========================================================--
-- CREATE ROW
--========================================================--

local function createRow(object)

    local row =
        Instance.new("Frame")

    row.Size =
        UDim2.new(1, -2, 0, 36)

    row.BackgroundColor3 =
        Color3.fromRGB(40, 40, 40)

    row.BorderSizePixel = 0

    row.Parent = listFrame

    local corner =
        Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(0, 6)

    corner.Parent = row

    --====================================================--
    -- TYPE
    --====================================================--

    local typeLabel =
        Instance.new("TextLabel")

    typeLabel.Size =
        UDim2.fromOffset(28, 20)

    typeLabel.Position =
        UDim2.fromOffset(4, 8)

    typeLabel.BackgroundColor3 =
        object:IsA("Model")
        and Color3.fromRGB(125, 80, 180)
        or Color3.fromRGB(65, 105, 160)

    typeLabel.Text =
        object:IsA("Model")
        and "M"
        or "P"

    typeLabel.TextColor3 =
        Color3.new(1, 1, 1)

    typeLabel.TextSize = 9

    typeLabel.Font =
        Enum.Font.GothamBold

    typeLabel.Parent = row

    local typeCorner =
        Instance.new("UICorner")

    typeCorner.CornerRadius =
        UDim.new(0, 4)

    typeCorner.Parent =
        typeLabel

    --====================================================--
    -- NAME
    --====================================================--

    local nameLabel =
        Instance.new("TextLabel")

    nameLabel.Size =
        UDim2.new(1, -150, 1, 0)

    nameLabel.Position =
        UDim2.fromOffset(38, 0)

    nameLabel.BackgroundTransparency = 1

    nameLabel.Text =
        object.Name

    nameLabel.TextColor3 =
        Color3.fromRGB(235, 235, 235)

    nameLabel.TextSize = 10

    nameLabel.Font =
        Enum.Font.GothamMedium

    nameLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    nameLabel.TextTruncate =
        Enum.TextTruncate.AtEnd

    nameLabel.Parent = row

    --====================================================--
    -- HIGHLIGHT BUTTON
    --====================================================--

    local toggle =
        Instance.new("TextButton")

    toggle.Size =
        UDim2.fromOffset(45, 24)

    toggle.Position =
        UDim2.new(1, -105, 0, 6)

    toggle.TextSize = 9

    toggle.Font =
        Enum.Font.GothamBold

    toggle.TextColor3 =
        Color3.new(1, 1, 1)

    toggle.Parent = row

    local toggleCorner =
        Instance.new("UICorner")

    toggleCorner.CornerRadius =
        UDim.new(0, 5)

    toggleCorner.Parent =
        toggle

    --====================================================--
    -- TP
    --====================================================--

    local tpButton =
        Instance.new("TextButton")

    tpButton.Size =
        UDim2.fromOffset(45, 24)

    tpButton.Position =
        UDim2.new(1, -55, 0, 6)

    tpButton.BackgroundColor3 =
        Color3.fromRGB(55, 110, 180)

    tpButton.Text = "TP"

    tpButton.TextColor3 =
        Color3.new(1, 1, 1)

    tpButton.TextSize = 9

    tpButton.Font =
        Enum.Font.GothamBold

    tpButton.Parent = row

    local tpCorner =
        Instance.new("UICorner")

    tpCorner.CornerRadius =
        UDim.new(0, 5)

    tpCorner.Parent =
        tpButton

    --====================================================--
    -- TOGGLE UPDATE
    --====================================================--

    local function updateToggle()

        if highlightedObjects[object] then

            toggle.Text = "ON"

            toggle.BackgroundColor3 =
                Color3.fromRGB(40, 180, 80)

        else

            toggle.Text = "OFF"

            toggle.BackgroundColor3 =
                Color3.fromRGB(75, 75, 75)

        end

    end

    toggle.Activated:Connect(function()

        if highlightedObjects[object] then

            removeHighlight(object)

        else

            addHighlight(object)

        end

        updateToggle()

    end)

    tpButton.Activated:Connect(function()

        teleportToObject(object)

    end)

    updateToggle()

end

--========================================================--
-- SEARCH
--========================================================--

local function searchObjects()

    searchVersion += 1

    local thisSearch =
        searchVersion

    clearList()

    local searchText =
        string.lower(
            searchBox.Text
        )

    if #searchText < MIN_SEARCH_LENGTH then

        statusLabel.Text =
            "Ketik nama untuk mencari..."

        return

    end

    statusLabel.Text =
        "Mencari..."

    -- Beri kesempatan UI bernapas
    task.wait()

    if thisSearch ~= searchVersion then
        return
    end

    local results = {}

    --====================================================--
    -- SCAN WORKSPACE
    --====================================================--

    for _, object in ipairs(
        workspace:GetDescendants()
    ) do

        if thisSearch ~= searchVersion then
            return
        end

        if object:IsA("BasePart")
            or object:IsA("Model") then

            local name =
                string.lower(
                    object.Name
                )

            if string.find(
                name,
                searchText,
                1,
                true
            ) then

                local allowed = true

                if interactableOnly
                    and not hasInteraction(
                        object
                    ) then

                    allowed = false

                end

                if allowed then

                    table.insert(
                        results,
                        object
                    )

                    -- Stop kalau sudah cukup
                    if #results >= MAX_RESULTS then
                        break
                    end

                end

            end

        end

    end

    --====================================================--
    -- SORT
    --====================================================--

    table.sort(
        results,
        function(a, b)

            return string.lower(a.Name)
                < string.lower(b.Name)

        end
    )

    --====================================================--
    -- CREATE GUI
    --====================================================--

    for _, object in ipairs(results) do

        if thisSearch ~= searchVersion then
            return
        end

        createRow(object)

    end

    if #results == 0 then

        statusLabel.Text =
            "Tidak ditemukan."

    elseif #results >= MAX_RESULTS then

        statusLabel.Text =
            "Hasil: "
            .. tostring(#results)
            .. "+ (dibatasi)"

    else

        statusLabel.Text =
            "Hasil: "
            .. tostring(#results)

    end

end

--========================================================--
-- SEARCH TEXT
--========================================================--

searchBox:GetPropertyChangedSignal(
    "Text"
):Connect(function()

    searchObjects()

end)

--========================================================--
-- INTERACTABLE TOGGLE
--========================================================--

interactToggle.Activated:Connect(function()

    interactableOnly =
        not interactableOnly

    if interactableOnly then

        interactToggle.Text = "ON"

        interactToggle.BackgroundColor3 =
            Color3.fromRGB(40, 180, 80)

    else

        interactToggle.Text = "OFF"

        interactToggle.BackgroundColor3 =
            Color3.fromRGB(75, 75, 75)

    end

    if #searchBox.Text >= MIN_SEARCH_LENGTH then

        searchObjects()

    end

end)

--========================================================--
-- DISABLE ALL
--========================================================--

disableAllButton.Activated:Connect(function()

    disableAllHighlights()

    -- Update tombol yang sedang terlihat
    for _, row in ipairs(
        listFrame:GetChildren()
    ) do

        if row:IsA("Frame") then

            local button =
                row:FindFirstChildOfClass(
                    "TextButton"
                )

            -- Ambil tombol highlight pertama
            for _, child in ipairs(
                row:GetChildren()
            ) do

                if child:IsA("TextButton")
                    and child.Text ~= "TP" then

                    child.Text = "OFF"

                    child.BackgroundColor3 =
                        Color3.fromRGB(
                            75,
                            75,
                            75
                        )

                    break

                end

            end

        end

    end

end)

--========================================================--
-- REFRESH
--========================================================--

refreshButton.Activated:Connect(function()

    if #searchBox.Text >= MIN_SEARCH_LENGTH then

        searchObjects()

    end

end)

--========================================================--
-- CLOSE
--========================================================--

closeButton.Activated:Connect(function()

    frame.Visible = false

    openButton.Visible = true

end)

--========================================================--
-- OPEN
--========================================================--

openButton.Activated:Connect(function()

    frame.Visible = true

    openButton.Visible = false

end)

--========================================================--
-- DRAG SYSTEM
--========================================================--

local function makeDraggable(
    guiObject,
    dragHandle
)

    local dragging = false

    local dragStart

    local startPosition

    local dragInput

    dragHandle.InputBegan:Connect(
        function(input)

            if input.UserInputType ==
                Enum.UserInputType.MouseButton1
                or input.UserInputType ==
                Enum.UserInputType.Touch then

                dragging = true

                dragStart =
                    input.Position

                startPosition =
                    guiObject.Position

                dragInput = input

                input.Changed:Connect(
                    function()

                        if input.UserInputState ==
                            Enum.UserInputState.End then

                            dragging = false

                        end

                    end
                )

            end

        end
    )

    dragHandle.InputChanged:Connect(
        function(input)

            if input.UserInputType ==
                Enum.UserInputType.MouseMovement
                or input.UserInputType ==
                Enum.UserInputType.Touch then

                dragInput = input

            end

        end
    )

    UserInputService.InputChanged:Connect(
        function(input)

            if not dragging then
                return
            end

            if input ~= dragInput then
                return
            end

            local delta =
                input.Position
                - dragStart

            guiObject.Position =
                UDim2.new(

                    startPosition.X.Scale,

                    startPosition.X.Offset
                        + delta.X,

                    startPosition.Y.Scale,

                    startPosition.Y.Offset
                        + delta.Y
                )

        end
    )

end

-- Hanya title bar yang drag frame
makeDraggable(
    frame,
    titleBar
)

-- OPEN bisa dipindahkan
makeDraggable(
    openButton,
    openButton
)

--========================================================--
-- INITIAL STATE
--========================================================--

frame.Visible = true

openButton.Visible = false

statusLabel.Text =
    "Ketik nama untuk mencari..."

--========================================================--
-- CLEANUP
--========================================================--

task.spawn(function()

    while task.wait(3) do

        for object, highlights
            in pairs(highlightedObjects) do

            if not object
                or not object.Parent then

                for _, highlight
                    in ipairs(highlights) do

                    if highlight then
                        highlight:Destroy()
                    end

                end

                highlightedObjects[object] = nil

            end

        end

    end

end)