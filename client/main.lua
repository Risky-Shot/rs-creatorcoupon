VORPCore = exports.vorp_core:GetCore()
FeatherMenu =  exports['feather-menu'].initiate()

CouponManageMenu = FeatherMenu:RegisterMenu("rs-creatorCoupon:menu:manageMenu",{
    top = '3%',
    left = '3%',
    ['720width'] = '400px',
    ['1080width'] = '700px',
    ['2kwidth'] = '600px',
    ['4kwidth'] = '800px',
    style = {},
    contentslot = {
        style = {
            ['height'] = '500px',
            ['min-height'] = '450px'
        }
    },
    draggable = true,
    canclose = true
})

function ManageItem(id)
    local itemData = VORPCore.Callback.TriggerAwait("rs-creatorcoupon:server:fetchItemData", id)

    if not itemData then return end

    local couponItemPage = CouponManageMenu:RegisterPage("rs-creatorCoupon:couponItemPage")

    couponItemPage:RegisterElement('header', {
        value = 'Manage Item',
        slot = "header",
        style = {}
    })

    couponItemPage:RegisterElement('subheader', {
        value = itemData.item,
        slot = 'header'
    })

    couponItemPage:RegisterElement('line', {
        slot = "header",
        style = {}
    })

    couponItemPage:RegisterElement('slider', {
        label = "Quantity",
        start = itemData.quantity or 1,
        slot = "content",
        min = 1,
        max = 100,
        steps = 1,
    }, function(data)
        itemData.quantity = data.value
    end)

    couponItemPage:RegisterElement('line', {
        slot = "footer",
        style = {}
    })

    couponItemPage:RegisterElement('button', {
        label = "Update Item",
        slot = 'footer'
    }, function()
        TriggerServerEvent("rs-creatorCoupon:server:updateCouponItem", id, itemData.quantity)
        CouponManageMenu:Close({})
    end)

    couponItemPage:RegisterElement('button', {
        label = "Delete Item",
        slot = 'footer'
    }, function()
        TriggerServerEvent("rs-creatorCoupon:server:deleteCouponItem", id)
        CouponManageMenu:Close({})
    end)

    couponItemPage:RegisterElement('bottomline', { slot = "footer"})

    CouponManageMenu:Open({ startupPage = couponItemPage })
end

function ManageWeapon(id)
    local weaponData = VORPCore.Callback.TriggerAwait("rs-creatorcoupon:server:fetchWeaponData", id)

    if not weaponData then return end

    local couponWeaponPage = CouponManageMenu:RegisterPage("rs-creatorCoupon:couponWeaponPage")

    couponWeaponPage:RegisterElement('header', {
        value = 'Manage Weapon',
        slot = "header",
        style = {}
    })

    couponWeaponPage:RegisterElement('subheader', {
        value = weaponData.weapon,
        slot = 'header'
    })

    couponWeaponPage:RegisterElement('line', {
        slot = "header",
        style = {}
    })

    couponWeaponPage:RegisterElement('slider', {
        label = "Quantity",
        start = weaponData.quantity or 1,
        slot = "content",
        min = 1,
        max = 100,
        steps = 1,
    }, function(data)
        -- This gets triggered whenever the sliders selected value changes
        weaponData.quantity = data.value
    end)

    couponWeaponPage:RegisterElement('line', {
        slot = "footer",
        style = {}
    })

    couponWeaponPage:RegisterElement('button', {
        label = "Update Weapon",
        slot = 'footer'
    }, function()
        TriggerServerEvent("rs-creatorCoupon:server:updateCouponWeapon", id, weaponData.quantity)
        CouponManageMenu:Close({})
    end)

    couponWeaponPage:RegisterElement('button', {
        label = "Delete Weapon",
        slot = 'footer'
    }, function()
        TriggerServerEvent("rs-creatorCoupon:server:deleteCouponWeapon", id)
        CouponManageMenu:Close({})
    end)

    couponWeaponPage:RegisterElement('bottomline', { slot = "footer"})

    CouponManageMenu:Open({ startupPage = couponWeaponPage })
end

