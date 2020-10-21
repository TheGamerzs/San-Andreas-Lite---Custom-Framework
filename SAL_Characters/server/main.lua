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
    -- If the player is new, they won't have any valid characters.
    -- Character storage works by using a unique character ID for each identifier. Character ids work like indices i.e. character 1, character 2 etc.
    if identifier then
        local playerInformation
        MySQL.ready(function()
            MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @id', {['@id'] = identifier}, function(results)
                playerInformation = results

                -- Check to see how many characters have been registered with the player.
                local numberOfCharacters = #playerInformation

                if (numberOfCharacters == 1) and (playerInformation[1].char_id == nil) then
                    print("Player " .. identifier .. " has no registered characters. Player needs to be registered before playing")
                    TriggerClientEvent('SAL_Characters:RegisterPlayer', identifier)
                else
                    -- TODO redirect to the character selection screen.
                    -- Allow the player to spawn in, getting their skin ready to load in etc. If the skin is null for example, we can instead just spawn in a default ped.
                end
            end)
        end)
    else
        DropPlayer(source, "Invalid Identifier")
    end
end)