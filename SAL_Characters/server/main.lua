-- The main server file for the SAL character framework.

-- TODO Change user identifiers to use "char[num]:" instead of "Steam"

-- Database initialisation.
AddEventHandler('es:playerLoaded', function(source, user) 
    -- Get the player's identifier upon loading in.
    local identifiers = GetPlayerIdentifiers(source)

    local identifier
    -- Extract the steam identifier out of it. EssentialMode ensures that our character spawns in with a steam ID.
    for k, v in ipairs(identifiers) do
        if string.match(v, 'steam:') then
            identifier = v
            break
        end
    end

    print("A player is loading in with the ID: " .. identifier)

    -- Run a query to check on the license if the player has been initialised in the server.
    -- If the player is new, they won't have any valid characters.
    -- Character storage works by using a unique character ID for each identifier. Character ids work like indices i.e. character 1, character 2 etc.
    if identifier then
        -- Extract the code after the "steam:" part.
        local identifierHex = identifier:sub(7)
        local playerInformation
        MySQL.ready(function()
            MySQL.Async.fetchAll('SELECT * FROM `users` WHERE `identifier` LIKE "%' .. identifierHex .. '%"', {}, function(results)
                
                playerInformation = results
                
                local identifierPrefix
                for k, v in ipairs(playerInformation) do
                    identifierPrefix = v.identifier:sub(1, 5)
                    print("identifier prefix = " .. identifierPrefix)
                    if(identifierPrefix == "char") then
                        print("Add this to a char array to pass over to the client")
                        -- TODO finish this. 
                    end
                end 

                TriggerClientEvent('SAL_Characters:RegisterPlayer', source)
            end)
        end)
    else
        DropPlayer(source, "Invalid Identifier")
    end
end)