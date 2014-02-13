module DICOMNET

  # This is a scaffold class, used for loading the context items contained
  # in the association request. The AssociationRequest proceeds to process
  # these context items as application context, presentation context and
  # user information.
  #
  class AssociationRequestScaffold < BinData::Record

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
    string :called_ae, :length => 16, :initial_value => "DESTINATION", :pad_byte => "\x20"
    # The client side application entity name.
    string :calling_ae, :length => 16, :initial_value => "RUBY_DICOM", :pad_byte => "\x20"
    string :reserved3, :length => 32, :initial_value => "\x00" * 32
    # The context item structures contained in the request.
    array :context_items, :type => :context_item, :read_until => :eof

  end

end