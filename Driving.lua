-- ==============================================================================
-- VETERAN ARCHITECT: THE TOUCH PERFECTION (V13.2 - COLLAPSIBLE LIST)
-- PLATFORM: ROBLOX (LUAU) - CLIENT SIDE / EXECUTOR
-- ==============================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Trạng thái Teleport
local targetPlayer = nil
local autoTpConnection = nil
local autoTpEnabled = false

-- Trạng thái Physics (Limit 30)
local flyEnabled = false
local flySpeed = 10
local speedEnabled = false
local moveSpeed = 10

-- Trạng thái ESP
local espEnabled = false

-- ==============================================================================
-- 1. CROSS-PLATFORM INPUT & MODERN PHYSICS LOGIC (LINEAR VELOCITY)
-- ==============================================================================

local function getRootPart()
	local char = LocalPlayer.Character
	if not char then return nil end
	local hum = char:FindFirstChild("Humanoid")
	if hum and hum.SeatPart then
		local model = hum.SeatPart:FindFirstAncestorOfClass("Model")
		if model and model.PrimaryPart then return model.PrimaryPart end
		return hum.SeatPart
	end
	return char:FindFirstChild("HumanoidRootPart")
end

local function setupFlyConstraints(root)
	if not root then return nil, nil end
	
	local attachment = root:FindFirstChild("VA_FlyAttachment")
	if not attachment then
		attachment = Instance.new("Attachment")
		attachment.Name = "VA_FlyAttachment"
		attachment.Parent = root
	end

	local lv = root:FindFirstChild("VA_FlyVelocity")
	if not lv then
		lv = Instance.new("LinearVelocity")
		lv.Name = "VA_FlyVelocity"
		lv.Attachment0 = attachment
		lv.MaxForce = math.huge
		lv.VectorVelocity = Vector3.zero
		lv.Enabled = false
		lv.Parent = root
	end

	local ao = root:FindFirstChild("VA_FlyOrientation")
	if not ao then
		ao = Instance.new("AlignOrientation")
		ao.Name = "VA_FlyOrientation"
		ao.Mode = Enum.OrientationAlignmentMode.OneAttachment
		ao.Attachment0 = attachment
		ao.MaxTorque = math.huge
		ao.Enabled = false
		ao.Parent = root
	end

	return lv, ao
end

RunService.RenderStepped:Connect(function(deltaTime)
	local root = getRootPart()
	if not root then return end

	local moveVector = Vector3.new(0, 0, 0)
	local success, _ = pcall(function()
		local controls = require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule")):GetControls()
		moveVector = controls:GetMoveVector()
	end)
	
	if not success or moveVector.Magnitude == 0 then
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChild("Humanoid")
		if hum and hum.SeatPart then
			moveVector = Vector3.new(hum.SeatPart.SteerFloat, 0, -hum.SeatPart.ThrottleFloat)
		else
			local x, z = 0, 0
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then z = -1 end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then z = 1 end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then x = -1 end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then x = 1 end
			moveVector = Vector3.new(x, 0, z)
		end
	end

	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChild("Humanoid")

	if flyEnabled then
		local lv, ao = setupFlyConstraints(root)
		if hum and not hum.PlatformStand then hum.PlatformStand = true end
		
		if lv and ao then
			lv.Enabled = true
			ao.Enabled = true
			
			local yOffset = 0
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then yOffset = 1 end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then yOffset = -1 end
			
			local finalMoveVec = Vector3.new(moveVector.X, yOffset, moveVector.Z)
			
			local worldMoveDir = (Camera.CFrame * CFrame.new(finalMoveVec)).Position - Camera.CFrame.Position
			if worldMoveDir.Magnitude > 0 then
				worldMoveDir = worldMoveDir.Unit
			end
			
			lv.VectorVelocity = worldMoveDir * (flySpeed * 5)
			ao.CFrame = Camera.CFrame
		end
	else
		local lv = root:FindFirstChild("VA_FlyVelocity")
		local ao = root:FindFirstChild("VA_FlyOrientation")
		if lv and lv.Enabled then lv.Enabled = false end
		if ao and ao.Enabled then ao.Enabled = false end
		
		if hum and hum.PlatformStand then hum.PlatformStand = false end
		
		if speedEnabled then
			local moveDir = (Camera.CFrame.RightVector * moveVector.X) - (Camera.CFrame.LookVector * moveVector.Z)
			local flatDir = Vector3.new(moveDir.X, 0, moveDir.Z)
			if flatDir.Magnitude > 0 then
				root.CFrame = root.CFrame + (flatDir.Unit * moveSpeed * deltaTime * 15)
			end
		end
	end
end)

