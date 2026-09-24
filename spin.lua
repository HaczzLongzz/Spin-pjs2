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

local function getSpins()
for _,v in pairs(gui:GetDescendants())do
if v:IsA("TextLabel") then
local t=v.Text or ""
local n=t:match("^(%d+)%s+[Ss]pins?$")
if n then return tonumber(n) end
end
end
return nil
end

local function checkClan()
for _,v in pairs(gui:GetDescendants())do
if v:IsA("TextLabel") and v.Visible then
local t=v.Text or ""
for _,c in ipairs(CLANS)do
if t:find(c) then return c end
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
if not btn then task.wait(0.5) continue end

local s=getSpins()
if s~=nil and s<=0 then
notify("SpinBot","Het spin, doi server...")
task.wait(2)
TeleportService:Teleport(game.PlaceId,lp)
return
end

-- ACTIVATE TRUC TIEP - khong can click vat ly
btn:Activate()
SPINS=SPINS+1
print("Spin#"..SPINS.." spins:"..tostring(s))

task.wait(0.4)

-- Skip animation bang Activate lan 2
btn:Activate()

task.wait(0.4)

local r=checkClan()
if r then
notify("SUPREME!",r.." - "..SPINS.." spins!")
RUNNING=false
task.wait(5)
TeleportService:Teleport(game.PlaceId,lp)
return
end

task.wait(0.8+math.random()*0.5)
end
end

_G.StopSpin=function()
RUNNING=false
notify("Stopped",SPINS.." spins.")
end

task.spawn(main)
