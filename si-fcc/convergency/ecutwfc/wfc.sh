#!/bin/bash

# EDIT THE PSEUDOPOTENTIAL PATH
pseudo_dir="/home/mcosta/qe-6.5/pseudo"

# Calculates the total energy for different values of ecutwfc

# plot  ecutwfcXtotal_energy.dat to check the convergency

# check if an in-out-files directory is present
dir_files="ecutwfc-in-out-files"
if [ ! -e "ecutwfc-in-out-files" ] ; then
    mkdir $dir_files
fi

for ecutwfc in `seq 10 5 50`; do 

cat > si.scf.$ecutwfc.in <<EOF
&control
    calculation = 'scf'
    restart_mode='from_scratch',
    prefix='silicon',
    tstress = .true.
    tprnfor = .true.
    pseudo_dir = '$pseudo_dir',
    outdir='./'
 /
 &system
    ibrav=  2, 
    celldm(1) =10.20, 
    nat=  2, 
    ntyp= 1,
    ecutwfc =$ecutwfc,
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


pw.x < si.scf.$ecutwfc.in > si.scf.$ecutwfc.out

total_energy=`grep ! si.scf.$ecutwfc.out | awk '{print $5}'`  
echo $ecutwfc $total_energy >> ecutwfcXtotal_energy.dat

mv si.scf.$ecutwfc.in si.scf.$ecutwfc.out $dir_files

done
