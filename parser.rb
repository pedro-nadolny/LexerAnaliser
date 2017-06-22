require_relative 'lexer'
class Parser 
    def initialize
        @token = Token.new("", "")
        @get_token = Proc.new{}
    end 

    def parse(input) 
        scanner, msg = scanner(input)

        if scanner 
            @get_token = scanner
            @token = @get_token.call
            ast, msg = self.Exp

            if ast 
                t, msg = le("EOF")

                if t 
                    return ast
                else 
                    return nil, msg
                end
            else 
                return nil, msg
            end
        else
            return nil, msg
        end
    end

    def le (t)
        if @token.get_tipo == t
            tk = @token
            @token = @get_token.call
            return tk
        else 
            return nil, "Expressao invalida: li '%s', mas esperava '%s'" % [@token.get_tipo, t]
        end
    end

    #Exp ::= Termo { (+|-) Termo } 
    def Exp
        exp1, msg = self.Termo
        if exp1 then
            if @token.get_tipo == "+" or @token.get_tipo == "-"
                if @token.get_tipo == "+" then
                    
                    op, msg= le("+")
                    if op then
                        exp2, msg = self.Termo
                        if exp2 then
                            return Hash["tag" => "add", "1" => exp1, "2" => exp2]
                        else
                            return nil, msg
                        end
                    else
                        return nil, msg
                    end
                else 
                    op, msg= le("-")
                    if op then
                        exp2, msg = self.Termo
                        if exp2 then
                            return Hash["tag" => "sub", "1" => exp1, "2" => exp2]
                        else
                            return nil, msg
                        end
                    else
                        return nil, msg
                    end
                end
            else
                return exp1
            end
        else
            return nil, msg
        end
    end

    #Termo ::= Fator { (*|/) Fator } OK
    def Termo
        exp1, msg = self.Fator
        if exp1 then
            while @token.get_tipo == "*" or @token.get_tipo == "/"
                if @token.get_tipo == "*" then
                    op, msg = le("*")
                    if op then
                        exp2, msg = self.Fator
                        if exp2 then
                            return Hash["tag" => "mul", "1" => exp1, "2" => exp2]
                        else
                            return nil, msg
                        end
                    else
                        return nil, msg
                    end
                else 
                    op, msg = le("/")
                    if op then
                        exp2, msg = self.Fator
                        if exp2 then
                            return Hash["tag" => "div", "1" => exp1, "2" => exp2]
                        else
                            return nil, msg
                        end
                    else
                        return nil, msg
                    end
                end            
            end
        return exp1
        else
            return nil, msg
        end
    end

    #Fator ::= - Fator | Pot OK
    def Fator
        if @token.get_tipo == "-" then
            op, msg = le("-")
            if op
                exp2, msg = self.Fator
                if exp2 
                    return Hash["tag" => "sub", "1" => Hash["tag" => "num", "1" => 0.0], "2" => exp2]
                else 
                    return nil, msg
                end
            else 
                return nil, msg
            end
        else
            pot, msg = self.Pot
            if pot
                return pot
            else
                return nil, msg
            end 
        end
    end

    #Pot ::= Primario ^ Pot | Primario OK
    def Pot
        exp1, msg = self.Primario
        if exp1 then
            if @token.get_tipo == "^" then
                op, msg = le("^")
                if op
                    exp2, msg = self.Pot
                    if exp2 then
                        return Hash["tag" => "pot", "1" => exp1, "2" => exp2]
                    else
                        return nil, msg
                    end
                else
                    return nil, msg
                end 
            end
            return exp1
        end 
        return nil, msg 
    end

    #Primario ::= ( Exp ) | Num
    def Primario
        if @token.get_tipo == "num" then
            t, msg = le("num")
            if t
                return Hash["tag" => "num", "1" => t.get_lexama.to_f]
            else
                return nil, msg
            end
        elsif @token.get_tipo == "(" then
            t, msg = le("(")
            if t then
                exp1, msg = self.Exp
                if exp1 then
                    t, msg = le(")")
                    if t then
                        return exp1
                    else
                        return nil, msg 
                    end
                else
                    return nil, msg 
                end
            else
                return nil, msg 
            end 
        end

        return nil, "Token inesperado, esperava num ou (, encontrou #{@token.get_tipo}"
    end
end