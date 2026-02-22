 _______                                      
 \      \    ____  __ __ ___.__. ____   ____  
 /   |   \  / ___\|  |  <   |  |/ __ \ /    \ 
/    |    \/ /_/  >  |  /\___  \  ___/|   |  \
\____|__  /\___  /|____/ / ____|\___  >___|  /
        \//_____/        \/         \/     \/ 

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local ProximityPromptService = game:GetService("ProximityPromptService") -- Đã thêm service tương tác
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- // LOGIC FPS
local FPS = {}
local sec = tick()

-- // CẤU HÌNH GỐC (SINGLE SOURCE OF TRUTH)
local Config = {
    ForceResetKey = true,
    Aimbot = false, 
    Smoothness = 1, 
    Bind = Enum.UserInputType.MouseButton2,
    TeamCheck = false, 
    WallCheck = false,
    KillAura = false, 
    KillAuraRange = 20, 
    TriggerBot = false, 
    TriggerDelay = 0.05, 
    SpinBot = false, 
    SpinSpeed = 20,
    HitboxExpander = false, 
    HitboxPart = "Head", 
    HitboxSize = 15,
    WallHackChams = false, 
    EspHighlight = false, 
    ChamsTransparency = 0.5,
    RainbowMode = false, 
    RainbowSpeed = 1, 
    SelectedColorR = 255, 
    SelectedColorG = 255, 
    SelectedColorB = 255,
    FOV = 70, 
    InfiniteZoom = true,
    Speed = false, 
    SpeedVal = 25, 
    JumpBypass = false, 
    JumpBypassPower = 50, 
    Bhop = false, 
    InfJump = false, 
    AntiAFK = true,
    Fly = false, 
    FlySpeed = 50,
    FlyFallSpeed = 0, -- Tốc độ rơi mặc định khi bay
    InstantInteract = false, -- Tương tác không cần giữ phím
    Noclip = false
}

local StartTime = os.time()
local function GetPlayTime()
    local s = os.time() - StartTime
    return string.format("%02d:%02d:%02d", math.floor(s/3600), math.floor((s%3600)/60), s%60)
end

-- ==========================================
-- // INSTANT INTERACT LOGIC (BACKEND)
-- ==========================================
ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if Config.InstantInteract then
        fireproximityprompt(prompt)
    end
end)

-- ==========================================
-- // SECURITY: FORCE DELETE SAVED KEY
-- ==========================================
-- Atlas UI thường lưu key trong thư mục Config của nó. 
-- Ta sẽ xóa nó trước khi load UI để ép nhập lại.
local configName = "Aimbot Recode"
pcall(function()
    if isfolder(configName) then
        -- Xóa file lưu key của Atlas (thường là Key.json hoặc tương tự)
        for _, file in ipairs(listfiles(configName)) do
            if file:find("key") or file:find("Key") then
                delfile(file)
            end
        end
    end
end)

-- ==========================================
-- // KHỞI TẠO ATLAS UI & KEY SYSTEM
-- ==========================================
local Atlas = loadstring(game:HttpGet("https://raw.githubusercontent.com/naibelgodd/roblox.lib/main/Atlas.lua"))()

local UI = Atlas.new({
    Name = "Aimbot Recode V36",
    ConfigFolder = "Aimbot Recode",
    Credit = "Nguyen dep zai",
    Color = Color3.fromRGB(150, 0, 255), 
    Bind = "P", 
    UseLoader = false, -- Phải để true để hiện bảng nhập Key
    FullName = "Aimbot Recode V36",
    CheckKey = function(inputtedKey)
        local secretKey = "w"
        if inputtedKey == secretKey then
            return true
        else
            return false
        end
    end,
    Discord = "https://discord.gg/pBk7fRaX"
})

-- ==========================================
-- // THIẾT LẬP CÁC TRANG (PAGES)
-- ==========================================
local combatPage = UI:CreatePage("Combat")
local visualPage = UI:CreatePage("Visuals")
local movePage = UI:CreatePage("Movement")
local checkPage = UI:CreatePage("Checks")
local universalPage = UI:CreatePage("Universal")
local settingPage = UI:CreatePage("Settings")

