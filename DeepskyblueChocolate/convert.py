import sys

RSIZE = 33

with open(sys.argv[1], "rb") as infile, open(sys.argv[2], "w") as outfile:
  while(True):
    bytes = infile.read(RSIZE)
    hexa = bytes.hex()
    inte = int.from_bytes(bytes, byteorder="big")
    binary = f'{inte:0264b}'
    if(bytes):
      #print(hexa)
      #print(binary[0:8])
      #print(binary[8::])
      outfile.write(binary[0:8])
      outfile.write(",")
      outfile.write(binary[8::])
      outfile.write("\n")
    if(not bytes):
      break
