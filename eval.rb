require_relative 'parser'
parser = Parser.new{}

def eval (exp)
    if exp.tag == "num" then
        return exp["1"]
    elsif exp.tag == "add" then
        return eval(exp["1"]) + eval(exp["2"])
    elsif exp.tag == "sub" then
        return eval(exp["1"]) - eval(exp["2"])
    elsif exp.tag == "mul" then
        return eval(exp["1"]) * eval(exp["2"])
    elsif exp.tag == "div" then
        return eval(exp["1"]) / eval(exp["2"])
    end
end

if ARGV.length != 1
  abort("Uso: eval.rb <exp>")
end

input = ARGV[0]
ast, msg = parser.parse(input)

if ast then
  print(eval(ast))
else
  abort(msg)
end
