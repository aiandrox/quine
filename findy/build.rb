# frozen_string_literal: true

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
  0000000000111111111111111111000111110000000000000011111100000000000000000000111111100000011111110000000011111110000000000001111111000111111000000000111111100000000000
  0000000000000001111111110000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001111111000000000000
  0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111110000000000000
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
end_text_start_point = last_point + end_text.length
output_text_length = "\e[0m#\e[m".length

bits = aa.gsub("\n", '').reverse.to_i(2)

bin = [Marshal.dump(bits)].pack('m').gsub("\n", '')
colors_text = colors.to_s.gsub(' ', '').gsub("\n", '')

code = <<CODE
  c=eval("#{colors_text}").flat_map(&:to_a)
  n=Marshal.load("#{bin}".unpack("m")[0])
  l=#{"'".ord}.chr
  m=#{"\e".ord}.chr
  e="#{start_text}"+l+($s*2)
  o=""
  j=-1

  0.upto(#{y_length * x_length - 1}){|i|
    t=(c.include?(i)?34:#{blank_color})
    o<<(n[i]==1?m+"["+t.to_s+"m"+e[j+=1]+m+"[m":#{' '.ord})
    o<<(i%#{x_length}==#{x_length - 1}?#{"\n".ord}:"")
  }
  o[-#{end_text_start_point + end_text.length * output_text_length},#{(end_text.length + 1) * output_text_length}]=l+"#{end_text}"
  puts(o)
CODE

code = code.split("\n").join(';').gsub(' ', '')
code << '#'

file = File.new('quine_base.rb', 'w')
file.puts "#{start_text}'#{code}'#{end_text}"
