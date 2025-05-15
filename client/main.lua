local spawnedPeds = {}

CreateThread(function()
	while true do
		Wait(500)

        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - Config.PedCoords.xyz)

        if distance < 6.0 and not spawnedPeds[k] then
            local spawnedPed = NearPed(Config.Ped, Config.PedCoords)
            spawnedPeds[k] = { spawnedPed = spawnedPed }
        end

        if distance >= 6.0 and spawnedPeds[k] then
            for i = 255, 0, -51 do
                Wait(50)
                SetEntityAlpha(spawnedPeds[k].spawnedPed, i, false)
            end
            DeletePed(spawnedPeds[k].spawnedPed)
            spawnedPeds[k] = nil
        end
	end
end)