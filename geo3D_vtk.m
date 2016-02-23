%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Getting geometry from abaqus to export it to ensight
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%% LOADING FILES OF NODES AND ELEM %%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%% WRITING HEADING FOR VTK FILE

	% printing heading to file
f=fopen(strcat('MyParaviewFile_',file,'.vtk'),'w');
fprintf(f,'# vtk DataFile Version 1.0\n');
fprintf(f,'ECM-CELL DIFFUSION-MECHANICS\n');
fprintf(f,'ASCII\n');
fprintf(f,'\n');
fprintf(f,'DATASET UNSTRUCTURED_GRID\n');
fprintf(f,'%s %8i %s\n','POINTS', nnode ,'float');

%%%%%%%%%%%%%%%%%%%%%% WRITING COORDINATES OF NODES %%%%%%%%%%%%%%%%%%%%%%%%%

	% printing coordinates
for i1=1:nnode
           fprintf(f,'%14.8E %14.8E %14.8E\n',X(i1,1:3));
end
fprintf(f,'\n');

%%%%%%%%%%%%%%%%%%%%%% WRITING CONNECTIVITY OF NODES %%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(f,'%s %8i %8i\n','CELLS', nelem , nelem*(nodes+1));
for i1=1:nelem     
            fprintf(f,'%4i  ',nodes);
            for j1=1:nodes;
                fprintf(f,'%10i  ',T(i1,j1)-1);
            end;
            fprintf(f,'\n');
end
fprintf(f,'\n');
fprintf(f,'%s %8i\n','CELL_TYPES', nelem);
for i1=1:nelem
            fprintf(f,' %4i ', type);
end
fprintf(f,'\n');          

%%%%%%%%%%%%%%%%%%%%%% WRITING VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(f,'%s %8i\n','POINT_DATA', nnode);
fprintf(f,'SCALARS Ux float\n');
fprintf(f,'LOOKUP_TABLE default\n');
temp = load('temp.dat');
for i1=1:nnode
           fprintf(f,'%14.8E\n', Temp(i1) );
end

% fprintf(f,'%s %8i\n','CELL_DATA', nelem);
% fprintf(f,'SCALARS C10 float\n');
% fprintf(f,'LOOKUP_TABLE default\n');
% for i1=1:nelem
%            fprintf(f,'%14.8E\n', 0 );
% end
fclose(f);
