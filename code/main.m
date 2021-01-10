% Nothing, 31, 32, 41, 42, 43, 51, 52, 53, 54, 61, 62, 63, 64, 65, 11, 22, 33, 44,
% 55, 66, 21
% -> 1,...,22
x = 1:22;

% rolling probs: f(a) = Prob(roll = a)
p = 1/36;
f = [0; 2*p*ones(14,1); p*ones(6,1); 2*p];
F = cumsum(f);

M = numel(x);

C0 = get_C('default',f,M);
Ca = get_C('aggressive',f,M);
Cp = get_C('passive',f,M);

%% Value functions (valueD.eps, valueA.eps)

cs = {'D','A'};
for j = 1:numel(cs)

    switch cs{j}
        case 'D'
            C = C0;
        case 'A'
            C = Ca;
        case 'P'
            C = Ca;
    end     
    [V,N,O] = get_V(f,C);

    figH = figure;
    subplot(2,2,1)
    
    plotnice(N);
    figH.CurrentAxes.TickLabelInterpreter='latex';
    colorbar;
    ylabel('$a$','Interpreter','latex'); xlabel('$b$','Interpreter','latex'); title('$N(a,b)$','Interpreter','latex')
    subplot(2,2,2)
    if 1
    bar(1:M-1,O(1,2:end));
    figH.CurrentAxes.TickLabelInterpreter='latex';
    a = axis; axis([1 M-1 a(3:4)]);
    xlabel('$b$','Interpreter','latex'); title('$O(b)$','Interpreter','latex')
    else
    plotnice(O);
    figH.CurrentAxes.TickLabelInterpreter='latex';
    colorbar;
    ylabel('$a$','Interpreter','latex'); xlabel('$b$','Interpreter','latex'); title('$O(a,b)$','Interpreter','latex')    
    end
    subplot(2,2,3)
    plotnice(V);
    figH.CurrentAxes.TickLabelInterpreter='latex';
    colorbar;
    ylabel('$a$','Interpreter','latex'); xlabel('$b$','Interpreter','latex'); title('$V(a,b)$','Interpreter','latex') %title('V= max(N,O)')
    subplot(2,2,4)
    D = double(N > O);
    D(isnan(V)) = NaN;
    plotnice(D);
    figH.CurrentAxes.TickLabelInterpreter='latex';
    ylabel('$a$','Interpreter','latex'); xlabel('$b$','Interpreter','latex'); title('$N(a,b) > O(b)$','Interpreter','latex')

    set(figH,'Position',[0 0 700 500]);
    saveas(figH,['value' cs{j}],'epsc');
end

%% Bluff distributions (showC.eps)

figH = figure,
xx = 9:M;
subplot(1,2,1)
pp0 = f(xx); pp0 = pp0/sum(pp0);
plot(xx-1,pp0,'bo--')
hold on
pp = (1:numel(xx))'.*pp0; pp = pp/sum(pp);
plot(xx-1,pp,'ro--')
hold on
pp = (numel(xx):-1:1)'.*pp0; pp = pp/sum(pp);
plot(xx-1,pp,'go--')
hold on
a = axis; 
axis([xx(1)-1 M-1 a(3:4)])
xticks([xx-1])
figH.CurrentAxes.TickLabelInterpreter='latex';
xticklabels([{'$a+1$','','','$a+3$'} repmat({''},1,numel(xx)-8) {'$M-3$','','','$M$'}])
title('$C(a,r,b)$','Interpreter','latex')
xlabel('$b$','Interpreter','latex')
legend({'Default','Aggressive','Passive'},'Interpreter','latex')
subplot(1,2,2)
pp0 = f(xx); pp0 = pp0/sum(pp0);
plot(xx-1,pp0./pp0,'bo--')
hold on
pp = (1:numel(xx))'.*pp0; pp = pp/sum(pp);
plot(xx-1,pp./pp0,'ro--')
hold on
pp = (numel(xx):-1:1)'.*pp0; pp = pp/sum(pp);
plot(xx-1,pp./pp0,'go--')
hold on
a = axis; axis([xx(1)-1 M-1 a(3:4)])
xticks([xx-1])
figH.CurrentAxes.TickLabelInterpreter='latex';
xticklabels([{'$a+1$','','','$a+3$'} repmat({''},1,numel(xx)-8) {'$M-3$','','','$M$'}])
legend({'Default','Aggressive','Passive'},'Interpreter','latex')
title('$C(a,r,b) / C_0(a,r,b)$','Interpreter','latex')
xlabel('$b$','Interpreter','latex')

set(figH,'Position',[0 0 900 400]);
saveas(figH,'showC','epsc');

%% Public info simulations

nn = 1e6;
[V,N,O,score,leg_str] = deal({});

C = {C0,Ca};
[V{1},V{2},N{1},N{2},O{1},O{2}] = get_Vs(f,C{1},C{2});
score{end+1} = simulate_games(N,O,C,nn);
leg_str{end+1} = 'Default vs Aggressive';

C = {Cp,C0};
[V{1},V{2},N{1},N{2},O{1},O{2}] = get_Vs(f,C{1},C{2});
score{end+1} = simulate_games(N,O,C,nn);
leg_str{end+1} = 'Passive vs Default';

