module DICOMNET

  # The abstract syntax sub-item is part of the presentation context, and
  # communicates a desired action/purpose to be achieved.
  #
  # For more information about the Abstract syntax sub-item structure, refer
  # to the DICOM Standard, Part 8, Chapter 9.3.2.2.1.
  #
  class AbstractSyntax < BinData::Record

    endian :big
    # The item type code (30H).
    string :type, :length => 1, :asserted_value => "\x30"
    string :reserved1, :length => 1, :initial_value => "\x00"
    # The item length.
    uint16 :len, :value => lambda {num_bytes - 4}
    # Abstract syntax name.
    string :name, :read_length => :len

  end

end