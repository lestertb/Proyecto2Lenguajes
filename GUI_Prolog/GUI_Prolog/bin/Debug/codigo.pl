%Variables para el Data dynamic
:- dynamic pares/3.


:- dynamic grupo/2.


:- dynamic matrixSize/1.


% Inicio codigo

%Lleva el contador de miembros en los grupos
llevarContador(V1,V2):- V2 is V1.

%Concatena la lista de grupos
concatListas(L1,L2):- append(L1,[],L2).

%-----Inicio comprobar posiciones

% Abajo de la posicion actual por fuera de la matriz
buscarVertical(X,Y,List,0,Num):- matrixSize(Size),
	                         X2 is X+1,X2>Size,
				 buscarHorizontal(X,Y,List,List2,0,Num,Num2),
				 assert(grupo(List2,Num2)),!.


% Abajo de la posicion actual con otra posicion encontrada
buscarVertical(X,Y,List,0,Num):- matrixSize(Size),X2 is X+1,X2 =< Size,
				 pares(X2,Y,0),retract(pares(X2,Y,0)),assert(pares(X2,Y,1)),
				 NumAux is Num+1,
				 buscarVertical2(X2,Y,[List|[[X2,Y]]],ListaEncontrada,0,NumAux,NumEncontrado),
				 concatListas(ListaEncontrada,NuevaList),llevarContador(NumEncontrado,NuevoNum),
				 buscarHorizontal(X,Y,NuevaList,ListEncontrada2,0,NuevoNum,NumEncontrado2),
				 assert(grupo(ListEncontrada2,NumEncontrado2)),!.

% Abajo de la posicion actual pero sin otra posicion encontrada
buscarVertical(X,Y,List,0,Num):- matrixSize(Size),X2 is X+1,X2 =< Size,
				 not(pares(X2,Y,0)),
				 buscarHorizontal(X,Y,List,ListEncontrada,0,Num,NumEncontrado),
				 assert(grupo(ListEncontrada,NumEncontrado)),!.


%---------------------------------------------------------------------------
% Checkeo Horizontal de posiciones derecha e izquierda de (X,Y)
%--------------------------------------------------------------------------

% Izquierda de la posicion actual por fuera de la matriz
buscarHorizontal(_,Y,List,List2,0,Num,Num2):- matrixSize(Size),Y2 is Y+1,Y2>Size,
                                              concatListas(List,List2),llevarContador(Num,Num2),!.

% Izquierda de la posicion actual con otra posicion encontrada
buscarHorizontal(X,Y,List,List4,0,Num,Num4):- matrixSize(Size),Y2 is Y+1,Y2 =< Size,
                                              pares(X,Y2,0),retract(pares(X,Y2,_)),assert(pares(X,Y2,1)),
                                              Num2 is Num+1,
                                              buscarVertical2(X,Y2,[List|[[X,Y2]]],ListEncontrada,0,Num2,NumEncontrado),
                                              concatListas(ListEncontrada,List4),llevarContador(NumEncontrado,Num4),!.

% Izquierda de la posicion actual sin otra posicion encontrada
buscarHorizontal(X,Y,List,List2,0,Num,Num2):- matrixSize(Size),Y2 is Y+1,Y2 =< Size,
                                              not(pares(X,Y2,0)),
                                              concatListas(List,List2),
                                              llevarContador(Num,Num2),!.


%---------------------------------------------------------------------------
% Checkeo Vertical2 de posiciones arriba o abajo de la (X,Y)
%--------------------------------------------------------------------------

% Abajo de la posicion actual por fuera de la matriz
buscarVertical2(X,Y,List,List2,0,Num,Num2):- matrixSize(Size),X2 is X+1,X2>Size,
                                             buscarHorizontal2(X,Y,List,ListEncontrada,0,Num,NumEncontrado),
                                             concatListas(ListEncontrada,ListNueva),llevarContador(NumEncontrado,NumNuevo),
                                             buscarHorizontal2(X,Y,ListNueva,List2,1,NumNuevo,Num2),!.

% Abajo de la posicion actual con otra posicion encontrada
buscarVertical2(X,Y,List,List2,0,Num,Num3):- matrixSize(Size),X2 is X+1,X2 =< Size,
                                             pares(X2,Y,0),retract(pares(X2,Y,0)),assert(pares(X2,Y,1)),
                                             Num2 is Num+1,
                                             buscarVertical2(X2,Y,[List|[[X2,Y]]],ListEncontrada,0,Num2,NumEncontrado),
                                             concatListas(ListEncontrada,ListNueva),llevarContador(NumEncontrado,NumNuevo),
                                             buscarHorizontal2(X,Y,ListNueva,ListEncontrada2,0,NumNuevo,NumEncontrado2),
                                             concatListas(ListEncontrada2,ListNueva2),llevarContador(NumEncontrado2,NumNuevo2),
                                             buscarHorizontal2(X,Y,ListNueva2,List2,1,NumNuevo2,Num3),!.

