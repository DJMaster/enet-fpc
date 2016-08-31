//
// enet.h header binding for the Free Pascal Compiler aka FPC
//
// Binaries and demos available at http://www.djmaster.com/
//

(** 
 @file  protocol.h
 @brief ENet protocol
*)

const
  ENET_PROTOCOL_MINIMUM_MTU = 576;
  ENET_PROTOCOL_MAXIMUM_MTU = 4096;
  ENET_PROTOCOL_MAXIMUM_PACKET_COMMANDS = 32;
  ENET_PROTOCOL_MINIMUM_WINDOW_SIZE = 4096;
  ENET_PROTOCOL_MAXIMUM_WINDOW_SIZE = 65536;
  ENET_PROTOCOL_MINIMUM_CHANNEL_COUNT = 1;
  ENET_PROTOCOL_MAXIMUM_CHANNEL_COUNT = 255;
  ENET_PROTOCOL_MAXIMUM_PEER_ID = $FFF;
  ENET_PROTOCOL_MAXIMUM_FRAGMENT_COUNT = 1024 * 1024;

const
  ENET_PROTOCOL_COMMAND_NONE = 0;
  ENET_PROTOCOL_COMMAND_ACKNOWLEDGE = 1;
  ENET_PROTOCOL_COMMAND_CONNECT = 2;
  ENET_PROTOCOL_COMMAND_VERIFY_CONNECT = 3;
  ENET_PROTOCOL_COMMAND_DISCONNECT = 4;
  ENET_PROTOCOL_COMMAND_PING = 5;
  ENET_PROTOCOL_COMMAND_SEND_RELIABLE = 6;
  ENET_PROTOCOL_COMMAND_SEND_UNRELIABLE = 7;
  ENET_PROTOCOL_COMMAND_SEND_FRAGMENT = 8;
  ENET_PROTOCOL_COMMAND_SEND_UNSEQUENCED = 9;
  ENET_PROTOCOL_COMMAND_BANDWIDTH_LIMIT = 10;
  ENET_PROTOCOL_COMMAND_THROTTLE_CONFIGURE = 11;
  ENET_PROTOCOL_COMMAND_SEND_UNRELIABLE_FRAGMENT = 12;
  ENET_PROTOCOL_COMMAND_COUNT = 13;

  ENET_PROTOCOL_COMMAND_MASK = $0F;


  ENET_PROTOCOL_COMMAND_FLAG_ACKNOWLEDGE = (1 shl 7);
  ENET_PROTOCOL_COMMAND_FLAG_UNSEQUENCED = (1 shl 6);

  ENET_PROTOCOL_HEADER_FLAG_COMPRESSED = (1 shl 14);
  ENET_PROTOCOL_HEADER_FLAG_SENT_TIME = (1 shl 15);
  ENET_PROTOCOL_HEADER_FLAG_MASK = ENET_PROTOCOL_HEADER_FLAG_COMPRESSED or ENET_PROTOCOL_HEADER_FLAG_SENT_TIME;

  ENET_PROTOCOL_HEADER_SESSION_MASK = (3 shl 12);
  ENET_PROTOCOL_HEADER_SESSION_SHIFT = 12;

//TODO #ifdef _MSC_VER
//TODO #pragma pack(push, 1)
//TODO #define ENET_PACKED
//TODO #elif defined(__GNUC__) || defined(__clang__)
//TODO #define ENET_PACKED __attribute__ ((packed))
//TODO #else
//TODO #define ENET_PACKED
//TODO #endif

