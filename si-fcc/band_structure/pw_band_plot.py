# -*- coding: utf-8 -*-

# Python code to plot the band strucutre
# adapted from @author: yyyu200@163.com

import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt
import numpy as np

def parse_filband(feig, npl=8):
    # feig : filband in bands.x input file
    # npl : number per line

    feig=open(feig)
    l=feig.readline()
    nbnd=int(l.split(',')[0].split('=')[1])
    nks=int(l.split(',')[1].split('=')[1].split('/')[0])
    
    eig=np.zeros((nks,nbnd),dtype=np.float32)
    for i in range(nks):
        l=feig.readline()
        count=0
        if nbnd%npl==0:
            n=nbnd//npl
        else:
            n=nbnd//npl+1
        for j in range(n):
            l=feig.readline()
            for k in range(len(l.split())):
                eig[i][count]=l.split()[k]  # str to float
                count=count+1
                
    feig.close()

    return eig, nbnd, nks

do_find_gap=True

if do_find_gap:
    nvband=4 # valence band number, only applicable for do_find_gap=True

ymin=-10  # y range in plot
ymax=10

lw=1.2 # line width
e_ref=0.0 # set to fermi-level in scf output for metal, only applicable for do_find_gap=False

p1=plt.subplot(1, 1, 1)
F=plt.gcf()

eig, nbnd, nks=parse_filband('si.band')

plt.xlim([0,nks-1]) # k-points
plt.ylim([ymin,ymax])
plt.ylabel(r' E (eV) ',fontsize=16)

# Find bandgap
if do_find_gap and nbnd > nvband: # for insulators only
    eig_vbm=max(eig[:,nvband-1])
    eig_cbm=min(eig[:,nvband])
    Gap=eig_cbm-eig_vbm
    plt.title("Band gap= %.4f eV" % (Gap))
    e_ref=eig_vbm

for i in range(nbnd):
    line1=plt.plot( eig[:,i]-e_ref,color='r',linewidth=lw )

vlines= np.arange(0,nks,20) # positions of vertical lines, or specified by [0, 20, 40, ...]
for vline in vlines:
    plt.axvline(x=vline, ymin=ymin, ymax=ymax,linewidth=lw,color='black')

#!FCC (face-centered cubic) G-X-W-K-G-L-U-W-L-K U-X 
plt.xticks( vlines, (r'${\Gamma}$', 'X', 'W', 'K', r'${\Gamma}$', 'L',
           'U','W','L','K','U','X') )

plt.text(0.0, 8, 'Silicon FCC', fontsize=12, color='black')

plt.savefig('si-fcc-band.png',dpi=500)