-- ==========================================
-- // PAGE 1: COMBAT
-- ==========================================
local auraSec = combatPage:CreateSection("Kill Aura")
auraSec:CreateToggle({
    Name = "Enable Kill Aura", 
    Flag = "KillAuraTgl", 
    Callback = function(v) Config.KillAura = v end
})
auraSec:CreateSlider({
    Name = "Aura Range", 
    Flag = "AuraRangeSld", 
    Min = 5, 
    Max = 50, 
    Default = 20, 
    Callback = function(v) Config.KillAuraRange = v end
})

local aimSec = combatPage:CreateSection("Aimbot")
aimSec:CreateToggle({
    Name = "Enable Aimbot", 
    Flag = "AimTgl", 
    Callback = function(v) Config.Aimbot = v end
})
aimSec:CreateSlider({
    Name = "Aim Smoothness", 
    Flag = "AimSmoothSld", 
    Min = 1, 
    Max = 10, 
    Default = 1, 
    Callback = function(v) Config.Smoothness = v end
})

local trigSec = combatPage:CreateSection("Triggerbot")
trigSec:CreateToggle({
    Name = "Trigger Bot", 
    Flag = "TrigTgl", 
    Callback = function(v) Config.TriggerBot = v end
})
trigSec:CreateSlider({
    Name = "Trigger Delay", 
    Flag = "TrigDelaySld", 
    Min = 0, 
    Max = 100, 
    Default = 5, 
    Callback = function(v) Config.TriggerDelay = v/100 end
})

local hitSec = combatPage:CreateSection("Hitbox")
hitSec:CreateToggle({
    Name = "Hitbox Expander", 
    Flag = "HitTgl", 
    Callback = function(v) Config.HitboxExpander = v end
})
hitSec:CreateDropdown({
    Name = "Hitbox Part", 
    Options = {"Head", "Torso", "HumanoidRootPart"}, 
    DefaultItemSelected = "Head", 
    Callback = function(v) Config.HitboxPart = v end
})
hitSec:CreateSlider({
    Name = "Hitbox Size", 
    Flag = "HitSizeSld", 
    Min = 2, 
    Max = 50, 
    Default = 15, 
    Callback = function(v) Config.HitboxSize = v end
})

-- ==========================================
-- // PAGE 2: VISUALS
-- ==========================================
local espSec = visualPage:CreateSection("Chams & ESP")
espSec:CreateToggle({
    Name = "WallHack Chams", 
    Flag = "ChamTgl", 
    Callback = function(v) Config.WallHackChams = v end
})
espSec:CreateSlider({
    Name = "Chams Transparency", 
    Flag = "ChamTransSld", 
    Min = 0, 
    Max = 100, 
    Default = 50, 
    Callback = function(v) Config.ChamsTransparency = v/100 end
})
espSec:CreateToggle({
    Name = "Outline Highlight", 
    Flag = "HiTgl", 
    Callback = function(v) Config.EspHighlight = v end
})

local colorSec = visualPage:CreateSection("Color Settings")
colorSec:CreateColorPicker({
    Name = "ESP Color", 
    Flag = "ESPColor", 
    Default = Color3.fromRGB(255,255,255), 
    Callback = function(color) 
        Config.SelectedColorR = math.floor(color.R * 255)
        Config.SelectedColorG = math.floor(color.G * 255)
        Config.SelectedColorB = math.floor(color.B * 255)
    end
})
colorSec:CreateToggle({
    Name = "Rainbow Mode", 
    Flag = "RGBMode", 
    Callback = function(v) Config.RainbowMode = v end
})
colorSec:CreateSlider({
    Name = "Rainbow Speed", 
    Flag = "RGBSpeed", 
    Min = 1, 
    Max = 10, 
    Default = 1, 
    Callback = function(v) Config.RainbowSpeed = v end
})

local worldSec = visualPage:CreateSection("World & Camera")
worldSec:CreateToggle({
    Name = "Infinite Zoom", 
    Flag = "InfZoomTgl", 
    Default = true, 
    Callback = function(v) Config.InfiniteZoom = v end
})
worldSec:CreateSlider({
    Name = "Camera FOV", 
    Flag = "FovSld", 
    Min = 70, 
    Max = 120, 
    Default = 70, 
    Callback = function(v) 
        Config.FOV = v
        Camera.FieldOfView = v 
    end
})

