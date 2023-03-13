local BROKE_MODULE, BOUGHT_MODULE = GAS.Logging:MODULE(), GAS.Logging:MODULE()

BROKE_MODULE.Category = "Bubble Shields"
BROKE_MODULE.Name = "Damage"
BROKE_MODULE.Colour = Color( 255, 212, 125 )

BOUGHT_MODULE.Category = "Bubble Shields"
BOUGHT_MODULE.Name = "Purchases"
BOUGHT_MODULE.Colour = Color( 255, 212, 125 )

BROKE_MODULE:Setup( function()
	BROKE_MODULE:Hook( "Bubble_Broken_Shield", "shield_broke_hook", function( ply, ply2, shield_count )
		BROKE_MODULE:Log( "{1} has broke a shield of {2} leaving them with {3}.", GAS.Logging:FormatPlayer(ply2), GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(shield_count))
	end)
end)

BOUGHT_MODULE:Setup( function()
	BOUGHT_MODULE:Hook( "Bubble_Bought_Shield", "shield_bought_hook", function( ply, count, shield_count )
		BOUGHT_MODULE:Log( "{1} has bought " .. (count > 1 and "{2} shields bringing them to {3}." or "{2} shield bringing them to {3}."), GAS.Logging:FormatPlayer(ply), GAS.Logging:Highlight(count), GAS.Logging:Highlight(shield_count))
	end)
end)

GAS.Logging:AddModule( BROKE_MODULE )
GAS.Logging:AddModule( BOUGHT_MODULE )