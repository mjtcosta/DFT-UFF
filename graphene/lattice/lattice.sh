#!/bin/bash

# EDIT THE PSEUDOPOTENTIAL PATH
pseudo_dir="/home/mcosta/qe-6.5/pseudo"


# calculates the total energy for different lattice parameter 
# the curve minimun given the theoretical lattice parameter


# total number  points 
ntot=20

for i in $( seq $ntot )
do


# initial lattice parameter
l0=2.46

# 1% increment
step=0.001

frac=`echo "1+(-$ntot/2+$i)*$step"| bc`
lattice=` echo "( $l0*$frac )" | bc`

a=$lattice

cat > gr.relax.in <<EOF
&control
    calculation = 'relax'
    prefix='graphene',
    pseudo_dir = '$pseudo_dir',
    outdir='./'
    verbosity='high'
 /
 &system
    ibrav=  4, 
    a = $a 
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
 &Ions
 /
ATOMIC_SPECIES
C 12.0107 C.pbe-n-kjpaw_psl.1.0.0.UPF
ATOMIC_POSITIONS (crystal)
C   0.333333333  0.666666666  0.500000000
C   0.666666666  0.333333333  0.500000000
K_POINTS automatic
 12 12 1 0 0 0
EOF

pw.x < gr.relax.in > gr.relax.out

energy=` grep ! gr.relax.out  | tail -1 | awk '{print $5}'`
echo $a $energy >> parameter.dat

mv gr.relax.out gr.relax.$a.out

done
