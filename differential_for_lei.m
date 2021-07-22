%input data
filename='P34'
filename1=strcat(filename,'.csv');
Data=readtable(filename1)
Data=table2array(Data)
%select data range
x=Data(1099:1599,1);
y1=Data(1099:1599,2);

%set fitting tolerance, the less the best fitting for original data, but
%more noisy for differential data
fit_tolerance= 5e-04

%x=x(1:end-250);  %delete noisy data at high potential
%y1=y1(1:end-250);
%y2=Data(:,3);
%y2=y2(1:end-250);
%y3=Data(:,4);
%y3=y3(1:end-250);

%estimate noise range and fitting 
%sqrt(estimatenoise(y1));

[sp1,y1_fit] = spaps(x,y1,fit_tolerance);
fnplt(sp1)
y1_fit=fnplt(sp1)
y1_fit=y1_fit';
%x_fit= 300:1:500 %choose the data arrange you need to get 
%y1_fit=feval(spl,x_fit)
%sqrt(estimatenoise(y2));
%sp2 = spaps(x,y2,2e-08);
%fnplt(sp2)


%sqrt(estimatenoise(y3));
%sp3 = spaps(x,y3,2e-08);
%fnplt(sp3)


figure (1)
plot(x,y1,'k.')
hold on
fnplt(sp1)
%plot(x,y2,'k.')
%fnplt(sp2)
%plot(x,y3,'k.')
%fnplt(sp3)
%hold off
figure (2)
fnplt(fnder(spl))
y1_fit_dif=fnplt(fnder(spl))
y1_fit_dif=y1_fit_dif';

figure (3)
fnplt(fnder(fnder(spl),1))
y1_fit_dif2=fnplt(fnder(fnder(spl),1))
y1_fit_dif2=y1_fit_dif2'

fileN=strcat(filename,'_fit.csv');
fileN1=strcat(filename,'_fit_dif.csv');
fileN2=strcat(filename,'_fit_dif2.csv');
csvwrite(fileN,y1_fit);
csvwrite(fileN1,y1_fit_dif);
csvwrite(fileN2,y1_fit_dif2);
%hold on
%fnplt(fnder(sp2))
%fnplt(fnder(sp3))

