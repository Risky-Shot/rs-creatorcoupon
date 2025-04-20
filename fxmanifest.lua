games { 'rdr3', 'gta5' }
fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
lua54 'yes'

name 'rs-creatorcoupon'
author 'riskyshot'
description 'A Coupon System to reward players using Creator Codes.'
repository ''

shared_script 'config/shared.lua'

client_scripts {
    'config/client.lua',
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config/server.lua',
    'server/main.lua'
}
