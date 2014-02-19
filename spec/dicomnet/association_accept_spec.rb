# encoding: UTF-8

require 'spec_helper'

module DICOMNET

  describe AssociationAccept do

    before(:all) do
      @acx = ApplicationContext.new(:name => '1.2.840.10008.3.1.1.1')
      @as = AbstractSyntax.new(:name => '1.2.840.10008.1.1') #Verification
      @ts1 = TransferSyntax.new(:name => '1.2.840.10008.1.2') # Implicit Little
      @ts2 = TransferSyntax.new(:name => '1.2.840.10008.1.2.1') # Explicit Little
      @ts3 = TransferSyntax.new(:name => '1.2.840.10008.1.2.2') # Explicit Big
      @pc = PresentationContextResponse.new(:id => 1, :abstract_syntax => @as, :transfer_syntax => @ts1)
      @ui = UserInformation.read(File.open(USER_INFO, 'rb').read)
      @item_type = "\x02"
      # AA with one presentation context:
      @bin = File.open(A_AC, 'rb').read
      # AA with two presentation contexts:
      @bin2pc = File.open(A_AC_2PC, 'rb').read
      # AA with invalid pdu type:
      @bin_with_invalid_type = @bin.dup
      @bin_with_invalid_type[0] = "\x11"
    end

    describe '::read' do

      it "raises an error when encountering an unexpected item type" do
        expect {AssociationAccept.read(@bin_with_invalid_type)}.to raise_error
      end

      context "parses an association accept binary string and" do

        before(:all) do
          @ac = AssociationAccept.read(@bin)
        end

        it "returns an AssociationAccept instance" do
          expect(@ac).to be_a(AssociationAccept)
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

        it "sets the 'application_context' instance variable" do
          expect(@ac.application_context).to eq(@acx)
        end

        it "sets the 'presentation_context_responses' instance variable array" do
          expect(@ac.presentation_context_responses).to eq([@pc])
        end

        it "sets the 'user_information' instance variable" do
          expect(@ac.user_information).to eq(@ui)
        end

      end

      context "parses an association accept binary string containing multiple presentation context items and" do

        before(:all) do
          @ac = AssociationAccept.read(@bin2pc)
        end

        it "sets the 'len' instance variable" do
          expect(@ac.len).to eql @bin2pc.length - 6
        end

        it "sets the 'application_context' instance variable" do
          expect(@ac.application_context).to eq(@acx)
        end

        it "loads 2 presentation contexts" do
          expect(@ac.presentation_context_responses.length).to eq(2)
        end

        it "sets the 'user_information' instance variable" do
          expect(@ac.user_information).to eq(@ui)
        end

      end

    end

    describe '::new' do

      before(:all) do
        @ac = AssociationAccept.new
      end

      it "creates a new AssociationAccept instance" do
        expect(@ac).to be_a(AssociationAccept)
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
        ac = AssociationAccept.new
        ac.called_ae = "HOST"
        expect(ac.called_ae).to eql "HOST            "
      end

    end


    describe '#calling_ae=' do

      it "changes its value (and applies proper padding)" do
        ac = AssociationAccept.new
        ac.calling_ae = "SOMEONE"
        expect(ac.calling_ae).to eql "SOMEONE         "
      end

    end


    describe '#protocol_version=' do

      it "changes its value (and maintains a fixed length)" do
        ac = AssociationAccept.new
        ac.protocol_version = "\x00\x02\x99"
        expect(ac.protocol_version).to eql "\x00\x02"
      end

    end


    describe '#type=' do

      it "it raises an error if the type is attempted set with an invalid value" do
        ac = AssociationAccept.new
        expect {ac.type = "\x09"}.to raise_error
      end

      it "it accepts that the type is set with the valid value" do
        ac = AssociationAccept.new
        ac.type = @item_type
        expect(ac.type).to eql @item_type
      end

    end


    describe '#reserved1=' do

      it "changes its value (and maintains a fixed length)" do
        ac = AssociationAccept.new
        ac.reserved1 = "\x01\x99"
        expect(ac.reserved1).to eql "\x01"
      end

    end


    describe '#reserved2=' do

      it "changes its value (and maintains a fixed length)" do
        ac = AssociationAccept.new
        ac.reserved2 = "\x01\x01\x99"
        expect(ac.reserved2).to eql "\x01\x01"
      end

    end


    describe '#reserved3=' do

      it "changes its value (and maintains a fixed length)" do
        ac = AssociationAccept.new
        ac.reserved3 = "\x01"
        expect(ac.reserved3).to eql "\x01" + "\x00" * 31
      end

    end


    describe '#application_context=' do

      it "changes its value" do
        ac = AssociationAccept.new
        ac.application_context = @ac
        expect(ac.application_context).to eq(@acx)
      end

    end


    describe '#user_information=' do

      it "changes its value" do
        ac = AssociationAccept.new
        ac.user_information = @ui
        expect(ac.user_information).to eq(@ui)
      end

    end


    describe '#len' do

      it "is synchronized with any changing attributes" do
        ac = AssociationAccept.new
        initial_length = ac.len.dup
        ac.application_context = @acx
        expect(ac.len).to be > initial_length
        expect(ac.len).to eql ac.num_bytes - 6
      end

    end


    describe '#len=' do

      it "is not able to change its value (to something other than the length of the remaining structure)" do
        ac = AssociationAccept.new
        ac.len = 5
        expect(ac.len).not_to eql 5
      end

    end


    describe '#to_binary_s' do

      it "reproduces the original binary string (in this single presentation context case)" do
        ac = AssociationAccept.read(@bin)
        output = ac.to_binary_s
        expect(output).to eql @bin
      end

      it "reproduces the original binary string in this multiple presentation context case)" do
        ac = AssociationAccept.read(@bin2pc)
        output = ac.to_binary_s
        expect(output).to eql @bin2pc
      end

      it "uses the modified attributes along with the defaults to produce a valid string" do
        ac = AssociationAccept.read(@bin)
        bin = @bin.dup
        bin[7] = "\x09"
        ac.protocol_version = "\x00\x09"
        output = ac.to_binary_s
        expect(output).to eql bin
      end

    end


    describe '#write' do

      it "encodes the object to file (reproducing the original binary string)" do
        ac = AssociationAccept.read(@bin)
        f = File.join(TMPDIR, 'association_accept.bin')
        File.open(f, 'wb') do |io|
          ac.write(io)
        end
        output = File.open(f, 'rb').read
        expect(output).to eql @bin
      end

    end

  end

end