function AddItem(code)
    local couponsItemAddPage = CouponManageMenu:RegisterPage("rs-creatorCoupon:couponsItemAddPage")

    local item, quantity = nil, 0

    couponsItemAddPage:RegisterElement('header', {
        value = 'Add Reward Item',
        slot = "header",
        style = {}
    })

    couponsItemAddPage:RegisterElement('line', {
        slot = "header",
        style = {}
    })

    couponsItemAddPage:RegisterElement('input', {
        label = "Item Name",
        placeholder = "Valid Item Name...",
    }, function(data)
        item = data.value
    end)

    couponsItemAddPage:RegisterElement('slider', {
        label = "Quantity",
        start = 1,
        min = 1,
        max = 100,
        steps = 1,
    }, function(data)
        quantity = data.value
    end)

    couponsItemAddPage:RegisterElement('line', {
        slot = "footer",
        style = {}
    })

    couponsItemAddPage:RegisterElement('button', {
        label = "Insert & Save",
        slot = 'footer'
    }, function()
        if not item or quantity < 1 then return end

        TriggerServerEvent("rs-creatorCoupon:server:addItemToCoupon", code, item, quantity)
        CouponManageMenu:Close({})
    end)

    couponsItemAddPage:RegisterElement('bottomline', { slot = "footer"})

    CouponManageMenu:Open({ startupPage = couponsItemAddPage })
end

function AddWeapon(code)
    local couponsWeaponAddPage = CouponManageMenu:RegisterPage("rs-creatorCoupon:couponsWeaponAddPage")

    local weapon, quantity = nil, 0

    couponsWeaponAddPage:RegisterElement('header', {
        value = 'Add Reward Weapon',
        slot = "header",
        style = {}
    })

    couponsWeaponAddPage:RegisterElement('line', {
        slot = "header",
        style = {}
    })

    couponsWeaponAddPage:RegisterElement('input', {
        label = "Item Hash String",
        placeholder = "Valid Weapon Hash String...",
    }, function(data)
        weapon = data.value
    end)

    couponsWeaponAddPage:RegisterElement('slider', {
        label = "Quantity",
        start = 1,
        min = 1,
        max = 100,
        steps = 1,
    }, function(data)
        quantity = data.value
    end)

    couponsWeaponAddPage:RegisterElement('line', {
        slot = "footer",
        style = {}
    })

    couponsWeaponAddPage:RegisterElement('button', {
        label = "Insert & Save",
        slot = 'footer'
    }, function()
        if not weapon or quantity < 1 then return end

        TriggerServerEvent("rs-creatorCoupon:server:addWeaponToCoupon", code, weapon, quantity)
        CouponManageMenu:Close({})
    end)

    couponsWeaponAddPage:RegisterElement('bottomline', { slot = "footer"})

    CouponManageMenu:Open({ startupPage = couponsWeaponAddPage })
end

function OpenManageItems(code)
    local itemsData = VORPCore.Callback.TriggerAwait("rs-creatorcoupon:server:fetchCouponItemsData", code)

    local couponsItemListPage = CouponManageMenu:RegisterPage("rs-creatorCoupon:couponsItemListPage")

    couponsItemListPage:RegisterElement('header', {
        value = 'Reward Items',
        slot = "header",
        style = {}
    })

    couponsItemListPage:RegisterElement('button', {
        label = "Add Reward Item",
        slot = 'header'
    }, function()
        AddItem(code)
    end)

    couponsItemListPage:RegisterElement('line', {
        slot = "header",
        style = {}
    })
    ---------------------
    
    for _, itemData in pairs(itemsData) do
        couponsItemListPage:RegisterElement('button', {
            label = itemData.item,
            slot = 'content'
        }, function()
            ManageItem(itemData.id)
        end)
    end
    
    couponsItemListPage:RegisterElement('bottomline', { slot = "footer"})

    CouponManageMenu:Open({ startupPage = couponsItemListPage })
end

