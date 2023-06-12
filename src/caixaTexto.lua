--[[

    Caixa Texto

    # .

--]]

require "/src/palavra"

local function novo(x, y, comp, larg, espessura)

    local tempo = 0

    local caixaTexto = {
        x = x or 0,
        y = y or 0,
        comp = comp or 128,
        larg = larg or 32,
        espessura = espessura or 4,
        texto = "",
        cursor = "",
        piscar = 1,
        selecionado = false
    }

    caixaTexto.fonte = lgrafico.newFont(caixaTexto.larg *0.8)
    
    function caixaTexto:load()
    end

    function caixaTexto:update(dt)
        
        if not self.selecionado then
            tempo = 0
            self.cursor = ""
            return
        end

        tempo = tempo +dt
        if self.piscar < tempo then
            tempo = 0
        end
        
        if self.piscar *0.5 > tempo then
            self.cursor = "|"
        else
            self.cursor = ""
        end

    end

    function caixaTexto:draw()

        lgrafico.setLineWidth(self.espessura)
        lgrafico.rectangle("line", self.x, self.y, self.comp, self.larg)
        lgrafico.print(self.texto ..self.cursor, self.fonte, self.x, self.y)
        
    end

    function caixaTexto:keypressed(tecla, cod, repeticao)
        
        if self.selecionado then
            if tecla == "backspace" then
                self.texto = string.sub(self.texto, 1, #self.texto -1)
            end
        end

    end

    function caixaTexto:keyreleased(tecla, cod)
    end

    function caixaTexto:textinput(texto)
        
        if self.selecionado and self.fonte:getWidth(self.texto) < self.comp -self.fonte:getWidth("|||") then
            self.texto = self.texto ..texto
        end

    end

    function caixaTexto:selecionar(x, y)
        
        if self.x < x and self.x +self.comp > x then
            if self.y < y and self.y +self.larg > y then
                return true
            end
        end

    end

    function caixaTexto:mousepressed(x, y, botao, toque, repeticao)
        
        self.selecionado = self:selecionar(x, y)

    end

    return caixaTexto

end

caixaTexto = {
    novo = novo
}

print("caixaTexto.lua")
  
return caixaTexto