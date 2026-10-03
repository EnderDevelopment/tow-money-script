local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('towMoneyScript:checkTow', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer then
        MySQL.Async.fetchScalar('SELECT last_tow_time FROM tow_money WHERE player_id = @player_id', {
            ['@player_id'] = xPlayer.identifier
        }, function(lastTowTime)
            local currentTime = os.time()
            
            if lastTowTime == nil or currentTime - lastTowTime >= Config.CooldownTime then
                local amount = math.random(Config.MinimumAmount, Config.MaximumAmount)
                
                xPlayer.addMoney(amount)
                
                MySQL.Async.execute('INSERT INTO tow_money (player_id, last_tow_time) VALUES (@player_id, @last_tow_time) ON DUPLICATE KEY UPDATE last_tow_time = @last_tow_time', {
                    ['@player_id'] = xPlayer.identifier,
                    ['@last_tow_time'] = currentTime
                })
                
                TriggerClientEvent('esx:showNotification', source, 'You earned ~g~$' .. amount .. '~s~ for towing the vehicle.')
                
                cb(true)
            else
                TriggerClientEvent('esx:showNotification', source, 'You need to wait ~r~' .. (Config.CooldownTime - (currentTime - lastTowTime)) .. '~s~ seconds before earning money again.')
                
                cb(false)
            end
        end)
    else
        cb(false)
    end
end)