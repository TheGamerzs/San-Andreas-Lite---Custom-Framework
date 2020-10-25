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

-- TODO finish
RegisterNetEvent('SAL_Characters:SpawnCharacter')
AddEventHandler('SAL_Characters:SpawnCharacter', function()
    isCharacterLoaded = true

    ToggleSound(true)
    if not IsPlayerSwitchInProgress() then
        SwitchOutPlayer(PlayerPedId(), 0, 1)
    end

    DoScreenFadeIn(1000)
    Citizen.Wait(500)

    ToggleSound(false)

    Citizen.Wait(5000)
    SwitchInPlayer(PlayerPedId())

    -- Wait for the player switch to be completed (state 12).
    while GetPlayerSwitchState() ~= 12 do
        Citizen.Wait(0)
    end

    DisplayHud(true)
    DisplayRadar(true)
end)

RegisterNetEvent('SAL_Characters:RegisterPlayer')
AddEventHandler('SAL_Characters:RegisterPlayer', function(charTable)
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