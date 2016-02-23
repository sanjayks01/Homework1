@ECHO
del %2\%1.log
del %2\%1.err
del %2\%1.out
del %2\%1.post.res
del %2\%1.post.dat

rem ErrorFile: %2\%1.err
rename %2\%1.dat %2\nodes_%1
rename %2\%1-3.dat %2\elem_%1
rename %2\%1-1.dat %2\inlet_%1.dat
rename %2\%1-2.dat %2\outlet_%1.dat