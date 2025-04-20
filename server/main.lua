VORPCore = exports.vorp_core:GetCore()

local function IsAllowedToManageCode(source)
    if IsPlayerAceAllowed(source, Config.manageAce) then return true end

    return false
end

local function DebugPrint(msg)
    if SharedConfig.debug then
        print('[COUPON CREATOR] ',msg)
    end
end

RegisterCommand("couponManage", function(source, args)
    -- Permission Check
    local source = source

    if not IsAllowedToManageCode(source) then return end

    TriggerClientEvent("rs-creatorcoupon:client:openCouponManageMenu", source)
end, false)

RegisterCommand("redeem", function(source, args)
    -- Permission Check
    local source = source

    local user = VORPCore.getUser(source)

    if not user then return end

    local character = user.getUsedCharacter

    if not character then return end

    local identifier = user.getIdentifier()

    local id =  MySQL.scalar.await('SELECT `identifier` FROM `coupons_users` WHERE `identifier` = ? LIMIT 1', {
        identifier
    })

    if id then 
        DebugPrint("Already Redeemed Code")
        VORPCore.NotifyObjective(source, "You have already redeemed a coupon code in past.", 4000)
        return 
    end

    local code = args[1]

    if not code then 
        DebugPrint("Please Provide A Code To Redeem")
        VORPCore.NotifyObjective(source, "Please Provide A Code To Redeem.", 4000)
        return 
    end

    -- Validate Code

    local response =  MySQL.single.await('SELECT `code`, `maxUse`, `currentUse`, `active` FROM `coupons` WHERE `code` = ? LIMIT 1', {
        code
    })

    if not response.code then 
        DebugPrint("Invalid Code") 
        VORPCore.NotifyObjective(source, "Please Provide A Valid Code To Redeem.", 4000)
        return 
    end

    if response.active == 0 then 
        VORPCore.NotifyObjective(source, "Code is no longer Active for use.", 4000)
        return 
    end

    if response.maxUse == -1 then goto SKIPUSECHECK1 end

    if response.currentUse >= response.maxUse then 
        DebugPrint("Code Max Usage Reached") 
        VORPCore.NotifyObjective(source, "Max Usage for this code has been reached.", 4000)
        return     
    end

    ::SKIPUSECHECK1::

    local items = MySQL.query.await('SELECT r.item, i.label as label, r.quantity FROM coupons_items r JOIN items i ON r.item = i.item WHERE `code` = ?', {
        code
    })

    local weapons = MySQL.query.await('SELECT `weapon`, `quantity` FROM `coupons_weapons` WHERE `code` = ?', {
        code
    })

    local money = MySQL.single.await('SELECT `money`, `gold`, `rol` FROM `coupons_money` WHERE `code` = ? LIMIT 1', {
        code
    })

    local passingData = {
        code = code,
        items = items or {},
        weapons = weapons or {},
        money = money or {}
    }

    TriggerClientEvent("rs-creatorcoupon:client:redeemCoupon", source, passingData)
end, false)

