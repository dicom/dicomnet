# encoding: UTF-8

require 'spec_helper'

module DICOMNET

  describe AbstractSyntax do

    before(:all) do
      @item_type = "\x30"
      @bin = File.open(ASX, 'rb').read
      @bin_with_invalid_type = @bin.dup
      @bin_with_invalid_type[0] = "\x12"
    end

    describe '::read' do

      it "raises an error when encountering an unexpected item type" do
        expect {AbstractSyntax.read(@bin_with_invalid_type)}.to raise_error(BinData::ValidityError)
      end

      context "parses an abstract syntax binary string" do

        before(:all) do
          @as = AbstractSyntax.read(@bin)
        end

        it "and returns an AbstractSyntax instance" do
          expect(@as).to be_a(AbstractSyntax)
        end

        it "and sets the 'type' instance variable" do
          expect(@as.type).to eql @item_type
        end

        it "and sets the 'len' instance variable" do
          expect(@as.len).to eql 25
        end

        it "and sets the 'name' instance variable" do
          expect(@as.name).to eql '1.2.840.10008.5.1.4.1.1.4'
        end

        it "and sets the 'reserved1' instance variable" do
          expect(@as.reserved1).to eql "\x00"
        end

      end

    end


    describe '::new' do

      before(:all) do
        @as = AbstractSyntax.new
      end

      it "creates a new AbstractSyntax instance" do
        expect(@as).to be_a(AbstractSyntax)
      end

      it "by default sets the type attribute to 30H" do
        expect(@as.type).to eql @item_type
      end

      it "by default sets the len attribute to 0" do
        expect(@as.len).to eql 0
      end

      it "by default sets the name attribute to ''" do
        expect(@as.name).to eql ''
      end

      it "by default sets the reserved1 attribute to a zero hex" do
        expect(@as.reserved1).to eql "\x00"
      end

    end


    describe '#type=' do

      it "it raises an error if the type is attempted set with an invalid value" do
        as = AbstractSyntax.new
        expect {as.type = "\x05"}.to raise_error(BinData::ValidityError)
      end

      it "it ascepts that the type is set with the valid value" do
        as = AbstractSyntax.new
        as.type = @item_type
        expect(as.type).to eql @item_type
      end

    end


    describe '#len' do

      it "is synchronized with the name attribute" do
        as = AbstractSyntax.new
        as.name = '1.2.34'
        expect(as.len).to eql 6
      end

    end


    describe '#len=' do

      it "is not able to change its value (to something other than the length of the name attribute)" do
        as = AbstractSyntax.new
        as.name = '1.2.34'
        as.len = 5
        expect(as.len).to eql 6
      end

    end


    describe '#name=' do

      it "changes its value" do
        as = AbstractSyntax.new
        as.name = '1.2.34'
        expect(as.name).to eql '1.2.34'
      end

    end


    describe '#reserved1=' do

      it "changes its value (and maintains a fixed length)" do
        as = AbstractSyntax.new
        as.reserved1 = "\x01\x99"
        expect(as.reserved1).to eql "\x01"
      end

    end


    describe '#to_binary_s' do

      it "reproduces the original binary string" do
        as = AbstractSyntax.read(@bin)
        output = as.to_binary_s
        expect(output).to eql @bin
      end

      it "uses the modified attributes along with the defaults" do
        as = AbstractSyntax.new
        as.name = '1.2.34'
        output = as.to_binary_s
        expect(output).to eql "\x30\x00\x00\x06\x31\x2e\x32\x2e\x33\x34"
      end

    end


    describe '#write' do

      it "encodes the object to file (reproducing the original binary string)" do
        as = AbstractSyntax.read(@bin)
        f = File.join(TMPDIR, 'abstract_syntax.bin')
        File.open(f, 'wb') do |io|
          as.write(io)
        end
        output = File.open(f, 'rb').read
        expect(output).to eql @bin
      end

    end

  end

end