function OpenManageWeapons(code)
    local weaponsData = VORPCore.Callback.TriggerAwait("rs-creatorcoupon:server:fetchCouponWeaponsData", code)

    local couponsWeaponListPage = CouponManageMenu:RegisterPage("rs-creatorCoupon:couponsWeaponListPage")

    couponsWeaponListPage:RegisterElement('header', {
        value = 'Reward Weapons',
        slot = "header",
        style = {}
    })

    couponsWeaponListPage:RegisterElement('button', {
        label = "Add Reward Weapon",
        slot = 'header'
    }, function()
        AddWeapon(code)
    end)

    couponsWeaponListPage:RegisterElement('line', {
        slot = "header",
        style = {}
    })
    ---------------------
    
    for _, weaponData in pairs(weaponsData) do
        couponsWeaponListPage:RegisterElement('button', {
            label = weaponData.weapon,
            slot = 'content'
        }, function()
            ManageWeapon(weaponData.id)
        end)
    end
    
    couponsWeaponListPage:RegisterElement('bottomline', { slot = "footer"})

    CouponManageMenu:Open({ startupPage = couponsWeaponListPage })
end

function OpenManageMoney(code)
    local moneyData = VORPCore.Callback.TriggerAwait("rs-creatorcoupon:server:fetchCouponMoneyData", code)

    local money, gold, rol = moneyData.money or 0, moneyData.gold or 0, moneyData.rol or 0

    local couponsMoneyListPage = CouponManageMenu:RegisterPage("rs-creatorCoupon:couponsMoneyListPage")

    couponsMoneyListPage:RegisterElement('header', {
        value = 'Reward Money',
        slot = "header",
        style = {}
    })

    couponsMoneyListPage:RegisterElement('line', {
        slot = "header",
        style = {}
    })

    couponsMoneyListPage:RegisterElement('input', {
        label = "Money",
        placeholder = "Current Money : "..(money),
        slot = "content",
    }, function(data)
        -- This gets triggered whenever the input value changes
        money = data.value
    end)

    couponsMoneyListPage:RegisterElement('input', {
        label = "Gold",
        placeholder = "Current Gold : "..(gold),
        slot = "content",
    }, function(data)
        -- This gets triggered whenever the input value changes
        gold = data.value
    end)

    couponsMoneyListPage:RegisterElement('input', {
        label = "Rol",
        placeholder = "Current Rol : "..(rol),
        slot = "content",
    }, function(data)
        -- This gets triggered whenever the input value changes
        rol = data.value
    end)

    couponsMoneyListPage:RegisterElement('button', {
        label = "Update",
        slot = "footer",
    }, function()
        -- This gets triggered whenever the button is clicked
        TriggerServerEvent("rs-creatorCoupon:server:updateCouponMoneyData", code, money, gold, rol)
        CouponManageMenu:Close({})
    end)

    couponsMoneyListPage:RegisterElement('bottomline', { slot = "footer"})

    CouponManageMenu:Open({ startupPage = couponsMoneyListPage })
end

function OpenCouponMenu(code)
    local couponData = VORPCore.Callback.TriggerAwait("rs-creatorcoupon:server:fetchCouponData", code)

    if not couponData then return end

    local couponsManagePage = CouponManageMenu:RegisterPage("rs-creatorCoupon:couponsManagePage")

    couponsManagePage:RegisterElement('header', {
        value = 'Manage Coupon',
        slot = "header",
        style = {}
    })

    couponsManagePage:RegisterElement('subheader', {
        value = couponData.code,
        slot = "header",
        style = {}
    })

    couponsManagePage:RegisterElement('line', {
        slot = "header",
        style = {}
    })

    couponsManagePage:RegisterElement("textdisplay", {
        value = "Total Uses : "..(couponData.currentUse or 0),
        slot = "header",
    })

    couponsManagePage:RegisterElement('slider', {
        label = "Max Usage",
        start = couponData.maxUse or -1,
        slot = "content",
        min = -1,
        max = 1000,
        steps = 1,
    }, function(data)
        -- This gets triggered whenever the sliders selected value changes
        couponData.maxUse = data.value
    end)

    couponsManagePage:RegisterElement("checkbox", {
        label = "Active Status",
        slot = "content",
        start = couponData.active == 1 and true or false
    }, function(data)
        couponData.active = data.value == true and 1 or 0
    end)

    couponsManagePage:RegisterElement('button', {
        label = "Manage Items",
        slot = 'content'
    }, function()
        OpenManageItems(code)
    end)

    couponsManagePage:RegisterElement('button', {
        label = "Manage Weapons",
        slot = 'content'
    }, function()
        OpenManageWeapons(code)
    end)

    couponsManagePage:RegisterElement('button', {
        label = "Manage Money",
        slot = 'content'
    }, function()
        OpenManageMoney(code)
    end)

    couponsManagePage:RegisterElement('line', {
        slot = "footer",
        style = {}
    })

    couponsManagePage:RegisterElement('button', {
        label = "Update Code",
        slot = 'footer'
    }, function()
        TriggerServerEvent("rs-creatorCoupon:server:updateCouponData", couponData)
        CouponManageMenu:Close({})
    end)

    couponsManagePage:RegisterElement('button', {
        label = "Back",
        slot = 'footer',
    }, function()
        OpenAllCouponsPage()
    end)

    couponsManagePage:RegisterElement('bottomline', { slot = "footer"})

    CouponManageMenu:Open({ startupPage = couponsManagePage })
