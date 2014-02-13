# encoding: UTF-8

require 'spec_helper'

module DICOMNET

  describe UserItem do

    before(:all) do
      @bin_max_size = "\x51\x00\x00\x04\x00\x00\x20\x00"
      @bin_uid = "\x52\x00\x00\x19\x31\x2e\x32\x2e\x38\x32\x36\x2e\x30\x2e\x31\x2e\x33\x36\x38\x30\x30\x34\x33\x2e\x38\x2e\x36\x34\x33"
      @bin_version = "\x55\x00\x00\x0e\x52\x55\x42\x59\x2d\x44\x43\x4d\x5f\x30\x2e\x39\x2e\x35"
      @bin_unknown = "\x66\x00\x00\x04\x61\x73\x64\x66"
    end

    describe '::read' do

      # FIXME:
      #it "logs a warning when an unknown item type is encountered" do
        #DICOMNET.logger.expects(:warn).once
        #UserItem.read(@bin_unknown)
      #end

      context "parses a user item binary string (of type implementation uid) and" do

        before(:all) do
          @ui = UserItem.read(@bin_uid)
        end

        it "returns an UserItem instance" do
          expect(@ui).to be_a(UserItem)
        end

        it "sets the 'type' instance variable" do
          expect(@ui.type).to eql "\x52"
        end

        it "sets the 'len' instance variable" do
          expect(@ui.len).to eql 25
        end

        it "sets the 'val' instance variable" do
          expect(@ui.val).to eq('1.2.826.0.1.3680043.8.643')
        end

        it "sets the 'reserved1' instance variable" do
          expect(@ui.reserved1).to eql "\x00"
        end

      end


      context "parses a user item binary string (of type implementation version) and" do

        before(:all) do
          @ui = UserItem.read(@bin_version)
        end

        it "sets the 'type' instance variable" do
          expect(@ui.type).to eql "\x55"
        end

        it "sets the 'len' instance variable" do
          expect(@ui.len).to eql 14
        end

        it "sets the 'val' instance variable" do
          expect(@ui.val).to eq('RUBY-DCM_0.9.5')
        end

      end

      context "parses a user item binary string (of type max pdu size) and" do

        before(:all) do
          @ui = UserItem.read(@bin_max_size)
        end

        it "sets the 'type' instance variable" do
          expect(@ui.type).to eql "\x51"
        end

        it "sets the 'len' instance variable" do
          expect(@ui.len).to eql 4
        end

        it "sets the 'val' instance variable" do
          expect(@ui.val).to eq(8192)
        end

      end

      context "parses a user item binary string (of unknown type) and" do

        before(:all) do
          @ui = UserItem.read(@bin_unknown)
        end

        it "sets the 'type' instance variable" do
          expect(@ui.type).to eq("\x66")
        end

        it "sets the 'len' instance variable" do
          expect(@ui.len).to eql 4
        end

        it "sets the 'val' instance variable" do
          expect(@ui.val).to eq('asdf')
        end

      end

    end


    describe '::new' do

      before(:all) do
        @ui = UserItem.new
      end

      it "creates a new UserItem instance" do
        expect(@ui).to be_a(UserItem)
      end

      it "by default sets the type attribute to zero hex" do
        expect(@ui.type).to eql "\x00"
      end

      it "by default sets the len attribute to 0" do
        expect(@ui.len).to eql 0
      end

      it "by default sets the val attribute to ''" do
        expect(@ui.val).to eq('')
      end

      it "by default sets the reserved1 attribute to a zero hex" do
        expect(@ui.reserved1).to eql "\x00"
      end

    end


    describe '#type=' do

      # FIXME:
      #it "logs a warning if the type is attempted set with an unknown value" do
        #DICOMNET.logger.expects(:warn).once
        #ui = UserItem.new
        #ui.type = "\x02"
      #end

      it "does not log a warning when the type is set with a known value" do
        DICOMNET.logger.expects(:warn).never
        ui = UserItem.new
        ui.type = "\x51"
      end

      it "sets the type" do
        ui = UserItem.new
        ui.type = "\x51"
        expect(ui.type).to eql "\x51"
      end

    end


    describe '#len' do

      it "is synchronized with the val attribute" do
        ui = UserItem.new(:type => "\x51")
        ui.val = 8192
        expect(ui.len).to eql 4
      end

    end


    describe '#len=' do

      it "is not able to change its value (to something other than the length of the val attribute)" do
        ui = UserItem.new(:type => "\x52")
        ui.val = '1.2.34'
        ui.len = 5
        expect(ui.len).to eql 6
      end

    end


    describe '#val=' do

      it "changes its value" do
        ui = UserItem.new(:type => "\x52")
        ui.val = '1.2.34'
        expect(ui.val).to eq('1.2.34')
      end

    end


    describe '#reserved1=' do

      it "changes its value (and maintains a fixed length)" do
        ui = UserItem.new
        ui.reserved1 = "\x01\x99"
        expect(ui.reserved1).to eql "\x01"
      end

    end


    describe '#to_binary_s' do

      it "reproduces the original binary string" do
        ui = UserItem.read(@bin_version)
        output = ui.to_binary_s
        expect(output).to eql @bin_version
      end

      it "uses the modified attributes along with the defaults" do
        ui = UserItem.new(:type => "\x52", :val => '1.2.34')
        output = ui.to_binary_s
        expect(output).to eql "\x52\x00\x00\x06\x31\x2e\x32\x2e\x33\x34"
      end

    end


    describe '#write' do

      it "encodes the object to file (reproducing the original binary string)" do
        ui = UserItem.read(@bin_max_size)
        f = File.join(TMPDIR, 'user_item_max_size.bin')
        File.open(f, 'wb') do |io|
          ui.write(io)
        end
        output = File.open(f, 'rb').read
        expect(output).to eql @bin_max_size
      end

    end

  end

end