//
// enet.h header binding for the Free Pascal Compiler aka FPC
//
// Binaries and demos available at http://www.djmaster.com/
//

(** 
 @file  types.h
 @brief type definitions for ENet
*)

type
  enet_uint8 = cuchar; (**< unsigned 8-bit type  *)
  penet_uint8 = ^enet_uint8;
  enet_uint16 = cushort; (**< unsigned 16-bit type *)
  enet_uint32 = cuint; (**< unsigned 32-bit type *)
  penet_uint32 = ^enet_uint32;

