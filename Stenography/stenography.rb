def encode 
	inputMessage = File.open("input.txt") { |f| f.read.unpack("B*").first.split(//).map(&:to_i) }

	File.open("input.bmp", 'rb') { |io|
		io.seek 0xA 
		offset = io.read(4).unpack("V")[0]
		out = File.open "output.bmp", 'wb' 
		io.rewind
		out.write io.read(offset)
		io.seek offset

		results = io.each_byte.zip(inputMessage).each_with_object([]) { |(b, m), ary|
			b &= ~1
			b |= m if m
			ary << b
		}
		
		out << results.pack("C*")
	}
end

def decode
	File.open("sample_output.bmp", 'rb') { |io|
		io.seek 0xA
		offset = io.read(4).unpack("V")[0]
		io.seek offset

		results = io.each_byte.each_with_object([]) { |b, ary|
			ary << (b & 1).to_s
		}
		
		#puts results[0].class
		s = ""
		i = 0
		puts results.size
		while i != results.size
			
			c = results[i..i+7].map(&:to_s).join("").to_i(2)
			
			s << c.chr
			break if c == 0
			i += 8
			#results = results[8, -1]
			#results.map(&:to_s).pack "B*"
			
		end
		puts s
	}
end

encode
decode