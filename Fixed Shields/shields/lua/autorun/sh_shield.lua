vs = vs or {}
pMeta = FindMetaTable( "Player" )

function pMeta:GetShields()
    return self:GetNWInt( "QShield", 0 )
end

function pMeta:HasShields()
    return self:GetShields() > 0 and true or false
end

function pMeta:HasMaxShields()
    return self:GetShields() >= vs.shield.max and true or false
end

function pMeta:HasRoseTint()
    return self:GetNWBool( "QShieldTint", false )
end

function pMeta:GetShieldCooldown()
    local b = self:GetNWInt( "QShieldCooldownEnd", 0 )
    return math.Clamp( math.Round(b-CurTime()), 0, 999999 )
end

function pMeta:HasShieldCooldown()
    return self:GetShieldCooldown() > 0 and true or false
end

function pMeta:HasShieldActive()
    return self:GetNWBool( "QShieldActive", false )
end