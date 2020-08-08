
%% 
clear
s = serialport("COM4", 115200);
%% 
MAX = 4;
count = int32(0);
array = char(zeros(MAX,66));
%%
while(count < MAX)
    pause(0.5)
    if(s.NumBytesAvailable > 33)
        s.flush;
    elseif(s.NumBytesAvailable == 33)
        disp("I'm here")
        data = read(s,33,"int8");
        hex = dec2hex(data);
        rex = reshape(transpose(hex),1,66);
        count = count + 1;
        disp(count)
        array(count,:) = rex;
    end
end
%%
disp(array)

%%
% count = 0;
% for i = 1:MAX
%    for j = i+1:MAX
%         disp("ij: ")
%         disp(i)
%         disp(j)
%    end
% end
%%