#!/bin/bash

# EDIT THE PSEUDOPOTENTIAL PATH
pseudo_dir="/home/mcosta/qe-6.5/pseudo"


# Calculate the PDOS for a 64x64 k-grid. Suggestion reduce the k-mesh 
# to what happens to the pdos

# first perform a SCF calculation
cat > gr.scf.in <<EOF
&control
    calculation = 'scf'
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
    occupations = 'smearing', smearing = 'gaussian', degauss = 0.01,
 /
 &electrons
    diagonalization='david'
    mixing_mode = 'plain'
    mixing_beta = 0.7
    conv_thr =  1.0d-8
    startingpot='file'
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

# second perform a NSCF calculation on larger K-mese
cat > gr.nscf.in <<EOF
&control
    calculation = 'nscf'
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
    occupations = 'smearing', smearing = 'gaussian', degauss = 0.01,
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
 64 64 1 0 0 0
EOF

pw.x < gr.nscf.in > gr.nscf.out

# Calculates the PDOS 
cat > gr.pdos.in << EOF
 &projwfc
    outdir='./'
    prefix='graphene'
    Emin=-10.0, Emax=10.0, DeltaE=0.1
    !ngauss=1, degauss=0.01
 /
EOF

projwfc.x < gr.pdos.in > gr.pdos.out
######### PDOS ################
cat > gr.pdos.in << EOF
 &projwfc
    outdir='./'
    prefix='graphene'
    Emin=-10.0, Emax=10.0, DeltaE=0.1
    !ngauss=1, degauss=0.01
 /
EOF

projwfc.x < gr.pdos.in > gr.pdos.out
