function [V1,V2,N1,N2,O1,O2] = get_Vs_private(f,C1,C2,C1hat,C2hat)

[V1,~,N1,~,O1,~] = get_Vs(f,C1,C2hat);
[~,V2,~,N2,~,O2] = get_Vs(f,C1hat,C2);
