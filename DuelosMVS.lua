--[[
    DELTA EXECUTOR - Duelos: Murderers vs Sheriffs
    Features: Infinite Jump, Speed, FOV, ESP, Auto Shot
    Made for MvS Games
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")
local gui = player:WaitForChild("PlayerGui")

-- ====== SETTINGS ======
local Settings = {
    infiniteJump = false,
    speed = 0,
    speedBoost = false,
    speedValue = 50,
    fov = 70,
    esp = false,
    autoShot = false,
    autoShotRange = 100
}

-- ====== CREATE GUI ======
local screen = Instance.new("ScreenGui")
screen.Name = "DeltaMenu"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true
screen.Parent = gui

-- ====== BUBBLE BUTTON ======
local bubble = Instance.new("Frame")
bubble.Name = "Bubble"
bubble.Size = UDim2.new(0, 75, 0, 75)
bubble.Position = UDim2.new(0, 20, 0, 200)
bubble.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
bubble.Parent = screen
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 37)
corner.Parent = bubble

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 150, 255)
stroke.Thickness = 2
stroke.Parent = bubble

local bubbleBtn = Instance.new("TextButton")
bubbleBtn.Size = UDim2.new(1, 0, 1, 0)
bubbleBtn.BackgroundTransparency = 1
bubbleBtn.Text = "Δ"
bubbleBtn.Font = Enum.Font.GothamBlack
bubbleBtn.TextSize = 40
bubbleBtn.TextColor3 = Color3.fromRGB(100, 150, 255)
bubbleBtn.Parent = bubble

-- ====== MAIN PANEL ======
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 450, 0, 500)
panel.Position = UDim2.new(0.5, -225, 0.5, -250)
panel.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
panel.Visible = false
panel.Parent = screen

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 15)
panelCorner.Parent = panel

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.fromRGB(100, 150, 255)
panelStroke.Thickness = 2
panelStroke.Parent = panel

-- ====== HEADER ======
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
header.Parent = panel

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 15)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "DELTA MvS"
title.Font = Enum.Font.GothamBlack
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(100, 150, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -45, 0.5, -17)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 90)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Parent = header

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 8)
closeBtnCorner.Parent = closeBtn

-- ====== CONTENT ======
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -20, 1, -70)
content.Position = UDim2.new(0, 10, 0, 60)
content.BackgroundTransparency = 1
content.ScrollBarThickness = 5
content.Parent = panel

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.Parent = content

-- ====== FUNCTION TO CREATE TOGGLE ======
local function createToggle(parent, name, key)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    frame.Parent = parent

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 10)
    frameCorner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -65, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(220, 220, 235)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBox = Instance.new("Frame")
    toggleBox.Size = UDim2.new(0, 45, 0, 24)
    toggleBox.Position = UDim2.new(1, -55, 0.5, -12)
    toggleBox.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    toggleBox.Parent = frame

    local toggleBoxCorner = Instance.new("UICorner")
    toggleBoxCorner.CornerRadius = UDim.new(0, 12)
    toggleBoxCorner.Parent = toggleBox

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 20, 0, 20)
    dot.Position = UDim2.new(0.08, 0, 0.5, -10)
    dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    dot.Parent = toggleBox

    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(0, 10)
    dotCorner.Parent = dot

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Settings[key] = not Settings[key]
            toggleBox.BackgroundColor3 = Settings[key] and Color3.fromRGB(80, 210, 140) or Color3.fromRGB(60, 60, 80)
            local pos = Settings[key] and 0.66 or 0.08
            dot.Position = UDim2.new(pos, 0, 0.5, -10)
            print(name .. ":", Settings[key])
        end
    end)

    return frame
end

-- ====== FUNCTION TO CREATE SLIDER ======
local function createSlider(parent, name, key, min, max, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 55)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    frame.Parent = parent

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 10)
    frameCorner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 8)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextColor3 = Color3.fromRGB(220, 220, 235)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, 0, 0, 20)
    valueLabel.Position = UDim2.new(1, -50, 0, 8)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 13
    valueLabel.TextColor3 = Color3.fromRGB(100, 150, 255)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = frame

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 6)
    sliderBg.Position = UDim2.new(0, 10, 0, 32)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    sliderBg.Parent = frame

    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 3)
    sliderBgCorner.Parent = sliderBg

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    sliderFill.Parent = sliderBg

    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 3)
    sliderFillCorner.Parent = sliderFill

    local sliderDot = Instance.new("Frame")
    sliderDot.Size = UDim2.new(0, 16, 0, 16)
    sliderDot.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    sliderDot.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    sliderDot.Parent = sliderBg

    local sliderDotCorner = Instance.new("UICorner")
    sliderDotCorner.CornerRadius = UDim.new(0, 8)
    sliderDotCorner.Parent = sliderDot

    Settings[key] = default

    local dragging = false
    sliderDot.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = sliderBg.AbsolutePosition.X
            local sliderSize = sliderBg.AbsoluteSize.X
            local newPos = math.clamp(mousePos.X - sliderPos, 0, sliderSize)
            local percentage = newPos / sliderSize
            local value = math.floor(min + (max - min) * percentage)

            Settings[key] = value
            valueLabel.Text = tostring(value)
            sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            sliderDot.Position = UDim2.new(percentage, -8, 0.5, -8)
        end
    end)

    return frame
