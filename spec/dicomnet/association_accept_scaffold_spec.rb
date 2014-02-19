# encoding: UTF-8

require 'spec_helper'

module DICOMNET

  describe AssociationAcceptScaffold do

    before(:all) do
      @item_type = "\x02"
      # AA with one presentation context:
      @bin = File.open(A_AC, 'rb').read
      # AA with two presentation contexts:
      @bin2pc = File.open(A_AC_2PC, 'rb').read
      @bin_with_invalid_type = @bin.dup
      @bin_with_invalid_type[0] = "\x07"
    end

    describe '::read' do

      it "raises an error when encountering an unexpected item type" do
        expect {AssociationAcceptScaffold.read(@bin_with_invalid_type)}.to raise_error
      end

      context "parses an association accept binary string and" do

        before(:all) do
          @ac = AssociationAcceptScaffold.read(@bin)
        end

        it "returns an AssociationAcceptScaffold instance" do
          expect(@ac).to be_a(AssociationAcceptScaffold)
        end

        it "sets the 'type' instance variable" do
          expect(@ac.type).to eql @item_type
        end

        it "sets the 'len' instance variable" do
          expect(@ac.len).to eql @bin.length - 6
        end

        it "sets the 'protocol_version' instance variable" do
          expect(@ac.protocol_version).to eql "\x00\x01"
        end

        it "sets the 'called_ae' instance variable" do
          expect(@ac.called_ae).to eql "KONTOR          "
        end

        it "sets the 'calling_ae' instance variable" do
          expect(@ac.calling_ae).to eql "RUBY_DICOM      "
        end

        it "sets the 'reserved1' instance variable" do
          expect(@ac.reserved1).to eql "\x00"
        end

        it "sets the 'reserved2' instance variable" do
          expect(@ac.reserved2).to eql "\x00\x00"
        end

        it "sets the 'reserved3' instance variable" do
          expect(@ac.reserved3).to eql "\x00" * 32
        end

        it "loads 3 items (AC, PC & UI) in the 'context_items' instance variable array" do
          expect(@ac.context_items.map {|i| i.type}).to eq(["\x10", "\x21", "\x50"])
        end

      end

      context "parses a association accept binary string containing multiple presentation context items and" do

        before(:all) do
          @ac = AssociationAcceptScaffold.read(@bin2pc)
        end

        it "sets the 'len' instance variable" do
          expect(@ac.len).to eql @bin2pc.length - 6
        end

        it "loads 4 items (AC, PC, PC & UI) in the 'context_items' instance variable array" do
          expect(@ac.context_items.collect {|i| i.type}).to eq(["\x10", "\x21", "\x21", "\x50"])
        end

      end

    end


    describe '::new' do

      before(:all) do
        @ac = AssociationAcceptScaffold.new
      end

      it "creates a new AssociationAcceptScaffold instance" do
        expect(@ac).to be_a(AssociationAcceptScaffold)
      end

      it "by default sets the type attribute to 02H" do
        expect(@ac.type).to eql @item_type
      end

      it "by default sets the len attribute to num_bytes-6" do
        expect(@ac.len).to eql @ac.num_bytes - 6
      end

      it "by default sets the protocol_version attribute to '\x00\x01'" do
        expect(@ac.protocol_version).to eql "\x00\x01"
      end

      it "by default sets the called_ae attribute to RUBY_DICOM (properly padded to 16 bytes)" do
        expect(@ac.called_ae).to eql "RUBY_DICOM      "
      end

      it "by default sets the calling_ae attribute to CLIENT (properly padded to 16 bytes)" do
        expect(@ac.calling_ae).to eql "CLIENT          "
      end

      it "by default sets the reserved1 attribute to a zero hex" do
        expect(@ac.reserved1).to eql "\x00"
      end

      it "by default sets the reserved2 attribute to a double zero hex" do
        expect(@ac.reserved2).to eql "\x00\x00"
      end

      it "by default sets the reserved3 attribute to 32 zero hex bytes" do
        expect(@ac.reserved3).to eql "\x00" * 32
      end

    end


    describe '#called_ae=' do

      it "changes its value (and applies proper padding)" do
        ac = AssociationAcceptScaffold.new
        ac.called_ae = "HOST"
        expect(ac.called_ae).to eql "HOST            "
      end

    end


    describe '#calling_ae=' do

      it "changes its value (and applies proper padding)" do
        ac = AssociationAcceptScaffold.new
        ac.calling_ae = "SOMEONE"
        expect(ac.calling_ae).to eql "SOMEONE         "
      end

    end


    describe '#protocol_version=' do

      it "changes its value (and maintains a fixed length)" do
        ac = AssociationAcceptScaffold.new
        ac.protocol_version = "\x00\x02\x99"
        expect(ac.protocol_version).to eql "\x00\x02"
      end

    end


    describe '#type=' do

      it "raises an error if the type is attempted set with an invalid value" do
        ac = AssociationAcceptScaffold.new
        expect {ac.type = "\x09"}.to raise_error
      end

      it "accepts that the type is set with the valid value" do
        ac = AssociationAcceptScaffold.new
        ac.type = @item_type
        expect(ac.type).to eql @item_type
      end

    end


    describe '#reserved1=' do

      it "changes its value (and maintains a fixed length)" do
        ac = AssociationAcceptScaffold.new
        ac.reserved1 = "\x01\x99"
        expect(ac.reserved1).to eql "\x01"
      end

    end


    describe '#reserved2=' do

      it "changes its value (and maintains a fixed length)" do
        ac = AssociationAcceptScaffold.new
        ac.reserved2 = "\x01\x01\x99"
        expect(ac.reserved2).to eql "\x01\x01"
      end

    end


    describe '#reserved3=' do

      it "changes its value (and maintains a fixed length)" do
        ac = AssociationAcceptScaffold.new
        ac.reserved3 = "\x01"
        expect(ac.reserved3).to eql "\x01" + "\x00" * 31
      end

    end


    describe '#context_items=' do

      it "changes its value" do
        context_item = ContextItem.new(:type => "\x06")
        ac = AssociationAcceptScaffold.new
        ac.context_items << context_item
        expect(ac.context_items).to eq([context_item])
      end

    end


    describe '#len' do

      it "is synchronized with any changing attributes" do
        ac = AssociationAcceptScaffold.new
        initial_length = ac.len.dup
        context_item = ContextItem.new(:type => "\x06")
        ac.context_items << context_item
        expect(ac.len).to be > initial_length
        expect(ac.len).to eql ac.num_bytes - 6
      end

    end


    describe '#len=' do

      it "is not able to change its value (to something other than the length of the remaining structure)" do
        ac = AssociationAcceptScaffold.new
        ac.len = 5
        expect(ac.len).not_to eql 5
      end

    end


    describe '#to_binary_s' do

      it "reproduces the original binary string (in this single presentation context case)" do
        ac = AssociationAcceptScaffold.read(@bin)
        output = ac.to_binary_s
        expect(output).to eql @bin
      end

      it "reproduces the original binary string in this multiple presentation context case)" do
        ac = AssociationAcceptScaffold.read(@bin2pc)
        output = ac.to_binary_s
        expect(output).to eql @bin2pc
      end

      it "uses the modified attributes along with the defaults to produce a valid string" do
        ac = AssociationAcceptScaffold.read(@bin)
        bin = @bin.dup
        bin[7] = "\x09"
        ac.protocol_version = "\x00\x09"
        output = ac.to_binary_s
        expect(output).to eql bin
      end

    end


    describe '#write' do

      it "encodes the object to file (reproducing the original binary string)" do
        ac = AssociationAcceptScaffold.read(@bin)
        f = File.join(TMPDIR, 'association_accept_scaffold.bin')
        File.open(f, 'wb') do |io|
          ac.write(io)
        end
        output = File.open(f, 'rb').read
        expect(output).to eql @bin
      end

    end

  end

end