%%
clear
tic;
MAX = 1000;
count = 0;
s = serialport("COM4", 115200);
f = fopen('all_c.txt','w');

%% 

for i=1:255
    write(s,i,"uint8");
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