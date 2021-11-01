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
        jogada = 9,
        quadrado = {
            [1] = {"", "", ""},
            [2] = {"", "", ""},
            [3] = {"", "", ""},
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

    function tabuleiro:jogar(i, j, p)
        if i and j and self.jogada > 0 then
            self.jogada = self.jogada -1
            self.quadrado[i][j] = p or ""
        end
        print(self:checar(), self.jogada)
    end

    function tabuleiro:selecionar(x, y)

        if self.x < x and self.x +self.tamanho > x then
            if self.y < y and self.y +self.tamanho > y then
                i, j = 1, 1
            elseif self.y +self.tamanho < y and self.y +self.tamanho *2 > y then
                i, j = 2, 1
            elseif self.y +self.tamanho *2 < y and self.y +self.tamanho *3 > y then
                i, j = 3, 1
            end
        elseif self.x +self.tamanho < x and self.x +self.tamanho *2 > x then
            if self.y < y and self.y +self.tamanho > y then
                i, j = 1, 2
            elseif self.y +self.tamanho < y and self.y +self.tamanho *2 > y then
                i, j = 2, 2
            elseif self.y +self.tamanho *2 < y and self.y +self.tamanho *3 > y then
                i, j = 3, 2
            end
        elseif self.x +self.tamanho *2 < x and self.x +self.tamanho *3 > x then
            if self.y < y and self.y +self.tamanho > y then
                i, j = 1, 3
            elseif self.y +self.tamanho < y and self.y +self.tamanho *2 > y then
                i, j = 2, 3
            elseif self.y +self.tamanho *2 < y and self.y +self.tamanho *3 > y then
                i, j = 3, 3
            end
        end

        return i, j

    end

    function tabuleiro:checar()

        venceu = nil

        for i = 1, 3 do-- Horizontal Vertical
            if self.quadrado[i][1] ~= "" and self.quadrado[i][1] == self.quadrado[i][2] and self.quadrado[i][1] == self.quadrado[i][3] then
                venceu = self.quadrado[i][1]
                break
            elseif self.quadrado[1][i] ~= "" and self.quadrado[1][i] == self.quadrado[2][i] and self.quadrado[1][i] == self.quadrado[3][i] then
                venceu = self.quadrado[1][i]
                break
            end
        end

        -- Diagonal
        if self.quadrado[1][1] ~= "" and self.quadrado[1][1] == self.quadrado[2][2] and self.quadrado[1][1] == self.quadrado[3][3] then
            venceu = self.quadrado[1][1];
        elseif self.quadrado[3][1] ~= "" and self.quadrado[3][1] == self.quadrado[2][2] and self.quadrado[3][1] == self.quadrado[1][3] then
            venceu = self.quadrado[3][1];
        end

        if venceu == nil and self.jogada == 0 then
            return "Velha"
        else
            return venceu
        end

    end

    function tabuleiro:mousepressed(x, y, botao, toque, repeticao)
        
        p = botao == 1 and "X" or botao == 2 and "O" or ""
        i, j = self:selecionar(x, y)
        self:jogar(i, j, p)

    end

    return tabuleiro

end

tabuleiro = {
    novo = novo
}

print("tabuleiro.lua")
  
return tabuleiro