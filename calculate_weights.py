import numpy as np
from scipy.signal import firwin

N = 8       # Filter order 
f_c = 1000  # Cutoff frequency 
f_s = 10000 # Sampling frequency

coeffs = firwin(numtaps=N+1, cutoff=f_c, fs=f_s, window='hamming')
print(coeffs)
