%-----Variables para el Data dynamic

% tamannoMTX estructura: (Val) simplemente guarda el valor del tamaño de
% la matriz, para luego comprobar que los X y Y no se salen de la matriz
:- dynamic tamannoMTX/1.

% pares estructura: (1,0,v) los 2 primeros valores son las posiciones
% X,Y respectuvamente, el 3 valor es para marcar si ha sido visitado o
% no. "nv" es no visitado y "v" es visitado
:- dynamic pares/3.

% grupos estructura: ([[X,Y]],cant) los grupos tienen una lista con
% listas de pares, y el segundo valor lleva la cantidad de pares que se
% han ido agregando según las validaciónes
:- dynamic grupos/2.


%-----Inicio codigo
%
%

%Eliminar par que ya se tomó en cuenta
deletePar1(X,Y,_):- retract(pares(X,Y,_)).

%Eliminar par no visitado
deletePar2(X,Y,nv):- retract(pares(X,Y,nv)).


%Iniciar en 0,0 para tomar encuenta la primera posibilidad
startCrearGrupos:- startVerificar(0,0).

% Aumenta valores X,Y que se encuentren dentro del rando de la
% matrix para inciar con la verificación pares válidos y agregarlos a
% grupos
startVerificar(X,Y):- tamannoMTX(AuxTam),X =< AuxTam,Y =< AuxTam,
		      pares(X,Y,nv),deletePar1(X,Y,_),assert(pares(X,Y,v)),
		      searchAbajo(X,Y,[X,Y],abajo1,1),
		      AuxY is Y+1,
		      startVerificar(X,AuxY).

startVerificar(X,Y):- tamannoMTX(AuxTam),X =< AuxTam,Y =< AuxTam,
		      not(pares(X,Y,nv)),
		      AuxY is Y+1,
		      startVerificar(X,AuxY).

startVerificar(X,Y):- tamannoMTX(AuxTam),X =< AuxTam,Y > AuxTam,
		      AuxX is X+1,AuxY is 0,
		      startVerificar(AuxX,AuxY).

startVerificar(X,_):- tamannoMTX(AuxTam),X >AuxTam.

%Lleva el contador de miembros en los grupos
carryContador(V1,V2):- V2 is V1.

%Concatena la lista de grupos
concatListas(L1,L2):- append(L1,[],L2).

%-----Inicio comprobar posiciones

% Busqueda abajo en X (+1)
searchAbajo(X,Y,L,abajo1,Val):- tamannoMTX(AuxTam),AuxX is X+1,AuxX>AuxTam,
				searchDerecha(X,Y,L,L2,derecha1,Val,Val2),
				assert(grupos(L2,Val2)).

searchAbajo(X,Y,L,abajo1,Val):- tamannoMTX(AuxTam),AuxX is X+1,AuxX =< AuxTam,
				pares(AuxX,Y,nv),deletePar2(AuxX,Y,nv),assert(pares(AuxX,Y,v)),
				AuxCont is Val+1,
				searchAbajo2(AuxX,Y,[L|[[AuxX,Y]]],AuxLista,abajo2,AuxCont,AuxVal),
				concatListas(AuxLista,AuxLista2),carryContador(AuxVal,AuxVal2),
				searchDerecha(X,Y,AuxLista2,AuxListaResult,derecha1,AuxVal2,AuxValResult),
				assert(grupos(AuxListaResult,AuxValResult)).

searchAbajo(X,Y,L,abajo1,Val):- tamannoMTX(AuxTam),AuxX is X+1,AuxX =< AuxTam,
				not(pares(AuxX,Y,nv)),
				searchDerecha(X,Y,L,AuxListResult,derecha1,Val,AuxValResult),
				assert(grupos(AuxListResult,AuxValResult)).

%Busqueda derecha en Y (+1)

searchDerecha(_,Y,L,L2,derecha1,Val,Val2):- tamannoMTX(AuxTam),AuxY is Y+1,AuxY>AuxTam,
					    concatListas(L,L2),carryContador(Val,Val2).

searchDerecha(X,Y,L,L2,derecha1,Val,Val2):- tamannoMTX(AuxTam),AuxY is Y+1,AuxY =< AuxTam,
					    pares(X,AuxY,nv),deletePar1(X,AuxY,_),assert(pares(X,AuxY,v)),
					    AuxCont is Val+1,
					    searchAbajo2(X,AuxY,[L|[[X,AuxY]]],AuxListResult,abajo2,AuxCont,AuxValResult),
					    concatListas(AuxListResult,L2),carryContador(AuxValResult,Val2).

searchDerecha(X,Y,L,L2,derecha1,Val,Val2):- tamannoMTX(AuxTam),AuxY is Y+1,AuxY =< AuxTam,
					    not(pares(X,AuxY,nv)),
					    concatListas(L,L2),carryContador(Val,Val2).


% Busqueda abajo2 en X (+1) por si encontró un valor en la busqueda
% anterior

