#!/bin/bash

# Installing gfortran, fftw and others
sudo apt-get install build-essential fftw3-dev gfortran

################# openmpi  ######################
# Download 
wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.3.tar.gz
# Extract files
tar -xvf openmpi-4.0.3.tar.gz

# Instaling
cd openmpi-4.0.3
./configure --prefix=/usr/local/openmpi-4.0.3
make install
cd ..

echo 'export PATH=$PATH:/usr/local/openmpi-4.0.3/bin' >>  ~/.bashrc


################# LAPACK ###################

# Downloading
wget https://github.com/Reference-LAPACK/lapack/archive/v3.9.0.tar.gz
# Extract files
tar -xvf v3.9.0.tar.gz

# Instaling
cd  lapack-3.9.0


cp make.inc.example make.inc

make blaslib
make lapacklib
make tmglib

sudo cp librefblas.a /usr/local/lib/libblas.a
sudo cp liblapack.a /usr/local/lib/liblapack.a
sudo cp libtmglib.a /usr/local/lib/libtmg.a



################# QE ###################

# Downloading
wget https://github.com/QEF/q-e/archive/qe-6.5.tar.gz
# Extract files
tar -xvf qe-6.5.tar.gz
mv q-e-qe-6.5 qe-6.5

# Instaling
cd qe-6.5
./configure --enable-parallel=no --enable-openmp=yes
make all
echo 'export PATH=$PATH:/home/mcosta/qe-6.5/bin/' >>  ~/.bashrc


########## Instaling python : Anaconda3-2020.02-Linux-x86_64.sh
# Downloading

wget https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh
bash Anaconda3-2020.02-Linux-x86_64.sh


