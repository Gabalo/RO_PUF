from itertools import combinations
import sys
from bientropy import bien, tbien
from bitstring import Bits

def hamm(s1, s2):
	"""Calculate the Hamming distance between two bit strings"""
	assert len(s1) == len(s2)
	return sum(c1 != c2 for c1, c2 in zip(s1, s2))


LENGTH = 256
zeros = "0" * LENGTH

lines = []
count = 0
relsum = 0
biassum = 0
entrsum = 0
relcount = 0

"""Read the file and store each line in a Python array"""
with open(sys.argv[1], "rb") as putty:
	for line in putty:
	  dline = line[8:264].decode()
	  lines.append(dline)
	  count = count + 1
	  biassum = biassum + (hamm(dline,zeros) ) / LENGTH
	  entrsum = entrsum + tbien(Bits(bin(int(dline,base=2))))
	  
"""Calculate reliablity"""
for pair in list(combinations(lines,2)):
  relsum = relsum + ( hamm(pair[0],pair[1]) )/LENGTH
  relcount = relcount + 1

Rel = 100 - (relsum/relcount)*100
print("Reliability: ", round(Rel,4), "%")

Bias = (biassum/count)*100
print("Uniformity: ", round(Bias,4), "%")

Entropy = (entrsum/count)*100
print("Entropy: ", round(Entropy,4), "%")



