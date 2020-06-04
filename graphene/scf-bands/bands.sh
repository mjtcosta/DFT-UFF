#!/bin/bash

# EDIT THE PSEUDOPOTENTIAL PATH
pseudo_dir="/home/mcosta/qe-6.5/pseudo"

# calculates the Graphene band strucutre along the path G-K-M-G 


# first perform a SCF calculation
cat > gr.scf.in <<EOF
&control
    calculation = 'scf'
    restart_mode='from_scratch',
    prefix='graphene',
    pseudo_dir = '$pseudo_dir',
    outdir='./'
    verbosity='high'
 /
 &system
    ibrav=  4, 
    a = 2.4623
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
ATOMIC_SPECIES
C 12.0107 C.pbe-n-kjpaw_psl.1.0.0.UPF
ATOMIC_POSITIONS (crystal)
C   0.333333333  0.666666666  0.500000000
C   0.666666666  0.333333333  0.500000000
K_POINTS automatic
 12 12 1 0 0 0
EOF

pw.x < gr.scf.in > gr.scf.out

# Second a band structure calculation that read the converged SCF potential
cat > gr.bands.in <<EOF
&control
    calculation = 'bands'
    prefix='graphene',
    pseudo_dir = '$pseudo_dir',
    outdir='./'
    verbosity='high'
 /
 &system
    ibrav=  4, 
    a = 2.4623
    c = 10
    nat=  2, 
    ntyp= 1,
    ecutwfc = 60.0,
    ecutrho = 720.0,
    occupations = 'smearing', smearing = 'gaussian', degauss = 0.02,
    nbnd = 8, ! number of bands included in the calculation. Otherwise only the valence bands will be shown
 /
 &electrons
    diagonalization='david'
    mixing_mode = 'plain'
    mixing_beta = 0.7
    conv_thr =  1.0d-8
 /
ATOMIC_SPECIES
C 12.0107 C.pbe-n-kjpaw_psl.1.0.0.UPF
ATOMIC_POSITIONS (crystal)
C   0.333333333  0.666666666  0.500000000
C   0.666666666  0.333333333  0.500000000
!FCC (face-centered cubic) G-K-M-G
K_POINTS crystal_b
4
   0.000000000   0.000000000   0.000000000 20  ! \Gamma
   0.333333333   0.333333333   0.000000000 20  ! K
   0.000000000   0.500000000   0.000000000 20  ! M
   0.000000000   0.000000000   0.000000000 20  ! \Gamma
EOF

pw.x < gr.bands.in > gr.bands.out


cat > gr.bands-plot.in << EOF
 &bands
    prefix='graphene',
    outdir='./'
    filband='gr.band'
    lsym=.true.,
 /
EOF


bands.x < gr.bands-plot.in > gr.bands-plot.out
