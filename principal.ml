
open Signal


let _DELTA_COMPARAISON_BRUIT = 0.5
(**
 * _DELTA_COMPARAISON_BRUIT : float
 ******************************************************************************
 * Erreur acceptable pour la moyenne d'un signal de bruit blanc contenant 
 * un grand nombre d'échantillon.
 *)


let _DELTA_COMPARAISON_VAL = 0.00001
(**
 * _DELTA_COMPARAISON_EVAL : float
 ******************************************************************************
 * Erreur acceptable pour les valeurs point flottante dans le TP.
 *)


let approxEgalFloat delta x1 x2 = ( Float.abs ( x1 -. x2 ) ) <= delta 
(**
 * approxEgalFloat : float -> float -> float -> bool
 ******************************************************************************
 * Vérifie l'égalité entre deux valeurs point flottante en acceptant une 
 * marge d'erreur.
 * @param delta Erreur acceptée pour la comparaison.
 * @param x1 Une des deux valeurs comparées.
 * @param x2 Une des deux valeurs comparées.
 * @return 'true' si -delta <= ( x1 - x2 ) <= delta, 'false' sinon.
 *)
 

let listesEgales xs ys =
(**
 * listesEgales : float list -> float list -> bool
 ******************************************************************************
 * Compare deux listes de point flottant pour l'égalité.  Pour être égal, les
 * deux listes doivent avoir la même taille et contenir des valeurs 
 * approximativements égales.
 * @param xs Une des deux listes à comparer.
 * @param ys Une des deux listes à comparer.
 * @return 'true' si les deux listes sont pareil, 'false' sinon.
 *)
    ( ( List.compare_lengths xs ys ) = 0 )
	  &&
	( List.equal ( approxEgalFloat _DELTA_COMPARAISON_VAL ) xs ys )


let egalStatistiques s1 s2 = 
(**
 * egalStatistiques : statistiques -> statistiques -> bool
 ******************************************************************************
 * Vérifie que deux structures de statistiques contiennent des valeurs 
 * approximativements égales.
 * @param s1 Une des deux structures de statistique.
 * @param s2 Une des deux structures de statistique.
 * @return 'true' si les deux structures contiennent les mêmes statistiques,
 * 'false' sinon.
 *)
	approxEgalFloat _DELTA_COMPARAISON_VAL s1.moyenne s2.moyenne
	&&
	approxEgalFloat _DELTA_COMPARAISON_VAL s1.ecartType s2.ecartType
    

let tester1 ( id, test ) =
(**
 * tester1 : ( string, bool ) -> int
 ******************************************************************************
 * Interprète le résultat du test unitaire.
 * Si le résultat est 'false', alors un message est affiché avec 
 * l'identificateur du test érroné.
 * @param (id, test) l'identificateur et le résultat du test.
 * @return '0' si le test est érroné, '1' sinon.
 *)
	if test 
	then 1
    else ( print_endline ( "le test \"" ^ id ^ "\" ne donne pas le bon résultat." ); 0 )
	

let sommeListInt = 
(**
 * sommeListInt : int list -> int
 ******************************************************************************
 * Calcule la somme des valeurs d'une liste d'entier.
 * @param int list : la liste d'entier à sommer.
 * @return la somme des entiers de la liste. 
 *)
	List.fold_left (+) 0


let tester xs = 
(**
 * tester : ( string, bool ) list -> ()
 ******************************************************************************
 * Lance une suite de test unitaire et affiche un rapport d'évaluation.
 * Le rapport va donner l'identificateur des tests érronés et le ratio des
 * tests réussis.
 * @param xs La liste des tests unitaire.
 *)
    let
	    ( reussit, total ) = 
		    let
			    ts = List.map tester1 xs
			in
			    ( sommeListInt ts ), ( List.length ts )
	in
	    print_endline ( ( Int.to_string reussit ) ^ " / " ^ ( Int.to_string total ) )



let testsCalculerStatistique =
(** 
 * testsCalculerStatistique : ( string, bool ) list
 ******************************************************************************
 * Les tests unitaires pour la fonction 'calculerStatistique'.
 *)
    [
	    "stat 1", egalStatistiques { moyenne = 0.; ecartType = 0. } ( calculerStatistique [ 0. ] ) ;
	    "stat 2", egalStatistiques { moyenne = 1.; ecartType = 0. } ( calculerStatistique [ 1. ] ) ;
	    "stat 3", egalStatistiques { moyenne = 0.; ecartType = 0. } ( calculerStatistique [ 0.; 0.; 0.; 0.; 0.; 0.; 0. ] ) ;
	    "stat 4", egalStatistiques { moyenne = 0.; ecartType = 1. } ( calculerStatistique [ 1.; -1.; 1.; -1.; 1.; -1. ] ) ;
	]


let testsBruitBlanc =
(** 
 * testsBruitBlanc : ( string, bool ) list
 ******************************************************************************
 * Les tests unitaires pour la fonction 'bruitBlanc'.
 *)
    [
		"bruit 1", approxEgalFloat _DELTA_COMPARAISON_BRUIT 0.0 ( calculerStatistique ( bruitBlanc 10_000 ) ).moyenne ;
		"bruit 2", ( (=) 10 ) ( List.length ( bruitBlanc 10 ) ) ;
		"bruit 3", ( (=) 1_000 ) ( List.length ( bruitBlanc 1_000 ) ) ;
		"bruit 4", ( (=) 0 ) ( List.length ( bruitBlanc 0 ) ) ;
	]
	
	
let testsMulSignal =
(** 
 * testsMulSignal : ( string, bool ) list
 ******************************************************************************
 * Les tests unitaires pour la fonction 'mulSignal'.
 *)
    [
	    "mul 1", listesEgales [] ( mulSignal [] [] ) ;
	    "mul 2", listesEgales [ 2. ] ( mulSignal [ 1. ] [ 2. ] ) ;
	    "mul 3", listesEgales [ 2.; -1.; -0.5 ] ( mulSignal [ 1.; -1.; 0.5 ] [ 2.; 1.; -1. ] ) ;
	    "mul 4", listesEgales [ 10.; -10.; -10. ] ( mulSignal [ 5.; -4.; 5. ] [ 3.; 4.; -2. ] ) ;
	]
	
	
let testsConvolution =
(** 
 * testsConvolution : ( string, bool ) list
 ******************************************************************************
 * Les tests unitaires pour la fonction 'convolution'.
 *)
    [
		"con 1", listesEgales [] ( convolution [ 0. ] [] ) ;
		"con 2", listesEgales [ 0.4 ] ( convolution [ 0.1; 0.2; 0.4; 0.2; 0.1 ] [ 1. ] ) ;
		"con 3", listesEgales [ 1.; 2.; 3.; -1.; -2. ] ( convolution [ 1. ] [ 1.; 2.; 3.; -1.; -2. ] ) ;
		"con 4", listesEgales [ 0.7; 0.9; 1.; 0.9; 0.7 ] ( convolution [ 0.1; 0.2; 0.4; 0.2; 0.1 ] [ 1.; 1.; 1.; 1.; 1. ] ) ;
	]




let () = 
(**
 * () : ()
 ******************************************************************************
 * Le programme principal.
 * Ce programme construit la liste des tests unitaires et les évalues.
 *)
    let
	    tests = testsBruitBlanc @ testsCalculerStatistique @ testsMulSignal @ testsConvolution
	in
		tester tests


(**
 * Compiler avec :
 ******************************************************************************
 * ocamlopt -o tp1 signal.mli signal.ml principal.ml
 *)