# encoding: UTF-8

require 'spec_helper'

module DICOMNET

  describe AssociationReleaseRequest do

    before(:all) do
      @pdu_type = "\x05"
      @bin = "\x05\x00\x00\x00\x00\x04\x00\x00\x00\x00"
      @bin_with_invalid_pdu = "\x09\x00\x00\x00\x00\x04\x00\x00\x00\x00"
    end

    describe '::read' do

      it "raises an error when encountering an unexpected PDU type" do
        expect {AssociationReleaseRequest.read(@bin_with_invalid_pdu)}.to raise_error
      end

      context "parses an association release request binary string" do

        before(:all) do
          @arq = AssociationReleaseRequest.read(@bin)
        end

        it "and returns an AssociationReleaseRequest instance" do
          expect(@arq).to be_a(AssociationReleaseRequest)
        end

        it "and sets the 'type' instance variable" do
          expect(@arq.type).to eql @pdu_type
        end

        it "and sets the 'len' instance variable" do
          expect(@arq.len).to eql 4
        end

        it "and sets the 'reserved1' instance variable" do
          expect(@arq.reserved1).to eql "\x00"
        end

        it "and sets the 'reserved2' instance variable" do
          expect(@arq.reserved2).to eql "\x00" * 4
        end

      end

    end


    describe '::new' do

      before(:all) do
        @arq = AssociationReleaseRequest.new
      end

      it "creates a new AssociationReleaseRequest instance" do
        expect(@arq).to be_a(AssociationReleaseRequest)
      end

      it "by default sets the pdu_type attribute" do
        expect(@arq.type).to eql @pdu_type
      end

      it "by default sets the len attribute to 4" do
        expect(@arq.len).to eql 4
      end

      it "by default sets the reserved attributes to a zero hex" do
        expect(@arq.reserved1).to eql "\x00"
        expect(@arq.reserved2).to eql "\x00" * 4
      end

    end


    describe '#type=' do

      it "it raises an error if the type is attempted set with an invalid value" do
        arq = AssociationReleaseRequest.new
        expect {arq.type = "\x03"}.to raise_error
      end

      it "it accepts that the type is set with the valid value" do
        arq = AssociationReleaseRequest.new
        arq.type = @pdu_type
        expect(arq.type).to eql @pdu_type
      end

    end


    describe '#len=' do

      it "is not able to change its value" do
        arq = AssociationReleaseRequest.new
        arq.len = 5
        expect(arq.len).to eql 4
      end

    end


    describe '#reserved1=' do

      it "changes its value (and maintains a fixed length)" do
        arq = AssociationReleaseRequest.new
        arq.reserved1 = "\x01\x99"
        expect(arq.reserved1).to eql "\x01"
      end

    end


    describe '#reserved2=' do

      it "changes its value (and maintains a fixed length)" do
        arq = AssociationReleaseRequest.new
        arq.reserved2 = "\x02"
        expect(arq.reserved2).to eql "\x02\x00\x00\x00"
      end

    end


    describe '#to_binary_s' do

      it "reproduces the original binary string" do
        arq = AssociationReleaseRequest.read(@bin)
        output = arq.to_binary_s
        expect(output).to eql @bin
      end

      it "uses the modified attributes along with the defaults" do
        arq = AssociationReleaseRequest.new
        arq.reserved1 = "\x01"
        output = arq.to_binary_s
        expect(output).to eql "\x05\x01\x00\x00\x00\x04\x00\x00\x00\x00"
      end

    end


    describe '#write' do

      it "encodes the object to file (reproducing the original binary string)" do
        arq = AssociationReleaseRequest.read(@bin)
        f = File.join(TMPDIR, 'association_release_request.bin')
        File.open(f, 'wb') do |io|
          arq.write(io)
        end
        output = File.open(f, 'rb').read
        expect(output).to eql @bin
      end

    end

  end

end