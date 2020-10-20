-- The main server file for the SAL character framework.

-- Database initialisation.
-- TODO prevent the function being called twice if possible.
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
    -- If the player is new, they won't have a valid first/last name.
    -- TODO Create SQL file with new information imported.
    if identifier then
        local playerInformation
        MySQL.ready(function()
            MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @id', {['@id'] = identifier}, function(results)
                -- TODO Further checks on player DB status.
                playerInformation = results[1]

                local firstName = playerInformation.first_name
                local lastName = playerInformation.last_name

                if firstName == nil and lastName == nil then
                    print("Player " .. identifier .. " has an invalid name. Player needs to be registered")
                    TriggerClientEvent('SAL_Characters:RegisterPlayer', source, identifier)
                else
                    print("Player with name " .. firstName .. " " .. lastName .. " is connecting")
                    -- TODO continue to run through connection process with player.
                    -- Allow the player to spawn in, getting their skin ready to load in etc. If the skin is null for example, we can instead just spawn in a default ped.
                end
            end)
        end)
    else
        DropPlayer(source, "Invalid Identifier")
    end
end)