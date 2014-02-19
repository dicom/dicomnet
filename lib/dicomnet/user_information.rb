module DICOMNET

  # The user information item is the last part of the association, and conveys
  # various technical information related to the communication in user data
  # sub-items.
  #
  # For more information about the user information item structure, refer
  # to the DICOM Standard, Part 8, Chapters 9.3.2.3 and 9.3.3.3.
  #
  class UserInformation < BinData::Record

    endian :big
    # The item type code.
    string :type, :length => 1, :asserted_value => "\x50"
    string :reserved1, :length => 1, :initial_value => "\x00"
    # The item length.
    uint16 :len, :value => lambda {num_bytes - 4}
    # User data sub-items.
    array :user_items, :type => :user_item, :read_until => lambda {len == user_items.num_bytes}

    # Gives the value of the associated implementation UID user item (if present).
    #
    # @return [String, NilClass] the matched user item value (or nil if no match is made)
    #
    def implementation_uid
      i = item("\x52")
      i.val if i
    end

    # Sets the implementation UID user item.
    #
    # @param [String] value implementation UID
    #
    def implementation_uid=(value)
      i = item("\x52")
      i.val = value
    end

    # Gives the value of the associated implementation version user item (if present).
    #
    # @return [String, NilClass] the matched user item value (or nil if no match is made)
    #
    def implementation_version
      i = item("\x55")
      i.val if i
    end

    # Sets the implementation version user item.
    #
    # @param [String] value implementation version
    #
    def implementation_version=(value)
      i = item("\x55")
      i.val = value
    end

    # Gives the value of the associated max PDU length user item (if present).
    #
    # @return [Integer, NilClass] the matched user item value (or nil if no match is made)
    #
    def max_pdu_length
      i = item("\x51")
      i.val if i
    end

    # Sets the max PDU length user item.
    #
    # @param [Integer] value maximum pdu length
    #
    def max_pdu_length=(value)
      i = item("\x51")
      i.val = value
    end

    # Creates a set of 3 default user items for this user information instance.
    #
    def set_default_items
      self.user_items = [
        UserItem.new(:type => "\x51", :val => DICOMNET.max_package_size),
        UserItem.new(:type => "\x52", :val => DICOMNET.implementation_uid),
        UserItem.new(:type => "\x55", :val => DICOMNET.implementation_version)
      ]
    end


    private

    # Selects a single user item based on the given type.
    #
    # @param [String] type an item type code
    # @return [UserItem, NilClass] the matched user item (or nil if no match is made)
    #
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