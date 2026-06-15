local Library, Framework = loadfile("Rijin.lua")()

local Workspace = cloneref(game:GetService("Workspace"))
local Players = cloneref(game:GetService("Players"))
local Stats = cloneref(game:GetService("Stats"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local RunService = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))

local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Ping = Stats.PerformanceStats.Ping

local ItemSpawns = Workspace.ItemSpawns
local ConfigModule = require(ReplicatedStorage.Config)
local m_BridgeNet2 = require(ReplicatedStorage.Assets.Modules.BridgeNet2)
local Bridges = {
    ["SCPHandler"] = m_BridgeNet2.ClientBridge("SCPHandler"),
    ["repSound"] = m_BridgeNet2.ClientBridge("repSound"),
    ["repReload"] = m_BridgeNet2.ClientBridge("repReload"),
    ["fireWeapon"] = m_BridgeNet2.ClientBridge("__fireWeapon"),
    ["serverTracer"] = m_BridgeNet2.ClientBridge("serverTracer"),
    ["clientTracer"] = m_BridgeNet2.ClientBridge("clientTracer"),
    ["repTracer"] = m_BridgeNet2.ClientBridge("repTracer"),
    ["grenadeThrow"] = m_BridgeNet2.ClientBridge("grenadeThrow"),
    ["setBarriers"] = m_BridgeNet2.ClientBridge("setBarriers"),
    ["equipWeapon"] = m_BridgeNet2.ClientBridge("equipWeapon")
}

local AnimationTable = nil
-- local FireAnimationFunction = nil
local ClientTracerFunction = nil
local HitmarkerFunction = nil
local WeaponSystem = nil
local StaminaFunction = nil

local ClientBridge = require(ReplicatedStorage.Assets.Modules.BridgeNet2.src.Client.ClientBridge)
local Functions = debug.getupvalue(ClientBridge, 2).__index -- could just put it into the hook instead

local Utility = {
    Parts = {
        Character = nil,
        Humanoid = nil,
        RootPart = nil
    },
    Ping = Ping:GetValue(),
    Target = nil,
    PredictedDamage = {},
    Vertices = {
        Vector3.new(0, 1, 0),
        Vector3.new(0, -1, 0),
        Vector3.new(-1, 0, 0),
        Vector3.new(1, 0, 0),
        Vector3.new(0, 0, -1),
        Vector3.new(0, 0, 1),
    },
    IgnoreList = {
        CurrentCamera,
        LocalPlayer.Character or nil
    },
    CustomRotation = false,
    Rotated = false,
    LastRotation = os.clock(),
    SpinAngle = 0,
    SoundVolumes = {},
    OldGunStats = nil,
    GunStats = nil,
    Players = {},
}

