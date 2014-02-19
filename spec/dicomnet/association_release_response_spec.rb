# encoding: UTF-8

require 'spec_helper'

module DICOMNET

  describe AssociationReleaseResponse do

    before(:all) do
      @pdu_type = "\x06"
      @bin = "\x06\x00\x00\x00\x00\x04\x00\x00\x00\x00"
      @bin_with_invalid_pdu = "\x08\x00\x00\x00\x00\x04\x00\x00\x00\x00"
    end

    describe '::read' do

      it "raises an error when encountering an unexpected PDU type" do
        expect {AssociationReleaseResponse.read(@bin_with_invalid_pdu)}.to raise_error
      end

      context "parses an association release response binary string" do

        before(:all) do
          @arp = AssociationReleaseResponse.read(@bin)
        end

        it "and returns an AssociationReleaseResponse instance" do
          expect(@arp).to be_a(AssociationReleaseResponse)
        end

        it "and sets the 'type' instance variable" do
          expect(@arp.type).to eql @pdu_type
        end

        it "and sets the 'len' instance variable" do
          expect(@arp.len).to eql 4
        end

        it "and sets the 'reserved1' instance variable" do
          expect(@arp.reserved1).to eql "\x00"
        end

        it "and sets the 'reserved2' instance variable" do
          expect(@arp.reserved2).to eql "\x00" * 4
        end

      end

    end


    describe '::new' do

      before(:all) do
        @arp = AssociationReleaseResponse.new
      end

      it "creates a new AssociationReleaseResponse instance" do
        expect(@arp).to be_a(AssociationReleaseResponse)
      end

      it "by default sets the pdu_type attribute" do
        expect(@arp.type).to eql @pdu_type
      end

      it "by default sets the len attribute to 4" do
        expect(@arp.len).to eql 4
      end

      it "by default sets the reserved attributes to a zero hex" do
        expect(@arp.reserved1).to eql "\x00"
        expect(@arp.reserved2).to eql "\x00" * 4
      end

    end


    describe '#type=' do

      it "it raises an error if the type is attempted set with an invalid value" do
        arp = AssociationReleaseResponse.new
        expect {arp.type = "\x03"}.to raise_error
      end

      it "it accepts that the type is set with the valid value" do
        arp = AssociationReleaseResponse.new
        arp.type = @pdu_type
        expect(arp.type).to eql @pdu_type
      end

    end


    describe '#len=' do

      it "is not able to change its value" do
        arp = AssociationReleaseResponse.new
        arp.len = 5
        expect(arp.len).to eql 4
      end

    end


    describe '#reserved1=' do

      it "changes its value (and maintains a fixed length)" do
        arp = AssociationReleaseResponse.new
        arp.reserved1 = "\x01\x99"
        expect(arp.reserved1).to eql "\x01"
      end

    end


    describe '#reserved2=' do

      it "changes its value (and maintains a fixed length)" do
        arp = AssociationReleaseResponse.new
        arp.reserved2 = "\x02"
        expect(arp.reserved2).to eql "\x02\x00\x00\x00"
      end

    end


    describe '#to_binary_s' do

      it "reproduces the original binary string" do
        arp = AssociationReleaseResponse.read(@bin)
        output = arp.to_binary_s
        expect(output).to eql @bin
      end

      it "uses the modified attributes along with the defaults" do
        arp = AssociationReleaseResponse.new
        arp.reserved1 = "\x01"
        output = arp.to_binary_s
        expect(output).to eql "\x06\x01\x00\x00\x00\x04\x00\x00\x00\x00"
      end

    end


    describe '#write' do

      it "encodes the object to file (reproducing the original binary string)" do
        arp = AssociationReleaseResponse.read(@bin)
        f = File.join(TMPDIR, 'association_release_response.bin')
        File.open(f, 'wb') do |io|
          arp.write(io)
        end
        output = File.open(f, 'rb').read
        expect(output).to eql @bin
      end

    end

  end

end