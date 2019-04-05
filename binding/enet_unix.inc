//
// enet.h header binding for the Free Pascal Compiler aka FPC
//
// Binaries and demos available at http://www.djmaster.com/
//

(** 
 @file  unix.h
 @brief ENet Unix header
*)

//TODO #include <stdlib.h>
//TODO #include <sys/time.h>
//TODO #include <sys/types.h>
//TODO #include <sys/socket.h>
//TODO #include <arpa/inet.h>
//TODO #include <netinet/in.h>
//TODO #include <unistd.h>

#ifdef MSG_MAXIOVLEN
#define ENET_BUFFER_MAXIMUM MSG_MAXIOVLEN
#endif

type
  ENetSocket: cint;

const
  ENET_SOCKET_NULL = -1;

//TODO #define ENET_HOST_TO_NET_16(value) (htons (value)) (**< macro that converts host to net byte-order of a 16-bit value *)
//TODO #define ENET_HOST_TO_NET_32(value) (htonl (value)) (**< macro that converts host to net byte-order of a 32-bit value *)

//TODO #define ENET_NET_TO_HOST_16(value) (ntohs (value)) (**< macro that converts net to host byte-order of a 16-bit value *)
//TODO #define ENET_NET_TO_HOST_32(value) (ntohl (value)) (**< macro that converts net to host byte-order of a 32-bit value *)

type
  PENetBuffer = ^ENetBuffer;
  ENetBuffer = record
    data: pointer;
    dataLength: csize_t;
  end;

//TODO #define ENET_CALLBACK

//TODO #define ENET_API extern

type
  ENetSocketSet = TFDSet;
  PENetSocketSet = ^ENetSocketSet;

//TODO #define ENET_SOCKETSET_EMPTY(sockset)          FD_ZERO (& (sockset))
//TODO #define ENET_SOCKETSET_ADD(sockset, socket)    FD_SET (socket, & (sockset))
//TODO #define ENET_SOCKETSET_REMOVE(sockset, socket) FD_CLR (socket, & (sockset))
//TODO #define ENET_SOCKETSET_CHECK(sockset, socket)  FD_ISSET (socket, & (sockset))
    
