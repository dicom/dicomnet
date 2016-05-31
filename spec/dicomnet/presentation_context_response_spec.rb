# encoding: UTF-8

require 'spec_helper'

module DICOMNET

  describe PresentationContextResponse do

    before(:all) do
      @ts1 = TransferSyntax.new(:name => '1.2.840.10008.1.2') # Implicit Little
      @ts2 = TransferSyntax.new(:name => '1.2.840.10008.1.2.1') # Explicit Little
      @item_type = "\x21"
      # PC response (ID: 3, result: accept, ts: explicit little):
      @bin = File.open(PC_RP, 'rb').read
      # PC with invalid item type:
      @bin_with_invalid_pc_type = @bin.dup
      @bin_with_invalid_pc_type[0] = "\x13"
    end

    describe '::read' do

      it "raises an error when encountering an unexpected item type" do
        expect {PresentationContextResponse.read(@bin_with_invalid_pc_type)}.to raise_error(BinData::ValidityError)
      end

      context "parses a presentation context binary string and" do

        before(:all) do
          @pc = PresentationContextResponse.read(@bin)
        end

        it "returns an PresentationContextResponse instance" do
          expect(@pc).to be_a(PresentationContextResponse)
        end

        it "sets the 'type' instance variable" do
          expect(@pc.type).to eql @item_type
        end

        it "sets the 'len' instance variable" do
          expect(@pc.len).to eql @bin.length - 4
        end

        it "sets the 'id' instance variable" do
          expect(@pc.id).to eql 3
        end

        it "sets the 'result' instance variable" do
          expect(@pc.result).to eql 0
        end

        it "sets the 'reserved1' instance variable" do
          expect(@pc.reserved1).to eql "\x00"
        end

        it "sets the 'reserved2' instance variable" do
          expect(@pc.reserved2).to eql "\x00"
        end

        it "sets the 'reserved3' instance variable" do
          expect(@pc.reserved3).to eql "\x00"
        end

        it "sets the 'transfer_syntax' instance variable" do
          expect(@pc.transfer_syntax).to eq(@ts2)
        end

      end

    end


    describe '::new' do

      before(:all) do
        @pc = PresentationContextResponse.new
      end

      it "creates a new PresentationContextResponse instance" do
        expect(@pc).to be_a(PresentationContextResponse)
      end

      it "by default sets the type attribute to 21H" do
        expect(@pc.type).to eql @item_type
      end

      it "by default sets the len attribute to num_bytes-4" do
        expect(@pc.len).to eql @pc.num_bytes - 4
      end

      it "by default sets the id attribute to 1" do
        expect(@pc.id).to eql 1
      end

      it "by default sets the result attribute to 0" do
        expect(@pc.result).to eql 0
      end

      it "by default sets the reserved1 attribute to a zero hex" do
        expect(@pc.reserved1).to eql "\x00"
      end

      it "by default sets the reserved2 attribute to a zero hex" do
        expect(@pc.reserved2).to eql "\x00"
      end

      it "by default sets the reserved3 attribute to a zero hex" do
        expect(@pc.reserved3).to eql "\x00"
      end

    end


    describe '#transfer_syntax=' do

      it "changes its value" do
        pc = PresentationContextResponse.new
        pc.transfer_syntax = @ts2
        expect(pc.transfer_syntax).to eq(@ts2)
      end

    end


    describe '#id=' do

      it "changes its value" do
        pc = PresentationContextResponse.new
        pc.id = 3
        expect(pc.id).to eql 3
      end

    end


    describe '#type=' do

      it "it raises an error if the type is attempted set with an invalid value" do
        pc = PresentationContextResponse.new
        expect {pc.type = "\x04"}.to raise_error(BinData::ValidityError)
      end

      it "it accepts that the type is set with the valid value" do
        pc = PresentationContextResponse.new
        pc.type = @item_type
        expect(pc.type).to eql @item_type
      end

    end


    describe '#len' do

      it "is synchronized with any changing attributes" do
        pc = PresentationContextResponse.new
        initial_length = pc.len.dup
        pc.transfer_syntax = @ts1
        expect(pc.len).to be > initial_length
        expect(pc.len).to eql pc.num_bytes - 4
      end

    end


    describe '#len=' do

      it "is not able to change its value (to something other than the length of the remaining structure)" do
        pc = PresentationContextResponse.new
        pc.len = 5
        expect(pc.len).not_to eql 5
      end

    end


    describe '#reserved1=' do

      it "changes its value (and maintains a fixed length)" do
        pc = PresentationContextResponse.new
        pc.reserved1 = "\x01\x99"
        expect(pc.reserved1).to eql "\x01"
      end

    end


    describe '#reserved2=' do

      it "changes its value (and maintains a fixed length)" do
        pc = PresentationContextResponse.new
        pc.reserved2 = ""
        expect(pc.reserved2).to eql "\x00"
      end

    end


    describe '#reserved3=' do

      it "changes its value (and maintains a fixed length)" do
        pc = PresentationContextResponse.new
        pc.reserved3 = "\x03\x99"
        expect(pc.reserved3).to eql "\x03"
      end

    end


    describe '#to_binary_s' do

      it "reproduces the original binary string" do
        pc = PresentationContextResponse.read(@bin)
        output = pc.to_binary_s
        expect(output).to eql @bin
      end

      it "uses the modified attributes along with the defaults to produce a valid string" do
        pc = PresentationContextResponse.new
        pc.id = 3
        pc.transfer_syntax = @ts2
        output = pc.to_binary_s
        expect(output).to eql @bin
      end

    end


    describe '#write' do

      it "encodes the object to file (reproducing the original binary string)" do
        pc = PresentationContextResponse.read(@bin)
        f = File.join(TMPDIR, 'presentation_context_response.bin')
        File.open(f, 'wb') do |io|
          pc.write(io)
        end
        output = File.open(f, 'rb').read
        expect(output).to eql @bin
      end

    end

  end

end