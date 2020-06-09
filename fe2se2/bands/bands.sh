#!/bin/bash 

# EDIT THE PSEUDOPOTENTIAL PATH
pseudo_dir="/home/marcio/codes/pseudo/qe/pbe-no-soc/"


# 
# tes the band structure for the AFM configuration


system="Fe2Se2-FeSe"

cat > $system.scf.in <<EOF
&control 
    calculation = 'scf' 
   prefix      = '$system' 
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
    starting_magnetization(3)= -0.500 
    nspin=2 
/    
&electrons      
mixing_beta = 0.1
electron_maxstep=200
/    
CELL_PARAMETERS angstrom      
 3.717000000   0.00000000000          0.00000000000 
 0.00000000    3.71700000000          0.00000000000 
 0.00000000    0.00000000000         17.91000000000
ATOMIC_SPECIES      
Se  0.0 Se.pbe-n-kjpaw_psl.1.0.0.UPF    
Fe1  0.0 Fe.pbe-n-kjpaw_psl.1.0.0.UPF    
Fe2  0.0 Fe.pbe-n-kjpaw_psl.1.0.0.UPF    
ATOMIC_POSITIONS angstrom      
Fe1      0.046149054   0.046149054   8.954999940
Fe2      1.812110747   1.812110737   8.954999930
Se       0.046324208   1.811936981   7.465351193
Se       1.811936991   0.046324208  10.444648967
K_POINTS (automatic)      
 12 12 1 0 0 0 
EOF

pw.x < $system.scf.in > $system.scf.out

cat > $system.bands.in <<EOF
&control 
    calculation = 'bands' 
   prefix      = '$system' 
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
    starting_magnetization(3)= -0.500 
    nspin=2 
/    
&electrons      
mixing_beta = 0.1
electron_maxstep=200
/    
CELL_PARAMETERS angstrom      
 3.717000000   0.00000000000          0.00000000000 
 0.00000000    3.71700000000          0.00000000000 
 0.00000000    0.00000000000         17.91000000000
ATOMIC_SPECIES      
Se  0.0 Se.pbe-n-kjpaw_psl.1.0.0.UPF    
Fe1  0.0 Fe.pbe-n-kjpaw_psl.1.0.0.UPF    
Fe2  0.0 Fe.pbe-n-kjpaw_psl.1.0.0.UPF    
ATOMIC_POSITIONS angstrom      
Fe1      0.046149054   0.046149054   8.954999940
Fe2      1.812110747   1.812110737   8.954999930
Se       0.046324208   1.811936981   7.465351193
Se       1.811936991   0.046324208  10.444648967
K_POINTS crystal_b
4
   0.5000   0.5000   0.0000 20  ! M
   0.0000   0.0000   0.0000 20  ! \Gamma
   0.5000   0.0000   0.0000 20  ! X
   0.5000   0.5000   0.0000 20  ! M
EOF

pw.x < $system.bands.in > $system.bands.out


cat > $system.bands-up-plot.in << EOF
 &bands
    prefix='$system',
    spin_component=1
    outdir='./'
    filband='$system.band_up'
    lsym=.true.,
 /
EOF


bands.x < $system.bands-up-plot.in > $system.bands-up-plot.out

cat > $system.bands-dw-plot.in << EOF
 &bands
    prefix='$system',
    spin_component=2
    outdir='./'
    filband='$system.band_dw'
    lsym=.true.,
 /
EOF


bands.x < $system.bands-dw-plot.in > $system.bands-dw-plot.out
