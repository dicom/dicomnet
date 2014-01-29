module DICOMNET

  # This class is used as to store items contained in an association before
  # they are assigned for specific decoding based on their type. Generally
  # there will be 3 types of items decoded as a context item:
  # -Application Context
  # -Presentation Context
  # -User Information
  #
  class ContextItem < BinData::Record

    endian :big
    # The item type code.
    string :type, :length => 1
    string :reserved1, :length => 1, :initial_value => "\x00"
    # The item length.
    uint16 :len, :value => lambda {num_bytes - 4}
    # The data, which may contain a simple string value (in the case of an
    # application context item, or a sub item data structure (in the case of a
    # presentation context or user information item).
    string :data, :read_length => :len

  end

end