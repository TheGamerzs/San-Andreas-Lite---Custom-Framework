-- TODO handle when the user first loads in. The user should be redirected straight to the character creation.
RegisterServerEvent('es:playerLoaded')
AddEventHandler('es:playerLoaded', function(source, user)
    print("user has loaded in, load the main menu for the player.")
    
    TriggerClientEvent('SAL_Char_Select:SelectCharacter')
end)