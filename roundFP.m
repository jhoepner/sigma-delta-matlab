function f = roundFP(d, mode)

if mode == "none" 
    f = d;
    return;
end
if mode == "FP32"
    f = single(d);
    return;
end
if mode == "FXP8"
    f = round(d * 2^8)/2^8;
    return;
end

if mode == "FXP16"
   %intBits = 16 - round(log2(abs(d)));
    intBits = 16;
   % if abs(d) >= 2 
   %     display("MSB should have been adjusted!") 
   % end 
    f = round(d * 2^intBits)/2^intBits;
    return;
end

end