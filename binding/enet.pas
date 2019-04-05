//
// enet.h header binding for the Free Pascal Compiler aka FPC
//
// Binaries and demos available at http://www.djmaster.com/
//

(** 
 @file  enet.h
 @brief ENet public header file
*)

unit enet;

{$mode objfpc}{$H+}
{$inline on}

interface

uses
  ctypes{$ifdef MSWINDOWS}, winsock2{$endif};

const
  LIB_ENET = 'libenet-7.dll';

  ENET_VERSION_MAJOR = 1;
  ENET_VERSION_MINOR = 3;
  ENET_VERSION_PATCH = 14;


{$ifdef MSWINDOWS}
{$include enet_win32.inc}
{$endif}
{$ifdef UNIX}
{$include enet_unix.inc}
{$endif}

{$include enet_types.inc}
{$include enet_protocol.inc}
{$include enet_list.inc}
{$include enet_callbacks.inc}


function ENET_VERSION_CREATE(major: cint; minor: cint; patch: cint): cint; cdecl; inline;
function ENET_VERSION_GET_MAJOR(version: cint): cint; cdecl; inline;
function ENET_VERSION_GET_MINOR(version: cint): cint; cdecl; inline;
function ENET_VERSION_GET_PATCH(version: cint): cint; cdecl; inline;

type
  ENetPeerState = cint;
const
  ENET_PEER_STATE_DISCONNECTED = 0;
  ENET_PEER_STATE_CONNECTING = 1;
  ENET_PEER_STATE_ACKNOWLEDGING_CONNECT = 2;
  ENET_PEER_STATE_CONNECTION_PENDING = 3;
  ENET_PEER_STATE_CONNECTION_SUCCEEDED = 4;
  ENET_PEER_STATE_CONNECTED = 5;
  ENET_PEER_STATE_DISCONNECT_LATER = 6;
  ENET_PEER_STATE_DISCONNECTING = 7;
  ENET_PEER_STATE_ACKNOWLEDGING_DISCONNECT = 8;
  ENET_PEER_STATE_ZOMBIE = 9;

//TODO #ifndef ENET_BUFFER_MAXIMUM
  ENET_BUFFER_MAXIMUM = (1 + 2 * ENET_PROTOCOL_MAXIMUM_PACKET_COMMANDS);
//TODO #endif

   ENET_HOST_RECEIVE_BUFFER_SIZE = 256 * 1024;
   ENET_HOST_SEND_BUFFER_SIZE = 256 * 1024;
   ENET_HOST_BANDWIDTH_THROTTLE_INTERVAL = 1000;
   ENET_HOST_DEFAULT_MTU = 1400;
   ENET_HOST_DEFAULT_MAXIMUM_PACKET_SIZE = 32 * 1024 * 1024;
   ENET_HOST_DEFAULT_MAXIMUM_WAITING_DATA = 32 * 1024 * 1024;

   ENET_PEER_DEFAULT_ROUND_TRIP_TIME = 500;
   ENET_PEER_DEFAULT_PACKET_THROTTLE = 32;
   ENET_PEER_PACKET_THROTTLE_SCALE = 32;
   ENET_PEER_PACKET_THROTTLE_COUNTER = 7;
   ENET_PEER_PACKET_THROTTLE_ACCELERATION = 2;
   ENET_PEER_PACKET_THROTTLE_DECELERATION = 2;
   ENET_PEER_PACKET_THROTTLE_INTERVAL = 5000;
   ENET_PEER_PACKET_LOSS_SCALE = 1 shl 16;
   ENET_PEER_PACKET_LOSS_INTERVAL = 10000;
   ENET_PEER_WINDOW_SIZE_SCALE = 64 * 1024;
   ENET_PEER_TIMEOUT_LIMIT = 32;
   ENET_PEER_TIMEOUT_MINIMUM = 5000;
   ENET_PEER_TIMEOUT_MAXIMUM = 30000;
   ENET_PEER_PING_INTERVAL_ = 500;
   ENET_PEER_UNSEQUENCED_WINDOWS = 64;
   ENET_PEER_UNSEQUENCED_WINDOW_SIZE = 1024;
   ENET_PEER_FREE_UNSEQUENCED_WINDOWS = 32;
   ENET_PEER_RELIABLE_WINDOWS = 16;
   ENET_PEER_RELIABLE_WINDOW_SIZE = $1000;
   ENET_PEER_FREE_RELIABLE_WINDOWS = 8;