RegisterNetEvent("rs-creatorcoupon:server:redeemCoupon", function(code)
    local source = source

    local user = VORPCore.getUser(source)

    if not user then return end

    local character = user.getUsedCharacter

    if not character then return end

    local identifier = user.getIdentifier()

    local id =  MySQL.scalar.await('SELECT `identifier` FROM `coupons_users` WHERE `identifier` = ? LIMIT 1', {
        identifier
    })

    if id then 
        DebugPrint("Already Redeemed Code")
        VORPCore.NotifyObjective(source, "You have already redeemed a coupon code in past.", 4000)
        return 
    end

    if not code then 
        DebugPrint("Please Provide A Code To Redeem")
        VORPCore.NotifyObjective(source, "Please Provide A Code To Redeem.", 4000)
        return 
    end

    -- Validate Code

    local response =  MySQL.single.await('SELECT `code`, `maxUse`, `currentUse`, `active` FROM `coupons` WHERE `code` = ? LIMIT 1', {
        code
    })

    if not response.code then 
        DebugPrint("Invalid Code") 
        VORPCore.NotifyObjective(source, "Please Provide A Valid Code To Redeem.", 4000)
        return      
    end

    if response.active == 0 then 
        DebugPrint("Invactive Code") 
        VORPCore.NotifyObjective(source, "Code is no longer Active for use.", 4000)
        return            
    end

    if response.maxUse == -1 then goto SKIPUSECHECK end

    if response.currentUse >= response.maxUse then 
        DebugPrint("Code Max Usage Reached") 
        VORPCore.NotifyObjective(source, "Max Usage for this code has been reached.", 4000)
        return      
    end

    ::SKIPUSECHECK::

    local items = MySQL.query.await('SELECT `item`, `quantity` FROM `coupons_items` WHERE `code` = ?', {
        code
    })

    local weapons = MySQL.query.await('SELECT `weapon`, `quantity` FROM `coupons_weapons` WHERE `code` = ?', {
        code
    })

    local money = MySQL.single.await('SELECT `money`, `gold`, `rol` FROM `coupons_money` WHERE `code` = ? LIMIT 1', {
        code
    })

    if items then
        for i=1, #items do
            local item = items[i]
            exports.vorp_inventory:addItem(source, item.item, item.quantity)
        end
    end

    if weapons then
        for i=1, #weapons do
            local weapon = weapons[i]
            exports.vorp_inventory:createWeapon(source, weapon.weapon, 0)
        end
    end

    if money then
        if money.money > 0 then character.addCurrency(0, money.money) end
        if money.gold > 0 then character.addCurrency(1, money.gold) end
        if money.rol > 0 then character.addCurrency(2, money.rol) end
    end

    MySQL.insert.await('INSERT INTO `coupons_users` (identifier) VALUES (?)', {
        identifier
    })

    MySQL.update.await('UPDATE coupons SET currentUse = currentUse + 1 WHERE code = ?', {
        code
    })
end)


VORPCore.Callback.Register("rs-creatorcoupon:server:validateMenuOpenPermission", function(source, cb)
    if IsAllowedToManageCode(source) then 
        return cb(true) 
    end

    DebugPrint("Missing Permissions : rs-creatorcoupon:server:validateMenuOpenPermission")
    cb(false)
end)

VORPCore.Callback.Register("rs-creatorcoupon:server:fetchItemData", function(source, cb, id) 
    
    if not IsAllowedToManageCode(source) then 
        DebugPrint("Missing Permissions : rs-creatorcoupon:server:fetchItemData")
        return cb({}) 
    end

    local response = MySQL.single.await('SELECT `id`, `item`, `quantity` FROM `coupons_items` WHERE `id` = ? LIMIT 1', {
        id
    })

    if not response then 
        DebugPrint("No Item Data in SQL : rs-creatorcoupon:server:fetchItemData")
        return cb({}) 
    end

    DebugPrint("Item Data : "..json.encode(response))

    local returnData = {}

    returnData = {
        id = response.id,
        item = response.item,
        quantity = response.quantity
    }

    cb(returnData)
end)

VORPCore.Callback.Register("rs-creatorcoupon:server:fetchWeaponData", function(source, cb, id) 

    if not IsAllowedToManageCode(source) then return cb({}) end

    local response = MySQL.single.await('SELECT `id`, `weapon`, `quantity` FROM `coupons_weapons` WHERE `id` = ? LIMIT 1', {
        id
    })

    if not response then return cb({}) end

    local returnData = {}

    returnData = {
        id = response.id,
        item = response.weapon,
        quantity = response.quantity
    }

    cb(returnData)
end)

VORPCore.Callback.Register("rs-creatorcoupon:server:fetchCouponItemsData", function(source, cb, code) 
    if not IsAllowedToManageCode(source) then return cb({}) end

    local response = MySQL.query.await('SELECT `id`, `item` FROM `coupons_items` WHERE `code` = ?', {
        code
    })

    if not response then return cb({}) end

    cb(response)
end)

