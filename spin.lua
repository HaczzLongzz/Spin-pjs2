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

-- Khong doc spin count
-- Chi check Roll button con visible khong
-- Khi het spin → Roll button bien mat hoac disabled
local function isRollAvailable()
local btn=findRollBtn()
if not btn then return false end
-- Check button co bi disabled khong
if not btn.Visible then return false end
if not btn.Active then return false end
return true
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

-- Neu khong tim thay Roll button = het spin
-- Hoac button bi disable
if not btn or not btn.Visible or not btn.Active then
notify("SpinBot","Het spin → doi server...")
task.wait(2)
TeleportService:Teleport(game.PlaceId,lp)
return
end

-- SPIN
btn:Activate()
SPINS=SPINS+1
print("Spin#"..SPINS)

-- Doi animation
task.wait(0.5)

-- Skip animation
btn:Activate()

task.wait(0.5)

-- Check clan
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
