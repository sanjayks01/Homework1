% This program solves a convection-diffusion problem 
% in a 2D or 3D domain.

clear, close all, home

global diffusion

disp(' ')
disp('This program solves a diffusion equation')
disp(' ')
disp('No source term is considered');
% Add folders for models, element functions and the models from GiD
addpath('Elements');
addpath('Model');
addpath('GiD');
%Input file
disp(' ')
file=input('Type the name of the project:', 's');
%Read inputs    
T=load(strcat('elem_',file)); T = T(:,2:end);
X = load(strcat('nodes_',file)); X = X(:,2:end);
inlet = load(strcat('inlet_',file,'.dat'))';
outlet = load(strcat('outlet_',file,'.dat'))';    
%Read diffusion    
diffusion = load('prop.dat');
%Set number of elements, nodes dimensions and nodes per element.
nelem = length(T);
nnode = length(X);
dimension=size(X,2);
nodes=size(T,2);
%Build element shape functions and shape functions derivatives.
switch dimension
    case 2
        switch nodes
            case 3
                type=5;
                [n,wpg,pospg,N,dNdxi] = C2D3 ;

            case 6
                type=22;
                [n,wpg,pospg,N,dNdxi] = C2D6 ;

            case 4
                type=9;
                [n,wpg,pospg,N,dNdxi] = C2D4 ;


            case 8
                type=23;
                [n,wpg,pospg,N,dNdxi] = C2D8 ;
        end;

    case 3
        switch nodes
            case 4
                type=10;
                [n,wpg,pospg,N,dNdxi] = C3D4;
            case 10
                type=24;
                [n,wpg,pospg,N,dNdxi] = C3D10 ;
            case 8
                type=12;
                [n,wpg,pospg,N,dNdxi] = C3D8 ;
            case 20
                type=25;
                [n,wpg,pospg,N,dNdxi] = C3D20 ;
        end;
end;
%Create stiffness matrices
[K,f] = CreateMatrix(X,T,pospg,wpg,N,dNdxi,dimension);
%Boundary conditions
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
%Read output files
if dimension ==2
    geo2D_vtk;
elseif dimension ==3
    geo3D_vtk;
end
%We have ended the simulation!
display('Done!')