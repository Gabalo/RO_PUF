%%
clear
tic;
MAX = 33;
count = 0;
s = serialport("COM4", 115200);
wd = fopen('hexa.txt','r');

%% 

write(s,0x2A,"uint8");

while (count < MAX)
    hex_data = fscanf(wd,'%c',2);
    write_data = hex2dec(hex_data)
    write(s,write_data,"uint8");    
    count = count + 1;
    pause(0.1);
end

%%

fclose(wd);
toc;