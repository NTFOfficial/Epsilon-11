local Games = { -- the only reason i added the game names was for myself i dont wanna check the game ids :P
    [16680835] = {"Notoriety", "https://api.jnkie.com/api/v1/luascripts/public/6fddbda18f622560fa2906de3b63fdf63869f57cbaba3e958e668cb1a5be7ddd/download"},
    [7633926880] = {"BloxStrike", "https://api.jnkie.com/api/v1/luascripts/public/c134fdd571ed442f5026db2fd4a47f633e4b985b98ac64e32faec5dce96f79a2/download"},
    [8773050457] = {"SCP retroBreach", "https://api.jnkie.com/api/v1/luascripts/public/b95a31871f77b922f5318487784030b6a3c94913e4491f578ab63a0bd07bb794/download"},
    [3419284255] = {"Peroxide", "https://api.jnkie.com/api/v1/luascripts/public/77004a5744250e0bfec2afd74083e2c22d377f09a67bf214dd7d491fb9275cc9/download"},
    [3419284255] = {"KILLSTREAK!", "https://api.jnkie.com/api/v1/luascripts/public/7ab7a108d0d80d8138fd2a921c746f8e61eec9a3e646eda36bfd86ee53b3cd8d/download"},
}

local Game = Games[game.GameId]

if Game then
    loadstring(game:HttpGet(Game[2]))()
end
