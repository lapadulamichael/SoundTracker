
open Wave
open Tracker

let ( i0 : Tracker.instrument ) = [
	Triangle (0.2, 0.5, 0.25, 1.0, 0.0);
    Pulse    (0.2, 0.7, 0.35, 0.5, 0.0) ]
let ( i1 : Tracker.instrument ) = [
    Triangle (0.1, 0.5, 0.25, 1.0, 0.0);
    Pulse    (0.1, 0.7, 0.35, 0.5, 0.0) ]
let ( i2 : Tracker.instrument ) = [
    Triangle (0.05, 0.5, 0.25, 1.0, 0.0);
    Pulse    (0.05, 0.7, 0.35, 0.5, 0.0) ]
let ( i3 : Tracker.instrument ) = [
    Sin      (0.0, 0.0, 0.025, 0.0) ]
let ( i4 : Tracker.instrument ) = [
    Triangle (0.054, 0.7, 0.0, 0.93, 0.0);
    Triangle (0.031, 0.7, 0.0, 0.87, 0.50);
    Triangle (0.042, 0.7, 0.0, 0.76, 0.82);
    Triangle (0.012, 0.7, 0.0, 0.62, 0.15);
    Triangle (0.032, 0.7, 0.0, 0.52, 0.34);
    Triangle (0.002, 0.7, 0.0, 0.45, 0.94);
    Triangle (0.042, 0.7, 0.0, 0.28, 0.24);
    Triangle (0.025, 0.7, 0.0, 0.09, 0.04) ]
let ( i5 : Tracker.instrument ) = [
    Triangle (0.054, 0.7, 0.01, 0.93, 0.0);
    Triangle (0.031, 0.7, 0.01, 0.87, 0.50);
    Triangle (0.042, 0.7, 0.01, 0.76, 0.82);
    Triangle (0.012, 0.7, 0.01, 0.62, 0.15);
    Triangle (0.032, 0.7, 0.01, 0.52, 0.34);
    Triangle (0.002, 0.7, 0.01, 0.45, 0.94);
    Triangle (0.042, 0.7, 0.01, 0.28, 0.24);
    Triangle (0.025, 0.7, 0.01, 0.09, 0.04);
    Triangle (0.051, 0.7, 0.01, 0.95, 0.05);
    Triangle (0.021, 0.7, 0.01, 0.27, 0.52);
    Triangle (0.044, 0.7, 0.01, 0.77, 0.72);
    Triangle (0.022, 0.7, 0.01, 0.32, 0.19);
    Triangle (0.035, 0.7, 0.01, 0.58, 0.24);
    Triangle (0.042, 0.7, 0.01, 0.35, 0.91);
    Triangle (0.048, 0.7, 0.01, 0.24, 0.74);
    Triangle (0.025, 0.7, 0.01, 0.19, 0.08) ]