do
    function Utility.GetParts(Player)
        local Character = Player.Character
        local Head = (Character and Character:FindFirstChild("Head"))
        local Humanoid = (Character and Character:FindFirstChildOfClass("Humanoid"))
        local RootPart = (Humanoid and Humanoid.RootPart)
        local Animator = (Humanoid and Humanoid:FindFirstChildOfClass("Animator"))

        return Character, Head, Humanoid, RootPart, Animator
    end

    function Utility.GetBodyParts(Character, RootPart, BodyParts)
        local Parts = {}
        local BodyParts = BodyParts or {"Head", "Torso", "Arm", "Leg"}

        for _, Part in pairs(Character:GetChildren()) do
            if not Part:IsA("BasePart") or Part == RootPart then
                continue
            end

            for _, BodyPart in pairs(BodyParts) do
                if string.find(Part.Name:lower(), BodyPart:lower()) then
                    Parts[Part] = BodyPart
                end
            end
        end

        return Parts
    end

    function Utility.GetIgnoreList(Special)
        local RaycastParams = RaycastParams.new()
        RaycastParams.CollisionGroup = Special and "Players" or "ProjectileCollision" -- interesting?
        RaycastParams.FilterDescendantsInstances = Utility.IgnoreList
        RaycastParams.FilterType = Enum.RaycastFilterType.Exclude

        return RaycastParams
    end

    function Utility.CalculateFOV(Position)
        return math.deg(math.acos(CurrentCamera.CFrame.LookVector:Dot((Position - CurrentCamera.CFrame.Position).Unit)))
    end

    function Utility.GetAlgorithmValue(Algorithm, Position)
        if Algorithm == "Closest to FOV" then
            return Utility.CalculateFOV(Position)
        else
            return (Parts.RootPart.CFrame.Position - Position).Magnitude
        end
    end

    function Utility.PlayAnimation(Animation, Settings, Looped) -- add animationtable checks
        local Looped = Looped or false -- gay

        if WeaponSystem.weaponModel then
            local AnimationTrack = Utility.Parts.Animator:LoadAnimation(Animation)
            AnimationTrack.Priority = Settings.priority
            AnimationTrack.Name = Animation.Name
            AnimationTrack.Looped = Looped
            AnimationTrack:Play(Settings.fade or 0.1, nil, Settings.speed or 1)

            -- if AnimationTable then
                table.insert(AnimationTable, AnimationTrack)
            -- end

            AnimationTrack.KeyframeReached:Connect(function(Name)
                if WeaponSystem.weaponModel and (WeaponSystem.weaponModel:FindFirstChild("_Handle") and WeaponSystem.weaponModel._Handle:FindFirstChild(Name)) then
                    Bridges.repSound:Fire({
                        ["soundName"] = Name
                    })
                end
                
                if Name == "MagIn" then
                    Bridges.repReload:Fire()
                end
                
                --[[if Name == "Throw" and WeaponSystem.wepStats.weaponType == "Grenade" then
                    local LookVector = v_u_18.Hit.LookVector
                    if not UserInputService.MouseEnabled then
                        LookVector = workspace.CurrentCamera.CFrame.LookVector
                    end
                    Bridges.grenadeThrow:Fire({
                        ["lookVector"] = LookVector
                    })
                end]]
            end)

            if not Looped then
                AnimationTrack.Stopped:Once(function()
                    table.remove(AnimationTable, table.find(AnimationTable, AnimationTrack))
                end)
            end

            return AnimationTrack
        end
    end

    function Utility.Reload(Automatic)
        local Mag = WeaponSystem.equipped and WeaponSystem.equipped.Ammo.Mag or nil
        local Reserve = WeaponSystem.equipped and WeaponSystem.equipped.Ammo.Reserve or nil
        
        if not (Mag and Reserve) then
            return
        end

        --[[if Mag.Value >= Mag.MaxValue then
            return
        end]]

        if Reserve.Value <= 0 then
            return
        end

        if Automatic and Mag.Value > 0 then
            return
        end

        WeaponSystem.reloading = true

        local ReloadSpeed = WeaponSystem.wepStats and WeaponSystem.wepStats.reloadAnimSpeed or 1 -- why is this a variable?

        Utility.PlayAnimation(WeaponSystem.equipped.Animations.Reload, {
            ["priority"] = Enum.AnimationPriority.Action2,
            ["speed"] = ReloadSpeed
        }, false).Stopped:Once(function()
            WeaponSystem.reloading = false
        end)
    end

    function Utility.SilentAim()
        local SilentAim = Library.Flags["Aimbot/Silentaim"]

        if SilentAim == "Disabled" then
            CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, Utility.Target.HitPosition)
        elseif SilentAim == "Serverside" then
            local Parts = Utility.Parts
            local RootPartPosition = Parts.RootPart.CFrame.Position
            local HitPosition = Utility.Target.HitPosition

            Parts.Humanoid.AutoRotate = false
            Parts.RootPart.CFrame = CFrame.new(RootPartPosition, Vector3.new(HitPosition.X, RootPartPosition.Y, HitPosition.Z))
            Parts.Humanoid.AutoRotate = true
        end
    end

    function Utility.BonusShot(Humanoid, DamageValues, HitPart, BulletsFired, Ammo) -- when ur manually shooting predicted damage is wrong or som sh
        local Bonus = 0

        local Health = Humanoid.Health
        local Damage = DamageValues[HitPart.Name == "Head" and "Headshot" or "Body"] -- * BulletsFired -- shotgun yah? so nvm because i would have to actually count how many hit his ass to account for the damage bruhhhhhhhhhhh

        Health -= Damage -- since we account for a normal shot before

        while Health > 0 do
            if Ammo <= 0 then
                break
            end

            Ammo -= 1
            Health -= Damage
            Bonus += 1
        end

        local PredictedDamage = Damage * Bonus -- i kept unloading full clips on a single person because of the speed (health dont update in time)

        if not Utility.PredictedDamage[Humanoid] then
            Utility.PredictedDamage[Humanoid] = 0
        end

        Utility.PredictedDamage[Humanoid] += PredictedDamage

        task.spawn(function() -- need to test if calculation is even correct
            task.wait(Utility.Ping * 2 / 1000) -- adjust
            
            Utility.PredictedDamage[Humanoid] -= PredictedDamage
        end)

        return Bonus
    end

    function Utility.CalculateSpread(ServerTime, Index, Spread, LookVector)
        local v54 = Random.new(ServerTime * 10000 + LocalPlayer.UserId + Index * 1000)
        local v55 = v54:NextNumber(-Spread, Spread)
        local v56 = v54:NextNumber(-Spread, Spread)
        local v57 = math.rad(v55)
        local v58 = math.rad(v56)
        local v59 = Vector3.new(v57, v58, 0)
        return CFrame.fromEulerAngles(v59.X, v59.Y, v59.Z, Enum.RotationOrder.YXZ):VectorToWorldSpace(LookVector)
    end

    function Utility.AutoShoot()
        if WeaponSystem.reloading then
            return
        end

        if WeaponSystem.running then
            return
        end

        if not WeaponSystem.canFire then
            return
        end

        if not WeaponSystem.cycled then
            return
        end

        if not WeaponSystem.weaponModel then -- eh??
            return
        end

        if not WeaponSystem.weaponModel:FindFirstChild("_Handle") then -- EHHHHHH?
            return
        end

        local Ammo = WeaponSystem.equipped:FindFirstChild("Ammo")

        if not Ammo then
            return
        end

        local Mag = Ammo:FindFirstChild("Mag")

        if not Mag then
            return
        end

        if Mag.Value <= 0 then
            Utility.Reload()
            return
        end

        --[[if FireAnimationFunction then
            task.spawn(FireAnimationFunction)
        end]]

        local Fire = WeaponSystem.equipped.Animations:FindFirstChild("Fire")

        if Fire and (Fire:IsA("Animation") and Fire.AnimationId ~= "") then
            Utility.PlayAnimation(WeaponSystem.equipped.Animations.Fire, {
                ["priority"] = Enum.AnimationPriority.Action2
            }, false)
        elseif not Fire then
            Bridges.repSound:Fire({
                ["soundName"] = "Fire"
            })
        end

        if not WeaponSystem.weaponModel._Handle:FindFirstChild("Barrel") then
            return
        end

        local Shots = {}

        local Target = Utility.Target
        local Origin = Utility.Parts.Head.Position
        local ServerTime = Workspace:GetServerTimeNow()
        local Spread = WeaponSystem.wepStats.Spread

        for Index = 1, math.clamp(WeaponSystem.wepStats.BulletsFired, 1, 20) do
            if ClientTracerFunction then
                task.spawn(ClientTracerFunction, {
                    ["position"] = Target.HitPosition
                })
            end

            local Direction = (Target.HitPosition - Origin).Unit
            local Spread = Utility.CalculateSpread(ServerTime, Index, Spread, Direction)

            local RaycastResult = Workspace:Raycast(Origin, Spread * 1000, Utility.GetIgnoreList())
            
            Shots[Index] = {
                ["mouseVector"] = Direction,
                ["direction"] = Spread * 1000,
                ["startPosition"] = Origin,
                ["endPosition"] = RaycastResult and RaycastResult.Position or (Origin + Spread * 1000),
                ["hitPart"] = Target.HitPart
            }
        end

        Mag.Value -= 1

        Bridges.fireWeapon:Fire({
            ["bullets"] = Shots,
            ["sentAt"] = ServerTime
        })

        Utility.SilentAim()

        if HitmarkerFunction then
            task.spawn(HitmarkerFunction)
        end

        WeaponSystem.cycled = false

        task.wait(60 / WeaponSystem.wepStats.FireRate)

        WeaponSystem.cycled = true
    end

    function Utility.Aimbot()
        Utility.Target = nil

        if not Library.Flags["Aimbot/Enabled"] then
            return
        end

        if not WeaponSystem then
            return
        end

        if not WeaponSystem.equipped then
            return
        end
        
        if not WeaponSystem.wepStats then
            return
        end
        
        if WeaponSystem.wepStats.weaponType ~= "Gun" then
            return
        end

        local Parts = Utility.Parts

        if not Parts.Character or not Parts.Head or not Parts.Humanoid or Parts.Humanoid.Health <= 0 or not Parts.RootPart or not Parts.Head then -- gamble on animator
            return
        end

        local Origin = Parts.Head.Position -- tried gambling failed.

        local MaximumFOV = Library.Flags["Aimbot/FOV"]
        local Algorithm = Library.Flags["Aimbot/Algorithm"]
        local PriorityHitbox = Library.Flags["Aimbot/Priorityhitbox"]
        local Hitscan = Library.Flags["Aimbot/Hitscan"]
        -- local Multipoint = Library.Flags["Aimbot/Multipoint"]

        local Target, ClosestTarget = nil, math.huge

        for _, Player in pairs(Players:GetPlayers()) do
            if Player == LocalPlayer or Player.Team.Name == "Lobby" then
                continue
            end

            local Character = Player.Character

            if not Character or not ConfigModule.teamkillCheck(LocalPlayer, Player) then
                continue
            end

            local Humanoid = Character:FindFirstChildOfClass("Humanoid")

            if not Humanoid or Humanoid.Health <= 0 then
                continue
            end

            if (Utility.PredictedDamage[Humanoid] or 0) >= Humanoid.Health then
                continue
            end

            local RootPart = Humanoid.RootPart

            if not RootPart then
                continue
            end

            local Distance = (RootPart.CFrame.Position - Origin).Magnitude
            --[[local StartDamageDropoff = WeaponSystem.wepStats.StartDamageDropoff

            if Distance >= StartDamageDropoff then -- why waste ammo
                if WeaponSystem.wepStats.Damage[Name == "Head" and "Headshot" or "Body"] - (Distance - StartDamageDropoff) <= 0 then
                    continue
                end
            end]]

            local MaxDamageDropOff = WeaponSystem.wepStats.MaxDamageDropOff

            if MaxDamageDropOff and Distance >= MaxDamageDropOff then
                continue
            end

            local RootPartPosition = RootPart.CFrame.Position
            local FOV = Utility.CalculateFOV(RootPartPosition)

            if FOV > MaximumFOV then
                continue
            end

            local AlgorithmValue = Utility.GetAlgorithmValue(Algorithm, RootPartPosition)

            if AlgorithmValue > ClosestTarget then
                continue
            end
            
            local BodyParts = Utility.GetBodyParts(Character, RootPart, Hitscan)
            local HitPoints = {}
            
            for BodyPart, Name in pairs(BodyParts) do
                table.insert(HitPoints, BodyPart.Position)

                local PartSize = BodyPart.Size / 2

                for _, Vertice in pairs(Utility.Vertices) do
                    table.insert(HitPoints, (BodyPart.CFrame * CFrame.new(PartSize * Vertice)).Position)
                end

                --[[HitPoints[BodyPart.Position] = BodyPart

                -- if table.find(Multipoint, Name) then
                    local PartSize = BodyPart.Size / 2

                    for _, Vertice in pairs(Utility.Vertices) do
                        HitPoints[(BodyPart.CFrame * CFrame.new(PartSize * Vertice)).Position] = BodyPart
                    end
                -- end]]
            end

            local HitPart, HitPosition = nil, nil -- ClosestHit = math.huge

            for _, HitPoint in pairs(HitPoints) do
                local RaycastResult = Workspace:Raycast(Origin, (HitPoint - Origin).Unit * 1000, Utility.GetIgnoreList())

                if not RaycastResult or not RaycastResult.Instance:IsDescendantOf(Character) then -- or RaycastResult.Instance ~= BodyPart
                    continue
                end

                --[[local AlgorithmValue = Utility.GetAlgorithmValue(Algorithm, HitPoint)

                if Algorithm == "Closest to FOV" and AlgorithmValue > MaximumFOV then
                    continue
                end

                if AlgorithmValue > ClosestHit then
                    continue
                end

                ClosestHit = AlgorithmValue]]

                HitPart = RaycastResult.Instance -- BodyPart -- could change this to the raycast result
                HitPosition = RaycastResult.Position

                if string.find(HitPart.Name, PriorityHitbox) then -- dont want to use other hitboxes -- BodyParts[BodyPart]
                    break
                end
            end

            if not HitPart then -- or not HitPosition
                continue
            end

            ClosestTarget = AlgorithmValue

            Target = {
                Player = Player,
                Character = Character,
                Humanoid = Humanoid,
                RootPart = RootPart,
                HitPart = HitPart,
                HitPosition = HitPosition -- to look more legit
            }
        end

        Utility.Target = Target

        if Target and Library.Flags["Aimbot/Autoshoot"] then
            Utility.AutoShoot()
        end
    end

    function Utility.Meleebot()
        if not Library.Flags["Other/Automelee"] then
            return
        end

        if not LocalPlayer.PlayerGui:FindFirstChild("GameContext") or not LocalPlayer.PlayerGui.GameContext.SCP_Attack.Enabled then
            return
        end

        local Parts = Utility.Parts

        if not Parts.Character or not Parts.Head or not Parts.Humanoid or Parts.Humanoid.Health <= 0 or not Parts.RootPart or not Parts.Head then
            return
        end

        local Origin = Parts.Head.Position
        local TargetPart, ClosestTarget = nil, math.huge

        for _, Player in pairs(Players:GetPlayers()) do
            if Player == LocalPlayer or Player.Team.Name == "Lobby" then
                continue
            end

            local Character = Player.Character

            if not Character or not ConfigModule.teamkillCheck(LocalPlayer, Player) then
                continue
            end

            local Humanoid = Character:FindFirstChildOfClass("Humanoid")

            if not Humanoid or Humanoid.Health <= 0 then
                continue
            end

            local RootPart = Humanoid.RootPart

            if not RootPart then
                continue
            end

            local Distance = (RootPart.CFrame.Position - Origin).Magnitude

            if Distance >= 5 then
                continue
            end

            --[[local RaycastResult = Workspace:Raycast(Origin, (RootPart.Position - Origin).Unit * 1000, Utility.GetIgnoreList())

            if not RaycastResult or not RaycastResult.Instance:IsDescendantOf(Character) then
                continue
            end]]

            ClosestTarget = Distance

            TargetPart = RootPart
        end

        if not TargetPart then
            return
        end

        local RootPartPosition = Parts.RootPart.CFrame.Position
        local TargetPartPosition = TargetPart.Position

        Parts.RootPart.CFrame = CFrame.new(RootPartPosition, Vector3.new(TargetPartPosition.X, RootPartPosition.Y, TargetPartPosition.Z))

        Bridges.SCPHandler:Fire({
            ["Arg"] = "SCPAttack"
        })
    end

    function Utility.HvH()
        local Humanoid = Utility.Parts.Humanoid
        local RootPart = Utility.Parts.RootPart

        if not RootPart then
            return
        end

        Humanoid.AutoRotate = true

        if not Library.Flags["Antiaim/Enable"] then
            return
        end

        if not Library.Flags["Antiaim/Yaw"] then
            return
        end

        Humanoid.AutoRotate = false

        local RootPartPosition = RootPart.CFrame.Position
        local Rotation = CFrame.new(RootPartPosition, RootPartPosition + (CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1)))

        if Library.Flags["Antiaim/Basedonangle"] == "Closest player" then
            local Closest = math.huge

            for _, Player in pairs(Players:GetPlayers()) do
                if Player == LocalPlayer then -- or Player.Team.Name == "Lobby" -- dont think we will ever be close enough to point to a useless player
                    continue
                end

                local Character = Player.Character

                if not Character or not ConfigModule.teamkillCheck(LocalPlayer, Player) then
                    continue
                end

                local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                if not Humanoid or Humanoid.Health <= 0 then
                    continue
                end

                local RootPart = Humanoid.RootPart

                if not RootPart then
                    continue
                end

                local Distance = (RootPart.CFrame.Position - RootPartPosition).Magnitude

                if Distance > Closest then
                    continue
                end

                Closest = Distance
                Rotation = CFrame.new(RootPartPosition, Vector3.new(RootPart.CFrame.Position.X, RootPartPosition.Y, RootPart.CFrame.Position.Z))
            end
        end

        local Method = Library.Flags["Antiaim/Method"]
        local Angle1, Angle2 = Library.Flags["Antiaim/Angle#1"], Library.Flags["Antiaim/Angle#2"]

        if Method == "Rotate" then
            Rotation *= CFrame.Angles(0, math.rad(Angle1), 0)
        elseif Method == "Rotate dynamic" then
            if os.clock() - Utility.LastRotation >= Library.Flags["Antiaim/Updaterate"] / 1000 then
                Utility.Rotated = not Utility.Rotated
                Utility.LastRotation = os.clock()
            end

            Rotation *= CFrame.Angles(0, math.rad(Utility.Rotated and Angle1 or Angle2), 0)
        elseif Method == "Spin" then
            Utility.SpinAngle = (Utility.SpinAngle + math.rad(Angle1)) % (math.pi * 2)

            Rotation *= CFrame.Angles(0, Utility.SpinAngle, 0) 
        end

        RootPart.CFrame = Rotation
    end

    function Utility.Misc(Delta)
        local Parts = Utility.Parts
        local Character = Parts.Character

        if not Character then
            return
        end

        local RootPart = Parts.RootPart
        
        if not RootPart then
            return
        end

        local Noclip = Library.Flags["General/Noclip"]

        if Noclip then
            for _, Part in pairs(Parts.Character:GetChildren()) do
                if Part:IsA("BasePart") and Part.CanCollide then
                    Part.CanCollide = false
                end
            end

            local Direction = Vector3.new()

            if UserInputService:IsKeyDown("Space") then
                Direction += Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown("LeftControl") then -- i wanna be able to sprint!
                Direction -= Vector3.new(0, 1, 0)
            end

            if Direction.Magnitude > 0 then
                RootPart.CFrame += Direction * Delta * math.max(Library.Flags["General/Speed/Factor"] / 2, 25) -- i dont wanna fucking fall out the map
            end

            RootPart.AssemblyLinearVelocity *= Vector3.new(1, 0, 1)
        else
            RootPart.CanCollide = true
        end

        if Library.Flags["General/Speed"] then
            local Factor = Library.Flags["General/Speed/Factor"]
            local Direction = Vector3.new()
            
            local CameraCFrame = CurrentCamera.CFrame
            local LookVector = Vector3.new(CameraCFrame.LookVector.X, 0, CameraCFrame.LookVector.Z).Unit
            local RightVector = CameraCFrame.RightVector

            if UserInputService:IsKeyDown("W") then
                Direction += LookVector
            end
            if UserInputService:IsKeyDown("S") then
                Direction -= LookVector
            end
            if UserInputService:IsKeyDown("D") then
                Direction += RightVector
            end
            if UserInputService:IsKeyDown("A") then
                Direction -= RightVector
            end

            if Direction.Magnitude <= 0 then -- scary stuff
                return
            end

            Direction = Direction.Unit

            if not Noclip then
                local RaycastResult = Workspace:Raycast(CameraCFrame.Position, Direction * Delta * Factor, Utility.GetIgnoreList(true))

                if RaycastResult then
                    Factor = RaycastResult.Distance
                end
            end

            RootPart.CFrame += Direction * Delta * Factor
        end
    end

    function Utility.GrabAmmo()
        local Mag = WeaponSystem.equipped and WeaponSystem.equipped.Ammo.Mag or nil
        local Reserve = WeaponSystem.equipped and WeaponSystem.equipped.Ammo.Reserve or nil

        if not (Mag and Reserve) or Reserve.Value > 0 then -- >= Mag.MaxValue
            return
        end

        local Ammo = ItemSpawns:FindFirstChild(WeaponSystem.equipped:GetAttribute("Type") == "Primary" and "PrimAmmo" or "SecAmmo")

        if not Ammo then
            return
        end

        local ClickDetector = Ammo:FindFirstChildOfClass("ClickDetector")

        if not ClickDetector then
            return
        end

        fireclickdetector(ClickDetector)
    end

    function Utility.ApplyGunMods()
        local OldGunStats = Utility.OldGunStats
        local GunStats = Utility.GunStats

        if not (OldGunStats and GunStats and GunStats.weaponType == "Gun") then
            return
        end

        setreadonly(GunStats, false)

        if Library.Flags["General/Gunmodifications"] then
            do
                local Recoil = OldGunStats.Recoil
                local Value = Library.Flags["General/Gunmodifications/Recoilscale"]

                GunStats.Recoil = {
                    Horizontal = Recoil.Horizontal / 100 * Value,
                    Vertical = Recoil.Vertical / 100 * Value
                }

                GunStats.ViewPunch = OldGunStats.ViewPunch / 100 * Value
            end

            GunStats.Spread = OldGunStats.Spread / 100 * Library.Flags["General/Gunmodifications/Spreadscale"]
            GunStats.reloadAnimSpeed = (OldGunStats.reloadAnimSpeed or 1) / 100 * Library.Flags["General/Gunmodifications/Reloadspeedscale"]
            GunStats.FireRate = OldGunStats.FireRate / 100 * Library.Flags["General/Gunmodifications/Fireratescale"]

            if Library.Flags["General/Gunmodifications/Fullauto"] then
                GunStats.FireMode = "Auto"
            else
                GunStats.FireMode = OldGunStats.FireMode
            end

            if Library.Flags["General/Gunmodifications/Semiinfiniteammo"] then
                Utility.GrabAmmo()
            end
        else
            GunStats.Recoil = OldGunStats.Recoil
            GunStats.ViewPunch = OldGunStats.ViewPunch
            GunStats.Spread = OldGunStats.Spread
            GunStats.reloadAnimSpeed = (OldGunStats.reloadAnimSpeed or 1)
            GunStats.FireRate = OldGunStats.FireRate
            GunStats.FireMode = OldGunStats.FireMode
        end

        setreadonly(GunStats, true)
    end

    function Utility.CharacterSetup()
        local Character = LocalPlayer.Character

        if not Character then
            return
        end
        
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")

        if not Humanoid then
            return
        end

        local RootPart = Humanoid.RootPart

        if not RootPart then
            return
        end

        RootPart.ChildAdded:Connect(function(Child)
            if Library.Flags["General/Nofootstepnoise"] then
                if Child:IsA("Sound") and string.find(Child.Name, "rbxassetid://") then
                    Child:Stop()

                    Child.Played:Connect(function()
                        Child:Stop()
                    end)
                end
            end
        end)
    end

    function Utility.GrabWeaponSystem()
        local Character = LocalPlayer.Character

        if not Character then
            return
        end
        
        local Script = Character:FindFirstChild("WeaponSystem")

        if not Script then
            return
        end

        for _, Connection in pairs(getconnections(Character.ChildRemoved)) do
            local Function = Connection.Function

            if not Function then
                continue
            end

            if not string.find(debug.getinfo(Function).source, "WeaponSystem") then
                continue
            end

            AnimationTable = debug.getupvalue(Function, 3)

            break
        end

        --[[for _, Connection in pairs(getconnections(RunService.Heartbeat)) do
            local Function = Connection.Function

            if not Function then
                continue
            end

            if not string.find(debug.getinfo(Function).source, "WeaponSystem") then
                continue
            end

            FireAnimationFunction = debug.getupvalue(Function, 3)
            HitmarkerFunction = debug.getupvalue(Function, 5)

            break
        end]]

        local Env = getsenv(Script)
        local ClientTracer = Env.clientTracer

        if ClientTracer then
            ClientTracerFunction = ClientTracer
            WeaponSystem = debug.getupvalue(ClientTracer, 1)

            Utility.IgnoreList = WeaponSystem.ignoreTable

            setmetatable(WeaponSystem, { -- table hooking before gta 5
                __newindex = function(Self, Key, Value)
                    rawset(Self, Key, Value)

                    if Key == "wepStats" and Value then
                        Utility.OldGunStats = table.clone(Value)
                        Utility.GunStats = Value

                        Utility.ApplyGunMods()
                    end
                end
            })
        end

        if Env.Weapon_Connection then
            local Function = getconnectionfunction(Env.Weapon_Connection)

            if not Function then
                return
            end

            -- FireAnimationFunction = debug.getupvalue(Function, 3)
            HitmarkerFunction = debug.getupvalue(Function, 5)
        end
    end

    function Utility.GrabStaminaFunction()
        local Character = LocalPlayer.Character

        if not Character then
            return
        end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")

        if not Humanoid then
            return
        end

        for _, Connection in pairs(getconnections(Humanoid.Running)) do
            local Function = Connection.Function

            if not Function then
                continue
            end

            if not string.find(debug.getinfo(Function).source, "RunController") then
                continue
            end

            StaminaFunction = Function

            break
        end
    end

    function Utility.CreateHitboxes(Character)
        local Color = Library.Flags["Other/Showhitboxesonhit/Colorpicker"]
        local Hitboxes = {}

        for _, Part in pairs(Character:GetChildren()) do
            if not Part:IsA("BasePart") then
                continue
            end

            if Part.Transparency == 1 then -- i swear if this shit makes the invis scp invis fucj y na
                continue
            end

            local Hitbox = Instance.new("Part")
            -- Hitbox.Name = "Hitbox"
            Hitbox.Anchored = true
            Hitbox.CanCollide = false
            Hitbox.CanQuery = false
            Hitbox.CastShadow = false
            Hitbox.CFrame = Part.CFrame
            Hitbox.Color = Color
            Hitbox.Material = Enum.Material.ForceField -- certified hitbox bro
            Hitbox.Size = Part.Size * 1.1
            Hitbox.Transparency = 0.5
            Hitbox.Parent = Workspace

            table.insert(Hitboxes, Hitbox)
        end

        task.wait(2)

        for _, Hitbox in pairs(Hitboxes) do
            Hitbox:Destroy()
        end 
    end

    function Utility.CreateBulletTracer(Start, End)
        local Beam = Instance.new("Beam", Workspace)
        local Attachment1 = Instance.new("Attachment", Beam)
        local Attachment2 = Instance.new("Attachment", Beam)

        -- Beam.Name = "BulletTracer"
        Beam.Attachment0 = Attachment1
        Beam.Attachment1 = Attachment2
        Beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
        -- Beam.Enabled = true
        Beam.FaceCamera = true -- very important
        -- Beam.LightEmission = 0
        -- Beam.LightInfluence = 0
        Beam.Texture = "rbxassetid://446111271"
        Beam.TextureLength = 2
        -- Beam.TextureMode = Enum.TextureMode.Wrap
        -- Beam.Width0 = 1
        -- Beam.Width1 = 1
        -- Beam.ZOffset = 1

        Attachment1.WorldPosition = Start
        Attachment2.WorldPosition = End

        task.wait(2)

        Beam:Destroy()
    end

    function Utility.SetupPlayer(Player)
        local Data = {
            Player = Player,
            Friend = Player and LocalPlayer:IsFriendsWith(Player.UserId) or nil
        }

        Utility.Players[Player] = Data
    end

    function Utility.RemovePlayer(Player)
        Utility.Players[Player] = nil
    end

    function Utility.GetBoundingBox(Character, RootPart)
        local CharacterSize = Vector3.new()

        for _, Part in pairs(Character:GetChildren()) do
            if not Part:IsA("BasePart") then -- or Part.Transparency == 1
                continue
            end

            if string.find(Part.Name:lower(), "head") then
                CharacterSize += Vector3.new(Part.Size.X, Part.Size.Y, 0)
            elseif string.find(Part.Name:lower(), "torso") then
                CharacterSize += Vector3.new(0, Part.Size.Y, 0)
            elseif string.find(Part.Name:lower(), "arm") then
                CharacterSize += Vector3.new(Part.Size.X, 0, 0)
            elseif string.find(Part.Name:lower(), "leg") then
                CharacterSize += Vector3.new(0, Part.Size.Y, 0)
            end
        end

        local Rotation = CurrentCamera.CFrame - CurrentCamera.CFrame.Position
        local Width = Rotation * Vector3.new(CharacterSize.X / 2, 0, 0)
        local Height = Rotation * Vector3.new(0, CharacterSize.Y / 2, 0)
        local RootPartPosition = RootPart.CFrame.Position

        Width = CurrentCamera:WorldToViewportPoint(RootPartPosition + Width).X - CurrentCamera:WorldToViewportPoint(RootPartPosition - Width).X
        Height = CurrentCamera:WorldToViewportPoint(RootPartPosition - Height).Y - CurrentCamera:WorldToViewportPoint(RootPartPosition + Height).Y

        local BoxSize = Vector2.new(Width, Height)
        local Center = CurrentCamera:WorldToViewportPoint(RootPartPosition - Vector3.new(0, 0.125, 0))

        return Vector2.new(Center.X - BoxSize.X / 2, Center.Y - BoxSize.Y / 2), BoxSize
    end

    function Utility.LerpColor(Color1, Color2, Ratio)
        return Color3.new(
            Color1.R + (Color2.R - Color1.R) * Ratio,
            Color1.G + (Color2.G - Color1.G) * Ratio,
            Color1.B + (Color2.B - Color1.B) * Ratio
        )
    end

    function Utility.RenderPlayerOutline(Data)
        Data.Pass = false

        local Player = Data.Player

        if not Player then
            return
        end

        if Player.Team.Name == "Lobby" then
            return
        end

        local Character = Player.Character

        if not Character then
            return
        end

        local Type = Data.Friend and "Friends" or ConfigModule.teamkillCheck(LocalPlayer, Player) and "Enemy" or "Team"

        Data.Type = Type

        if not Library.Flags[Type .. "/Enabled"] then
            return
        end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")

        if not Humanoid or Humanoid.Health <= 0 then
            return
        end

        local RootPart = Humanoid.RootPart

        if not RootPart then
            return
        end
        
        local _, Visible = CurrentCamera:WorldToViewportPoint(RootPart.CFrame.Position)

        if not Visible then
            return
        end

        Data.Humanoid = Humanoid

        local BoxPosition, BoxSize = Utility.GetBoundingBox(Character, RootPart)

        Data.BoxSize = BoxSize
        Data.BoxPosition = BoxPosition

        local Components = Library.Flags[Type .. "/Components"]
        
        if table.find(Components, "Player name") then
            DrawingImmediate.OutlinedText(
                BoxPosition + Vector2.new(BoxSize.X / 2, -14),
                3,
                14,
                Color3.fromRGB(255, 255, 255),
                1,
                Color3.fromRGB(0, 0, 0),
                1,
                Player.Name,
                true
            )
        end

        local ItemEnabled = table.find(Components, "Item name")

        if ItemEnabled then
            local Tool = Character:FindFirstChildOfClass("Tool")

            DrawingImmediate.OutlinedText(
                BoxPosition + Vector2.new(BoxSize.X / 2, BoxSize.Y),
                3,
                14,
                Color3.fromRGB(255, 255, 255),
                1,
                Color3.fromRGB(0, 0, 0),
                1,
                Tool and Tool.Name:upper() or "None",
                true
            )
        end

        if table.find(Components, "Distance") then
            DrawingImmediate.OutlinedText(
                BoxPosition + Vector2.new(BoxSize.X / 2, BoxSize.Y + (ItemEnabled and 14 or 0)),
                3,
                14,
                Color3.fromRGB(255, 255, 255),
                1,
                Color3.fromRGB(0, 0, 0),
                1,
                "[ " .. math.round((CurrentCamera.CFrame.Position - RootPart.CFrame.Position).Magnitude) .. "st ]",
                true
            )
        end

        if Library.Flags[Type .. "/Box"] == "Box + outlines" then
            DrawingImmediate.Rectangle(
                BoxPosition,
                BoxSize,
                Color3.fromRGB(0, 0, 0),
                1,
                0,
                2
            )
        end

        if Library.Flags[Type .. "/Healthbar"] then
            local HealthBarPosition = BoxPosition - Vector2.new(6, 0)

            Data.HealthBarPosition = HealthBarPosition

            DrawingImmediate.FilledRectangle(
                HealthBarPosition,
                Vector2.new(4, BoxSize.Y),
                Color3.fromRGB(0, 0, 0),
                1,
                0
            )
        end

        Data.Pass = true
    end

    function Utility.GetPlayerColor(Data)
        if Utility.Target and Utility.Target.Player == Data.Player then
            return Library.Flags["Colors/Aimbottarget/Colorpicker"]
        end

        -- add playerlist color bullshit

        if Library.Flags["Colors/" .. (Data.Friend and "Friendscheme" or "Scheme")] == "Team based" then
            return Data.Player.TeamColor.Color
        end
        
        if Data.Type == "Enemy" then
            return Library.Flags["Colors/Enemyteam"]
        elseif Data.Type == "Team" then
            return Library.Flags["Colors/Friendlyteam"]
        else
            return Library.Flags["Colors/Friend"]
        end
    end

    function Utility.RenderPlayerInline(Data)
        if not Data.Pass then
            return
        end

        local Type = Data.Type
        local Box = Library.Flags[Type .. "/Box"]

        if Box == "Box" or Box == "Box + outlines" then
            DrawingImmediate.Rectangle(
                Data.BoxPosition,
                Data.BoxSize,
                Utility.GetPlayerColor(Data),
                1,
                0,
                1
            )
        end

        if Library.Flags[Type .. "/Healthbar"] then
            local HealthRatio = Data.Humanoid.Health / Data.Humanoid.MaxHealth

            DrawingImmediate.FilledRectangle(
                Data.HealthBarPosition + Vector2.new(1, Data.BoxSize.Y * (1 - HealthRatio) + 1),
                Vector2.new(2, Data.BoxSize.Y * HealthRatio - 2),
                Utility.LerpColor(Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 0), HealthRatio),
                1,
                0
            )
        end
    end
