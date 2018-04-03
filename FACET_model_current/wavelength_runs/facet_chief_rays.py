# -*- coding: utf-8 -*-
"""
Created on Fri Mar 30 09:46:03 2018

@author: pwfa-facet2
"""


import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit
#import pyzdde.arraytrace as at
import pyzdde.zdde as pyz

import random as rand

pos_transport = [2, 7, 11]

optical_pos = [2, 7, 11, 24, 28, 40, 52, 63, 68, 80, 84]

for i in range(13,18,2):
    pos_transport.append(i)

pos_transport.append(24)
pos_transport.append(28)

for i in range(30,35,2):   
    pos_transport.append(i)
    
pos_transport.append(40)

for i in range(42,47,2):   
    pos_transport.append(i)

pos_transport.append(52)

for i in range(54, 59, 2):  
    pos_transport.append(i)

pos_transport.append(63)
pos_transport.append(68)    
    
for i in range(70,75, 2): 
    pos_transport.append(i)
    
pos_transport.append(80)
pos_transport.append(84)
    
for i in range(86, 91, 2):  
    pos_transport.append(i)

def facet_chief_ray_tracker(file_name, surface_tbvariated, surface_pos_list, wavenum,  angle_variation):
    unmodified_beam_x =[]
    unmodified_beam_y = []
    
    link = pyz.createLink()
    link.zLoadFile(file_name)
    wavelength = wavenum /1000
    link.zSetWave(1, wavelength, 1) 
    
    link.zSetSurfaceParameter(4, 3, 0) #3 = x-tilt, 4=y-tilt
    link.zSetSurfaceParameter(6, 3, 0)
    link.zSetSurfaceParameter(4, 4, 0)
    link.zSetSurfaceParameter(6, 4, 0)

    link.zSaveFile(file)

    for curr_surface in surface_pos_list:
        t_ccdx = link.zOperandValue('POPD', curr_surface, 1, 0, 11)
        t_ccdy = link.zOperandValue('POPD', curr_surface, 1, 0, 12)
       #print(t_ccdx, t_ccdy)
        unmodified_beam_x.append(t_ccdx)
        unmodified_beam_y.append(t_ccdy)
    
    ##add initial offset to first mirror
    
    offset_x =[]
    offset_y = []
    
    #modify entries 
    link.zSetSurfaceParameter(surface_tbvariated, 3, angle_variation)
    link.zSetSurfaceParameter(surface_tbvariated+2, 3, -angle_variation)
    link.zSaveFile(file_name)
    
    for curr_surface in surface_pos_list:
        t_ccdx = link.zOperandValue('POPD', curr_surface, 1, 0, 11)
        t_ccdy = link.zOperandValue('POPD', curr_surface, 1, 0, 12)
       #print(t_ccdx, t_ccdy)
        offset_x.append(t_ccdx)
        offset_y.append(t_ccdy)
    
    pyz.closeLink()
    return(unmodified_beam_x, unmodified_beam_y, offset_x, offset_y)
    
file = r"C:\Users\pwfa-facet2\Desktop\slacecodes\FACET_model_current\wavelength_runs\transportwithoffsetentries.zmx"

transport = [0]
transport.append(transport[-1]+541)
transport.append(transport[-1]+27)

for i in range(0,3):
    transport.append(transport[-1]+517)

transport.append(transport[-1]+517)
transport.append(transport[-1]+100)

for i in range(0,3):
    transport.append(transport[-1]+770.5)

transport.append(transport[-1]+770.5)

for i in range(0,3):
    transport.append(transport[-1]+1530.25)

transport.append(transport[-1]+1530.25)

for i in range(0,3):
    transport.append(transport[-1]+503.25)

transport.append(transport[-1]+503.25)
transport.append(transport[-1]+381.7)

for i in range(0,3):
    transport.append(transport[-1]+2934.575)

transport.append(transport[-1]+2934.575)
transport.append(transport[-1]+381.7)

for i in range(0,3):
    transport.append(transport[-1]+472.5)



a = facet_chief_ray_tracker(file, 4, pos_transport, 800, .3)

np.savetxt('offset3.csv', list(zip(a[0], a[1], a[2], a[3])))

"""
p= plt.figure(figsize=(12,8))
p0 = p.add_subplot(111)
p0.scatter(transport, a[1], marker = 'd', s=80, label = 'No Offset')
p0.scatter(transport,a[3], marker = '^', s=60, label = 'Offset at Mirror-1')
p0.legend(loc='best')
p.suptitle('Beam Position in FACET-II Laser Transport')
p.subplots_adjust(top=0.8)
p.tight_layout()    
p.savefig('simpletest.pdf')

"""
