/** Base de conocimiento*/

:- dynamic pares/2.



conectado(X,Y):-
	pares(X,Y),
	pares(X+1,Y),
	pares(X,Y+1),
	conectado(X,Y).