end

do
    local Window = Library:Window()
    local InformationList = Library:InformationList()

    local AimbotTab = Window:Tab({Name = "Aimbot"})
    local VisualsTab = Window:Tab({Name = "Visuals"})
    local HvHTab = Window:Tab({Name = "Hack vs Hack"})
    local MiscTab = Window:Tab({Name = "Miscellaneous"})
    local PlayerList = Window:PlayerList()

    do
        local AimbotSection = AimbotTab:Section({Name = "Aimbot"})
        local AimbotToggle = AimbotSection:Toggle({Name = "Enabled", Flag = "Aimbot/Enabled"}):Keybind({Mouse = true, StatusName = "Aimbot"})
        local AimbotDependency = AimbotSection:Dependency({Element = AimbotToggle})

        AimbotDependency:Toggle({Name = "Auto shoot", Flag = "Aimbot/Autoshoot"})
        -- AimbotDependency:Toggle({Name = "Multi target", Flag = "Aimbot/Multitarget"})
        AimbotDependency:Slider({Name = "Maximum FOV", Flag = "Aimbot/FOV", Min = 0, Max = 180, Value = 180})
        AimbotDependency:Dropdown({Name = "Silent aim", Flag = "Aimbot/Silentaim", Options = {"Disabled", "Clientside", "Serverside"}, Value = "Clientside"})

        AimbotDependency:Dropdown({Name = "Algorithm", Flag = "Aimbot/Algorithm", Options = {"Closest to FOV", "Distance"}})
        AimbotDependency:Dropdown({Name = "Priority hitbox", Flag = "Aimbot/Priorityhitbox", Options = {"Head", "Torso", "Arm", "Leg"}, Value = {"Head"}})
        AimbotDependency:Dropdown({Name = "Hitscan", Flag = "Aimbot/Hitscan", Multi = true, Options = {"Head", "Torso", "Arm", "Leg"}, Value = {"Head", "Torso"}}) -- accept all hitboxes by default but make it Multipoint
        -- AimbotDependency:Dropdown({Name = "Multipoint", Flag = "Aimbot/Multipoint", Multi = true, Options = {"Head", "Torso", "Arm", "Leg"}, Value = {"Head", "Torso"}})

        local OtherSection = AimbotTab:Section({Name = "Other"})

        OtherSection:Toggle({Name = "Auto melee", Flag = "Other/Automelee"})
        OtherSection:Slider({Name = "Maximum FOV", Flag = "Other/FOV", Min = 0, Max = 180, Value = 180})
    end

    do
        local EnemySection, TeamSection, FriendsSection, ColorsSection = VisualsTab:MultiSection({Sections = {"Enemy", "Team", "Friends", "Colors"}})
        
        for _, Section in pairs({EnemySection, TeamSection, FriendsSection}) do
            local Flag = Section.Name

            Section:Toggle({Name = "Enabled", Flag = Flag .. "/Enabled"})
            Section:Dropdown({Name = "Components", Flag = Flag .. "/Components", Multi = true, Options = {"Player name", "Item name", "Distance"}})
            Section:Dropdown({Name = "Box", Flag = Flag .. "/Box", Options = {"Disabled", "Box", "Box + outlines"}})
            Section:Toggle({Name = "Flags", Flag = Flag .. "/Flags"})
            Section:Dropdown({Name = "Flags list", Flag = Flag .. "/Flags/List", Multi = true, Options = {}})
            Section:Toggle({Name = "Health bar", Flag = Flag .. "/Healthbar"})

            if Flag ~= "Friends" then
                Section:Toggle({Name = "Cheater alerts", Flag = Flag .. "/Cheateralerts"})
            end
        end

        ColorsSection:Dropdown({Name = "Scheme", Flag = "Colors/Scheme", Options = {"Team based", "Custom"}})
        ColorsSection:Colorpicker({Name = "Enemy team", Flag = "Colors/Enemyteam", Value = Color3.fromRGB(255, 0, 0)})
        ColorsSection:Colorpicker({Name = "Friendly team", Flag = "Colors/Friendlyteam", Value = Color3.fromRGB(0, 0, 255)})
        ColorsSection:Toggle({Name = "Aimbot target", Flag = "Colors/Aimbottarget"}):Colorpicker({Value = Color3.fromRGB(128, 0, 128)})
        ColorsSection:Dropdown({Name = "Friend scheme", Flag = "Colors/Friendscheme", Options = {"Single color", "Team based"}})
        ColorsSection:Colorpicker({Name = "Friend", Flag = "Colors/Friend", Value = Color3.fromRGB(0, 255, 0)})

        local ObjectsSection = VisualsTab:Section({Name = "Objects", Side = "Left"})

        ObjectsSection:Dropdown({Name = "Weapons", Flag = "Objects/Weapons", Multi = true, Options = {}})
        ObjectsSection:Dropdown({Name = "Cards", Flag = "Objects/Cards", Multi = true, Options = {"Level 1", "Level 2", "Level 3", "Level 4", "Level 5"}})
        ObjectsSection:Dropdown({Name = "Throwables", Flag = "Objects/Throwables", Multi = true, Options = {"Frag Grenade", "Incendiary Grenade", "Smoke Grenade", "Flashbang"}})
        ObjectsSection:Dropdown({Name = "Other", Flag = "Objects/Other", Multi = true, Options = {"Medkit", "Primary Ammo", "Secondary Ammo"}})

        local OtherSection = VisualsTab:Section({Name = "Other"})

        OtherSection:Colorpicker({Name = "Menu Foreground", Flag = "Other/MenuForeground", Value = Color3.fromRGB(0, 128, 255), Callback = function(Color)
            Framework.UpdateTheme("Foreground", Color)
        end})
        OtherSection:Colorpicker({Name = "Menu Background", Flag = "Other/MenuBackground", Value = Color3.fromRGB(32, 32, 32), Callback = function(Color)
            Framework.UpdateTheme("Background", Color)
        end})
        OtherSection:Toggle({Name = "Show hitboxes on hit", Flag = "Other/Showhitboxesonhit"}):Colorpicker({Value = Color3.fromRGB(255, 0, 0)})
        OtherSection:Slider({Name = "Custom FOV", Flag = "Other/CustomFOV", Min = 1, Max = 120, Value = CurrentCamera.FieldOfView})
        OtherSection:Dropdown({Name = "Removals", Flag = "Other/Removals", Multi = true, Options = {"Flashbang"}})
        OtherSection:Toggle({Name = "Bullet tracers", Flag = "Other/Bullettracers"})
        OtherSection:Toggle({Name = "Thirdperson", Flag = "Other/Thirdperson"}):Keybind({IgnoreList = true})
        OtherSection:Slider({Name = "Max distance", Flag = "Other/Thirdperson/Distance", Min = 0, Max = 10, Unit = "st"})
        OtherSection:Toggle({Name = "Show information panel", Flag = "Other/Showinformationpanel", Value = true, Callback = function(Value)
            InformationList.Enabled = Value
        end})
        OtherSection:Toggle({Name = "Viewmodel show silent aim", Flag = "Other/Viewmodelshowsilentaim"})
        OtherSection:Toggle({Name = "Viewmodel offset", Flag = "Other/Viewmodeloffset"})
        OtherSection:Slider({Name = "Forward", Flag = "Other/Viewmodeloffset/Forward", Min = -10, Max = 10, Unit = "st", Value = 0})
        OtherSection:Slider({Name = "Right", Flag = "Other/Viewmodeloffset/Right", Min = -10, Max = 10, Unit = "st", Value = 0})
        OtherSection:Slider({Name = "Up", Flag = "Other/Viewmodeloffset/Up", Min = -10, Max = 10, Unit = "st", Value = 0})
    end

    do
        local AASection = HvHTab:Section({Name = "Antiaim"})
        local AAToggle = AASection:Toggle({Name = "Enable", Flag = "Antiaim/Enable"}):Keybind({Mouse = true, StatusName = "ANTI AIM"})
        local AADependency = AASection:Dependency({Element = AAToggle})

        -- AADependency:Dropdown({Name = "Pitch", Flag = "Antiaim/Pitch", Options = {"Disabled"}})
        AADependency:Toggle({Name = "Yaw", Flag = "Antiaim/Yaw"})
        AADependency:Toggle({Name = "Auto edge", Flag = "Antiaim/Autoedge"})
        AADependency:Dropdown({Name = "Based on angle", Flag = "Antiaim/Basedonangle", Options = {"Local angles", "Closest player"}})
        -- Cycle key
        AADependency:Dropdown({Name = "Method", Flag = "Antiaim/Method", Options = {"Rotate", "Rotate dynamic", "Spin"}, Callback = function(Option)
            if Option == "Spin" then
                Utility.SpinAngle = 0
            end
        end})
        -- AADependency:Dropdown({Name = "Rotate target", Flag = "Antiaim/Rotatetarget", Options = {"Rotate", "Rotate dynamic", "Spin"}})
        AADependency:Slider({Name = "Updaterate", Flag = "Antiaim/Updaterate", Min = 250, Max = 2500, Unit = "ms", Value = 250})
        AADependency:Slider({Name = "Angle #1", Flag = "Antiaim/Angle#1", Min = -180, Max = 180, Value = 0, Callback = function()
            Utility.SpinAngle = 0
        end})
        AADependency:Slider({Name = "Angle #2", Flag = "Antiaim/Angle#2", Min = -180, Max = 180, Value = 0})

        local OtherSection = HvHTab:Section({Name = "Other"})
    end

    do
        local GeneralSection = MiscTab:Section({Name = "General"})

        GeneralSection:Toggle({Name = "Noclip", Flag = "General/Noclip"}):Keybind({FalseInvisible = true})
        GeneralSection:Toggle({Name = "Speed", Flag = "General/Speed"}):Keybind({FalseInvisible = true})
        GeneralSection:Slider({Name = "Speed factor", Flag = "General/Speed/Factor", Min = 1, Max = 200, Unit = "st/s", Value = 20})
        GeneralSection:Toggle({Name = "Infinite stamina", Flag = "General/Infinitestamina"})
        GeneralSection:Toggle({Name = "No footstep noise", Flag = "General/Nofootstepnoise"})
        GeneralSection:Toggle({Name = "Disable SCP-096 trigger", Flag = "General/DisableSCP-096trigger"})
        --[[GeneralSection:Keybind({Name = "Self SCP-096 trigger", Flag = "General/SelfSCP-096trigger", Callback = function()
            if LocalPlayer:GetAttribute("Role") == "SCP-096" then
                Bridges.SCPHandler:Fire({
                    ["Arg"] = "SeenFace",
                    ["SCP"] = LocalPlayer
                })
            end
        end})]]
        GeneralSection:Toggle({Name = "Gun modifications", Flag = "General/Gunmodifications", Callback = Utility.ApplyGunMods})
        GeneralSection:Slider({Name = "Recoil scale", Flag = "General/Gunmodifications/Recoilscale", Min = 0, Max = 100, Unit = "%", Value = 100, Callback = Utility.ApplyGunMods})
        GeneralSection:Slider({Name = "Spread scale", Flag = "General/Gunmodifications/Spreadscale", Min = 0, Max = 100, Unit = "%", Value = 100, Callback = Utility.ApplyGunMods})
        GeneralSection:Slider({Name = "Reload speed scale", Flag = "General/Gunmodifications/Reloadspeedscale", Min = 100, Max = 1000, Unit = "%", Value = 100, Callback = Utility.ApplyGunMods})
        GeneralSection:Slider({Name = "Fire rate scale", Flag = "General/Gunmodifications/Fireratescale", Min = 100, Max = 1000, Unit = "%", Value = 100, Callback = Utility.ApplyGunMods})
        GeneralSection:Toggle({Name = "Full auto", Flag = "General/Gunmodifications/Fullauto", Callback = Utility.ApplyGunMods})
        GeneralSection:Toggle({Name = "Semi infinite ammo", Flag = "General/Gunmodifications/Semiinfiniteammo", Callback = Utility.ApplyGunMods})
        GeneralSection:Toggle({Name = "Semi onetap", Flag = "General/Gunmodifications/Semionetap"})
        GeneralSection:Toggle({Name = "Auto reload", Flag = "General/Gunmodifications/Autoreload"})

        local OtherSection = MiscTab:Section({Name = "Other"})
    end

    Library:AutoLoad("SCP retroBreach")
