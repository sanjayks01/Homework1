function [n,w,xi,N,dNdxi]=C3D8
%====================== No. integration points =============================
%
%   Defines the number of integration points:be used for
%   each element type
%

n = 8;
ncoord=3;  
nodes=8;
xi=zeros(ncoord,n);
%
%====================== INTEGRATION POINTS ==================================
%
%   Defines positions of integration points
%

         x1D = [-0.5773502692,0.5773502692];
         for k = 1:2
           for j = 1:2 
             for i = 1:2
               n = 4*(k-1) + 2*(j-1) + i;
               xi(1,n) = x1D(i);
               xi(2,n) = x1D(j);
               xi(3,n) = x1D(k);
             end
           end
         end

         w = [1.,1.,1.,1.,1.,1.,1.,1.];
%
%================= SHAPE FUNCTIONS ==================================
%
%        Nij: Shape functions of the Int Point i [4x4] Ni [4x1]

N=zeros(n,nodes);
for i1=1:n
       
       N(i1,1) = (1.-xi(1,i1))*(1.-xi(2,i1))*(1.-xi(3,i1))/8.;
       N(i1,2) = (1.+xi(1,i1))*(1.-xi(2,i1))*(1.-xi(3,i1))/8.;
       N(i1,3) = (1.+xi(1,i1))*(1.+xi(2,i1))*(1.-xi(3,i1))/8.;
       N(i1,4) = (1.-xi(1,i1))*(1.+xi(2,i1))*(1.-xi(3,i1))/8.;
       N(i1,5) = (1.-xi(1,i1))*(1.-xi(2,i1))*(1.+xi(3,i1))/8.;
       N(i1,6) = (1.+xi(1,i1))*(1.-xi(2,i1))*(1.+xi(3,i1))/8.;
       N(i1,7) = (1.+xi(1,i1))*(1.+xi(2,i1))*(1.+xi(3,i1))/8.;
       N(i1,8) = (1.-xi(1,i1))*(1.+xi(2,i1))*(1.+xi(3,i1))/8.;
end
%
%================= SHAPE FUNCTION DERIVATIVES ======================
%
%        Nij,r: Dev of shape functions of the Int Point i [4x8]
%        [2*i-1 2*i] => dNi,r [4x2]
dNdxi = zeros(ncoord*n,nodes);
for i1=1:n     
              
       dNdxi(i1*3-2,1) = -(1.-xi(2,i1))*(1.-xi(3,i1))/8.;
       dNdxi(i1*3-1,1) = -(1.-xi(1,i1))*(1.-xi(3,i1))/8.;
       dNdxi(i1*3,1) = -(1.-xi(1,i1))*(1.-xi(2,i1))/8.;
       dNdxi(i1*3-2,2) = (1.-xi(2,i1))*(1.-xi(3,i1))/8.;
       dNdxi(i1*3-1,2) = -(1.+xi(1,i1))*(1.-xi(3,i1))/8.;
       dNdxi(i1*3,2) = -(1.+xi(1,i1))*(1.-xi(2,i1))/8.;
       dNdxi(i1*3-2,3) = (1.+xi(2,i1))*(1.-xi(3,i1))/8.;
       dNdxi(i1*3-1,3) = (1.+xi(1,i1))*(1.-xi(3,i1))/8.;
       dNdxi(i1*3,3) = -(1.+xi(1,i1))*(1.+xi(2,i1))/8.;
       dNdxi(i1*3-2,4) = -(1.+xi(2,i1))*(1.-xi(3,i1))/8.;
       dNdxi(i1*3-1,4) = (1.-xi(1,i1))*(1.-xi(3,i1))/8.;
       dNdxi(i1*3,4) = -(1.-xi(1,i1))*(1.+xi(2,i1))/8.;
       dNdxi(i1*3-2,5) = -(1.-xi(2,i1))*(1.+xi(3,i1))/8.;
       dNdxi(i1*3-1,5) = -(1.-xi(1,i1))*(1.+xi(3,i1))/8.;
       dNdxi(i1*3,5) = (1.-xi(1,i1))*(1.-xi(2,i1))/8.;
       dNdxi(i1*3-2,6) = (1.-xi(2,i1))*(1.+xi(3,i1))/8.;
       dNdxi(i1*3-1,6) = -(1.+xi(1,i1))*(1.+xi(3,i1))/8.;
       dNdxi(i1*3,6) = (1.+xi(1,i1))*(1.-xi(2,i1))/8.;
       dNdxi(i1*3-2,7) = (1.+xi(2,i1))*(1.+xi(3,i1))/8.;
       dNdxi(i1*3-1,7) = (1.+xi(1,i1))*(1.+xi(3,i1))/8.;
       dNdxi(i1*3,7) = (1.+xi(1,i1))*(1.+xi(2,i1))/8.;
       dNdxi(i1*3-2,8) = -(1.+xi(2,i1))*(1.+xi(3,i1))/8.;
       dNdxi(i1*3-1,8) = (1.-xi(1,i1))*(1.+xi(3,i1))/8.;
       dNdxi(i1*3,8) = (1.-xi(1,i1))*(1.+xi(2,i1))/8.;
end
end
%
