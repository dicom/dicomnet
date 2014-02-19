module DICOMNET

  # The association release response signals is the receipt from the
  # scp to the scu, which signals that the session is finished.
  #
  # For more information about the A-RELEASE-RP PDU structure, refer to the
  # DICOM Standard, Part 8, Chapter 9.3.7.
  #
  class AssociationReleaseResponse < BinData::Record

    endian :big
    # The PDU type code.
    string :type, :length => 1, :asserted_value => "\x06"
    string :reserved1, :length => 1, :initial_value => "\x00"
    # The PDU length.
    uint32 :len, :value => 4
    string :reserved2, :length => 4, :initial_value => "\x00\x00\x00\x00"

  end

end