end

do
    RunService.RenderStepped:Connect(function(Delta)
        Utility.Parts.Character, Utility.Parts.Head, Utility.Parts.Humanoid, Utility.Parts.RootPart, Utility.Parts.Animator = Utility.GetParts(LocalPlayer)
        Utility.Ping = Ping:GetValue()

        Utility.Aimbot()
        Utility.Meleebot()
        Utility.HvH()
        Utility.Misc(Delta)

        if StaminaFunction and Library.Flags["General/Infinitestamina"] then
            debug.setupvalue(StaminaFunction, 6, 100)
        end
    end)

    DrawingImmediate.GetPaint(0):Connect(function()
        for _, Data in pairs(Utility.Players) do
            Utility.RenderPlayerOutline(Data)
        end
    end)

    DrawingImmediate.GetPaint(1):Connect(function()
        for _, Data in pairs(Utility.Players) do
            Utility.RenderPlayerInline(Data)
        end
    end)

    Players.PlayerAdded:Connect(Utility.SetupPlayer)
    Players.PlayerRemoving:Connect(Utility.RemovePlayer)

    LocalPlayer.CharacterAdded:Connect(function(Character)
        repeat
            task.wait()
        until Character

        table.insert(Utility.IgnoreList, Character)

        repeat
            task.wait()
        until Character:FindFirstChild("Humanoid")

        Utility.CharacterSetup()

        repeat
            task.wait()
        until Character:FindFirstChild("WeaponSystem")

        Utility.GrabWeaponSystem()

        repeat
            task.wait()
        until Character:FindFirstChild("RunController")

        Utility.GrabStaminaFunction()
    end)
