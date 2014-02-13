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
  class AssociationRequest < BinData::Record

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
    # The application context structure.
    application_context :application_context
    # The presentation context structures (1 or several).
    array :presentation_context_requests, :type => :presentation_context_request, :initial_length => 0
    # The user information structure.
    user_information :user_information

    # Reads the association request binary string.
    #
    def self.read(str)
      r = AssociationRequestScaffold.read(str)
      a = self.new(
        :len => r.len,
        :reserved1 => r.reserved1,
        :protocol_version => r.protocol_version,
        :reserved2 => r.reserved2,
        :called_ae => r.called_ae,
        :calling_ae => r.calling_ae,
        :reserved3 => r.reserved3
      )
      r.context_items.each do |item|
        case item.type
        when "\x10"
          a.application_context = ApplicationContext.read(item.to_binary_s)
        when "\x20"
          a.presentation_context_requests << PresentationContextRequest.read(item.to_binary_s)
        when "\x50"
          a.user_information = UserInformation.read(item.to_binary_s)
        else
          raise "Unexpected item type encountered. Expected 0x10, 0x20 or 0x50, got: 0x#{item.type.unpack('H*')[0]}"
        end
      end
      a
    end

  end

end