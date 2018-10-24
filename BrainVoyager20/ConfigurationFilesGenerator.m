%% Carlos PhD Vogals/Syllables/Words
datasetConfigs = struct();
datasetConfigs.subjects = {'CarlosFerreira'};

datasetConfigs.runs = {
    {'anatomical','run1','run2','run3'}, ...
    };

datasetConfigs.volumes = {
    [176 195 195 195] , ...
    };


datasetConfigs.TR = 2500;
datasetConfigs.prtPrefix = {
    {'Run1','Run2','Run3'}, ...
    };

datasetConfigs.path = 'E:\DATA_Carlos_PhD';
datasetConfigs.AnalysisPath = 'E:\DATA_Carlos_PhD\ANALYSIS';
datasetConfigs.shiftROI = false;
save('Configs_Carlos_PhD.mat','datasetConfigs')

%% Carlos Phonos
datasetConfigs = struct();
datasetConfigs.subjects = {'RenatoFonseca','JoaoPereira','RicardoSilva','NadiaAlves','AnaSapalo'};

datasetConfigs.runs = {
    {'anatomical','fonologico','semantico','overtspeech','innerspeech'}, ...
    {'anatomical','fonologico','semantico','overtspeech','innerspeech'}, ...
    {'anatomical','fonologico','semantico','overtspeech','innerspeech'}, ...
    {'anatomical','fonologico','semantico','overtspeech','innerspeech'}, ...
    {'anatomical','fonologico','semantico','overtspeech','innerspeech'}, ...
    };

datasetConfigs.volumes = {
    [176 114 96 65 65] , ...
    [176 222 186 125 125] , ...
    [176 222 186 125 125] , ...
    [176 222 186 125 125] , ...
    [176 222 186 125 125] , ...
    };

datasetConfigs.TR = 2500;
datasetConfigs.prtPrefix = {
    {'Fonologico','Semantico','Overtspeech','Innerspeech'}, ...
    {'Fonologico','Semantico','Overtspeech','Innerspeech'}, ...
    {'Fonologico','Semantico','Overtspeech','Innerspeech'}, ...
    {'Fonologico','Semantico','Overtspeech','Innerspeech'}, ...
    {'Fonologico','Semantico','Overtspeech','Innerspeech'}, ...
    };

datasetConfigs.path = 'E:\DATA_Carlos_Phonos';
datasetConfigs.AnalysisPath = 'E:\DATA_Carlos_Phonos\ANALYSIS';
datasetConfigs.shiftROI = false;
save('Configs_Carlos_Phonos.mat','datasetConfigs')

%% Clinical Trial
datasetConfigs = struct();
datasetConfigs.subjects = {'Subject01_S1','Subject01_S2','Subject01_S3','Subject01_S4','Subject01_S5',...
    'Subject02_S1','Subject02_S2','Subject02_S3','Subject02_S4','Subject02_S5',...
    'Subject03_S1','Subject03_S2','Subject03_S3','Subject03_S4','Subject03_S5',...
    'Subject04_S1','Subject04_S2','Subject04_S3','Subject04_S4','Subject04_S5',...
    'Subject05_S1','Subject05_S2','Subject05_S3','Subject05_S4','Subject05_S5',...
    'Subject06_S1','Subject06_S2','Subject06_S3','Subject06_S4','Subject06_S5',...
    'Subject07_S1','Subject07_S2','Subject07_S3','Subject07_S4','Subject07_S5',...
    'Subject08_S1','Subject08_S2','Subject08_S3','Subject08_S4','Subject08_S5',...
    };
datasetConfigs.runs = {'anatomical','loc','train','fv1','fv2','trans'};
datasetConfigs.volumes = [176 160 300 300 300 300];
datasetConfigs.TR = 2000;
datasetConfigs.prtPrefix = {'Dynamic','TrainFeedbackPrt','Visual1FeedbackPrt','Visual2FeedbackPrt','TransferFeedbackPrt'};
datasetConfigs.path = 'T:\DATA_ClinicalTrial';
datasetConfigs.AnalysisPath = 'T:\DATA_ClinicalTrial\ANALYSIS';
datasetConfigs.shiftROI = true;
save('Configs_ClinicalTrial.mat','datasetConfigs')

%% N-back Daniela
datasetConfigs = struct();
datasetConfigs.subjects = {'ElioRodrigues','JoaoAndrade','LuisFerreira','TaniaMarques',...
    'OrlandoGalego','MartaSilva','RaquelMonteiro','MiguelCarvalho',...
    'HugoQuental','TeresaSousa','BrunoLeitao','AlexandreCampos',...
    'AnaInesMartins','MarianaBaptista','TiagoFernandes',...
    'JoaoCarvalho','JoaoDuarte','CristinaDuque',...
    'NunoDuarte'};
