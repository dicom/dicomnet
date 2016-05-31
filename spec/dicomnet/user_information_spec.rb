# encoding: UTF-8

require 'spec_helper'

module DICOMNET

  describe UserInformation do

    before(:all) do
      @max_size = UserItem.new(:type => "\x51", :val => 32768)
      @implementation_uid = UserItem.new(:type => "\x52", :val => '1.2.826.0.1.3680043.8.641')
      @implementation_version = UserItem.new(:type => "\x55", :val => 'RUBY-DCM_0.9.5')
      @item_type = "\x50"
      @bin = File.open(USER_INFO, 'rb').read
      @bin_with_invalid_type = @bin.dup
      @bin_with_invalid_type[0] = "\x23"
    end

    describe '::read' do

      it "raises an error when encountering an unexpected item type" do
        expect {UserInformation.read(@bin_with_invalid_type)}.to raise_error(BinData::ValidityError)
      end

      context "parses a user information binary string (containing the 3 default user items) and" do

        before(:all) do
          @ui = UserInformation.read(@bin)
        end

        it "returns a UserInformation instance" do
          expect(@ui).to be_a(UserInformation)
        end

        it "sets the 'type' instance variable" do
          expect(@ui.type).to eql @item_type
        end

        it "sets the 'len' instance variable" do
          expect(@ui.len).to eql @bin.length - 4
        end

        it "sets the 'reserved1' instance variable" do
          expect(@ui.reserved1).to eql "\x00"
        end

        it "sets the 'user_items' instance variable array" do
          expect(@ui.user_items).to eq([@max_size, @implementation_uid, @implementation_version])
        end

      end


      context "parses a user information binary string (containing a 4th, unknown user item) and" do

        before(:all) do
          @bin_unknown = File.open(USER_INFO_UNKNOWN_ITEM, 'rb').read
          @ui_unknown = UserInformation.read(@bin_unknown)
        end

        it "sets the 'len' instance variable" do
          expect(@ui_unknown.len).to eql @bin_unknown.length - 4
        end

        it "sets the 'user_items' instance variable array" do
          unknown_item = UserItem.new(:type => "\x99", :val => 'asdf')
          expect(@ui_unknown.user_items).to eq([@max_size, @implementation_uid, @implementation_version, unknown_item])
        end

      end

    end


    describe '::new' do

      before(:all) do
        @ui = UserInformation.new
      end

      it "creates a new UserInformation instance" do
        expect(@ui).to be_a(UserInformation)
      end

      it "by default sets the type attribute to 50H" do
        expect(@ui.type).to eql @item_type
      end

      it "by default sets the len attribute to num_bytes-4" do
        expect(@ui.len).to eql @ui.num_bytes - 4
      end

      it "by default sets the reserved1 attribute to a zero hex" do
        expect(@ui.reserved1).to eql "\x00"
      end

    end


    describe '#set_default_items' do

      it "fills the user_items array of this empty user information instance with the 3 default items" do
        ui = UserInformation.new
        ui.set_default_items
        expect(ui.user_items[0].val).to eq(DICOMNET.max_package_size)
        expect(ui.user_items[1].val).to eq(DICOMNET.implementation_uid)
        expect(ui.user_items[2].val).to eq(DICOMNET.implementation_version)
        expect(ui.user_items.length).to eq(3)
      end

      it "resets the pre-configured user_items array of this user information instance with the 3 default items" do
        ui = UserInformation.new
        ui.user_items = [UserItem.new(:type => "\x99", :val => 'asdf')]
        ui.set_default_items
        expect(ui.user_items[0].val).to eq(DICOMNET.max_package_size)
        expect(ui.user_items[1].val).to eq(DICOMNET.implementation_uid)
        expect(ui.user_items[2].val).to eq(DICOMNET.implementation_version)
        expect(ui.user_items.length).to eq(3)
      end

    end


    describe '#type=' do

      it "it raises an error if the type is attempted set with an invalid value" do
        ui = UserInformation.new
        expect {ui.type = "\x09"}.to raise_error(BinData::ValidityError)
      end

      it "it accepts that the type is set with the valid value" do
        ui = UserInformation.new
        ui.type = @item_type
        expect(ui.type).to eql @item_type
      end

    end


    describe '#len' do

      it "is synchronized with any changing attributes" do
        ui = UserInformation.new
        initial_length = ui.len.dup
        ui.set_default_items
        expect(ui.len).to be > initial_length
        expect(ui.len).to eql ui.num_bytes - 4
      end

    end


    describe '#len=' do

      it "is not able to change its value (to something other than the length of the user items attributes)" do
        ui = UserInformation.new
        ui.len = 5
        expect(ui.len).not_to eql 5
      end

    end


    describe '#user_items=' do

      it "changes its value" do
        ui = UserInformation.new
        ui.user_items = [@implementation_uid]
        expect(ui.user_items).to eq([@implementation_uid])
      end

    end


    describe '#reserved1=' do

      it "changes its value (and maintains a fixed length)" do
        ui = UserInformation.new
        ui.reserved1 = "\x01\x99"
        expect(ui.reserved1).to eql "\x01"
      end

    end


    describe '#to_binary_s' do

      it "reproduces the original binary string" do
        ui = UserInformation.read(@bin)
        output = ui.to_binary_s
        expect(output).to eql @bin
      end

      it "uses the modified attributes along with the defaults to produce a valid string" do
        bin_unknown = "\x50\x00\x00\x3f\x51\x00\x00\x04\x00\x00\x80\x00\x52\x00\x00\x19\x31\x2e\x32\x2e\x38\x32\x36\x2e\x30\x2e\x31\x2e\x33\x36\x38\x30\x30\x34\x33\x2e\x38\x2e\x36\x34\x31\x55\x00\x00\x0e\x52\x55\x42\x59\x2d\x44\x43\x4d\x5f\x30\x2e\x39\x2e\x35\x66\x00\x00\x04\x61\x73\x64\x66".force_encoding('ASCII-8BIT')
        ui = UserInformation.new
        ui.set_default_items
        ui.max_pdu_length = 32768
        ui.implementation_uid = '1.2.826.0.1.3680043.8.641'
        ui.implementation_version = 'RUBY-DCM_0.9.5'
        ui.user_items << UserItem.new(:type => "\x66", :val => 'asdf')
        output = ui.to_binary_s
        expect(output).to eql bin_unknown
      end

    end


    describe '#write' do

      it "encodes the object to file (reproducing the original binary string)" do
        ui = UserInformation.read(@bin)
        f = File.join(TMPDIR, 'user_information.bin')
        File.open(f, 'wb') do |io|
          ui.write(io)
        end
        output = File.open(f, 'rb').read
        expect(output).to eq(@bin)
      end

    end

  end

end