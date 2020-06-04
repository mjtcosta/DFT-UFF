#!/bin/bash

# EDIT THE PSEUDOPOTENTIAL PATH
pseudo_dir="/home/mcosta/qe-6.5/pseudo"

# calculates the Graphene lattice parameter using vc-relax. 

# 
cat > gr.vc-relax.in <<EOF
&control
    calculation = 'vc-relax'
    prefix='graphene',
    pseudo_dir = '$pseudo_dir',
    outdir='./'
    verbosity='high'
    forc_conv_thr = 1d-5,
 /
 &system
    ibrav=  4, 
    a = 2.40 ! a bit smaller then 2.4623
    c = 10
    nat=  2, 
    ntyp= 1,
    ecutwfc = 60.0,
    ecutrho = 720.0,
    occupations = 'smearing', smearing = 'gaussian', degauss = 0.02,
 /
 &electrons
    diagonalization='david'
    mixing_mode = 'plain'
    mixing_beta = 0.7
    conv_thr =  1.0d-8
 /
&ions
      ion_dynamics = 'bfgs',
/
&CELL
    cell_dynamics  = 'bfgs',
    press          = 0.0,
    press_conv_thr = 0.5,
    cell_dofree    = '2Dxy',
/
ATOMIC_SPECIES
C 12.0107 C.pbe-n-kjpaw_psl.1.0.0.UPF
ATOMIC_POSITIONS (crystal)
C   0.333333333  0.666666666  0.500000000
C   0.666666666  0.333333333  0.500000000
K_POINTS automatic
 12 12 1 0 0 0
EOF

pw.x < gr.vc-relax.in > gr.vc-relax.out

