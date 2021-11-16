require "palavra"
require "tabuleiro"
require "menu"
require "caixaTexto"

function love.load(arg)

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
    _cliente = menu:new()
    _menu:load('main')
    _multi:load('multiplayer')
    _cliente:load('cliente')
    opc = nil
    mopc = nil
    hopc = nil
    enet = require "enet"
    host = enet.host_create("*:25565")
    server =nil
    event = nil
    connected = false
    isCurrentPlayer = false
    --[[_jogo = goUnPack(goPack(jogo))
    print(_jogo.x, _jogo.y, _jogo.tamanho, _jogo.jogador, _jogo.jogada, _jogo.venceu, _jogo.quadrado[1][1],
        _jogo.quadrado[1][2], _jogo.quadrado[1][3], _jogo.quadrado[2][1], _jogo.quadrado[2][2], _jogo.quadrado[2][3],
        _jogo.quadrado[3][1], _jogo.quadrado[3][2], _jogo.quadrado[3][3])

    if jogo == x then
        print("passou")
    end]]
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
        if mopc == nil then
            _multi:draw()
        elseif mopc == 1 then
            if hopc == nil then
                _cliente:draw()
                ip:draw()
            elseif hopc == 1 then
                host = enet.host_create()
                server = host:connect(ip.texto)
                server:timeout(1, 5000, 120000)
                if connected then
                    jogo:draw()
                end
                -- SE SAIR DO LOOP WHILE EVENT A CONEXAO E FECHADA
                while mopc == 1 and (connected == false or isCurrentPlayer == false) do
                    event = host:service(100)
                    while event do
                        if event.type == "receive" then
                            -- RECEBE O JOGO
                            jogo = goUnPack(event.data)

                            -- ALTERA O JOGO
                            isCurrentPlayer = true

                        elseif event.type == "connect" then
                            print(event.peer, "connected.")
                            connected = true
                        elseif event.type == "disconnect" then
                            print(event.peer, "disconnected.")
                            mopc = nil
                            opc = nil
                        end
                        event = host:service(100)
                    end
                end
            elseif hopc == 2 then
                mopc = nil
                hopc = nil
            end
        elseif mopc == 2 then
            if connected == true then
                jogo:draw()
            end
            while mopc == 2 and (connected == false or isCurrentPlayer == false) do
                event = host:service(0)
                while event do
                    print('DENTRO DO LOOP', event.data,event.peer,event.type)
                    if event.type == "receive" then
                        -- RECEBE O JOGO
                        jogo = goUnPack(event.data)

                        -- ALTERA O JOGO
                        isCurrentPlayer = true

                    elseif event.type == "connect" then
                        print(event.peer, "connected.")
                        -- COMECA O JOGO
                        isCurrentPlayer = true
                        connected = true

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
    local data = love.data.pack("string", "nnnsnssssssssss", go.x, go.y, go.tamanho, go.jogador, go.jogada, go.venceu,
        go.quadrado[1][1], go.quadrado[1][2], go.quadrado[1][3], go.quadrado[2][1], go.quadrado[2][2],
        go.quadrado[2][3], go.quadrado[3][1], go.quadrado[3][2], go.quadrado[3][3])
    return data
end

function goUnPack(data)
    local go = tabuleiro.novo()
    go.x, go.y, go.tamanho, go.jogador, go.jogada, go.venceu, go.quadrado[1][1], go.quadrado[1][2], go.quadrado[1][3], go.quadrado[2][1], go.quadrado[2][2], go.quadrado[2][3], go.quadrado[3][1], go.quadrado[3][2], go.quadrado[3][3] =
        love.data.unpack("nnnsnssssssssss", data, 1)

    return go
end

function love.keypressed(tecla, cod, repeticao)
    -- goPrint(jogo)
    print(jogo.x, jogo.y, jogo.tamanho, jogo.jogador, jogo.jogada, jogo.venceu, jogo.quadrado[1][1],
        jogo.quadrado[1][2], jogo.quadrado[1][3], jogo.quadrado[2][1], jogo.quadrado[2][2], jogo.quadrado[2][3],
        jogo.quadrado[3][1], jogo.quadrado[3][2], jogo.quadrado[3][3])
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
        -- Adcionar retorno de se a jogada aconteceu
        jogo:mousepressed(x, y, botao, toque, repeticao)
        -- envia o jogo?

    elseif opc == 2 then
        if mopc == nil then
            mopc = _multi:mousepressed(x, y, botao, toque, repeticao)
        elseif mopc == 1 then
            if hopc == nil then
                ip:mousepressed(x, y, botao, toque, repeticao)
                hopc = _cliente:mousepressed(x, y, botao, toque, repeticao)
            elseif hopc == 1 then

            end
        elseif mopc == 2 and connected and isCurrentPlayer then
            jogo:mousepressed(x, y, botao, toque, repeticao)
            print(event)
            --event.peer:send("goPack(jogo)")
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
