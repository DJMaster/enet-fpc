//
// enet.h header binding for the Free Pascal Compiler aka FPC
//
// Binaries and demos available at http://www.djmaster.com/
//

(** 
 @file  time.h
 @brief ENet time constants and macros
*)

const
  ENET_TIME_OVERFLOW = 86400000;

//TODO #define ENET_TIME_LESS(a, b) ((a) - (b) >= ENET_TIME_OVERFLOW)
//TODO #define ENET_TIME_GREATER(a, b) ((b) - (a) >= ENET_TIME_OVERFLOW)
//TODO #define ENET_TIME_LESS_EQUAL(a, b) (! ENET_TIME_GREATER (a, b))
//TODO #define ENET_TIME_GREATER_EQUAL(a, b) (! ENET_TIME_LESS (a, b))

//TODO #define ENET_TIME_DIFFERENCE(a, b) ((a) - (b) >= ENET_TIME_OVERFLOW ? (b) - (a) : (a) - (b))

