clear all;
addpath("raw_data");

%% crab density

data = readtable('raw_data\maryland data.xlsx','Sheet','final data'); % raw data
data.total_crabs = data.total_crabs*1e6;
data.adult_fems = data.adult_fems*1e6;
data.juveniles = data.juveniles*1e6;
% densities
chesapeake_bay_area = 9.8*10^3*10^3; % 1000m^2
data.juveniles_density = data.juveniles/chesapeake_bay_area; % crabs/1000m^2
data.adult_fems_density = data.adult_fems/chesapeake_bay_area; % crabs/1000m^2
data.total_crabs_density = data.total_crabs/chesapeake_bay_area; % crabs/1000m^2

data = data(4:end-1,:); % from year 1993 to 2023 to match with temperature

save('processed_data\data.mat','data');

%% temperature

temperature = ncread("raw_data\tos.nwa.full.hcast.monthly.regrid.r20250715.199301-202312.nc",'tos');
latitude = ncread("raw_data\tos.nwa.full.hcast.monthly.regrid.r20250715.199301-202312.nc",'lat');
latitude = round(latitude,2);
longitude = ncread("raw_data\tos.nwa.full.hcast.monthly.regrid.r20250715.199301-202312.nc",'lon');
longitude = round(longitude,2);

% chesapeake bay coordinates
chesapeake_lat = 38.21;
chesapeake_lon = round(283.74-360,2);
x = find(longitude == chesapeake_lon); 
y = find(latitude == chesapeake_lat);
T = reshape(permute(temperature(x,y,:),[3 2 1]),12,[]);

save('processed_data\temperature.mat','T');