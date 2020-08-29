%%
clear
tic;
MAX = 1000;
count = 0;
NumBytes = 0;
s = serialport("COM4", 115200);
f = fopen('test_aa_bin.txt','w');
h = fopen('test_aa_hex.txt','w');

%1A 05 78
%%

while (count < MAX)
    write(s,0xaa,"uint8");
    while (NumBytes < 33)
        NumBytes = s.NumBytesAvailable;
    end
    data = read(s,33,"uint8");
    bin = dec2bin(data,8);
    hex = dec2hex(data);
    tbin = reshape(transpose(bin),1,264);
    thex = reshape(transpose(hex),1,66);
    fprintf(f,tbin);
    fprintf(h,thex);
    fprintf(f,'\n');
    fprintf(h,'\n');
    count = count + 1;
end

%%

fclose(f);
fclose(h);
toc;