-- ==========================================
-- // PAGE 3: MOVEMENT
-- ==========================================
local noclipSec = movePage:CreateSection("Noclip Bypass")
noclipSec:CreateToggle({
    Name = "Enable Noclip Bypass (Bind X)", 
    Flag = "NoclipTgl", 
    Callback = function(v) Config.Noclip = v end
})

local speedSec = movePage:CreateSection("Speed & Jump")
speedSec:CreateToggle({
    Name = "Speed Bypass (Bind Z)", 
    Flag = "SpdTgl", 
    Callback = function(v) Config.Speed = v end
})
speedSec:CreateSlider({
    Name = "Speed Value", 
    Flag = "SpdValSld", 
    Min = 16, 
    Max = 500, 
    Default = 25, 
    Callback = function(v) Config.SpeedVal = v end
})
speedSec:CreateToggle({
    Name = "Jump Power Bypass", 
    Flag = "JmpTgl", 
    Callback = function(v) Config.JumpBypass = v end
})
speedSec:CreateSlider({
    Name = "Jump Value", 
    Flag = "JmpValSld", 
    Min = 50, 
    Max = 500, 
    Default = 50, 
    Callback = function(v) Config.JumpBypassPower = v end
})

local flySec = movePage:CreateSection("Fly & Others")
flySec:CreateToggle({
    Name = "Enable Fly Bypass", 
    Flag = "FlyTgl", 
    Callback = function(v) Config.Fly = v end
})
flySec:CreateSlider({
    Name = "Fly Speed", 
    Flag = "FlySpdSld", 
    Min = 10, 
    Max = 500, 
    Default = 50, 
    Callback = function(v) Config.FlySpeed = v end
})
flySec:CreateSlider({
    Name = "Fly Fall Speed (Tốc độ rơi)", 
    Flag = "FlyFallSld", 
    Min = 0, 
    Max = 50, 
    Default = 0, 
    Callback = function(v) Config.FlyFallSpeed = v end
})
flySec:CreateToggle({
    Name = "Infinite Jump", 
    Flag = "InfJmpTgl", 
    Callback = function(v) Config.InfJump = v end
})
flySec:CreateToggle({
    Name = "Bunny Hop", 
    Flag = "BhopTgl", 
    Callback = function(v) Config.Bhop = v end
})
flySec:CreateToggle({
    Name = "Spin Bot", 
    Flag = "SpinTgl", 
    Callback = function(v) Config.SpinBot = v end
})
flySec:CreateSlider({
    Name = "Spin Speed", 
    Flag = "SpinSpdSld", 
    Min = 1, 
    Max = 100, 
    Default = 20, 
    Callback = function(v) Config.SpinSpeed = v end
})

-- ==========================================
-- // PAGE 4: CHECKS
-- ==========================================
local globalCheckSec = checkPage:CreateSection("Target Checks")
globalCheckSec:CreateToggle({
    Name = "Team Check", 
    Flag = "TeamChkTgl", 
    Callback = function(v) Config.TeamCheck = v end
})
globalCheckSec:CreateToggle({
    Name = "Wall Check (Aimbot)", 
    Flag = "WallChkTgl", 
    Callback = function(v) Config.WallCheck = v end
})

-- ==========================================
-- // PAGE 5: UNIVERSAL (WAYPOINT & INTERACT BYPASS)
-- ==========================================
local interactSec = universalPage:CreateSection("World Interaction")

-- Hàm xử lý ép thời gian chờ về 0
local function BypassPrompt(prompt)
    if prompt:IsA("ProximityPrompt") then
        -- Lưu lại thời gian gốc để có thể tắt tính năng
        if not prompt:GetAttribute("OriginalHold") then
            prompt:SetAttribute("OriginalHold", prompt.HoldDuration)
        end
        
        if Config.InstantInteract then
            prompt.HoldDuration = 0
        end

        -- Chống game tự động reset lại HoldDuration
        prompt:GetPropertyChangedSignal("HoldDuration"):Connect(function()
            if Config.InstantInteract and prompt.HoldDuration ~= 0 then
                prompt.HoldDuration = 0
            end
        end)
    end
end

-- Áp dụng cho các Prompt đã có sẵn trong map
for _, obj in pairs(workspace:GetDescendants()) do
    BypassPrompt(obj)
