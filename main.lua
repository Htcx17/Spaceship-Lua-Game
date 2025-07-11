---@diagnostic disable: lowercase-global
local love = require('love')
local Player = require('objects/Player')
local Game = require('states/game')
math.randomseed(os.time())

function love.load()
    love.mouse.setVisible(false)
    mouse_x, mouse_y = 0,0

    local showDebugging = true
    player = Player(showDebugging)
    game = Game()
    game:startNewGame(player)

end

function love.keypressed(key)
    if game.state.running then
        if key == 'w' or key == 'up' then
        player.thrusting = true
        end
        if key == 'space' or key == 'down' then
            player:shootLaser()
        end
        if key == 'escape' then
        game:changeGameState('paused')
        end
    elseif game.state.paused then
        if key == 'escape' then
            game:changeGameState('running')
        end
    end
    
    
end

function love.keyreleased(key)
    if key == 'w' or key == 'up' then
        player.thrusting = false
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if game.state.running then
            player:shootLaser()
        end
    end
end

function love.update(dt)
    mouse_x, mouse_y = love.mouse.getPosition()

    if game.state.running then
        player:movePlayer()

        for ast_index, asteroids in pairs(asteroids) do
            asteroids:move(dt)
        end
    end
end

function love.draw()
    if game.state.running or game.state.paused then
        player:draw(game.state.paused)
        game:draw(game.state.paused)
        for _, asteroids in pairs(asteroids) do
            asteroids:draw(game.state.paused)
        end
    end
    

    love.graphics.setColor(1,1,1,1)

    love.graphics.print(love.timer.getFPS(), 10, 10)
end

