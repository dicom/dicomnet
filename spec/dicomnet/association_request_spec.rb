# encoding: UTF-8

require 'spec_helper'

module DICOMNET

  describe AssociationRequest do

    before(:all) do
      @ac = ApplicationContext.new(:name => '1.2.840.10008.3.1.1.1')
      #@as = AbstractSyntax.new(:name => '1.2.840.10008.5.1.4.1.1.4') # MR
      @as = AbstractSyntax.new(:name => '1.2.840.10008.1.1') #Verification
      @ts1 = TransferSyntax.new(:name => '1.2.840.10008.1.2') # Implicit Little
      @ts2 = TransferSyntax.new(:name => '1.2.840.10008.1.2.1') # Explicit Little
      @ts3 = TransferSyntax.new(:name => '1.2.840.10008.1.2.2') # Explicit Big
      @pc = PresentationContext.new(:id => 1, :abstract_syntax => @as, :transfer_syntaxes => [@ts1, @ts2, @ts3])
      @ui = UserInformation.read(File.open(USER_INFO, 'rb').read)
      @item_type = "\x01"
      # AR with one presentation context, containing 3 transfer syntaxes:
      @bin = File.open(A_RQ, 'rb').read
      @bin_with_invalid_ar_type = @bin.dup
      @bin_with_invalid_ar_type[0] = "\x07"
      # AR with two presentation contexts, each containing 2 transfer sytnaxes:
      @bin2pc = File.open(A_RQ_2PC, 'rb').read
    end

    describe '::read' do

      it "raises an error when encountering an unexpected item type" do
        expect {AssociationRequest.read(@bin_with_invalid_ar_type)}.to raise_error
      end

      context "parses an association request binary string and" do

        before(:all) do
          @ar = AssociationRequest.read(@bin)
        end

        it "returns an AssociationRequest instance" do
          expect(@ar).to be_a(AssociationRequest)
        end

        it "sets the 'type' instance variable" do
          expect(@ar.type).to eql @item_type
        end

        it "sets the 'len' instance variable" do
          expect(@ar.len).to eql @bin.length - 6
        end

        it "sets the 'protocol_version' instance variable" do
          expect(@ar.protocol_version).to eql "\x00\x01"
        end

        it "sets the 'called_ae' instance variable" do
          expect(@ar.called_ae).to eql "KONTOR          "
        end

        it "sets the 'calling_ae' instance variable" do
          expect(@ar.calling_ae).to eql "RUBY_DICOM      "
        end

        it "sets the 'reserved1' instance variable" do
          expect(@ar.reserved1).to eql "\x00"
        end

        it "sets the 'reserved2' instance variable" do
          expect(@ar.reserved2).to eql "\x00\x00"
        end

        it "sets the 'reserved3' instance variable" do
          expect(@ar.reserved3).to eql "\x00" * 32
        end

        it "sets the 'application_context' instance variable" do
          expect(@ar.application_context).to eq(@ac)
        end

        it "sets the 'presentation_contexts' instance variable array" do
          expect(@ar.presentation_contexts).to eq([@pc])
        end

        it "sets the 'user_information' instance variable" do
          expect(@ar.user_information).to eq(@ui)
        end

      end

      context "parses an association request binary string containing multiple presentation context items and" do

        before(:all) do
          @ar = AssociationRequest.read(@bin2pc)
        end

        it "sets the 'len' instance variable" do
          expect(@ar.len).to eql @bin2pc.length - 6
        end

        it "sets the 'application_context' instance variable" do
          expect(@ar.application_context).to eq(@ac)
        end

        it "loads 2 presentation contexts" do
          expect(@ar.presentation_contexts.length).to eq(2)
        end

        it "sets the 'user_information' instance variable" do
          expect(@ar.user_information).to eq(@ui)
        end

      end

    end

    describe '::new' do

      before(:all) do
        @ar = AssociationRequest.new
      end

      it "creates a new AssociationRequest instance" do
        expect(@ar).to be_a(AssociationRequest)
      end

      it "by default sets the type attribute to 01H" do
        expect(@ar.type).to eql @item_type
      end

      it "by default sets the len attribute to num_bytes-6" do
        expect(@ar.len).to eql @ar.num_bytes - 6
      end

      it "by default sets the protocol_version attribute to '\x00\x01'" do
        expect(@ar.protocol_version).to eql "\x00\x01"
      end

      it "by default sets the called_ae attribute to DESTINATION (properly padded to 16 bytes)" do
        expect(@ar.called_ae).to eql "DESTINATION     "
      end

      it "by default sets the calling_ae attribute to RUBY_DICOM (properly padded to 16 bytes)" do
        expect(@ar.calling_ae).to eql "RUBY_DICOM      "
      end

      it "by default sets the reserved1 attribute to a zero hex" do
        expect(@ar.reserved1).to eql "\x00"
      end

      it "by default sets the reserved2 attribute to a double zero hex" do
        expect(@ar.reserved2).to eql "\x00\x00"
      end

      it "by default sets the reserved3 attribute to 32 zero hex bytes" do
        expect(@ar.reserved3).to eql "\x00" * 32
      end

    end


    describe '#called_ae=' do

      it "changes its value (and applies proper padding)" do
        ar = AssociationRequest.new
        ar.called_ae = "HOST"
        expect(ar.called_ae).to eql "HOST            "
      end

    end


    describe '#calling_ae=' do

      it "changes its value (and applies proper padding)" do
        ar = AssociationRequest.new
        ar.calling_ae = "CLIENT"
        expect(ar.calling_ae).to eql "CLIENT          "
      end

    end


    describe '#protocol_version=' do

      it "changes its value" do
        ar = AssociationRequest.new
        ar.protocol_version = "\x00\x02"
        expect(ar.protocol_version).to eql "\x00\x02"
      end

    end


    describe '#type=' do

      it "it raises an error if the type is attempted set with an invalid value" do
        ar = AssociationRequest.new
        expect {ar.type = "\x09"}.to raise_error
      end

      it "it accepts that the type is set with the valid value" do
        ar = AssociationRequest.new
        ar.type = @item_type
        expect(ar.type).to eql @item_type
      end

    end


    describe '#application_context=' do

      it "changes its value" do
        ar = AssociationRequest.new
        ar.application_context = @ac
        expect(ar.application_context).to eq(@ac)
      end

    end


    describe '#user_information=' do

      it "changes its value" do
        ar = AssociationRequest.new
        ar.user_information = @ui
        expect(ar.user_information).to eq(@ui)
      end

    end


    describe '#len' do

      it "is synchronized with any changing attributes" do
        ar = AssociationRequest.new
        initial_length = ar.len.dup
        ar.application_context = @ac
        expect(ar.len).to be > initial_length
        expect(ar.len).to eql ar.num_bytes - 6
      end

    end


    describe '#len=' do

      it "is not able to change its value (to something other than the length of the remaining structure)" do
        ar = AssociationRequest.new
        ar.len = 5
        expect(ar.len).not_to eql 5
      end

    end


    describe '#to_binary_s' do

      it "reproduces the original binary string (in this single presentation context case)" do
        ar = AssociationRequest.read(@bin)
        output = ar.to_binary_s
        expect(output).to eql @bin
      end

      it "reproduces the original binary string in this multiple presentation context case)" do
        ar = AssociationRequest.read(@bin2pc)
        output = ar.to_binary_s
        expect(output).to eql @bin2pc
      end

      it "uses the modified attributes along with the defaults to produce a valid string" do
        ar = AssociationRequest.read(@bin)
        bin = @bin.dup
        bin[7] = "\x09"
        ar.protocol_version = "\x00\x09"
        output = ar.to_binary_s
        expect(output).to eql bin
      end

    end


    describe '#write' do

      it "encodes the object to file (reproducing the original binary string)" do
        ar = AssociationRequest.read(@bin)
        f = File.join(TMPDIR, 'association_request.bin')
        File.open(f, 'wb') do |io|
          ar.write(io)
        end
        output = File.open(f, 'rb').read
        expect(output).to eql @bin
      end

    end

  end

end