datasetConfigs.runs = {'anatomical','loc','train','NF1','NF2','NF3','trans'};
datasetConfigs.folders = {'anatomical','run-loc-data','run-train-data','run-NF1-data','run-NF2-data','run-NF3-data','run-trans-data'};
datasetConfigs.volumes = [176 315 195 195 195 195 195];
datasetConfigs.TR = 2000;
datasetConfigs.prtPrefix = {'DanielaNF_nBackTask315v1back','DanielaNF195v','DanielaNF195v','DanielaNF195v','DanielaNF195v','DanielaNF195v'};
datasetConfigs.path = 'L:\DATA_Daniela_20';
datasetConfigs.AnalysisPath = 'L:\DATA_Daniela_20\ANALYSIS';
datasetConfigs.shiftROI = true;
save('Configs_Daniela.mat','datasetConfigs')

%% InterHemispheric NF Joao Pereira
datasetConfigs = struct();
datasetConfigs.subjects = {'JoaoDuarte','JoaoPereira'};
datasetConfigs.runs = {'anatomical','loc','train','NF1','NF2','NF3','trans'};
datasetConfigs.volumes = [176 340 340 340 340 340 340];
datasetConfigs.TR = 1500;
datasetConfigs.prtPrefix = {'interhemisphericLocalizer340v','interhemisphericFeedback340v','interhemisphericFeedback340v','interhemisphericFeedback340v','interhemisphericFeedback340v','interhemisphericFeedback340v'};
datasetConfigs.path = 'L:\DATA_InterHemisphericNF';
datasetConfigs.AnalysisPath = 'L:\DATA_InterHemisphericNF\ANALYSIS';
datasetConfigs.shiftROI = false;
save('Configs_InterHemNF.mat','datasetConfigs')

%% TEST DATASET
datasetConfigs = struct();
datasetConfigs.subjects = {'Subject01_S1','Subject01_S2','Subject01_S3','Subject01_S4','Subject01_S5',...
    'Subject02_S1','Subject02_S2','Subject02_S3','Subject02_S4','Subject02_S5',...
    'Subject03_S1','Subject03_S2','Subject03_S3','Subject03_S4','Subject03_S5',...
    };
datasetConfigs.runs = {'anatomical','loc','train','fv1','fv2','trans'};
datasetConfigs.volumes = [176 160 300 300 300 300];
datasetConfigs.TR = 2000;
datasetConfigs.prtPrefix = {'Dynamic','TrainFeedbackPrt','Visual1FeedbackPrt','Visual2FeedbackPrt','TransferFeedbackPrt'};
datasetConfigs.path = 'C:\Users\alexa\Desktop\DATA_FOLDER_TEST';
datasetConfigs.AnalysisPath = 'C:\Users\alexa\Desktop\DATA_FOLDER_TEST\ANALYSIS';
save('Configs_TEST.mat','datasetConfigs')

%% N-back TEST
datasetConfigs = struct();
datasetConfigs.subjects = {'AlexandreCampos'};
datasetConfigs.runs = {'anatomical','loc','train','NF1','NF2','NF3','trans'};
datasetConfigs.folders = {'anatomical','run-loc-data','run-train-data','run-NF1-data','run-NF2-data','run-NF3-data','run-trans-data'};
datasetConfigs.volumes = [176 315 195 195 195 195 195];
datasetConfigs.TR = 2000;
datasetConfigs.prtPrefix = {'DanielaNF_nBackTask315v1back','DanielaNF195v','DanielaNF195v','DanielaNF195v','DanielaNF195v','DanielaNF195v'};
datasetConfigs.path = 'C:\Users\alexa\Desktop\TesteBV3.0';
datasetConfigs.AnalysisPath = 'C:\Users\alexa\Desktop\TesteBV3.0\ANALYSIS';
datasetConfigs.shiftROI = true;
save('Configs_NbackTEST.mat','datasetConfigs')

%% NECSUS TEST
datasetConfigs = struct();
datasetConfigs.subjects = {'AlexandreCampos'};
datasetConfigs.runs = {'anatomical','loc','train','NF1','NF2','NF3','trans'};
datasetConfigs.folders = {'anatomical','run-loc-data','run-train-data','run-NF1-data','run-NF2-data','run-NF3-data','run-trans-data'};
datasetConfigs.volumes = [176 315 195 195 195 195 195];
datasetConfigs.TR = 2000;
datasetConfigs.prtPrefix = {'DanielaNF_nBackTask315v1back','DanielaNF195v','DanielaNF195v','DanielaNF195v','DanielaNF195v','DanielaNF195v'};
datasetConfigs.path = 'C:\Users\alexa\Desktop\TesteBV3.0';
datasetConfigs.AnalysisPath = 'C:\Users\alexa\Desktop\TesteBV3.0\ANALYSIS';
datasetConfigs.shiftROI = true;
save('Configs_NbackTEST.mat','datasetConfigs')
