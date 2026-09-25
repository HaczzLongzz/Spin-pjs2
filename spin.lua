local Players=game:GetService("Players")
local TeleportService=game:GetService("TeleportService")
local HttpService=game:GetService("HttpService")
local lp=Players.LocalPlayer
local gui=lp:WaitForChild("PlayerGui")
local SG=game:GetService("StarterGui")
local RUNNING=true
local SPINS=0
local CLANS={"Kamado","Rengoku","Soyama","Uzui"}

local BIN_ID="6ab6d3ceffd5d160532f0e2a"
local MASTER_KEY="$2a$10$dHm3pkZ62aJW/K4QqOUL.eehuOyT8KgV1gDXc8W.lgbPboJ.IMrIu"
local API_URL="https://api.jsonbin.io/v3/b/"..BIN_ID

local function notify(t,m)
SG:SetCore("SendNotification",{Title=t,Text=m,Duration=5})
end

local function getHWID()
local ok,id=pcall(function()
return game:GetService("RbxAnalyticsService"):GetClientId()
end)
return ok and id or tostring(game:GetService("RunService"):GetRobloxVersion())
end

local function getBin()
local ok,res=pcall(function()
return HttpService:JSONDecode(
game:HttpGet(API_URL.."/latest",{
["X-Master-Key"]=MASTER_KEY
})
)
end)
if ok then return res.record end
return nil
end

local function updateBin(data)
pcall(function()
local body=HttpService:JSONEncode(data)
HttpService:RequestAsync({
Url=API_URL,
Method="PUT",
Headers={
["Content-Type"]="application/json",
["X-Master-Key"]=MASTER_KEY
},
Body=body
})
end)
end

local function checkKey(inputKey)
local data=getBin()
if not data then return false,"Loi ket noi server!" end
local keys=data.keys
if not keys then return false,"Loi database!" end
local keyData=keys[inputKey]
if not keyData then return false,"Key khong ton tai!" end
if keyData.used then
local hwid=getHWID()
if keyData.hwid==hwid then
return true,"OK_SAME_HWID"
else
return false,"Key da duoc su dung tren may khac!"
end
end
-- Key chua dung, dang ky HWID
local hwid=getHWID()
keys[inputKey]={used=true,hwid=hwid}
data.keys=keys
updateBin(data)
return true,"OK_NEW"
end

-- KEY INPUT UI
local keyGui=Instance.new("ScreenGui")
keyGui.Name="KeySystem"
keyGui.ResetOnSpawn=false
keyGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
keyGui.Parent=lp:WaitForChild("PlayerGui")

local bg=Instance.new("Frame")
bg.Size=UDim2.new(1,0,1,0)
bg.BackgroundColor3=Color3.fromRGB(0,0,0)
bg.BackgroundTransparency=0.5
bg.BorderSizePixel=0
bg.Parent=keyGui

local frame=Instance.new("Frame")
frame.Size=UDim2.new(0,350,0,220)
frame.Position=UDim2.new(0.5,-175,0.5,-110)
frame.BackgroundColor3=Color3.fromRGB(20,20,30)
frame.BorderSizePixel=0
frame.Parent=keyGui
Instance.new("UICorner",frame).CornerRadius=UDim.new(0,12)

local title=Instance.new("TextLabel")
title.Size=UDim2.new(1,0,0,50)
title.Position=UDim2.new(0,0,0,0)
title.BackgroundTransparency=1
title.Text="HACZZ SPIN BOT"
title.TextColor3=Color3.fromRGB(255,200,50)
title.Font=Enum.Font.GothamBold
title.TextScaled=true
title.Parent=frame

local sub=Instance.new("TextLabel")
sub.Size=UDim2.new(1,0,0,25)
sub.Position=UDim2.new(0,0,0,0.25)
sub.BackgroundTransparency=1
sub.Text="Nhap key de su dung"
sub.TextColor3=Color3.fromRGB(150,150,150)
sub.Font=Enum.Font.Gotham
sub.TextScaled=true
sub.Parent=frame

local inputBox=Instance.new("TextBox")
inputBox.Size=UDim2.new(0.85,0,0,45)
inputBox.Position=UDim2.new(0.075,0,0,100)
inputBox.BackgroundColor3=Color3.fromRGB(35,35,50)
inputBox.BorderSizePixel=0
inputBox.Text=""
inputBox.PlaceholderText="HACZZ-XXXX-XXXX"
inputBox.TextColor3=Color3.new(1,1,1)
inputBox.PlaceholderColor3=Color3.fromRGB(100,100,100)
inputBox.Font=Enum.Font.GothamBold
inputBox.TextScaled=true
inputBox.Parent=frame
Instance.new("UICorner",inputBox).CornerRadius=UDim.new(0,8)

