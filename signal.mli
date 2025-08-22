(*
	------------------------------------
	interface signal.mli
	------------------------------------
*)

type signal = float list
(**
 * Un type pour représenter un signal.
 * @invariant :
 *     Soit
 *         vs : signal
 *     alors
 *         pour tout v dans vs, -10 <= v <= 10.
 *)


type filtre = signal
(**
 * Un type pour décrire les filtres utilisé pour les convolutions.
 * @invariant :
 *    Soit 
 *        fs : filtre
 *    alors
 *        ( ( length fs ) mod 2. ) = 1.
 *        et
 *        pour tout f dans fs, -1 <= f <= 1.
 *)
 
 
type statistiques = {
    moyenne   : float ;
	ecartType : float ;
}
(**
 * Enregistrement pour contenir les résultats d'une analyse statistiques des
 * valeurs d'une liste.
 *)


val bruitBlanc : int -> signal
(**
 * bruitBlanc n
 ******************************************************************************
 * Cette fonction construit une liste de nombre de type float.
 * Cette liste va contenir des valeurs entre -10.0 et 10.0 inclusivement.
 * @param n indique la taille qu'aura la liste résultante.
 * @return une liste contenant 'n' valeurs aléatoire entre -10.0 et 10.0.
 *)


val calculerStatistique : signal -> statistiques
(**
 * calculerStatistique vs
 ******************************************************************************
 * Cette fonction calcule la moyenne et l'écart type des valeurs d'une liste de
 * float.
 * Une liste vide aura une moyenne de 0.0 et un écart type de 0.0.
 * @param vs la liste des valeurs utilisées pour calculer les 
 *           statistiques.
 * @return un enregistrement de type statistiques contenant les résultats de 
 *         l'analyse.
 *)


val mulSignal : signal -> signal -> signal
(**
 * mulSignal vs ws
 ******************************************************************************
 * multiplie les valeurs des deux signaux, élément à élément.
 * Si une valeur donne plus grande 10., alors elle est remise à 10..
 * Si une valeur donne plus petite que -10., alors elle est remise à -10..
 * @param vs le premier signal.
 * @param ws le deuxième signal.
 * @precondition : ( length vs ) = ( length ws )
 * @return le signal résultant de la multiplication.
 *) 
 
val convolution : filtre -> signal -> signal
(**
 * convolution fs vs
 ******************************************************************************
 * Cette fonction effectue la convolution du signal à l'aide du
 * filtre.
 * @param fs le filtre utilisé pour la convolution.
 * @param vs le signal sur laquelle la convolution est effectué.
 * @return le signal filtrée.
 *)
