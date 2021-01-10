function r = get_roll()

xx = [kron(1:14,[1 1]) 15:20 21 21] + 1;
r = xx(randi(36,1,1));

% r = xx(randi(36,100000,1));
% figure
% hist(r,[0:22])