f=fopen('coriolan.txt');
A=fread(f,inf,'uint8');
fclose(f);
[C,IA,IC]=unique(A);
table=histcounts(IC,1:(length(C)+1));
bar(C);
p=table/sum(table)
entropy=sum(-p.*log2(p));