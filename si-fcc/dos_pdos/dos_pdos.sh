#!/bin/bash

# EDIT THE PSEUDOPOTENTIAL PATH
pseudo_dir="/home/mcosta/qe-6.5/pseudo"

# calculates the density of states (DOS) and projected DOS (PDOS).

# SUGGESTION
# change the K_POINTS parameters to see how the DOS and PDOS changes.

# DOS
# the DOS file is given by si.dos

#PDOS
# the PDOS files are : 'silicon.pdos_atm#1(Si)_wfc#1(s)' 'silicon.pdos_atm#1(Si)_wfc#2(p)' 'silicon.pdos_atm#2(Si)_wfc#1(s)' 'silicon.pdos_atm#2(Si)_wfc#1(p)'

# Notice occupations flags have been included.

cat > si.scf.in<<EOF
&control
    calculation = 'scf'
    restart_mode='from_scratch',
    prefix='silicon',
    pseudo_dir = '$pseudo_dir',
    outdir='./'
    verbosity='high'
 /
 &system
    ibrav=  2, 
    celldm(1) =10.20, 
    nat=  2, 
    ntyp= 1,
    ecutwfc =32.0,
    occupations='smearing',
    smearing='gaussian',
    degauss=0.01
 /
 &electrons
    diagonalization='david'
    mixing_mode = 'plain'
    mixing_beta = 0.7
    conv_thr =  1.0d-8
 /
ATOMIC_SPECIES
 Si  28.086  Si.pz-vbc.UPF
ATOMIC_POSITIONS alat
 Si 0.00 0.00 0.00
 Si 0.25 0.25 0.25
K_POINTS automatic
4 4 4 0 0 0
EOF

pw.x < si.scf.in > si.scf.out

######### DOS ################
cat > si.dos.in << EOF
 &dos
    outdir='./'
    prefix='silicon'
    fildos='si.dos',
    Emin=-10.0, Emax=10.0, DeltaE=0.1
 /
EOF

dos.x < si.dos.in > si.dos.out


######### PDOS ################
cat > si.pdos.in << EOF
 &projwfc
    outdir='./'
    prefix='silicon'
    Emin=-10.0, Emax=10.0, DeltaE=0.1
    !ngauss=1, degauss=0.01
 /
EOF

projwfc.x < si.pdos.in > si.pdos.out
