/** Base persona*/
persona(lester).
persona(juan).
persona(pedro).

/** Base progenitor, para ejercicio de árbol familiar*/

progenitor(clara,pedro).
progenitor(pedro,jose).
progenitor(ana,clara).
progenitor(jose,clara).


cargar(A):-exists_file(A),consult(A).

/**Es par*/
es_par(X):- 0 is X mod 2.

/**Otras*/
abuelo(X,Y):- progenitor(X,Z) , progenitor(Z,Y).

bisabuelo(X,Y):- progenitor(X,Z), abuelo(Z,Y).

