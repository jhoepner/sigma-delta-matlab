function f = roundFXP(d, WL)

%special value to not do anything
%it's not very clean but permits to do the exact version in double
%precision
if WL==64
    f = d;
    return;
end

if WL==32
    f = single(d);
    return;
end

if d == 0
    msb = 1;
end

if d > 0
    msb = round(log2(d + 1));
end
if d < 0
    msb = round(log2(-d));
end

lsb = WL - msb - 1;

f = round(d*2^lsb)/2^lsb;

end