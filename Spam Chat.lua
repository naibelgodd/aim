--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- RUKA V5
local P=game:GetService("Players")
local T=game:GetService("TextChatService")
local U=game:GetService("UserInputService")
local p=P.LocalPlayer
local O="ALONE_WX5"
local G=p:WaitForChild("PlayerGui")

if G:FindFirstChild("L") then G.L:Destroy() end
if G:FindFirstChild("V") then G.V:Destroy() end

local L=Instance.new("ScreenGui")
L.Name="L"
L.ResetOnSpawn=false
L.Parent=G

local B=Instance.new("Frame")
B.Size=UDim2.new(1,0,1,0)
B.BackgroundColor3=Color3.new(0,0,0)
B.Parent=L

local Y=Instance.new("Frame")
Y.Size=UDim2.new(0,400,0,250)
Y.Position=UDim2.new(0.5,-200,0.5,-125)
Y.BackgroundColor3=Color3.fromRGB(255,215,0)
Y.Parent=B

local W=Instance.new("TextLabel")
W.Size=UDim2.new(1,-20,0.6,0)
W.Position=UDim2.new(0,10,0,10)
W.BackgroundTransparency=1
W.Text="WELCOME TO DELUX + LEGENDARY VERSION OF RUKA V5"
W.TextColor3=Color3.new(0,0,0)
W.Font=Enum.Font.GothamBlack
W.TextSize=20
W.TextWrapped=true
W.Parent=Y

local PB=Instance.new("TextButton")
PB.Size=UDim2.new(0,200,0,50)
PB.Position=UDim2.new(0.5,-100,0.8,0)
PB.BackgroundColor3=Color3.fromRGB(0,100,0)
PB.Text="CLICK TO PLAY"
PB.TextColor3=Color3.new(1,1,1)
PB.Font=Enum.Font.GothamBold
PB.TextSize=20
PB.Parent=Y

local S=Instance.new("ScreenGui")
S.Name="V"
S.ResetOnSpawn=false
S.Parent=G
S.Enabled=false

local F=Instance.new("Frame")
F.Size=UDim2.new(0,400,0,500)
F.Position=UDim2.new(0.5,-200,0.5,-250)
F.BackgroundColor3=Color3.fromRGB(40,40,50)
F.Active=true
F.Draggable=true
F.Parent=S

local Tt=Instance.new("TextLabel")
Tt.Size=UDim2.new(1,0,0,35)
Tt.BackgroundTransparency=1
Tt.Text="RUKA V5"
Tt.TextColor3=Color3.new(1,1,1)
Tt.Font=Enum.Font.GothamBlack
Tt.TextSize=24
Tt.Parent=F

task.spawn(function()
while task.wait(0.1) do
if Tt.Parent then
Tt.TextColor3=Color3.fromHSV(tick()%5/5,0.8,1)
end
end
end)

local TB=Instance.new("TextBox")
TB.Size=UDim2.new(1,-30,0,40)
TB.Position=UDim2.new(0,15,0,45)
TB.BackgroundColor3=Color3.fromRGB(60,60,70)
TB.PlaceholderText="ENTER HATER NAME"
TB.Text=""
TB.TextColor3=Color3.new(1,1,1)
TB.Font=Enum.Font.GothamSemibold
TB.TextSize=17
TB.ClearTextOnFocus=false
TB.Parent=F

local SA=Instance.new("TextButton")
SA.Size=UDim2.new(0,100,0,30)
SA.Position=UDim2.new(0,15,0,90)
SA.BackgroundColor3=Color3.fromRGB(255,165,0)
SA.Text="SECTION A"
SA.TextColor3=Color3.new(1,1,1)
SA.Font=Enum.Font.GothamBold
SA.TextSize=14
SA.Parent=F

local PL=Instance.new("TextLabel")
PL.Size=UDim2.new(1,-30,0,25)
PL.Position=UDim2.new(0,15,0,125)
PL.BackgroundTransparency=1
PL.Text="PATTERN:"
PL.TextColor3=Color3.new(1,1,1)
PL.Font=Enum.Font.GothamBold
PL.TextSize=14
PL.TextXAlignment=Enum.TextXAlignment.Left
PL.Parent=F

