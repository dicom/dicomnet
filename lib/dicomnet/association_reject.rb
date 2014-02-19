module DICOMNET

  # The association reject notification is used when the DICOM host
  # turns down the request for communication in its entirety, meaning that
  # none of the proposed presentation contexts were supported.
  # Issuing an association reject effectively terminates the communication.
  #
  # For more information about the A-ASSOCIATE-RJ  PDU structure, refer to the
  # DICOM Standard, Part 8, Chapter 9.3.4.
  #
  class AssociationReject < BinData::Record

    endian :big
    # The PDU type code.
    string :type, :length => 1, :asserted_value => "\x03"
    string :reserved1, :length => 1, :initial_value => "\x00"
    # The PDU length.
    uint32 :len, :value => 4
    string :reserved2, :length => 1, :initial_value => "\x00"
    # The general result of this rejection.
    uint8 :result, :initial_value => 1
    # The source causing the rejection (client or host).
    uint8 :source, :initial_value => 1
    # The specific reason for the rejection.
    uint8 :reason, :initial_value => 0

    # Explanations for the rejection reason (depends on the source value).
    REASONS = Hash.new
    REASONS[1] = {
      1 => 'No reason given',
      2 => 'Application context name not supported',
      3 => 'Calling AE title not recognized',
      4 => 'Reserved',
      5 => 'Reserved',
      6 => 'Reserved',
      7 => 'Called AE title not recognized',
      8 => 'Reserved',
      9 => 'Reserved',
      10 => 'Reserved'
    }
    REASONS[2] = {
      1 => 'No reason given',
      2 => 'Protocol version not supported'
    }
    REASONS[3] = {
      0 => 'Reserved',
      1 => 'Temporary congestion',
      2 => 'Local limit exceeded',
      3 => 'Reserved',
      4 => 'Reserved',
      5 => 'Reserved',
      6 => 'Reserved',
      7 => 'Reserved'
    }

    # Explanations for the rejection result.
    RESULTS = {
      1 => 'Rejected - permanent',
      2 => 'Rejected - transient'
    }

    # Explanations for the source of the rejection.
    SOURCES = {
      1 => 'DICOM UL service: User',
      2 => 'DICOM UL service: Provider (ACSE related function)',
      3 => 'DICOM UL service: Provider (Presentation related function)'
    }

    # Gives an explanation of the reason code.
    #
    # @return [String] a description corresponding to the reason code
    #
    def reason_description
      REASONS[self.source] && REASONS[self.source][self.reason] || "Unknown (invalid) source/reason code combination: #{self.source}/#{self.reason} (Valid combinations are source 1 and reason 1-10, source 2 and reason 1-2 or source 3 and reason 0-7)"
    end

    # Gives an explanation of the result code.
    #
    # @return [String] a description corresponding to the result code
    #
    def result_description
      RESULTS[self.result] || "Unknown (invalid) result code: #{self.result} (Valid codes are 1-2)"
    end

    # Gives an explanation of the source code.
    #
    # @return [String] a description corresponding to the source code
    #
    def source_description
      SOURCES[self.source] || "Unknown (invalid) source code: #{self.source} (Valid codes are 1-3)"
    end

  end

end