%%
clear
tic;
MAX = 1000;
count = 0;
s = serialport("COM4", 115200);
f = fopen('sha_2A_01.txt','w');
h = fopen('sha_2A_01_hex.txt','w');

%% 

while (count < MAX)
    write(s,0x2A,"uint8");
    NumBytes = s.NumBytesAvailable;
    if(NumBytes >= 33)
        data = read(s,33,"uint8");
        bin = dec2bin(data);
        hex = dec2hex(data);
        tbin = reshape(transpose(bin),1,264);
        thex = reshape(transpose(hex),1,66);
        fprintf(f,tbin);
        fprintf(h,thex);
        fprintf(f,'\n');
        fprintf(h,'\n');
        count = count + 1;
    end
end

%%

fclose(f);
toc;