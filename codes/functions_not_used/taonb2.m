function[f,tna,na] = taonb2(tA,tB,tR,n,p,nt)
%cn = 200;
cn = 200;
pn = round((n - cn)*p);
snt = zeros(n,1);
for k = 1:cn
    snt((nt - 1)*cn + k) = 1;
end
AR = tA - tR;
BR = tB - tR;
mratea = 400;
ratea = zeros(mratea,1);
for k = 1:n
    if snt(k) == 0
        ratea(AR(k) + 50) = ratea(AR(k) + 50) + 1;
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
        if AR(k) + 50 >= ta
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