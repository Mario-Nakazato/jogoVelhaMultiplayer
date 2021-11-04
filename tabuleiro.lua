--[[

    Tabuleiro

    # .

--]]

require "palavra"

local function novo(x, y, tamanho, jogador)

    local tabuleiro = {
        x = x or 0,
        y = y or 0,
        tamanho = tamanho or 128,
        jogador = jogador or "X",
        jogada = 9,
        venceu = nil,
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

        lgrafico.rectangle("line", self.x, self.y -self.tamanho, self.tamanho *3, self.tamanho)
        lgrafico.rectangle("line", self.x, self.y +self.tamanho *3, self.tamanho *3, self.tamanho)
        lgrafico.print("Mário X", lgrafico.newFont(32), self.x +self.tamanho /8, self.y -self.tamanho +self.tamanho /16)
        if self.venceu == "X" or self.venceu == "O" then
            lgrafico.print("Vencedor: " ..tostring(self.venceu), lgrafico.newFont(32), self.x +self.tamanho /8, self.y -self.tamanho /2 +self.tamanho /16)
        elseif self.venceu == "Velha" then
            lgrafico.print(self.venceu, lgrafico.newFont(32), self.x +self.tamanho +self.tamanho /8, self.y -self.tamanho /2 +self.tamanho /16)
        end
        
        lgrafico.print("Bruno O", lgrafico.newFont(32), self.x +self.tamanho *2 -self.tamanho /8, self.y -self.tamanho +self.tamanho /16)

    end

    function tabuleiro:jogar(i, j, p)
        if i and j and self.jogada > 0 and self.quadrado[i][j] == "" then
            self.jogada = self.jogada -1
            self.quadrado[i][j] = p or self.jogador
            self.jogador = self.jogador == "X" and "O" or "X"
        end
        return self:checar()
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

        self.venceu = nil

        for i = 1, 3 do-- Horizontal Vertical
            if self.quadrado[i][1] ~= "" and self.quadrado[i][1] == self.quadrado[i][2] and self.quadrado[i][1] == self.quadrado[i][3] then
                self.venceu = self.quadrado[i][1]
                break
            elseif self.quadrado[1][i] ~= "" and self.quadrado[1][i] == self.quadrado[2][i] and self.quadrado[1][i] == self.quadrado[3][i] then
                self.venceu = self.quadrado[1][i]
                break
            end
        end

        -- Diagonal
        if self.quadrado[1][1] ~= "" and self.quadrado[1][1] == self.quadrado[2][2] and self.quadrado[1][1] == self.quadrado[3][3] then
            self.venceu = self.quadrado[1][1];
        elseif self.quadrado[3][1] ~= "" and self.quadrado[3][1] == self.quadrado[2][2] and self.quadrado[3][1] == self.quadrado[1][3] then
            self.venceu = self.quadrado[3][1];
        end

        if self.venceu then
            self.jogada = 0
        end

        if self.venceu == nil and self.jogada == 0 then
            self.venceu = "Velha"
        end

        return self.venceu

    end

    function tabuleiro:mousepressed(x, y, botao, toque, repeticao)
        
        if self.jogada > 0 then
            --p = botao == 1 and "X" or botao == 2 and "O" or ""
            i, j = self:selecionar(x, y)
        end
        return self:jogar(i, j, p)

    end

    return tabuleiro

end

tabuleiro = {
    novo = novo
}

print("tabuleiro.lua")
  
return tabuleiro