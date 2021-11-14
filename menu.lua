--[[

    Menu

    # .

--]]

local function new()
    local menu = {}
    BUTTON_HEIGHT = 64
    LOGO_HEIGHT = 648
    LOGO_WEIGHT = 337
    function newButton(text, fn)
        return {
            text = text,
            fn = fn,
            now = false,
            last = false
        }
    end
    local buttons = {}
    font = love.graphics.newFont(32)
    local button_location = {}
    function menu:update(dt)
    end

    function menu:load(any)
        logo = love.graphics.newImage('Logo.png')
        button_location = {}
        if any == 'main' then
            table.insert(buttons, newButton('Um jogador', function()
                print('start game')
                return 1
            end))
            table.insert(buttons, newButton('Multiplayer', function()
                print('load game')
                return 2
            end))
            table.insert(buttons, newButton('Exit', function()
                love.event.quit(0)
            end))
        elseif any == 'multiplayer' then
            table.insert(buttons, newButton('Conectar', function()
                print('Conectar')
                return 1
            end))
            table.insert(buttons, newButton('Hospedar', function()
                print('Hospedar')
                return 2
            end))
            table.insert(buttons, newButton('Voltar', function()
                print('Voltar')
                return 3
            end))
        end
    end
    function menu:mousepressed(x, y, botao, toque, repeticao)
        for i, bt in pairs(button_location) do
            if  x > bt[1] and x < bt[2] and y > bt[3] and y < bt[4] then
               return bt[5].fn()
            end
        end
        return nil
    end

    function menu:draw()
        ww = love.graphics.getWidth()
        wh = love.graphics.getHeight()

        button_width = ww / 3
        margin = 16

        total_height = (BUTTON_HEIGHT + margin) * #buttons
        cursor_y = 50
        if #button_location == 0  then
            located = false
        else
            located = true 
        end
        for i, button in ipairs(buttons) do
            button.last = button.now
            bx = (ww / 2) - (button_width / 2)
            by = (wh / 2) - (total_height / 2) + cursor_y

            color = {0.2, 0, 0.5, 1}
            mx, my = love.mouse.getPosition()

            houver = mx > bx and mx < bx + button_width and my > by and my < by + BUTTON_HEIGHT
            if located == false then
                button_location[button.text] = {bx, bx+button_width, by, by+BUTTON_HEIGHT, button}
            end
            if houver then
                color = {0.4, 0, 1, 1}
            end

            love.graphics.setColor(unpack(color))
            love.graphics.rectangle('fill', bx, by, button_width, BUTTON_HEIGHT, BUTTON_HEIGHT / 2)
            love.graphics.setColor(0, 0, 0, 1)

            textW = font:getWidth(button.text)
            textH = font:getHeight(button.text)
            love.graphics.print(button.text, font, (ww / 2) - (textW / 2), by + (textH / 2))

            cursor_y = cursor_y + (BUTTON_HEIGHT + margin)
        end
        love.graphics.setColor(1, 1, 1, 1)

        love.graphics.draw(logo, (ww / 2) - (LOGO_WEIGHT * 0.65) + 10, 50, 0, 0.65)
    end
    return menu
end

menu = {
    new = new
}

print('menu')

return menu