end

function OpenAllCouponsPage()
    local availableCoupons = VORPCore.Callback.TriggerAwait("rs-creatorcoupon:server:fetchAllCoupons")

    if #availableCoupons < 1 then return end

    local couponsListPage = CouponManageMenu:RegisterPage("rs-creatorCoupon:couponsListPage")

    couponsListPage:RegisterElement('header', {
        value = 'Available Coupons',
        slot = "header",
        style = {}
    })

    couponsListPage:RegisterElement('subheader', {
        value = "Select To Manage Coupon",
        slot = "header",
        style = {}
    })

    couponsListPage:RegisterElement('line', {
        slot = "header",
        style = {}
    })

    for _, code in pairs(availableCoupons) do
        couponsListPage:RegisterElement('button', {
            label = code.code,
            slot = 'content'
        }, function()
            OpenCouponMenu(code.code)
        end)
    end

    couponsListPage:RegisterElement('button', {
        label = "Back",
        slot = 'footer'
    }, function()
        OpenCouponAdminMenu()
    end)

    couponsListPage:RegisterElement('bottomline', { slot = "footer"})

    CouponManageMenu:Open({ startupPage = couponsListPage })
end

function OpenCreateCouponMenu()
    local newCouponPage = CouponManageMenu:RegisterPage("rs-creatorCoupon:newCouponPage")

    local couponCode, maxUsage = nil, -1

    newCouponPage:RegisterElement('header', {
        value = 'Create New Coupon',
        slot = "header",
        style = {}
    })

    newCouponPage:RegisterElement('line', {
        slot = "header",
        style = {}
    })

    newCouponPage:RegisterElement('input', {
        label = "Coupon Code",
        placeholder = "Unique Code For Creator",
        style = {}
    }, function(data)
        -- This gets triggered whenever the input value changes
        print("Input Triggered: ", data.value)
        couponCode = data.value
    end)
    
    newCouponPage:RegisterElement('slider', {
        label = "Max Usage",
        start = -1,
        min = -1,
        max = 1000,
        steps = 1,
    }, function(data)
        -- This gets triggered whenever the sliders selected value changes
        print(json.encode(data.value))
        maxUsage = data.value
    end)

    newCouponPage:RegisterElement('line', {
        slot = "footer",
        style = {}
    })

    newCouponPage:RegisterElement('button', {
        label = "Generate Coupon",
        slot = 'footer'
    }, function()
        TriggerServerEvent("rs-creatorcoupon:server:createNewCoupon", {code = couponCode, maxUsage = maxUsage })
        CouponManageMenu:Close({})
    end)

    newCouponPage:RegisterElement('button', {
        label = "Back",
        slot = 'footer'
    }, function()
        OpenCouponAdminMenu()
    end)

    newCouponPage:RegisterElement('bottomline', { slot = "footer"})

    CouponManageMenu:Open({ startupPage = newCouponPage })
end