let ( p0 : Tracker.piste ) = { 
	inst = i3;
	instructions = [ N ( 'G', true, 0, 0.1 ); C; C; C; C; C; C; C ];
}
let ( p1 : Tracker.piste ) = {
    inst = i0;
	instructions = [ N ( 'C', false, 4, 0.33 ); C;
   	                 N ( 'D', false, 4, 0.33 ); C;
					 N ( 'E', false, 4, 0.33 ); C;
					 N ( 'C', false, 4, 0.33 ); C ];
}
let ( p2 : Tracker.piste ) = {
    inst = i0;
	instructions = [ N ( 'E', false, 4, 0.33 ); C;
   	                 N ( 'F', false, 4, 0.33 ); C;
					 N ( 'G', false, 4, 0.33 ); C; C; C ];
}
let ( p3 : Tracker.piste ) = {
    inst = i0;
	instructions = [ N ( 'G', false, 4, 0.33 );
   	                 N ( 'A', false, 4, 0.33 );
   	                 N ( 'G', false, 4, 0.33 );
   	                 N ( 'F', false, 4, 0.33 );
					 N ( 'E', false, 4, 0.33 ); C;
					 N ( 'C', false, 4, 0.33 ); C ];
}
let ( p4 : Tracker.piste ) = {
    inst = i0;
	instructions = [ N ( 'D', false, 4, 0.33 ); C;
   	                 N ( 'G', false, 4, 0.33 ); C;
					 N ( 'C', false, 4, 0.33 ); C; C; C ];
}
let ( p5 : Tracker.piste ) = {
    inst = i1;
	instructions = [ N ( 'C', false, 5, 0.41 ); C;
   	                 N ( 'D', false, 5, 0.41 ); C;
					 N ( 'E', false, 5, 0.41 ); C;
					 N ( 'C', false, 5, 0.41 ); C ];
}
let ( p6 : Tracker.piste ) = {
    inst = i1;
	instructions = [ N ( 'E', false, 5, 0.41 ); C;
   	                 N ( 'F', false, 5, 0.41 ); C;
					 N ( 'G', false, 5, 0.41 ); C; C; C ];
}
let ( p7 : Tracker.piste ) = {
    inst = i1;
	instructions = [ N ( 'G', false, 5, 0.41 );
   	                 N ( 'A', false, 5, 0.41 );
   	                 N ( 'G', false, 5, 0.41 );
   	                 N ( 'F', false, 5, 0.41 );
					 N ( 'E', false, 5, 0.41 ); C;
					 N ( 'C', false, 5, 0.41 ); C ];
}
let ( p8 : Tracker.piste ) = {
    inst = i1;
	instructions = [ N ( 'D', false, 5, 0.41 ); C;
   	                 N ( 'G', false, 4, 0.41 ); C;
					 N ( 'C', false, 5, 0.41 ); C; C; C ];
}
let ( p9 : Tracker.piste ) = {
    inst = i2;
	instructions = [ N ( 'G', false, 5, 0.35 ); C;
   	                 N ( 'A', false, 5, 0.35 ); C;
					 N ( 'B', false, 5, 0.35 ); C;
					 N ( 'G', false, 5, 0.35 ); C ];
}
let ( p10 : Tracker.piste ) = {
    inst = i2;
	instructions = [ N ( 'B', false, 5, 0.35 ); C;
   	                 N ( 'C', false, 6, 0.35 ); C;
					 N ( 'D', false, 6, 0.35 ); C; C; C ];
}
let ( p11 : Tracker.piste ) = {
    inst = i2;
	instructions = [ N ( 'D', false, 6, 0.35 );
   	                 N ( 'E', false, 6, 0.35 );
   	                 N ( 'D', false, 6, 0.35 );
   	                 N ( 'C', false, 6, 0.35 );
					 N ( 'B', false, 5, 0.35 ); C;
					 N ( 'G', false, 5, 0.35 ); C ];
}
let ( p12 : Tracker.piste ) = {
    inst = i2;
	instructions = [ N ( 'A', false, 5, 0.35 ); C;
   	                 N ( 'D', false, 5, 0.35 ); C;
					 N ( 'G', false, 5, 0.35 ); C; C; C ];
}
let ( p13 : Tracker.piste ) = {
    inst = i4;
	instructions = [ N ( 'D', true, 1, 0.3 ); S; C; C;
   	                 N ( 'A', true, 2, 0.27 ); S; C; C ];
}
let ( p14 : Tracker.piste ) = {
    inst = i4;
	instructions = [ S; C; N ( 'F', true, 3, 0.32 );
   	                 N ( 'F', true, 3, 0.32 ); S; C;
   	                 N ( 'F', true, 3, 0.35 ); S ];
}

let ( t1 : Tracker.patron ) = [ p0; p1; p5; p9;  p13; p14 ]
let ( t2 : Tracker.patron ) = [ p0; p2; p6; p10; p13; p14 ]
let ( t3 : Tracker.patron ) = [ p0; p3; p7; p11; p13; p14 ]
let ( t4 : Tracker.patron ) = [ p0; p4; p8; p12; p13; p14 ]

let ( tracks : Tracker.ordre ) = { 
    dure = 0.25;
	patrons = [ t1; t1; t2; t2; t3; t3; t4; t4 ];
}

let () = Wave.ecrireWave "musique.wav" ( Tracker.genererEchantillon tracks )

(**
 * Compiler avec :
 ******************************************************************************
 * ocamlopt -o tp2 wave.mli wave.ml tracker.mli tracker.ml principal.ml
 *)
 