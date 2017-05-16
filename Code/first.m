f=fopen('coriolan.txt');
A=fread(f,10,'uint8');
fclose(f);
A'
g=dec2hex(A);
h=dec2bin(A);
