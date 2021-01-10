function score = simulate_games(N,O,C,nn)

M = size(N{1},1);
score = zeros(nn,2);

for k = 1:nn
    %if mod(k,1000) == 0; disp(k); end
    if rand < 0.5, i = 1; j = 2; else, i = 2; j = 1; end
    a = 1;
    while 1
        % player i takes rolls (need to beat a):
        r = get_roll();
        b = get_claim(a,r,C{i});

        % player j says 'No' or 'Ok':
        if N{j}(a,b) > O{j}(a,b)
            % No
            L = 1 + (b==M);
            if b == r
                % player j loses:
                score(k,j) = -L;
            else
                % player i loses:
                score(k,i) = -L;
            end
            break
        else
            if (b == M)
                score(k,j) = score(k,j) - 1;
                break
            else
                a = b;
                j_ = j; j = i; i = j_;
            end
        end
    end
end