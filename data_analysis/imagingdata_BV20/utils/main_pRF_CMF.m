%% Load data

% File paths.
DIRECTORY_DATA = 'E:\Ficheiros_pRFanalysis_27.08.2019\AD42';

% File names.
srfF_name='AD42_ANAT_Average_aTAL_WM_RH_RECOSM_CORR_INFL.srf';
smpF_name='AD42_pRF_OC_RH_30_30_30_x_-7.27-7.27_y_-7.27-7.27_s_0.20-7.00.smp';
poiF_name='AD42_RetinotopicAreas_V1V2V3_RH.poi';

% Open files using neuroelf.
srfF=xff(fullfile(DIRECTORY_DATA,srfF_name));
smpF=xff(fullfile(DIRECTORY_DATA,smpF_name));
poiF=xff(fullfile(DIRECTORY_DATA,poiF_name));

fprintf('the srf files must match \n \t %s \n \t %s \n \t %s\n', srfF_name, smpF.NameOfOriginalSRF,poiF.FromMeshFile )

%% Extract required data

% Get coordenates from mesh.
srf_vcoords=srfF.VertexCoordinate;
% Get coordenates from  statistical maps (e.g. map #1 ,i.e. R).
smp_Rvalues= smpF.Map(1).SMPData;
% Should have the same length as srf.VertexCoordinate (the order is
% important).
fprintf('the num of vrt in srf %i must match %i\n',...
    size(srf_vcoords,1),...
    numel(smp_coords))

% POI analysis
for v=1:numel(poiF.POI)
    % poiF.POI(v).Vertices gives you the list of vertices (idxs)
    % that need to be accessed in smp.Map(1).SMPData and srf.VertexCoordinate
    poi_idxs=poiF.POI(v).Vertices;
    % values for corresponding idxs.
    poi_Rvalues=smp_Rvalues(poi_idxs);    
    % Coords of each voxel of the poi.
    poi_coords_pIdx=srf_vcoords(poi_idxs,:);
    % Neighbors of each voxel of the poi.
    poi_neighbors_pIdx=srfF.Neighbors(poi_idxs,:);
end


%% Figure with patch - display neighbors, etc.
figure,
patch(...
    poi_coords_pIdx(:,1)',...
    poi_coords_pIdx(:,2)',...
    poi_coords_pIdx(:,3)',...
    zeros(size(poi_Rvalues)),...
    'EdgeColor','none',...
    'Marker','.',...
    'MarkerFaceColor','flat')
hold on
for i=1:10
    n_idxs=poi_neighbors_pIdx{i,2};
    n_coords=srf_vcoords(n_idxs,:);
    for ii=1:numel(n_idxs)
        patch(...
            n_coords(:,1)',...
            n_coords(:,2)',...
            n_coords(:,3)',...
            ones(size(n_coords(:,1)'))*i,...
            'EdgeColor','interp',...
            'Marker','o',...
            'MarkerFaceColor','flat')
    end
    pause(1)
end
