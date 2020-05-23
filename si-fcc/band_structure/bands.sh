#!/bin/bash

# EDIT THE PSEUDOPOTENTIAL PATH
pseudo_dir="/home/mcosta/qe-6.5/pseudo"

# calculates the Si-FCC band strucutre along the path G-X-W-K-G-L-U-W-L-K U-X 

# SUGGESTION
# change the kpoints in the SCF calculation. Is there any changes in the bandstructure

# PLOT
# The band strucutre plot can be done using pw_band_plot.py 

# first perform a SCF calculation
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

# Second a band structure calculation that read the converged SCF potential
cat > si.bands.in <<EOF
&control
    calculation = 'bands'
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
    nbnd = 8, ! number of bands included in the calculation. Otherwise only the valence bands will be shown
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

!FCC (face-centered cubic) G-X-W-K-G-L-U-W-L-K U-X 
K_POINTS crystal_b
11
   0.0000   0.0000   0.0000 20  ! \Gamma
   0.5000   0.0000   0.5000 20  ! X
   0.5000   0.2500   0.7500 20  ! W
   0.3750   0.3750   0.7500 20  ! K
   0.0000   0.0000   0.0000 20  ! \Gamma
   0.5000   0.5000   0.5000 20  ! L
   0.6250   0.2500   0.6250 20  ! U
   0.5000   0.2500   0.7500 20  ! W
   0.5000   0.5000   0.5000 20  ! L
   0.6250   0.2500   0.6250 20  ! U
   0.5000   0.0000   0.5000 20  ! X
EOF

pw.x < si.bands.in > si.bands.out


cat > si.bands-plot.in << EOF
 &bands
    prefix='silicon',
    outdir='./'
    filband='si.band'
    lsym=.true.,
 /
EOF


bands.x < si.bands-plot.in > si.bands-plot.out
