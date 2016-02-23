function [n,w,xi,N,dNdxi]=C2D3
%====================== No. integration points =============================
%
%   Defines the number of integration points:be used for
%   each element type
%

n = 1;
ncoord=2;  
nodes=3;
xi=zeros(ncoord,n);
%
%====================== INTEGRATION POINTS ==================================
%
%   Defines positions of integration points
%

         xi(1,1) = 1./3.;
         xi(2,1) = 1./3.;
         



    w(1) = 0.5;
%
%================= SHAPE FUNCTIONS ==================================
%
%        Nij: Shape functions of the Int Point i [4x4] Ni [4x1]

N=zeros(n,nodes);
for i1=1:n
    
       N(i1,1) = xi(1,i1);
       N(i1,2) = xi(2,i1);
       N(i1,3) = 1.-xi(1,i1)-xi(2,i1);

end
%
%================= SHAPE FUNCTION DERIVATIVES ======================
%
%        Nij,r: Dev of shape functions of the Int Point i [4x8]
%        [2*i-1 2*i] => dNi,r [4x2]
dNdxi = zeros(ncoord*n,nodes);
for i1=1:n
            
       dNdxi(i1*2-1,1) = 1.;
       dNdxi(i1*2,2) = 1.;
       dNdxi(i1*2-1,3) = -1.;
       dNdxi(i1*2,3) = -1.;
end


end
%
