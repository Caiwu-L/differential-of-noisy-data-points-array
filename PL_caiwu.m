PL_file=csvread('1JG-P1-PL-Exp0.5sSEC.csv')
EL_file=csvread('1JG-P1-EL-Exp0.5sSEC.csv')
PL_BG_file=csvread('TAPE-Filter-bg-PL-exp0.5SEC.csv')
EL_BG_file=csvread('1JG-P1-dark-Exp0.5sSEC.csv')
WL=csvread('WL.csv')
Cal_sa1=csvread('FAPI-PL-10t-0.5t-exp0.5sSEC.csv')
Cal_sa2=csvread('FAPI-PL-exp0.5sSEC.csv')
Cal_lamp1=csvread('Hal-cal-10t-0.5t-exp0.5SEC.csv')
Cal_irra=readtable('aaa.csv')
Cal_irra=table2array(Cal_irra)
PL_spec=PL_file(2:end,2:end)
EL_spec=EL_file(2:end,2:end)
PL_BG_spec=PL_BG_file(2:end,2)
EL_BG_spec=EL_BG_file(2:end,2)
Cal_sa1_spec=Cal_sa1(2:end,2)
Cal_sa2_spec=Cal_sa1(2:end,2)
Cal_lamp1_spec=Cal_lamp1(2:end,2)
WL_array=WL(2:end-1,1)
Cal_irra_WL=Cal_irra(:,1);
Cal_irra_val=Cal_irra(:,2);
index=Cal_irra_WL>=601&Cal_irra_WL<=1020
Cal_irra_WL1=Cal_irra_WL(index)
Cal_irra_val_1=Cal_irra_val(index)


%background subtract
EL_S=EL_spec-EL_BG_spec;
PL_S=PL_spec-PL_BG_spec-EL_S;
Cal_sa1_S=Cal_sa1_spec-EL_BG_spec;
Cal_sa2_S=Cal_sa2_spec-EL_BG_spec;
Cal_lamp1_S=Cal_lamp1_spec-EL_BG_spec;

% interplate as 1 nm
inter_array=601:1:1020;
inter_array=inter_array';
EL_S_inter=interp1(WL_array,EL_S,inter_array,'spline');
PL_S_inter=interp1(WL_array,PL_S,inter_array,'spline');
Cal_sa1_S_inter=interp1(WL_array,Cal_sa1_S,inter_array,'spline');
Cal_sa2_S_inter=interp1(WL_array,Cal_sa2_S,inter_array,'spline');
Cal_lamp1_S_inter=interp1(WL_array,Cal_lamp1_S,inter_array,'spline');

index3=inter_array==800
y=Cal_lamp1_S_inter(index3)
Cal_irra_WL1=Cal_irra_WL(index)
Cal_irra_val_1=Cal_irra_val(index)

%spectrum correction

Cal_lamp2=Cal_lamp1_S_inter.*(Cal_sa2_S_inter./Cal_sa1_S_inter)


index2=Cal_irra_WL==800
Cal_irra_val_2=Cal_irra_val(index2)
Factor1=(Cal_irra_val_1/Cal_irra_val_2)./(Cal_lamp1_S_inter/y)
Factor2=Cal_irra_val_1./Cal_lamp2

Corr_PL=Factor1.*PL_S_inter
Corr_EL=Factor1.*EL_S_inter
Power_PL=Factor2.*Corr_PL
Power_EL=Factor2.*Corr_EL

%iradiance calculation
I_PL=inter_array'*Power_PL
I_EL=inter_array'*Power_EL

potential_PL=PL_file(1,2:end)'
potential_EL=EL_file(1,2:end)'

figure(1)
plot(potential_PL,I_PL);
figure(2)
plot(potential_EL,I_EL);

figure(3)
columns = size(Corr_PL);
columns = columns(2);
set(0,'DefaultAxesColorOrder',jet(columns))
plot(inter_array,Corr_PL,'linewidth',3);
xlabel('Wavelength (nm)') 
ylabel('Delta O.D.')
set(gca,'Fontsize',20);
set(gca,'linew',3);
set(gcf,'color','w');
axis square
figure(4)
columns = size(Corr_PL);
columns = columns(2);
set(0,'DefaultAxesColorOrder',jet(columns))
surface(potential_PL,inter_array,Corr_PL,'EdgeColor','none');


