fx_version 'cerulean'
game 'gta5'

author 'GOD-GAMER'
description 'Advanced Retail and Fast Food Job System with Corporate Ladder'
version '0.0.2'

shared_scripts {
    'config.lua',
    'shared/utils.lua',
    'shared/startup.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

exports {
    'getPlayerJobData',
    'addExperience',
    'promotePlayer',
    'getJobStores',
    'testResource'
}