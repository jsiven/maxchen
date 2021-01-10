function C = get_C(mode,f,M,p)
switch mode
    case 'default'
        bluff = @(ii)f(ii);
    case 'aggressive'
        bluff = @(ii)(1:sum(ii))'.*f(ii);
    case 'passive'
        bluff = @(ii)(sum(ii):-1:1)'.*f(ii);
end

if ~exist('p','var')
    C = zeros(M,M,M);
    for a = 1:M
        for r = 1:M
            if r > a
                C(a,r,r) = 1;
            elseif r <= a
                ii = 1:M > a;
                if any(ii)
                    pp = bluff(ii);
                    pp = pp/sum(pp);
                    C(a,r,ii) = pp;
                end
            end
        end
    end
else
    C = zeros(M,M,M);
    for a = 1:M
        for r = 1:M
            
            if r > a
                ii = 1:M > r;
                if any(ii)
                    % be honest with prob 1-p:
                    C(a,r,r) = 1-p;
                    % higher-than-r-bluff with prob p:
                    pp = bluff(ii);
                    pp = pp/sum(pp);
                    C(a,r,ii) = p*pp;
                else
                    C(a,r,r) = 1; % this case happens only when r = M
                end
            elseif r <= a
                % higher-than-a-bluff:
                ii = 1:M > a;
                if any(ii)
                    pp = bluff(ii);
                    pp = pp/sum(pp);
                    C(a,r,ii) = pp;
                end
            end
        end
    end
end