-- ==============================================================================
-- 2. BULLETPROOF ESP ENGINE
-- ==============================================================================

task.spawn(function()
	while task.wait(0.5) do
		if espEnabled then
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
					local head = player.Character.Head
					local esp = head:FindFirstChild("VA_ESP_FINAL")
					
					if not esp then
						esp = Instance.new("BillboardGui")
						esp.Name = "VA_ESP_FINAL"
						esp.Size = UDim2.new(0, 200, 0, 50)
						esp.StudsOffset = Vector3.new(0, 3, 0)
						esp.AlwaysOnTop = true
						
						local txt = Instance.new("TextLabel")
						txt.Name = "NameTag"
						txt.Size = UDim2.new(1, 0, 1, 0)
						txt.BackgroundTransparency = 1
						txt.TextColor3 = Color3.fromRGB(0, 255, 255)
						txt.TextStrokeTransparency = 0
						txt.Font = Enum.Font.Code
						txt.TextSize = 16
						txt.Parent = esp
						esp.Parent = head
					end
					
					esp.NameTag.Text = "[ " .. player.Name .. " ]"
				end
			end
		else
			for _, player in ipairs(Players:GetPlayers()) do
				if player.Character and player.Character:FindFirstChild("Head") then
					local esp = player.Character.Head:FindFirstChild("VA_ESP_FINAL")
					if esp then esp:Destroy() end
				end
			end
		end
	end
end)

-- ==============================================================================
-- 3. PROCEDURAL UI (DRAGGABLE BUBBLE + MAIN PANEL)
-- ==============================================================================
local gui = Instance.new("ScreenGui")
gui.Name = "ArchitectUtilityUI_V13_2"
gui.ResetOnSpawn = false

-- [ DRAGGABLE BUBBLE ]
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 45, 0, 45)
toggleBtn.Position = UDim2.new(0, 20, 0.5, 0) 
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleBtn.TextColor3 = Color3.fromRGB(255, 200, 0)
toggleBtn.Text = "V.A"
toggleBtn.Font = Enum.Font.Code
toggleBtn.TextSize = 16
toggleBtn.Parent = gui
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

local isDragging = false
local hasMoved = false
local dragStartPos = nil
local startGuiPos = nil

toggleBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isDragging = true
		hasMoved = false
		dragStartPos = input.Position
		startGuiPos = toggleBtn.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStartPos
		if delta.Magnitude > 5 then
			hasMoved = true
			toggleBtn.Position = UDim2.new(startGuiPos.X.Scale, startGuiPos.X.Offset + delta.X, startGuiPos.Y.Scale, startGuiPos.Y.Offset + delta.Y)
		end
	end
end)

toggleBtn.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isDragging = false
		local delta = input.Position - dragStartPos
		if delta.Magnitude <= 5 then 
			if gui:FindFirstChild("MainFrame") then
				gui.MainFrame.Visible = not gui.MainFrame.Visible
			end
		end
	end
end)

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0.65, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = gui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "VETERAN PANEL (V13.2)"
title.TextColor3 = Color3.fromRGB(0, 255, 150)
title.Font = Enum.Font.Code
title.TextSize = 18
title.Parent = mainFrame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, -35)
scroll.Position = UDim2.new(0, 0, 0, 35)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.BorderSizePixel = 0
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scroll

