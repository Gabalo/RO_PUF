%%
clear
tic;
MAX = 1000;
count = 0;
s = serialport("COM4", 115200);
f = fopen('crp_2A_d2.txt','w');

%% 

while (count < MAX)
    write(s,0x2A,"uint8");
    NumBytes = s.NumBytesAvailable;
    if(NumBytes >= 33)
        data = read(s,33,"uint8");
        hex = dec2bin(data);
        rex = reshape(transpose(hex),1,264);
        fprintf(f,rex);
        fprintf(f,'\n');
        count = count + 1;
    end
end

%%

fclose(f);
toc;