type
  ENetVersion = enet_uint32;

  PENetAddress = ^ENetAddress;
  PENetChannel = ^ENetChannel;
  PENetHost = ^ENetHost;
  PENetPeer = ^ENetPeer;
  PENetEvent = ^ENetEvent;

(**
 * Portable internet address structure. 
 *
 * The host must be specified in network byte-order, and the port must be in host 
 * byte-order. The constant ENET_HOST_ANY may be used to specify the default 
 * server host. The constant ENET_HOST_BROADCAST may be used to specify the
 * broadcast address (255.255.255.255).  This makes sense for enet_host_connect,
 * but not for enet_host_create.  Once a server responds to a broadcast, the
 * address is updated from ENET_HOST_BROADCAST to the server's actual IP address.
 *)
  ENetAddress = record
    host: enet_uint32;
    port: enet_uint16;
  end;

  ENetChannel = record
    outgoingReliableSequenceNumber: enet_uint16;
    outgoingUnreliableSequenceNumber: enet_uint16;
    usedReliableWindows: enet_uint16;
    reliableWindows: array[0..ENET_PEER_RELIABLE_WINDOWS-1] of enet_uint16;
    incomingReliableSequenceNumber: enet_uint16;
    incomingUnreliableSequenceNumber: enet_uint16;
    incomingReliableCommands: ENetList;
    incomingUnreliableCommands: ENetList;
  end;

(**
 * An ENet peer which data packets may be sent or received from. 
 *
 * No fields should be modified unless otherwise specified. 
 *)
  ENetPeer = record
    dispatchList: ENetListNode;
    host: PENetHost;
    outgoingPeerID: enet_uint16;
    incomingPeerID: enet_uint16;
    connectID: enet_uint32;
    outgoingSessionID: enet_uint8;
    incomingSessionID: enet_uint8;
    address: ENetAddress; (**< Internet address of the peer *)
    data: pointer; (**< Application private data, may be freely modified *)
    state: ENetPeerState;
    channels: PENetChannel;
    channelCount: csize_t; (**< Number of channels allocated for communication with peer *)
    incomingBandwidth: enet_uint32; (**< Downstream bandwidth of the client in bytes/second *)
    outgoingBandwidth: enet_uint32; (**< Upstream bandwidth of the client in bytes/second *)
    incomingBandwidthThrottleEpoch: enet_uint32;
    outgoingBandwidthThrottleEpoch: enet_uint32;
    incomingDataTotal: enet_uint32;
    outgoingDataTotal: enet_uint32;
    lastSendTime: enet_uint32;
    lastReceiveTime: enet_uint32;
    nextTimeout: enet_uint32;
    earliestTimeout: enet_uint32;
    packetLossEpoch: enet_uint32;
    packetsSent: enet_uint32;
    packetsLost: enet_uint32;
    packetLoss: enet_uint32; (**< mean packet loss of reliable packets as a ratio with respect to the constant ENET_PEER_PACKET_LOSS_SCALE *)
    packetLossVariance: enet_uint32;
    packetThrottle: enet_uint32;
    packetThrottleLimit: enet_uint32;
    packetThrottleCounter: enet_uint32;
    packetThrottleEpoch: enet_uint32;
    packetThrottleAcceleration: enet_uint32;
    packetThrottleDeceleration: enet_uint32;
    packetThrottleInterval: enet_uint32;
    pingInterval: enet_uint32;
    timeoutLimit: enet_uint32;
    timeoutMinimum: enet_uint32;
    timeoutMaximum: enet_uint32;
    lastRoundTripTime: enet_uint32;
    lowestRoundTripTime: enet_uint32;
    lastRoundTripTimeVariance: enet_uint32;
    highestRoundTripTimeVariance: enet_uint32;
    roundTripTime: enet_uint32; (**< mean round trip time (RTT), in milliseconds, between sending a reliable packet and receiving its acknowledgement *)
    roundTripTimeVariance: enet_uint32;
    mtu: enet_uint32;
    windowSize: enet_uint32;
    reliableDataInTransit: enet_uint32;
    outgoingReliableSequenceNumber: enet_uint16;
    acknowledgements: ENetList;
    sentReliableCommands: ENetList;
    sentUnreliableCommands: ENetList;
    outgoingReliableCommands: ENetList;
    outgoingUnreliableCommands: ENetList;
    dispatchedCommands: ENetList;
    needsDispatch: cint;
    incomingUnsequencedGroup: enet_uint16;
    outgoingUnsequencedGroup: enet_uint16;
    unsequencedWindow: array[0..(ENET_PEER_UNSEQUENCED_WINDOW_SIZE div 32)-1] of enet_uint32; 
    eventData: enet_uint32;
    totalWaitingData: csize_t;
  end;

