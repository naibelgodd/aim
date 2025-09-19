local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()


local Window = Rayfield:CreateWindow({
   Name = "Naibell Hub FB: Đó Ai",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Create By Đó Ai",
   LoadingSubtitle = "Naibell",
   ShowText = "Naitheme", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Bloom", 

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Naibell Hub!!",
      Subtitle = "Submit The Key",
      Note = "This is the test version", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = false, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"naibellhub.lol"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

Rayfield:Notify({
   Title = "Notify",
   Content = "Thank For Your Using",
   Duration = 6.5,
   Image = 113664949755202,
})

local UniversalTab = Window:CreateTab("Universal", 4483362458) -- Title, Image

  local Button = UniversalTab:CreateButton({
   Name = "EdgeIY",
   Callback = function()
   loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))();
    end,
  })
  
  local Button = UniversalTab:CreateButton({
   Name = "Hitbox Note: Very op XD",
   Callback = function()
   loadstring(game:HttpGet("https://rscripts.net/raw/universal-hitbox-v10-open-source_1733529165192_LIstHcFlfK.txt",true))();
    end,
  })

  local Button = UniversalTab:CreateButton({
   Name = "NebulaX",
   Callback = function()
   loadstring(game:HttpGet("https://gist.githubusercontent.com/user2084375/a10f000d8b1a0aa75c0205feead68083/raw/c96fc1b8f430982b17fcd3390e3020f40300b8f5/gistfile1.txt"))();
    end,
  })

  local Button = UniversalTab:CreateButton({
   Name = "Fly Gui V3",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
    end,
  })

  local Button = UniversalTab:CreateButton({
   Name = "Noclip Gui",
   Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/naibelgodd/aim/main/Noclip%20Gui.lua"))();
    end,
  })

  local Button = UniversalTab:CreateButton({
   Name = "Invisible Gui",
   Callback = function()
   loadstring(game:HttpGet('https://abre.ai/invisible-v2'))();
    end,
  })

  local Button = UniversalTab:CreateButton({
   Name = "Sky",
   Callback = function()
   s = Instance.new("Sky")
s.Name = "SKY"
s.SkyboxBk = "http://www.roblox.com/asset/?id=90774749350746"
s.SkyboxDn = "http://www.roblox.com/asset/?id=126893304944673"
s.SkyboxFt = "http://www.roblox.com/asset/?id=90774749350746"
s.SkyboxLf = "http://www.roblox.com/asset/?id=90774749350746"
s.SkyboxRt = "http://www.roblox.com/asset/?id=90774749350746"
s.SkyboxUp = "http://www.roblox.com/asset/?id=126893304944673"
s.Parent = game.Lighting
    end,
  })
