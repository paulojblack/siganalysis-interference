%To do next is calculate visibility, (max(peak) -
%min(peak))/(max(peak)+min(peak). Consider 3 peaks, average left two,
%average right two, divide each by the average of the troughs between them
%to accurately represent this value.

%Don't do the peak search, just divide y into like 10 spots.


function [pks,locs] =  calcpeaks()
    tic
    %Looping through slices of plot. Cycles vertically (1,1040) across image
%to extract Z data (intensity value) across X coordinates (1,1392). Returns
%xtotal and ztotal, both [1392,1040]containing properly distributed image
%data.

%NOTE - the coordinates obtained from the text files sometimes omit
%positions at random, so if the position is checked and doesn't contain a
%value, the position is added and a z value of '0' is assigned to it.
    function [xarray, zarray] = sortimage()
        data = dataset('File','101.txt','ReadVarNames',false);
        x = data.Var1;
        y = data.Var2;
        z = data.Var3;
        %%% Begin Loop function
        %Integers for loops
        j = 1;
        i = 1;
        %Declaration of arrays with predetermined size.
        xarray = zeros(1392,1040);
        zarray = zeros(1392,1040);
        %Loop over each vertical slice
        while y(j) ~= 1039
            n = y(j) + 1;
            r = 1;
            
            if x(i) == 0 && xarray(1,n) ~= 0
                    xarray(1,n) = 0;
                    zarray(1,n) = 0;
                    r = r + 1;
                    i = i + 1;
            end
            %Loop across the x axis collection information for each pixel
            while x(i) ~= 1391
                xarray(r,n) = x(i);
                zarray(r,n) = z(i);
                r = r + 1;
                %Force missing x positions into x
                if (x(i+1) ~= x(i) + 1) && (x(i+1) ~= 0 && (x(i+1) ~= 1392))
                    xarray(r,n) = x(i) + 1;
                    zarray(r,n) = 0;
                    r = r + 1;
                end
             
                i = i + 1;
            end
            %Include the last value, possibly better syntax would remove the need?
            if x(i) == 1391
                xarray(r,n) = x(i);
                zarray(r,n) = z(i);
                i = i + 1;
                
                %%Force first entry in each column to be zero
                if x(i) ~= 0
                    x = [x(1:i-1); 0; x(i:end)];
                    z = [z(1:i-1); 0; z(i:end)];
                end
            end
            j = i + 1;
            
        end
        %%End loop function
    end

    %%DETREND FUNCTION
    function notrend = removetrend(ztotal)
        n = 1;
        while n ~= 1040
            [p,s,mu] = polyfit((1:numel(ztotal(:,n))).',ztotal(:,n),6);
            f_y = polyval(p,(1:numel(ztotal(:,n))),[],mu);
            if n ==1
                notrend = ztotal(:,n) - f_y.';
            end
            notrend = [notrend,ztotal(:,n) - f_y.'];
            n = n + 1;
        end
    end

    %%SMOOTH DETREND
    function zfinal = usefilter(removetrend)
        n = 1;
        while n ~= 1040
            temp = sgolayfilt(removetrend(:,n),7,21);
            if n == 1
                zfinal = temp;
            end
            zfinal = [zfinal, temp];
            n = n + 1;
        end
    end

    %PEAK FINDING FUNCTION
    function [pks,locs] = peakarray(inputarray)
         p = 1;
         while p ~= 1040
            [pks(:,p),locs(:,p)] = findpeaks(inputarray(:,p),'SortStr','descend',...
                'NPeak',3);
            p = p + 1;
         end
    end
    
    function invert = trougharray(inputarray)
        p = 1;
        while p ~= 1040
            inputinvert = -inputdata;
        end
    end
            

    %function zbatch = batchbrightest(pks,locs)
        %%First we will sort through pks array to find the 3 brightest
        %%peaks separated by a certain number (say 100) of columns. This will produce
        %%the location of the three brightest sections of the image
        %%separated by this arbitrary number which corresponds to the y
        %%axis
        %[maxvals, maxindices] = max(pks);
        
        
        %Second we take each of these brightest peaks and collect all
        %values plus and minus 50 y bins of each. We then average all these
        %values together and create 3 final plots which will be the
        %averaged intensity of the 100 bins surrounding each of the
        %brightest peaks in the image. These will be outputted for new peak
        %analysis.
    %end
    %FUNCTION CALLS
    [xtotal,ztotal] = sortimage();
    notrend = removetrend(ztotal);
    zfinal = usefilter(notrend);
    [pks, locs] = peakarray(zfinal);
    
    
    
     figure(1)
     hold on
     plot(xtotal(:,500),-zfinal(:,500),'r')
     legend('Trend removed')
     hold off
     
%      figure(2)
%      hold on
%      plot(xtotal(:,500),ztotal(:,500),'r')
%      legend('Orig')
%      hold off
%      
%      figure(3)
%      hold on
%      plot(xtotal(:,500),notrend(:,500),'r')
%      legend('Trend removed')
%      hold off
     

    toc

end
