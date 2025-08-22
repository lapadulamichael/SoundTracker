
(*
	------------------------------------
	implementation signal.ml
	------------------------------------
	@auteur 1 :
	  nom : Michael Lapadula
		code permanent : LAPM67010405
*)

Random.self_init ()

type signal = float list

type filtre = signal

type statistiques = {
  moyenne   : float ;
	ecartType : float ;
}

let rec bruitBlanc (n : int) : signal = 
match n with 
| 0 -> []
| _ -> (Random.float 20.0 -. 10.0) :: bruitBlanc (n-1)

let calculerStatistique (vs : signal) : statistiques =
	let rec somme (vs : signal) : float = 
	(** Cette fonction calcule la somme d'une liste de float.
 	* @param vs est la liste utilisée pour calculé la somme des valeurs.
 	* @return un float représentant la somme des valeurs de vs.
 	*
	*)
	match vs with
	| [] -> 0.0
	| v :: reste -> v +. somme (reste) 
	in 
	let rec sommedecarre (vs : signal) : float = 
	(** Cette fonction calcule la somme du carré des valeurs d'une liste de float.
	* @param vs est la liste utilisée pour calculé la somme du carré des valeurs.
 	* @return un float représentant la somme du carré des valeurs de vs.
	*)
	match vs with
	| [] -> 0.0
	| v :: reste -> (v**2.0) +. sommedecarre (reste) in 
	let n = float_of_int(List.length vs) 
	in 
	let moyenne = somme vs /. n in
	let moyennecarre = sommedecarre vs /. n in 
	let ecartType_presqrt = moyennecarre -. (moyenne**2.0) in 
	{ moyenne ; ecartType = sqrt ecartType_presqrt }

let mulSignal (xs : signal) (ys : signal) : signal =
  let rec correcteur l =
	(** Cette fonction prend une liste et remplace chaque valeur de celle-ci
	* dépassant les limites -10.0 à 10.0 par la limite la plus proche. Par 
	*	exemple, chaque valeur plus petite que -10.0 deviendra -10.0 et toute 
	*	valeur plus grande que 10.0 deviendra 10.0.
	* @param l une liste de float.
	*	@return la liste de float l mais corrigée.
	*)
    match l with
    | [] -> []
    | x :: reste ->
      let corr =
        if x > 10.0 then 10.0
        else if x < -10.0 then -10.0
        else x
			in
			corr :: correcteur reste
	in
	let mul2signaux = List.map2 ( *. ) xs ys in
	correcteur mul2signaux

let rec getter_list (l : signal) (i : int) : float = 
(** Cette fonction retourne la valeur se trouvant a l'index i
*	d'une liste de float.
* @param l la liste de float dans laquelle on va trouver la valeur à l'index voulu.
* @param i un entier correspondant à l'index voulu.
* @return un float correspondant à la valeur à l'index i de la liste l.
* @raise Failure "Erreur : out of bounds" si i est hors des bornes de l.
*)
	match l with 
	| [] -> failwith "Erreur : out of bounds"
	| x :: xs -> if i = 0 then x else getter_list xs (i -1)

let convolution (fs : filtre) (vs : signal) : signal = 
let n = List.length fs in 
let c = List.length vs in 
let m = n / 2 in 
let rec loop1 j =
(** Cette sous-fonction sert de boucle qui applique la convolution
* à chaque indice du signal vs. 
* @param j c'est l'indice qui est actuellement en traitement
* @return une liste de float représentant le résultat de la convolution.
*) 
	if j >= c then []
	else 
		let rec loop2 i (acc : float) = 
		(** Cette sous-fonction sert de boucle qui accumule un float
		* qui est le résultat la convolution du signal vs avec le filtre
		* centré à l'indice j et qui prendra la position de la valeur à 
		* l'indice j de la liste résultante.
		* @param i c'est l'indice actuel dans le filtre.
		* @param acc c'est le montant accumulé.
		*	@return le float résultant de la convolution de l'indice j.
		*)
			if i >= n then acc
			else 
				let k = j - m + i in
				if k >= 0 && k < c then 
					let acc'  = acc +. getter_list fs i *. getter_list vs k in
					loop2 (i+1) acc' 
				else 
					loop2 (i+1) acc
		in
		let yi = loop2 0 0.0 in
		yi :: loop1 (j + 1) in
		loop1 0;;