C = {Cp,Ca};
[V{1},V{2},N{1},N{2},O{1},O{2}] = get_Vs(f,C{1},C{2});
score{end+1} = simulate_games(N,O,C,nn);
leg_str{end+1} = 'Passive vs Aggressive';

% player 1's losses minus player 2's losses:
% (Line going up means player 1 is better)
leg_str_ = leg_str;
for j = 1:numel(leg_str)
    leg_str_{j} = sprintf('%s (%3.2f / game)',leg_str{j},round(100*mean(score{j}(:,1) - score{j}(:,2)))/100);
end
figH = figure;
plot((1:nn)/1000,cumsum(cell2mat(cellfun(@(s){s(:,1)-s(:,2)},score))))
legend(leg_str_,'location','northwest','Interpreter','latex')
figH.CurrentAxes.TickLabelInterpreter='latex';
xlabel('No. games (thousands)','Interpreter','latex')

saveas(figH,['C:\Users\user\Desktop\Maxchen\Public'],'epsc');
%(mm ./ ss) * sqrt(2500)

%% Private info simulations

nn = 1e6;
[V,N,O,score] = deal({});

% C1hat, C2hat
chats = {
'D','D',
'D','A',
'D','P',
'A','D',
'A','A',
'A','P',
'P','D',
'P','A',
'P','P',
};

if 1
    for k = 1:size(chats,1)
        k
        C = {C0,Ca};
        for j = 1:2
            switch chats{k,j}
                case 'D'
                    C{end + 1} = C0;
                case 'A'
                    C{end + 1} = Ca;
                case 'P'
                    C{end + 1} = Cp;
            end
        end
        [V{1},V{2},N{1},N{2},O{1},O{2}] = get_Vs_private(f,C{1},C{2},C{3},C{4});
        score{end+1} = simulate_games(N,O,C,nn);
    end

    mm = cell2mat(cellfun(@(s){mean(s(:,1)-s(:,2))},score));
    save mm mm
else
    load mm
end

DAP = 'DAP';
table = [];
for j = 1:3
    for k = 1:3
        ii = find(strcmp(chats(:,2),DAP(j)) & strcmp(chats(:,1),DAP(k)));
        table(j,k) = mm(ii);
    end
end

table_str = sprintf([...
'&Default & %3.2f& %3.2f & %3.2f \\\\ \n'...
'$\\hat{C}_2$&Aggressive & %3.2f&%3.2f&%3.2f\\\\ \n' ...
'&Passive & %3.2f&%3.2f&%3.2f\\\\'],[table(1,:) table(2,:) table(3,:)]);
 disp(table_str)

%% Private info, all possibilities:

actions = {[1 1],[1 2],[1 3],[2 1],[2 2],[2 3],[3 1],[3 2],[3 3]};
Cs = {C0,Ca,Cp};
P = NaN(numel(actions));

if 1
for j = 1:numel(actions)-1
    for k = j+1:numel(actions)
        disp([j k])
        [C,V,N,O] = deal({});
        C{1} = Cs{actions{j}(1)}; % C1
        C{2} = Cs{actions{k}(1)}; % C2
        C{3} = Cs{actions{k}(2)}; % C1hat
        C{4} = Cs{actions{j}(2)}; % C2hat
        [V{1},V{2},N{1},N{2},O{1},O{2}] = get_Vs_private(f,C{1},C{2},C{3},C{4});
        score = simulate_games(N,O,C,nn);
        
        P(j,k) = mean(score(:,1)-score(:,2));
    end
end
save P P
else
load P
end
P_ = P;
P_ = P_'; P_ = P_(:); P_ = P_(~isnan(P_));
for j = 1:numel(actions), P(j,j) = 0; end
for j = 1:numel(actions)
    for k = j+1:numel(actions)
        P(k,j) = -P(j,k);
    end
end
table = sprintf([...
                '&$D,D$ &  &%3.2f&%3.2f&%3.2f&%3.2f&%3.2f&%3.2f&%3.2f&%3.2f\\\\ \n' ...
                '&$D,A$ &  &     &%3.2f&%3.2f&%3.2f&%3.2f&%3.2f&%3.2f&%3.2f\\\\ \n' ...
                '&$D,P$ &  &     &     &%3.2f&%3.2f&%3.2f&%3.2f&%3.2f&%3.2f\\\\ \n' ...
                '&$A,D$ &  &     &     &     &%3.2f&%3.2f&%3.2f&%3.2f&%3.2f\\\\ \n' ...
'$C_1,\\hat{C}_2$&$A,A$ &  &     &     &     &     &%3.2f&%3.2f&%3.2f&%3.2f\\\\ \n' ...
                '&$A,P$ &  &     &     &     &     &     &%3.2f&%3.2f&%3.2f\\\\ \n' ...
                '&$P,D$ &  &     &     &     &     &     &     &%3.2f&%3.2f\\\\ \n' ...
                '&$P,A$ &  &     &     &     &     &     &     &     &%3.2f\\\\ \n' ...
                '&$P,P$ &  &     &     &     &     &     &     &     &     \\\\ \n'],P_);
disp(table)
x = LemkeHowson(-P,P);
[x{1} x{2}]
