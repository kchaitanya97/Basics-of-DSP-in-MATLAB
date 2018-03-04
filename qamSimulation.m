%This is a simulation for a quadrature amplitude modulation.

%generating a random signal which ic considered as an output of a sensor
Signal = 5*ones(1,1000)+randn(1,1000)*1.5;
%generating time axis and two mutually orthogonal signals O0, O1. These
%orthogonal signal will serve as the basis signals in the 2-D plane
t = [0:0.001:1];
O0 = sqrt(2)*cos(2*pi*100*t);
O1 = sqrt(2)*sin(2*pi*100*t);
%normalizing the incoming signal to put it in scale of 0 to 1
M = max(Signal);
Signal = Signal./M;
%quantizing the signal
Quant = zeros(1,length(Signal));
for i=1:length(Signal)
    if Signal(i)<=0.125
        Quant(i)=0;
    elseif Signal(i)>=0.125&&Signal(i)<=0.25
        Quant(i)=0.125;
    elseif Signal(i)>=0.25&&Signal(i)<=0.375
        Quant(i)=0.25;
    elseif Signal(i)>=0.375&&Signal(i)<=0.5
        Quant(i)=0.375;
    elseif Signal(i)>=0.5&&Signal(i)<=0.625
        Quant(i)=0.5;
    elseif Signal(i)>=0.625&&Signal(i)<=0.75
        Quant(i)=0.625;
    elseif Signal(i)>=0.75&&Signal(i)<=0.875
        Quant(i)=0.75;
    else 
        Quant(i)=0.875;    
    end
end
figure(1)
subplot(5,2,1);
plot(Quant);
% getting the the constellation diagram
x = zeros(1,length(Signal));
y = zeros(1,length(Signal));
x(Signal<=0.125) = (10^(-3))^0.5;
y(Signal<=0.125) = 0;
x(Signal>=0.125&Signal<=0.25) = (10^(-3))^0.5;
y(Signal>=0.125&Signal<=0.25) = (10^(-3))^0.5;
x(Signal>=0.25&Signal<=0.375) = 0;
y(Signal>=0.25&Signal<=0.375) = (10^(-3))^0.5;
x(Signal>=0.325&Signal<=0.5) = -(10^(-3))^0.5;
y(Signal>=0.325&Signal<=0.5) = (10^(-3))^0.5;
x(Signal>=0.5&Signal<=0.625) = -(10^(-3))^0.5;
y(Signal>=0.5&Signal<=0.625) = 0;
x(Signal>=0.625&Signal<=0.75) = -(10^(-3))^0.5;
y(Signal>=0.625&Signal<=0.75) = -(10^(-3))^0.5;
x(Signal>=0.75&Signal<=0.875) = 0;
y(Signal>=0.75&Signal<=0.875) = -(10^(-3))^0.5;
x(Signal>=0.875&Signal<=1) = (10^(-3))^0.5;
y(Signal>=0.875&Signal<=1) = -(10^(-3))^0.5;
subplot(5,2,2);
scatter(x,y);
% modulating the information from the incoming signal on the orthonormal
% basis
xmod = zeros(1,length(t)*length(Signal));
ymod = zeros(1,length(t)*length(Signal));
for i=1:length(Signal)
    xmod((i-1)*length(t)+1:1:i*length(t))=x(i)*O0;
    ymod((i-1)*length(t)+1:1:i*length(t))=y(i)*O1;
end
%the final signal which is to be transmitted
final = xmod+ymod;
subplot(5,2,3);
plot(final);
%white gaussian noise with standard deviation of N/2
N = 10^(-1);
noise = randn(1,length(final))*(N/2);
%the recieved signal
recieved = final + noise;
subplot(5,2,4);
plot(recieved);
%deomdulation of the signal 
xr = zeros(1,length(Signal));
yr = zeros(1,length(Signal));
for i=1:length(Signal)
    xr(i) = sum(recieved((i-1)*length(t)+1:1:i*length(t)).*O0)/length(t);
    yr(i) = sum(recieved((i-1)*length(t)+1:1:i*length(t)).*O1)/length(t);
end
% the constelation diagram of the incoming signal 
subplot(5,2,5);
scatter(xr,yr);
%getting the final signal 
decider = [(xr*((10^(-3))^0.5) + yr*0-0.001*0.5*ones(1,length(yr)));(xr*((10^(-3))^0.5)+yr*((10^(-3))^0.5)-0.001*ones(1,length(yr)));(xr*0+yr*((10^(-3))^0.5)-0.001*0.5*ones(1,length(yr)));(xr*(-(10^(-3))^0.5)+yr*((10^(-3))^0.5)-0.001*ones(1,length(yr)));(xr*(-(10^(-3))^0.5)+yr*(0)-0.001*0.5*ones(1,length(yr)));(xr*(-(10^(-3))^0.5)+yr*(-(10^(-3))^0.5)-0.001*ones(1,length(yr)));(xr*(0)+yr*(-(10^(-3))^0.5)-0.001*0.5*ones(1,length(yr)));(xr*((10^(-3))^0.5)+yr*(-(10^(-3))^0.5)-0.001*ones(1,length(yr)))];
Rec_Signal = zeros(1,length(Signal));
test = zeros(1,length(Signal));
for i=1:length(Signal)
    decide = find(decider(:,i)==max(decider(:,i)));
    test(i) = decide;
    if decide==1
        Rec_Signal(i)=0;
    elseif decide==2
        Rec_Signal(i)=0.125;
    elseif decide==3
        Rec_Signal(i)=0.25;
    elseif decide==4
        Rec_Signal(i)=0.375;
    elseif decide==5
        Rec_Signal(i)=0.5;
    elseif decide==6
        Rec_Signal(i)=0.625;
    elseif decide==7
        Rec_Signal(i)=0.75;
    else 
        Rec_Signal(i)=0.875;    
    end
end
subplot(5,2,6)
plot(Rec_Signal);
subplot(5,2,7);
plot(x);
subplot(5,2,8);
plot(y);
subplot(5,2,9);
plot(xr);
subplot(5,2,10)
plot(yr);
figure(2)
subplot(2,1,1)
plot(xcorr(Signal,Signal),'g');
subplot(2,1,2)
plot(xcorr(Rec_Signal,Signal));