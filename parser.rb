#Exp ::= Termo { (+|-) Termo } OK
#Termo ::= Fator { (*|/) Fator } OK
#Fator ::= - Fator | Pot OK
#Pot ::= Primario ^ Pot | Primario OK
#Primario ::= ( Exp ) | Num

#import lexer

token = {}

def le ()
#    if token.tipo == t then
#        tk:Token = token
#        token = get_token
#    end
end

def Exp
    exp1 = Termo
    if exp1 then
        while token.tipo == "+" or token.tipo == "-"
            if token.tipo == "+" then
                op = le("+")

                if op then
                    exp2 = Termo
                    if exp2 then
                        exp1 = Hash["tag", "add", "1", exp1, "2", exp2]
                    else
                        puts("Error")
                    end
                else
                    puts("Error")
                end
            else 
                if op then
                    exp2 = termo()
                    if exp2 then
                        exp1 = Hash["tag", "sub", "1", exp1, "2", exp2]
                    else
                        puts("Error")
                    end
                else
                    puts("Error")
                end


            end
        return exp1
    end
    else
        return nil
    end
end

def Termo
    exp1 = Fator
    if exp1 then
        while token.tipo == "*" or token.tipo == "/"
            if token.tipo == "*" then
                op = le("*")
                if op then
                    exp2 = Fator
                    if exp2 then
                        exp1 = Hash["tag", "mul", "1", exp1, "2", exp2]
                    else
                        puts("Error")
                    end
                else
                    puts("Error")
                end
            else 
                if op then
                    exp2 = Fator
                    if exp2 then
                        exp1 = Hash["tag", "div", "1", exp1,"2", exp2]
                    else
                        puts("Error")
                    end
                else
                    puts("Error")
                end


            end
        return exp1
    end
    else
        return nil
    end
end



def Fator
    if token.tipo == "-" then
        op = le("-")
        if op
            return exp1 = Hash["tag", "sub",  "1", 0, "2", Fator]
        end

    else
        exp1 = Pot
        if exp1 then
            return exp1
        end
        
    end
    return nil
end



def Pot
    exp1 = Primario
    if exp1 then
        if token.tipo == "^" then
            op = le("^")
               if op then
                    exp2 = Pot
                    if exp2 then
                       exp1 = Hash["tag", "pot", "1", exp1, "2", exp2]
                    else
                        puts("Error")
                    end
                else
                    puts("Error")
                end 
        end
        return exp1
    end
end


def Primario
    if token.tipo == "num" then
        t = le("Num")
        if t then
            return Hash["tag", "numero", "1", t.lexema]
        else
            return nil
        end
    elsif token.tipo == "(" then
        t = le("(")
        if t then
            exp1 = Exp
            if exp1 then
                t = le(")")
                if t then
                    return exp1
                else
                    return nil
                end
            else
                return nil
            end
        else
            return nil
        end 
    end

end
