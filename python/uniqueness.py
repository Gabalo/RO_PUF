import sys

def hamm(s1, s2):
	"""Calculate the Hamming distance between two bit strings"""
	assert len(s1) == len(s2)
	return sum(c1 != c2 for c1, c2 in zip(s1, s2))


LENGTH = 256

RSIZE = 33
unisum = 0

"""Read the file and store each line in a Python array"""
with open(sys.argv[1], "rb") as file1, open(sys.argv[2], "rb") as file2:
	for x in range(256):
		line1 = file1.readline()
		line2 = file2.readline()
		dline1 = line1[8:264].decode()
		dline2 = line2[8:264].decode()
		
		unisum = unisum + ((hamm(dline1,dline2) ) / LENGTH)

Uniqueness = (unisum/256)*100
print("Uniqueness: ", round(Uniqueness,4), "%")


