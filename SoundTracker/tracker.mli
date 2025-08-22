
module Tracker :
sig

(**
 * Un instrument est une liste de fonction d'onde.
 * Une onde est un choix parmit 3 :
 * Sin : une onde sinusoidale.
 * Pulse : une onde rectangulaire.
 * Triangle : une onde triangulaire.
 *
 * Les ondes ont des paramètres
 * e : Le temps pour la première enveloppe.
 * a^1 : L'amplitude de la première enveloppe.
 * a^2 : L'amplitude de la deuxième enveloppe.
 * \phi : Le déphasage de l'onde.
 * q : La ratio haut/bas d'une période de l'onde.
 *     Pour les ondes Pulse et Triangle seulement.
 *)
type onde = 
      (* e, a^1, a^2, \phi *)
      Sin of float * float * float * float
    | 
	  (* e, a^1, a^2, q, \phi *)
	  Pulse of float * float * float * float * float
	|
	  (* e, a^1, a^2, q, \phi *)
	  Triangle of float * float * float * float * float

type instrument = onde list


(**
 * Une piste est une suite d'instructions joué par 1 instrument.
 * Chaque élément de la suite à la même durée (dure le même temps).
 *
 * Une instruction est 1 de trois élément :
 * S : une note silencieuse, reste 0.0 pour le temps de la note.
 * N : Le début d'une note.
 *    char : Une lettre entre 'A' et 'G', représentant la note.
 *    bool : Une note peut avoir un dièse.
 *    int : L'octave de la note.
 *    float : Le volume de la note.
 * C : Indique que l'élément précédant de la piste continue
 *    pour un autre instruction.
 *)
type instruction = 
      S
	| (* note, est_dièse, octave, volume *)
	  N of char * bool * int * float
	|
	  C

type piste = {
    inst : instrument;
	instructions : instruction list;
}


(**
 * Un ordre représente l'ordre des pistes pour une musique.
 *     dure : la dure de chaque instruction dans la musique.
 *     patrons : la liste des patrons qui seront jouées en parallèle.
 *         ( nous pouvons percevoir chaque patron comme étant un 
 *           musicien qui joue. )
 * 
 * Un patron représente une suite de piste qui sont jouées une après 
 * l'autre par le musicien.
 *)
type patron = piste list

type ordre = {
    dure : float;
	patrons : patron list;
}

(**
 * Cette fonction construit la séquence d'échantillon à partir de
 * la description de la musique.
 * @param ordre : La description de la musique.
 *)
val genererEchantillon : ordre -> int list

end