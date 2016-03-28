function[f] = taonb(tA,tB,tR,n,p,nt)
pn = round((n - 200)*p);
snt = zeros(n,1);
for k = 1:200
    snt((nt - 1)*200 + k) = 1;
end
AR = tA - tR;
BR = tB - tR;
aru = 50;
mratea = 400;
ratea = zeros(mratea,1);
for k = 1:n
    if snt(k) == 0
        ratea(AR(k) + aru) = ratea(AR(k) + aru) + 1;
    end
end
na = 0;
ta = 0;
for k = mratea:-1:1
    na = na + ratea(k);
    if na > pn
        ta = k;
        break;
    end
end
tna = zeros(na);
ntna = 0;
for k = 1:n
    if snt(k) == 0
        if AR(k) + aru >= ta
            ntna = ntna + 1;
            tna(ntna) = k;
        end
    end
end
f = 0;
for k = 1:na
    f = f + BR(tna(k));
end
f = f / na;