(** An ENet packet compressor for compressing UDP packets before socket sends or receives.
 *)
  ENetCompressCallback = function (context: pointer; const inBuffers: PENetBuffer; inBufferCount: csize_t; inLimit: csize_t; outData: penet_uint8; outLimit: csize_t): csize_t; cdecl;
  ENetDecompressCallback = function (context: pointer; const inData: penet_uint8; inLimit: csize_t; outData: penet_uint8; outLimit: csize_t): csize_t; cdecl;
  ENetDestroyCallback = procedure (context: pointer); cdecl;
  
  PENetCompressor = ^ENetCompressor;
  ENetCompressor = record
    (** Context data for the compressor. Must be non-NULL. *)
    context: pointer;
    (** Compresses from inBuffers[0:inBufferCount-1], containing inLimit bytes, to outData, outputting at most outLimit bytes. Should return 0 on failure. *)
    compress: ENetCompressCallback;
    (** Decompresses from inData, containing inLimit bytes, to outData, outputting at most outLimit bytes. Should return 0 on failure. *)
    decompress: ENetDecompressCallback;
    (** Destroys the context when compression is disabled or the host is destroyed. May be NULL. *)
    destroy: ENetDestroyCallback;
  end;

(** Callback that computes the checksum of the data held in buffers[0:bufferCount-1] *)
  ENetChecksumCallback = function (const buffers: PENetBuffer; bufferCount: csize_t): enet_uint32; cdecl;

(** Callback for intercepting received raw UDP packets. Should return 1 to intercept, 0 to ignore, or -1 to propagate an error. *)
  ENetInterceptCallback = function (host: PENetHost; event: PENetEvent): cint; cdecl;

(** An ENet host for communicating with peers.
  *
  * No fields should be modified unless otherwise stated.

    @sa enet_host_create()
    @sa enet_host_destroy()
    @sa enet_host_connect()
    @sa enet_host_service()
    @sa enet_host_flush()
    @sa enet_host_broadcast()
    @sa enet_host_compress()
    @sa enet_host_compress_with_range_coder()
    @sa enet_host_channel_limit()
    @sa enet_host_bandwidth_limit()
    @sa enet_host_bandwidth_throttle()
  *)
  ENetHost = record
    socket: ENetSocket;
    address: ENetAddress; (**< Internet address of the host *)
    incomingBandwidth: enet_uint32; (**< downstream bandwidth of the host *)
    outgoingBandwidth: enet_uint32; (**< upstream bandwidth of the host *)
    bandwidthThrottleEpoch: enet_uint32;
    mtu: enet_uint32;
    randomSeed: enet_uint32;
    recalculateBandwidthLimits: cint;
    peers: PENetPeer; (**< array of peers allocated for this host *)
    peerCount: csize_t; (**< number of peers allocated for this host *)
    channelLimit: csize_t; (**< maximum number of channels allowed for connected peers *)
    serviceTime: enet_uint32;
    dispatchQueue: ENetList;
    continueSending: cint;
    packetSize: csize_t;
    headerFlags: enet_uint16;
    commands: array[0..ENET_PROTOCOL_MAXIMUM_PACKET_COMMANDS-1] of ENetProtocol;
    commandCount: csize_t;
    buffers: array[0..ENET_BUFFER_MAXIMUM-1] of ENetBuffer;
    bufferCount: csize_t;
    checksum: ENetChecksumCallback; (**< callback the user can set to enable packet checksums for this host *)
    compressor: ENetCompressor;
    packetData: array [0..1, 0..ENET_PROTOCOL_MAXIMUM_MTU-1] of enet_uint8;
    receivedAddress: ENetAddress;
    receivedData: penet_uint8;
    receivedDataLength: csize_t;
    totalSentData: enet_uint32; (**< total data sent, user should reset to 0 as needed to prevent overflow *)
    totalSentPackets: enet_uint32; (**< total UDP packets sent, user should reset to 0 as needed to prevent overflow *)
    totalReceivedData: enet_uint32; (**< total data received, user should reset to 0 as needed to prevent overflow *)
    totalReceivedPackets: enet_uint32; (**< total UDP packets received, user should reset to 0 as needed to prevent overflow *)
    intercept: ENetInterceptCallback; (**< callback the user can set to intercept received raw UDP packets *)
    connectedPeers: csize_t;
    bandwidthLimitedPeers: csize_t;
    duplicatePeers: csize_t; (**< optional number of allowed peers from duplicate IPs, defaults to ENET_PROTOCOL_MAXIMUM_PEER_ID *)
    maximumPacketSize: csize_t; (**< the maximum allowable packet size that may be sent or received on a peer *)
    maximumWaitingData: csize_t; (**< the maximum aggregate amount of buffer space a peer may use waiting for packets to be delivered *)
  end;

