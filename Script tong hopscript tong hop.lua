local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Script Tổng Hợp FB: Đó Ai", "DarkTheme")

local Tab = Window:NewTab("Blox Fruit")
local Section = Tab:NewSection("Bloxfruit")

Section:NewButton("Redz", "Redz", function()
   loadstring(game:HttpGet("https://github.com/LuaCrack/Min/raw/main/MinUp27Vn"))()
end)

local Section = Tab:NewSection("+1 block every second")

Section:NewButton("+1 block every second", "Redz", function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/naibelgodd/aim/main/%2B1-Blocks-Every-Second.lua"))()
end)

local Tab = Window:NewTab("Universal")
local Section = Tab:NewSection("Script")

Section:NewButton("EdgeIY", "You can flyyyyyyy", function()
   loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

Section:NewButton("HitBox", "Push", function()
   loadstring(game:HttpGet("https://rscripts.net/raw/universal-hitbox-v10-open-source_1733529165192_LIstHcFlfK.txt",true))()
end)

Section:NewButton("NebulaX", "Key need", function()
   loadstring(game:HttpGet("https://rscripts.net/raw/universal-hitbox-v10-open-source_1733529165192_LIstHcFlfK.txt",true))()
end)

Section:NewTextBox("NebulaX Key", "Fp1BR4Y6x3", function(txt)
	print(txt)
end)

Section:NewKeybind("Toggle to hide gui", "KeybindInfo", Enum.KeyCode.F, function()
	Library:ToggleUI()
end)
