#!/bin/bash -xv

# EDIT THE PSEUDOPOTENTIAL PATH
pseudo_dir="/home/mcosta/codes/pseudo/qe"
system="NiI2-MoS2"


for kpts in 3 5 7 9 12 16 20
do

# first perform a SCF calculation
cat > $system.scf.in <<EOF
&control 
    calculation = 'scf'
    prefix      = '$system' 
    pseudo_dir = '$pseudo_dir',
    outdir='./'    
    verbosity = 'high'    
/    
&system      
    ibrav=  0  
    nat=  3  
    ntyp=  2  
    a = 1.0000 
    ecutwfc =  90.000  
    ecutrho =  900.000  
    occupations='smearing', smearing='methfessel-paxton', degauss=0.0073529411765      
    lspinorb=  .true.  
    noncolin=  .true.  
    starting_magnetization(1)=  0.5
    angle1(1) = 0
    angle2(1) = 0
/    
&electrons      
!conv_thr= 1.D-8      
mixing_beta = 0.1
/    
CELL_PARAMETERS cubic      
        3.8508522511         0.0000000000         0.0000000000
       -1.9254261255         3.3349358756         0.0000000000
        0.0000000000         0.0000000000        18.3890323639
ATOMIC_SPECIES      
Ni 0.0 Ni.rel-pbe-n-kjpaw_psl.1.0.0.UPF
I  0.0 I.rel-pbe-dn-kjpaw_psl.1.0.0.UPF
ATOMIC_POSITIONS angstrom      
Ni     0.000000000         0.000000000         9.194516182
I      1.925426245         1.111645222        10.899520874
I      1.925426245         1.111645222         7.489511490
K_POINTS (automatic)      
 $kpts $kpts 1 0 0 0 
EOF

pw.x < $system.scf.in > $system.scf-$kpts.out
energy=`grep ! $system.scf-$kpts.out | awk {'print $5'}`

echo $kpts $energy > total_energy_along_z.dat


done
