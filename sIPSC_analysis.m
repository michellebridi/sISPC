
%This part loads up the Excel or text files automatically and creates some
%variables and data structures.
clear
a=dir(fullfile('*.txt'));          %Makes a structure with recording file metadata
b=struct2cell(a);  %Converts structure array 'a' to cell array 'b' (still metadata)
c=b(1,:);        %makes another cell array with the names of the raw data file and the destination result data file 
[h,l]=size(c);   %
jj=0;            %


%%
%
for ii=1:1:l %start_index:increment_value:ending_index           
    if strfind(c{ii},'.txt')    %find the name of the raw data file
        jj=jj+1;
        [xlsstr{jj}] = textread(c{ii}); %copies the named text file into an array here
    end
end


%%
%
for q=1:1:length(xlsstr);    
                
A=xlsstr{1,q};  


K=1; 

    i=1; 
    A1=A(:,i); 
    A2=A1(~isnan(A1));  
    [m2,n2]=size(A2);   
    cnt=1;  

        for j=1:5000:5000*fix(m2/5000); %Steps over 500 ms (5000 samples at 10 kHz) to reckon a moving baseline, with the max
                                        %number of steps depending on
                                        %length 'm2' of the vector 'A2'
        A3=A2(j:j+4999,:);  %copy 'A2' into a new vector 
        meanBSL=mean(mode(A3)); %Calculates the mode/baseline value of 'A3'
        A4=bsxfun(@minus,A3,meanBSL.'); %'A4' is the vector that results from subtracting baseline values from 'A3'
        M=sum(A4);  %This is the sum of all the values of 'A4' in pA; integration step
        fivemillisecondcharge{i,cnt,q}=M; %calculates charge based on the integration value 'M' (actually over 500 msec)
        cnt=cnt+1;  %Ticks 'cnt' up for each run through
        end
        
    %end    %Once this loop has run it has pulled the data values from each column in 'A' and performed that moving baseline 
            %calculation on all of them

FragmentMatrix=cellfun(@sum,fivemillisecondcharge); 
FragmentI=FragmentMatrix(1,:,q); 
NumI=length(nonzeros(FragmentMatrix(1,:,q))); 
CellI{q}=sum(FragmentI(:))/NumI*2; %final value for the charge calculated. Takes the sum of all values in
                                   %'FragmentI' then it divides them by the
                                   % number of bins and multiplies by 2 (500 msec*2=1 sec) to
                                   % get pA in one second
end

%%
%writes data to a results excel file
AllI=cell2mat(CellI);
Filename=b(1,:);
Items={'Filename','I',}';
AllI=num2cell(AllI);
FinalData=[Filename;AllI];
Result=[Items,FinalData];
xlswrite('Output.xlsx',Result);



