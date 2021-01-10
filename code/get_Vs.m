function [V1,V2,N1,N2,O1,O2] = get_Vs(f,C1,C2)
M = numel(f);
[V1,V2,N1,N2,O1,O2] = deal(NaN(M,M));
for b = M:-1:2
    for a = 1:b-1
        [V1(a,b),N1(a,b),O1(a,b)] = getVab(a,b,f,V2,C1,C2);
        [V2(a,b),N2(a,b),O2(a,b)] = getVab(a,b,f,V1,C2,C1);
    end
end

function [v,n,o] = getVab(a,b,f,V2,C1,C2)
M = numel(f);
ii = 1:M <= a;
if any(ii)
    Bab = sum(C2(a,ii,b)'.*f(ii))/sum(C2(a,:,b)'.*f);
else
    Bab = 0;
end

n = (+1+(b == M)) * Bab + (-1-(b==M)) * (1-Bab);

o = (-1)*(b == M);
for r = 1:M
    for c = b+1:M
        o = o + f(r)*C1(b,r,c)*(-V2(b,c));
    end
end

v = max(n, o);