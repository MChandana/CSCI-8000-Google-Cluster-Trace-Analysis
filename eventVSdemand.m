%%
% Author: Sruthi Palaparthi
% Last Revision: 12/04/2018
% Matlab Version: 2018a
% Version :1
clc;
clear all;
close all;
format long;
%% Define Variables
startTime=0.1666;  % Specify in Hours
endTime=30*24;
sTime=startTime*3600*10^6;
eTime=endTime*3600*10^6;
%% Load Data Table
loadDir='E:\CloudData\clusterdata-2011-2\task_events';
cd(loadDir);
fileList=dir('*.csv');
tblCtr=1;
foundFlag=0;
%% Separating Between Times
for flCtr=1:500
    
    dataTable = readtable(fileList(flCtr).name,'Delimiter',',','ReadVariableNames',false);
    dataTable.Properties.VariableNames={'Time','MissingInfo','JobID','TaskID'...
                                        'MachineID','EventType','User','SchdClass','Priority'...
                                        'CPUReq','MemReq','DskReq','DMR'};
    dataTable=dataTable(:,{'Time','JobID','TaskID','MachineID','EventType','Priority','CPUReq','MemReq'});
     rows=(dataTable.Time>sTime)&(sum(dataTable.Time<eTime));
     if (sum(rows)~=0)
         flCtr
        if foundFlag==0
            Table=dataTable(rows,:);
            foundFlag=1;
        else
            Table=[Table;dataTable(rows,:)];
        end
     else
        if(foundFlag==1)
            break;
        end
    end
end



%% Distribution for all priorities
mastTable=Table;
clear Table;
KCPU=-1;
grps=-1;
for i=0:11
    krows=mastTable.Priority==i;
    kCPU{i+1}=table2array(mastTable(krows,'CPUReq'));
    KCPU=[KCPU;kCPU{i+1}];
    grps=[grps;ones(sum(krows),1)*(i+1)];
    i
end
KCPU=KCPU(2:end);
grps=grps(2:end);
figure;boxplot(KCPU,grps,'Symbol','');


%% Distrubution for Priorities 0-1,2-8,9-11
lrows=(mastTable.Priority>=0)&(sum(mastTable.Priority<=3));
mrows=(mastTable.Priority>=4)&(sum(mastTable.Priority<=7));
hrows=(mastTable.Priority>=8)&(sum(mastTable.Priority<=11));
lCPU=table2array(mastTable(lrows,'CPUReq'));
mCPU=table2array(mastTable(mrows,'CPUReq'));
hCPU=table2array(mastTable(hrows,'CPUReq'));
cpuReq=[lCPU;mCPU;hCPU];
grps=[ones(sum(lrows),1);ones(sum(mrows),1)*2;ones(sum(hrows),1)*3];
figure;boxplot(cpuReq,grps,'Symbol','');set(gca,'XTickLabel',{'Low','Medium','High'});
%%
figure;subplot(311);hist(lCPU,100000);
subplot(312);hist(mCPU,1000000);subplot(313);hist(hCPU,100000);






