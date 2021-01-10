function b = get_claim(a,r,C)

% FOR NOW:
if r > a
    b = r;
else
    C_ = cumsum(squeeze(C(a,r,:)));
    b = find(rand <= C_,1);
end