VORPCore.Callback.Register("rs-creatorcoupon:server:fetchCouponWeaponsData", function(source, cb, code) 
    if not IsAllowedToManageCode(source) then return cb({}) end

    local response = MySQL.query.await('SELECT `id`, `weapon` FROM `coupons_weapons` WHERE `code` = ?', {
        code
    })

    if not response then return cb({}) end

    cb(response)
end)

VORPCore.Callback.Register("rs-creatorcoupon:server:fetchCouponMoneyData", function(source, cb, code) 
    if not IsAllowedToManageCode(source) then return cb({}) end

    local row = MySQL.single.await('SELECT `money`, `gold`, `rol` FROM `coupons_money` WHERE `code` = ? LIMIT 1', {
        code
    })

    if not row then return cb({}) end

    cb(row)
end)

VORPCore.Callback.Register("rs-creatorcoupon:server:fetchCouponData", function(source, cb, code) 
    if not IsAllowedToManageCode(source) then return cb(nil) end

    local row = MySQL.single.await('SELECT `code`, `currentUse`, `maxUse`, `active` FROM `coupons` WHERE `code` = ? LIMIT 1', {
        code
    })

    if not row then return cb(nil) end

    cb(row)
end)

VORPCore.Callback.Register("rs-creatorcoupon:server:fetchAllCoupons", function(source, cb)
    if not IsAllowedToManageCode(source) then 
        DebugPrint("Missing Permissions : rs-creatorcoupon:server:fetchAllCoupons")
        return cb({}) 
    end

    local response = MySQL.query.await('SELECT `code` FROM `coupons`')

    if not response then 
        print("No Coupons : rs-creatorcoupon:server:fetchAllCoupons")
        return cb({}) 
    end

    cb(response)
end)

--------------------------------------------------

RegisterNetEvent("rs-creatorcoupon:server:createNewCoupon", function(data)
    local source = source

    if not data.code or not data.maxUsage then return end -- Validate data type for code and maxUsage

    -- Check Permissions

    if not IsAllowedToManageCode(source) then return end

    -- Insert SQl Query Here

    local queries = {
        { query = 'INSERT INTO `coupons` (code, maxUse) VALUES (?, ?)', values = { data.code, data.maxUsage or -1 }},
        { query = 'INSERT INTO `coupons_money` (code, money, gold, rol) VALUES (?, ?, ?, ?)', values = { data.code, 0, 0, 0 }},
    }

    local success = MySQL.transaction.await(queries)

    if success then 
        -- Notify About Successfl create of coupon
        VORPCore.NotifyObjective(source, "Created New Coupon : "..data.code, 4000)
    else
        -- Notiy Error
        VORPCore.NotifyObjective(source, "Failed to create code.", 4000)
    end
end)

RegisterNetEvent("rs-creatorCoupon:server:updateCouponItem", function(id, quantity)
    local source = source

    if not id or quantity then return end

    if not IsAllowedToManageCode(source) then return end

    local affectedRows = MySQL.update.await('UPDATE coupons_items SET quantity = ? WHERE id = ?', {
        quantity, id
    })

    if affectedRows > 0 then
        -- Notify Success Update
        VORPCore.NotifyObjective(source, "Updated Item quantity.", 4000)
    else
        -- Notify Error 
        VORPCore.NotifyObjective(source, "Failed to Update Item quantity.", 4000)
    end
end)

RegisterNetEvent("rs-creatorCoupon:server:deleteCouponItem", function(id)
    local source = source

    if not id then return end

    if not IsAllowedToManageCode(source) then return end

    local affectedRows = MySQL.update.await('DELETE FROM coupons_items WHERE id = ?', {
        id
    })

    if affectedRows > 0 then
        -- Notify Success Update
        VORPCore.NotifyObjective(source, "Deleted Reward Item.", 4000)
    else
        -- Notify Error 
        VORPCore.NotifyObjective(source, "Failed to Delete Reward Item.", 4000)
    end
end)


