timer.Simple( 0, function() ShieldSystem_SyncAll() end ) -- IGNORE 

//////////////////////////////////////////////////////////////////////////////////

// Developed by Vectivus:
// http://steamcommunity.com/profiles/76561198371018204

//////////////////////////////////////////////////////////////////////////////////

vs.shield = { // Configuration for shield system :)

    // How many shields the player(s) can hold at once
    max = 5,

    // How long each shield protects the player ( in seconds )
    delay = 1,

    // The price for each shield
    price = 150000,

    // Price of roseTint ( Only works if 'crouch' is enabled )
    roseTint = 500000,

    // How long the player has to wait before purchasing more shield(s) once ALL have been destroyed
    cooldown = 8,

    // The material the shield(s) will use
    material = "Models/effects/comball_tape",

    crouch = { // While the player crouches the bubble will appear around then until they stop crouching

        enable = true, // enables this feature

        // What material the bubble will use while the player crouches
        material = "models/props_combine/tprings_globe",

    },

}