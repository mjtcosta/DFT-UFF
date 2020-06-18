#!/bin/bash

system="MoS2-MoS2"

# calculates the MoS2 band strucutre along the path G-K-M-G 

# change to bands directory
cd ../bands

# runs projwfc.x to obtain all wfc weights
cat > $system.proj.in <<EOF
&projwfc
   outdir='.',
   prefix='$system',
   ngauss=0, degauss=0.036748
   DeltaE=0.01
   kresolveddos=.true.
   filpdos='$system.k'
   filproj='$system-proj.k'
/
EOF

projwfc.x < $system.proj.in > $system.proj.out

# back to plots-pyprocar
cd ../plots-pyprocar

# copy the necessary files 
cp ../scf/$system.scf.in scf.in
cp ../scf/$system.scf.out scf.out

cp ../bands/$system.bands.in bands.in
cp ../bands/$system.bands.out bands.out

cp ../bands/$system.proj.in kpdos.in
cp ../bands/$system.proj.out kpdos.out


# creates pyprocar file
cat > bands-pyprocar.py << EOF
import pyprocar
pyprocar.bandsplot(elimit=[-4,4],savefig='mos2-bands-no-soc.png',mode='plain',color='blue',code='qe')
EOF

#runs pyprocar file
python bands-pyprocar.py
# bands are in the mos2-bands-no-soc.png
