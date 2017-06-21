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

            ast, msg = exp

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
        if @token.tipo == t
            tk = @token
            @token = @get_token.call
            return tk
        else 
            return nil, "Expressao invalida: li '%s', mas esperava '%s'" % [@token.tipo, t]
        end
    end

    #Exp ::= Termo { (+|-) Termo } 
    def exp
        exp1, msg = termo
        if exp1 then
            while @token.tipo == "+" or @token.tipo == "-"
                if @token.tipo == "+" then
                    op, msg= le("+")
                    if op then
                        exp2, msg = termo
                        if exp2 then
                            exp1 = Hash["tag" => "add", "1" => exp1, "2" => exp2]
                        else
                            return nil, msg
                        end
                    else
                        return nil, msg
                    end
                else 
                    op, msg= le("-")
                    if op then
                        exp2, msg = termo
                        if exp2 then
                            exp1 = Hash["tag" => "sub", "1" => exp1, "2" => exp2]
                        else
                            return nil, msg
                        end
                    else
                        return nil, msg
                    end
                end
            return exp1
            end
        else
            return nil, msg
        end
    end

    #Termo ::= Fator { (*|/) Fator } OK
    def termo
        exp1, msg = fator
        if exp1 then
            while @token.tipo == "*" or @token.tipo == "/"
                if @token.tipo == "*" then
                    op, msg = le("*")
                    if op then
                        exp2, msg = fator
                        if exp2 then
                            exp1 = Hash["tag" => "mul", "1" => exp1, "2" => exp2]
                        else
                            return nil, msg
                        end
                    else
                        return nil, msg
                    end
                else 
                    op, msg = le("/")
                    if op then
                        exp2, msg = fator
                        if exp2 then
                            exp1 = Hash["tag" => "div", "1" => exp1, "2" => exp2]
                        else
                            return nil, msg
                        end
                    else
                        return nil, msg
                    end
                end
            return exp1
            end
        else
            return nil, msg
        end
    end

    #Fator ::= - Fator | Pot OK
    def fator
        if @token.tipo == "-" then
            op, msg = le("-")
            if op
                exp2, msg = fator
                if exp2 
                    return Hash["tag" => "sub", "1" => 0, "2" => exp2]
                else 
                    return nil, msg
                end
            else 
                return nil, msg
            end
        else
            pot, msg = Pot
            if pot
                return pot
            else
                return nil, msg
            end 
        end
    end

    #Pot ::= Primario ^ Pot | Primario OK
    def pot
        exp1, msg = primario
        if exp1 then
            if @token.tipo == "^" then
                op, msg = le("^")
                if op
                    exp2, msg = Pot
                    if exp2 then
                        exp1 = Hash["tag" => "pot", "1" => exp1, "2" => exp2]
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
    def primario
        if @token.tipo == "num" then
            t, msg = le("num")
            if t
                return Hash["tag" => "num", "1" => t.lexema]
            else
                return nil, msg
            end
        elsif @token.tipo == "(" then
            t, msg = le("(")
            if t then
                exp1, msg = exp
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

        return nil, "Token inesperado, esperava num ou (, encontrou %s" % [@token.tipo]
    end
end