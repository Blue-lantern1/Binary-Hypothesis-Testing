clear all;
clc;

edb = [-30:5:20];
e = power(10,edb/20); %converting edb to normal scale

neta = sqrt(e)/2; %η = (mo + m1)/2; given mo=0,m1=√E

Pfa_th = qfunc(sqrt(5*e)/2); %theoritical calculation of Pfa
Pd_th = qfunc(-sqrt(5*e)/2); %theoritical calculation of Pd

Pfa_sim=zeros(1,length(edb)); 
Pd_sim=zeros(1,length(edb));

for i=1:length(edb)
    possiblec_FA = 0;
    possiblec_D = 0;
    for j=1:10000      %10000 iterations per point
        %genrating 5 samples under H0 and checking sufficient statistic
        if mean(normrnd(0,1,[1,5])) >= neta(i)
            possiblec_FA=possiblec_FA+1;
        end
        %genrating 5 samples under H1 and checking sufficient statistic
        if mean(normrnd(sqrt(e(i)),1,[1,5])) >= neta(i)
            possiblec_D = possiblec_D+1;
        end
    end
    Pfa_sim(i)=possiblec_FA/10000; %iterations satisfied/total number of iterations
    Pd_sim(i)=possiblec_D/10000; %iterations satisfied/total number of iterations
end
%Plotting
tiledlayout(2,1)

ax1=nexttile;
plot(ax1,edb,Pfa_th)
hold on;
plot(ax1,edb,Pfa_sim)
title(ax1,'Prob of false alarm vs E_d_b')
xlabel(ax1,'E_d_b')
ylabel(ax1,'P_F_A')
legend(ax1,{'Theoritical','Simulated'},Location="northeast")
grid on;

ax2=nexttile;
plot(ax2,edb,Pd_th)
hold on;
plot(ax2,edb,Pd_sim)
title(ax2,'Prob of detection vs E_d_b')
xlabel(ax2,'E_d_b')
ylabel(ax2,'P_D')
legend(ax2,{'Theoritical','Simulated'},Location="southeast")
grid on;