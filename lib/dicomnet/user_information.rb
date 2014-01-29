module DICOMNET

  # The user information item is the last part of the association, and conveys
  # various technical information related to the communication in user data
  # sub-items.
  #
  # For more information about the User information item structure, refer
  # to the DICOM Standard, Part 8, Chapter 9.3.2.3.
  #
  class UserInformation < BinData::Record

    endian :big
    # The item type code (50H).
    string :type, :read_length => 1, :asserted_value => "\x50"
    string :reserved1, :read_length => 1, :initial_value => "\x00"
    # The item length.
    uint16 :len, :value => lambda {num_bytes - 4}
    # User data sub-items.
    array :user_items, :type => :user_item, :read_until => lambda {len == user_items.num_bytes}

    def implementation_uid
      i = item("\x52")
      i.val if i
    end

    def implementation_uid=(value)
      i = item("\x52")
      i.val = value
    end

    def implementation_version
      i = item("\x55")
      i.val if i
    end

    def implementation_version=(value)
      i = item("\x55")
      i.val = value
    end

    def max_pdu_length
      i = item("\x51")
      i.val if i
    end

    def max_pdu_length=(value)
      i = item("\x51")
      i.val = value
    end

    def set_default_items
      self.user_items = [
        UserItem.new(:type => "\x51", :val => DICOMNET.max_package_size),
        UserItem.new(:type => "\x52", :val => DICOMNET.implementation_uid),
        UserItem.new(:type => "\x55", :val => DICOMNET.implementation_version)
      ]
    end


    private


    def item(type)
      user_item = nil
      user_items.each do |u|
        if u.type == type
          user_item = u
          break
        end
      end
      user_item
    end

  end

end