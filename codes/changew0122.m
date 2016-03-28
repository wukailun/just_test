connect2 = connect;
nt = 6;
fai = 0.0003;
tracent = traceex4(:,:,nt);
fnak = 0;
ftnak = zeros(2,1);
for k = 1:sn
    if tracent(k) >= 35
        fnak = fnak + 1;
        ftnak(fnak) = k;
    end
end
%fnak = nak(nt);
%ftnak = zeros(fnak,1);
jna = zeros(sn,1);
hebw = zeros(sn,1);
for k = 1:sn
    hebw(k) = traceex4(k,1,nt);
end
for k = 1:fnak
    %ftnak(k) = tnak(k,nt);
    jna(ftnak(k)) = 1;
end
for k = 1:fnak
    for r = 1:fnak
        if connect2(ftnak(k),ftnak(r)) > 0
            sss = 3
            connect2(k,r) = connect2(k,r) + fai*hebw(k)*hebw(r);
        end
    end
end
for k = 1:sn
    for r = k + 1:sn
        if jna(k) + jna(r) == 1
            if connect2(k,r) > 0
                sss = 1
                connect2(k,r) = connect2(k,r) + fai*hebw(k)*hebw(r);
            end
            if connect2(r,k) > 0
                sss = 2
                connect2(r,k) = connect2(r,k) + fai*hebw(k)*hebw(r);
            end 
        end
    end
end





