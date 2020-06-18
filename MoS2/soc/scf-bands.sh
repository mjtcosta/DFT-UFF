#!/bin/bash

# EDIT THE PSEUDOPOTENTIAL PATH
pseudo_dir="/home/mcosta/qe-6.5/pseudo"
system="MoS2-MoS2"

# calculates the MoS2 band strucutre along the path G-K-M-G 

mkdir scf
cd scf

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
    ecutwfc =  50.000  
    ecutrho =  500.000  
    occupations='smearing', smearing='methfessel-paxton', degauss=0.0073529411765      
    lspinorb=  .true.  
    noncolin=  .true.  
    starting_magnetization=  0.000  
/    
&electrons      
conv_thr= 1.D-8      
/    
CELL_PARAMETERS cubic      
3.18406653 0.00000000 0.00000000 
-1.59203327 2.75748253 0.00000000 
0.00000000 0.00000000 15.00000000 
ATOMIC_SPECIES      
S  0.0 S.rel-pbe-n-kjpaw_psl.1.0.0.UPF    
Mo  0.0 Mo.rel-pbe-spn-kjpaw_psl.1.0.0.UPF    
ATOMIC_POSITIONS angstrom      
Mo       0.000000000   0.000000000   9.063556670
S        1.592033270   0.919160840  10.627112390
S        1.592033270   0.919160840   7.500000000
K_POINTS (automatic)      
 10 10 1 0 0 0 
EOF

pw.x < $system.scf.in > $system.scf.out

#leaving scf directory
cd ..

mkdir bands
# entering bands directory
cd bands

# copy the converged scf calculation to perform a band strcutre calculation
cp -r ../scf/$system.save .

# Second a band structure calculation that read the converged SCF potential
cat > $system.bands.in <<EOF
&control 
    calculation = 'bands'
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
    ecutwfc =  50.000  
    ecutrho =  500.000  
    occupations='smearing', smearing='methfessel-paxton', degauss=0.0073529411765      
    lspinorb=  .true.  
    noncolin=  .true.  
    starting_magnetization=  0.000  
/    
&electrons      
conv_thr= 1.D-8      
startingpot='file'      
/    
CELL_PARAMETERS cubic      
3.18406653 0.00000000 0.00000000 
-1.59203327 2.75748253 0.00000000 
0.00000000 0.00000000 15.00000000 
ATOMIC_SPECIES      
S  0.0 S.rel-pbe-n-kjpaw_psl.1.0.0.UPF    
Mo  0.0 Mo.rel-pbe-spn-kjpaw_psl.1.0.0.UPF    
ATOMIC_POSITIONS angstrom      
Mo       0.000000000   0.000000000   9.063556670
S        1.592033270   0.919160840  10.627112390
S        1.592033270   0.919160840   7.500000000
K_POINTS crystal_b
4
   0.000000000   0.000000000   0.000000000 20  ! \Gamma
   0.333333333   0.333333333   0.000000000 20  ! K
   0.000000000   0.500000000   0.000000000 20  ! M
   0.000000000   0.000000000   0.000000000 20  ! \Gamma
EOF

pw.x < $system.bands.in > $system.bands.out


cat > $system.bands-plot.in << EOF
 &bands
    prefix='$system',
    outdir='./'
    filband='$system.band'
    lsym=.false.,
 /
EOF


bands.x < $system.bands-plot.in > $system.bands-plot.out

