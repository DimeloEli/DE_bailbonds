lib.addCommand({'setbail', 'setbond'}, {
    help = 'Set a players bond',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target players id',
            optional = true,
        },
        {
            name = 'price',
            type = 'number',
            help = 'The price of the players bond',
            optional = true,
        },
    },
}, function(source, args, user)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(args.target)

    if xTarget == nil then
        TriggerClientEvent("ox_lib:notify", source, {type = "error", description = "Player not online."})
        return
    end

    if args.price == nil then
        TriggerClientEvent("ox_lib:notify", source, {type = "error", description = "Must provide a valid price."})
        return
    end

    for k, v in pairs(Config.PoliceJobs) do
        if xPlayer.job.name == v then
            MySQL.insert("INSERT INTO `user_bailbonds` (name, price, paid) VALUES (?, ?, ?)", {
                xTarget.getName(), args.price, 0
            }, function(id)
                TriggerClientEvent("ox_lib:notify", source, {type = "inform", title = "Bond", icon = "fas fa-handcuffs", description = "You have set " .. xTarget.getName() .. "'s bond to $" .. args.price})
                TriggerClientEvent("ox_lib:notify", xTarget.source, {type = "inform", title = "Bond", icon = "fas fa-handcuffs", description = "Your bond has been set to $" .. args.price})
            end)
        end
    end
end)

ESX.RegisterServerCallback("DE_bailbonds:getBonds", function(source, cb)
    local data = MySQL.query.await("SELECT * FROM `user_bailbonds`")

    cb(data)
end)

RegisterNetEvent('DE_bailbonds:payBond')
AddEventHandler('DE_bailbonds:payBond', function(name, price)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local plyMoney = xPlayer.getAccount(Config.PayAccount).money

    if plyMoney >= price then
        xPlayer.removeAccountMoney(Config.PayAccount, price)

        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(account)
            if account then
                account.addMoney(price)
            end
        end)
            
        MySQL.update.await('UPDATE `user_bailbonds` SET `paid` = ? WHERE `name` = ? AND `price` = ?', {
            1, name, price
        })
    
        TriggerClientEvent("ox_lib:notify", source, {type = "inform", title = "Bond", position = "center-right", icon = "fas fa-handcuffs", description = "You have paid " .. name .. "'s bond at $" .. price})
    else
        TriggerClientEvent("ox_lib:notify", source, {type = "error", title = "Bond", position = "center-right", icon = "fas fa-handcuffs", description = "You don't have enough to pay this bond"})
    end
end)
