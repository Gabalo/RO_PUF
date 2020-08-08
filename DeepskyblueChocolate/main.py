from itertools import combinations
import sys

def hamm(s1, s2):
    """Calculate the Hamming distance between two bit strings"""
    assert len(s1) == len(s2)
    return sum(c1 != c2 for c1, c2 in zip(s1, s2))

zeros = "0" * 264

RSIZE = 33
lines = []
count = 0
relsum = 0
biassum = 0
relcount = 0

with open(sys.argv[1], "rb") as putty:
  while(True):
    bytes = putty.read(RSIZE)
    hexa = bytes.hex()
    inte = int.from_bytes(bytes, byteorder="big")
    binary = f'{inte:0264b}'

    if(bytes):
      lines.append(binary)
      count = count + 1
      biassum = biassum + hamm(binary,zeros)
    if(not bytes):
      break

for pair in list(combinations(lines,2)):
  relsum = relsum + hamm(pair[0],pair[1])
  relcount = relcount + 1

Rel = 100 - ((relsum/264)/relcount)*100
print("Reliability: ", Rel, "%")

Bias = ((biassum/264)/count)*100
print("Bias: ", Bias, "%")
