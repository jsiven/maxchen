function [V,V_no,V_ok] = get_V(f,C)
M = numel(f);
[V,V_no,V_ok] = deal(NaN(M,M));
for b = M:-1:2
    for a = 1:b-1
        [V(a,b),V_no(a,b),V_ok(a,b)] = getVab(a,b,f,V,C);
    end
end

function [v,v_no,v_ok] = getVab(a,b,f,V,C)
M = numel(f);
ii = 1:M <= a;
if any(ii)
    Bab = sum(C(a,ii,b)'.*f(ii))/sum(C(a,:,b)'.*f);
else
    Bab = 0;
end

v_no = (+1+(b == M)) * Bab + (-1-(b==M)) * (1-Bab);

v_ok = (-1)*(b == M);
for r = 1:M
    for c = b+1:M
        v_ok = v_ok + f(r)*C(b,r,c)*(-V(b,c));
    end
end

v = max(v_no, v_ok);