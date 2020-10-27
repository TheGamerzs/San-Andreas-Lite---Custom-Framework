-- The main server file for the SAL character framework.

-- Finish the character registration and add to the database. 
RegisterNetEvent('SAL_Characters:newCharacter')
AddEventHandler('SAL_Characters:newCharacter', function(data)
    local player = source
    local xPlayer
    local steamIdentifier
    local licenseIdentifier
    local identifierHex

    TriggerEvent('es:getPlayerFromId', player, function(user)
        xPlayer = user
        steamIdentifier = xPlayer.getIdentifier()
        licenseIdentifier = xPlayer.getLicense()
        identifierHex = steamIdentifier:sub(7)
    end)

    local charID = data.charID
    local newIdentifier = "char" .. charID .. ":" .. identifierHex
    -- Add to the database, ensure everything is okay then we can send to the client a message to load in.
    MySQL.ready(function()
        TriggerEvent('es_db:createUser', newIdentifier, licenseIdentifier, Config.startingMoney, 0, function()
            TriggerEvent('es_db:updateUser', newIdentifier, {first_name = data.firstName, middle_name = data.middleName, last_name = data.lastName, date_of_birth = data.dateOfBirth}, function(result)
                if result then
                    TriggerClientEvent('SAL_Characters:SpawnCharacter', player)
                else
                    DropPlayer(player, "Error occurred, check your database connection")
                end
            end)
        end)
    end)
end)

-- Database initialisation.
AddEventHandler('es:playerLoaded', function(source, user) 
    -- The user here acts as the user object created in EssentialMode. Needs to be passed down.
    local xPlayer = user
    local identifier = xPlayer.getIdentifier()

    print("A player is loading in with the ID: " .. identifier)

    -- Run a query to check on the license if the player has been initialised in the server.
    -- If the player is new, they won't have any valid characters.
    -- Character storage works by using a unique character ID for each identifier. Character ids work like indices i.e. character 1, character 2 etc.
    if identifier then
        -- Extract the code after the "steam:" part.
        local identifierHex = identifier:sub(7)
        local playerInformation
        MySQL.ready(function()
            TriggerEvent('es_db:retrieveUserByHex', identifierHex, function(results)
                if(results) then
                    playerInformation = results
                    -- Grabs all characters the player owns. Active characters have an identifier prefix of "charn" where n is a number.
                    -- The number can range from 1 to 4 depending on the character slot they chose in the selection window.
                    local identifierPrefix
                    local charTable = {}
                    for k, v in ipairs(playerInformation) do
                        identifierPrefix = v.identifier:sub(1, 5)
                        if(identifierPrefix:sub(1, 4) == "char") then
                            table.insert(charTable, v) -- Add character to a table to pass over to the player.
                        end
                    end 
                    TriggerClientEvent('SAL_Characters:LoadCharacterMenu', source, charTable)
                else
                    DropPlayer(source, "There was a database error. Please try again.")
                end
            end)
        end)
    else
        DropPlayer(source, "Invalid Identifier")
    end
end)