# encoding: UTF-8

require 'spec_helper'

module DICOMNET

  describe TransferSyntax do

    before(:all) do
      @item_type = "\x40"
      @bin = File.open(TSX, 'rb').read
      @bin_with_invalid_type = @bin.dup
      @bin_with_invalid_type[0] = "\x13"
    end

    describe '::read' do

      it "raises an error when encountering an unexpected item type" do
        expect {TransferSyntax.read(@bin_with_invalid_type)}.to raise_error
      end

      context "parses a transfer syntax binary string and" do

        before(:all) do
          @ts = TransferSyntax.read(@bin)
        end

        it "returns an TransferSyntax instance" do
          expect(@ts).to be_a(TransferSyntax)
        end

        it "sets the 'type' instance variable" do
          expect(@ts.type).to eql @item_type
        end

        it "sets the 'len' instance variable" do
          expect(@ts.len).to eql 17
        end

        it "sets the 'name' instance variable" do
          expect(@ts.name).to eql '1.2.840.10008.1.2'
        end

        it "sets the 'reserved1' instance variable" do
          expect(@ts.reserved1).to eql "\x00"
        end

      end

    end


    describe '::new' do

      before(:all) do
        @ts = TransferSyntax.new
      end

      it "creates a new TransferSyntax instance" do
        expect(@ts).to be_a(TransferSyntax)
      end

      it "by default sets the type attribute to 40H" do
        expect(@ts.type).to eql @item_type
      end

      it "by default sets the len attribute to 0" do
        expect(@ts.len).to eql 0
      end

      it "by default sets the name attribute to ''" do
        expect(@ts.name).to eql ''
      end

      it "by default sets the reserved1 attribute to a zero hex" do
        expect(@ts.reserved1).to eql "\x00"
      end

    end


    describe '#type=' do

      it "it raises an error if the type is attempted set with an invalid value" do
        ts = TransferSyntax.new
        expect {ts.type = "\x02"}.to raise_error
      end

      it "it ascepts that the type is set with the valid value" do
        ts = TransferSyntax.new
        ts.type = @item_type
        expect(ts.type).to eql @item_type
      end

    end


    describe '#len' do

      it "is synchronized with the name attribute" do
        ts = TransferSyntax.new
        ts.name = '1.2.34'
        expect(ts.len).to eql 6
      end

    end


    describe '#len=' do

      it "is not able to change its value (to something other than the length of the name attribute)" do
        ts = TransferSyntax.new
        ts.name = '1.2.34'
        ts.len = 5
        expect(ts.len).to eql 6
      end

    end


    describe '#name=' do

      it "changes its value" do
        ts = TransferSyntax.new
        ts.name = '1.2.34'
        expect(ts.name).to eql '1.2.34'
      end

    end


    describe '#reserved1=' do

      it "changes its value (and maintains a fixed length)" do
        ts = TransferSyntax.new
        ts.reserved1 = "\x01\x99"
        expect(ts.reserved1).to eql "\x01"
      end

    end


    describe '#to_binary_s' do

      it "reproduces the original binary string" do
        ts = TransferSyntax.read(@bin)
        output = ts.to_binary_s
        expect(output).to eql @bin
      end

      it "uses the modified attributes along with the defaults" do
        ts = TransferSyntax.new
        ts.name = '1.2.34'
        output = ts.to_binary_s
        expect(output).to eql "\x40\x00\x00\x06\x31\x2e\x32\x2e\x33\x34"
      end

    end


    describe '#write' do

      it "encodes the object to file (reproducing the original binary string)" do
        ts = TransferSyntax.read(@bin)
        f = File.join(TMPDIR, 'transfer_syntax.bin')
        File.open(f, 'wb') do |io|
          ts.write(io)
        end
        output = File.open(f, 'rb').read
        expect(output).to eql @bin
      end

    end

  end

end