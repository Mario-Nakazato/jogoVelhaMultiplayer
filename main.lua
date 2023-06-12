require "/src/palavra"
require "/src/utils/tools"
require "/src/tabuleiro"
require "/src/menu"
require "/src/caixaTexto"
socket = require "socket"
udp = socket.udp()

currentPlayer = false
msg_or_ip = nil
port_or_nil = nil

function love.load(arg, unfilteredArg)
    if arg[#arg] == "-debug" then
        require("mobdebug").start()
    end -- Debug para ZeroBrane Studio IDE Utilize; Argumento - arg esta disponivel global.

    jogo = tabuleiro.novo()
    jogo.tamanho = 128
    jogo.x, jogo.y = tela.c / 2 - jogo.tamanho * 3 / 2, tela.l / 2 - jogo.tamanho * 3 / 2

    ip = caixaTexto.novo()
    ip.comp, ip.larg = 640, 64
    ip.x, ip.y = tela.c / 2 - ip.comp / 2, jogo.y * 1.75 -- tela.l /2 -ip.larg /2
    ip.fonte = lgrafico.newFont(ip.larg * 0.8)

    _menu = menu:new()
    _multi = menu:new()
    _host = menu:new()
    _menu:load('main')
    _multi:load('multiplayer')
    _host:load('host')
    opc = nil
    mopc = nil
    hopc = nil
end

function love.update(dt)
    ip:update(dt)
    if mopc == 1 and hopc == 1 then
        address, port = "localhost", 25565
        if ip.texto ~= "" then
            address = ip.texto
        end
        udp:setpeername(address, port)
        udp:settimeout(0)
        if playi and playj then
            udp:send(tostring(playi) .. '-' .. tostring(playj))
            playi = nil
            playj = nil
            currentPlayer = true
        end
        data = udp:receive()
        if data then
            local p = split(data, '-')
            playi, playj, currentPlayer, gameStatus = p[1], p[2], p[3], p[4]
            if playi and playj and currentPlayer then
                jogo:jogar(tonumber(playi), tonumber(playj))
                playi = nil
                playj = nil
                currentPlayer = false
            end
        end
    elseif mopc == 2 then
        -- TO DO fazer a porta ser dinamica
        udp:setsockname('*', 25565)
        udp:settimeout(0)
        data, msgOrIp, portOrNil = udp:receivefrom()
        if portOrNil then
            port_or_nil = portOrNil
        end
        if msgOrIp ~= "timeout" then
            msg_or_ip = msgOrIp
        end
        if data then
            local p = split(data, '-')
            playi, playj = p[1], p[2]

            if playi and playj and currentPlayer == false then
                jogo:jogar(tonumber(playi), tonumber(playj))
                playi = nil
                playj = nil
                currentPlayer = true
            end
        end

        if playi and playj and currentPlayer then
            udp:sendto(tostring(playi) .. '-' .. tostring(playj) .. '-' .. tostring(currentPlayer) .. '-' ..
                tostring(gameStatus), msg_or_ip, port_or_nil)
            playi = nil
            playj = nil
            currentPlayer = false
        end
    end
end

function love.draw()
    if opc == nil then
        _menu:draw()
    elseif opc == 1 then
        jogo:draw()
    elseif opc == 2 then
        if mopc == nil then
            _multi:draw()
        elseif mopc == 1 then
            if hopc == nil then
                _host:draw()
                ip:draw()
            elseif hopc == 1 then
                jogo:draw()
            elseif hopc == 2 then
                mopc = nil
                hopc = nil
            end
        elseif mopc == 2 then
            jogo:draw()
        elseif mopc == 3 then
            opc = nil
            mopc = nil
        end
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == "f5" then
        love.load(arg)
    end

    ip:keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
end

function love.mousepressed(x, y, button, istouch, presses)
    if opc == nil then
        opc = _menu:mousepressed(x, y, button, istouch, presses)
    elseif opc == 1 then
        jogo:mousepressed(x, y, button, istouch, presses)
    elseif opc == 2 then
        if mopc == nil then
            mopc = _multi:mousepressed(x, y, button, istouch, presses)
        elseif mopc == 1 then
            if hopc == nil then
                ip:mousepressed(x, y, button, istouch, presses)
                hopc = _host:mousepressed(x, y, button, istouch, presses)
            elseif hopc == 1 then
                if currentPlayer == false then
                    playi, playj = jogo:mousepressed(x, y, button, istouch, presses)
                end
            end
        elseif mopc == 2 then
            if currentPlayer then
                playi, playj, gameStatus = jogo:mousepressed(x, y, button, istouch, presses)
            end
        end
    end
end

function love.mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
end

function love.wheelmoved(x, y)
end

function love.mousefocus(focus)
end

function love.resize(w, h)
end

function love.focus(focus)
end

function love.quit()
end

function love.touchpressed(id, x, y, dx, dy, pressure)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
end

function love.displayrotated(index, orientation)
end

function love.textedited(text, start, length)
end

function love.textinput(text)
    ip:textinput(text)
end

--[[
function love.directorydropped(path)
end

function love.filedropped(file)
end

function love.errorhandler(msg)
end

function love.lowmemory()
end

function love.threaderror(thread, errorstr)
end

function love.visible(visible)-- Esta funcao CallBack não funciona, utilize visivel = love.window.isMinimized()
end

--love.physics world callbacks
function beginContact(a, b, coll)
end

function endContact(a, b, coll)
end

function preSolve(a, b, coll)
end

--postSolve(fixture1, fixture2, contact, normal_impulse1, tangent_impulse1, normal_impulse2, tangent_impulse2)
function postSolve(a, b, coll, normalimpulse, tangentimpulse)
end
--love.physics world callbacks
--]]
