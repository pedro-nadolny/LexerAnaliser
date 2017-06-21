#!/bin/env ruby
# encoding: utf-8


class Token
   def initialize(tipo, lexama)
      @tipo = tipo
      @lexama = lexama
   end

   def print
       puts " Tipo: #{@tipo}" + " Lexama: #{@lexama}"
   end
end


Token_vector = []


def is_numeric?(obj) 
   obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
end


puts "informe a string"
str = gets


i = 0
#str.each_str[i] do |str[i]|
while i < str.length
  
    counterPoint = false
    if str[i] == ' ' or str[i] == '\n' or str[i] == '\t' then
        i=+1
    

    elsif is_numeric? str[i] then
        number = str[i]
        temp = i+1
        while(is_numeric? str[temp] or str[temp] == ".")
            

                if(str[temp] == ".")
                    number << str[temp]
                    temp+=1
                     if(!(is_numeric? str[temp]))
                         puts("TOKEN INVALIDO")
                         return
                     end

                     while(is_numeric? str[temp])
                        number << str[temp]
                        temp+=1
                
                        if !is_numeric? str[temp]
                            i = temp
                           next
                        end
                     end
                
                else
                    number << str[temp]
                    temp+=1
                end
        end
        i = temp-1
        Token_vector << Token.new("numero", number)
        

    elsif str[i] == '+' then
       Token_vector << Token.new("+", "+")
    

    elsif str[i] == '-' then
        Token_vector << Token.new("-", "-")
    

    elsif str[i] == '*' then
        Token_vector << Token.new("*", "*")
    

    elsif str[i] == '/' then
        Token_vector << Token.new("/", "/")
    

    elsif str[i] == '(' then
        Token_vector << Token.new("(", "(")
    

    elsif str[i] == ')' then
        Token_vector << Token.new(")", ")")
    

    elsif str[i] == '^' then
        Token_vector << Token.new("^", "^")
    

    else
        puts("error")
    end
    i+=1
end

Token_vector.each do |token|
    puts token.print
end

