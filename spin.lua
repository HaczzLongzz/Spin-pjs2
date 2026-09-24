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
pcall(function() firebutton(btn,"LeftMouseButton") fired=true end)
if fired then return end
pcall(function() firebutton(btn) fired=true end)
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

-- 5 clicks trong 1 giay = skip animation
local function skipAnim()
local vp=workspace.CurrentCamera.ViewportSize
local cx=vp.X/2
local cy=vp.Y/2
task.wait(0.2) -- doi anim bat dau
for i=1,5 do
pcall(function()
mousemoveabs(cx,cy)
mouse1press()
task.wait(0.02)
mouse1release()
end)
task.wait(0.18) -- 5 clicks / 1 giay = 0.2s moi click
end
end

local function handlePopup(isSupreme)
task.wait(0.5)
for _,v in pairs(gui:GetDescendants())do
if v:IsA("TextLabel") and v.Visible then
local t=v.Text or ""
if t:find("Are you sure") or t:find("Rolling replaces") then
local frame=v.Parent
local buttons={}
for _,b in pairs(frame:GetDescendants())do
if b:IsA("ImageButton") or b:IsA("TextButton") then
table.insert(buttons,b)
end
end
table.sort(buttons,function(a,b)
return a.AbsolutePosition.X < b.AbsolutePosition.X
end)
if #buttons>=2 then
if isSupreme then
fireBtn(buttons[#buttons])
print("Supreme: X, giu lai")
else
fireBtn(buttons[1])
print("Not supreme: tick, quay tiep")
end
end
return
end
end
end
end

local function checkClan()
for _,v in pairs(gui:GetDescendants())do
if v:IsA("TextLabel") and v.Visible then
local t=v.Text or ""
if t:find("%(") and t:find("%)") then
for _,c in ipairs(CLANS)do
if t:find(c) then
print("SUPREME:",t)
return c
end
end
end
end
end
return nil
end

-- STOP BUTTON UI
local stopGui=Instance.new("ScreenGui")
stopGui.Name="SpinBotUI"
stopGui.ResetOnSpawn=false
stopGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
stopGui.Parent=lp:WaitForChild("PlayerGui")

local frame=Instance.new("Frame")
frame.Size=UDim2.new(0,140,0,60)
frame.Position=UDim2.new(0,10,1,-70)
frame.BackgroundColor3=Color3.fromRGB(30,30,30)
frame.BorderSizePixel=0
frame.Parent=stopGui
Instance.new("UICorner",frame).CornerRadius=UDim.new(0,8)

local spinLabel=Instance.new("TextLabel")
spinLabel.Size=UDim2.new(1,0,0,25)
spinLabel.Position=UDim2.new(0,0,0,5)
spinLabel.BackgroundTransparency=1
spinLabel.Text="Spins: 0"
spinLabel.TextColor3=Color3.new(1,1,1)
spinLabel.Font=Enum.Font.GothamBold
spinLabel.TextScaled=true
spinLabel.Parent=frame

local stopBtn=Instance.new("TextButton")
stopBtn.Size=UDim2.new(1,-10,0,28)
stopBtn.Position=UDim2.new(0,5,0,30)
stopBtn.BackgroundColor3=Color3.fromRGB(200,50,50)
stopBtn.Text="STOP SPIN"
stopBtn.TextColor3=Color3.new(1,1,1)
stopBtn.Font=Enum.Font.GothamBold
stopBtn.TextScaled=true
stopBtn.BorderSizePixel=0
stopBtn.Parent=frame
Instance.new("UICorner",stopBtn).CornerRadius=UDim.new(0,6)

stopBtn.MouseButton1Click:Connect(function()
RUNNING=false
notify("SpinBot","STOPPED - "..SPINS.." spins total.")
stopGui:Destroy()
end)

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

notify("SpinBot","Found! Farming Supreme...")

while RUNNING do
btn=findRollBtn()

if not btn or not btn.Visible or not btn.Active then
notify("SpinBot","Het spin! Dung lai.")
RUNNING=false
return
end

-- SPIN
fireBtn(btn)
SPINS=SPINS+1
spinLabel.Text="Spins: "..SPINS
print("Spin#"..SPINS)

-- SKIP ANIMATION (5 clicks trong 1 giay)
skipAnim()

-- Doi result hien
task.wait(0.3)

-- Check Supreme
local r=checkClan()
print("Result:",tostring(r))
if r then
notify("SUPREME GOT!",r.." - "..SPINS.." spins!")
handlePopup(true)
RUNNING=false
task.wait(3)
stopGui:Destroy()
TeleportService:Teleport(game.PlaceId,lp)
return
end

-- Xu ly popup Legendary/Mythic
handlePopup(false)

task.wait(0.2+math.random()*0.2)
end
end

_G.StopSpin=function()
RUNNING=false
notify("Stopped",SPINS.." spins.")
end

task.spawn(main)
