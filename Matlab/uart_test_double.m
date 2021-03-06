%%
clear
tic;
MAX = 1000;
count = 0;
s = serialport("COM4", 115200);
f = fopen('sha_2A_99.txt','w');
h = fopen('sha_2A_99_hex.txt','w');

%% 

while (count < MAX)
    write(s,0xb5,"uint8");
    NumBytes = s.NumBytesAvailable;
    if(NumBytes >= 66)
        data = read(s,33,"uint8");
        bin = dec2bin(data,8);
        hex = dec2hex(data);
        tbin = reshape(transpose(bin),1,264);
        thex = reshape(transpose(hex),1,66);
        fprintf(f,tbin);
        fprintf(h,thex);
        fprintf(f,'\n');
        fprintf(h,'\n');
        
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
end

%%

fclose(f);
fclose(h);
toc;