aa = <<~END
  0000000000000111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
  0000000001111111111111111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
  0000000111111111111111111111111100000000000000000011111111111111111111100000111111100000000000000000000000000000000000000000000000001111111000000000000000000000000000
  0000011111111110000000001111111110000000000000000011111111111111111111100000111111100000000000000000000000000000000000000000000000001111111000000000000000000000000000
  0000111111110000000000000001111111100000000000000011111111111111111111100000111111100000000000000000000000000000000000000000000000001111111000000000000000000000000000
  0001111111000000000000000000011111110000000000000011111100000000000000000000000000000000000000000000000000000000000000000000000000001111111000000000000000000000000000
  0011111110001111100000000000001111110000000000000011111100000000000000000000111111100000011111011111111111110000000000001111111111111111111000111111100000000011111110
  0011111101111111000000000000000111111000000000000011111100000000000000000000111111100000011111111111111111111100000000111111111111111111111000011111110000000111111100
  0111111111111111000000000000000111111000000000000011111100000000000000000000111111100000011111111111111111111110000001111111111111111111111000001111111000001111111000
  0111111111111100000000000000000111111000000000000011111111111111111110000000111111100000011111111000000111111110000011111111000000111111111000001111111100011111110000
  0111111111100000000000000000000111111000000000000011111111111111111110000000111111100000011111110000000011111110000011111110000000011111111000000111111110111111100000
  0011111111000000000000000000001111111000000000000011111111111111111110000000111111100000011111110000000011111110000011111100000000001111111000000011111111111111000000
  0011111110000000000000000000001111110000000000000011111100000000000000000000111111100000011111110000000011111110000011111100000000001111111000000001111111111110000000
  0001111111000000000000000000111111100000000000000011111100000000000000000000111111100000011111110000000011111110000011111110000000011111111000000000111111111110000000
  0000111111111000000000000011111111000000000000000011111100000000000000000000111111100000011111110000000011111110000011111111100000111111111000000000011111111100000000
  0000011111111111100001111111111111100000000000000011111100000000000000000000111111100000011111110000000011111110000001111111111111111111111000000000011111111000000000
  0000000111111111111111111111111111111000000000000011111100000000000000000000111111100000011111110000000011111110000000011111111111111111111000000000111111110000000000
  0000000000111111111111111111000111110000000000000011111110000000000000000000011111110000001111111000000001111111000000000000111111100011111100000000011111110000000000
  0000000000000001111111110000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111000000000000
  0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111110000000000000
  1111111111111111111111111111111111111111111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
END

colors = [
  13..356,
  500..520,
  660..680,
  830..850,
  995..1020,
  1162..1180,
  1328..1345,
  1495..1510,
  1660..1675,
  1825..1840,
  1990..2005,
  2155..2170,
  2320..2336,
  2490..2506,
  2655..2669
]

blank_color = 0

start_text = 'eval$s=%w'
end_text = '.join'

aa_data = aa.split("\n")
x_length = aa_data.first.length
y_length = aa_data.length
last_point = aa_data.last.split('1').last.length # 最終行に1がないパターンは考慮しない

bits = aa.gsub("\n", '').reverse.to_i(2)

bin = [Marshal.dump(bits)].pack('m').gsub("\n", '')
colors_bin = [Marshal.dump(colors)].pack('m').gsub("\n", '')

code = <<CODE
  a=proc{|b|Marshal.load(b.unpack("m")[0])}
  n=a.call("#{bin}")
  c=a.call("#{colors_bin}").flat_map(&:to_a)
  e="#{start_text}"+#{"'".ord}.chr+($s*3)
  o=""
  j=-1

  0.upto(#{y_length * x_length - 1}){|i|
    t=(c.include?(i)?34:#{blank_color})
    o<<#{"\e".ord}.chr+"["+t.to_s+"m"
    o<<(n[i]==1?e[j+=1]:#{' '.ord})
    o<<(i%#{x_length}==#{x_length - 1}?#{"\n".ord}:"")
    o<<#{"\e".ord}.chr+"[0m"
  }
  o[-#{last_point + end_text.length + 1},20]=""+#{"'".ord}.chr+"#{end_text}"
  puts(o)
CODE

code = code.split("\n").join(';').gsub(' ', '')
code << '#'

file = File.new('quine_base.rb', 'w')
file.puts "#{start_text}'#{code}'#{end_text}"
