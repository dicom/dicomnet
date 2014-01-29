module DICOMNET

  # The presentation context follows the application context, and conveys
  # the purpose as well as the preferred encoding to use for a specific task.
  # The presentation context contains one abstract syntax and one or serveral
  # transfer syntaxes.
  #
  # For more information about the Presentation context item structure, refer
  # to the DICOM Standard, Part 8, Chapter 9.3.2.2.
  #
  class PresentationContext < BinData::Record

    endian :big
    # The item type code (10H).
    string :type, :read_length => 1, :asserted_value => "\x20"
    string :reserved1, :read_length => 1, :initial_value => "\x00"
    # The item length.
    uint16 :len, :value => lambda {num_bytes - 4}
    # Presentation context id.
    uint8 :id, :initial_value => 1
    string :reserved2, :read_length => 1, :initial_value => "\x00"
    string :reserved3, :read_length => 1, :initial_value => "\x00"
    string :reserved4, :read_length => 1, :initial_value => "\x00"
    abstract_syntax :abstract_syntax
    array :transfer_syntaxes, :type => :transfer_syntax, :read_until => lambda {(len - 4) == (abstract_syntax.num_bytes + transfer_syntaxes.num_bytes)}

    # Resets the transfer syntaxes array with a one-element array containing
    # the given transfer syntax.
    #
    def transfer_syntax=(ts)
      raise "Expected TransferSyntax, got #{ts.class}" unless ts.is_a?(TransferSyntax)
      self.transfer_syntaxes = [ts]
    end

  end

end