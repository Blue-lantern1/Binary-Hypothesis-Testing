clear all;
clc;

edb = [-10:5:10];
e = power(10,edb/20);%converting edb to normal scale
neta = [0.1:0.01:20];%varying η
for i=1:length(edb)
    Pfa_th = zeros(1,length(neta));
    Pd_th = zeros(1,length(neta));

    Pfa_sim = zeros(1,length(neta));
    Pd_sim = zeros(1,length(neta));

    %generating 10000 iterations of 5 samples under H0 and H1 respectively    
    h0 = normrnd(0,1,[10000,5]);
    h1 = normrnd(sqrt(e(i)),1,[10000,5]);
    %calculating sufficient statistic
    s0 = mean(h0,2);
    s1 = mean(h1,2);

    for j=1:length(neta)
        Pfa_th(j) = qfunc(neta(j)*sqrt(5)); %theoritical calculation of Pfa
        Pd_th(j) = qfunc((neta(j)-sqrt(e(i)))*sqrt(5)); %theoritical calculation of Pd
                
        possiblec_FA = 0;
        possiblec_D = 0;
        for k=1:10000   %checking sufficient statistic
            if s0(k) >= neta(j)
                possiblec_FA=possiblec_FA+1;
            end
            if s1(k) >= neta(j)
                possiblec_D = possiblec_D+1;
            end
        end
        Pfa_sim(j)=possiblec_FA/10000; %iterations satisfied/total number of iterations
        Pd_sim(j)=possiblec_D/10000; %iterations satisfied/total number of iterations

    end
    %Plotting
    subplot(2,3,i)
    plot(Pfa_th,Pd_th,'b',Pfa_sim,Pd_sim,'g')
    str = strcat('E=',num2str(edb(i)),'dB');
    text(0.3,0.5,str,'Color','red')
    title('ROC curve')
    xlabel('Prob of false alarm (P_F_A)')
    ylabel('Prob of detection (P_D)')
    legend({'Theoritical','Simulated'},Location="southeast")
    grid on;

    subplot(2,3,6)
    plot(Pfa_th,Pd_th,'b',Pfa_sim,Pd_sim,'g')
    title('ROC curves')
    xlabel('Prob of false alarm (P_F_A)')
    ylabel('Prob of detection (P_D)')
    legend({'Theoritical','Simulated'},Location="southeast")
    hold on;
    grid on;
end