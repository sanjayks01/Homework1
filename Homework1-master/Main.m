% This program solves a convection-diffusion problem 
% in a square domain [0,1]x[0,1] using bilinear elements.

clear, close all, home

global diffusion  h 

disp(' ')
disp('This program solves a diffusion equation')
disp(' ')
disp('No source term is considered');

disp(' ')
dimen = input('Type 2: for 2D and Type 3: for 3D analysis  ');
if dimen == 2
    elemtype = input('Type 1: for tri and Type 2: for quad  ');
    ordertype = input('Type 1: for P1 and Type 2: for P2  ');
    if (elemtype == 1 && ordertype == 1)
        file = 'C2D3';
    elseif (elemtype == 1 && ordertype == 2)
        file = 'C2D6';
    elseif (elemtype == 2 && ordertype == 1)
        file = 'C2D4';
    elseif (elemtype == 2 && ordertype == 2)
        file = 'C2D8';
    end
elseif dimen == 3
    
else
    display('Input error');
    break;
end

T=load(strcat('elem_',file)); T = T(:,2:end);
X = load(strcat('nodes_',file)); X = X(:,2:end);
inlet = load(strcat('inlet_',file,'.dat'))';
outlet = load(strcat('outlet_',file,'.dat'))';
diffusion = load('prop.dat');

nelem = length(T);
nnode = length(X);
dimension=size(X,2);
nodes=size(T,2);
switch file
    case 'C2D3'
        type=5;
        [n,wpg,pospg,N,dNdxi] = C2D3 ;
        [K,f] = CreateMatrix2D(X,T,pospg,wpg,N,dNdxi);

    case 'C2D6'
        type=22;
        [n,wpg,pospg,N,dNdxi] = C2D6 ;
        [K,f] = CreateMatrix2D(X,T,pospg,wpg,N,dNdxi);

    case 'C2D4'
        type=9;
        [n,wpg,pospg,N,dNdxi] = C2D4 ;
        [K,f] = CreateMatrix2D(X,T,pospg,wpg,N,dNdxi);
        
    case 'C2D8'
        type=23;
        [n,wpg,pospg,N,dNdxi] = C2D8 ;
        [K,f] = CreateMatrix2D(X,T,pospg,wpg,N,dNdxi);
        
end;

C = [inlet, ones(length(inlet),1);
    outlet, zeros(length(outlet),1)];

ndir = size(C,1);
neq  = size(f,1);
A = zeros(ndir,neq);
A(:,C(:,1)) = eye(ndir);
b = C(:,2);


% SOLUTION OF THE LINEAR SYSTEM
% Entire matrix
Ktot = [K A';A zeros(ndir,ndir)];
ftot = [f;b];

sol = Ktot\ftot;
Temp = sol(1:neq);

if dimension ==2
    geo2D_vtk;
elseif dimension ==3
    
end
display('Done!')