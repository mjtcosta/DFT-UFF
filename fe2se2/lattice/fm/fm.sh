#!/bin/bash 

# EDIT THE PSEUDOPOTENTIAL PATH
pseudo_dir="/home/marcio/codes/pseudo/qe/pbe-no-soc/"


# calculates the total energy for different lattice parameter AFM configuration 
# the curve minimun given the theoretical lattice parameter


system="Fe2Se2-FeSe"

for lattice in 3.531 3.568 3.605 3.642 3.679 3.717 3.754 3.791 3.828 3.865 3.902 
do


a1x=` echo " 1.000000*$lattice " | bc`
a2y=` echo "1.000000000000000*$lattice " | bc`

cat > $system.relax.in <<EOF
&control 
    calculation = 'relax' 
   prefix      = '$system' 
    tprnfor = .true.    
    pseudo_dir = '$pseudo_dir',
    outdir='./'    
    verbosity = 'high'    
    wf_collect=.true.    
/    
&system      
    ibrav=  0  
    nat=  4  
    ntyp=  3  
    ecutwfc =  60.000  
    ecutrho =  600.000  
    occupations='smearing', smearing='methfessel-paxton', degauss=0.0073529411765      
    lspinorb=  .false.  
    noncolin=  .false.  
    starting_magnetization(2)=  0.500  
    starting_magnetization(3)=  0.500 
    nspin=2 
/    
&electrons      
mixing_beta = 0.1
electron_maxstep=200
/    
&ions      
/    
CELL_PARAMETERS angstrom      
 $a1x      0.00000000000          0.00000000000 
 0.00000000    $a2y               0.00000000000 
 0.00000000    0.00000000             17.910
ATOMIC_SPECIES      
Se  0.0 Se.pbe-n-kjpaw_psl.1.0.0.UPF    
Fe1  0.0 Fe.pbe-n-kjpaw_psl.1.0.0.UPF    
Fe2  0.0 Fe.pbe-n-kjpaw_psl.1.0.0.UPF    
ATOMIC_POSITIONS angstrom      
Fe1      0.006297338   0.006297338   8.954999940
Fe2      1.851962777   1.851962767   8.954999930
Se       0.014454771   1.843806104   7.483851669
Se       1.843806114   0.014454771  10.426148491
K_POINTS (automatic)      
 12 12 1 0 0 0 
EOF

pw.x < $system.relax.in > $system.relax.out

energy=` grep ! $system.relax.out  | tail -1 | awk '{print $5}'`
echo $lattice $energy >> parameter.dat

mv $system.relax.out $system.relax.$lattice.out



done
