//
// enet.h header binding for the Free Pascal Compiler aka FPC
//
// Binaries and demos available at http://www.djmaster.com/
//

(** 
 @file  list.h
 @brief ENet list management 
*)

type
  PENetListNode = ^ENetListNode;
  ENetListNode = record
    next: PENetListNode;
    previous: PENetListNode;
  end;

type
  ENetListIterator = PENetListNode;

type
  PENetList = ^ENetList;
  ENetList = record
    sentinel: ENetListNode ;
  end;

procedure enet_list_clear(list: PENetList); cdecl; external LIB_ENET;

function enet_list_insert(iterator: ENetListIterator; data: pointer): ENetListIterator; cdecl; external LIB_ENET;
function enet_list_remove(iterator: ENetListIterator): pointer; cdecl; external LIB_ENET;
function enet_list_move(iterator: ENetListIterator; source: pointer; dest: pointer): ENetListIterator; cdecl; external LIB_ENET;

function enet_list_size(list: PENetList): size_t; cdecl; external LIB_ENET;

//TODO #define enet_list_begin(list) ((list) -> sentinel.next)
//TODO #define enet_list_end(list) (& (list) -> sentinel)

//TODO #define enet_list_empty(list) (enet_list_begin (list) == enet_list_end (list))

//TODO #define enet_list_next(iterator) ((iterator) -> next)
//TODO #define enet_list_previous(iterator) ((iterator) -> previous)

//TODO #define enet_list_front(list) ((void *) (list) -> sentinel.next)
//TODO #define enet_list_back(list) ((void *) (list) -> sentinel.previous)

