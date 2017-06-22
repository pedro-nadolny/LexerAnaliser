class Token

   def initialize(tipo, lexama)
      @tipo = tipo
      @lexama = lexama
   end

   def print
       puts "Tk(#{@tipo}, #{@lexama})"
   end

   def get_tipo
        return @tipo
   end

   def get_lexama
       return @lexama
   end
end

def is_numeric?(obj) 
   obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
end

$tokenArray = []

def scan(str = "") 
    i = 0
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
                    return "Token invalido, esperava \"num\", encontrou %s" % [str[temp]]
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
            $tokenArray << Token.new("num", number)

        elsif str[i] == '+'    
            $tokenArray << Token.new("+", "+")

        elsif str[i] == '-'
            $tokenArray << Token.new("-", "-")
    
        elsif str[i] == '*'
            $tokenArray << Token.new("*", "*")

        elsif str[i] == '/'
            $tokenArray << Token.new("/", "/")
        
        elsif str[i] == '('
            $tokenArray << Token.new("(", "(")
    
        elsif str[i] == ')'
            $tokenArray << Token.new(")", ")")
        
        elsif str[i] == '^'
            $tokenArray << Token.new("^", "^")
        
        else
            return "Caracter desconhecido %s" % [str[i]]
        end
    i=i+1
    end
    
    if $tokenArray.length > 0 
        return nil
    end

    return "Token invalido: string vazia"    
end

def scanner(input = "") 
    msg = scan(input)
    if msg
        return nil, msg
    else 
        i = 0
        return Proc.new {
            if i == $tokenArray.length
                next Token.new("EOF", "")
            end

            t = $tokenArray[i]
            i = i + 1
            next t
        }
    end
end
