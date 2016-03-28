%traceex4(:,:,16) = traceR;
tn = 33;
traceR1 = zeros(sn,1);
traceB = zeros(sn,1);
z = zeros(tn,tn);
for k = 1:tn
    for r = 1:tn
        tracek = traceex4(:,:,k);
        tracer = traceex4(:,:,r);
        z(k,r) = ftaonb(tracer,tracek,traceR1,sn,0.02,1);
    end
end
figure;imagesc(z)

t22 = zeros(1,200);
tnak = zeros(120,tn);
nak = zeros(1,tn);
rtn = zeros(25,tn);
for k = 1:tn
    tracek = traceex4(:,:,k);
    %[f,tna,na] = ftaonb2(tracek,traceB,traceR1,sn,35,1);
    [f,tna,na] = taonb2(tracek,traceB,traceR1,sn,0.02,1);
    for r = 1:na
        tnak(r,k) = tna(r);
        rtn(floor((tna(r) - 1)/200)+1,k) = rtn(floor((tna(r) - 1)/200)+1,k) + 1;
        if floor((tna(r) - 1)/200)+1 == 22
            t22(tna(r) - 21*200) = t22(tna(r) - 21*200) + 1;
        end
    end
    nak(k) = na;
end
tnak
nak
figure;imagesc(rtn')
rtn
zk = zeros(tn,tn);
for k = 1:tn
    for t = 1:tn
        rcna = 0;
        for r = 1:nak(k)
            for s = 1:nak(t)
                if tnak(r,k) == tnak(s,t)
                    rcna = rcna + 1;
                    break;
                end
            end
        end
        zk(k,t) = rcna;
    end
end
figure;imagesc(zk)
l22 = zeros(200,400);
for k = 1:200
    for r = 1:400
        l22(k,r) = njacell(k + 21*200,r);
        if l22(k,r) == 2
            l22(k,r) = 0.5;
        end
    end
end
for k = 1:200
    for r = 1:400
        l22(k,r) = l22(k,r) + t22(k)/30;
    end
end
figure;imagesc(l22)
ct22 = zeros(200,200);
oct22 = zeros(200,200);
for k = 1:200
    for r = 1:200
        krc = connect(k + 21*200,r + 21*200);
        if krc > 1
            krc = 1;
        end
        krt = 0;
        if t22(k) > 0 || t22(r) > 0
            krt = 1;
        end
        ct22(k,r) = krc + krt/30;
        oct22(k,r) = krc;
    end
end
zct = 0;
for k = 1:200
    if t22(k) > 0
        zct = zct + 1;
    end
end
zct
figure;imagesc(ct22)
        