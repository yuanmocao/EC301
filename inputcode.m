

j = input("How many joints are there? \n");
m = input("How many members are there? \n");

if (2*j-3 ~= m)
    fprintf('Joints and members don''t satisfied the requirements\n');
    return
end

C = zeros(j,m);
Sx = zeros(j,3);
Sy = zeros(j,3);
X = zeros(1,j);
Y = zeros(1,j);
L = zeros(1,2*j);
count = 1;
for i = 1:j
    fprintf('About joint %d\n',i);

    %reaction

    if count <= 2
        choice = input("Is there a reaction force? Y/N\n",'s');
        if choice == 'Y'
            count = count +1;
            choice = input("Is this a rollar or pin? R/P\n",'s');
            if choice == 'P'
                Sx(i,1) = 1;
                Sy(i,2) = 1;
                
            elseif choice == 'R'
                Sy(i,3) = 1;
            end
    
        else
            fprintf('joint%d has no reaction force.\n',i)
        end
    end

    %connected members
    num_mem = input("How many members is this joint connected to? \n");
    for k = 1:num_mem
        member = input(sprintf("What's the #%d member it is connected to? \n",k));
        C(i,member) = 1;
    end

    %joint location
    X(i) = input("what's the x coordinate of the joint? \n");
    Y(i) = input("what's the y coordinate of the joint? \n");

    %load applied
    choice = input("Is there load applied to this joint? Y/N \n",'s');
    if choice == 'Y'
        choice = input("Pick if the load is Horizontal or Vertical: H/V \n",'s');
        if choice == 'H'
            weight = input("Weight of the load? \n");
            L(i) = weight;
        elseif choice == 'V'
            weight = input("Weight of the load? \n");
            L(i+j) = weight;
        end
    elseif choice == 'N'
        sprintf("This joint has no load.");
    end


end
L = L';


%{
% j = #joints, m = #members
% j =  #rows & m = #columns
% Connection Matrix
% size [ j x m ]
C = [ 1 1 0 0 0 0 0;
      1 0 1 0 1 1 0;
      0 1 1 1 0 0 0;
      0 0 0 1 1 0 1
      ];

% total 3 reaction forces
% connection of reaction forces in x direction with different joints 
% size[j x 3] 
Sx = [ 1 0 0;
       0 0 0;
       0 0 0;
       0 0 0;
       0 0 0];

%connection of reaction forces in y direction with different joints 
% size [j x 3]
Sy = [ 0 1 0;
       0 0 0;
       0 0 0;
       0 0 0;
       0 0 1];
% coordinates vector xy
% size[j] 
X = [];
Y = [];
%load vector, 2 * joints number
% first half on direction X
% second half on Y
% size[1 x 2j] 
L = [0;0;0;0;0;0;0;0;0;0];
%}
name = input('name the file: (with .mat)','s');
save(name,'C','Sx','Sy','X','Y','L')