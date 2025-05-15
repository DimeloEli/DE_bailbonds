lib.registerMenu({
    id = 'bailbonds_menu',
    title = 'Bail Bonds',
    position = 'top-right',
    options = {
        {label = "Paid bonds", description = "View Paid Bonds"},
        {label = "Unpaid bonds", description = "View Unpaid Bonds"},
    },
}, function(selected, scrollIndex, args)
    if selected == 1 then
        TriggerEvent("DE_bailbonds:showBonds", true)
    elseif selected == 2 then
        TriggerEvent("DE_bailbonds:showBonds", false)
    end
end)


RegisterNetEvent("DE_bailbonds:showBonds")
AddEventHandler("DE_bailbonds:showBonds", function(paid)
    local Bonds = {}

    if paid then
        ESX.TriggerServerCallback("DE_bailbonds:getBonds", function(data)
            for k, v in pairs(data) do
                if v.paid then
                    table.insert(Bonds, {
                        label = v.name,
                        description = "Price: $" .. v.price
                    })
                end
            end

            if #Bonds > 0 then
                lib.registerMenu({
                    id = 'paid_menu',
                    title = 'Paid Bonds',
                    position = 'top-right',
                    options = Bonds,
                    onClose = function(keyPressed)
                        lib.showMenu('bailbonds_menu')
                    end,
                }, function(selected, scrollIndex, args)
                    lib.showMenu('bailbonds_menu')
                end)
                lib.showMenu('paid_menu')
            else
                lib.notify({type = "error", title = "Bond", description = "No paid bond at this time."})
            end
        end)
    else
        ESX.TriggerServerCallback("DE_bailbonds:getBonds", function(data)
            for k, v in pairs(data) do
                if not v.paid then
                    table.insert(Bonds, {
                        label = v.name,
                        description = "Price: $" .. v.price,
                        args = {
                            name = v.name,
                            price = v.price,
                        },
                    })
                end
            end

            if #Bonds > 0 then
                lib.registerMenu({
                    id = 'unpaid_menu',
                    title = 'Unpaid Bonds',
                    position = 'top-right',
                    options = Bonds,
                    onClose = function(keyPressed)
                        lib.showMenu('bailbonds_menu')
                    end,
                }, function(selected, scrollIndex, args)
                    TriggerServerEvent('DE_bailbonds:payBond', args.name, args.price)
                    lib.showMenu('bailbonds_menu')
                end)
                lib.showMenu('unpaid_menu')
            else
                lib.notify({type = "error", title = "Bond", description = "No unpaid bond at this time."})
            end
        end)
    end
end)