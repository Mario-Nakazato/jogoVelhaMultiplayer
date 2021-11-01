require "palavra"
require "tabuleiro"

function love.load(arg)

    if arg[#arg] == "-debug" then require("mobdebug").start() end -- Debug para ZeroBrane Studio IDE Utilize; Argumento - arg esta disponivel global.

    tamanho = 128
    jogo = tabuleiro.novo(tela.c /2 -tamanho *3 /2, tela.l /2 -tamanho *3 /2, tamanho)

end

function love.update(dt)

    jogo:update(dt)

end

function love.draw()

    jogo:draw()

end

function love.keypressed(tecla, cod, repeticao)

    if tecla == "f5" then
        love.load(arg)
    end

end

function love.keyreleased(tecla, cod)



end

function love.mousepressed(x, y, botao, toque, repeticao)

    jogo:mousepressed(x, y, botao, toque, repeticao)

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

function love.textinput(texto)



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