end

-- Lắng nghe và tự động áp dụng cho các Prompt mới được sinh ra (như Spawn Machine mới)
workspace.DescendantAdded:Connect(function(obj)
    BypassPrompt(obj)
end)

interactSec:CreateToggle({
    Name = "Instant Interact (Bỏ giữ nút E)", 
    Flag = "InstInteractTgl", 
    Callback = function(v) 
        Config.InstantInteract = v 
        -- Cập nhật tức thời toàn bộ map khi bật/tắt
        for _, prompt in pairs(workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then
                if v then
                    prompt.HoldDuration = 0
                else
                    -- Trả lại thời gian gốc nếu tắt
                    local orig = prompt:GetAttribute("OriginalHold")
                    if orig then prompt.HoldDuration = orig end
                end
            end
        end
    end
})

local wpSec = universalPage:CreateSection("Waypoint Manager")

local Waypoints = {}
local CurrentWpName = ""
local SelectedWp = "Empty"

local function GetWaypointList()
    local l = {}
    for k, _ in pairs(Waypoints) do table.insert(l, k) end
    return #l > 0 and l or {"Empty"}
end

wpSec:CreateTextBox({
    Name = "Waypoint Name", 
    Flag = "WpNameBox", 
    DefaultText = "", 
    PlaceholderText = "Nhập tên Waypoint...",
    Callback = function(t) CurrentWpName = t end
})

local wpDrop
wpSec:CreateButton({
    Name = "Set Waypoint (Lưu vị trí hiện tại)", 
    Callback = function()
        if CurrentWpName ~= "" and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Waypoints[CurrentWpName] = LocalPlayer.Character.HumanoidRootPart.CFrame
            UI:Notify({Title="Waypoint", Content="Đã lưu vị trí: " .. CurrentWpName})
            if wpDrop then wpDrop:Update(GetWaypointList()) end
        else
            UI:Notify({Title="Lỗi", Content="Vui lòng nhập tên Waypoint hoặc đợi nhân vật Spawn."})
        end
    end
})

wpDrop = wpSec:CreateDropdown({
    Name = "List Waypoint", 
    Options = GetWaypointList(),
    Callback = function(v) SelectedWp = v end
})

wpSec:CreateButton({
    Name = "TP To Waypoint", 
    Callback = function()
        if SelectedWp ~= "Empty" and SelectedWp ~= "" and Waypoints[SelectedWp] then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = Waypoints[SelectedWp] + Vector3.new(0, 3, 0)
                UI:Notify({Title="Teleport", Content="Đã bay tới: " .. SelectedWp})
            end
        else
            UI:Notify({Title="Lỗi", Content="Waypoint không tồn tại."})
        end
    end
})

wpSec:CreateButton({
    Name = "Del Waypoint", 
    Callback = function()
        if SelectedWp ~= "Empty" and SelectedWp ~= "" and Waypoints[SelectedWp] then
            Waypoints[SelectedWp] = nil
            UI:Notify({Title="Waypoint", Content="Đã xóa: " .. SelectedWp})
            SelectedWp = "Empty"
            if wpDrop then wpDrop:Update(GetWaypointList()) end
        end
    end
})

-- ==========================================
-- // PAGE 6: SETTINGS
-- ==========================================
local statusSec = settingPage:CreateSection("System Status")
local st_time = statusSec:CreateParagraph("Playtime: 00:00:00")
local st_fps = statusSec:CreateParagraph("FPS: Calculating...")
local st_ping = statusSec:CreateParagraph("Ping: 0 ms")
local st_player = statusSec:CreateParagraph("Players: 0")

local serverSec = settingPage:CreateSection("Server Management")
serverSec:CreateButton({
    Name = "Rejoin Server", 
    Callback = function() 
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) 
    end
})
serverSec:CreateButton({
    Name = "Small Server Hop", 
    Callback = function()
        local success, result = pcall(function() 
            return game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100") 
        end)
        if success then
            local data = HttpService:JSONDecode(result)
            local targetServer = nil
            local minPlayers = math.huge
            for _, s in pairs(data.data) do
                if s.playing < minPlayers and s.playing > 0 and s.id ~= game.JobId then
                    minPlayers = s.playing
                    targetServer = s.id
                end
            end
            if targetServer then 
                TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServer, LocalPlayer) 
            end
        end
    end
})

