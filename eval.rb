# RUBY VERSION 2.4.1 

require_relative 'parser'

def eval (exp)
    if exp["tag"] == "num"
        return exp["1"]
    elsif exp["tag"] == "neg" then        
        return -eval(exp["1"])
    end

    left = eval(exp["1"])
    right = eval(exp["2"])

    if exp["tag"] == "add" then        
        t = left + right 
        open = "+"
    elsif exp["tag"] == "sub" then
        t = left - right
        open = "-"
    elsif exp["tag"] == "mul" then
        t = left * right
        open = "*"
    elsif exp["tag"] == "div" then
        t = left / right
        open = "/"
    elsif exp["tag"] == "pot" then
        t = left ** right
        open = "^"
    end

    print("#{left} #{open} #{right} = #{t}\n")
    $first = false
    return t
end

if ARGV.length != 1
  abort("Uso: eval.rb <exp>")
end

input = ARGV[0]
input = input.delete(' ').delete('\n').delete('\t')

parser = Parser.new{}
ast, msg = parser.parse(input)

if ast then
    v = eval(ast)

    print("\nResultado: ")
    print(v)
    print("\n")
else
    abort(msg)
end
