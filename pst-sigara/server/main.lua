ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('pst-sigara:sigaraver')
AddEventHandler('pst-sigara:sigaraver', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    xPlayer.addInventoryItem('sigara', 1)
end)

RegisterServerEvent('pst-sigara:hazirsigaraver')
AddEventHandler('pst-sigara:hazirsigaraver', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.getInventoryItem('sigara').count >= 1 then
        xPlayer.removeInventoryItem('sigara', 1)
        Citizen.Wait(500)
        xPlayer.addInventoryItem('hazirsigara', 1)
    end
end)

RegisterServerEvent('pst-sigara:sigarasat')
AddEventHandler('pst-sigara:sigarasat', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local money = math.random(25, 225)
    if xPlayer.getInventoryItem('hazirsigara').count >= 1 then
        xPlayer.removeInventoryItem('hazirsigara', 1)
        Citizen.Wait(500)
        xPlayer.addMoney(money)
        dclog(xPlayer, ' 1 adet kaçak sigara sattı kazandığı miktar = ' ..money.. '$')
    end
end)

ESX.RegisterServerCallback('pst-sigara:malzemekontrol', function(source, cb, item, gereklisayi)
	local xPlayer = ESX.GetPlayerFromId(source)
	itemcount = xPlayer.getInventoryItem(item).count
	if itemcount >= gereklisayi then
		cb(true)
	else
        activity = 0
        TriggerClientEvent('esx:showNotification', source, 'Üzerinde yeterli sigara yok!')
	end
end)

function dclog(xPlayer, text)
    local playerName = Sanitize(xPlayer.getName())
  
    local discord_webhook = "WEBHOOKGIRINZ"
    if discord_webhook == '' then
      return
    end
    local headers = {
      ['Content-Type'] = 'application/json'
    }
    local data = {
      ["username"] = "Log system",
      ["avatar_url"] = "https://cdn.discordapp.com/attachments/771332991234474024/788884546745401404/a_4f2d57440789fb4ae8db16198289078e.gif",
      ["embeds"] = {{
        ["author"] = {
          ["name"] = playerName .. ' - ' .. xPlayer.identifier
        },
        ["color"] = 1942002,
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
      }}
    }
    data['embeds'][1]['description'] = text
    PerformHttpRequest(discord_webhook, function(err, text, headers) end, 'POST', json.encode(data), headers)
end

function Sanitize(str)
    local replacements = {
        ['&' ] = '&amp;',
        ['<' ] = '&lt;',
        ['>' ] = '&gt;',
        ['\n'] = '<br/>'
    }

    return str
        :gsub('[&<>\n]', replacements)
        :gsub(' +', function(s)
            return ' '..('&nbsp;'):rep(#s-1)
        end)
end