(**
 * An ENet event type, as specified in @ref ENetEvent.
 *)
  PENetEventType = ^ENetEventType;
  ENetEventType = (
    (** no event occurred within the specified time limit *)
    ENET_EVENT_TYPE_NONE = 0,  
 
    (** a connection request initiated by enet_host_connect has completed.  
      * The peer field contains the peer which successfully connected. 
      *)
    ENET_EVENT_TYPE_CONNECT = 1,  
 
    (** a peer has disconnected.  This event is generated on a successful 
      * completion of a disconnect initiated by enet_peer_disconnect, if 
      * a peer has timed out, or if a connection request intialized by 
      * enet_host_connect has timed out.  The peer field contains the peer 
      * which disconnected. The data field contains user supplied data 
      * describing the disconnection, or 0, if none is available.
      *)
    ENET_EVENT_TYPE_DISCONNECT = 2,  
 
    (** a packet has been received from a peer.  The peer field specifies the
      * peer which sent the packet.  The channelID field specifies the channel
      * number upon which the packet was received.  The packet field contains
      * the packet that was received; this packet must be destroyed with
      * enet_packet_destroy after use.
      *)
    ENET_EVENT_TYPE_RECEIVE = 3
  );

(**
 * ENet packet structure.
 *
 * An ENet data packet that may be sent to or received from a peer. The shown 
 * fields should only be read and never modified. The data field contains the 
 * allocated data for the packet. The dataLength fields specifies the length 
 * of the allocated data.  The flags field is either 0 (specifying no flags), 
 * or a bitwise-or of any combination of the following flags:
 *
 *    ENET_PACKET_FLAG_RELIABLE - packet must be received by the target peer
 *    and resend attempts should be made until the packet is delivered
 *
 *    ENET_PACKET_FLAG_UNSEQUENCED - packet will not be sequenced with other packets 
 *    (not supported for reliable packets)
 *
 *    ENET_PACKET_FLAG_NO_ALLOCATE - packet will not allocate data, and user must supply it instead
 *
 *    ENET_PACKET_FLAG_UNRELIABLE_FRAGMENT - packet will be fragmented using unreliable
 *    (instead of reliable) sends if it exceeds the MTU
 *
 *    ENET_PACKET_FLAG_SENT - whether the packet has been sent from all queues it has been entered into
   @sa ENetPacketFlag
 *)
  PENetPacket = ^ENetPacket;
  ENetPacketFreeCallback = procedure(struct: PENetPacket);
  ENetPacket = record
    referenceCount: csize_t; (**< internal use only *)
    flags: enet_uint32; (**< bitwise-or of ENetPacketFlag constants *)
    data: penet_uint8; (**< allocated data for packet *)
    dataLength: csize_t; (**< length of data *)
    freeCallback: ENetPacketFreeCallback; (**< function to be called when the packet is no longer in use *)
    userData: pointer; (**< application private data, may be freely modified *)
  end;