local statusLabel=Instance.new("TextLabel")
statusLabel.Size=UDim2.new(1,0,0,25)
statusLabel.Position=UDim2.new(0,0,0,155)
statusLabel.BackgroundTransparency=1
statusLabel.Text=""
statusLabel.TextColor3=Color3.fromRGB(255,100,100)
statusLabel.Font=Enum.Font.Gotham
statusLabel.TextScaled=true
statusLabel.Parent=frame

local confirmBtn=Instance.new("TextButton")
confirmBtn.Size=UDim2.new(0.85,0,0,40)
confirmBtn.Position=UDim2.new(0.075,0,0,175)
confirmBtn.BackgroundColor3=Color3.fromRGB(50,180,50)
confirmBtn.Text="XAC NHAN"
confirmBtn.TextColor3=Color3.new(1,1,1)
confirmBtn.Font=Enum.Font.GothamBold
confirmBtn.TextScaled=true
confirmBtn.BorderSizePixel=0
confirmBtn.Parent=frame
Instance.new("UICorner",confirmBtn).CornerRadius=UDim.new(0,8)

-- KEY VERIFIED → CHAY SCRIPT CHINH
local function startBot()
keyGui:Destroy()

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

local function skipAnim()
local vp=workspace.CurrentCamera.ViewportSize
local cx=vp.X/2
local cy=vp.Y/2
task.wait(0.2)
for i=1,5 do
pcall(function()
mousemoveabs(cx,cy)
mouse1press()
task.wait(0.02)
mouse1release()
end)
task.wait(0.18)
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
else
fireBtn(buttons[1])
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
if t:find(c) then return c end
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

local sFrame=Instance.new("Frame")
sFrame.Size=UDim2.new(0,140,0,60)
sFrame.Position=UDim2.new(0,10,1,-70)
sFrame.BackgroundColor3=Color3.fromRGB(20,20,30)
sFrame.BorderSizePixel=0
sFrame.Parent=stopGui
Instance.new("UICorner",sFrame).CornerRadius=UDim.new(0,8)

local spinLabel=Instance.new("TextLabel")
spinLabel.Size=UDim2.new(1,0,0,25)
spinLabel.Position=UDim2.new(0,0,0,5)
spinLabel.BackgroundTransparency=1
spinLabel.Text="Spins: 0"
spinLabel.TextColor3=Color3.fromRGB(255,200,50)
spinLabel.Font=Enum.Font.GothamBold
spinLabel.TextScaled=true
spinLabel.Parent=sFrame

local stopBtn=Instance.new("TextButton")
stopBtn.Size=UDim2.new(1,-10,0,28)
stopBtn.Position=UDim2.new(0,5,0,30)
stopBtn.BackgroundColor3=Color3.fromRGB(200,50,50)
stopBtn.Text="STOP SPIN"
stopBtn.TextColor3=Color3.new(1,1,1)
stopBtn.Font=Enum.Font.GothamBold
stopBtn.TextScaled=true
stopBtn.BorderSizePixel=0
stopBtn.Parent=sFrame
Instance.new("UICorner",stopBtn).CornerRadius=UDim.new(0,6)

stopBtn.MouseButton1Click:Connect(function()
RUNNING=false
notify("SpinBot","STOPPED - "..SPINS.." spins total.")
stopGui:Destroy()
end)

-- MAIN LOOP
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
notify("SpinBot","Het spin! Dung lai.")
RUNNING=false
stopGui:Destroy()
return
end

fireBtn(btn)
SPINS=SPINS+1
spinLabel.Text="Spins: "..SPINS
print("Spin#"..SPINS)

skipAnim()
task.wait(0.3)

local r=checkClan()
if r then
notify("SUPREME GOT!",r.." - "..SPINS.." spins!")
handlePopup(true)
RUNNING=false
task.wait(3)
stopGui:Destroy()
TeleportService:Teleport(game.PlaceId,lp)
return
end

handlePopup(false)
task.wait(0.2+math.random()*0.2)
end
end

-- CONFIRM BUTTON
confirmBtn.MouseButton1Click:Connect(function()
local inputKey=inputBox.Text
if inputKey=="" then
statusLabel.Text="Nhap key di!"
statusLabel.TextColor3=Color3.fromRGB(255,100,100)
return
end
statusLabel.Text="Dang kiem tra..."
statusLabel.TextColor3=Color3.fromRGB(255,200,50)
task.spawn(function()
local ok,msg=checkKey(inputKey)
if ok then
statusLabel.Text="Key hop le! Dang khoi dong..."
statusLabel.TextColor3=Color3.fromRGB(50,255,50)
task.wait(1)
startBot()
else
statusLabel.Text=msg
statusLabel.TextColor3=Color3.fromRGB(255,100,100)
end
end)
end)