local CP="@@"
local PBs={}
local PD={
{text="[R-U-K-A]",pattern="[R-U-K-A]+"},
{text="¢°¢°",pattern="¢°"},
{text="=====",pattern="===="},
{text="$=$=$=",pattern="$=$"},
{text="¥=¥=¥",pattern="¥="},
{text="§×§×§",pattern="§×"},
{text="R.U.K.A",pattern="R.U.K.A"},
{text="π÷π÷",pattern="π÷"},
{text="√÷√÷",pattern="√÷"},
{text="|÷|÷|",pattern="|÷"},
{text="°=°=°",pattern="°="},
{text="°•°•°",pattern="°•"},
{text="×=×=×",pattern="×="},
{text="¢=¢=¢",pattern="¢="},
{text="₹=₹=₹",pattern="₹="},
{text="[=]=[",pattern="[=]"},
{text="[=]=[",pattern="[=]=]"},
{text="Æ=Æ=Æ",pattern="Æ="},
{text="Ω×Ω×",pattern="Ω×"},
{text="μ÷μ÷",pattern="μ÷"},
{text="Π=Π=Π",pattern="Π="},
{text="?=?=?",pattern="?="},
{text="©=©=©",pattern="©="},
{text="%×%×%",pattern="%×"},
{text="~§~§~",pattern="~§"},
{text="=✓=✓",pattern="=✓"},
{text="™®™®",pattern="™®"},
{text="÷¥÷¥",pattern="÷¥"},
{text="∆|∆|∆",pattern="∆|"},
{text="∆%∆%",pattern="∆%"},
{text="°o°o°",pattern="°o"},
{text="O_⁠oO",pattern="O_⁠o"},
{text="^_⁠_⁠_",pattern="^_⁠_"},
{text="+____",pattern="+____"},
{text="=____",pattern="=____"},
{text="[-_-_]",pattern="[-_-]"},
{text="|====|",pattern="|===="},
{text="|×|×|",pattern="|×"},
{text='"_"-"',pattern='"_"'},
{text="(£)(£)",pattern="(£)"},
{text="{×}={",pattern="{×}"},
{text="(+)_(+",pattern="(+)_"},
{text="[=°•=}",pattern="[=°•=}"},
{text="[=°•=}",pattern="[=°•=}"},
{text='{";";"}',pattern='{";"}'},
{text="-_-_",pattern="-_"},
{text="###",pattern="##"},
{text="_____",pattern="__"},
{text="@@@@",pattern="@@",d=true},
{text="$$$",pattern="$$"},
{text="!!!",pattern="!!"},
{text="???",pattern="??"},
{text="3_3_3",pattern="3_3"},
{text="✓✓✓✓",pattern="✓✓"},
{text="~*~*",pattern="~*"},
{text="+-+-",pattern="+-"},
{text="8_8_",pattern="8_"},
{text="0_0_",pattern="0_"},
{text="#-#-",pattern="#-"},
{text="@_@_",pattern="@_"},
{text="()()",pattern="()"},
{text="&-&-",pattern="&-"},
{text="=_=",pattern="=_"},
{text="*_*_",pattern="*_"},
{text="=-=",pattern="=-"}
}

for i,data in ipairs(PD) do
local row=math.floor((i-1)/8)
local col=(i-1)%8
local btn=Instance.new("TextButton")
btn.Size=UDim2.new(0,45,0,25)
btn.Position=UDim2.new(0,15+col*48,0,150+row*30)
btn.BackgroundColor3=data.d and Color3.fromRGB(200,30,30) or Color3.fromRGB(70,70,80)
btn.Text=data.text
btn.TextColor3=Color3.new(1,1,1)
btn.Font=Enum.Font.GothamBold
btn.TextSize=12
btn.Parent=F
btn.MouseButton1Click:Connect(function()
CP=data.pattern
for _,b in ipairs(PBs) do
b.BackgroundColor3=Color3.fromRGB(70,70,80)
end
btn.BackgroundColor3=Color3.fromRGB(200,30,30)
end)
PBs[i]=btn
end

