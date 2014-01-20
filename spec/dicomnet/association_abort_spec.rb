# encoding: UTF-8

require 'spec_helper'

module DICOMNET

  describe AssociationAbort do

    before(:all) do
      @pdu_type = "\x07"
      @bin = "\x07\x00\x00\x00\x00\x04\x00\x00\x02\x01"
      @invalid_pdu = "\x06\x00\x00\x00\x00\x04\x00\x00\x00\x00"
    end

    describe '::read' do

      it "raises an error when encountering an unexpected PDU type" do
        expect {AssociationAbort.read(@invalid_pdu)}.to raise_error
      end

      context "parses an association abort binary string" do

        before(:all) do
          @ab = AssociationAbort.read(@bin)
        end

        it "and returns an AssociationAbort instance" do
          expect(@ab).to be_a(AssociationAbort)
        end

        it "and sets the 'type' instance variable" do
          expect(@ab.type).to eql @pdu_type
        end

        it "and sets the 'len' instance variable" do
          expect(@ab.len).to eql 4
        end

        it "and sets the 'source' instance variable" do
          expect(@ab.source).to eql 2
        end

        it "and sets the 'reason' instance variable" do
          expect(@ab.reason).to eql 1
        end

        it "and sets the 'reserved1' instance variable" do
          expect(@ab.reserved1).to eql "\x00"
        end

        it "and sets the 'reserved2' instance variable" do
          expect(@ab.reserved2).to eql "\x00"
        end

        it "and sets the 'reserved3' instance variable" do
          expect(@ab.reserved3).to eql "\x00"
        end

      end

    end


    describe '::new' do

      before(:all) do
        @ab = AssociationAbort.new
      end

      it "creates a new AssociationAbort instance" do
        expect(@ab).to be_a(AssociationAbort)
      end

      it "by default sets the pdu_type attribute to 07H" do
        expect(@ab.type).to eql @pdu_type
      end

      it "by default sets the len attribute to 4" do
        expect(@ab.len).to eql 4
      end

      it "by default sets the source attribute to 0" do
        expect(@ab.source).to eql 0
      end

      it "by default sets the reason attribute to 0" do
        expect(@ab.reason).to eql 0
      end

      it "by default sets the reserved attributes to a zero hex" do
        expect(@ab.reserved1).to eql "\x00"
        expect(@ab.reserved2).to eql "\x00"
        expect(@ab.reserved3).to eql "\x00"
      end

    end


    describe '#type=' do

      it "it raises an error if the type is attempted set with an invalid value" do
        ab = AssociationAbort.new
        expect {ab.type = 5}.to raise_error
      end

      it "it accepts that the type is set with the valid value" do
        ab = AssociationAbort.new
        ab.type = @pdu_type
        expect(ab.type).to eql @pdu_type
      end

    end


    describe '#len=' do

      it "is not able to change its value" do
        ab = AssociationAbort.new
        ab.len = 5
        expect(ab.len).to eql 4
      end

    end


    describe '#source=' do

      it "changes its value" do
        ab = AssociationAbort.new
        ab.source = 2
        expect(ab.source).to eql 2
      end

    end


    describe '#reason=' do

      it "changes its value" do
        ab = AssociationAbort.new
        ab.reason = 1
        expect(ab.reason).to eql 1
      end

    end


    describe '#source_description' do

      it "gives the expected text corresponding to this value" do
        ab = AssociationAbort.new
        ab.source = 1
        expect(ab.source_description).to eql 'Reserved'
      end

      it "gives some description which includes the argument, when an invalid value is passed" do
        ab = AssociationAbort.new
        ab.source = 99
        expect(ab.source_description).to match(/99/)
      end

    end


    describe '#reason_description' do

      it "gives the expected text corresponding to this value" do
        ab = AssociationAbort.new
        ab.reason = 2
        expect(ab.reason_description).to eql 'Unexpected PDU'
      end

      it "gives some description which includes the argument, when an invalid value is passed" do
        ab = AssociationAbort.new
        ab.reason = 99
        expect(ab.reason_description).to match(/99/)
      end

    end


    describe '#to_binary_s' do

      it "reproduces the original binary string" do
        ab = AssociationAbort.read(@bin)
        output = ab.to_binary_s
        expect(output).to eql @bin
      end

      it "uses the modified attributes along with the defaults" do
        ab = AssociationAbort.new
        ab.source=2
        ab.reason = 5
        output = ab.to_binary_s
        expect(output).to eql "\x07\x00\x00\x00\x00\x04\x00\x00\x02\x05"
      end

    end


    describe '#write' do

      it "encodes the object to file (reproducing the original binary string)" do
        ab = AssociationAbort.read(@bin)
        f = File.join(TMPDIR, 'association_abort.bin')
        File.open(f, 'wb') do |io|
          ab.write(io)
        end
        output = File.read(f)
        expect(output).to eql @bin
      end

    end

  end

end