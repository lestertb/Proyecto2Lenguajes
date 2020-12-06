%Data dynamic
:- dynamic pares/3.


:- dynamic grupo/2.


:- dynamic matrixSize/1.


%codigo
buscarVertical(X,Y,List,0,Num):- X2 is X-1,
                                 X2<0,
                                 buscarVertical(X,Y,List,1,Num).

buscarVertical(X,Y,List,0,Num):- X2 is X-1,
                                 X2 >= 0,
                                 pares(X2,Y,0),
				 retract(pares(X2,Y,_)),
                                 assert(pares(X2,Y,1)),
                                 Num2 is Num+1,
                                 buscarVertical(X2,Y,[List|[[X2,Y]]],0,Num2),
                                 buscarVertical(X,Y,List,1,Num2),
                                 buscarHorizontal(X,Y,List,0,Num2),
                                 buscarHorizontal(X,Y,List,1,Num2).

buscarVertical(X,Y,List,0,Num):- X2 is X-1,
                                 X2 >= 0,
                                 not(pares(X2,Y,0)),
                                 buscarVertical(X,Y,List,1,Num).

buscarVertical(X,Y,List,1,Num):- matrixSize(Size),
                                 X2 is X+1,
                                 X2>Size,
                                 buscarHorizontal(X,Y,List,0,Num).

buscarVertical(X,Y,List,1,Num):- matrixSize(Size),
                                 X2 is X+1,
                                 X2=<Size,
                                 pares(X2,Y,0),
                                 retract(pares(X2,Y,_)),
                                 assert(pares(X2,Y,1)),
                                 Num2 is Num+1,
                                 buscarVertical(X2,Y,[List|[[X2,Y]]],0,Num2).

buscarVertical(X,Y,List,1,Num):- matrixSize(Size),
                                 X2 is X+1,
                                 X2=<Size,
                                 not(pares(X2,Y,0)),
                                 buscarHorizontal(X,Y,List,0,Num).


buscarHorizontal(X,Y,List,0,Num):- Y2 is Y-1,
                                   Y2<0,
                                   buscarHorizontal(X,Y,List,1,Num).

buscarHorizontal(X,Y,List,0,Num):- Y2 is Y-1,
                                   Y2 >= 0,
                                   pares(X,Y2,0),
                                   retract(pares(X,Y2,_)),
                                   assert(pares(X,Y2,1)),
                                   Num2 is Num+1,
                                   buscarVertical(X,Y2,[List|[[X,Y2]]],0,Num2).

buscarHorizontal(X,Y,List,0,Num):- Y2 is Y-1,
                                   Y2 >= 0,
                                   not(pares(X,Y2,0)),
                                   buscarHorizontal(X,Y,List,1,Num).

buscarHorizontal(X,Y,List,1,Num):- matrixSize(Size),
                                   Y2 is Y+1,
                                   Y2>Size,
                                   buscarHorizontal(X,Y,List,2,Num).

buscarHorizontal(X,Y,List,1,Num):- matrixSize(Size),
                                   Y2 is Y+1,
                                   Y2=<Size,
                                   pares(X,Y2,0),
                                   retract(pares(X,Y2,_)),
                                   assert(pares(X,Y2,1)),
                                   Num2 is Num+1,
                                   buscarVertical(X,Y2,[List|[[X,Y2]]],0,Num2).

buscarHorizontal(X,Y,List,1,Num):- matrixSize(Size),
                                   Y2 is Y+1,
                                   Y2=<Size,
                                   not(pares(X,Y2,0)),
				   pares(X,Y,0),
				   retract(pares(X,Y,0)),
				   assert(pares(X,Y,1)),
				   buscarHorizontal(_,_,List,2,Num).

buscarHorizontal(_,_,List,2,Num):- assert(grupo(List,Num)).


buscarHorizontal(X,Y,List,1,Num):- matrixSize(Size),
                                   Y2 is Y+1,
                                   Y2=<Size,
                                   not(pares(X,Y2,0)),
                                   not(pares(X,Y,0)),
				   retract(pares(X,Y,1)),
				   assert(pares(X,Y,0)),
		                   buscarHorizontal(X,Y,List,1,Num).

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
	assert(pares(3,0,0)),
	assert(pares(3,1,0)),
	assert(pares(3,2,0)),
	assert(pares(2,1,0)).





