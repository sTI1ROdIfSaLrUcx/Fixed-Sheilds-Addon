include("shared.lua")

for i=12, 45 do // Not as expensive as people think...
	surface.CreateFont( "ui."..i, { font = "Montserrat", size = i }) 
	surface.CreateFont( "uib."..i, { font = "Montserrat", size = i, weight = 1024 })
end
function ENT:Draw()
	self:DrawModel()

	local p, w, h = LocalPlayer(), ScrW(), ScrH()
	if p:GetPos():Distance( self:GetPos() ) > 250 then return end

	local pos = self:GetPos() + Vector( 0, 0, self:OBBMaxs().z ) + Vector(0,0,math.sin(CurTime()*1+self:EntIndex()))
	local ang = p:EyeAngles()

	ang:RotateAroundAxis( ang:Right(), 90 )
	ang:RotateAroundAxis( ang:Up(), -90 )
	pos = pos + Vector( 0, 0, 10 )

	cam.Start3D2D( pos, ang, 0.1 )
		local text = "Shield Seller"

		surface.SetFont( "ui.35" )
		local tW, _ = surface.GetTextSize( text ) + w*.01
		draw.RoundedBox( 0, -tW/2, 30, tW, 55, Color( 0, 0, 0, 220 ) )
        draw.RoundedBox( 0, -tW/2, 30, tW, 5, Color( 50, 50, 50, 255 ) )
        draw.RoundedBox( 0, -tW/2, 80, tW, 5, Color( 50, 50, 50, 255 ) )
        draw.RoundedBox( 0, -tW/2, 30, tW, 5, Color( 50, 50, 50, 255 ) )
        draw.RoundedBox( 0, -tW/2, 30, 5, 55, Color( 50, 50, 50, 255 ) )
        draw.RoundedBox( 0, 175/2, 30, 5, 55, Color( 50, 50, 50, 255 ) )

		draw.SimpleText( text, "ui.35", 0, 55, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	cam.End3D2D()
end