(**
 * An ENet event as returned by enet_host_service().
   
   @sa enet_host_service
 *)
  ENetEvent = record
    type_: ENetEventType; (**< type of the event *)
    peer: PENetPeer; (**< peer that generated a connect, disconnect or receive event *)
    channelID: enet_uint8; (**< channel on the peer that generated the event, if appropriate *)
    data: enet_uint32; (**< data associated with the event, if appropriate *)
    packet: PENetPacket; (**< packet associated with the event, if appropriate *)
  end;

  PENetSocketType = ^ENetSocketType;
  ENetSocketType = (
    ENET_SOCKET_TYPE_STREAM = 1,
    ENET_SOCKET_TYPE_DATAGRAM = 2
  );

  PENetSocketWait = ^ENetSocketWait;
  ENetSocketWait = (
    ENET_SOCKET_WAIT_NONE = 0,
    ENET_SOCKET_WAIT_SEND = 1,
    ENET_SOCKET_WAIT_RECEIVE = 2,
    ENET_SOCKET_WAIT_INTERRUPT = 4
  );

  PENetSocketOption = ^ENetSocketOption;
  ENetSocketOption = (
    ENET_SOCKOPT_NONBLOCK = 1,
    ENET_SOCKOPT_BROADCAST = 2,
    ENET_SOCKOPT_RCVBUF = 3,
    ENET_SOCKOPT_SNDBUF = 4,
    ENET_SOCKOPT_REUSEADDR = 5,
    ENET_SOCKOPT_RCVTIMEO = 6,
    ENET_SOCKOPT_SNDTIMEO = 7,
    ENET_SOCKOPT_ERROR = 8,
    ENET_SOCKOPT_NODELAY = 9
  );

  PENetSocketShutdown = ^ENetSocketShutdown;
  ENetSocketShutdown = (
    ENET_SOCKET_SHUTDOWN_READ = 0,
    ENET_SOCKET_SHUTDOWN_WRITE = 1,
    ENET_SOCKET_SHUTDOWN_READ_WRITE = 2
  );

const
  ENET_HOST_ANY = 0;
  ENET_HOST_BROADCAST_ = $FFFFFFFF;
  ENET_PORT_ANY = 0;

type
(**
 * Packet flag bit constants.
 *
 * The host must be specified in network byte-order, and the port must be in
 * host byte-order. The constant ENET_HOST_ANY may be used to specify the
 * default server host.
 
   @sa ENetPacket
*)
  PENetPacketFlag = ^ENetPacketFlag;
  ENetPacketFlag = (
    (** packet must be received by the target peer and resend attempts should be
      * made until the packet is delivered *)
    ENET_PACKET_FLAG_RELIABLE = 1,
    (** packet will not be sequenced with other packets
      * not supported for reliable packets
      *)
    ENET_PACKET_FLAG_UNSEQUENCED = 2,
    (** packet will not allocate data, and user must supply it instead *)
    ENET_PACKET_FLAG_NO_ALLOCATE = 4,
    (** packet will be fragmented using unreliable (instead of reliable) sends
      * if it exceeds the MTU *)
    ENET_PACKET_FLAG_UNRELIABLE_FRAGMENT = 8,
    
    (** whether the packet has been sent from all queues it has been entered into *)
    ENET_PACKET_FLAG_SENT = 256
  );

  PENetAcknowledgement = ^ENetAcknowledgement;
  ENetAcknowledgement = record
    acknowledgementList: ENetListNode;
    sentTime: enet_uint32;
    command: ENetProtocol;
  end;

  PENetOutgoingCommand = ^ENetOutgoingCommand;
  ENetOutgoingCommand = record
    outgoingCommandList: ENetListNode;
    reliableSequenceNumber: enet_uint16;
    unreliableSequenceNumber: enet_uint16;
    sentTime: enet_uint32;
    roundTripTimeout: enet_uint32;
    roundTripTimeoutLimit: enet_uint32;
    fragmentOffset: enet_uint32;
    fragmentLength: enet_uint16;
    sendAttempts: enet_uint16;
    command: ENetProtocol;
    packet: PENetPacket;
  end;

  PENetIncomingCommand = ^ENetIncomingCommand;
  ENetIncomingCommand = record
    incomingCommandList: ENetListNode;
    reliableSequenceNumber: enet_uint16;
    unreliableSequenceNumber: enet_uint16;
    command: ENetProtocol;
    fragmentCount: enet_uint32;
    fragmentsRemaining: enet_uint32;
    fragments: penet_uint32;
    packet: PENetPacket;
  end;



