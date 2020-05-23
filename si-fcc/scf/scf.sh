#!/bin/bash

# EDIT THE PSEUDOPOTENTIAL PATH
pseudo_dir="/home/mcosta/qe-6.5/pseudo"


# Performs a self consistent calculation (SCF)

cat > si.scf.in <<EOF
&control
    calculation = 'scf'
    restart_mode='from_scratch',
    prefix='silicon',
    tstress = .true.
    tprnfor = .true.
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


