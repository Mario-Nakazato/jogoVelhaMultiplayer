--[[

    Menu

    # .

--]]

local function new()
    local menu = {}
    BUTTON_HEIGHT = 64
    LOGO_HEIGHT = 648
    LOGO_WEIGHT = 337
    function newButton(text,fn)
        return{
            text = text,
            fn = fn,
            now = false,
            last = false
        }
    end
    buttons = {}
    font = love.graphics.newFont(32)
    
    function menu:update(dt)
    end
    
    function menu:load()
        logo = love.graphics.newImage('Logo.png')
        table.insert(buttons, newButton(
            'Um jogador', function()
                print('start game')
                return 1
            end))
        table.insert(buttons, newButton(
            'Multiplayer', function()
                print('load game')
                return 2
            end))
        table.insert(buttons, newButton(
            'Exit', function()
                love.event.quit(0)
            end))
    end
    function menu:draw()
        ww = love.graphics.getWidth()
        wh = love.graphics.getHeight()

        button_width = ww/3
        margin = 16

        total_height = (BUTTON_HEIGHT+margin) * #buttons
        cursor_y = 50
        
        for i, button in ipairs(buttons) do
            button.last = button.now
            local bx =(ww/2) - (button_width/2)
            local by =(wh/2) - (total_height/2) +cursor_y

            color = {0.2, 0, 0.5, 1}
            mx, my = love.mouse.getPosition()

            houver = mx > bx and mx < bx + button_width and
                     my > by and my < by + BUTTON_HEIGHT
            if houver then
                color = {0.4, 0, 1, 1}
            end
            button.now = love.mouse.isDown(1)
            if button.now and not button.last and houver then
                return button.fn()
            end

            love.graphics.setColor(unpack(color))
            love.graphics.rectangle(
                'fill',
                bx,
                by,
                button_width,
                BUTTON_HEIGHT,
                BUTTON_HEIGHT/2
            )
            love.graphics.setColor(0,0,0,1)

            local textW = font:getWidth(button.text)
            local textH = font:getHeight(button.text)
            love.graphics.print(
                button.text,
                font,
                (ww/2) - (textW/2),
                by + (textH/2)
            )

            cursor_y = cursor_y + (BUTTON_HEIGHT+ margin)
        end
        love.graphics.setColor(1,1,1,1)

        love.graphics.draw(logo, 
            (ww/2)-(LOGO_WEIGHT*0.65)+10,
            50, 0, 0.65)
    end
    return menu
end

menu = {
    new = new
}

print('menu')

return menu