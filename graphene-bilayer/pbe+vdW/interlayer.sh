#!/bin/bash

# EDIT THE PSEUDOPOTENTIAL PATH
pseudo_dir="/home/mcosta/qe-6.5/pseudo"


# calculates the total energy for different interlayer distances 

# total number  points 
ntot=40

for i in $( seq $ntot )
do

# 1% increment
step=0.01

z0=0.25
z=`echo "$z0+($i)*$step"| bc`

cat > gr.relax.in <<EOF
&control
    calculation='scf',
    prefix='graphite'
    pseudo_dir = '$pseudo_dir',
    outdir='./'
 /
 &system
    ibrav = 4,
    a=2.46596482
    c=20.0
    nat=  4,
    ntyp= 1,
    vdw_corr = 'dft-d3',
    ecutwfc = 60
    ecutrho = 720
 /
 &electrons
    conv_thr =1.0d-8
/
ATOMIC_SPECIES
C 12.0107 C.pbe-n-kjpaw_psl.1.0.0.UPF
ATOMIC_POSITIONS crystal
 C 0.00000    1.00000    $z
 C 0.66667    0.33333    $z
 C 0.00000    1.00000    0.25000
 C 0.33333    0.66667    0.25000
K_POINTS AUTOMATIC
10 10 1 0 0 0
EOF

pw.x < gr.relax.in > gr.relax.out

energy=` grep ! gr.relax.out  | tail -1 | awk '{print $5}'`
d=`echo "($z-0.25)*20.0"| bc`
echo $d $energy >> parameter.dat
echo $d
mv gr.relax.out gr.relax.$d.out

done
