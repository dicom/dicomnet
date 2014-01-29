# encoding: UTF-8

require 'spec_helper'

module DICOMNET

  describe PresentationContext do

    before(:all) do
      @as1 = AbstractSyntax.new(:name => '1.2.840.10008.5.1.4.1.1.2') # CT
      @as2 = AbstractSyntax.new(:name => '1.2.840.10008.5.1.4.1.1.4') # MR
      @ts1 = TransferSyntax.new(:name => '1.2.840.10008.1.2') # Implicit Little
      @ts2 = TransferSyntax.new(:name => '1.2.840.10008.1.2.1') # Explicit Little
      @item_type = "\x20"
      # PC with one abstract syntax (MR) and one transfer syntax (Implicit little):
      @bin = "\x20\x00\x00\x36\x01\x00\x00\x00\x30\x00\x00\x19\x31\x2e\x32\x2e\x38\x34\x30\x2e\x31\x30\x30\x30\x38\x2e\x35\x2e\x31\x2e\x34\x2e\x31\x2e\x31\x2e\x34\x40\x00\x00\x11\x31\x2e\x32\x2e\x38\x34\x30\x2e\x31\x30\x30\x30\x38\x2e\x31\x2e\x32"
      @bin_with_invalid_pc_type = "\x33\x00\x00\x36\x01\x00\x00\x00\x30\x00\x00\x19\x31\x2e\x32\x2e\x38\x34\x30\x2e\x31\x30\x30\x30\x38\x2e\x35\x2e\x31\x2e\x34\x2e\x31\x2e\x31\x2e\x34\x40\x00\x00\x11\x31\x2e\x32\x2e\x38\x34\x30\x2e\x31\x30\x30\x30\x38\x2e\x31\x2e\x32"
    end

    describe '::read' do

      it "raises an error when encountering an unexpected item type" do
        expect {PresentationContext.read(@bin_with_invalid_pc_type)}.to raise_error
      end

      context "parses a presentation context binary string and" do

        before(:all) do
          @pc = PresentationContext.read(@bin)
        end

        it "returns an PresentationContext instance" do
          expect(@pc).to be_a(PresentationContext)
        end

        it "sets the 'type' instance variable" do
          expect(@pc.type).to eql @item_type
        end

        it "sets the 'len' instance variable" do
          expect(@pc.len).to eql @bin.length - 4
        end

        it "sets the 'id' instance variable" do
          expect(@pc.id).to eql 1
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

        it "sets the 'reserved4' instance variable" do
          expect(@pc.reserved4).to eql "\x00"
        end

        it "sets the 'abstract_syntax' instance variable" do
          expect(@pc.abstract_syntax).to eq(@as2)
        end

        it "sets the 'transfer_syntaxes' instance variable array" do
          expect(@pc.transfer_syntaxes).to eq([@ts1])
        end

      end

      context "parses a presentation context binary string containing multiple transfer syntax items and" do

        before(:all) do
          # PC string with id=5, as = MR image storage and ts = (Implicit little endian + Explicit little endian):
          @bin2 = "\x20\x00\x00\x4d\x05\x00\x00\x00\x30\x00\x00\x19\x31\x2e\x32\x2e\x38\x34\x30\x2e\x31\x30\x30\x30\x38\x2e\x35\x2e\x31\x2e\x34\x2e\x31\x2e\x31\x2e\x34\x40\x00\x00\x11\x31\x2e\x32\x2e\x38\x34\x30\x2e\x31\x30\x30\x30\x38\x2e\x31\x2e\x32\x40\x00\x00\x13\x31\x2e\x32\x2e\x38\x34\x30\x2e\x31\x30\x30\x30\x38\x2e\x31\x2e\x32\x2e\x31"
          @pc2 = PresentationContext.read(@bin2)
        end

        it "sets the 'len' instance variable" do
          expect(@pc2.len).to eql @bin2.length - 4
        end

        it "sets the 'abstract_syntax' instance variable" do
          expect(@pc2.abstract_syntax).to eq(@as2)
        end

        it "sets the 'transfer_syntaxes' instance variable array" do
          expect(@pc2.transfer_syntaxes).to eq([@ts1, @ts2])
        end

      end

      context "parses a presentation context binary string containing two presentation contexts, extracts the first pc and" do

        before(:all) do

          # Double PC string with as = MR image storage and ts = (Implicit little endian (first) and Explicit little endian (second)):
          @bin3 = @bin + "\x20\x00\x00\x38\x03\x00\x00\x00\x30\x00\x00\x19\x31\x2e\x32\x2e\x38\x34\x30\x2e\x31\x30\x30\x30\x38\x2e\x35\x2e\x31\x2e\x34\x2e\x31\x2e\x31\x2e\x34\x40\x00\x00\x13\x31\x2e\x32\x2e\x38\x34\x30\x2e\x31\x30\x30\x30\x38\x2e\x31\x2e\x32\x2e\x31"
          @pc3 = PresentationContext.read(@bin3)
        end

        it "sets the 'len' instance variable" do
          expect(@pc3.len).to eql @bin.length - 4
        end

        it "sets the 'abstract_syntax' instance variable" do
          expect(@pc3.abstract_syntax).to eq(@as2)
        end

        it "sets the 'transfer_syntaxes' instance variable array" do
          expect(@pc3.transfer_syntaxes).to eq([@ts1])
        end

      end

    end


    describe '::new' do

      before(:all) do
        @pc = PresentationContext.new
      end

      it "creates a new PresentationContext instance" do
        expect(@pc).to be_a(PresentationContext)
      end

      it "by default sets the type attribute to 20H" do
        expect(@pc.type).to eql @item_type
      end

      it "by default sets the len attribute to num_bytes-4" do
        expect(@pc.len).to eql @pc.num_bytes - 4
      end

      it "by default sets the id attribute to 1" do
        expect(@pc.id).to eql 1
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

      it "by default sets the reserved4 attribute to a zero hex" do
        expect(@pc.reserved4).to eql "\x00"
      end

    end


    describe '#id=' do

      it "changes its value" do
        pc = PresentationContext.new
        pc.id = 3
        expect(pc.id).to eql 3
      end

    end


    describe '#transfer_syntax=' do

      it "raises an error if the argument is not a TransferSyntax" do
        pc = PresentationContext.new
        expect {pc.transfer_syntax = @as1}.to raise_error
      end

      it "fills transfer_syntaxes array of this empty presentation context instance with the argument instance" do
        pc = PresentationContext.new
        pc.transfer_syntax = @ts1
        expect(pc.transfer_syntaxes).to eq([@ts1])
      end

      it "resets the multi-element transfer_syntaxes array of this presentation context instance with the argument instance" do
        pc = PresentationContext.new
        pc.transfer_syntaxes.assign([@ts1, @ts2])
        pc.transfer_syntax = @ts2
        expect(pc.transfer_syntaxes).to eq([@ts2])
      end

    end


    describe '#type=' do

      it "it raises an error if the type is attempted set with an invalid value" do
        pc = PresentationContext.new
        expect {pc.type = "\x04"}.to raise_error
      end

      it "it accepts that the type is set with the valid value" do
        pc = PresentationContext.new
        pc.type = @item_type
        expect(pc.type).to eql @item_type
      end

    end


    describe '#len' do

      it "is synchronized with any changing attributes" do
        pc = PresentationContext.new
        initial_length = pc.len.dup
        pc.abstract_syntax = @as1
        expect(pc.len).to be > initial_length
        expect(pc.len).to eql pc.num_bytes - 4
      end

    end


    describe '#len=' do

      it "is not able to change its value (to something other than the length of the remaining structure)" do
        pc = PresentationContext.new
        pc.len = 5
        expect(pc.len).not_to eql 5
      end

    end


    describe '#to_binary_s' do

      it "reproduces the original binary string" do
        pc = PresentationContext.read(@bin)
        output = pc.to_binary_s
        expect(output).to eql @bin
      end

      it "uses the modified attributes along with the defaults to produce a valid string (in this single transfer syntax case)" do
        # PC string with id=3, as = MR image storage and ts = Explicit little endian:
        bin = "\x20\x00\x00\x38\x03\x00\x00\x00\x30\x00\x00\x19\x31\x2e\x32\x2e\x38\x34\x30\x2e\x31\x30\x30\x30\x38\x2e\x35\x2e\x31\x2e\x34\x2e\x31\x2e\x31\x2e\x34\x40\x00\x00\x13\x31\x2e\x32\x2e\x38\x34\x30\x2e\x31\x30\x30\x30\x38\x2e\x31\x2e\x32\x2e\x31"
        pc = PresentationContext.new
        pc.id = 3
        pc.abstract_syntax = @as2
        pc.transfer_syntax = @ts2
        output = pc.to_binary_s
        expect(output).to eql bin
      end

      it "uses the modified attributes along with the defaults to produce a valid string (in this multiple transfer syntax case)" do
        # PC string with id=5, as = MR image storage and ts = (Implicit little endian + Explicit little endian):
        bin = "\x20\x00\x00\x4d\x05\x00\x00\x00\x30\x00\x00\x19\x31\x2e\x32\x2e\x38\x34\x30\x2e\x31\x30\x30\x30\x38\x2e\x35\x2e\x31\x2e\x34\x2e\x31\x2e\x31\x2e\x34\x40\x00\x00\x11\x31\x2e\x32\x2e\x38\x34\x30\x2e\x31\x30\x30\x30\x38\x2e\x31\x2e\x32\x40\x00\x00\x13\x31\x2e\x32\x2e\x38\x34\x30\x2e\x31\x30\x30\x30\x38\x2e\x31\x2e\x32\x2e\x31"
        pc = PresentationContext.new
        pc.id = 5
        pc.abstract_syntax = @as2
        pc.transfer_syntaxes = [@ts1, @ts2]
        output = pc.to_binary_s
        expect(output).to eql bin
      end

    end


    describe '#write' do

      it "encodes the object to file (reproducing the original binary string)" do
        pc = PresentationContext.read(@bin)
        f = File.join(TMPDIR, 'presentation_context.bin')
        File.open(f, 'wb') do |io|
          pc.write(io)
        end
        output = File.open(f, 'rb').read
        expect(output).to eql @bin
      end

    end

  end

end