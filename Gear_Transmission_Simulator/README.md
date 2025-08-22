# Gear Transmission Simulator (Prolog)

University project in **Prolog** simulating the transmission of motion in a system of gears and worm screws.  
The program models components and their links, then propagates speed and torque through the system.

## Features
- Define parts:
  - `piece(Id, dents(N)).` — gear with N teeth
  - `piece(Id, vis(N)).` — worm screw with N threads
- Define connections:
  - `lien(essieu, A, B).` — axle link
  - `lien(direct, A, B).` — meshed gears / gear–worm link
  - `lien(chaine, A, B).` — chain link
- Query motion:
  ```prolog
  tourner(Id1, V, C, Id2, RV, RC).

## Test
Consult `tp3.pl` via SWI-Prolog. You can then follow `test.txt` to test an example.