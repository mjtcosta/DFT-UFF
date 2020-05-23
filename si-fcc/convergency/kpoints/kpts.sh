#!/bin/bash

# EDIT THE PSEUDOPOTENTIAL PATH
pseudo_dir="/home/mcosta/qe-6.5/pseudo"

# Calculates the total energy for different values of kpoints

# plot nkptsXtotal_energy.dat  to check the convergency


# check if an in-out-files directory is present
dir_files="nkpts-in-out-files"
if [ ! -e "nkpts-in-out-files" ] ; then
    mkdir $dir_files
fi

for nkpts in `seq 4 2 16`; do 

cat > si.scf.$nkpts.in <<EOF
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
    ecutwfc = 30.0,
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
 $nkpts $nkpts $nkpts 0 0 0
EOF


pw.x < si.scf.$nkpts.in > si.scf.$nkpts.out

total_energy=`grep ! si.scf.$nkpts.out | awk '{print $5}'` 
echo $nkpts $total_energy >> nkptsXtotal_energy.dat

mv si.scf.$nkpts.in si.scf.$nkpts.out $dir_files

done
