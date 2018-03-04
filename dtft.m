%implimentation of DTFT using matrix multiplication
%the code constructs the matrix W: Refer the notes of DSP in copy
n=-1:3;
x=1:5;
M=500;
w=2*pi/M;%range from 0 to 2*pi
k=0:M-1;
W=exp(-1i*w*n'*k);
X=x*W;
% to make normalized axis wile ploting use n=k/m;
% where n is nrmalised index and 1 means pi
% now we will compare it with the original matlab fft function
y=fft(x); 
n=0:4;
n=n/5;
figure(1);
plot(k/M,abs(X));
hold on;
plot(n,abs(y));
%in the figure we see that the points of fft lie on our made dft
%%
%the code in previous section generates a 5 point dft because the original function was also 5 point 
%to get denser fft use zero padding
x1=zeros(1,length(k));
x1(1:length(x))=x;
y=fft(x1);
n=0:length(y)-1; 
n=n/M;
figure(1);
plot(k/M,abs(X));
hold on;
plot(n,abs(y),'r--');
%%
%Although the magnitude spectrum coninsides but the phase spectrum dont,
%the reason behind this is that the fft function dosent takes into account
%the horizontal axis. 
x1=zeros(1,length(k));
x1(1:length(x))=x;
y=fft(x1);
n=0:length(y)-1; 
n=n/M;
figure(1);
plot(k/M,angle(X));
hold on;
plot(n,angle(y));
%%
% the above problem can be rectified by using time shift property
x1=zeros(1,length(k));
x1(1:length(x))=x;
y=fft(x1).*exp(1i*w*1*k);%our axis starts from -1 and fft assmes it from 0 so we advannce it by n=1;
n=0:length(y)-1; 
n=n/M;
figure(1);
plot(k/M,angle(X));
hold on;
plot(n,angle(y),'r--');
%%
%frequency shifting
n=-100:100;
x=cos(0.2*n);
y=fft(x);
M=500;
w=2*pi/500;
xs=x.*exp(1i*pi/2*n);%to shift the frequency by pi/2
k=-M/2:(M/2)-1;
W=exp(-1i*w*n'*k);
X=x*W;
Xs=xs*W;
hold on;
plot(k/M,abs(X),'g');
plot(k/M,abs(Xs),'r');
% lets check by doing shift with function
[XXs,w]=sigshift(X,k,125);%125 is equivalent to pi/2
plot(w/M,abs(XXs),'k--');%black superimposes red to see red comment this line

%%
% convulation in time domain
x1=randn(1,5);
n1=-1:3;
x2=randn(1,6);
n2=-3:2;
[x3,n3]=con_m(x1,n1,x2,n2);
M=500;
w=2*pi/M;
k=-M/2:(M/2)-1;
W=exp(-1i*w*n1'*k);
X1=x1*W;
W=exp(-1i*w*n2'*k);
X2=x2*W;
W=exp(-1i*w*n3'*k);
X3=x3*W;
subplot(3,1,1);
plot(k/M,abs(X1));
subplot(3,1,2);
plot(k/M,abs(X2));
subplot(3,1,3);
hold on;
plot(k/M,abs(X3));
[XX3,w]=sigmult(X2,k,X1,k);
plot(w/M,abs(XX3),'r--');%we see that the multiplication completly over lap the result after convulation
%while the corellation the scond signal gets conjugated
%%
% parseval theorem
n=-1:3;
x=randn(1,5);
E1=sum(x.^2);
M=50000;
k=0:(M-1);
w=2*pi/M;
W=exp(-1i*w*n'*k);
X=x*W;
E2=(1/(2*pi))*trapz(abs(X).^2)*w;%trapz(X) is used to perform numerical inegration with dx = 1 the function here is multiplied with w to change dx to w
E1
E2
