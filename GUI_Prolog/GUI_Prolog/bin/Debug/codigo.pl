/** Base de conocimiento*/

:- dynamic pares/2.

pares(0,0).
pares(1,0).
pares(0,1).
pares(2,2).



conectado(X):-
	pares(X,Z),
	pares(Z,X),
	write('Grupo').
