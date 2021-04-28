require 'digest'
require 'json'
require 'pp'

class Block

    attr_reader :index
    attr_reader :timestamp
    attr_reader :data
    attr_reader :previous_hash
    attr_reader :nonce
    attr_reader :hash


    def initialize(index, data, previous_hash)
        @index = index
        @timestamp = Time.now
        @data = data
        @previous_hash = previous_hash
        @nonce, @hash = make_hash_with_proof()
    end

    def make_hash_with_proof( difficulty="99")
        nonce = 0
        loop do
            hash = calculate_hash_with_nonce( nonce )
            if hash.start_with?( difficulty )
                return [nonce, hash]
            else
                nonce += 1
            end
        end 
    end

    def calculate_hash_with_nonce( nonce=0 )
        sha = Digest::SHA256.new
        sha.update( nonce.to_s + @index.to_s + @timestamp.to_s + @data + @previous_hash)
        sha.hexdigest
    end

    def self.first( data="Genesis" )
        Block.new(0, data, "0")
    end

    def self.next( previous, data="Transaction data..." )
        Block.new( previous.index+1, data, previous.hash )
    end

end

b0 = Block.first()
b1 = Block.next(b0, "Here is Block 1")
b2 = Block.next(b1, "Here is Block 2")
b3 = Block.next(b2, "Here is Block 3")
b4 = Block.next(b3, "Here is Block 4")
b5 = Block.next(b4, "Here is Block 5")
b6 = Block.next(b5, "Here is Block 6")

blockchain = [b0, b1, b2, b3, b4, b5, b6]

pp blockchain