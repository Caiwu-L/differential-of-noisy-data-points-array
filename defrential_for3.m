filename='juliafitting_ir'
filename1=strcat(filename,'.csv');
Data=readtable(filename1)
Data=table2array(Data)
x=Data(650:end,1);
y1=Data(:,2);
y2=Data(:,3);
y3=Data(650:end,4);

fit_tolerance3= 8e-9
[sp3,y3_fit] = spaps(x,y3,fit_tolerance3,1);
plot(x,y3,'k.')
fnplt(sp3)
y3_fit=fnplt(sp3)
y3_fit=y3_fit';
figure (1)
fnplt(fnder(sp3))
y3_fit_dif=fnplt(fnder(sp3))
y3_fit_dif=y3_fit_dif';
hold off


figure (1)

plot(x,y3,'k.')
fnplt(sp3)
hold off
figure (2)
hold on
y3_fit_dif=fnplt(fnder(sp3))
y3_fit_dif=y3_fit_dif';
hold off