end

do
    for _, Player in pairs(Players:GetPlayers()) do
        if Player == LocalPlayer then
            continue
        end

        Utility.SetupPlayer(Player)
    end

    Utility.CharacterSetup()
    Utility.GrabWeaponSystem()
    Utility.GrabStaminaFunction()
end

do
    local Fire; Fire = hookfunction(Functions.Fire, function(Bridge, Args)
        local Name = Bridge._name

        if not checkcaller() then
            if Name == "__fireWeapon" and Utility.Target then -- no target no aimbot
                local HitPosition = Utility.Target.HitPosition

                for _, Shot in pairs(Args.bullets) do
                    --[[local Direction = (HitPosition - Shot.startPosition).Unit

                    Shot.mouseVector = Direction
                    Shot.direction = Direction * 1000
                    Shot.endPosition = HitPosition]]
                    Shot.hitPart = Utility.Target.HitPart
                end
            elseif Name == "SCPHandler" and Args.SCP and Args.SCP ~= LocalPlayer and Library.Flags["General/DisableSCP-096trigger"] then
                return
            elseif Name == "ReportBridge" then -- gay ac
                return
            end
        end

        if Name == "__fireWeapon" then
            --[[local ServerTime = Args.sentAt -- Workspace:GetServerTimeNow() -- patched 0/0 so gaye!
            local Spread = WeaponSystem.wepStats.Spread

            for Index, Shot in pairs(Args.bullets) do
                -- local Direction = (Shot.endPosition - Shot.startPosition).Unit
                local Spread = Utility.CalculateSpread(ServerTime, Index, Spread, Shot.direction)

                local RaycastResult = Workspace:Raycast(Shot.startPosition, Spread * 1000, Utility.GetIgnoreList())

                -- Shot.mouseVector = Direction
                Shot.direction = Spread * 1000
                Shot.endPosition = RaycastResult and RaycastResult.Position or (Shot.startPosition + Spread * 1000)
                -- Shot.hitPart = Utility.Target.HitPart
            end]]

            -- Args.sentAt = ServerTime

            if Library.Flags["Other/Showhitboxesonhit"] then
                local HitPlayers = {}

                for _, Shot in pairs(Args.bullets) do
                    local HitPart = Shot.hitPart

                    if not HitPart then
                        continue
                    end

                    local Character = HitPart.Parent

                    --[[if not Character then
                        return
                    end]]

                    local Humanoid = Character:FindFirstChildOfClass("Humanoid") -- is it actually a player and not some random wall

                    if not Humanoid then
                        continue
                    end

                    local Player = Players:GetPlayerFromCharacter(Character)

                    if not Player then
                        continue
                    end

                    if HitPlayers[Player] then
                        continue
                    end

                    if not ConfigModule.teamkillCheck(LocalPlayer, Player) then
                        continue
                    end

                    HitPlayers[Player] = true

                    task.spawn(Utility.CreateHitboxes, Character) -- dont wanna delay shots
                end
            end

            if Library.Flags["Other/Bullettracers"] then
                local Start = (WeaponSystem and WeaponSystem.weaponModel and WeaponSystem.weaponModel:FindFirstChild("_Handle") and WeaponSystem.weaponModel._Handle.Barrel)
                
                for _, Shot in pairs(Args.bullets) do
                    task.spawn(Utility.CreateBulletTracer, Start and Start.WorldPosition or Shot.startPosition, Shot.endPosition)
                end
            end

            if Library.Flags["General/Gunmodifications/Semiinfiniteammo"] then
                Utility.GrabAmmo()
            end

            if Library.Flags["General/Gunmodifications/Autoreload"] then
                Utility.Reload(true)
            end

            if Library.Flags["General/Gunmodifications/Semionetap"] then
                local Damage = WeaponSystem.wepStats.Damage
                local BulletsFired = math.clamp(WeaponSystem.wepStats.BulletsFired, 1, 20)
                local Mag = WeaponSystem.equipped.Ammo.Mag

                for _, Shot in pairs(Args.bullets) do
                    local HitPart = Shot.hitPart

                    if not HitPart then
                        continue
                    end

                    local Character = HitPart.Parent

                    --[[if not Character then
                        return
                    end]]

                    local Humanoid = Character:FindFirstChildOfClass("Humanoid") -- is it actually a player and not some random wall

                    if not Humanoid or Humanoid.Health <= 0 then
                        continue
                    end

                    if (Utility.PredictedDamage[Humanoid] or 0) >= Humanoid.Health then
                        continue
                    end

                    local Player = Players:GetPlayerFromCharacter(Character)

                    if not Player then
                        continue
                    end

                    if not ConfigModule.teamkillCheck(LocalPlayer, Player) then
                        continue
                    end

                    for _ = 1, Utility.BonusShot(Humanoid, Damage, HitPart, BulletsFired, Mag.Value) do
                        Mag.Value -= 1

                        Fire(Bridge, Args)
                    end

                    break -- it how or why but predicted damage fucking didnt owrk??
                end
            end
        elseif Name == "repReload" then
            if Library.Flags["General/Gunmodifications/Autoreload"] then
                Utility.Reload(true)
            end
        end

        return Fire(Bridge, Args)
    end)

    local Namecall, NewIndex, Index = nil, nil, nil

    Namecall = hookmetamethod(game, "__namecall", function(Self, ...)
        local Script = getcallingscript()
        local Method = getnamecallmethod()
        local Args = {...}

        if not checkcaller() then
            if Method == "Raycast" and Script.Name == "WeaponSystem" and Utility.Target then
                Utility.SilentAim()

                Args[2] = (Utility.Target.HitPosition - Args[1]).Unit * 1000

                return Namecall(Self, unpack(Args))
            end
        end

        return Namecall(Self, ...)
    end)
    NewIndex = hookmetamethod(game, "__newindex", function(Self, Key, Value)
        if not checkcaller() then
            if Self:IsA("Humanoid") and Key == "AutoRotate" and Utility.CustomRotation then -- thats so gay bro
                return
            elseif Self == CurrentCamera and Key == "CFrame" then
                if Library.Flags["Other/Thirdperson"] then -- hide the arms
                    local Origin = Value.Position
                    local Distance = Library.Flags["Other/Thirdperson/Distance"]
                    local CameraCFrame = Value * CFrame.new(0, 0, Distance)
                    local RaycastResult = Workspace:Raycast(Origin, (CameraCFrame.Position - Origin).Unit * Distance, Utility.GetIgnoreList(true))

                    if RaycastResult then
                        CameraCFrame = Value * CFrame.new(0, 0, RaycastResult.Distance)
                    end

                    Value = CameraCFrame
                end
            elseif Self.Name == "ViewmodelBox" and Key == "CFrame" then
                if Utility.Target and Library.Flags["Other/Viewmodelshowsilentaim"] then
                    Value = CFrame.new(Value.Position, Utility.Target.HitPosition)
                end

                if Library.Flags["Other/Viewmodeloffset"] then
                    Value *= CFrame.new(
                        Library.Flags["Other/Viewmodeloffset/Right"],
                        Library.Flags["Other/Viewmodeloffset/Up"],
                        Library.Flags["Other/Viewmodeloffset/Forward"]
                    )
                end

                if Library.Flags["Other/Thirdperson"] then -- hide the arms
                    Value *= CFrame.new(0, 0, -200)
                end
            end
        else
            if Self:IsA("Humanoid") and Key == "AutoRotate" then
                Utility.CustomRotation = not Value
            end
        end

        return NewIndex(Self, Key, Value)
    end)
    --[[Index = hookmetamethod(game, "__index", function(Self, Key)
        return Index(Self, Key)
    end)]]
end