-- [ SMART TOUCH BUTTONS ]
local function createButton(text, order, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.85, 0, 0, 35)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = text
	btn.Font = Enum.Font.Code
	btn.TextSize = 14
	btn.LayoutOrder = order
	btn.Parent = scroll
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
	
	local btnDragStart = nil
	local isScrolling = false
	
	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			btnDragStart = input.Position
			isScrolling = false
			btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		end
	end)
	
	btn.InputChanged:Connect(function(input)
		if btnDragStart and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - btnDragStart
			if delta.Magnitude > 10 then 
				isScrolling = true
				btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			end
		end
	end)
	
	btn.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			if btnDragStart and not isScrolling then
				callback(btn) 
			end
			btnDragStart = nil
		end
	end)
	return btn
end

local function createSlider(name, maxVal, defaultVal, order, updateVarCallback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(0.85, 0, 0, 50) 
	container.BackgroundTransparency = 1
	container.LayoutOrder = order
	container.Parent = scroll
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 20)
	label.BackgroundTransparency = 1
	label.Text = name .. ": " .. defaultVal
	label.TextColor3 = Color3.fromRGB(200, 200, 200)
	label.Font = Enum.Font.Code
	label.TextSize = 14
	label.Parent = container
	
	local sliderBg = Instance.new("Frame")
	sliderBg.Size = UDim2.new(1, 0, 0, 10)
	sliderBg.Position = UDim2.new(0, 0, 0, 30)
	sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	sliderBg.Parent = container
	Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
	
	local sliderFill = Instance.new("Frame")
	sliderFill.Size = UDim2.new(defaultVal/maxVal, 0, 1, 0)
	sliderFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
	sliderFill.Parent = sliderBg
	Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)
	
	local draggingSlider = false
	local function updateSlider(input)
		local pos = math.clamp(input.Position.X - sliderBg.AbsolutePosition.X, 0, sliderBg.AbsoluteSize.X)
		local percent = pos / sliderBg.AbsoluteSize.X
		local value = math.floor(percent * maxVal)
		sliderFill.Size = UDim2.new(percent, 0, 1, 0)
		label.Text = name .. ": " .. value
		updateVarCallback(value)
	end
	
	sliderBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = true; updateSlider(input)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateSlider(input)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = false
		end
	end)
end

-- ==============================================================================
-- 4. BINDING COMPONENTS & COLLAPSIBLE PLAYER LIST
-- ==============================================================================

-- [ Target Display ]
local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(0.85, 0, 0, 25)
targetLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
targetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
targetLabel.Text = "Target: None"
targetLabel.Font = Enum.Font.Code
targetLabel.TextSize = 14
targetLabel.LayoutOrder = 1
targetLabel.Parent = scroll
Instance.new("UICorner", targetLabel).CornerRadius = UDim.new(0, 4)

-- [ Player List Toggle Header ]
local listExpanded = false -- Mặc định thu gọn
local playerListToggle = Instance.new("TextButton")
playerListToggle.Size = UDim2.new(0.85, 0, 0, 30)
playerListToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
playerListToggle.TextColor3 = Color3.fromRGB(255, 200, 0)
playerListToggle.Text = listExpanded and "▼ Player List" or "▶ Player List"
playerListToggle.Font = Enum.Font.Code
playerListToggle.TextSize = 14
playerListToggle.LayoutOrder = 2
playerListToggle.Parent = scroll
Instance.new("UICorner", playerListToggle).CornerRadius = UDim.new(0, 4)

-- [ Player List Container ]
local playerListContainer = Instance.new("Frame")
playerListContainer.Size = UDim2.new(1, 0, 0, 0)
playerListContainer.BackgroundTransparency = 1
playerListContainer.AutomaticSize = Enum.AutomaticSize.Y
playerListContainer.Visible = listExpanded
playerListContainer.LayoutOrder = 3
playerListContainer.Parent = scroll
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 4)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.SortOrder = Enum.SortOrder.Name
listLayout.Parent = playerListContainer

