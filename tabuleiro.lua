--[[

    Tabuleiro

    # .

--]]

require "palavra"

local function novo(x, y, tamanho)

    local tabuleiro = {
        x = x or 0,
        y = y or 0,
        tamanho = tamanho or 128,
        quadrado = {
            [1] = {" ", " ", " "},
            [2] = {" ", " ", " "},
            [3] = {" ", " ", " "},
        }
    }

    tabuleiro.fonte = lgrafico.newFont(tabuleiro.tamanho)
    
    function tabuleiro:load()
    end

    function tabuleiro:update(dt)
    end

    function tabuleiro:draw()
        lgrafico.setLineWidth(self.tamanho /32)
        lgrafico.line(self.x, self.y +self.tamanho, self.x +self.tamanho *3, self.y +self.tamanho)
        lgrafico.line(self.x, self.y +self.tamanho *2, self.x +self.tamanho *3, self.y +self.tamanho *2)
        lgrafico.line(self.x +self.tamanho, self.y, self.x +self.tamanho, self.y +self.tamanho *3)
        lgrafico.line(self.x +self.tamanho *2, self.y, self.x +self.tamanho *2, self.y +self.tamanho *3)
        for i = 0, 2 do
            for j = 0, 2 do
                lgrafico.print(self.quadrado[i +1][j +1], self.fonte, self.x +self.tamanho *j +self.tamanho /8, self.y +self.tamanho *i -self.tamanho /16)
            end
        end
    end

    function tabuleiro:peca(i, j, p)
        self.quadrado[i][j] = p or " "
    end

    function tabuleiro:mousepressed(x, y, botao, toque, repeticao)
        
        p = botao == 1 and "X" or "O"

        if self.x < x and self.x +self.tamanho > x then
            if self.y < y and self.y +self.tamanho > y then
                self:peca(1, 1, p)
            elseif self.y +self.tamanho < y and self.y +self.tamanho *2 > y then
                self:peca(2, 1, p)
            elseif self.y +self.tamanho *2 < y and self.y +self.tamanho *3 > y then
                self:peca(3, 1, p)
            end
        elseif self.x +self.tamanho < x and self.x +self.tamanho *2 > x then
            if self.y < y and self.y +self.tamanho > y then
                self:peca(1, 2, p)
            elseif self.y +self.tamanho < y and self.y +self.tamanho *2 > y then
                self:peca(2, 2, p)
            elseif self.y +self.tamanho *2 < y and self.y +self.tamanho *3 > y then
                self:peca(3, 2, p)
            end
        elseif self.x +self.tamanho *2 < x and self.x +self.tamanho *3 > x then
            if self.y < y and self.y +self.tamanho > y then
                self:peca(1, 3, p)
            elseif self.y +self.tamanho < y and self.y +self.tamanho *2 > y then
                self:peca(2, 3, p)
            elseif self.y +self.tamanho *2 < y and self.y +self.tamanho *3 > y then
                self:peca(3, 3, p)
            end
        end

    end

    return tabuleiro

end

tabuleiro = {
    novo = novo
}

print("tabuleiro.lua")
  
return tabuleiro