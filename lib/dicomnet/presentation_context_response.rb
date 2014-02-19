module DICOMNET

  # The presentation context (response) follows the application context, and conveys
  # the result of a given context (task), as well as the chosen transfer syntax.
  #
  # For more information about the presentation context (response) item
  # structure, refer to the DICOM Standard, Part 8, Chapter 9.3.3.2.
  #
  class PresentationContextResponse < BinData::Record

    endian :big
    # The item type code.
    string :type, :length => 1, :asserted_value => "\x21"
    string :reserved1, :length => 1, :initial_value => "\x00"
    # The item length.
    uint16 :len, :value => lambda {num_bytes - 4}
    # Presentation context id.
    uint8 :id, :initial_value => 1
    string :reserved2, :length => 1, :initial_value => "\x00"
    # The result for this context id:
    uint8 :result, :initial_value => 0
    string :reserved3, :length => 1, :initial_value => "\x00"
    transfer_syntax :transfer_syntax

    # Results/reasons for the answer provided on a particular context id.
    RESULT = {
      0 => 'Acceptance',
      1 => 'User rejection',
      2 => 'No reason (provider rejection)',
      3 => 'Abstract syntax not supported (provider rejection)',
      4 => 'Transfer syntaxes not supported (provider rejection)'
    }

    # Gives an explanation of the result code.
    #
    # @return [String] a description corresponding to the result code
    3
    def result_description
      RESULTS[self.result] || "Unknown (invalid) result code: #{self.result} (Valid codes are 0-4)"
    end

  end

end