local confSec = settingPage:CreateSection("Configuration Manager")
local ConfigFolder = "Atlas_Polo_Configs"
if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end
local ConfigNameInput = ""
local SelectedConfig = "Empty"

local function GetConfigList() 
    local l = {} 
    for _,f in ipairs(listfiles(ConfigFolder)) do 
        local name = f:match("([^/\\]+)%.json$")
        if name then table.insert(l, name) end 
    end 
    return #l > 0 and l or {"Empty"}
end

confSec:CreateTextBox({
    Name = "Config Name", 
    Flag = "ConfNameBox", 
    DefaultText = "", 
    PlaceholderText = "Nhập tên cấu hình...",
    Callback = function(t) ConfigNameInput = t end
})

confSec:CreateButton({
    Name = "Save Config", 
    Callback = function()
        if ConfigNameInput ~= "" then
            writefile(ConfigFolder.."/"..ConfigNameInput..".json", HttpService:JSONEncode(Config))
            UI:Notify({Title="Saved", Content="Đã lưu cấu hình: " .. ConfigNameInput})
        end
    end
})

local confDrop = confSec:CreateDropdown({
    Name = "Select Config", 
    Options = GetConfigList(),
    Callback = function(v) SelectedConfig = v end
})

confSec:CreateButton({
    Name = "Load Config", 
    Callback = function()
        local p = ConfigFolder.."/"..SelectedConfig..".json"
        if isfile(p) then
            local d = HttpService:JSONDecode(readfile(p))
            for k,v in pairs(d) do Config[k] = v end
            UI:Notify({Title="Loaded", Content="Đã tải cấu hình. Bật lại Toggle trên UI để đồng bộ."})
        end
    end
})

confSec:CreateButton({
    Name = "Delete Config", 
    Callback = function()
        local p = ConfigFolder.."/"..SelectedConfig..".json"
        if isfile(p) then 
            delfile(p)
            confDrop:Update(GetConfigList())
            UI:Notify({Title="Deleted", Content="Đã xóa: " .. SelectedConfig})
        end
    end
})

confSec:CreateButton({
    Name = "Refresh List", 
    Callback = function()
        confDrop:Update(GetConfigList())
        UI:Notify({Title="Refreshed", Content="Đã làm mới danh sách config."})
    end
})

local miscSec = settingPage:CreateSection("Miscellaneous")
miscSec:CreateToggle({
    Name = "Anti-AFK", 
    Flag = "AfkTgl", 
    Default = true, 
    Callback = function(v) Config.AntiAFK = v end
})

miscSec:CreateButton({
    Name = "Fast Mode (Chỉ xóa bóng và giảm chất lượng)", 
    Callback = function()
        Lighting.GlobalShadows = false
        settings().Rendering.QualityLevel = 1
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                v.Material = Enum.Material.SmoothPlastic
            end
        end
        UI:Notify({Title="Fast Mode", Content="Đã bật đồ họa cơ bản!"})
    end
})

miscSec:CreateButton({
    Name = "Super Fast Mode (Xóa sạch Texture, Decal, Hiệu ứng)", 
    Callback = function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        settings().Rendering.QualityLevel = 1
        
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("Clouds") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") then
                v:Destroy()
            end
        end

        if workspace:FindFirstChild("Terrain") then
            workspace.Terrain.Decoration = false
            workspace.Terrain.WaterWaveSize = 0
            workspace.Terrain.WaterWaveSpeed = 0
            workspace.Terrain.WaterReflectance = 0
            workspace.Terrain.WaterTransparency = 0
        end

        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                v.Material = Enum.Material.SmoothPlastic
                v.CastShadow = false
            elseif v:IsA("Texture") or v:IsA("Decal") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Sparkles") or v:IsA("Smoke") or v:IsA("Fire") then
                v:Destroy()
            end
        end
        UI:Notify({Title="Super Fast Mode", Content="Potato PC mode activated!"})
    end
})

-- ==========================================
-- // HỆ THỐNG LOGIC LÕI & BACKEND
-- ==========================================

