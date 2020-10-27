local displayActive = false
local isCharacterLoaded = false
local availableCharacters = {}

-- Fade the screen out if the player hasn't loaded yet. 
-- Used to create the blackout background effect.
AddEventHandler('SAL_Characters:SetupScreenRequirements', function()
    DoScreenFadeOut(1000)

    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end

    FreezeEntityPosition(GetPlayerPed(-1), true)
end)

function ToggleSound(state)
    if state then
        StartAudioScene("MP_LEADERBOARD_SCENE");
    else
        StopAudioScene("MP_LEADERBOARD_SCENE");
    end
end

-- TODO finish and optimise.
-- TODO Save chosen character information in a class. 
RegisterNetEvent('SAL_Characters:SpawnCharacter')
AddEventHandler('SAL_Characters:SpawnCharacter', function()
    isCharacterLoaded = true
    local ped = GetPlayerPed(-1)

    if(not Config.sal_spawnmenu) then
        ToggleSound(true)
        if not IsPlayerSwitchInProgress() then
            SwitchOutPlayer(PlayerPedId(), 0, 1)
        end

        DoScreenFadeIn(1000)
        Citizen.Wait(500)

        ToggleSound(false)

        Citizen.Wait(7000) -- Sets how long to wait in the "cloud" state. 

        SetEntityCoords(ped, Config.defaultSpawn.x, Config.defaultSpawn.y, Config.defaultSpawn.z) -- Player spawn location. could refactor this to a config.
        SwitchInPlayer(PlayerPedId())

        -- Wait for the player switch to be completed (state 12).
        while GetPlayerSwitchState() ~= 12 do
            Citizen.Wait(0)
        end

        DisplayHud(true)
        DisplayRadar(true)
    else
        print("initiate handler for spawn menu here") -- TODO complete.
    end
end)

RegisterNetEvent('SAL_Characters:LoadCharacterMenu')
AddEventHandler('SAL_Characters:LoadCharacterMenu', function(charTable)
    -- Create the NUI for player registration.
    if not displayActive then
        displayActive = true

        availableCharacters = charTable

        DisplayHud(false)
        DisplayRadar(false)

        Citizen.Wait(500)

        SendNUIMessage({
            type = 'enableui',
            characters = availableCharacters
        })
    end
end)

RegisterNUICallback('register', function(data, cb)
    print("User wants to register with the following info: ")
    print(json.encode(data))

    displayActive = false
    -- Send player information to the database
    TriggerServerEvent('SAL_Characters:newCharacter', data)
end)

RegisterNUICallback('play', function(data, cb)
    print("User wants to play using the following character slot: ")
    print(json.encode(data))

    displayActive = false

    -- TODO Take the information and store this as a class. We can use the ID and take it from the available characters table.
    TriggerEvent('SAL_Characters:SpawnCharacter') 
end)

-- Main Thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if NetworkIsSessionStarted() and (not isCharacterLoaded) then
            TriggerEvent('SAL_Characters:SetupScreenRequirements')
        end

        -- Disable any character and menu features whilst inside the character window. Only allowing mouse control. 
        SetNuiFocus(displayActive, displayActive)
        DisableControlAction(0, 1, displayActive) -- LookLeftRight
        DisableControlAction(0, 2, displayActive) -- LookUpDown
        DisableControlAction(0, 142, displayActive) -- MeleeAttackAlternative
        DisableControlAction(0, 18, displayActive) -- Enter
        DisableControlAction(0, 322, displayActive) -- ESC
        DisableControlAction(0, 106, displayActive) -- VehicleMouseControlOverride
        EnableControlAction(0, 1, not displayActive) -- LookLeftRight
        EnableControlAction(0, 2, not displayActive) -- LookUpDown
        EnableControlAction(0, 142, not displayActive) -- MeleeAttackAlternative
        EnableControlAction(0, 18, not displayActive) -- Enter
        EnableControlAction(0, 322, not displayActive) -- ESC
        EnableControlAction(0, 106, not displayActive) -- VehicleMouseControlOverride    
    end
end)