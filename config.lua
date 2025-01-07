Config = {}

Config.MinWithdrawl = 1500 -- $ received minimum for successful hack
Config.MaxWithdrawal = 2500 -- $ received maximum for successful hack
Config.Account = "money" -- money | black_money | bank
Config.AddStress = 5 --% stress gain from hacking
Config.mincops = 0 -- minimum required cops to start mission

Config.ATMModels = {
    `prop_atm_01`, -- 20 on map
    `prop_atm_02`, -- 37 on map
    `prop_atm_03`, -- 30 on map
    `prop_fleeca_atm` -- 4 on map
}

Config.ATMModelsString = {
    "prop_atm_01", -- 20 on map
    "prop_atm_02", -- 37 on map
    "prop_atm_03", -- 30 on map
    "prop_fleeca_atm" -- 4 on map
}

Config.Chance = 0.5 -- Chance of police alert on successful hack. Note: police are always alerted on failed hack.

