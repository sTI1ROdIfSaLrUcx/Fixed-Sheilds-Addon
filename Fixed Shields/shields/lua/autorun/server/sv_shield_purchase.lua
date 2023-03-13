local function ShieldSystem_Distance( p, a ) // player, distance
    local vendor = false
    for _, e in pairs( ents.FindByClass( "elite_shield_npc" ) ) do
        if ( p:GetPos():Distance( e:GetPos() ) < a ) then
            vendor = true
            break
        end
    end 
    return vendor
end

local function ShieldSystem_Purchase( p, k ) // player, shield
    local sData = vs.shield
    if !sData and !k then return end
    if ( k < 1 or k > sData.max ) then return end
    if !ShieldSystem_Distance( p, 140 ) then return end

    do // Checks if the player is on cooldown
        if p:HasShieldCooldown() then
            DarkRP.notify( p, 1, 4, "You're currently on cooldown! - " .. p:GetShieldCooldown() )
            return
        end
    end
    local price = sData.price
    local canAfford = p:canAfford( price * k )

    do // Checks if the player reaches certain amount of shield(s)
        if ( k == sData.max and p:HasShields() ) then return end -- prevents players buying "max shields" while currently holding shields
        if ( k + p:GetShields() > sData.max ) then return end
        if ( p:HasMaxShields() ) then
            DarkRP.notify( p, 0, 4, "You've already got max shields!" )
            return
        end
    end

    do // Checks if the player can afford the shield(s)
        if ( !canAfford ) then
            DarkRP.notify( p, 1, 4, "You're unable to afford this!" )
            return
        end
        p:addMoney( -price )

        if !p:HasShields() then
            _ShieldSystem_ShieldProp( p, sData.material )
            timer.Simple( 4, function()
                if IsValid( p.shield ) then p.shield:Remove() end
            end )
        end

        -- For bLogs
        hook.Run( "Bubble_Bought_Shield", p, k, p:GetShields() + k )

        p:AddShields( k )
    end
end

local function ShieldSystem_PurchaseTint( p ) // player
    local sData = vs.shield
    if !sData then return end
    if !ShieldSystem_Distance( p, 140 ) then return end
    if !p:HasShields() then return end
    local price = sData.roseTint
    local canAfford = p:canAfford( price )

    do // Checks if the player already has Tint or if they can afford it
        if p:HasRoseTint() then
            DarkRP.notify( p, 1, 4, "You already have rose tint!" )
            return
        end

        if ( !canAfford ) then
            DarkRP.notify( p, 1, 4, "You're unable to afford this!" )
            return
        end

        DarkRP.notify( p, 2, 4, "You've purchased 'Rose Tint'" )
        p:SetRoseTint( true )
        p:addMoney( -price )
    end
end
concommand.Add( "eliteshield.buy", function( p, _, t )
    local k = tonumber( t[1] or 0 )
    ShieldSystem_Purchase( p, k )
end )

concommand.Add( "eliteshieldtint.buy", function( p )
    ShieldSystem_PurchaseTint( p )
end )