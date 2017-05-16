s = 'arithmetic'
uniq = unique(s)
duniq = double(uniq)
ds = double(s)
hh = hist(ds,duniq)

prec = 48
probs = hh/sum(hh);
probst = floor(probs*2^prec)/2^prec
% normalize their sum to 1
sp = sum(probst);
if (any(probs) <=0 )
    display('Error: all probabilities must be strictly poistive')
    STOP1
end

lows = 0; highs = probst(1);
for i = 2:length(duniq)
    lows(i) = lows(i-1)+ probst(i-1);
    highs(i) = highs(i-1)+ probst(i);
end
InitialTable = [probst' lows' highs']



%_------------

LowEnc = 0; HighEnc = 1; Progress = [LowEnc HighEnc]; prob_message = 1;
for i = 1:length(ds)
    current_symbol = ds(i);
    j = find( duniq == current_symbol );
    los = lows(j); his = highs(j);
    current_interval = HighEnc-LowEnc;
    HighEnc = LowEnc + current_interval*his;
    LowEnc = LowEnc + current_interval*los;
    Progress = [Progress; LowEnc HighEnc];
    prob_message = prob_message * probs(j);
end

 Progress;
 
 intLowEnc = floor(LowEnc*2^40)
binLowEnc = bitget( intLowEnc, 40:-1:1)
intHighEnc = floor(HighEnc*2^40)
binHighEnc = bitget( intHighEnc, 40:-1:1)
[binHighEnc' binLowEnc' (1:40)']
message = (LowEnc+HighEnc)/2

ind = find(binHighEnc~= binLowEnc,1)
ind1 = find( binLowEnc(ind:end) == 0,1);
ind2 = ind+ind1-1;
binLowEnc(ind2) = 1;

binLowEnc(1:ind2)

message = binLowEnc(1:ind2)*(2.^(-(1:ind2)'))

ideal_codelength = - log2(prob_message)

 MessageDecoded = [];
crt_message = message;
for i = 1:length(ds)
    for j = 1:length(duniq)
        los = lows(j); his = highs(j);
        if( (los <= crt_message) && (his > crt_message) )
            break
        end
    end
    current_interval = his-los;
    crt_message = (crt_message - los)/current_interval;
    MessageDecoded = [MessageDecoded uniq(j)]
  
	
end
