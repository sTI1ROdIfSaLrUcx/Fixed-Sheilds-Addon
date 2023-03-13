util.AddNetworkString( "elite.shield.sync" )

local function ShieldSystem_Sync_Data()
    local t = {}
    for k, v in pairs( vs.shield ) do
        t[k] = t[k] or {}
        t[k] = TypeID(v) != TYPE_FUNCTION and v or nil        
    end
    return t
end
function ShieldSystem_Sync( p )
    if !IsValid( p ) then return end
    net.Start( "elite.shield.sync" )
        net.WriteTable( ShieldSystem_Sync_Data() )
    net.Send( p )
end
concommand.Add( "elite.shield.sync", function( p ) ShieldSystem_Sync( p ) end )

function ShieldSystem_SyncAll()
    for _, p in pairs( player.GetAll() ) do
        ShieldSystem_Sync( p )
    end
end