(** @defgroup global ENet global functions
    @{ 
*)

(** 
  Initializes ENet globally.  Must be called prior to using any functions in
  ENet.
  @returns 0 on success, < 0 on failure
*)
function enet_initialize(): cint; cdecl; external LIB_ENET;

(** 
  Initializes ENet globally and supplies user-overridden callbacks. Must be called prior to using any functions in ENet. Do not use enet_initialize() if you use this variant. Make sure the ENetCallbacks structure is zeroed out so that any additional callbacks added in future versions will be properly ignored.

  @param version the constant ENET_VERSION should be supplied so ENet knows which version of ENetCallbacks struct to use
  @param inits user-overridden callbacks where any NULL callbacks will use ENet's defaults
  @returns 0 on success, < 0 on failure
*)
function enet_initialize_with_callbacks(version: ENetVersion; const inits: PENetCallbacks): cint; cdecl; external LIB_ENET;

(** 
  Shuts down ENet globally.  Should be called when a program that has
  initialized ENet exits.
*)
procedure enet_deinitialize(); cdecl; external LIB_ENET;

(**
  Gives the linked version of the ENet library.
  @returns the version number 
*)
function enet_linked_version(): ENetVersion; cdecl; external LIB_ENET;

(** @} *)

(** @defgroup private ENet private implementation functions *)

(**
  Returns the wall-time in milliseconds.  Its initial value is unspecified
  unless otherwise set.
  *)
function enet_time_get(): enet_uint32; cdecl; external LIB_ENET;
(**
  Sets the current wall-time in milliseconds.
  *)
procedure enet_time_set(time: enet_uint32); cdecl; external LIB_ENET;

(** @defgroup socket ENet socket functions
    @{
*)
function enet_socket_create(type_: ENetSocketType): ENetSocket; cdecl; external LIB_ENET;
function enet_socket_bind(socket: ENetSocket; const address: PENetAddress): cint; cdecl; external LIB_ENET;
function enet_socket_get_address(socket: ENetSocket; address: PENetAddress): cint; cdecl; external LIB_ENET;
function enet_socket_listen(socket: ENetSocket; port: cint): cint; cdecl; external LIB_ENET;
function enet_socket_accept(socket: ENetSocket; address: PENetAddress): ENetSocket; cdecl; external LIB_ENET;
function enet_socket_connect(socket: ENetSocket; const address: PENetAddress): cint; cdecl; external LIB_ENET;
function enet_socket_send(socket: ENetSocket; const address: PENetAddress; const buffer: PENetBuffer; bufferCount: csize_t): cint; cdecl; external LIB_ENET;
function enet_socket_receive(socket: ENetSocket; address: PENetAddress; buffer: PENetBuffer; bufferCount: csize_t): cint; cdecl; external LIB_ENET;
function enet_socket_wait(socket: ENetSocket; condition: penet_uint32; timeout: enet_uint32): cint; cdecl; external LIB_ENET;
function enet_socket_set_option(socket: ENetSocket; option: ENetSocketOption; value: cint): cint; cdecl; external LIB_ENET;
function enet_socket_get_option(socket: ENetSocket; option: ENetSocketOption; value: pcint): cint; cdecl; external LIB_ENET;
function enet_socket_shutdown(socket: ENetSocket; how: ENetSocketShutdown): cint; cdecl; external LIB_ENET;
procedure enet_socket_destroy(socket: ENetSocket); cdecl; external LIB_ENET;
function enet_socketset_select(socket: ENetSocket; readSet: PENetSocketSet; writeSet: PENetSocketSet; timeout: enet_uint32): cint; cdecl; external LIB_ENET;

(** @} *)