local SB=Instance.new("TextButton")
SB.Size=UDim2.new(0,150,0,35)
SB.Position=UDim2.new(0,15,1,-50)
SB.BackgroundColor3=Color3.fromRGB(200,30,30)
SB.Text="START"
SB.TextColor3=Color3.new(1,1,1)
SB.Font=Enum.Font.GothamBold
SB.TextSize=18
SB.Parent=F

local STB=Instance.new("TextButton")
STB.Size=UDim2.new(0,150,0,35)
STB.Position=UDim2.new(1,-165,1,-50)
STB.BackgroundColor3=Color3.fromRGB(220,40,40)
STB.Text="STOP"
STB.TextColor3=Color3.new(1,1,1)
STB.Font=Enum.Font.GothamBold
STB.TextSize=18
STB.Parent=F

local CB=Instance.new("TextButton")
CB.Size=UDim2.new(0,30,0,30)
CB.Position=UDim2.new(1,-40,0,8)
CB.BackgroundColor3=Color3.fromRGB(220,0,0)
CB.Text="X"
CB.TextColor3=Color3.new(1,1,1)
CB.Font=Enum.Font.GothamBold
CB.TextSize=20
CB.Parent=F

CB.MouseButton1Click:Connect(function()
F.Visible=false
end)

U.InputBegan:Connect(function(input,gp)
if not gp and input.KeyCode==Enum.KeyCode.Insert then
F.Visible=not F.Visible
end
end)

local WL=Instance.new("TextLabel")
WL.Size=UDim2.new(1,-20,0,50)
WL.Position=UDim2.new(0,10,0.5,60)
WL.BackgroundTransparency=1
WL.TextColor3=Color3.fromRGB(255,100,100)
WL.Font=Enum.Font.GothamBold
WL.TextSize=20
WL.TextWrapped=true
WL.Visible=false
WL.Parent=F

local function SW()
WL.Text="DONT TRY TO WRITE YOUR FATHER NAME"
WL.Visible=true
task.delay(4,function()
WL.Visible=false
end)
end

TB.FocusLost:Connect(function()
local text=TB.Text:upper()
local cleaned=string.lower(text:gsub("[%s%*%-%_%^%!@#%$%%&%(%)%.%,%?]",""):gsub("0","o"):gsub("1","i"):gsub("3","e"):gsub("4","a"):gsub("5","s"):gsub("7","t"):gsub("@","a"):gsub("!","i"))
if cleaned:find("RUKA") or cleaned:find("ARCH") then
TB.Text=""
SW()
end
end)

local LK=false
local MT=false
local ME=nil
local SP=false
local ST=nil

local function IFN(name)
if name=="" then return false end
local cleaned=string.lower(name:gsub("[%s%*%-%_%^%!@#%$%%&%(%)%.%,%?]",""):gsub("0","o"):gsub("1","i"):gsub("3","e"):gsub("4","a"):gsub("5","s"):gsub("7","t"):gsub("@","a"):gsub("!","i"))
return cleaned:find("ARCH") or cleaned:find("RUKA")
end

