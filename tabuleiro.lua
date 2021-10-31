--[[

    Tabuleiro

    # .

--]]

require "palavra"

local function novo()
  
    local tabuleiro = {
        fonte = lgrafico.newFont(128)
    }
    
    function tabuleiro:load()
        lgrafico.setFont(self.fonte)
    end

    function tabuleiro:update(dt)
    end

    function tabuleiro:draw()
        lgrafico.setLineWidth(4)
        lgrafico.line(0, 128, 128 *3, 128)
        lgrafico.line(0, 128 *2, 128 *3, 128 *2)
        lgrafico.line(128, 0, 128, 128 *3)
        lgrafico.line(128 *2, 0, 128 *2, 128 *3)
        lgrafico.print("O", 16, -8)
    end

    return tabuleiro
  
  end
  
  tabuleiro = {
    novo = novo
  }
  
  print("tabuleiro.lua")
  
  return tabuleiro