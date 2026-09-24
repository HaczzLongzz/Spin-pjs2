local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local lp = Players.LocalPlayer
local gui = lp:WaitForChild("PlayerGui")
local SG = game:GetService("StarterGui")
local vim = game:GetService("VirtualInputManager")
local RUNNING = true
local SPINS = 0
local CLANS = {"Kamado","Rengoku","Soyama","Uzui"}

local function notify(t,m)
    SG:SetCore("SendNotification",{Title=t,Text=m,Duration=5})
end

local function getBtn()
    local o = gui
    local p = {"Components","Body","AvatarFrames","Left","Frame","SpinningFrame","Spinner","Holder","SpinButton","Button"}
    for _,v in ipairs(p) do
        if o == nil then return nil end
        o = o:FindFirstChild(v)
    end
    return o
end

local function click(btn)
    local x = btn.AbsolutePosition.X + btn.AbsoluteSize.X/2
    local y = btn.AbsolutePosition.Y + btn.AbsoluteSize.Y/2
    vim:SendMouseButtonEvent(x,y,0,true,game,0)
    task.wait(0.08)
    vim:SendMouseButtonEvent(x,y,0,false,game,0)
end

local function skip()
    local vp = workspace.CurrentCamera.ViewportSize
    vim:SendMouseButtonEvent(vp.X/2,vp.Y/2,0,true,game,0)
    task.wait(0.05)
    vim:SendMouseButtonEvent(vp.X/2,vp.Y/2,0,false,game,0)
end

local function getSpins()
    for _,v in pairs(gui:GetDescendants()) do
        if v:IsA("TextLabel") then
            local n = v.Text:match("^(%d+)%s*[Ss]pin")
            if n then return tonumber(n) end
        end
    end
    return nil
end

local function checkClan()
    for _,v in pairs(gui:GetDescendants()) do
        if v:IsA("TextLabel") and v.Visible then
            for _,c in ipairs(CLANS) do
                if v.Text:find(c) then return c end
            end
        end
    end
    return nil
end

local function main()
    notify("SpinBot","Loading...")
    task.wait(2)

    local btn = getBtn()
    if not btn then
        notify("ERROR","No Roll button found!")
        return
    end

    notify("SpinBot","Found! Farming Supreme...")

    while RUNNING do
        btn = getBtn()
        if not btn then task.wait(0.5) continue end

        local s = getSpins()
        if s ~= nil and s <= 0 then
            notify("SpinBot","Out of spins, rejoining...")
            task.wait(2)
            TeleportService:Teleport(game.PlaceId,lp)
            return
        end

        click(btn)
        SPINS = SPINS + 1
        print("Spin#"..SPINS)

        task.wait(0.4)
        skip()
        task.wait(0.4)

        local r = checkClan()
        if r then
            notify("SUPREME GOT!",r.." - "..SPINS.." spins!")
            RUNNING = false
            task.wait(5)
            TeleportService:Teleport(game.PlaceId,lp)
            return
        end

        task.wait(0.8 + math.random()*0.5)
    end
end

_G.StopSpin = function()
    RUNNING = false
    notify("Stopped",SPINS.." spins.")
end

task.spawn(main)
