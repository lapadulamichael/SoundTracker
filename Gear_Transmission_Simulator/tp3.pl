% deux types d'entrees
:- dynamic pieces/2.
:- dynamic liens/3.


piece_type_valide(dents(N)) :-
	N > 0.
piece_type_valide(vis(N)) :-
	member(N, [1,2,3,4]).

lien_type_valide(essieu).
lien_type_valide(direct).
lien_type_valide(chaine).

% ajouter une piece
piece(Id, Type) :- 
	\+ pieces(Id, _),
	piece_type_valide(Type),
	assertz(pieces(Id, Type)), !.
piece(_, _) :-
	format("Add piece failed"),
	fail.

% ajouter un lien
lien(Type, Id1, Id2) :- 
	pieces(Id1, _),
	pieces(Id2, _),
	Id1 \= Id2,
	lien_type_valide(Type),
	assertz(liens(Type, Id1, Id2)), !.
lien(_, _, _):-
	format("Add lien failed"),
	fail.

% piece ciblee trouvee
parcourir(Id, V, C, Id, _, V, C) :- !.

% parcourir le graphe et transmet la V et le  C
parcourir(Actuel, V, C, Cible, Visites, RV, RC) :-
    voisins(Actuel, Voisin, TypeLien),
    \+ member(Voisin, Visites),  % éviter cycles

    pieces(Actuel, TypeA),
    pieces(Voisin, TypeB),

    transmettre(TypeLien, TypeA, TypeB, V, C, V2, C2),
    
    parcourir(Voisin, V2, C2, Cible, [Voisin|Visites], RV, RC).

% trouver voisins
voisins(A, B, Type) :- liens(Type, A, B).
voisins(B, A, Type) :- liens(Type, A, B).

% essieu
transmettre(essieu, _, _, VA, CA, VA, CA).

% piece B = vis -> impossible
transmettre(direct, _, vis(_), _, _, _, _) :- !, fail.

% piece A = vis
transmettre(direct, vis(S), dents(DB), VA, CA, VB, CB) :-
	VB0 is ((S / DB) * VA),
	CB0 is ((VA / VB0) * CA),
	efficacite(direct_vis(S), E),
	VB is VB0 * E,
    CB is CB0 * E.
	
% deux roues, lien direct
transmettre(direct, dents(DA), dents(DB), VA, CA, VB, CB) :-
    VB0 is -((DA / DB) * VA),
	CB0 is (VA / VB0) * CA,
    efficacite(direct, E),
    VB is VB0 * E,
    CB is CB0 * E.

% deux roues, lien chaine
transmettre(chaine, dents(DA), dents(DB), VA, CA, VB, CB) :-
    VB0 is (DA / DB) * VA,
	CB0 is (VA / VB0) * CA,
    efficacite(chaine, E),
    VB is VB0 * E,
    CB is CB0 * E.

efficacite(essieu, 1.0).
efficacite(direct, 0.9).
efficacite(chaine, 0.8).
efficacite(direct_vis(1), 0.8).
efficacite(direct_vis(2), 0.7).
efficacite(direct_vis(3), 0.6).
efficacite(direct_vis(4), 0.5).

tourner(Id1, V, C, Id2, RV, RC) :-
    parcourir(Id1, V, C, Id2, [Id1-V-C], RV, RC).