%Data dynamic
:- dynamic pares/3.


:- dynamic grupo/2.


:- dynamic matrixSize/1.


%codigo
%
a(Num,Num2):- Num2 is Num.

b(List,L):- append(List,[],L).

%---------------------------------------------------------------------------
% Checkeo Vertical de posiciones arriba o abajo de la (X,Y)
%--------------------------------------------------------------------------

% Abajo de la posicion actual por fuera de la matriz
buscarVertical(X,Y,List,0,Num):- matrixSize(Size),
                                            X2 is X+1,
                                            X2>Size,
                                            buscarHorizontal(X,Y,List,List2,0,Num,Num2),
                                            assert(grupo(List2,Num2)),
                                            write(List2),
                                            write(Num2),
                                            nl,!.


% Abajo de la posicion actual con otra posicion encontrada
buscarVertical(X,Y,List,0,Num):- matrixSize(Size),
                                            X2 is X+1,
                                            X2 =< Size,
                                            pares(X2,Y,0),
                                            retract(pares(X2,Y,0)),
                                            assert(pares(X2,Y,1)),
                                            NumAux is Num+1,
                                            buscarVertical2(X2,Y,[List|[[X2,Y]]],ListaEncontrada,0,NumAux,NumEncontrado),
                                            b(ListaEncontrada,NuevaList),
                                            a(NumEncontrado,NuevoNum),
                                            buscarHorizontal(X,Y,NuevaList,ListEncontrada2,0,NuevoNum,NumEncontrado2),
                                            assert(grupo(ListEncontrada2,NumEncontrado2)),
                                            write(ListEncontrada2),
                                            write(NumEncontrado2),
                                            nl,!.

% Abajo de la posicion actual pero sin otra posicion encontrada
buscarVertical(X,Y,List,0,Num):- matrixSize(Size),
                                            X2 is X+1,
                                            X2 =< Size,
                                            not(pares(X2,Y,0)),
                                            buscarHorizontal(X,Y,List,ListEncontrada,0,Num,NumEncontrado),
                                            assert(grupo(ListEncontrada,NumEncontrado)),
                                            write(ListEncontrada),
                                            write(NumEncontrado),
                                            nl,!.


%---------------------------------------------------------------------------
% Checkeo Horizontal de posiciones derecha e izquierda de (X,Y)
%--------------------------------------------------------------------------

% Izquierda de la posicion actual por fuera de la matriz
buscarHorizontal(_,Y,List,List2,0,Num,Num2):- matrixSize(Size),
                                         Y2 is Y+1,
                                         Y2>Size,
                                         b(List,List2),
                                         a(Num,Num2),!.

% Izquierda de la posicion actual con otra posicion encontrada
buscarHorizontal(X,Y,List,List4,0,Num,Num4):- matrixSize(Size),
                                              Y2 is Y+1,
                                              Y2 =< Size,
                                              pares(X,Y2,0),
                                              retract(pares(X,Y2,_)),
                                              assert(pares(X,Y2,1)),
                                              Num2 is Num+1,
                                              buscarVertical2(X,Y2,[List|[[X,Y2]]],ListEncontrada,0,Num2,NumEncontrado),
                                              b(ListEncontrada,List4),
                                              a(NumEncontrado,Num4),!.

% Izquierda de la posicion actual sin otra posicion encontrada
buscarHorizontal(X,Y,List,List2,0,Num,Num2):- matrixSize(Size),
                                          Y2 is Y+1,
                                          Y2 =< Size,
                                          not(pares(X,Y2,0)),
                                          b(List,List2),
                                          a(Num,Num2),!.


%---------------------------------------------------------------------------
% Checkeo Vertical2 de posiciones arriba o abajo de la (X,Y)
%--------------------------------------------------------------------------

% Abajo de la posicion actual por fuera de la matriz
buscarVertical2(X,Y,List,List2,0,Num,Num2):- matrixSize(Size),
                                             X2 is X+1,
                                             X2>Size,
                                             buscarHorizontal2(X,Y,List,ListEncontrada,0,Num,NumEncontrado),
                                             b(ListEncontrada,ListNueva),
                                             a(NumEncontrado,NumNuevo),
                                             buscarHorizontal2(X,Y,ListNueva,List2,1,NumNuevo,Num2),!.

% Abajo de la posicion actual con otra posicion encontrada
buscarVertical2(X,Y,List,List2,0,Num,Num3):- matrixSize(Size),
                                            X2 is X+1,
                                            X2 =< Size,
                                            pares(X2,Y,0),
                                            retract(pares(X2,Y,0)),
                                            assert(pares(X2,Y,1)),
                                            Num2 is Num+1,
                                            buscarVertical2(X2,Y,[List|[[X2,Y]]],ListEncontrada,0,Num2,NumEncontrado),
                                            b(ListEncontrada,ListNueva),
                                            a(NumEncontrado,NumNuevo),
                                            buscarHorizontal2(X,Y,ListNueva,ListEncontrada2,0,NumNuevo,NumEncontrado2),
                                            b(ListEncontrada2,ListNueva2),
                                            a(NumEncontrado2,NumNuevo2),
                                            buscarHorizontal2(X,Y,ListNueva2,List2,1,NumNuevo2,Num3),!.