local function IsValidTarget(p)
    if p == LocalPlayer then return false end
    if not p.Character then return false end
    local hum = p.Character:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return false end 
    if Config.TeamCheck and p.Team == LocalPlayer.Team then return false end 
    return true
end

local function IsVisible(targetPart)
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.IgnoreWater = true
    
    local result = workspace:Raycast(origin, direction, rayParams)
    if result and result.Instance then
        if result.Instance:IsDescendantOf(targetPart.Parent) then 
            return true 
        else 
            return false 
        end
    end
    return true
end

local function CleanESP(char)
    if not char then return end
    for _, v in pairs(char:GetDescendants()) do
        if v.Name == "PoloCham" or v.Name == "PoloHL" then 
            v:Destroy() 
        end
    end
end

RunService.Stepped:Connect(function()
    if Config.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then 
                part.CanCollide = false 
            end
        end
    end
end)

-- ==========================================
-- // KILL AURA LOGIC REWRITE
-- ==========================================
task.spawn(function()
    while task.wait(0.1) do
        if Config.KillAura and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local closestTarget = nil
            local shortestDistance = Config.KillAuraRange
            
            for _, p in pairs(Players:GetPlayers()) do
                if IsValidTarget(p) and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if dist <= shortestDistance then
                        shortestDistance = dist
                        closestTarget = p.Character
                    end
                end
            end
            
            if closestTarget then
                local myRoot = LocalPlayer.Character.HumanoidRootPart
                local targetPos = closestTarget.HumanoidRootPart.Position
                
                myRoot.CFrame = CFrame.lookAt(myRoot.Position, Vector3.new(targetPos.X, myRoot.Position.Y, targetPos.Z))
                
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                else
                    pcall(function() VirtualUser:ClickButton1(Vector2.new(0, 0)) end)
                    pcall(function() mouse1click() end)
                end
            end
        end
    end
end)

local function UpdateVisuals()
    pcall(function()
        for _, p in pairs(Players:GetPlayers()) do
            if IsValidTarget(p) then
                local char = p.Character
                local color = Config.RainbowMode and Color3.fromHSV(tick() * (Config.RainbowSpeed / 2) % 1, 1, 1) or Color3.fromRGB(Config.SelectedColorR, Config.SelectedColorG, Config.SelectedColorB)
                
                if Config.WallHackChams then
                    for _, bp in pairs(char:GetChildren()) do
                        if bp:IsA("BasePart") and bp.Transparency < 1 then
                            local cham = bp:FindFirstChild("PoloCham") or Instance.new("BoxHandleAdornment", bp)
                            cham.Name = "PoloCham"
                            cham.Adornee = bp
                            cham.AlwaysOnTop = true
                            cham.ZIndex = 10
                            cham.Size = bp.Size * 1.05
                            cham.Color3 = color
                            cham.Transparency = Config.ChamsTransparency
                            cham.Visible = true
                        end
                    end
                else
                    CleanESP(char)
                end

                local hl = char:FindFirstChild("PoloHL")
                if Config.EspHighlight then
                    if not hl then 
                        hl = Instance.new("Highlight", char)
                        hl.Name = "PoloHL"
                        hl.FillTransparency = 1
                        hl.OutlineTransparency = 0 
                    end
                    hl.OutlineColor = color
                    hl.Enabled = true
                else 
                    if hl then hl:Destroy() end 
                end
            else
                if p.Character then CleanESP(p.Character) end
            end
        end
    end)
end