function OpenCouponAdminMenu()
    local homePage = CouponManageMenu:RegisterPage("rs-creatorCoupon:mainPage")

    homePage:RegisterElement('header', {
        value = 'Creator Coupon',
        slot = "header",
        style = {}
    })

    homePage:RegisterElement('line', {
        slot = "header",
        style = {}
    })

    homePage:RegisterElement('button', {
        label = "Create New Coupon",
    }, function()
        OpenCreateCouponMenu()
    end)

    homePage:RegisterElement('button', {
        label = "Manage Coupons",
    }, function()
        OpenAllCouponsPage()
    end)

    homePage:RegisterElement('bottomline', { slot = "footer"})

    CouponManageMenu:Open({ startupPage = homePage })
end

RegisterNetEvent("rs-creatorcoupon:client:openCouponManageMenu", function()
    local allowed = VORPCore.Callback.TriggerAwait("rs-creatorcoupon:server:validateMenuOpenPermission")

    if not allowed then return end

    OpenCouponAdminMenu()
end)

CouponRedeemMenu = FeatherMenu:RegisterMenu("rs-creatorCoupon:menu:redeemMenu",{
    -- top = '3%',
    -- left = '3%',
    ['720width'] = '400px',
    ['1080width'] = '700px',
    ['2kwidth'] = '600px',
    ['4kwidth'] = '800px',
    style = {},
    contentslot = {
        style = {
            ['height'] = '500px',
            ['min-height'] = '450px'
        }
    },
    draggable = true,
    canclose = true
})

function OpenRedeemMenu(data)
    local homePage = CouponRedeemMenu:RegisterPage("rs-creatorCoupon:mainRedeemPage")

    homePage:RegisterElement('header', {
        value = 'Redeem Coupon',
        slot = "header",
        style = {}
    })

    homePage:RegisterElement('subheader', {
        value = data.code,
        slot = "header",
        style = {}
    })

    homePage:RegisterElement('line', {
        slot = "header",
        style = {}
    })

    local itemsText = ''
    local weaponsText = ''
    local moneyText = ''

    for i=1, #data.items do
        local item = data.items[i]
        itemsText = itemsText..item.quantity..'x : '..item.label..'\n'
    end

    for i=1, #data.weapons do
        local weapon = data.weapons[i]
        weaponsText = weaponsText..weapon.quantity..'x : '..weapon.weapon..'\n'
    end

    if data.money.money > 0 then
        moneyText = moneyText.."Money : "..data.money.money..'\n'
    end
    if data.money.gold > 0 then
        moneyText = moneyText.."Gold : "..data.money.gold..'\n'
    end
    if data.money.rol > 0 then
        moneyText = moneyText.."Rol : "..data.money.rol..'\n'
    end

    homePage:RegisterElement('subheader', {
        value = "Reward Items",
        slot = "content",
        style = {
            ['color'] = 'red'
        }
    })

    homePage:RegisterElement('textdisplay', {
        value = itemsText,
        slot = "content",
        style = {}
    })

    homePage:RegisterElement('line', {
        slot = "content",
        style = {}
    })

    homePage:RegisterElement('subheader', {
        value = "Reward Weapons",
        slot = "content",
        style = {
            ['color'] = 'red'
        }
    })

    homePage:RegisterElement('textdisplay', {
        value = weaponsText,
        slot = "content",
        style = {}
    })

    homePage:RegisterElement('line', {
        slot = "content",
        style = {}
    })

    homePage:RegisterElement('subheader', {
        value = "Reward Money",
        slot = "content",
        style = {
            ['color'] = 'red'
        }
    })

    homePage:RegisterElement('textdisplay', {
        value = moneyText,
        slot = "content",
        style = {}
    })

    homePage:RegisterElement('bottomline', {slot = 'footer'})

    homePage:RegisterElement('button', {
        label = "Get Rewards",
        slot = 'footer'
    }, function()
        -- This gets triggered whenever the button is clicked
        TriggerServerEvent("rs-creatorcoupon:server:redeemCoupon", data.code)
        CouponRedeemMenu:Close({})
    end)

    homePage:RegisterElement('textdisplay', {
        value = "Make Sure you have enough space in inventory to get these rewards.",
        slot = "footer",
        style = {}
    })

    CouponRedeemMenu:Open({ startupPage = homePage })
end

RegisterNetEvent("rs-creatorcoupon:client:redeemCoupon", function(data)
    OpenRedeemMenu(data)
end)