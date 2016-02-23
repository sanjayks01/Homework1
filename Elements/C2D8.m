function [n,w,xi,N,dNdxi]=C2D8
%====================== No. integration points =============================
%
%   Defines the number of integration points:be used for
%   each element type
%

n = 9;
ncoord=2;  
nodes=8;
xi=zeros(ncoord,n);
w=zeros(1,n);
%
%====================== INTEGRATION POINTS ==================================
%
%   Defines positions of integration points
%

         xi(1,1) = -0.7745966692;
         xi(2,1) = xi(1,1);
         xi(1,2) = 0.0;
         xi(2,2) = xi(1,1);
         xi(1,3) = -xi(1,1);
         xi(2,3) = xi(1,1);
         xi(1,4) = xi(1,1);
         xi(2,4) = 0.0;
         xi(1,5) = 0.0;
         xi(2,5) = 0.0;
         xi(1,6) = -xi(1,1);
         xi(2,6) = 0.0;
         xi(1,7) = xi(1,1);
         xi(2,7) = -xi(1,1);
         xi(1,8) = 0.;
         xi(2,8) = -xi(1,1);
         xi(1,9) = -xi(1,1);
         xi(2,9) = -xi(1,1);

         w1D = [0.555555555,0.888888888,0.55555555555];
         for j = 1:3
           for i = 1:3
             n = 3*(j-1)+i;
             w(n) = w1D(i)*w1D(j);
           end
         end
%
%================= SHAPE FUNCTIONS ==================================
%
%        Nij: Shape functions of the Int Point i [4x4] Ni [4x1]

N=zeros(n,nodes);
for i1=1:n
       N(i1,1) = -0.25*(1.-xi(1,i1))*(1.-xi(2,i1))*(1.+xi(1,i1)+xi(2,i1));
       N(i1,2) = 0.25*(1.+xi(1,i1))*(1.-xi(2,i1))*(xi(1,i1)-xi(2,i1)-1.);
       N(i1,3) = 0.25*(1.+xi(1,i1))*(1.+xi(2,i1))*(xi(1,i1)+xi(2,i1)-1.);
       N(i1,4) = 0.25*(1.-xi(1,i1))*(1.+xi(2,i1))*(xi(2,i1)-xi(1,i1)-1.);
       N(i1,5) = 0.5*(1.-xi(1,i1)*xi(1,i1))*(1.-xi(2,i1));
       N(i1,6) = 0.5*(1.+xi(1,i1))*(1.-xi(2,i1)*xi(2,i1));
       N(i1,7) = 0.5*(1.-xi(1,i1)*xi(1,i1))*(1.+xi(2,i1));
       N(i1,8) = 0.5*(1.-xi(1,i1))*(1.-xi(2,i1)*xi(2,i1));
end
%
%================= SHAPE FUNCTION DERIVATIVES ======================
%
%        Nij,r: Dev of shape functions of the Int Point i [4x8]
%        [2*i-1 2*i] => dNi,r [4x2]
dNdxi = zeros(ncoord*n,nodes);
for i1=1:n     
       dNdxi(i1*2-1,1) = 0.25*(1.-xi(2,i1))*(2.*xi(1,i1)+xi(2,i1));
       dNdxi(i1*2,1) = 0.25*(1.-xi(1,i1))*(xi(1,i1)+2.*xi(2,i1));
       dNdxi(i1*2-1,2) = 0.25*(1.-xi(2,i1))*(2.*xi(1,i1)-xi(2,i1));
       dNdxi(i1*2,2) = 0.25*(1.+xi(1,i1))*(2.*xi(2,i1)-xi(1,i1));
       dNdxi(i1*2-1,3) = 0.25*(1.+xi(2,i1))*(2.*xi(1,i1)+xi(2,i1));
       dNdxi(i1*2,3) = 0.25*(1.+xi(1,i1))*(2.*xi(2,i1)+xi(1,i1));
       dNdxi(i1*2-1,4) = 0.25*(1.+xi(2,i1))*(2.*xi(1,i1)-xi(2,i1));
       dNdxi(i1*2,4) = 0.25*(1.-xi(1,i1))*(2.*xi(2,i1)-xi(1,i1));
       dNdxi(i1*2-1,5) = -xi(1,i1)*(1.-xi(2,i1));
       dNdxi(i1*2,5) = -0.5*(1.-xi(1,i1)*xi(1,i1));
       dNdxi(i1*2-1,6) = 0.5*(1.-xi(2,i1)*xi(2,i1));
       dNdxi(i1*2,6) = -(1.+xi(1,i1))*xi(2,i1);
       dNdxi(i1*2-1,7) = -xi(1,i1)*(1.+xi(2,i1));
       dNdxi(i1*2,7) = 0.5*(1.-xi(1,i1)*xi(1,i1));
       dNdxi(i1*2-1,8) = -0.5*(1.-xi(2,i1)*xi(2,i1));
       dNdxi(i1*2,8) = -(1.-xi(1,i1))*xi(2,i1);
end
end
%