type
  PENetProtocolHeader = ^ENetProtocolHeader;
  ENetProtocolHeader = packed record
    peerID: enet_uint16;
    sentTime: enet_uint16;
  end;

  PENetProtocolCommandHeader = ^ENetProtocolCommandHeader;
  ENetProtocolCommandHeader = packed record
    command: enet_uint8;
    channelID: enet_uint8;
    reliableSequenceNumber: enet_uint16;
  end;

  PENetProtocolAcknowledge = ^ENetProtocolAcknowledge;
  ENetProtocolAcknowledge = packed record
    header: ENetProtocolCommandHeader;
    receivedReliableSequenceNumber: enet_uint16;
    receivedSentTime: enet_uint16;
  end;

  PENetProtocolConnect = ^ENetProtocolConnect;
  ENetProtocolConnect = packed record
    header: ENetProtocolCommandHeader;
    outgoingPeerID: enet_uint16;
    incomingSessionID: enet_uint8;
    outgoingSessionID: enet_uint8;
    mtu: enet_uint32;
    windowSize: enet_uint32;
    channelCount: enet_uint32;
    incomingBandwidth: enet_uint32;
    outgoingBandwidth: enet_uint32;
    packetThrottleInterval: enet_uint32;
    packetThrottleAcceleration: enet_uint32;
    packetThrottleDeceleration: enet_uint32;
    connectID: enet_uint32;
    data: enet_uint32;
  end;

  PENetProtocolVerifyConnect = ^ENetProtocolVerifyConnect;
  ENetProtocolVerifyConnect = packed record
    header: ENetProtocolCommandHeader;
    outgoingPeerID: enet_uint16;
    incomingSessionID: enet_uint8;
    outgoingSessionID: enet_uint8;
    mtu: enet_uint32;
    windowSize: enet_uint32;
    channelCount: enet_uint32;
    incomingBandwidth: enet_uint32;
    outgoingBandwidth: enet_uint32;
    packetThrottleInterval: enet_uint32;
    packetThrottleAcceleration: enet_uint32;
    packetThrottleDeceleration: enet_uint32;
    connectID: enet_uint32;
  end;

  PENetProtocolBandwidthLimit = ^ENetProtocolBandwidthLimit;
  ENetProtocolBandwidthLimit = packed record
    header: ENetProtocolCommandHeader;
    incomingBandwidth: enet_uint32;
    outgoingBandwidth: enet_uint32;
  end;

  PENetProtocolThrottleConfigure = ^ENetProtocolThrottleConfigure;
  ENetProtocolThrottleConfigure = packed record
    header: ENetProtocolCommandHeader;
    packetThrottleInterval: enet_uint32;
    packetThrottleAcceleration: enet_uint32;
    packetThrottleDeceleration: enet_uint32;
  end;

  PENetProtocolDisconnect = ^ENetProtocolDisconnect;
  ENetProtocolDisconnect = packed record
    header: ENetProtocolCommandHeader;
    data: enet_uint32;
  end;

  PENetProtocolPing = ^ENetProtocolPing;
  ENetProtocolPing = packed record
    header: ENetProtocolCommandHeader;
  end;

  PENetProtocolSendReliable = ^ENetProtocolSendReliable;
  ENetProtocolSendReliable = packed record
    header: ENetProtocolCommandHeader;
    dataLength: enet_uint16;
  end;

  PENetProtocolSendUnreliable = ^ENetProtocolSendUnreliable;
  ENetProtocolSendUnreliable = packed record
    header: ENetProtocolCommandHeader;
    unreliableSequenceNumber: enet_uint16;
    dataLength: enet_uint16;
  end;

  PENetProtocolSendUnsequenced = ^ENetProtocolSendUnsequenced;
  ENetProtocolSendUnsequenced = packed record
    header: ENetProtocolCommandHeader;
    unsequencedGroup: enet_uint16;
    dataLength: enet_uint16;
  end;

  PENetProtocolSendFragment = ^ENetProtocolSendFragment;
  ENetProtocolSendFragment = packed record
    header: ENetProtocolCommandHeader;
    startSequenceNumber: enet_uint16;
    dataLength: enet_uint16;
    fragmentCount: enet_uint32;
    fragmentNumber: enet_uint32;
    totalLength: enet_uint32;
    fragmentOffset: enet_uint32;
  end;

  PENetProtocol = ^ENetProtocol;
  ENetProtocol = packed record
    header: ENetProtocolCommandHeader;
    acknowledge: ENetProtocolAcknowledge;
    connect: ENetProtocolConnect;
    verifyConnect: ENetProtocolVerifyConnect;
    disconnect: ENetProtocolDisconnect;
    ping: ENetProtocolPing;
    sendReliable: ENetProtocolSendReliable;
    sendUnreliable: ENetProtocolSendUnreliable;
    sendUnsequenced: ENetProtocolSendUnsequenced;
    sendFragment: ENetProtocolSendFragment;
    bandwidthLimit: ENetProtocolBandwidthLimit;
    throttleConfigure: ENetProtocolThrottleConfigure;
  end;

//TODO #ifdef _MSC_VER
//TODO #pragma pack(pop)
//TODO #endif