RegisterNetEvent("rs-creatorCoupon:server:updateCouponWeapon", function(id, quantity)
    local source = source

    if not id or quantity then return end

    if not IsAllowedToManageCode(source) then return end

    local affectedRows = MySQL.update.await('UPDATE coupons_weapons SET quantity = ? WHERE id = ?', {
        quantity, id
    })

    if affectedRows > 0 then
        -- Notify Success Update
        VORPCore.NotifyObjective(source, "Updated Reward Weapon.", 4000)
    else
        -- Notify Error 
        VORPCore.NotifyObjective(source, "Failed to Update Reward Weapon.", 4000)
    end
end)

RegisterNetEvent("rs-creatorCoupon:server:deleteCouponWeapon", function(id)
    local source = source

    if not id then return end

    if not IsAllowedToManageCode(source) then return end

    local affectedRows = MySQL.update.await('DELETE FROM coupons_weapons WHERE id = ?', {
        id
    })

    if affectedRows > 0 then
        -- Notify Success Update
        VORPCore.NotifyObjective(source, "Deleted Reward Weapon.", 4000)
    else
        -- Notify Error 
        VORPCore.NotifyObjective(source, "Failed to Delete Reward Weapon.", 4000)
    end
end)

RegisterNetEvent("rs-creatorCoupon:server:updateCouponMoneyData", function(code, money, gold, rol)
    local source = source

    if not code or not money or not gold or not rol then return end

    if not IsAllowedToManageCode(source) then return end

    local affectedRows = MySQL.update.await('UPDATE coupons_money SET `money` = ?, `gold` = ?, `rol` = ? WHERE `code` = ?' , {
        money or 0, gold or 0, rol or 0, code
    })
    
    if affectedRows > 0 then
        -- Notify Success Update
        VORPCore.NotifyObjective(source, "Updated Reward Money.", 4000)
    else
        -- Notify Error 
        VORPCore.NotifyObjective(source, "Failed to update Reward Weapon.", 4000)
    end
end)

RegisterNetEvent("rs-creatorCoupon:server:updateCouponData", function(data)
    local source = source

    if not data.code or not data.maxUse or not data.active then return end

    if not IsAllowedToManageCode(source) then return end

    local affectedRows = MySQL.update.await('UPDATE coupons SET `maxUse` = ?, `active` = ? WHERE code = ?', {
        data.maxUse, data.active, data.code
    })

    if affectedRows > 0 then
        -- Notify Success Update
        VORPCore.NotifyObjective(source, "Updated Coupon.", 4000)
    else
        -- Notify Error 
        VORPCore.NotifyObjective(source, "Failed to update coupon.", 4000)
    end
end)

RegisterNetEvent("rs-creatorCoupon:server:addItemToCoupon", function(code, item, quantity)
    local source = source

    if not item or not quantity or quantity < 1 or not code then return end

    if not IsAllowedToManageCode(source) then return end

    local id = MySQL.insert.await('INSERT INTO `coupons_items` (code, item, quantity) VALUES (?, ?, ?)', {
        code, item, quantity
    })

    if id then
        -- Notify Success Update
        VORPCore.NotifyObjective(source, "Added reward item "..item.."to code : "..code, 4000)
    else
        -- Notify Error 
        VORPCore.NotifyObjective(source, "Failed to add reward item", 4000)
    end
end)

RegisterNetEvent("rs-creatorCoupon:server:addWeaponToCoupon", function(code, weapon, quantity)
    local source = source

    if not weapon or not quantity or quantity < 1 or not code then return end

    if not IsAllowedToManageCode(source) then return end

    local id = MySQL.insert.await('INSERT INTO `coupons_weapons` (code, weapon, quantity) VALUES (?, ?, ?)', {
        code, weapon, quantity
    })

    if id then
        -- Notify Success Update
        VORPCore.NotifyObjective(source, "Added reward weapon "..weapon.."to code : "..code, 4000)
    else
        -- Notify Error 
        VORPCore.NotifyObjective(source, "Failed to add reward weapon", 4000)
    end
end)

