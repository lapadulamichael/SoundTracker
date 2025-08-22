
module Wave :
sig

(*
------------------------------------------------------------------------
-- Le code suivant construit le fichier .WAV.                         --
-- Le code que vous devez construire est à la suite.                  --
-- Remarquez les constantes                                           --
--     _FREQUENCE_ECHANTILLONAGE_INT                                  --
--     _AMPLITUDE_MAXIMUM_INT                                         --
--     _AMPLITUDE_MAXIMUM_FLOAT                                       --
-- qui vous seront utile.                                             --
------------------------------------------------------------------------
*)

    val _FREQUENCE_ECHANTILLONAGE : int
	val _FREQUENCE_ECHANTILLONAGE_FLOAT : float


    val _AMPLITUDE_MAXIMUM : int
	val _AMPLITUDE_MAXIMUM_FLOAT : float

	val ecrireWave : string -> int list -> unit
end