class Token
   def initialize(tipo, lexama)
      @tipo = tipo
      @lexama = lexama
   end

   def print
       puts "Tk(#{@tipo}, #{@lexama})"
   end
end

def is_numeric?(obj) 
   obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
end

def scan(str = "") 
    i = 0
    tokenArray = []

    while i < str.length
        if str[i] == ' ' or str[i] == '\n' or str[i] == '\t' then
            i =+ 1
        elsif is_numeric? str[i]
            number = str[i]
            temp = i+1

            while(is_numeric? str[temp])
                number << str[temp]
                temp+=1
        
                if !is_numeric? str[temp]
                    i = temp
                    next
                end
            end

            if(str[temp] == ".")
                number << str[temp]
                temp+=1
                
                if (!(is_numeric? str[temp]))
                    return nil, "Token invalido, esperava \"num\", encontrou %s" % [str[temp]]
                end

                while(is_numeric? str[temp])
                    number << str[temp]
                    temp+=1
        
                    if !is_numeric? str[temp]
                        i = temp
                        next
                    end
                end
            end
            i = temp-1
            tokenArray << Token.new("num", number)

        elsif str[i] == '+'    
            tokenArray << Token.new("+", "+")

        elsif str[i] == '-'
            tokenArray << Token.new("-", "-")
    
        elsif str[i] == '*'
            tokenArray << Token.new("*", "*")

        elsif str[i] == '/'
            tokenArray << Token.new("/", "/")
        
        elsif str[i] == '('
            tokenArray << Token.new("(", "(")
    
        elsif str[i] == ')'
            tokenArray << Token.new(")", ")")
        
        elsif str[i] == '^'
            tokenArray << Token.new("^", "^")
        
        else
            return nil, "Caracter desconhecido %s" % [str[i]]
        end
    i=i+1
    end
    
    if tokenArray.length > 0 
        puts("ScanReturns: ")
        puts(tokenArray.class)
        return tokenArray
    end

    return nil, "Token invalido: string vazia"    
end

def scanner(input = "") 
    tokens, msg = scan(input)
    puts("ScanRead: ")
    puts(tokens.class)

    if tokens 
        i = 0
        return Proc.new {
            if i > tokens.length
                return Token.new("EOF", "")
            end

            t = tokens[i]
            i = i + 1
            next t
        }
    else 
        return nil, msg
    end
end