(** @defgroup Address ENet address functions
    @{
*)
(** Attempts to parse the printable form of the IP address in the parameter hostName
    and sets the host field in the address parameter if successful.
    @param address destination to store the parsed IP address
    @param hostName IP address to parse
    @retval 0 on success
    @retval < 0 on failure
    @returns the address of the given hostName in address on success
*)
function enet_address_set_host_ip(address: PENetAddress; const hostName: pchar): cint; cdecl; external LIB_ENET;

(** Attempts to resolve the host named by the parameter hostName and sets
    the host field in the address parameter if successful.
    @param address destination to store resolved address
    @param hostName host name to lookup
    @retval 0 on success
    @retval < 0 on failure
    @returns the address of the given hostName in address on success
*)
function enet_address_set_host(address: PENetAddress; const hostName: pchar): cint; cdecl; external LIB_ENET;

(** Gives the printable form of the IP address specified in the address parameter.
    @param address    address printed
    @param hostName   destination for name, must not be NULL
    @param nameLength maximum length of hostName.
    @returns the null-terminated name of the host in hostName on success
    @retval 0 on success
    @retval < 0 on failure
*)
function enet_address_get_host_ip(const address: PENetAddress; hostName: pchar; nameLength: csize_t): cint; cdecl; external LIB_ENET;

(** Attempts to do a reverse lookup of the host field in the address parameter.
    @param address    address used for reverse lookup
    @param hostName   destination for name, must not be NULL
    @param nameLength maximum length of hostName.
    @returns the null-terminated name of the host in hostName on success
    @retval 0 on success
    @retval < 0 on failure
*)
function enet_address_get_host(const address: PENetAddress; hostName: pchar; nameLength: csize_t): cint; cdecl; external LIB_ENET;

(** @} *)

function enet_packet_create(const data: pointer; dataLength: csize_t; flags: ENetPacketFlag): PENetPacket; cdecl; external LIB_ENET;
procedure enet_packet_destroy(packet: PENetPacket); cdecl; external LIB_ENET;
function enet_packet_resize(packet: PENetPacket; dataLength: csize_t): cint; cdecl; external LIB_ENET;
function enet_crc32(const buffer: PENetBuffer; bufferCount: csize_t): enet_uint32; cdecl; external LIB_ENET;

function enet_host_create(const address: PENetAddress; peerCount: csize_t; channelLimit: csize_t; incomingBandwidth: enet_uint32; outgoingBandwidth: enet_uint32): PENetHost; cdecl; external LIB_ENET;
procedure enet_host_destroy(host: PENetHost); cdecl; external LIB_ENET;
function enet_host_connect(host: PENetHost; const address: PENetAddress; channelCount: csize_t; data: enet_uint32): PENetPeer; cdecl; external LIB_ENET;
function enet_host_check_events(host: PENetHost; event: PENetEvent): cint; cdecl; external LIB_ENET;
function enet_host_service(host: PENetHost; event: PENetEvent; timeout: enet_uint32): cint; cdecl; external LIB_ENET;
procedure enet_host_flush(host: PENetHost); cdecl; external LIB_ENET;
procedure enet_host_broadcast(host: PENetHost; channelID: enet_uint8; packet: PENetPacket); cdecl; external LIB_ENET;
procedure enet_host_compress(host: PENetHost; const compressor: PENetCompressor); cdecl; external LIB_ENET;
function enet_host_compress_with_range_coder(host: PENetHost): cint; cdecl; external LIB_ENET;
procedure enet_host_channel_limit(host: PENetHost; channelLimit: csize_t); cdecl; external LIB_ENET;
procedure enet_host_bandwidth_limit(host: PENetHost; incomingBandwidth: enet_uint32; outgoingBandwidth: enet_uint32); cdecl; external LIB_ENET;
procedure enet_host_bandwidth_throttle(host: PENetHost); cdecl; external LIB_ENET;
function enet_host_random_seed(): enet_uint32; cdecl; external LIB_ENET;

