fx_version 'cerulean'
game 'gta5'

author 'Thomas Pritchard'

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua'
}