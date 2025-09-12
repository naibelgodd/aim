local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Đó Ai NEW SCRIPT"
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 120)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -60)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 5)
title.BackgroundTransparency = 1
title.Text = "ĐÓ Ai NEW SCRIPT"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.8, 0, 0, 25)
toggleButton.Position = UDim2.new(0.1, 0, 0, 45)
toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "tự động chèo: tắt"
toggleButton.TextSize = 14
toggleButton.Font = Enum.Font.Gotham
toggleButton.Parent = mainFrame
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleButton

local function makeDraggable(frame)
    local dragging = false
    local dragInput, dragStart, startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(mainFrame)

local isToggled = false
toggleButton.MouseButton1Click:Connect(function()
    isToggled = not isToggled
    if isToggled then
        toggleButton.Text = "tự động chèo: bật"
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        getgenv().farm = true
        spawn(function()
            local remoteFolder = game:GetService("ReplicatedStorage"):WaitForChild("src"):WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("GameService"):WaitForChild("RE")
            local handleClickEvent = remoteFolder:WaitForChild("HandleClick")
            local args = {2}
            while getgenv().farm do
                handleClickEvent:FireServer(unpack(args))
                task.wait()
            end
        end)
    else
        toggleButton.Text = "tự động chèo: tắt"
        toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        getgenv().farm = false
    end
end)
