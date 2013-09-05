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
FileUtils.mkdir(DICOMNET::TMPDIR)
FileUtils.mkdir(DICOMNET::LOGDIR)