% Abajo de la posicion actual pero sin otra posicion encontrada
buscarVertical2(X,Y,List,List2,0,Num,Num3):- matrixSize(Size),X2 is X+1,X2 =< Size,
                                             not(pares(X2,Y,0)),
                                             buscarHorizontal2(X,Y,List,ListEncontrada,0,Num,NumEncontrado),                                                                      concatListas(ListEncontrada,ListNueva),
                                             llevarContador(NumEncontrado,NumNuevo),
                                             buscarHorizontal2(X,Y,ListNueva,List2,1,NumNuevo,Num3),!.

buscarVertical2(X,_,List,List2,1,Num,Num2):- X2 is X-1,X2 < 0,
					     concatListas(List,List2),
                                             llevarContador(Num,Num2),!.

% Abajo de la posicion actual con otra posicion encontrada
buscarVertical2(X,Y,List,List2,1,Num,Num3):- X2 is X-1,X2 >= 0,
                                             pares(X2,Y,0),retract(pares(X2,Y,0)),assert(pares(X2,Y,1)),
                                             Num2 is Num+1,
                                             buscarVertical2(X2,Y,[List|[[X2,Y]]],ListEncontrada,0,Num2,NumEncontrado),
                                             concatListas(ListEncontrada,List2),
                                             llevarContador(NumEncontrado,Num3),!.

% Abajo de la posicion actual pero sin otra posicion encontrada
buscarVertical2(X,Y,List,List2,1,Num,Num3):- X2 is X-1,X2 >= 0,
                                             not(pares(X2,Y,0)),
					     concatListas(List,List2),
                                             llevarContador(Num,Num3),!.



%---------------------------------------------------------------------------
% Checkeo Horizontal2 de posiciones derecha e izquierda de (X,Y)
%--------------------------------------------------------------------------

% Derecha de la posicion actual por fuera de la matriz
buscarHorizontal2(X,Y,List,List2,0,Num,Num2):- matrixSize(Size),Y2 is Y+1,Y2>Size,
                                               buscarHorizontal2(X,Y,List,List2,1,Num,Num2),!.

% Derecha de la posicion actual con otra posicion encontrada
buscarHorizontal2(X,Y,List,List2,0,Num,Num3):- matrixSize(Size),Y2 is Y+1,Y2 =< Size,
                                               pares(X,Y2,0),retract(pares(X,Y2,_)),assert(pares(X,Y2,1)),
                                               Num2 is Num+1,
                                               buscarVertical2(X,Y2,[List|[[X,Y2]]],ListEncontrada,0,Num2,NumEncontrado),
                                               concatListas(ListEncontrada,List2),llevarContador(NumEncontrado,Num3),!.

% Derecha de la posicion actual sin otra posicion encontrada
buscarHorizontal2(X,Y,List,List2,0,Num,Num2):- matrixSize(Size),Y2 is Y+1,Y2 =< Size,
                                               not(pares(X,Y2,0)),
					       buscarHorizontal2(X,Y,List,List2,1,Num,Num2),!.

% !
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Izquierda de la posicion actual por fuera de la matriz
buscarHorizontal2(X,Y,List,List2,1,Num,Num2):- Y2 is Y-1,Y2<0,
					       buscarVertical2(X,Y,List,List2,1,Num,Num2),!.

% Izquierda de la posicion actual con otra posicion encontrada
buscarHorizontal2(X,Y,List,List2,1,Num,Num3):-Y2 is Y-1,Y2 >= 0,
                                              pares(X,Y2,0),retract(pares(X,Y2,_)),assert(pares(X,Y2,1)),
                                              Num2 is Num+1,
                                              buscarVertical2(X,Y2,[List|[[X,Y2]]],ListEncontrada,0,Num2,NumEncontrado),
                                              concatListas(ListEncontrada,List2),llevarContador(NumEncontrado,Num3),!.

% Izquierda de la posicion actual sin otra posicion encontrada
buscarHorizontal2(X,Y,List,List2,1,Num,Num2):- Y2 is Y-1,Y2 >= 0,
                                               not(pares(X,Y2,0)),
                                               buscarVertical2(X,Y,List,List2,1,Num,Num2),!.

printGrupos(G,Cant):- grupo(G,Cant).

%Iniciar en 0,0 para tomar encuenta la primera posibilidad
inicioCrearGrupos:- inicioVerificar(0,0),!.

%Verificar pares válidos
inicioVerificar(X,Y):- matrixSize(Size),X =< Size,Y =< Size,
               pares(X,Y,0),retract(pares(X,Y,_)),assert(pares(X,Y,1)),
               buscarVertical(X,Y,[X,Y],0,1),
               AuxY is Y+1,
               inicioVerificar(X,AuxY).

inicioVerificar(X,Y):- matrixSize(Size),X =< Size,Y =< Size,
               not(pares(X,Y,0)),
               AuxY is Y+1,
               inicioVerificar(X,AuxY).

inicioVerificar(X,Y):- matrixSize(Size),X =< Size,Y > Size,
               AuxX is X+1,AuxY is 0,
               inicioVerificar(AuxX,AuxY).

inicioVerificar(X,_):- matrixSize(Size),X >Size,!.