function enet_peer_send(peer: PENetPeer; channelID: enet_uint8; packet: PENetPacket): cint; cdecl; external LIB_ENET;
function enet_peer_receive(peer: PENetPeer; channelID: penet_uint8): PENetPacket; cdecl; external LIB_ENET;
procedure enet_peer_ping(peer: PENetPeer); cdecl; external LIB_ENET;
procedure enet_peer_ping_interval(peer: PENetPeer; pingInterval: enet_uint32); cdecl; external LIB_ENET;
procedure enet_peer_timeout(peer: PENetPeer; timeoutLimit: enet_uint32; timeoutMinimum: enet_uint32; timeoutMaximum: enet_uint32); cdecl; external LIB_ENET;
procedure enet_peer_reset(peer: PENetPeer); cdecl; external LIB_ENET;
procedure enet_peer_disconnect(peer: PENetPeer; data: enet_uint32); cdecl; external LIB_ENET;
procedure enet_peer_disconnect_now(peer: PENetPeer; data: enet_uint32); cdecl; external LIB_ENET;
procedure enet_peer_disconnect_later(peer: PENetPeer; data: enet_uint32); cdecl; external LIB_ENET;
procedure enet_peer_throttle_configure(peer: PENetPeer; interval: enet_uint32; acceleration: enet_uint32; deceleration: enet_uint32); cdecl; external LIB_ENET;
function enet_peer_throttle(peer: PENetPeer; roundTripTime: enet_uint32): cint; cdecl; external LIB_ENET;
procedure enet_peer_reset_queues(peer: PENetPeer); cdecl; external LIB_ENET;
procedure enet_peer_setup_outgoing_command(peer: PENetPeer; outgoingCommand: PENetOutgoingCommand); cdecl; external LIB_ENET;
function enet_peer_queue_outgoing_command(peer: PENetPeer; const command: PENetProtocol; packet: PENetPacket; offset: enet_uint32; length: enet_uint16): PENetOutgoingCommand; cdecl; external LIB_ENET;
function enet_peer_queue_incoming_command(peer: PENetPeer; const command: PENetProtocol; const data: pointer; dataLength: csize_t; flags: enet_uint32; fragmentCount: enet_uint32): PENetIncomingCommand; cdecl; external LIB_ENET;
function enet_peer_queue_acknowledgement(peer: PENetPeer; const command: PENetProtocol; sentTime: enet_uint16): PENetAcknowledgement; cdecl; external LIB_ENET;
procedure enet_peer_dispatch_incoming_unreliable_commands(peer: PENetPeer; channel: PENetChannel); cdecl; external LIB_ENET;
procedure enet_peer_dispatch_incoming_reliable_commands(peer: PENetPeer; channel: PENetChannel); cdecl; external LIB_ENET;
procedure enet_peer_on_connect(peer: PENetPeer); cdecl; external LIB_ENET;
procedure enet_peer_on_disconnect(peer: PENetPeer); cdecl; external LIB_ENET;

function enet_range_coder_create(): pointer; cdecl; external LIB_ENET;
procedure enet_range_coder_destroy(context: pointer); cdecl; external LIB_ENET;
function enet_range_coder_compress(context: pointer; const inBuffers: PENetBuffer; inBufferCount: csize_t; inLimit: csize_t; outData: penet_uint8; outLimit: csize_t): csize_t; cdecl; external LIB_ENET;
function enet_range_coder_decompress(context: pointer; const inData: penet_uint8; inLimit: csize_t; outData: penet_uint8; outLimit: csize_t): csize_t; cdecl; external LIB_ENET;
   
function enet_protocol_command_size(commandNumber: enet_uint8): csize_t; cdecl; external LIB_ENET;


implementation

function ENET_VERSION_CREATE(major: cint; minor: cint; patch: cint): cint; cdecl; inline;
begin
  Result := (((major) shl 16) or ((minor) shl 8) or (patch));
end;

function ENET_VERSION_GET_MAJOR(version: cint): cint; cdecl; inline;
begin
  Result := (((version) shr 16) and $FF);
end;

function ENET_VERSION_GET_MINOR(version: cint): cint; cdecl; inline;
begin
  Result := (((version) shr 8)and $FF);
end;

function ENET_VERSION_GET_PATCH(version: cint): cint; cdecl; inline;
begin
  Result := ((version) and $FF);
end;


end.

