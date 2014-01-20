# encoding: UTF-8

require 'spec_helper'

module DICOMNET

  describe ApplicationContext do

    before(:all) do
      @pdu_type = 16
      @bin = "\x10\x00\x00\x15\x31\x2e\x32\x2e\x38\x34\x30\x2e\x31\x30\x30\x30\x38\x2e\x33\x2e\x31\x2e\x31\x2e\x31"
      @invalid_pdu = "\x07\x00\x00\x15\x31\x2e\x32\x2e\x38\x34\x30\x2e\x31\x30\x30\x30\x38\x2e\x33\x2e\x31\x2e\x31\x2e\x31"
    end

    describe '::read' do

      it "raises an error when encountering an unexpected PDU type" do
        expect {ApplicationContext.read(@invalid_pdu)}.to raise_error
      end

      context "parses an application context binary string" do

        before(:all) do
          @ac = ApplicationContext.read(@bin)
        end

        it "and returns an ApplicationContext instance" do
          expect(@ac).to be_a(ApplicationContext)
        end

        it "and sets the 'type' instance variable" do
          expect(@ac.type).to eql @pdu_type
        end

        it "and sets the 'len' instance variable" do
          expect(@ac.len).to eql 21
        end

        it "and sets the 'name' instance variable" do
          expect(@ac.name).to eql '1.2.840.10008.3.1.1.1'
        end

        it "and sets the 'reserved1' instance variable" do
          expect(@ac.reserved1).to eql "\x00"
        end

      end

    end


    describe '::new' do

      before(:all) do
        @ac = ApplicationContext.new
      end

      it "creates a new ApplicationContext instance" do
        expect(@ac).to be_a(ApplicationContext)
      end

      it "by default sets the pdu_type attribute to 16" do
        expect(@ac.type).to eql @pdu_type
      end

      it "by default sets the len attribute to 21" do
        expect(@ac.len).to eql 21
      end

      it "by default sets the name attribute to '1.2.840.10008.3.1.1.1'" do
        expect(@ac.name).to eql '1.2.840.10008.3.1.1.1'
      end

      it "by default sets the reserved1 attribute to a zero hex" do
        expect(@ac.reserved1).to eql "\x00"
      end

    end


    describe '#type=' do

      it "it raises an error if the type is attempted set with an invalid value" do
        ac = ApplicationContext.new
        expect {ac.type = 5}.to raise_error
      end

      it "it accepts that the type is set with the valid value" do
        ab = ApplicationContext.new
        ab.type = @pdu_type
        expect(ab.type).to eql @pdu_type
      end

    end


    describe '#len' do

      it "is synchronized with the name attribute" do
        ac = ApplicationContext.new
        ac.name = '1.2.34'
        expect(ac.len).to eql 6
      end

    end


    describe '#len=' do

      it "is not able to change its value (to something other than the length of the name attribute)" do
        ac = ApplicationContext.new
        ac.len = 5
        expect(ac.len).to eql 21
      end

    end


    describe '#name=' do

      it "changes its value" do
        ac = ApplicationContext.new
        ac.name = '1.2.34'
        expect(ac.name).to eql '1.2.34'
      end

    end


    describe '#to_binary_s' do

      it "reproduces the original binary string" do
        ac = ApplicationContext.read(@bin)
        output = ac.to_binary_s
        expect(output).to eql @bin
      end

      it "uses the modified attributes along with the defaults" do
        ac = ApplicationContext.new
        ac.name = '1.2.34'
        output = ac.to_binary_s
        expect(output).to eql "\x10\x00\x00\x06\x31\x2e\x32\x2e\x33\x34"
      end

    end


    describe '#write' do

      it "encodes the object to file (reproducing the original binary string)" do
        ac = ApplicationContext.read(@bin)
        f = File.join(TMPDIR, 'application_context.bin')
        File.open(f, 'wb') do |io|
          ac.write(io)
        end
        output = File.read(f)
        expect(output).to eql @bin
      end

    end

  end

end