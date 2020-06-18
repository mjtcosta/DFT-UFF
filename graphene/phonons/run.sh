#! /bin/bash

# Remember to edit the pseudo potential path in graphene.scf.in

#SCF calculation
pw.x < graphene.scf.in > graphene.scf.out

# Phonon calculation -  the most computational demanding part
ph.x < graphene.ph.in > graphene.ph.out

# Interatomic Force Constants calculation
q2r.x < graphene.q2r.in > graphene.q2r.out

# phonon frequencies along the BZ high symmetry lines
matdyn.x < graphene.matdyn_disp.in > graphene.matdyn_disp.out

# plot phonon bands
plotband.x < graphene.plotband

# calculates phonon density of states
matdyn.x < graphene.matdyn_dos.in > graphene.matdyn_dos.out
