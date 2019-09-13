% function ExportPRFsData()
% 
% Based on the work of S?nia Ferreira to export the values of PRFs maps
% from BrainVoayger 12/06/2015
?
?
%%
clear all
clc
close all
?
?
% Logging
% addpath('/usr/local/MATLAB/R2019a/toolbox/log4m/')
% addpath('/usr/local/MATLAB/R2019a/toolbox/log4m/')
% addpath('/home/fmachado/git/neuroelf-matlab')
?
Logger = log4m.getLogger('log_ageing_receptive_fields.txt');
?
% plot parameters
?
% tresholds 
thDotSize=0.5; % % size of fixation dot of stimuli
thBinSize=0.5; % Size of bin of eccentricity
thMaxEC=7; %maximum of eccentricity
?
    
?
?
% -------------------------------------------------------------------------
% -----------------------GET NEEDED FILES  --------------------------------
% -------------------------------------------------------------------------
?
?
?
DIRECTORY_DATA =  'C:\Users\Maria Fatima\Documents\Aging_ICNAS_PC_IBILI\Matlab files_agingProject\FatimaMachado\Ficheiros_pRFanalysis_27.08.2019\';
?
% DIRECTORY_DATA =  '/home/fmachado/Documents/fatimaloureiro_project/Ficheiros_pRFanalysis_27.08.2019/';
?
all_participants = dir(DIRECTORY_DATA);
?
header = {'Subject', 'ROI','Nr_Vertices','Mean_pRF_size', 'fit_m', 'fit_b','bin1','bin2','bin3','bin4','bin5','bin6','bin7','bin8','bin9','bin10','bin11','bin12', 'bin13'};
?
all_participants_data = [];
?
for j = 1 : length(all_participants)
    
    clearvars -except Logger all_participants all_participants_data header j SMP_POSITION_HEMISPHERE POI_POSITION_HEMISPHERE SRF_POSITION_HEMISPHERE DIRECTORY_DATA th*
    
    participant = all_participants(j).name;
    
    if (length(participant) < 3)
        continue;
    end
    
    Logger.info(mfilename, sprintf('Parsing Participant %s', participant))
    
    pathFilesParticipant = strcat(all_participants(j).folder , '\', participant);
    
    [smp_RH, smp_LH, poi_RH, poi_LH, srf_RH, srf_LH] = LoadSubjectData(pathFilesParticipant);
    
    smpMap_RH=smp_RH.Map;
    smpR_RH=smp_RH.Map(1);
    smpX_RH=smp_RH.Map(2);
    smpY_RH=smp_RH.Map(3);
    smpS_RH=smp_RH.Map(4);
    smpEC_RH=smp_RH.Map(5);
    smpPA_RH=smp_RH.Map(6);
            
    smpMap_LH=smp_LH.Map;
    smpR_LH=smp_LH.Map(1);
    smpX_LH=smp_LH.Map(2);
    smpY_LH=smp_LH.Map(3);
    smpS_LH=smp_LH.Map(4);
    smpEC_LH=smp_LH.Map(5);
    smpPA_LH=smp_LH.Map(6);
            
?
    % Check if the files selected belonging to the right hemisphere
    if (poi_RH.NrOfMeshVertices~=smp_RH.NrOfVertices || poi_RH.NrOfMeshVertices~=srf_RH.NrOfVertices);
        button=errordlg('Files do not correspond to the same data set.','Error');
        uiwait(button);
            return;
    end
?
    % Check if the files selected belonging to the left hemisphere
    if (poi_LH.NrOfMeshVertices~=smp_LH.NrOfVertices || poi_LH.NrOfMeshVertices~=srf_LH.NrOfVertices)
        button=errordlg('Files do not correspond to the same data set.','Error');
        uiwait(button);
        return;
    end
        
    %--------------------------------------------------------------------------
    %---------------------- EXTRACT DATA FOR EACH MAP -------------------------
    %--------------------------------------------------------------------------
?
    % extract the data for each map of the right hemisphere and find cluster 
    %  with non-zero values  
?
    dataR_RH=smpR_RH.SMPData; % R map: containing the square root of the explained variance of the best fitting pRF model per vertex
    dataX_RH=smpX_RH.SMPData; % Best-fit pRF x: contains the x location of the pRF model assigned to a vertex
    dataY_RH=smpY_RH.SMPData; % Best-fit pRF y:  contains the x location of the pRF model assigned to a vertex
    dataS_RH=smpS_RH.SMPData; % Best-fit pRF s: contains the receptive field size of the pRF model assigned to a vertex
    dataEC_RH=smpEC_RH.SMPData; % Eccentricity: contains estimates of eccentricity values that are simply obtained by applying the equation ecc = sqrt(x2 + y2) at each vertex
    dataPA_RH=smpPA_RH.SMPData; % Polar angle: contains estimates of the location in polar coordinates
?
    % extract the data for each map of the left hemisphere and find cluster 
    %  with non-zero values  
?
    dataR_LH=smpR_LH.SMPData; 
    dataX_LH=smpX_LH.SMPData; 
    dataY_LH=smpY_LH.SMPData; 
    dataS_LH=smpS_LH.SMPData;
    dataEC_LH=smpEC_LH.SMPData; 
    dataPA_LH=smpPA_LH.SMPData; 
?
?
    % concatenate the information provided of both hemispheres and find the  
    %  indices of cluster with non-zero values  
    dataR=[dataR_RH;dataR_LH];
    cluR=find(dataR~=0);
    dataX=[dataX_RH;dataX_LH];
    cluX=find(dataX~=0);
    dataY=[dataY_RH;dataY_LH];
    cluY=find(dataY~=0);
    dataS=[dataS_RH;dataS_LH];
    cluS=find(dataS~=0);
    dataEC=[dataEC_RH;dataEC_LH];
    cluEC=find(dataEC~=0);
    dataPA=[dataPA_RH;dataPA_LH];
    cluPA=find(dataPA~=0);
?
    %--------------------------------------------------------------------------
    %---------------------- EXTRACT DATA FROM EACH POI ------------------------
    %--------------------------------------------------------------------------
?
    nr_poi_RH=poi_RH.NrOfPOIs; % number the ROIs belonging to the right hemisphere
    nr_poi_LH=poi_LH.NrOfPOIs; % number the ROIs belonging to the left hemisphere
?
    % error: the number of ROIs is different between hemispheres
    % stop running script
    if (nr_poi_RH ~=nr_poi_LH)
        button=errordlg('Different number of ROIs detected between hemisphere.','Error');
        uiwait(button);
        return;
    end
?
    names={};
    names_POIs={};
    NrOfRoiVertices=[];
    ROI_fit_m = [];
    ROI_fit_b = [];
    Mean_pRF=[];
    % cmap=hsv(nr_poi_RH); % reates a 7-by-3 set of colors from the HSV colormap
?
    for ii=1:nr_poi_RH
?
        % get the name of the selected ROi of each hemisphere
        namePOI_RH=poi_RH.POI(ii).Name;
        space=find((isspace(poi_RH.POI(1).Name))==1);
        namePOI_RH=namePOI_RH(1:space);
        namePOI_LH=poi_RH.POI(ii).Name;
        space=find((isspace(poi_LH.POI(1).Name))==1);
        namePOI_LH=namePOI_LH(1:space);
?
        % error: the number of ROIs is different between hemispheres
            % stop running script
        if (namePOI_RH~=namePOI_LH)
            button=errordlg('Different ROI selected between hemisphere .','Error');
            uiwait(button);
            return;
        end
?
        names_POIs{end+1,1}=namePOI_RH; % save names of POis into a cell
?
        names=[names; namePOI_RH];
?
        NrOfRoiVertices(end+1,1)=poi_RH.POI(ii).NrOfVertices + poi_LH.POI(ii).NrOfVertices; % save the number of vertive of ROI;
?
    
        V=[poi_RH.POI(ii).Vertices; poi_LH.POI(ii).Vertices]; % Indices of vertices of the ROI
        VR=intersect(V,cluR); % get ID vertices of R map corresponding to POI
        VX=intersect(V,cluX); % get ID vertices of Best-fit pRF:x  corresponding to POI 
        VY=intersect(V,cluY); % get ID vertices of Best-fit pRF: corresponding to POI
        VS=intersect(V,cluS); % get ID vertices of Best-fit pRF:s corresponding to POI
        VEC=intersect(V,cluEC); % get ID vertices of Eccentricity corresponding to POI
        VPA=intersect(V,cluPA); % get ID vertices of Polar angle corresponding to POI
?
       % get the data of the selected ROi 
        data2R=dataR(VR);
        data2X=dataX(VX);
        data2Y=dataY(VY);
        data2S=dataS(VS);
        data2EC=dataEC(VEC);
        data2PA=dataPA(VPA);
?
    %     %Remove outliers
        [a,b]=sort(data2EC); % sorts the elements of data2EC in ascending order; a: sorted elements of data2EC; b: returns a collection of index vectors 
        dvpada=std(a);
        posOut=a+3*dvpada;
        negOut=a-3*dvpada;
        a=a(a<=posOut);
        a=a(a>=negOut);
        a=a(a<=thMaxEC);
?
       % get the mean of the pRF size inside ROI
        Mean_pRF(end+1,1)=mean(data2S(b));
?
        %Create eccentricty bins
    %       aBin=dotSize:binSize:maxEC;
        aBin=linspace(thDotSize,thMaxEC,(thMaxEC/thBinSize));  
?
        for n=1:length(aBin)-1
            binS=[];
            Bins(n)=(aBin(n)+aBin(n+1))/2; % get the mean value of eccentricity inside a Bin
?
            for i=1:length(a)
                if a(i)>=aBin(n) && a(i)<aBin(n+1)
                    if b(i)<=size(data2S,1)
                        binS(i)=data2S(b(i));
                    end
                end
                binS=binS(binS~=0);
            end
?
           if isnan(binS)==0
                bin2S(ii,n)=mean(binS);
           else
               bin2S(ii,n)=0;
               error=strcat('ATTENTION: NaN values in ROI  ',names(ii),'  for eccentricity  ',num2str(aBin(n+1)),' deg will be converted to zero');
               display(error);
           end
         end 
        bin3S=bin2S(ii,:); % get the mean values of PRFs for each ROI in each Bin
        pRFSize(ii,1:length(bin3S))=bin3S; % put mean values of pRFS size into a matrix (each line correspond to a VOI and ech column to a Bin)
        SD(ii,1:length(bin3S))=std(pRFSize(ii,1:length(bin3S)));  % calculate the standard deviation for each binned-data 
        SEM(ii,1:length(bin3S))=SD(ii,1:length(bin3S))/sqrt(length(pRFSize(ii,1:length(bin3S))));% calculate the standard error of the mean for each binned-data 
?
        % linear regression relation between pRF size and Bin of eceentricity 
       fitpRFs=polyfit(Bins,bin3S,1);% fit data       
       funcPRFs(ii,1:length(bin3S))=polyval(fitpRFs,Bins);
       ROI_fit_m(end+1,1) = fitpRFs(1);
       ROI_fit_b(end+1,1) = fitpRFs(2);
        
    end
?
?
    cmap=hsv(nr_poi_RH); % reates a 7-by-3 set of colors from the HSV colormap
?
    
%     for k=1:nr_poi_RH
%     figure(1), hold on
%     errorbar(Bins,pRFSize(k,:),SEM(k,:),'o','MarkerFaceColor',[cmap(k,:)],'MarkerEdgeColor',[0 0 0],'Color',[0 0 0],'LineWidth',0.5);
%     plot(Bins,funcPRFs(k,:), 'Color',[cmap(k,:)]);
%     end
% 
% 
%     set(gca,'XLim',[0 5])
%     ylabel('PRF Size (deg)')
%     xlabel(strcat('Bins of Eccentricity (',num2str(binSize),' deg)'))
%     legend(names,'EdgeColor',[1 1 1])
%     hold off
?
    % 
    % -------------------------------------------------------------------------
    % -------------------------  EXPORT DATA  ---------------------------------
    % -------------------------------------------------------------------------
?
    
    Data=[NrOfRoiVertices Mean_pRF ROI_fit_m ROI_fit_b pRFSize];
    Data=num2cell(Data);
    
    Data=[{participant; participant; participant} names_POIs Data];
    
    all_participants_data = [all_participants_data; Data];
    
    filenameSaveTable = sprintf('data\\%s_results_pRFs_Ageing.xls', participant);
    
    Logger.info(mfilename, sprintf('Saving resutls to file %s', filenameSaveTable))
    
    writetable (cell2table(Data, 'VariableNames', header), filenameSaveTable);
end
?
filenameSaveTable = 'data\all_results_pRFs_Ageing.xls';
?
writetable (cell2table(all_participants_data, 'VariableNames', header), filenameSaveTable);