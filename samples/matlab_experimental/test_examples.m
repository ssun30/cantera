% runs selected examples without pausing

LoadCantera
clear all
close all

equil();
isentropic();
reactor1();
reactor2();
surfreactor;
periodic_cstr;
rankine(300.0, 2.0*oneatm, 0.8, 0.7);
prandtl1();
flame1;
catcomb;
exit;

clear all
close all
UnloadCantera