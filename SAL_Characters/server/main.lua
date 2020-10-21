-- The main server file for the SAL character framework.

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
        local playerInformation
        MySQL.ready(function()
            MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @id', {['@id'] = identifier}, function(results)
                playerInformation = results

                -- TODO run a sanity check on the user's identifier before going to register menu.
                TriggerClientEvent('SAL_Characters:RegisterPlayer', source)
            end)
        end)
    else
        DropPlayer(source, "Invalid Identifier")
    end
end)