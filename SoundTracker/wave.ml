
module Wave =

struct

	let _OCTETS_PAR_ECHANTILLON : int = 
	    2

	let _FREQUENCE_ECHANTILLONAGE = 
	    44_100
		
    let _FREQUENCE_ECHANTILLONAGE_FLOAT = 
	    Float.of_int _FREQUENCE_ECHANTILLONAGE

	let _AMPLITUDE_MAXIMUM = 
	    ( Int.shift_left 1 ( _OCTETS_PAR_ECHANTILLON * 8 - 1 ) ) - 1
		
	let _AMPLITUDE_MAXIMUM_FLOAT = 
	    Float.of_int _AMPLITUDE_MAXIMUM

    (* Description de fichier RIFF : WAVE 
	   Cette section contient les constructeurs d'entête pour le fichier Wave.
	   Cette entête est divisé en suite d'octet (chunk).
	 *)

	(**
	 * Taille, en octets, de l'informations de base de l'entête du fichier WAVE.
	 *)
	let _TAILLE_CHUNK_BASE : int =
	    20

	(**
	 * fmt
	 *)
	let _TAILLE_SUB_CHUNK_1 : int = 
	    16

    (**
	 * PCM
	 *)
	let _FORMAT_AUDIO : int =
	    1

	(**
	 * Mono
	 *)
	let _NB_CANALS : int =
	    1

	(**
	 * Taille des blocks
	 *)
	let _OCTETS_PAR_BLOCK : int = 
	    _NB_CANALS * _OCTETS_PAR_ECHANTILLON

    let _taille_sub_chunk_2 ( nbEchantillon : int ) : int =
		nbEchantillon * _OCTETS_PAR_BLOCK

    (**
     * Calcule la taille totale du fichier RIFF.
	 * @param nbEchantillon, le nombre d'échantillons qui seront placés dans le fichier.
	 * @return le nombre d'octet que contiendra le fichier.
	 *)
    let tailleChunkRiff ( nbEchantillon : int ) : int = 
	    _TAILLE_CHUNK_BASE + _TAILLE_SUB_CHUNK_1 + ( _taille_sub_chunk_2 nbEchantillon )

	(**
	 * Construit une sequence de 1 octet avec la valeur indiquée.
	 * @param v, la valeur a placer dans un octet.
	 * @return la séquence de 1 octet contenant v à la position 0.
	 *)
	let create_bytes_int_8 ( v : int ) : bytes =
	    let
		    resultat = Bytes.create 1
		in
	        ( Bytes.set_int8 resultat 0 v ) ; resultat

	(**
	 * Construit une sequence de 2 octets avec la valeur indiquée.
	 * @param v, la valeur a placer sur 2 octets.
	 * @return la séquence de 2 octets contenant v à partir de la position 0 en little-endian.
	 *)
	let create_bytes_int_16_le ( v : int ) : bytes =
	    let
		    resultat = Bytes.create 2
		in
	        ( Bytes.set_int16_le resultat 0 v ) ; resultat

	(**
	 * Construit une sequence de 4 octets avec la valeur indiquée.
	 * @param v, la valeur a placer sur 4 octets.
	 * @return la séquence de 4 octets contenant v à partir de la position 0 en little-endian.
	 *)
	let create_bytes_int_32_le ( v : int ) : bytes =
	    let
		    resultat = Bytes.create 4
		in
	        ( Bytes.set_int32_le resultat 0 ( Int32.of_int v ) ) ; resultat

	(**
	 * Nb octets par seconde.
	 *)
	let _FREQUENCE_OCTETS : int = 
	    _FREQUENCE_ECHANTILLONAGE * _NB_CANALS * _OCTETS_PAR_ECHANTILLON

	(**
	 * Nb bits par échantillons
	 *)
	let _BITS_PAR_ECHANTILLON = 
		_OCTETS_PAR_ECHANTILLON * 8


	(**
	 * Premier chunk.
	 *)
	let _SUB_CHUNK_1 : bytes = 
	    Bytes.concat Bytes.empty
 		    [ Bytes.of_string  "fmt ";
              create_bytes_int_32_le _TAILLE_SUB_CHUNK_1;
              create_bytes_int_16_le _FORMAT_AUDIO;
              create_bytes_int_16_le _NB_CANALS;
              create_bytes_int_32_le _FREQUENCE_ECHANTILLONAGE;
              create_bytes_int_32_le _FREQUENCE_OCTETS;
              create_bytes_int_16_le _OCTETS_PAR_BLOCK;
              create_bytes_int_16_le _BITS_PAR_ECHANTILLON
            ]


	let create_bytes_echantillon ( echantillons : int list ) ( taille : int ) : bytes =
	    let 
		    tableau = Bytes.create taille
		in
			let rec _remplir_bytes_echantillon i ds =
				match ds with
				| [] -> ()
				| e :: es -> 
					( if _OCTETS_PAR_ECHANTILLON == 1
					  then Bytes.set_int8 tableau i
					  else Bytes.set_int16_le tableau ( 2 * i )
					) e;
					( _remplir_bytes_echantillon ( i + 1 ) es )
			in
				( _remplir_bytes_echantillon 0 echantillons ); tableau


	let create_sub_chunk_2 ( nbEchantillon : int ) ( echantillons : int list ) : bytes =
	    let 
		    taille = _taille_sub_chunk_2 nbEchantillon
		in
			Bytes.concat Bytes.empty 
				[ Bytes.of_string "data";
				  create_bytes_int_32_le taille;
				  create_bytes_echantillon echantillons taille
				]
   
   
	(**
	 * Construit le chunk complet du fichier wave a partir des échantillons.
	 * @param echantillons, la liste d'échantillons a placer dans le fichier WAVE.
	 *)
    let construireChunkRiff ( echantillons : int list ) : bytes =
	    let 
		    nbEchantillon = List.length echantillons
		in
		    Bytes.concat Bytes.empty
                [ Bytes.of_string "RIFF";
                  create_bytes_int_32_le ( tailleChunkRiff nbEchantillon );
				  Bytes.of_string "WAVE";
				  _SUB_CHUNK_1;
				  create_sub_chunk_2 nbEchantillon echantillons
                ]


	let ecrireWave nomFichier echantillons = 
		let 
			fichier_sortie = open_out_bin nomFichier
		in 
			( output_bytes fichier_sortie ( construireChunkRiff echantillons ) ); 
			( close_out fichier_sortie )





end