% Abajo de la posicion actual pero sin otra posicion encontrada
buscarVertical2(X,Y,List,List2,0,Num,Num3):- matrixSize(Size),
                                            X2 is X+1,
                                            X2 =< Size,
                                            not(pares(X2,Y,0)),
                                            buscarHorizontal2(X,Y,List,ListEncontrada,0,Num,NumEncontrado),                                                                    b(ListEncontrada,ListNueva),
                                            a(NumEncontrado,NumNuevo),
                                            buscarHorizontal2(X,Y,ListNueva,List2,1,NumNuevo,Num3),!.


buscarVertical2(X,_,List,List2,1,Num,Num2):- X2 is X-1,
                                             X2 < 0,
					     b(List,List2),
                                             a(Num,Num2),!.

% Abajo de la posicion actual con otra posicion encontrada
buscarVertical2(X,Y,List,List2,1,Num,Num3):-X2 is X-1,X2 >= 0,
                                            pares(X2,Y,0),retract(pares(X2,Y,0)),assert(pares(X2,Y,1)),
                                            Num2 is Num+1,
                                            buscarVertical2(X2,Y,[List|[[X2,Y]]],ListEncontrada,0,Num2,NumEncontrado),
                                            b(ListEncontrada,List2),
                                            a(NumEncontrado,Num3),!.

% Abajo de la posicion actual pero sin otra posicion encontrada
buscarVertical2(X,Y,List,List2,1,Num,Num3):-X2 is X-1,
                                            X2 >= 0,
                                            not(pares(X2,Y,0)),
					    b(List,List2),
                                            a(Num,Num3),!.



%---------------------------------------------------------------------------
% Checkeo Horizontal2 de posiciones derecha e izquierda de (X,Y)
%--------------------------------------------------------------------------

% Derecha de la posicion actual por fuera de la matriz
buscarHorizontal2(X,Y,List,List2,0,Num,Num2):- matrixSize(Size),
                                         Y2 is Y+1,
                                         Y2>Size,
                                         buscarHorizontal2(X,Y,List,List2,1,Num,Num2),!.

% Derecha de la posicion actual con otra posicion encontrada
buscarHorizontal2(X,Y,List,List2,0,Num,Num3):- matrixSize(Size),
                                              Y2 is Y+1,
                                              Y2 =< Size,
                                              pares(X,Y2,0),
                                              retract(pares(X,Y2,_)),
                                              assert(pares(X,Y2,1)),
                                              Num2 is Num+1,
                                              buscarVertical2(X,Y2,[List|[[X,Y2]]],ListEncontrada,0,Num2,NumEncontrado),
                                              b(ListEncontrada,List2),
                                              a(NumEncontrado,Num3),!.

% Derecha de la posicion actual sin otra posicion encontrada
buscarHorizontal2(X,Y,List,List2,0,Num,Num2):- matrixSize(Size),
                                  Y2 is Y+1,
                                  Y2 =< Size,
                                  not(pares(X,Y2,0)),
                                  buscarHorizontal2(X,Y,List,List2,1,Num,Num2),!.

% !
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Izquierda de la posicion actual por fuera de la matriz
buscarHorizontal2(X,Y,List,List2,1,Num,Num2):- Y2 is Y-1,
                                               Y2<0,
					       buscarVertical2(X,Y,List,List2,1,Num,Num2),!.

% Izquierda de la posicion actual con otra posicion encontrada
buscarHorizontal2(X,Y,List,List2,1,Num,Num3):-Y2 is Y-1,
                                              Y2 >= 0,
                                              pares(X,Y2,0),
                                              retract(pares(X,Y2,_)),
                                              assert(pares(X,Y2,1)),
                                              Num2 is Num+1,
                                              buscarVertical2(X,Y2,[List|[[X,Y2]]],ListEncontrada,0,Num2,NumEncontrado),
                                              b(ListEncontrada,List2),
                                              a(NumEncontrado,Num3),!.

% Izquierda de la posicion actual sin otra posicion encontrada
buscarHorizontal2(X,Y,List,List2,1,Num,Num2):- Y2 is Y-1,
                                  Y2 >= 0,
                                  not(pares(X,Y2,0)),
                                  buscarVertical2(X,Y,List,List2,1,Num,Num2),!.






grupos(Grupo,Cantidad):- grupo(Grupo,Cantidad).


ejecutar:- iniciar(0,0),!.

iniciar(X,Y):- matrixSize(Size),
               X =< Size,
               Y =< Size,
               pares(X,Y,0),
               retract(pares(X,Y,_)),
               assert(pares(X,Y,1)),
               buscarVertical(X,Y,[X,Y],0,1),
               Y2 is Y+1,
               iniciar(X,Y2).

iniciar(X,Y):- matrixSize(Size),
               X =< Size,
               Y =< Size,
               not(pares(X,Y,0)),
               Y2 is Y+1,
               iniciar(X,Y2).


iniciar(X,Y):- matrixSize(Size),
               X =< Size,
               Y > Size,
               X2 is X+1,
               Y2 is 0,
               iniciar(X2,Y2).



iniciar(X,_):- matrixSize(Size),
               X >Size,!.


insertarBD:-
	assert(pares(0,0,0)),
	assert(pares(0,1,0)),
	assert(pares(1,0,0)),
	assert(pares(1,1,0)),
	assert(pares(2,0,0)),
	assert(pares(2,1,0)),
        assert(pares(2,2,0)),
        assert(pares(1,2,0)).







