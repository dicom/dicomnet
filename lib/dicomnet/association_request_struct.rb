module DICOMNET

  # The association request is the initial message sent from a client to a host
  # in order to establish a DICOM communication. The request contains various
  # types of information contained in the header, as well as three items:
  # -Application Context
  # -Presentation Context
  # -User Information
  #
  # For more information about the Association request pdu structure, refer
  # to the DICOM Standard, Part 8, Chapter 9.3.2.
  #
  class AssociationRequestStruct < BinData::Record

    endian :big
    # The item type code (01H).
    string :type, :length => 1, :asserted_value => "\x01"
    string :reserved1, :length => 1, :initial_value => "\x00"
    # The item length.
    uint32 :len, :value => lambda {num_bytes - 6}
    # Protocol version.
    string :protocol_version, :length => 2, :initial_value => "\x00\x01"
    string :reserved2, :length => 2, :initial_value => "\x00\x00"
    # The server side application entity name.
    string :called_ae, :length => 16, :initial_value => "DESTINATION", :pad_byte=>"\x20"
    # The client side application entity name.
    string :calling_ae, :length => 16, :initial_value => "RUBY_DICOM", :pad_byte=>"\x20"
    string :reserved3, :length => 32, :initial_value => "\x00" * 32
    # The context item structures contained in the request.
    array :context_items, :type => :context_item, :read_until => :eof

  end

end