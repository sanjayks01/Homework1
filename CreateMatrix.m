function [K,f] = CreateMatrix(X,T,pospg,pespg,N,dNdxi,dimension,source) 
% Stiffness matrix K and r.h.s vector f 
% obtained by discretizing a heat equation
% 
% X:            nodal coordinates
% T:            connectivities (elements)
% pospg, pespg: Gauss points an weights in the reference element
% N,Nxi,Neta:   shape functions on the Gauss points 


global diffusion 

nu = diffusion;

% Total number of elements and number of nodes in aech one
[numel,nen] = size(T); 
% Total number of nodes
numnp = size(X,1); 
 
% Allocate storage
K = zeros(numnp,numnp); 
f = zeros(numnp,1); 

% Loop on elements
for ielem = 1:numel
    % Te: global number of the nodes in the current element
    % Xe: coordenates of the nodes in the current element
    Te = T(ielem,:); 
    % Get local information
    Xe = X(Te,:); 
    % Element matrices
    if dimension==2
        [Ke,fe] = MatEl2D(Xe,nen,pospg,pespg,N,dNdxi,source);
    elseif dimension==3
            [Ke,fe] = MatEl3D(Xe,nen,pospg,pespg,N,dNdxi,source);
    end;
    % Assemble the element matrices
    K(Te,Te) = K(Te,Te) + Ke; 
    f(Te) = f(Te) + fe; 
    clear Ke; clear fe; 
end 
 
 
