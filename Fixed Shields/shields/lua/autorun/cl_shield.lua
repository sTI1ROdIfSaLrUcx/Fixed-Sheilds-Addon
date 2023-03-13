if !CLIENT then return end
for i=12, 45 do
	surface.CreateFont( "ui."..i, { font = "Montserrat", size = i }) 
	surface.CreateFont( "uib."..i, { font = "Montserrat", size = i, weight = 1024 })
end
surface.CreateFont("shs", {
	font = "Montserrat",
	size = 25,
	antialias = true
})
local shieldData = {}
timer.Simple( 0, function() RunConsoleCommand( "elite.shield.sync" ) end )
net.Receive( "elite.shield.sync", function() shieldData = net.ReadTable() end )

local clamp = function(value, min, max)
    if (value > max) then value = max end
    if (value < min) then value = min end

    return value
end

concommand.Add("elite.shield", function( p )
    local w, h = ScrW(), ScrH()
    local W, H = w*.30, h*.25
    local lp = LocalPlayer()

    local DFrame = vgui.Create( "XeninUI.Frame" )
    DFrame:SetTitle( "Shield Purchase" )
    DFrame:MakePopup()
    DFrame:SetSize( W, H )
    DFrame:DockPadding( 0, 0, 0, 0 )
    DFrame:Center()
    DFrame.Think = function( s )
        if input.IsKeyDown( KEY_TAB ) then 
            s:Close() 
        end
    end

    local DPanel = vgui.Create( "DPanel", DFrame )
    DPanel:Dock( TOP )
    DPanel:DockMargin( W*.08, H*.08, W*.08, W*.08 )
    DPanel:SetTall( H*.75 )
    DPanel.Paint = nil

    local bntList = { 
        { name = "Max Shield", price = shieldData.price * (shieldData.max - lp:GetShields()), count = (shieldData.max - lp:GetShields()), type = 1 },
        { name = "1 Shield", price = shieldData.price, count = 1, type = 1 },
        { name = "Rose Tinted Glasses", price = shieldData.roseTint, type = 2 },
    }

    local function refreshList(addedShield)
        local shields = clamp(lp:GetShields() + addedShield, 0, 5)
        bntList = {
            { name = "Max Shield", price = shieldData.price * (shieldData.max - shields), count = (shieldData.max - shields), type = 1 },
            { name = "1 Shield", price = shieldData.price, count = 1, type = 1 },
            { name = "Rose Tinted Glasses", price = shieldData.roseTint, type = 2 },
        }
    end

    for k, v in pairs( bntList ) do
        local DButton = vgui.Create( "PIXEL.TextButton", DPanel )
        DButton:Dock( TOP )
        DButton:DockMargin( 0, 0, 0, H*.08 )
        DButton:SetTall( H*.18 )
        DButton:SetText( "" )
        DButton.ID = k
        DButton.Paint = function( s, w, h )
            if s:IsHovered() then
                draw.RoundedBox( 5, 0, 0, w, h, Color( 128, 128, 128 ) )
            else
                draw.RoundedBox( 5, 0, 0, w, h, Color( 128, 128, 128 ) )
            end
            if bntList[DButton.ID].price then
                draw.SimpleText( v.name .. " / " .. DarkRP.formatMoney( bntList[DButton.ID].price ), "ui.20", w*.5, h*.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            elseif bntList[DButton.ID].tokens then
                draw.SimpleText( v.name .. " / " .. string.Comma( bntList[DButton.ID].tokens ) .. " Tokens", "ui.20", w*.5, h*.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
            end
        end
        DButton.DoClick = function()
            if ( !v.type ) then return end

            if (v.type == 1) then
                RunConsoleCommand("eliteshield.buy", v.count)

                if (v.count + LocalPlayer():GetShields() >= shieldData.max) then
                    DFrame:Remove()
                end

                refreshList(v.count)
            else
                RunConsoleCommand("eliteshieldtint.buy")
                DFrame:Remove()
            end
        end
    end
end)

hook.Add("HUDPaint", "eliteShield.HUD", function()
    local p, w, h = LocalPlayer(), ScrW(), ScrH()
    if !p:HasShields() then return end
    draw.RoundedBox( 0, w*.46,h - (h * .039), w * .1, h * .03, Color( 30, 30, 30,240 ) )
    draw.RoundedBox( 0, w*.46,h - (h * .01), w * .1, h * .006,Color(128, 128, 128 ) )
    draw.SimpleText( "Active Shields: " .. p:GetShields(), "shs", w *.509, h*.974, Color( 128, 128, 128 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end)