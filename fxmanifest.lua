fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'G.A.S.T. Dev'
description  'ATM hack script v1.0'


client_scripts {
	'client/client.lua',
}

server_scripts {
	'server/server.lua',
}

shared_script {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua',
	'config.lua'
}

dependency 'gast_lib'