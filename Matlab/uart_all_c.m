%%
clear
tic;
count = 0;
NumBytes = 0;
s = serialport("COM8", 115200);
f = fopen('all_bin.txt','w');
h = fopen('all_hex.txt','w');

%% 

for i=0:255
    write(s,i,"uint8");
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
        write(s,i,"uint8");
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