RunService.RenderStepped:Connect(function()
    -- FPS
    local fr = tick()
    for index = #FPS, 1, -1 do FPS[index + 1] = (FPS[index] >= fr - 1) and FPS[index] or nil end
    FPS[1] = fr
    pcall(function() st_fps.Set("FPS: " .. math.floor((tick() - sec >= 1 and #FPS) or (#FPS / (tick() - sec)))) end)
    
    -- Zoom
    if Config.InfiniteZoom then LocalPlayer.CameraMaxZoomDistance = 999999 else LocalPlayer.CameraMaxZoomDistance = 128 end

    UpdateVisuals()

    -- SpinBot
    if Config.SpinBot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(Config.SpinSpeed * 5), 0)
    end

    -- Hitbox Logic
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local part = p.Character:FindFirstChild(Config.HitboxPart)
            if part and part:IsA("BasePart") then
                if Config.HitboxExpander and IsValidTarget(p) then
                    part.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                    part.Transparency = 0.7
                    part.CanCollide = false
                    part.Massless = true
                elseif part.Size.X > 5 then
                    if part.Name == "Head" then part.Size = Vector3.new(1.2, 1, 1) 
                    elseif part.Name == "Torso" then part.Size = Vector3.new(2, 2, 1)
                    elseif part.Name == "HumanoidRootPart" then part.Size = Vector3.new(2, 2, 1) end
                    part.Transparency = (part.Name == "HumanoidRootPart") and 1 or 0
                    part.Massless = false
                end
            end
        end
    end

    -- Aimbot với Wall Check
    if Config.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target, dist = nil, math.huge
        for _, v in pairs(Players:GetPlayers()) do
            if IsValidTarget(v) then
                local tPart = v.Character:FindFirstChild("Head")
                if tPart then
                    if not Config.WallCheck or IsVisible(tPart) then
                        local pos, vis = Camera:WorldToViewportPoint(tPart.Position)
                        if vis then
                            local m = (Vector2.new(pos.X, pos.Y) - (Camera.ViewportSize/2)).Magnitude
                            if m < dist then 
                                dist = m
                                target = v.Character 
                            end
                        end
                    end
                end
            end
        end
        if target then Camera.CFrame = Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position, target.Head.Position), 1/Config.Smoothness) end
    end

    -- Fly Bypass Update (Có Vertical Velocity tùy chỉnh)
    if Config.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        local vel = LocalPlayer.Character.Humanoid.MoveDirection * Config.FlySpeed
        
        -- Áp dụng hướng âm cho trục Y khi rơi để mô phỏng trọng lực nhân tạo
        local yVel = -Config.FlyFallSpeed 
        
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then 
            yVel = Config.FlySpeed 
        elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then 
            yVel = -Config.FlySpeed 
        end
        root.AssemblyLinearVelocity = Vector3.new(vel.X, yVel, vel.Z)
    end
end)

-- Vòng lặp Heartbeat
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
        local hum = char.Humanoid
        local root = char.HumanoidRootPart
        
        -- Speed
        if Config.Speed and not Config.Fly and hum.MoveDirection.Magnitude > 0 then
            root.AssemblyLinearVelocity = Vector3.new(hum.MoveDirection.X * Config.SpeedVal, root.AssemblyLinearVelocity.Y, hum.MoveDirection.Z * Config.SpeedVal)
        end
        
        -- Jump
        if Config.JumpBypass then 
            hum.UseJumpPower = true
            hum.JumpPower = Config.JumpBypassPower 
        end
        
        -- Bhop
        if Config.Bhop and hum.FloorMaterial ~= Enum.Material.Air and hum.MoveDirection.Magnitude > 0 then 
            hum:ChangeState(Enum.HumanoidStateType.Jumping) 
        end
    end
end)

-- Events
UserInputService.JumpRequest:Connect(function()
    if Config.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end
end)

-- // MACRO BIND: NHẤN Z ĐỂ TOGGLE SPEED, NHẤN X ĐỂ TOGGLE NOCLIP
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Z then
        Config.Speed = not Config.Speed
        UI:Notify({Title = "Bind", Content = "Speed Bypass: " .. (Config.Speed and "BẬT" or "TẮT")})
    elseif input.KeyCode == Enum.KeyCode.X then
        Config.Noclip = not Config.Noclip
        UI:Notify({Title = "Bind", Content = "Noclip Bypass: " .. (Config.Noclip and "BẬT" or "TẮT")})
    elseif input.KeyCode == Enum.KeyCode.B then
        Config.Fly = not Config.Fly
        UI:Notify({Title = "Bind", Content = "Fly Bypass: " .. (Config.Fly and "BẬT" or "TẮT")})
    end
end)

-- Loop Status
task.spawn(function()
    while true do
        pcall(function()
            st_time.Set("Playtime: " .. GetPlayTime())
            st_ping.Set("Ping: " .. math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) .. " ms")
            st_player.Set("Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers)
        end)
        task.wait(1)
    end
end)

UI:Notify({
    Title = "Authentication Success", 
    Content = "Xác thực thành công. Cảm ơn bạn đã sử dụng."
})