end

-- ====== ADD TOGGLES & SLIDERS ======
createToggle(content, "Infinite Jump", "infiniteJump")
createToggle(content, "Speed Boost", "speedBoost")
createSlider(content, "Speed", "speedValue", 20, 150, 50)
createSlider(content, "FOV", "fov", 40, 120, 70)
createToggle(content, "ESP", "esp")
createToggle(content, "Auto Shot", "autoShot")

-- ====== INFINITE JUMP ======
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Space and Settings.infiniteJump then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ====== SPEED BOOST ======
RunService.RenderStepped:Connect(function()
    if Settings.speedBoost and humanoidRootPart then
        local moveDirection = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + (Camera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - (Camera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + Camera.CFrame.RightVector
        end

        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit
            humanoidRootPart.Velocity = Vector3.new(
                moveDirection.X * Settings.speedValue,
                humanoidRootPart.Velocity.Y,
                moveDirection.Z * Settings.speedValue
            )
        end
    end
end)

-- ====== FOV CHANGER ======
RunService.RenderStepped:Connect(function()
    Camera.FieldOfView = Settings.fov
end)

-- ====== ESP ======
local espBoxes = {}

RunService.RenderStepped:Connect(function()
    if Settings.esp then
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local otherChar = otherPlayer.Character
                local otherHumanoidRootPart = otherChar:FindFirstChild("HumanoidRootPart")
                local otherHumanoid = otherChar:FindFirstChild("Humanoid")

                if otherHumanoidRootPart and otherHumanoid and otherHumanoid.Health > 0 then
                    local id = otherPlayer.UserId
                    if not espBoxes[id] then
                        espBoxes[id] = Instance.new("BoxHandleAdornment")
                        espBoxes[id].Adornee = otherHumanoidRootPart
                        espBoxes[id].Color3 = Color3.fromRGB(255, 0, 0)
                        espBoxes[id].Transparency = 0.5
                        espBoxes[id].Parent = otherHumanoidRootPart
                    end
                end
            end
        end
    else
        for id, box in pairs(espBoxes) do
            box:Destroy()
        end
        espBoxes = {}
    end
end)

-- ====== AUTO SHOT ======
RunService.RenderStepped:Connect(function()
    if Settings.autoShot then
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local otherChar = otherPlayer.Character
                local otherHumanoidRootPart = otherChar:FindFirstChild("HumanoidRootPart")
                local otherHumanoid = otherChar:FindFirstChild("Humanoid")

                if otherHumanoidRootPart and otherHumanoid and otherHumanoid.Health > 0 then
                    local distance = (otherHumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                    if distance <= Settings.autoShotRange then
                        -- Intenta disparar (dependiendo del juego)
                        local tool = char:FindFirstChildOfClass("Tool")
                        if tool and tool:FindFirstChild("Handle") then
                            -- Buscar función de disparo
                            if tool:FindFirstChild("Shoot") then
                                tool.Shoot:FireServer(otherHumanoidRootPart.Position)
                            elseif tool:FindFirstChild("Fire") then
                                tool.Fire:FireServer(otherHumanoidRootPart.Position)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ====== PANEL TOGGLE ======
local menuOpen = false
bubbleBtn.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    panel.Visible = menuOpen
end)

closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
    menuOpen = false
end)

-- ====== DRAG BUBBLE ======
local dragging = false
local dragStart = Vector2.new()
local startPos = bubble.Position

bubble.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = UserInputService:GetMouseLocation()
        startPos = bubble.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local currentMouse = UserInputService:GetMouseLocation()
        local delta = currentMouse - dragStart
        bubble.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("✅ DELTA MvS Menu Loaded!")
print("🎮 Features: Infinite Jump, Speed, FOV, ESP, Auto Shot")
