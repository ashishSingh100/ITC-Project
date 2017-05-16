%% Specify	input	and	output	filenames
infile = 'input.txt' ;
outfile = 'output.zzz' ;

%% Read uncompressed text file

fileID =fopen (infile );
A=fread(fileID ,inf ,'uint8') ;
fclose(fileID ) ;
disp ( 'Entering encoding' ) ;

%% Conduct	frequency	analysis	( build	" table " )
% C	is	the	alphabet :	as	per	documentation	of	unique ,
% IA	and	IC	are	index	arrays C = A( IA )	and A = C( IC )

[C, IA , IC ]= unique (A) ;
table=histcounts(IC,1:(length(C)+1));
%% Find	entropy
p=table/sum( table ) ;
entropy=sum(-p.*log2(p)) ;
disp (['Expecting', num2str(entropy),'bits per symbol']);
%% Use	arithmetic	coding	to	encode	the	sequence
code=arithenco(IC,table);
%% Calculate bits per symbol
bitspersymbol=length(code)/length(A) ;
disp ( [ 'Achieved ',num2str(bitspersymbol),'bits per symbol' ] ) ;
%% Save	compressed	data
f =fopen (outfile , 'wb+' ) ;
fwrite( f,'_RTG') ;
%% Write	data	to	f i l e
fwrite( f , length(A),'uint32' ) ;
% Write	alphabet length
fwrite( f ,length(C),'uint8' ) ;
% Write	alphabet
fwrite ( f ,C, 'uint8' ) ;
% Write	table
bits_per_table_entry= floor(log2(max(table)))+1 ;
bytes_per_table_entry= ceil( bits_per_table_entry/8 ) ;
if	bytes_per_table_entry > 2
    count_class= 'uint32' ;
elseif	bytes_per_table_entry > 1
    count_class= 'uint16' ;
else
    count_class= 'uint8' ;
end
fh=str2func(count_class);
counts=fh(table);
fwrite(f ,bytes_per_table_entry , 'uint8' ); 
fwrite(f ,counts,count_class );
% Padd code	to a multiple of 8bits
padd= ceil(length(code)/8)*8-length(code);
code =[ code ; zeros( padd,1)] ;
% Pack code into bytes
packed_code=zeros(length(code)/8,1 ,'uint8') ;
for	i =1: length(packed_code)
    packed_code(i,1)=bi2de(code((1+8*(i-1)):(8+8*( i-1)))') ;
end
fwrite(f ,length(packed_code),'uint32' ) ; 
fwrite ( f ,packed_code , 'uint8' ) ;
fclose( f );
disp( 'Exiting. ') ;