searchAbajo2(X,Y,L,L2,abajo2,Val,Val2):- tamannoMTX(AuxTam),AuxX is X+1,AuxX>AuxTam,
					 searchDerecha2(X,Y,L,AuxList,derecha2,Val,AuxVal),
					 concatListas(AuxList,AuxListResult),carryContador(AuxVal,AuxValResult),
					 searchIzquierda(X,Y,AuxListResult,L2,izquierda1,AuxValResult,Val2).

searchAbajo2(X,Y,L,L2,abajo2,Val,Val2):- tamannoMTX(AuxTam),AuxX is X+1,AuxX =< AuxTam,
					 pares(AuxX,Y,nv),deletePar2(AuxX,Y,nv),assert(pares(AuxX,Y,v)),
					 AuxCont is Val+1,
					 searchAbajo2(AuxX,Y,[L|[[AuxX,Y]]],AuxList,abajo2,AuxCont,AuxVal),
					 concatListas(AuxList,AuxResultLista),carryContador(AuxVal,AuxResultVal),
					 searchDerecha2(X,Y,AuxResultLista,Aux2Lista,derecha2,AuxResultVal,Aux2Val),
					 concatListas(Aux2Lista,Aux3Lista),carryContador(Aux2Val,Aux3Val),
					 searchIzquierda(X,Y,Aux3Lista,L2,izquierda1,Aux3Val,Val2).

searchAbajo2(X,Y,L,L2,abajo2,Val,Val2):- tamannoMTX(AuxTam),AuxX is X+1,AuxX =< AuxTam,
					 not(pares(AuxX,Y,nv)),
					 searchDerecha2(X,Y,L,AuxList,derecha2,Val,AuxVal),										 concatListas(AuxList,AuxResultLista),
					 carryContador(AuxVal,AuxResultVal),
					 searchIzquierda(X,Y,AuxResultLista,L2,izquierda1,AuxResultVal,Val2).

%Busqueda arriba en Y (-1)
searchArriba(X,_,L,L2,arriba1,Val,Val2):- AuxX is X-1,AuxX < 0,
					  concatListas(L,L2),
					  carryContador(Val,Val2).

searchArriba(X,Y,L,L2,arriba1,Val,Val2):- AuxX is X-1,AuxX >= 0,
					  pares(AuxX,Y,nv),deletePar2(AuxX,Y,nv),assert(pares(AuxX,Y,v)),
					  AuxCont is Val+1,
					  searchAbajo2(AuxX,Y,[L|[[AuxX,Y]]],AuxList,abajo2,AuxCont,AuxVal),
					  concatListas(AuxList,L2),carryContador(AuxVal,Val2).

searchArriba(X,Y,L,L2,arriba1,Val,Val2):- AuxX is X-1,AuxX >= 0,
					  not(pares(AuxX,Y,nv)),
					  concatListas(L,L2),carryContador(Val,Val2).

% Busqueda Derecha2 en Y (+1) por si encontró un valor en la busqueda
% anterior
searchDerecha2(X,Y,L,L2,derecha2,Val,Val2):- tamannoMTX(AuxTam),AuxY is Y+1,AuxY>AuxTam,
					     searchIzquierda(X,Y,L,L2,izquierda1,Val,Val2).

searchDerecha2(X,Y,L,L2,derecha2,Val,Val2):- tamannoMTX(AuxTam),AuxY is Y+1,AuxY =< AuxTam,
					     pares(X,AuxY,nv),deletePar1(X,AuxY,_),assert(pares(X,AuxY,v)),
					     AuxCont is Val+1,
					     searchAbajo2(X,AuxY,[L|[[X,AuxY]]],AuxList,abajo2,AuxCont,AuxVal),
					     concatListas(AuxList,L2),carryContador(AuxVal,Val2).

searchDerecha2(X,Y,L,L2,derecha2,Val,Val2):- tamannoMTX(AuxTam),AuxY is Y+1,AuxY =< AuxTam,
					     not(pares(X,AuxY,nv)),
					     searchIzquierda(X,Y,L,L2,izquierda1,Val,Val2).

%Busqueda Izquierda en Y (-1)
searchIzquierda(X,Y,L,L2,izquierda1,Val,Val2):- AuxY is Y-1,AuxY<0,
					        searchArriba(X,Y,L,L2,arriba1,Val,Val2).

% Izquierda de la posicion actual con otra posicion encontrada
searchIzquierda(X,Y,L,L2,izquierda1,Val,Val2):- AuxY is Y-1,AuxY >= 0,
                                                pares(X,AuxY,nv),deletePar1(X,AuxY,_),assert(pares(X,AuxY,v)),
                                                AuxCont is Val+1,
                                                searchAbajo2(X,AuxY,[L|[[X,AuxY]]],AuxList,abajo2,AuxCont,AuxVal),
                                                concatListas(AuxList,L2),carryContador(AuxVal,Val2).

% Izquierda de la posicion actual sin otra posicion encontrada
searchIzquierda(X,Y,L,L2,izquierda1,Val,Val2):- AuxY is Y-1,AuxY >= 0,
                                                not(pares(X,AuxY,nv)),
                                                searchArriba(X,Y,L,L2,arriba1,Val,Val2).

%Imprimir las listas de los grupos con su cantidad
printGrupos(G,Cant):- grupos(G,Cant).









