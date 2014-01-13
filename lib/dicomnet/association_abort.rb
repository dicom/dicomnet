module DICOMNET

  # The association abort notification is used when a DICOM node is
  # subject to an invalid message which it isn't able to handle within the
  # ordinary DICOM negotiation framework. Its use signals that the
  # negotiation is over.
  #
  class AssociationAbort < BinData::Record

    endian :big
    # The PDU type code.
    uint8 :type, :value => 7, :check_value => lambda { value == 7}
    string :reserved1, :read_length => 1, :initial_value => "\x00"
    # The PDU length.
    uint32 :len, :value => 4
    string :reserved2, :read_length => 1, :initial_value => "\x00"
    string :reserved3, :read_length => 1, :initial_value => "\x00"
    # The source of a situation causing an abort.
    uint8 :source, :initial_value => 0
    # The reason for an abort.
    uint8 :reason, :initial_value => 0

    # Reasons for issueing an abort notification.
    REASONS = {
      0 => 'Reason not specified',
      1 => 'Unrecognized PDU',
      2 => 'Unexpected PDU',
      3 => 'Reserved',
      4 => 'Unrecognized PDU parameter',
      5 => 'Unexpected PDU parameter',
      6 => 'Invalid PDU parameter value',
    }

    # The source for the situation which caused an abort notification.
    SOURCES = {
      0 => 'Service user initiated abort',
      1 => 'Reserved',
      2 => 'Service provider initiated abort'
    }

    # Gives an explanation of the reason code.
    #
    def reason_description
      REASONS[self.reason] || "Unknown (invalid) reason code: #{self.reason} (Valid codes are 0-6)"
    end

    # Gives an explanation of the source code.
    #
    def source_description
      SOURCES[self.source] || "Unknown (invalid) source code: #{self.source} (Valid codes are 0-2)"
    end

  end

end