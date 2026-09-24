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

local function clickBtn(btn)
    -- Lay toa do truc tiep tu button, tu dong scale theo man hinh
    local pos=btn.AbsolutePosition
    local size=btn.AbsoluteSize
    local cx=pos.X+size.X/2
    local cy=pos.Y+size.Y/2
    mousemoveabs(cx,cy)
    task.wait(0.05)
    mouse1press()
    task.wait(0.08)
    mouse1release()
end

local function skipAnim(btn)
    -- Click giua man hinh de skip
    local vp=workspace.CurrentCamera.ViewportSize
    mousemoveabs(vp.X/2,vp.Y/2)
    task.wait(0.05)
    mouse1click()
end

local function getSpins()
    -- Tim "28 Spins" label chinh xac
    for _,v in pairs(gui:GetDescendants())do
        if v:IsA("TextLabel") then
            local t=v.Text or ""
            -- Match chinh xac: so + Spins (khong phai button mua)
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
    
    -- Doi button xuat hien, toi da 30 giay
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
    
    notify("SpinBot","Found! Close Delta UI, farming in 3s...")
    task.wait(3)
    
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
        
        -- DONG DELTA UI TRUOC KHI CLICK
        clickBtn(btn)
        SPINS=SPINS+1
        print("Spin#"..SPINS.." | spins:"..tostring(s))
        
        task.wait(0.4)
        skipAnim(btn)
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
