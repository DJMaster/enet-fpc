//
// enet.h header binding for the Free Pascal Compiler aka FPC
//
// Binaries and demos available at http://www.djmaster.com/
//

(** 
 @file  win32.h
 @brief ENet Win32 header
*)

//TODO #ifdef _MSC_VER
//TODO #ifdef ENET_BUILDING_LIB
//TODO #pragma warning (disable: 4267) // size_t to int conversion
//TODO #pragma warning (disable: 4244) // 64bit to 32bit int
//TODO #pragma warning (disable: 4018) // signed/unsigned mismatch
//TODO #pragma warning (disable: 4146) // unary minus operator applied to unsigned type
//TODO #endif
//TODO #endif

type
  ENetSocket = TSocket;

const
  ENET_SOCKET_NULL = INVALID_SOCKET;

//TODO function ENET_HOST_TO_NET_16(value: cint16) (htons (value))
//TODO function ENET_HOST_TO_NET_32(value: cint32) (htonl (value))

//TODO function ENET_NET_TO_HOST_16(value: cint16) (ntohs (value))
//TODO function ENET_NET_TO_HOST_32(value: cint32) (ntohl (value))

type
  PENetBuffer = ^ENetBuffer;
  ENetBuffer = record
    dataLength: csize_t;
    data: pointer;
  end;

//TODO #ifdef ENET_DLL
//TODO #ifdef ENET_BUILDING_LIB
//TODO #define ENET_API __declspec( dllexport )
//TODO #else
//TODO #define ENET_API __declspec( dllimport )
//TODO #endif (* ENET_BUILDING_LIB *)
//TODO #else (* !ENET_DLL *)
//TODO #define ENET_API extern
//TODO #endif (* ENET_DLL *)

type
  ENetSocketSet = TFDSet;
  PENetSocketSet = ^ENetSocketSet;

//TODO #define ENET_SOCKETSET_EMPTY(sockset)          FD_ZERO (& (sockset))
//TODO #define ENET_SOCKETSET_ADD(sockset, socket)    FD_SET (socket, & (sockset))
//TODO #define ENET_SOCKETSET_REMOVE(sockset, socket) FD_CLR (socket, & (sockset))
//TODO #define ENET_SOCKETSET_CHECK(sockset, socket)  FD_ISSET (socket, & (sockset))

