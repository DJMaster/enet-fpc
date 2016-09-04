//
// enet.h header binding for the Free Pascal Compiler aka FPC
//
// Binaries and demos available at http://www.djmaster.com/
//

(** 
 @file  callbacks.h
 @brief ENet callbacks
*)

type
  malloc_cb = function(size: csize_t): pointer; cdecl;
  free_cb = procedure(memory: pointer); cdecl;
  no_memory_cb = procedure(); cdecl;

type
  PENetCallbacks = ^ENetCallbacks;
  ENetCallbacks = record
    malloc: malloc_cb;
    free: free_cb;
    no_memory: no_memory_cb
  end;

(** @defgroup callbacks ENet internal callbacks
    @{
    @ingroup private
*)
function enet_malloc(size: csize_t): pointer; cdecl; external LIB_ENET;
procedure enet_free(memory: pointer); cdecl; external LIB_ENET;

(** @} *)

