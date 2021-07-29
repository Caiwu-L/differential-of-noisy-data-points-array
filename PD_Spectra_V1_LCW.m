%Enter the value of t(0) 
t_val = 1;
filename1='PD-1P36-2OSP-SP';
filename=strcat(filename1,'.csv');
%Enter the filename for the SEC data
SEC_data_array  = csvread(filename);

%Find potential and wavelength data from arrays
% get data array also removing padding 0 from potential array
time_array  = SEC_data_array(1,2:end);
wavelengths_array = SEC_data_array(2:end,1);
data_array= SEC_data_array(2:end,2:end);

%Find position of reference time in array
Delta_t=abs(time_array-t_val);
[t_valmin,t_min_index]=min(Delta_t);
time_array2=time_array(t_min_index:end)';

% get regerance array using logical indexing
Ref_array=data_array(:,t_min_index);
log_RA=log10(Ref_array);

% calculate DOD array,using sgolayfilt to process all columns without loop
DOD=-log10(data_array)+log_RA;
DOD_smooth=sgolayfilt(DOD,3,499);

% get the data region that is more than the ref potential
output_data=DOD(:,t_min_index:end);
output_dataS=DOD_smooth(:,t_min_index:end);

%Plot data
columns = size(output_dataS);
columns = columns(2);
set(0,'DefaultAxesColorOrder',jet(columns))

plot(wavelengths_array,output_dataS,'linewidth',3)
xlabel('Wavelength (nm)') 
ylabel('Delta O.D.')
title('Smoothed spectra')
set(gca,'Fontsize',20);
xlim([350 1050]);
set(gca,'linew',3);
    
figure
surface(time_array2,wavelengths_array,output_dataS,'EdgeColor','none');
xlabel('Time (s)', 'FontSize', 25)

ylabel('Wavelength (nm)', 'FontSize', 25)
colorbar()
%h = colorbar();
%ylabel(h,'ΔA','FontSize', 16)
%set(h, 'ylim', [-100E-6,3E-3])
colormap turbo
set(gcf,'color','w');
set(gca,'FontSize',20)

%title('SEC data summary')
% put it all together
WL = SEC_data_array(:,1);
Final=[time_array;DOD];
Final=[WL,Final];

FinalS=[time_array;DOD_smooth];
FinalS=[WL,FinalS];

fileN=strcat(filename1,'_DOD.csv');
fileN2=strcat(filename1,'_SMOOTH_','DOD.csv');
csvwrite(fileN,Final);
csvwrite(fileN2,FinalS);
clear
clc