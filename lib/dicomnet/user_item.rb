module DICOMNET

  # The user data sub-item is part of the user information, and
  # specific pieces of technical information related to the communication,
  # like e.g. the maximum network data package size.
  #
  # For more information about the user sub item structure, refer
  # to the DICOM Standard, Part 8, Chapters 9.3.2.3 and 9.3.3.3.
  #
  class UserItem < BinData::Record

    endian :big
    # The item type code (various - e.g. 51H).
    string :type, :length => 1, :initial_value => "\x00"
    string :reserved1, :length => 1, :initial_value => "\x00"
    # The item length.
    uint16 :len, :value => lambda {num_bytes - 4}
    # User data value (decoding depends on the type of item):
    choice :val, :selection => :type do
      uint32 "\x51", :initial_value => DICOMNET.max_package_size
      string "\x52", :read_length => :len, :initial_value => DICOMNET.implementation_uid
      string "\x55", :read_length => :len, :initial_value => DICOMNET.implementation_version
      string :default, :read_length=>:len
    end

  end

end