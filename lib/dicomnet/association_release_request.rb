module DICOMNET

  # The association release request signals that the client is finished
  # with its communications and is ending the connection.
  #
  # For more information about the A-RELEASE-RQ PDU structure, refer to the
  # DICOM Standard, Part 8, Chapter 9.3.6.
  #
  class AssociationReleaseRequest < BinData::Record

    endian :big
    # The PDU type code.
    string :type, :length => 1, :asserted_value => "\x05"
    string :reserved1, :length => 1, :initial_value => "\x00"
    # The PDU length.
    uint32 :len, :value => 4
    string :reserved2, :length => 4, :initial_value => "\x00\x00\x00\x00"

  end

end