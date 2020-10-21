RegisterNetEvent('SAL_Characters:RegisterPlayer')
AddEventHandler('SAL_Characters:RegisterPlayer', function(identifier)
    -- Create the NUI for player registration.
    DoScreenFadeOut(1000)

    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end

    Citizen.Wait(500)

    FreezeEntityPosition(GetPlayerPed(-1), true)

    SetNuiFocus(true, true)

    DisplayHud(false)
    DisplayRadar(false)

    SendNUIMessage({
        type = 'enableui'
    })
end)

RegisterNetEvent('SAL_Characters:SelectCharacter')
AddEventHandler('SAL_Characters:SelectCharacter', function(identifier)

end)