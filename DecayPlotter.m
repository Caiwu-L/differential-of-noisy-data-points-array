filename1='decay-1.18-1.26OSP-SP';
filename=strcat(filename1,'.csv');
data=csvread(filename);
filename2='WL';
filename2_=strcat(filename2,'.csv');
    
WL_array  = csvread(filename2_);
%wavelengths_array0 = SEC_data_array(:,1);
wavelengths_array=WL_array(:,1);
WL=[0;wavelengths_array];

% set Wl and range to average around select referanc time to calculate DOD
WL_val=500;
range=20;
upper=WL_val+range;
lower=WL_val-range;
t_val=10;
% get data 
time=data(1,:);
WL0=data(:,1);
spectra=data(2:end,2:end);

% get boolean for WL ranges
WL_TF=WL<upper&WL>lower;

%get t value closest to selected 


Delta_t=abs(time-t_val);
t_valmin=min(Delta_t);
time_TF=Delta_t==t_valmin;
t_val2=time(time_TF);



%get region of interest
region=spectra(WL_TF,:);

% average WL values together
N=length(time);
N=N-1;
for i=1:N
    Final(i)=mean(region(:,i));
end 
time2=time(2:end)';
time2=time2';

% get the intensity at selected time

time_TF2=time_TF(2:end)';
Io=Final(time_TF2);
%Io=Io(1); %for 0.01M 1.13 V data
DOD=-log10(Final/Io);
%DOD_smooth=smooth(DOD,20,'sgolay',2);
DOD_smooth=smooth(DOD,0.02,'rlowess');
% plot data region
figure
plot(time2,Final);
xlabel('Time (s)') 
ylabel('Counts.')
set(gca,'Fontsize',20);
set(gca,'linew',3);
figure
hold on
plot(time2,DOD) 
plot(time2,DOD_smooth,'color','red') 
xlabel('Time (nm)') 
ylabel('Delta O.D.')
set(gca,'Fontsize',20);
set(gca,'linew',3);
hold off

Final=[time2',DOD'];
FinalS=[time2',DOD_smooth];

WL_val_string=num2str(WL_val);
filename2=strcat(WL_val_string,"_Kinetic_",filename);
filename_s=strcat(WL_val_string,"_Kinetic_SMOOTHED_",filename);

csvwrite(filename2,Final);
csvwrite(filename_s,FinalS);

clear
clc

