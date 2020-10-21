local displayActive = false
local isMenuLoaded = false

-- Fade the screen out if the player hasn't loaded yet.
AddEventHandler('SAL_Characters:SetupScreenRequirements', function()
    DoScreenFadeOut(1000)

    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end

    FreezeEntityPosition(GetPlayerPed(-1), true)
end)

RegisterNetEvent('SAL_Characters:RegisterPlayer')
AddEventHandler('SAL_Characters:RegisterPlayer', function(identifier)
    if not isMenuLoaded then
        isMenuLoaded = true
    end

    -- Create the NUI for player registration.
    if not displayActive then
        displayActive = true

        DisplayHud(false)
        DisplayRadar(false)

        Citizen.Wait(500)

        SendNUIMessage({
            type = 'enableui'
        })
    end
end)

-- Main Thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

        if NetworkIsSessionStarted() and (not isMenuLoaded) then
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
    end
end)