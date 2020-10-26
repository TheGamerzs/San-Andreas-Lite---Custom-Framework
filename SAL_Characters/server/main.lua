-- The main server file for the SAL character framework.

-- Finish the character registration and add to the database. 
RegisterNetEvent('SAL_Characters:newCharacter')
AddEventHandler('SAL_Characters:newCharacter', function(data)
    local xPlayer = source

    local identifiers = GetPlayerIdentifiers(xPlayer)

    local licenseIdentifier
    local steamIdentifier
    local identifierSuffix
    -- Extract the license identifier out of it. EssentialMode ensures that our character spawns in with a steam ID.
    for k, v in ipairs(identifiers) do
        if string.match(v, 'license:') then
            licenseIdentifier = v
        end

        if string.match(v, 'steam:') then
            steamIdentifier = v
            identifierSuffix = steamIdentifier:sub(7)
        end
    end

    local charID = data.charID
    local newIdentifier = "char" .. charID .. ":" .. identifierSuffix
    -- Add to the database, ensure everything is okay then we can send to the client a message to load in.
    MySQL.ready(function()
        MySQL.Async.execute('INSERT INTO `users` (`identifier`, `license`, `money`, `bank`, `permission_level`, `group`, `first_name`, `middle_name`, `last_name`, `date_of_birth`) VALUES (@identifier, @license, @money, @bank, @permission_level, @group, @first_name, @middle_name, @last_name, @date_of_birth)', 
        {['identifier'] = newIdentifier, ['license'] = licenseIdentifier, ['money'] = 10000, ['bank'] = 0, ['permission_level'] = 0, ['group'] = "user", ['first_name'] = data.firstName, ['middle_name'] = data.middleName, ['last_name'] = data.lastName, ['date_of_birth'] = data.dateOfBirth},
        function(affectedRows)
           -- Check if database has completed the action properly, then forward the player to spawn in.
            if affectedRows ~= nil then
                TriggerClientEvent('SAL_Characters:SpawnCharacter', xPlayer)
            else
                print("Error occurred, check your database connection")
            end
        end)  
    end)
end)

-- Database initialisation.
AddEventHandler('es:playerLoaded', function(source, user) 
    -- Get the player's identifier upon loading in.
    local xPlayer = source
    local identifiers = GetPlayerIdentifiers(xPlayer)

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
                
                TriggerClientEvent('SAL_Characters:LoadCharacterMenu', xPlayer, charTable)
            end)
        end)
    else
        DropPlayer(xPlayer, "Invalid Identifier")
    end
end)