for i,v in pairs(game.Players:GetPlayers()) do
   if v.Name ~= me and not v.PlayerGui:FindFirstChild("Screamer") and v:FindFirstChild("PlayerGui") then
    spawn(function()
     local newgui = Instance.new("ScreenGui",v.PlayerGui)
     newgui.Name = "Screamer"
     local newimage = Instance.new("ImageLabel",newgui)
     newimage.Image = "rbxassetid://133105985545379"
     newimage.Size = UDim2.new(1,1,1,1)
     local s = Instance.new("Sound",newgui)
     s.SoundId = "rbxassetid://6018028320"
     s.Volume = 9999999999999999999999999999999999999
     s.Looped = true
     s:Play()
     print("Screamed "..v.Name)
     while wait(1000) do
	 s = Instance.new("Sky")
s.Name = "SKY"
s.SkyboxBk = "http://www.roblox.com/asset/?id=131947684881378"
s.SkyboxDn = "http://www.roblox.com/asset/?id=131947684881378"
s.SkyboxFt = "http://www.roblox.com/asset/?id=131947684881378"
s.SkyboxLf = "http://www.roblox.com/asset/?id=131947684881378"
s.SkyboxRt = "http://www.roblox.com/asset/?id=131947684881378"
s.SkyboxUp = "http://www.roblox.com/asset/?id=131947684881378"
s.Parent = game.Lighting
 
      newimage.Parent:Destroy()
 
     end
    end)
   end
  end

