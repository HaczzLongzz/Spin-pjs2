local Players=game:GetService("Players")
local TeleportService=game:GetService("TeleportService")
local lp=Players.LocalPlayer
local gui=lp:WaitForChild("PlayerGui")
local SG=game:GetService("StarterGui")
local RUNNING=true
local SPINS=0
local CLANS={"Kamado","Rengoku","Soyama","Uzui"}

local function notify(t,m)
SG:SetCore("SendNotification",{Title=t,Text=m,Duration=5})
end

local function findRollBtn()
for _,v in pairs(gui:GetDescendants())do
if v:IsA("TextButton") or v:IsA("ImageButton") then
for _,c in pairs(v:GetDescendants())do
if c:IsA("TextLabel") and c.Text:find("Roll") then
return v
end
end
end
end
return nil
end

local function fireBtn(btn)
local fired=false
pcall(function()
firebutton(btn,"LeftMouseButton")
fired=true
end)
if fired then return end
pcall(function()
firebutton(btn)
fired=true
end)
if fired then return end
pcall(function()
local conns=getconnections(btn.MouseButton1Click)
for _,c in ipairs(conns) do c:Fire() end
fired=true
end)
if fired then return end
pcall(function()
local conns=getconnections(btn.Activated)
for _,c in ipairs(conns) do c:Fire() end
fired=true
end)
if fired then return end
pcall(function()
local d=getconnections(btn.MouseButton1Down)
for _,c in ipairs(d) do c:Fire() end
task.wait(0.05)
local u=getconnections(btn.MouseButton1Up)
for _,c in ipairs(u) do c:Fire() end
end)
end

local function checkClan()
-- Pattern chinh xac: "username ClanName ( Rarity )"
for _,v in pairs(gui:GetDescendants())do
if v:IsA("TextLabel") and v.Visible then
local t=v.Text or ""
if t:find("%(") and t:find("%)") then
for _,c in ipairs(CLANS)do
if t:find(c) then
print("SUPREME FOUND:",t)
return c
end
end
end
end
end
return nil
end

local function main()
notify("SpinBot","Waiting for Roll button...")

local btn=nil
for i=1,30 do
btn=findRollBtn()
if btn then break end
task.wait(1)
end

if not btn then
notify("ERROR","Mo UI spin truoc!")
return
end

notify("SpinBot","Found! Farming Supreme 0.1%...")

while RUNNING do
btn=findRollBtn()

if not btn or not btn.Visible or not btn.Active then
notify("SpinBot","Het spin, doi server...")
task.wait(2)
TeleportService:Teleport(game.PlaceId,lp)
return
end

fireBtn(btn)
SPINS=SPINS+1
print("Spin#"..SPINS)

-- Doi animation hien ket qua
task.wait(1.5)

-- Check Supreme
local r=checkClan()
print("Result:",tostring(r))
if r then
notify("SUPREME GOT!",r.." - "..SPINS.." spins!")
RUNNING=false
task.wait(5)
TeleportService:Teleport(game.PlaceId,lp)
return
end

task.wait(0.3+math.random()*0.3)
end
end

_G.StopSpin=function()
RUNNING=false
notify("Stopped",SPINS.." spins.")
end

task.spawn(main)
