%% Phase Noise Effects on Advanced Radar Waveforms
%
% Please cite these 2 articles
% 
% [1] E. Onat and A. Orduyilmaz, "The Effect of Phase Noise on Radar Waveforms and Performance Analysis," 2025 33rd Signal Processing and Communications Applications Conference (SIU), Sile, Istanbul, Turkiye, 2025, pp. 1-4, doi: 10.1109/SIU66497.2025.11111835.
% [2] E. Onat and A. Orduyilmaz, "Phase Noise Effects on Advanced Radar Waveforms: A Performance Study of Linear and Nonlinear Frequency Modulations," International Journal of Advances in Engineering and Pure Sciences, vol. XX, no. Y, pp. AAA–BBB, 202C, doi: 10.7240/jeps.1111111.
%

% 
% Dr. Emrah Onat (eonat87@yahoo.com)
% Dr. Adnan Orduyilmaz (orduyilmaz@gmail.com)

close all;
clear all;
clc

%% Parameters

f0  = 200e6; % Starting frequency of chirp (Hz)
N   = 32768; % Number of points to sample pulse
tau = 10e-6; % Pulse width (seconds)
B   = 20e6;  % Bandwidth of chirp (Hz)

noiselevel = 1; % Noise Level

dt = 2*tau/N;          % Setup time axis
fs = 1/dt;             % Sampling Frequency
t = (-tau:dt:tau-dt)'; % Time Interval


%% LFM
[f(:,1) phi_t(:,1) s(:,1)] = getlfm(f0,tau,B,t);
wtype = ["LFM"];    % Generate chirped waveform

%% Taylor 7 NLFM
[f(:,2) phi_t(:,2) s(:,2)] = gettws(7,f0,tau,B,t);
wtype = [wtype,"Taylor 7"];

%% Taylor 30 NLFM
[f(:,3) phi_t(:,3) s(:,3)] = gettws(30,f0,tau,B,t);
wtype = [wtype,"Taylor 30"];

%% Tangent NLFM
alfa = 2.5;
[f(:,4) phi_t(:,4) s(:,4)] = gettbw(alfa,f0,tau,B,t);
wtype = [wtype,"Tangent"];

%% Hiperbolic NLFM
[f(:,5) phi_t(:,5) s(:,5)] = gethfm(f0,tau,B,t);
wtype = [wtype,"Hyperbolic"];

% Create pulse
s(find(abs(t)>tau/2),:) = 0;
f(find(abs(t)>tau/2),:) = 0;     

% Figure
fplot1 = linspace(-fs/2,fs/2,length(t))';
figure
plot(fplot1*1e-6,abs(fft(s)))
legend(wtype)

% Noise Addition
noisefix = noiselevel*randn(size(s));
h  = flipud(s) + noisefix;
hx = flipud(s);