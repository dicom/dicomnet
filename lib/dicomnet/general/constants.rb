module DICOMNET

  # Ruby DICOM's registered DICOM UID root (Implementation Class UID).
  UID_ROOT = DICOM::UID_ROOT

  # Ruby DICOMNET name & version (max 16 characters).
  NAME = "RB_DCMNET_" + DICOM::VERSION

  # Implicit, little endian (the default transfer syntax).
  IMPLICIT_LITTLE_ENDIAN = "1.2.840.10008.1.2"
  # Explicit, little endian transfer syntax.
  EXPLICIT_LITTLE_ENDIAN = "1.2.840.10008.1.2.1"
  # Explicit, big endian transfer syntax.
  EXPLICIT_BIG_ENDIAN = "1.2.840.10008.1.2.2"

  # Verification SOP class UID.
  VERIFICATION_SOP = "1.2.840.10008.1.1"
  # Application context SOP class UID.
  APPLICATION_CONTEXT = "1.2.840.10008.3.1.1.1"

  # Network transmission successful.
  SUCCESS = 0
  # Network proposition accepted.
  ACCEPTANCE = 0
  # Presentation context rejected by abstract syntax.
  ABSTRACT_SYNTAX_REJECTED = 3
  # Presentation context rejected by transfer syntax.
  TRANSFER_SYNTAX_REJECTED = 4

  # Some network command element codes:
  C_STORE_RQ = 1 # (encodes to 0001H as US)
  C_GET_RQ = 16 # (encodes to 0010H as US)
  C_FIND_RQ = 32 # (encodes to 0020H as US)
  C_MOVE_RQ = 33 # (encodes to 0021H as US)
  C_ECHO_RQ = 48 # (encodes to 0030 as US)
  C_CANCEL_RQ = 4095 # (encodes to 0FFFH as US)
  C_STORE_RSP = 32769 # (encodes to 8001H as US)
  C_GET_RSP = 32784 # (encodes to 8010H as US)
  C_FIND_RSP = 32800 # (encodes to 8020H as US)
  C_MOVE_RSP = 32801 # (encodes to 8021H as US)
  C_ECHO_RSP = 32816 # (encodes to 8030H as US)
  NO_DATA_SET_PRESENT = 257 # (encodes to 0101H as US)
  DATA_SET_PRESENT = 1
  DEFAULT_MESSAGE_ID = 1

  # The network communication flags:
  DATA_MORE_FRAGMENTS = "00"
  COMMAND_MORE_FRAGMENTS = "01"
  DATA_LAST_FRAGMENT = "02"
  COMMAND_LAST_FRAGMENT = "03"

  # Network communication PDU types:
  PDU_ASSOCIATION_REQUEST = "01"
  PDU_ASSOCIATION_ACCEPT = "02"
  PDU_ASSOCIATION_REJECT = "03"
  PDU_DATA = "04"
  PDU_RELEASE_REQUEST = "05"
  PDU_RELEASE_RESPONSE = "06"
  PDU_ABORT = "07"

  # Network communication item types:
  ITEM_APPLICATION_CONTEXT = "10"
  ITEM_PRESENTATION_CONTEXT_REQUEST = "20"
  ITEM_PRESENTATION_CONTEXT_RESPONSE = "21"
  ITEM_ABSTRACT_SYNTAX = "30"
  ITEM_TRANSFER_SYNTAX = "40"
  ITEM_USER_INFORMATION = "50"
  ITEM_MAX_LENGTH = "51"
  ITEM_IMPLEMENTATION_UID = "52"
  ITEM_MAX_OPERATIONS_INVOKED = "53"
  ITEM_ROLE_NEGOTIATION = "54"
  ITEM_IMPLEMENTATION_VERSION = "55"

end

