//
// enet.h header binding for the Free Pascal Compiler aka FPC
//
// Binaries and demos available at http://www.djmaster.com/
//

(** 
 @file  utility.h
 @brief ENet utility header
*)

function ENET_MAX(x; y: cint): cint; inline;
begin
 if (x > y)
   then Result := x
   else Result := y;
end;

function ENET_MIN(x; y: cint): cint; inline;
begin
  if (x < y)
    then Result := x
    else Result := y;
end;

