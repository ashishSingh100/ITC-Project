	disp( 'Entering text decoder . . . ' ) ;
	infile = 'coriolan.zzz' ;
	outfile = 'coriolan_z.txt' ;
	%% Decoder
	f=fopen(infile,'r');
	%% Read and	check magic	number
	magic=fread(f,4,'*char')';
	if all(magic=='_RTG')
        disp( 'Great !	Magic	number	matches . ' ) ;
    else
        disp( 'Magic	number	does	not	match ') ;
        return ;
	end
	%% Read unencoded data length
	len=fread(f ,1 ,'uint32') ;
	%% Read	alphabet	length
	alphabet_len=fread( f ,1 ,'uint8') ;
	%% Read	alphabet
	C=fread(f,alphabet_len,'uint8') ;
	%% Read	table
	bytes_per_table_entry=fread(f,1,'uint8');
    if bytes_per_table_entry > 2
        count_class= 'uint32' ;
    elseif	bytes_per_table_entry > 1
        count_class= 'uint16';
    else
        count_class= 'uint8';
   end
    
	recovered_table=fread( f,alphabet_len,count_class);
	%% Read packed code
	packed_code_len=fread(f,1,'uint32' );
	packed_code=fread(f,packed_code_len,'uint8');
	%% Unpack the code
	code_len=packed_code_len*8;
	recovered_code=zeros(code_len ,1,'double') ;
	recovered_code=de2bi(packed_code,8 );
	recovered_code=recovered_code(:);
	%% Recover index array
	IC=arithdeco( recovered_code , recovered_table , len ) ;
	%% Apply alphabet
	recovered=C(IC) ;
	%% Write the file
	f =fopen( outfile , 'w' ) ;
	fwrite( f , recovered ) ;
	fclose(f) ;
	%--------------------------------------------
	disp( 'Exiting	RTG	text decoder . . . ' ) ;

