module DICOMNET

  # The association accept is the answer sent from the host to the client
  # in order to convey which parts of the proposed DICOM communication
  # have been accepted. The accept message is structured similarly to the
  # request, containing a header followed by three items:
  # -Application Context
  # -Presentation Context
  # -User Information
  #
  # For more information about the A-ASSOCIATE-AC PDU structure, refer
  # to the DICOM Standard, Part 8, Chapter 9.3.3.
  #
  class AssociationAccept < BinData::Record

    endian :big
    # The PDU type code.
    string :type, :length => 1, :asserted_value => "\x02"
    string :reserved1, :length => 1, :initial_value => "\x00"
    # The item length.
    uint32 :len, :value => lambda {num_bytes - 6}
    # Protocol version.
    string :protocol_version, :length => 2, :initial_value => "\x00\x01"
    string :reserved2, :length => 2, :initial_value => "\x00\x00"
    # The server side application entity name.
    string :called_ae, :length => 16, :initial_value => "RUBY_DICOM", :pad_byte => "\x20"
    # The client side application entity name.
    string :calling_ae, :length => 16, :initial_value => "CLIENT", :pad_byte => "\x20"
    string :reserved3, :length => 32, :initial_value => "\x00" * 32
    # The application context structure.
    application_context :application_context
    # The presentation context structures (1 or several).
    array :presentation_context_responses, :type => :presentation_context_response, :initial_length => 0
    # The user information structure.
    user_information :user_information

    # Reads the association accept binary string.
    #
    # @param [String] str an association accept binary string
    # @return [AssociationAccept] the created AssociationAccept instance
    #
    def self.read(str)
      r = AssociationAcceptScaffold.read(str)
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
        when "\x21"
          a.presentation_context_responses << PresentationContextResponse.read(item.to_binary_s)
        when "\x50"
          a.user_information = UserInformation.read(item.to_binary_s)
        else
          raise "Unexpected item type encountered. Expected 0x10, 0x21 or 0x50, got: 0x#{item.type.unpack('H*')[0]}"
        end
      end
      a
    end

  end

end