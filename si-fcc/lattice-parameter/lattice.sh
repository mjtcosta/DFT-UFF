#!/bin/bash

# EDIT THE PSEUDOPOTENTIAL PATH
pseudo_dir="/home/mcosta/qe-6.5/pseudo"

# calculates the total energy for different lattice parameter 
# the curve minimun giver the theoretical lattice parameter

# SUGGESTION
# Change the calculation parameters ecutwfc, kpoints and see if the theoretical parameters changes.


# total number  points 
ntot=15

for i in $( seq $ntot )
do


# initial lattice parameter
l0=10.20

# 1% increment
step=0.01

frac=`echo "1+(-$ntot/2+$i)*$step"| bc`
lattice=` echo "( $l0*$frac )" | bc`

cat > si.relax.in <<EOF
&control
    calculation = 'relax'
    restart_mode='from_scratch',
    prefix='silicon',
    tprnfor = .true.
    pseudo_dir = '$pseudo_dir',
    outdir='./'
    verbosity='high'
 /
 &system
    ibrav=  2, 
    celldm(1) =$lattice, 
    nat=  2, 
    ntyp= 1,
    ecutwfc =50.0,
 /
 &electrons
    diagonalization='david'
    mixing_mode = 'plain'
    mixing_beta = 0.7
    conv_thr =  1.0d-8
 /
 &ions
 /
ATOMIC_SPECIES
 Si  28.086  Si.pz-vbc.UPF
ATOMIC_POSITIONS alat
 Si 0.00 0.00 0.00
 Si 0.25 0.25 0.25
K_POINTS automatic
 8 8 8 0 0 0
EOF

pw.x < si.relax.in > si.relax.out


energy=` grep ! si.relax.out  | tail -1 | awk '{print $5}'`
echo $lattice $energy >> parameter.dat
mv si.relax.out si.relax.$lattice.out


done
