local ped = nil

CreateThread(function()
	while true do
		Wait(500)

        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - Config.PedCoords.xyz)

        if distance < 6.0 and not ped then
            local spawnedPed = NearPed(Config.Ped, Config.PedCoords)
            ped = spawnedPed
        end

        if distance >= 6.0 and ped then
            for i = 255, 0, -51 do
                Wait(50)
                SetEntityAlpha(ped, i, false)
            end
            DeletePed(ped)
            ped = nil
        end
	end
end)
