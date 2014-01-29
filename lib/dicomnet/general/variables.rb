module DICOMNET

  class << self

    #--
    # Module attributes:
    #++

    # The implemenation uid given by dicomnet.
    attr_accessor :implementation_uid
    # The implemenation version given by dicomnet.
    attr_accessor :implementation_version
    # The maximum network package size proposed by dicomnet.
    attr_accessor :max_package_size

  end

  #--
  # Default variable settings:
  #++

  # The default implementation uid.
  self.implementation_uid = DICOM::UID_ROOT
  # The default implementation version (max 16 characters).
  self.implementation_version = "RB_DCMNET_" + DICOMNET::VERSION
  # The default maximum network package size.
  self.max_package_size = 32768 # 16384

end