-- Logic Smart Touch cho Header Toggle
local pToggleDrag = nil
local pToggleScroll = false
playerListToggle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		pToggleDrag = input.Position; pToggleScroll = false
		playerListToggle.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	end
end)
playerListToggle.InputChanged:Connect(function(input)
	if pToggleDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		if (input.Position - pToggleDrag).Magnitude > 10 then pToggleScroll = true; playerListToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35) end
	end
end)
playerListToggle.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		playerListToggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		if pToggleDrag and not pToggleScroll then
			listExpanded = not listExpanded
			playerListContainer.Visible = listExpanded
			playerListToggle.Text = listExpanded and "▼ Player List" or "▶ Player List"
		end
		pToggleDrag = nil
	end
end)

local function updatePlayerList()
	for _, child in ipairs(playerListContainer:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local pBtn = Instance.new("TextButton")
			pBtn.Size = UDim2.new(0.85, 0, 0, 30)
			pBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			pBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
			pBtn.Text = "👤 " .. player.Name
			pBtn.Font = Enum.Font.Code
			pBtn.TextSize = 13
			pBtn.Parent = playerListContainer
			Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 4)
			
			local pBtnDragStart = nil
			local pIsScrolling = false
			pBtn.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					pBtnDragStart = input.Position; pIsScrolling = false; pBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
				end
			end)
			pBtn.InputChanged:Connect(function(input)
				if pBtnDragStart and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					if (input.Position - pBtnDragStart).Magnitude > 10 then pIsScrolling = true; pBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45) end
				end
			end)
			pBtn.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					pBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
					if pBtnDragStart and not pIsScrolling then
						targetPlayer = player
						targetLabel.Text = "Target: " .. player.Name
						targetLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
					end
					pBtnDragStart = nil
				end
			end)
		end
	end
end
updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(function(player)
	if targetPlayer == player then
		targetPlayer = nil
		targetLabel.Text = "Target: None"
		targetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	end
	updatePlayerList()
end)

-- [ TELEPORT LOGIC & OTHERS (LAYOUT ORDER SHIFTED + 3) ]
local function teleportToTarget()
	if not targetPlayer or not targetPlayer.Character then return end
	local targetPivot = targetPlayer.Character:GetPivot()
	local char = LocalPlayer.Character
	if not char then return end
	local hum = char:FindFirstChild("Humanoid")
	if hum and hum.SeatPart then
		local vehicle = hum.SeatPart:FindFirstAncestorOfClass("Model")
		if vehicle and vehicle.PrimaryPart then vehicle:PivotTo(targetPivot); return end
	end
	char:PivotTo(targetPivot)
end

createButton("Teleport", 4, teleportToTarget)
createButton("Auto TP: OFF", 5, function(btn)
	autoTpEnabled = not autoTpEnabled
	if autoTpEnabled then
		btn.Text = "Auto TP: ON"; btn.TextColor3 = Color3.fromRGB(0, 255, 0)
		autoTpConnection = RunService.Heartbeat:Connect(teleportToTarget)
	else
		btn.Text = "Auto TP: OFF"; btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		if autoTpConnection then autoTpConnection:Disconnect(); autoTpConnection = nil end
	end
end)

createButton("1. Rejoin Server", 6, function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
createButton("2. Hop Server", 7, function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
createButton("3. Hop Small Server", 8, function()
	pcall(function()
		if not game.HttpGet then return TeleportService:Teleport(game.PlaceId, LocalPlayer) end 
		local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=10"
		local data = game:GetService("HttpService"):JSONDecode(game:HttpGet(url))
		if data and data.data then
			for _, server in ipairs(data.data) do
				if server.playing < server.maxPlayers and server.id ~= game.JobId then
					TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer); return
				end
			end
		end
	end)
end)

createButton("🛸 Toggle Fly: OFF", 9, function(btn)
	flyEnabled = not flyEnabled
	btn.Text = "🛸 Toggle Fly: " .. (flyEnabl
