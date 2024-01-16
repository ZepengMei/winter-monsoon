
clear
% clc

% addpath('m_map')


%%a = ncinfo('cru_ts4.07.1901.2022.tmp.dat.nc')    
%%a.Variables.Name               
path_1 = ['cru_ts4.07.1901.2022.tmp.dat.nc']; 
lon  = double(ncread(path_1,'lon'));
lat  = double(ncread(path_1,'lat'));
time = double(ncread(path_1,'time'));
sst  = double(ncread(path_1,'tmp'));
% sst(:,:,1813:1814)=[];
% time(1813:1814)=[];
Tbase = datenum(1901, 1, 1);
time=time+Tbase; clear Tbase
% datestr(time)

% select 1940-2019


clear Tbase
startYear = 1950;
endYear = 2022;
T1 = datenum(startYear, 1, 1);
T2 = datenum(endYear,1,1);
n=find(time>= T1 & time <= T2);
% for i = startYear : endYear
%     T1 = datenum(i, 1, 1);
%     T2 = datenum(i+1,1,1);
%     
%     if length(n)~= 12
%         adsf=1
%     end
% end
sst=sst(:,:,n);
TIME=time(n); 
% datestr(TIME)

T=datestr(TIME);
clear time n T1 T2 path_1


%% change -180-180 to 0-360
[a]=find(lon >= 0);
[b]=find(lon < 0);
Lon =lon(b,1)+360;
lon=lon(a); lon(end+1:length(a)+length(b))=Lon; 
SST= sst(a,:,:);
SST(end+1:length(a)+length(b),:,:)=sst(b,:,:);
clear Lon a b sst

%% Fill the missing value with NaN
[m]=find(SST==-1.000000015047466e+30);
sst(m)=NaN;
clear m;

%% calculate season average (3-5)
a=(size(SST,3)/12); % 1940-2019
TIME(:,1)=repmat((1:1:12)',a,1);
TIME(:,2)=sort(repmat((startYear:endYear-1)',12,1),'ascend');
clear m; 


SST2 = SST;
SST3 = SST;
SST4 = SST;
SST5 = SST;
TIME2 = TIME;
TIME3 = TIME;
TIME4 = TIME;
TIME5 = TIME;
[m2]=find(TIME(:,1)~= 3 & TIME(:,1)~=4 & TIME(:,1)~=5);
[m3]=find(TIME(:,1)~= 6 & TIME(:,1)~=7 & TIME(:,1)~=8);
[m4]=find(TIME(:,1)~= 9 & TIME(:,1)~=10 & TIME(:,1)~=11);
[m5]=find(TIME(:,1)~= 12 & TIME(:,1)~=1 & TIME(:,1)~=2);
SST2(:,:,m2)=[]; 
TIME2(m2,:)=[];
SST3(:,:,m3)=[]; 
TIME3(m3,:)=[];
SST4(:,:,m4)=[]; 
TIME4(m4,:)=[];
SST5(:,:,m5)=[]; 
TIME5(m5,:)=[];

SST_AVG2=nanmean(SST2,3);
SST_AVG3=nanmean(SST3,3);
SST_AVG4=nanmean(SST4,3);
SST_AVG5=nanmean(SST5,3);

%% map
[Lat1,Lon1]=meshgrid(lat,lon);
figure('Units','centimeter','Position',[5 5 9 5]); % subplot(2,1,1);
m_proj('miller','lon',[90 290],'lat',[-31 31]);
hold on
m_colmap('jet',256);
m_contourf(Lon1,Lat1,SST_AVG2,60,'edgecolor','none');
[c,h]=m_contour(Lon1,Lat1,SST_AVG2,[25.5  29.5],'ShowText','on','Color','k','linewidth',1.5);
clabel(c,h,'FontSize',14) 
m_coast('color','k','linewidth',0.5);
m_grid('linestyle','none','tickdir','in','Yminortick','on','linewidth',0.5,'FontSize',14, ...
'xlim',[90,290],'xtick', [100 160 220 280],'ytick', [-30 -15 0 15 30],'TickDir','out')
caxis([18 30])
clabel(c,h,'LabelSpacing',400);
colormap(m_colmap('diverging',256))
colorbar('position',[0.93 0.17 0.02 0.7])

figure('Units','centimeter','Position',[5 5 9 5]); % subplot(2,1,1);
m_proj('miller','lon',[90 290],'lat',[-41 41]);
hold on
m_colmap('jet',256);
m_contourf(Lon1,Lat1,SST_AVG3,60,'edgecolor','none');
[c,h]=m_contour(Lon1,Lat1,SST_AVG3,[25.5  29.5],'ShowText','on','Color','k','linewidth',1.5);
clabel(c,h,'FontSize',14) 
m_coast('color','k','linewidth',0.5);
m_grid('linestyle','none','tickdir','in','Yminortick','on','linewidth',0.5,'FontSize',14, ...
'xlim',[90,290],'xtick', [100 160 220 280],'TickDir','out')
caxis([12 30])
clabel(c,h,'LabelSpacing',400);
colormap(m_colmap('diverging',256))
colorbar('position',[0.93 0.17 0.02 0.7])


figure('Units','centimeter','Position',[5 5 9 5]); % subplot(2,1,1);
m_proj('miller','lon',[90 290],'lat',[-41 41]);
hold on
m_colmap('jet',256);
m_contourf(Lon1,Lat1,SST_AVG4,60,'edgecolor','none');
[c,h]=m_contour(Lon1,Lat1,SST_AVG4,[25.5  29.5],'ShowText','on','Color','k','linewidth',1.5);
clabel(c,h,'FontSize',14) 
m_coast('color','k','linewidth',0.5);
m_grid('linestyle','none','tickdir','in','Yminortick','on','linewidth',0.5,'FontSize',14, ...
'xlim',[90,290],'xtick', [100 160 220 280],'TickDir','out')
caxis([12 30])
clabel(c,h,'LabelSpacing',400);
colormap(m_colmap('diverging',256))
colorbar('position',[0.93 0.17 0.02 0.7])


figure('Units','centimeter','Position',[5 5 9 5]); % subplot(2,1,1);
m_proj('miller','lon',[60 150],'lat',[0 50]);
hold on
m_colmap('jet',256);
m_contourf(Lon1,Lat1,SST_AVG5,60,'edgecolor','none');
[c,h]=m_contour(Lon1,Lat1,SST_AVG5,[-27  -15  5  27],'ShowText','on','Color','k','linewidth',1.5);
clabel(c,h,'FontSize',14) 
m_coast('color','k','linewidth',0.5);
m_grid('linestyle','none','tickdir','in','Yminortick','on','linewidth',0.5,'FontSize',14, ...
'xlim',[60,150],'xtick', [70 80 90 100 110 120 130 140],'TickDir','out')
caxis([-30 30])
clabel(c,h,'LabelSpacing',400);
colormap(m_colmap('diverging',256))
colorbar('position',[0.93 0.17 0.02 0.7])

