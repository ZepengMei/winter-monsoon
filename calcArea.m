%% 读取数据
% info = ncinfo('cru_ts4.07.1901.2022.tmp.dat.nc');
land = ncread('cru_ts4.07.1901.2022.tmp.dat.nc','tmp');
land = rot90(land);
time = ncread('cru_ts4.07.1901.2022.tmp.dat.nc','time');
time = timeCov(double(time),[1900 1 1]);
lat = flipud(ncread('cru_ts4.07.1901.2022.tmp.dat.nc','lat')); 
lon = (ncread('cru_ts4.07.1901.2022.tmp.dat.nc','lon'));
% 60-150, 0-50N
land = land(lat>=10&lat<=50,lon>=105&lon<=135,:);
lat = double(lat(lat>=10&lat<=50));
lon = double(lon(lon>=105&lon<=135));
[Lon,Lat]=meshgrid(lon,lat);
wgs84km = wgs84Ellipsoid("kilometer");
areaGrid = arrayfun(@(x) areaquad(x-0.25,0,x+0.25,0.5,wgs84km),lat);
areaGrid = repmat(areaGrid,1,length(lon));

land = land(:,:,time(:,1)>=1950);
th_list = -30:1:30;
for ii = 1:length(th_list)  
    a(:,:,ii) = aboveArea(land,areaGrid,th_list(ii));
     writematrix(a(:,:,ii),'data2.xlsx','sheet',num2str(th_list(ii)));
    %writematrix(zscore(a(:,:,ii)),'data_norm.xlsx','sheet',num2str(th_list(ii)));
end


