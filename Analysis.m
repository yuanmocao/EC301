load('C.mat');

[j, m] = size(C);
%makeT();
A = makeA(j,m,C,X,Y,Sx,Sy);
T = linsolve(A,L)
Wl = sum(L);
Rm = T/Wl
length = make_length(m,X,Y,C);
%Wl = input('Testing load: ');
Rmm = min((Rm))
index = find(Rm==Rmm)
Pcrit =  make_Pcrit(length,m)
Wf = -Pcrit(index)/Rmm
Tfinal = Wf * Rm
%{

m15: 0.827 (T) Reaction forces in oz: Sx1: 0.0
        Sy1: 0.75
        Sy2: 0.25
        Cost of truss: $319
        Theoretical max load/cost ratio in oz/$: 0.0031
 %}
fprintf('\\%% EK301, Section A5, Group A: Kelly Lam, Xinyu Lei, Wenhao Cao, 11/11/2022.\n')
fprintf('Load: %d oz\n',round(Wf));
fprintf('Member forces in oz\n');
for i = 1:m
    if Tfinal(i,1) > 0
        f = 'T';
    elseif Tfinal(i,1) == 0
        f = ' ';
    else
        f = 'C';
    end
    fprintf('m%d: %.3f (%c)\n',i,abs(Tfinal(i,1)),f);
end

fprintf('Reaction forces in oz:\n')
fprintf('Sx1: %.3f\n',Tfinal(m+1,1))
fprintf('Sy1: %.3f\n',Tfinal(m+2,1))
fprintf('Sy2: %.3f\n',Tfinal(m+3,1))





function Pcrit = make_Pcrit(length,m)
    Pcrit = zeros(1,m);
    for i =1:m
        Pcrit(i) = 2945/(length(i)^2);
    end
end

function length = make_length(m,X,Y,C)
    length = zeros(1,m);
    for i = 1:m
        CC = C(:,i);
        Col = find(CC==1)';
        length(i)=distance(Col(1),Col(2),X,Y);
    end
end
% j = #joints, m = #members

%make matrix A
% size [2j x m+3]
function A = makeA(j,m,C,X,Y,Sx,Sy)
    Coe = makeCoe(j,m,C,X,Y);
    S = [Sx;Sy];
    A = [Coe S];
end

% make coefficient matrix in A
function Coe = makeCoe(j,m,C,X,Y)
    CoeX = makeCoeX(j,m,C,X,Y);
    CoeY = makeCoeY(j,m,C,X,Y);
    Coe = [CoeX; CoeY];
end

% make coefficient matrix x in coefficient matrix
function CoeX = makeCoeX(j,m,C,X,Y)
    CoeX = C;
    for i = 1:m
        CC = C(:,i);
        Col = find(CC==1)';
        CoeX(Col(1),i) = (X(Col(2))-X(Col(1)))/distance(Col(1),Col(2),X,Y);
        CoeX(Col(2),i) = (X(Col(1))-X(Col(2)))/distance(Col(1),Col(2),X,Y);
    end
    
end

% make coefficient matrix y in coefficient matrix
function CoeY = makeCoeY(j,m,C,X,Y)
    CoeY = C;
    for i = 1:m
        CC = C(:,i);
        Col = find(CC==1)';
        CoeY(Col(1),i) = (Y(Col(2))-Y(Col(1)))/distance(Col(1),Col(2),X,Y);
        CoeY(Col(2),i) = (Y(Col(1))-Y(Col(2)))/distance(Col(1),Col(2),X,Y);
    end
end

function r = distance(m_1,m_x,X,Y)
    r = sqrt((X(m_x)-X(m_1))^2+(Y(m_x)-Y(m_1))^2);
end
    