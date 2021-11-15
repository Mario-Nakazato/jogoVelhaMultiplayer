require "palavra"
require "tabuleiro"
require "menu"
require "caixaTexto"

gameObject = {
    tab = "Ola MUNDO",
    actPlayer = 'x',
    num1 = 512,
    num2 = 420 + 69
}

function love.load(arg)

    if arg[#arg] == "-debug" then
        require("mobdebug").start()
    end -- Debug para ZeroBrane Studio IDE Utilize; Argumento - arg esta disponivel global.

    jogo = tabuleiro.novo()
    jogo.tamanho = 128
    jogo.x, jogo.y = tela.c / 2 - jogo.tamanho * 3 / 2, tela.l / 2 - jogo.tamanho * 3 / 2

    ip = caixaTexto.novo()
    ip.comp, ip.larg = 640, 64
    ip.x, ip.y = tela.c / 2 - ip.comp / 2, jogo.y -- tela.l /2 -ip.larg /2
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

end

function love.draw()

    if opc == nil then
        _menu:draw()
    elseif opc == 1 then
        jogo:draw()
    elseif opc == 2 then
        _multi:draw()
        if mopc == 1 then
            local enet = require "enet"
            local host = enet.host_create()
            local server = host:connect("localhost:25565")
            server:timeout(1, 5000, 5000)
            while mopc == 1 do
                local event = host:service(100)
                while event do
                    if event.type == "receive" then
                        -- RECEBE O JOGO
                        gameObject = goUnPack(event.data)

                        -- PRINT
                        goPrint(gameObject)

                        -- ALTERA O JOGO
                        gameObject.num1 = gameObject.num1 + 1
                        gameObject.num2 = gameObject.num2 + 1

                        -- DEVOLVE O JOGO
                        event.peer:send(goPack(gameObject))

                    elseif event.type == "connect" then
                        print(event.peer, "connected.")
                    elseif event.type == "disconnect" then
                        print(event.peer, "disconnected.")
                        mopc = nil
                        opc = nil
                    end
                    event = host:service(100)
                end
            end
        elseif mopc == 2 then
            local enet = require "enet"
            local host = enet.host_create("*:25565")
            while mopc == 2 do
                local event = host:service(0)
                while event do
                    if event.type == "receive" then
                        -- RECEBE O JOGO
                        gameObject = goUnPack(event.data)
                        -- PRINT
                        goPrint(gameObject)

                        -- ALTERA O JOGO
                        gameObject.num1 = gameObject.num1 + 1
                        gameObject.num2 = gameObject.num2 + 1

                        -- DEVOLVE O JOGO
                        event.peer:send(goPack(gameObject))

                    elseif event.type == "connect" then
                        print(event.peer, "connected.")
                        -- COMECA O JOGO
                        event.peer:send(goPack(gameObject))

                    elseif event.type == "disconnect" then
                        print(event.peer, "disconnected.")
                        mopc = nil
                        opc = nil
                    end
                    event = host:service()
                end
            end
        elseif mopc == 3 then
            opc = nil
            mopc = nil
        end
    end
end
function goPack(go)
    local data = love.data
                     .pack("string", "ssnn", gameObject.tab, gameObject.actPlayer, gameObject.num1, gameObject.num2)
    return data
end
function goUnPack(data)
    local go = {tab, actPlayer, num1, num2}
    go.tab, go.actPlayer, go.num1, go.num2 = love.data.unpack("ssnn", go, 1)
    return go
end
function goPrint(go)
    for k, v in pairs(go) do
        print(v)
    end
end
function love.keypressed(tecla, cod, repeticao)

    if tecla == "f5" then
        love.load(arg)
    end

    ip:keypressed(tecla, cod, repeticao)

end

function love.keyreleased(tecla, cod)

end

function love.textinput(texto)

    ip:textinput(texto)

end

function love.mousepressed(x, y, botao, toque, repeticao)

    if opc == nil then
        opc = _menu:mousepressed(x, y, botao, toque, repeticao)
    elseif opc == 1 then
        jogo:mousepressed(x, y, botao, toque, repeticao)
    elseif opc == 2 then
        if mopc == nil then
            mopc = _multi:mousepressed(x, y, botao, toque, repeticao)
        elseif mopc == 1 then
        elseif mopc == 2 then
            if hopc == nil then
                ip:mousepressed(x, y, botao, toque, repeticao)
                hopc = _host:mousepressed(x, y, botao, toque, repeticao)
            elseif hopc == 1 then
            elseif hopc == 2 then

            end
        end
    end
end

function love.mousereleased(x, y, botao, toque, repeticao)

end

function love.mousemoved(x, y, dx, dy, toque)

end

function love.wheelmoved(x, y)

end

function love.mousefocus(foco)

end

function love.resize(c, l)

end

function love.focus(foco)

end

function love.quit()

end
--[[
function inicioContato(a, b, contato)



end

function fimContato(a, b, contato)



end

function preContato(a, b, contato)



end

--function posContato(a, b, contato, normalImpulso, tangenteImpulso, normalImpulso1, tangenteImpulso1)
function posContato(a, b, contato, normalImpulso, tangenteImpulso)



end

function love.touchpressed(id, x, y, dx, dy, pressao)



end

function love.touchreleased(id, x, y, dx, dy, pressao)



end

function love.touchmoved(id, x, y, dx, dy, pressao)



end

function love.displayrotated(indice, orientacao)



end

function love.textedited(texto, inicio, tamanho)



end

function love.textinput(texto)--



end

function love.directorydropped(caminho)



end

function love.filedropped(arquivo)



end

function love.errorhandler(erro)



end

function love.lowmemory()



end

function love.threaderror(thread, erro)



end

function love.visible(visivel)-- Esta funcao CallBack não funciona, utilize visivel = love.window.isMinimized()
end
--]]
