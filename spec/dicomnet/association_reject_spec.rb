# encoding: UTF-8

require 'spec_helper'

module DICOMNET

  describe AssociationReject do

    before(:all) do
      @pdu_type = "\x03"
      @bin = "\x03\x00\x00\x00\x00\x04\x00\x01\x01\x01"
      @bin_with_invalid_pdu = "\x15\x00\x00\x00\x00\x04\x00\x01\x01\x01"
    end

    describe '::read' do

      it "raises an error when encountering an unexpected PDU type" do
        expect {AssociationReject.read(@bin_with_invalid_pdu)}.to raise_error(BinData::ValidityError)
      end

      context "parses an association reject binary string" do

        before(:all) do
          @arj = AssociationReject.read(@bin)
        end

        it "and returns an AssociationReject instance" do
          expect(@arj).to be_a(AssociationReject)
        end

        it "and sets the 'type' instance variable" do
          expect(@arj.type).to eql @pdu_type
        end

        it "and sets the 'len' instance variable" do
          expect(@arj.len).to eql 4
        end

        it "and sets the 'result' instance variable" do
          expect(@arj.result).to eql 1
        end

        it "and sets the 'source' instance variable" do
          expect(@arj.source).to eql 1
        end

        it "and sets the 'reason' instance variable" do
          expect(@arj.reason).to eql 1
        end

        it "and sets the 'reserved1' instance variable" do
          expect(@arj.reserved1).to eql "\x00"
        end

        it "and sets the 'reserved2' instance variable" do
          expect(@arj.reserved2).to eql "\x00"
        end

      end

    end


    describe '::new' do

      before(:all) do
        @arj = AssociationReject.new
      end

      it "creates a new AssociationReject instance" do
        expect(@arj).to be_a(AssociationReject)
      end

      it "by default sets the pdu_type attribute to 03H" do
        expect(@arj.type).to eql @pdu_type
      end

      it "by default sets the len attribute to 4" do
        expect(@arj.len).to eql 4
      end

      it "by default sets the result attribute to 1" do
        expect(@arj.result).to eql 1
      end

      it "by default sets the source attribute to 1" do
        expect(@arj.source).to eql 1
      end

      it "by default sets the reason attribute to 0" do
        expect(@arj.reason).to eql 0
      end

      it "by default sets the reserved attributes to a zero hex" do
        expect(@arj.reserved1).to eql "\x00"
        expect(@arj.reserved2).to eql "\x00"
      end

    end


    describe '#type=' do

      it "it raises an error if the type is attempted set with an invalid value" do
        arj = AssociationReject.new
        expect {arj.type = "\x16"}.to raise_error(BinData::ValidityError)
      end

      it "it accepts that the type is set with the valid value" do
        arj = AssociationReject.new
        arj.type = @pdu_type
        expect(arj.type).to eql @pdu_type
      end

    end


    describe '#len=' do

      it "is not able to change its value" do
        arj = AssociationReject.new
        arj.len = 5
        expect(arj.len).to eql 4
      end

    end


    describe '#result=' do

      it "changes its value" do
        arj = AssociationReject.new
        arj.result = 2
        expect(arj.result).to eql 2
      end

    end


    describe '#source=' do

      it "changes its value" do
        arj = AssociationReject.new
        arj.source = 3
        expect(arj.source).to eql 3
      end

    end


    describe '#reason=' do

      it "changes its value" do
        arj = AssociationReject.new
        arj.reason = 7
        expect(arj.reason).to eql 7
      end

    end


    describe '#reserved1=' do

      it "changes its value (and maintains a fixed length)" do
        arj = AssociationReject.new
        arj.reserved1 = "\x01\x99"
        expect(arj.reserved1).to eql "\x01"
      end

    end


    describe '#reserved2=' do

      it "changes its value (and maintains a fixed length)" do
        arj = AssociationReject.new
        arj.reserved2 = "\x02\x99"
        expect(arj.reserved2).to eql "\x02"
      end

    end


    describe '#result_description' do

      it "gives the expected text corresponding to this value" do
        arj = AssociationReject.new
        arj.result = 2
        expect(arj.result_description).to eql 'Rejected - transient'
      end

      it "gives some description which includes the argument, when an invalid value is passed" do
        arj = AssociationReject.new
        arj.result = 99
        expect(arj.result_description).to match(/99/)
      end

    end


    describe '#source_description' do

      it "gives the expected text corresponding to this value" do
        arj = AssociationReject.new
        arj.source = 1
        expect(arj.source_description).to eql 'DICOM UL service: User'
      end

      it "gives some description which includes the argument, when an invalid value is passed" do
        arj = AssociationReject.new
        arj.source = 99
        expect(arj.source_description).to match(/99/)
      end

    end


    describe '#reason_description' do

      it "gives the expected text corresponding to this value (with source being 1)" do
        arj = AssociationReject.new
        arj.source = 1
        arj.reason = 3
        expect(arj.reason_description).to eql 'Calling AE title not recognized'
      end

      it "gives the expected text corresponding to this value (with source being 2)" do
        arj = AssociationReject.new
        arj.source = 2
        arj.reason = 1
        expect(arj.reason_description).to eql 'No reason given'
      end

      it "gives the expected text corresponding to this value (with source being 3)" do
        arj = AssociationReject.new
        arj.source = 3
        arj.reason = 7
        expect(arj.reason_description).to eql 'Reserved'
      end

      it "gives some description which includes both source and reason arguments, when invalid value(s) are passed" do
        arj = AssociationReject.new
        arj.source = 98
        arj.reason = 99
        expect(arj.reason_description).to match(/98/)
        expect(arj.reason_description).to match(/99/)
      end

    end


    describe '#to_binary_s' do

      it "reproduces the original binary string" do
        arj = AssociationReject.read(@bin)
        output = arj.to_binary_s
        expect(output).to eql @bin
      end

      it "uses the modified attributes along with the defaults" do
        arj = AssociationReject.new
        arj.result = 2
        arj.source = 3
        arj.reason = 4
        output = arj.to_binary_s
        expect(output).to eql "\x03\x00\x00\x00\x00\x04\x00\x02\x03\x04"
      end

    end


    describe '#write' do

      it "encodes the object to file (reproducing the original binary string)" do
        arj = AssociationReject.read(@bin)
        f = File.join(TMPDIR, 'association_reject.bin')
        File.open(f, 'wb') do |io|
          arj.write(io)
        end
        output = File.open(f, 'rb').read
        expect(output).to eql @bin
      end

    end

  end

end