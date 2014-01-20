module DICOMNET

  # The application context is the first structure in an association, following
  # the initial header, and is used to state the context for the communication.
  #
  # For more information about the Application context item structure, refer
  # to the DICOM Standard, Part 8, Chapter 9.3.2.1.
  #
  class ApplicationContext < BinData::Record

    endian :big
    # The PDU type code (10H).
    uint8 :type, :asserted_value => 16
    string :reserved1, :read_length => 1, :initial_value => "\x00"
    # The PDU length.
    uint16 :len, :value=>lambda {name.length}
    # Application context name.
    string :name, :read_length => :len, :initial_value => '1.2.840.10008.3.1.1.1'

  end

end