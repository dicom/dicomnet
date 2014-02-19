module DICOMNET

  # The transfer syntax sub-item is part of the presentation context, and
  # conveys the encoding regimen to use for the communication.
  #
  # For more information about the transfer syntax sub-item structure, refer
  # to the DICOM Standard, Part 8, Chapters 9.3.2.2.2 and 9.3.3.2.1.
  #
  class TransferSyntax < BinData::Record

    endian :big
    # The item type code.
    string :type, :length => 1, :asserted_value => "\x40"
    string :reserved1, :length => 1, :initial_value => "\x00"
    # The item length.
    uint16 :len, :value => lambda {num_bytes - 4}
    # Transfer syntax name.
    string :name, :read_length => :len

  end

end