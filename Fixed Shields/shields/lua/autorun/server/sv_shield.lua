-- shield amount
function pMeta:SetShields(a)
    if not isnumber(a) then return end
    self:SetNWInt("QShield", a)
end

-- shield amount
function pMeta:AddShields(a)
    if not isnumber(a) then return end
    local i = self:GetShields()
    self:SetShields(i + a)
end

-- true or false
function pMeta:SetRoseTint(a)
    if not isbool(a) then return end
    self:SetNWBool("QShieldTint", a)
end

-- cooldown amount
function pMeta:SetShieldCooldown()
    local sData = vs.shield
    if not sData then return end
    local delay = sData.cooldown
    self:SetNWInt("QShieldCooldownEnd", CurTime() + delay)
end

-- true or false
function pMeta:SetShieldActive(a)
    if not isbool(a) then return end
    self:SetNWBool("QShieldActive", a)
end

hook.Add("PlayerSpawn", "ShieldSystem.Spawn", function(p)
    p:SetShields(0)
    p:SetRoseTint(false)
    p:SetShieldActive(false)
    p:SetMaterial("")
end)

-- player, material
function _ShieldSystem_ShieldProp(p, m)
    if not IsValid(p) then return end
    if IsValid(p.shield) then return end
    p.shield = ents.Create("elite_shield")
    p.shield:SetMaterial("Models/effects/comball_tape")
    p.shield:SetPos(p:WorldSpaceCenter())
    p.shield:SetOwner(p)
    p.shield:SetParent(p, 1)
    p.shield:Spawn()
end

hook.Add("PlayerShouldTakeDamage", "brek", function(e, t)
    local sData = vs.shield
    local p = e:IsPlayer() and e
    if not p:HasShields() then return end
    if p:HasSuit() then return end

    return false
end)

hook.Add("PostEntityTakeDamage", "ShieldSystem.Damage", function(e, t)
    local sData = vs.shield
    if not sData then return end
    local p = e:IsPlayer() and e
    local ply = e:IsPlayer() and e
    local att = t:GetAttacker()
    local inf = t:GetInflictor()
    local fall = t:IsFallDamage()
    if not p then return end
    if not att then return end
    if SH_SZ and SH_SZ:GetSafeStatus(ply) == SH_SZ.PROTECTED then return end
    if p:HasSuit() then return end
    if not p:HasShields() then return end

    if p:HasShields() and not p:HasShieldActive() then
        p:SetShieldActive(true)
        _ShieldSystem_ShieldProp(p, sData.material)
        p:AddShields(-1)
        sound.Play("Breakable.Glass", p:GetPos(), 128, 128)

        -- For bLogs
        hook.Run( "Bubble_Broken_Shield", p, t:GetAttacker(), p:GetShields() )

        if p:GetShields() <= 0 then
            p:SetShields(0)
            p:SetRoseTint(false)
            p:SetShieldCooldown()
        end

        timer.Simple(sData.delay, function()
            p:SetShieldActive(false)
            local hasShield = IsValid(p.shield)

            if hasShield then
                p.shield:Remove()
            end

            if p:HasShields() then return end

            if p:IsOnFire() then
                p.shield:Remove()
            end
        end)
    end
end)

hook.Add("Think", "ShieldSystem.Crouch", function()
    local sData = vs.shield
    if not sData then return end
    if not sData.crouch.enable then return end

    for _, p in pairs(player.GetAll()) do
        if not IsValid(p) then continue end
        if p:GetMoveType() == MOVETYPE_NOCLIP then continue end
        if not p:HasShields() then continue end
        if not p:HasRoseTint() then continue end
        if not p:Alive() then continue end
        if p:HasShieldActive() then continue end
        local hasShield = IsValid(p.shield)

        if not p:Crouching() and hasShield then
            p.shield:Remove()
        end

        if hasShield then continue end

        if p:Crouching() then
            _ShieldSystem_ShieldProp(p, sData.crouch.material)
        end
    end
end)

hook.Add("PlayerDeath", "ShieldSystem.RemoveShield", function(p)
    local hasShield = IsValid(p.shield)

    if hasShield then
        p.shield:Remove()
    end
end)