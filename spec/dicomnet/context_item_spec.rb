# encoding: UTF-8

require 'spec_helper'

module DICOMNET

  describe ContextItem do

    before(:all) do
      @bin = "\x23\x00\x00\x06\x11\x12\x13\x14\x15\x16"
    end

    describe '::read' do

      context "parses a context item binary string and" do

        before(:all) do
          @ct = ContextItem.read(@bin)
        end

        it "returns a ContextItem instance" do
          expect(@ct).to be_a(ContextItem)
        end

        it "sets the 'type' instance variable" do
          expect(@ct.type).to eql "\x23"
        end

        it "sets the 'len' instance variable" do
          expect(@ct.len).to eql 6
        end

        it "sets the 'data' instance variable" do
          expect(@ct.data).to eq("\x11\x12\x13\x14\x15\x16")
        end

        it "sets the 'reserved1' instance variable" do
          expect(@ct.reserved1).to eql "\x00"
        end

      end

    end


    describe '::new' do

      before(:all) do
        @ct = ContextItem.new
      end

      it "creates a new ContextItem instance" do
        expect(@ct).to be_a(ContextItem)
      end

      it "by default sets the type attribute to zero hex" do
        expect(@ct.type).to eql "\x00"
      end

      it "by default sets the len attribute to 0" do
        expect(@ct.len).to eql 0
      end

      it "by default sets the data attribute to ''" do
        expect(@ct.data).to eq('')
      end

      it "by default sets the reserved1 attribute to a zero hex" do
        expect(@ct.reserved1).to eql "\x00"
      end

    end


    describe '#type=' do

      it "sets the type (and maintains a fixed length)" do
        ct = ContextItem.new
        ct.type = "\x33\x99"
        expect(ct.type).to eql "\x33"
      end

    end


    describe '#len' do

      it "is synchronized with the 'data' attribute" do
        ct = ContextItem.new(:type => "\x41")
        ct.data = "\x21\x22"
        expect(ct.len).to eql 2
      end

    end


    describe '#len=' do

      it "is not able to change its value (to something other than the length of the val attribute)" do
        ct = ContextItem.new(:type => "\x52")
        ct.data = '1.2.34'
        ct.len = 5
        expect(ct.len).to eql 6
      end

    end


    describe '#data=' do

      it "changes its value" do
        ct = ContextItem.new(:type => "\x52")
        ct.data = '1.2.34'
        expect(ct.data).to eq('1.2.34')
      end

    end


    describe '#reserved1=' do

      it "changes its value (and maintains a fixed length)" do
        ct = ContextItem.new
        ct.reserved1 = "\x01\x99"
        expect(ct.reserved1).to eql "\x01"
      end

    end


    describe '#to_binary_s' do

      it "reproduces the original binary string" do
        ct = ContextItem.read(@bin)
        output = ct.to_binary_s
        expect(output).to eql @bin
      end

      it "uses the modified attributes along with the defaults" do
        ct = ContextItem.new(:type => "\x25", :data => '1.2.34')
        output = ct.to_binary_s
        expect(output).to eql "\x25\x00\x00\x06\x31\x2e\x32\x2e\x33\x34"
      end

    end


    describe '#write' do

      it "encodes the object to file (reproducing the original binary string)" do
        ct = ContextItem.read(@bin)
        f = File.join(TMPDIR, 'context_item.bin')
        File.open(f, 'wb') do |io|
          ct.write(io)
        end
        output = File.open(f, 'rb').read
        expect(output).to eq(@bin)
      end

    end

  end

end