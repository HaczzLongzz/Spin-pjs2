local Players=game:GetService("Players")
local TeleportService=game:GetService("TeleportService")
local lp=Players.LocalPlayer
local gui=lp:WaitForChild("PlayerGui")
local SG=game:GetService("StarterGui")
local RUNNING=false
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

local function skipAnim()
    local btn=findRollBtn()
    if not btn then return end
    task.wait(0.2)
    for i=1,5 do
        pcall(function()
            local conns=getconnections(btn.MouseButton1Click)
            for _,c in ipairs(conns) do c:Fire() end
        end)
        pcall(function()
            local conns=getconnections(btn.Activated)
            for _,c in ipairs(conns) do c:Fire() end
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
                        print("Supreme: giu lai")
                    else
                        fireBtn(buttons[1])
                        print("Not supreme: quay tiep")
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

local stopGui=Instance.new("ScreenGui")
stopGui.Name="SpinBotUI"
stopGui.ResetOnSpawn=false
stopGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
stopGui.Parent=lp:WaitForChild("PlayerGui")

local frame=Instance.new("Frame")
frame.Size=UDim2.new(0,150,0,95)
frame.Position=UDim2.new(0,10,1,-105)
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

local startBtn=Instance.new("TextButton")
startBtn.Size=UDim2.new(1,-10,0,28)
startBtn.Position=UDim2.new(0,5,0,30)
startBtn.BackgroundColor3=Color3.fromRGB(50,180,50)
startBtn.Text="START SPIN"
startBtn.TextColor3=Color3.new(1,1,1)
startBtn.Font=Enum.Font.GothamBold
startBtn.TextScaled=true
startBtn.BorderSizePixel=0
startBtn.Parent=frame
Instance.new("UICorner",startBtn).CornerRadius=UDim.new(0,6)

local stopBtn=Instance.new("TextButton")
stopBtn.Size=UDim2.new(1,-10,0,28)
stopBtn.Position=UDim2.new(0,5,0,62)
stopBtn.BackgroundColor3=Color3.fromRGB(200,50,50)
stopBtn.Text="STOP SPIN"
stopBtn.TextColor3=Color3.new(1,1,1)
stopBtn.Font=Enum.Font.GothamBold
stopBtn.TextScaled=true
stopBtn.BorderSizePixel=0
stopBtn.Parent=frame
Instance.new("UICorner",stopBtn).CornerRadius=UDim.new(0,6)

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
        fireBtn(btn)
        SPINS=SPINS+1
        spinLabel.Text="Spins: "..SPINS
        print("Spin#"..SPINS)
        skipAnim()
        task.wait(0.3)
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
        handlePopup(false)
        task.wait(0.2+math.random()*0.2)
    end
end

startBtn.MouseButton1Click:Connect(function()
    if RUNNING then return end
    RUNNING=true
    startBtn.BackgroundColor3=Color3.fromRGB(30,100,30)
    task.spawn(main)
end)

stopBtn.MouseButton1Click:Connect(function()
    RUNNING=false
    notify("SpinBot","STOPPED - "..SPINS.." spins total.")
    startBtn.BackgroundColor3=Color3.fromRGB(50,180,50)
end)

notify("HACZZ","SpinBot loaded! Bam START de bat dau.")
