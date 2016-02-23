@ECHO
del %2\%1.log
del %2\%1.err
del %2\%1.out
del %2\%1.post.res
del %2\%1.post.dat
rem OutputFile: %2\%1.log
rem ErrorFile: %2\%1.err
%3\frame3dd.exe %2\%1.dat %2\%1.out > %2\%1.log