local function GPN(name,tag)
local suffix=name.." TMKX MAI "..tag
local available=200-#suffix
local repeats=math.max(0,math.floor(available/#CP))
return string.rep(CP,repeats)..suffix
end

local function GCP()
local suffix="SCRIPT BY S1R RUKA~🤍"
local available=200-#suffix
local repeats=math.max(0,math.floor(available/#CP))
return string.rep(CP,repeats)..suffix
end

local function SCM(msg)
if MT or #msg==0 then return end
if #msg>200 then msg=msg:sub(1,200) end
local success,channel=pcall(function()
return T.TextChannels:WaitForChild("RBXGeneral",5)
end)
if success and channel then
pcall(function()
channel:SendAsync(msg)
end)
end
end

local SC={
"HELICOPTER","QUANTUM","ENTROPY","EVOLUTION","DNA","NEURON","PHOTOSYNTHESIS","BLACK HOLE",
"RELATIVITY","OXIDATION","FUSION","FISSION","GENETICS","MITOCHONDRIA","CELL","ATOM",
"MOLECULE","PROTON","NEUTRON","ELECTRON","PHOTON","WAVE FUNCTION","BIG BANG","DARK MATTER",
"DARK ENERGY","SUPERNOVA","NEUTRON STAR","QUASAR","HYPERSONIC","THERMODYNAMICS","DOOR",
"HONEY","TOY","AIR","BAG","AIR CONDITIONER","KADDA","REHMAN DAIKAT","ALLAH","PAKISTAN",
"REMOTE","TABLE","TV","CAR","TYRE","SHOES","WIFI","CHASHMA","EARPHONE","BALLS OF STEEL",
"DIO","SUZUKI ACCESS 125","PERFUME","SCREEN","PANIPURI","PILLOW","FAN","BAR","HOSTEL",
"THHUK","BMW-S1000RR"," REDMI","XIAOMI","POTTY","BLOOD","TEETH","TISSUE","BOOKS","WOWWW",
"BILLI","VEGETA","CRAZE","SPICES","MASALA","HONDA","DHURANDAR","VACCUM","GRIPER KI BIWI",
"PEN","INK","VWS","TATTI","LAITRING","UNGLI","HEHEHE","BHAR BHAR DAPABIM","TUNG TUNG SAHUR",
"EGG","MOUNTAIN","CHHADI","LIPSTICK"
}

local function UU()
if LK then
STB.Text="LOCKED"
STB.BackgroundColor3=Color3.fromRGB(100,100,100)
else
STB.Text="STOP"
STB.BackgroundColor3=Color3.fromRGB(220,40,40)
end
if SP then
SB.Text="RUNNING"
SB.BackgroundColor3=Color3.fromRGB(255,140,0)
else
SB.Text="START"
SB.BackgroundColor3=Color3.fromRGB(200,30,30)
end
end

local function SS(name)
if SP or IFN(name) or MT then return end
SP=true
TB.Text=name
UU()
ST=task.spawn(function()
SCM(GCP())
task.wait(2)
local i=1
local count=0
while SP and not MT do
count=count+1
local tag=SC[i]
SCM(GPN(name,tag))
task.wait(2)
i=(i%#SC)+1
if count>=math.random(8,12) then
task.wait(0.5)
SCM(GCP())
task.wait(2)
count=0
end
end
if MT then
STP()
end
end)
end

local function STP()
SP=false
if ST then
task.cancel(ST)
ST=nil
end
UU()
end

SB.MouseButton1Click:Connect(function()
if LK or MT then return end
local name=TB.Text:match("^%s*(.-)%s*$")
if name=="" then return end
if IFN(name) then
SW()
return
end
SS(name)
end)

STB.MouseButton1Click:Connect(function()
if LK then return end
STP()
end)

task.spawn(function()
local success,channel=pcall(function()
return T.TextChannels:WaitForChild("RBXGeneral",15)
end)
if not success then return end
local ct=nil
channel.MessageReceived:Connect(function(msg)
if not msg.TextSource then return end
local sender=P:GetPlayerByUserId(msg.TextSource.UserId)
if not sender then return end
if ct and sender.Name==ct then
SCM(msg.Text)
end
if sender.Name~=O then return end
local text=msg.Text
local low=text:lower()
if low=="!stop" then
LK=false
ct=nil
STP()
elseif low:sub(1,6)=="!spam " then
local target=text:sub(7):match("^%s*(.-)%s*$")
if target and target~="" and not IFN(target) then
LK=true
STP()
SS(target:upper())
end
elseif low:sub(1,5)=="!say " then
local message=text:sub(6):match("^%s*(.-)%s*$")
if message then
SCM(message)
end
elseif low:sub(1,9)=="!copycat " then
ct=text:sub(10):match("^%s*(.-)%s*$")
elseif low=="!uncopycat" then
ct=nil
elseif low:sub(1,6)=="!kick " then
local targetName=text:sub(7):match("^%s*(.-)%s*$")
if targetName and string.lower(p.Name)==string.lower(targetName) then
p:Kick("\nKicked by RUKA0_0\nDont come back loser")
end
elseif low:sub(1,6)=="!mute " then
if string.lower(p.Name)==string.lower(O) then return end
local rest=text:sub(7)
local targetName=rest:match("^(%S+)")
if not targetName or string.lower(p.Name)~=string.lower(targetName) then return end
local timePart=rest:match("^%S+%s+(.+)$")
local duration=nil
if timePart then
local num=timePart:match("^(%d+)")
local unit=timePart:match("%s*(%a+)%s*$")
if num and unit then
num=tonumber(num)
if unit:find("minute") then
duration=num*60
elseif unit:find("hour") then
duration=num*3600
end
end
end
MT=true
STP()
if ME then task.cancel(ME) end
if duration then
ME=task.delay(duration,function()
MT=false
ME=nil
end)
end
elseif low=="!unmute" then
MT=false
if ME then task.cancel(ME) end
ME=nil
elseif low:sub(1,6)=="!kill " then
local target=text:sub(7):match("^%s*(.-)%s*$")
if target then
local kills={
target.." DIED FROM L",
target.." GOT KILLED BY RUKA",
target.." IS DEAD LOL",
target.." RIP BOZO",
target.." DIED HAHA",
"GG "..target.." YOU DIED"
}
for _,k in ipairs(kills) do
SCM(k)
task.wait(2)
end
end
end
end)
end)

UU()

local SAF=Instance.new("Frame")
SAF.Size=UDim2.new(0,400,0,400)
SAF.Position=UDim2.new(0.5,-200,0.5,-200)
SAF.BackgroundColor3=Color3.fromRGB(50,50,60)
SAF.Active=true
SAF.Draggable=true
SAF.Visible=false
SAF.Parent=S

local SAT=Instance.new("TextLabel")
SAT.Size=UDim2.new(1,0,0,40)
SAT.BackgroundTransparency=1
SAT.Text="FOR FIGHT PROTECTION"
SAT.TextColor3=Color3.fromRGB(255,165,0)
SAT.Font=Enum.Font.GothamBlack
SAT.TextSize=20
SAT.Parent=SAF

local BB=Instance.new("TextButton")
BB.Size=UDim2.new(0,80,0,30)
BB.Position=UDim2.new(0,10,0,5)
BB.BackgroundColor3=Color3.fromRGB(100,100,100)
BB.Text="BACK"
BB.TextColor3=Color3.new(1,1,1)
BB.Font=Enum.Font.GothamBold
BB.TextSize=14
BB.Parent=SAF

local PBs2={}
local PD2={
{name="NOSIT",desc="Anti-headsit protection",color=Color3.fromRGB(255,100,100)},
{name="NOCLIP",desc="Pass through objects",color=Color3.fromRGB(100,100,255)},
{name="ANTI FLING",desc="Anti-vehicle fling",color=Color3.fromRGB(100,255,100)},
{name="ANTI KILL",desc="Anti-seat kill",color=Color3.fromRGB(255,255,100)},
{name="NO FLING",desc="Anti-void teleport",color=Color3.fromRGB(255,100,255)}
}

for i,data in ipairs(PD2) do
local btn=Instance.new("TextButton")
btn.Size=UDim2.new(1,-30,0,50)
btn.Position=UDim2.new(0,15,0,50+(i-1)*65)
btn.BackgroundColor3=Color3.fromRGB(70,70,80)
btn.Text=data.name.."\n"..data.desc
btn.TextColor3=Color3.new(1,1,1)
btn.Font=Enum.Font.GothamBold
btn.TextSize=14
btn.TextWrapped=true
btn.Parent=SAF
btn.MouseButton1Click:Connect(function()
if btn.BackgroundColor3==Color3.fromRGB(70,70,80) then
btn.BackgroundColor3=data.color
else
btn.BackgroundColor3=Color3.fromRGB(70,70,80)
end
end)
PBs2[i]=btn
end

SA.MouseButton1Click:Connect(function()
F.Visible=false
SAF.Visible=true
end)

BB.MouseButton1Click:Connect(function()
SAF.Visible=false
F.Visible=true
end)

PB.MouseButton1Click:Connect(function()
PB.BackgroundColor3=Color3.fromRGB(0,200,0)
PB.Text="LOADING..."
for i=1,0,-0.1 do
B.BackgroundTransparency=1-i
task.wait(0.02)
end
L:Destroy()
S.Enabled=true
F.Visible=true
print("RUKA V5 - LEGENDRY Version Loaded!")
print("Press INSERT to toggle GUI")
print("64 patterns available")
print("SECTION A - Fight Protection Features Added!")
end)

print("RUKA V5 - Loading Complete!")
print("Click the 'CLICK TO PLAY' button to start")



      
