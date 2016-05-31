# encoding: UTF-8

require File.dirname(__FILE__) + '/../lib/dicomnet'

RSpec.configure do |config|
  config.mock_with :mocha
end

# Defining constants for the sample DICOM files that are used in the specification,
# while suppressing the annoying warnings when these constants are initialized.
module Kernel
  def suppress_warnings
    original_verbosity = $VERBOSE
    $VERBOSE = nil
    result = yield
    $VERBOSE = original_verbosity
    return result
  end
end

suppress_warnings do
  # Application context:
  DICOMNET::ACX = 'samples/application_context.bin'
  # Association accept:
  DICOMNET::A_AC = 'samples/association_accept_1pc.bin'
  DICOMNET::A_AC_2PC = 'samples/association_accept_2pc.bin'
  # Association reject:
  DICOMNET::A_RJ = 'samples/association_reject.bin'
  # Association request:
  DICOMNET::A_RQ = 'samples/association_request_1_pc_3_ts.bin'
  DICOMNET::A_RQ_2PC = 'samples/association_request_2_pc_2_ts.bin'
  # Abstract syntax:
  DICOMNET::ASX = 'samples/abstract_syntax_mr.bin'
  # Presentation context (request):
  DICOMNET::PC_RQ = 'samples/presentation_context_request_1_ts.bin'
  DICOMNET::PC_RQ_2TS = 'samples/presentation_context_request_2_ts_id5.bin'
  # Presentation context (response):
  DICOMNET::PC_RP = 'samples/presentation_context_response_id3.bin'
  # Transfer syntax:
  DICOMNET::TSX = 'samples/transfer_syntax_implicit_little.bin'
  # User information:
  DICOMNET::USER_INFO = 'samples/user_information.bin'
  DICOMNET::USER_INFO_UNKNOWN_ITEM = 'samples/user_information_with_unknown_item_x99_asdf.bin'
  # Sample DICOM files:
  DICOMNET::DCM_IMPLICIT = 'samples/implicit_mr_16bit_mono2.dcm'
  DICOMNET::DCM_EXPLICIT = 'samples/explicit_rtdose_16bit_mono2_3d-volume.dcm'
  DICOMNET::DCM_IMPLICIT_JPEG2K = 'samples/implicit_us_jpeg2k-lossless-mono2-multiframe.dcm'
  DICOMNET::DCM_EXPLICIT_JPEG = 'samples/explicit_mr_jpeg-lossy_mono2.dcm'
  DICOMNET::DCM_EXPLICIT_RLE = 'samples/explicit_mr_rle_mono2.dcm'
  # Directory for writing temporary files:
  DICOMNET::TMPDIR = "tmp/"
  DICOMNET::LOGDIR = DICOMNET::TMPDIR + "logs/"
end

# Create a directory for temporary files (and delete the directory if it already exists):
require 'fileutils'
FileUtils.rmtree(DICOMNET::TMPDIR) if File.directory?(DICOMNET::TMPDIR)
sleep(0.001) # (For some reason, a small delay is needed here to avoid sporadic exceptions)
FileUtils.mkdir(DICOMNET::TMPDIR)
FileUtils.mkdir(DICOMNET::LOGDIR)