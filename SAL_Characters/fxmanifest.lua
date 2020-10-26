fx_version 'cerulean'
game 'gta5'

author 'Thomas Pritchard'

client_scripts {
    'config.lua',
    'client/main.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/js/main.js',
    'html/css/styles.css'
}