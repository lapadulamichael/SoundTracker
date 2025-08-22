
module Tracker =

struct

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


type patron = piste list

type ordre = {
    dure : float;
	patrons : patron list;
}

open Wave

let f_e = Wave._FREQUENCE_ECHANTILLONAGE_FLOAT
let amplitude_max = float_of_int Wave._AMPLITUDE_MAXIMUM
let notes = function
  | 'C' -> 0 | 'D' -> 2 | 'E' -> 4
	| 'F' -> 5 | 'G' -> 7 | 'A' -> 9
	| 'B' -> 11| _   -> failwith "Err"

let frequence_note (note : char) (diese : bool) (oct : int) : float = 
	(** Cette fonction calcule la frequence d'une note.
	* @param note		la note (C, F, B, D, G, E ou A)
	* @param diese 	si la note est un diese
	* @param oct	 	l'octave de cette note
	* 
	*)
  let u = notes note + (if diese == true then 1 else 0) in
	let h = 12 * oct + u - 57 in
  let z = 2.0 ** (1.0 /. 12.0) in
  440.0 *. (z ** float_of_int h)


let eval_fonction_onde onde (freq : float) (t_k : float) = 
	(** Cette fonction prend une onde et l'evalue en utilisant
	*	la formule lui correspondant.
	* @param onde	l'onde en question
	* @param freq la frequence de cette onde
	* @param t_k 	temps d'indice k
	*)
	match onde with
	| Sin (e, a1, a2, phi) -> 
		(if t_k <= e then a1 else a2) *. sin (2.0 *. Float.pi *. freq *. t_k +. phi)

	| Pulse (e, a1, a2, q, phi) -> 
		(if mod_float ((t_k +. phi) *. freq) 1.0 < q 
			then (if t_k <= e then a1 else a2) 
		else -.(if t_k <= e then a1 else a2))

	| Triangle (e, a1, a2, q, phi) ->
		(if mod_float ((t_k +. phi) *. freq) 1.0 < q 
			then (if t_k <= e then a1 else a2) *. 
		(((2.0 *. (mod_float ((t_k +. phi) *. freq) 1.0)) /. q) -. 1.0)
		else (if t_k <= e then a1 else a2) *. (1.0 *.
		((2.0 *. ((mod_float ((t_k +. phi) *. freq) 1.0) -. q)) /. (1.0 -. q)))
		)

let echantillon instrument (freq : float) (vol : float) (t_k : float) =
	(** Cette fonction calcule l'echantillon w_k qui correspond a la somme
	* de chaque echantillon d'une note sur un temps tk
	* @param instrument	l'instrument utilise
	* @param vol				le volume souhaite
	* @param freq 			la frequence de la note
	*)
  let somme_freq = List.fold_left (fun acc onde -> 
		acc +. eval_fonction_onde onde freq t_k) 0.0 instrument in
  vol *. somme_freq

let echantillon_note instrument (freq : float) (vol : float) (duree : float) =
	(** Cette fonction calcule l'echantillon w_k qui correspond a la somme
	* des ondes a l'instant t_k
	* @param instrument	l'instrument utilise
	* @param vol				le volume souhaite
	* @param freq 			la frequence de la note
	*)
  let n = int_of_float (duree *. f_e) in
  List.init n (fun k -> 
    let t_k = float_of_int k *. (1.0 /. f_e) in
    if k >= max 0 (n -10) then 0.0
    else echantillon instrument freq vol t_k
  )

let rec note_continue = function
  (** Cette fonction calcule pendant combien de temps une note continue 
  * (est allongee).
	*)
  | C :: reste -> 1 + note_continue reste
  | _ -> 0

let list_sub l start len =
	(** Implementation classique de List.sub. Retourne la liste l
	* mais a partir de start et jusqu'a len elements apres.
	* @param l			la liste
	* @param start	ou commencer la nouvelle liste
	* @param len 		la longueur de la nouvelle liste
	*)
  let rec aux i acc = function
    | [] -> List.rev acc
    | x :: xs ->
        if i >= start + len then List.rev acc
        else if i >= start then aux (i + 1) (x :: acc) xs
        else aux (i + 1) acc xs
  in
  aux 0 [] l

let echantillon_piste (piste : piste) (duree : float) =
	(** Retourne une liste d'echantillons de note d'une piste. On calcule
	* la valeure de chaque instruction.
	* @param piste	la piste
	* @param duree	la duree de la piste
	*)
	let rec loop acc instr current =
		(** Une boucle qui partoure chaque instructions de la piste et 
		* l'evalue en fonction de sa nature.
		* @param acc			l'accumulateur qui accumule la liste retournee
		* @param instr		l'instruction
		* @param current 	correspond a la derniere note jouee (utile s'il 
		*									faut l'allonger)
		*)
		match instr with 
		| [] -> List.rev acc
		| S :: reste ->
			let silence = List.init (int_of_float (duree *. f_e)) (fun _ -> 0.0) in
			loop (List.rev_append silence acc) reste None
		| N (note, diese, oct, vol) :: reste ->
			let freq = frequence_note note diese oct in
			let continue_note = note_continue reste in
			let new_duree = duree *.(float_of_int (continue_note + 1)) in
			let echant_note = echantillon_note piste.inst freq vol new_duree in
			let rest = List.drop continue_note reste in
			loop (List.rev_append echant_note acc) rest (Some echant_note)
		| C :: reste ->
				loop (List.rev_append 
				(match current with
					| Some prev -> list_sub prev 0 (int_of_float (duree *. f_e))
					| None -> List.init (int_of_float (duree *. f_e)) (fun _ -> 0.0)) 
					acc) reste current
					in
    loop [] piste.instructions None

let mix_suites (suites : float list list) =
	(** Cette fonction assamble les suites d'echantillon d'un patron 
	* en une seule liste en les additionnant index par index.
	* @param piste	la suite
	*)
  let tab = List.map Array.of_list suites in
  let length = Array.length (List.hd tab) in
	List.init length (fun i -> List.fold_left (fun acc val_piste -> 
		acc +. val_piste.(i))
		0.0 tab
  )

let cat_patrons (ord : ordre) =
	(** Cette fonction prends tous les patrons, les mixe (avec mix_suites)
	* et les mets dans une seule liste. 
	* @param ordre l'ordre contenant les patrons
	*)
	List.flatten (List.map (fun patron ->
    let pistes_evaluees = List.map (fun piste -> 
			echantillon_piste piste ord.dure) patron in
    mix_suites pistes_evaluees 
  ) ord.patrons)
	
let genererEchantillon (ord : ordre) : int list =
	(** Cette fonction genere une liste d'int qui correspondent aux
	* valeurs des patrons une fois evalues et echantillonnes.
	* @param ord	l'ordre contenant les patrons
	*)
  let result = cat_patrons ord in
  List.map (fun x ->
    let amp = x *. amplitude_max in
		let amp = if amp > amplitude_max then amplitude_max
		else if amp < -.amplitude_max then -.amplitude_max
		else amp in
    Int.of_float amp
  ) result

end