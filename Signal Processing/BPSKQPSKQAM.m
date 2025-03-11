clc;  
clear;  
close all; 
% Parameters 
SNR_dB = 0:2:20;  
numSymbols = 1e5;  
% Modulation Order 
M_BPSK = 2; % BPSK 
M_QPSK = 4; % QPSK 
M_QAM = 16; % 16-QAM 
% Generate Random Bits 
bits_BPSK = randi([0 1], numSymbols, 1); 
bits_QPSK = randi([0 1], numSymbols * 2, 1); 
bits_QAM = randi([0 1], numSymbols * 4, 1); 
% Modulation 
bpskMod = pskmod(bits_BPSK, M_BPSK); 
qpskMod = pskmod(bi2de(reshape(bits_QPSK, [], 2)), M_QPSK, pi/4); 
qamMod = qammod(bi2de(reshape(bits_QAM, [], 4)), M_QAM, 
'UnitAveragePower', true); 
% Define Fading Channels 
rayleighChan = comm.RayleighChannel('SampleRate', 1e6); 
ricianChan = comm.RicianChannel('SampleRate', 1e6, 'KFactor', 10); 
% Pass Signals through Fading Channels 
bpskRay = rayleighChan(bpskMod); 
qpskRay = rayleighChan(qpskMod); 
qamRay = rayleighChan(qamMod); 
bpskRic = ricianChan(bpskMod); 
qpskRic = ricianChan(qpskMod); 
qamRic = ricianChan(qamMod); 
% BER Storage Arrays 
bpskBER_Rayleigh = zeros(size(SNR_dB)); 
qpskBER_Rayleigh = zeros(size(SNR_dB)); 
qamBER_Rayleigh = zeros(size(SNR_dB)); 
bpskBER_Rician = zeros(size(SNR_dB)); 
qpskBER_Rician = zeros(size(SNR_dB)); 
qamBER_Rician = zeros(size(SNR_dB)); 
% Loop over SNR values 
for i = 1:length(SNR_dB) 
% Add AWGN for Rayleigh Fading 
bpskRay_AWGN = awgn(bpskRay, SNR_dB(i), 'measured'); 
qpskRay_AWGN = awgn(qpskRay, SNR_dB(i), 'measured'); 
qamRay_AWGN = awgn(qamRay, SNR_dB(i), 'measured'); 
% Add AWGN for Rician Fading 
bpskRic_AWGN = awgn(bpskRic, SNR_dB(i), 'measured'); 
qpskRic_AWGN = awgn(qpskRic, SNR_dB(i), 'measured'); 
qamRic_AWGN = awgn(qamRic, SNR_dB(i), 'measured'); 
% Demodulation for Rayleigh 
bpskDemodRay = pskdemod(bpskRay_AWGN, M_BPSK); 
qpskDemodRay = pskdemod(qpskRay_AWGN, M_QPSK, pi/4); 
qamDemodRay = qamdemod(qamRay_AWGN, M_QAM, 
'UnitAveragePower', true); 
% Demodulation for Rician 
bpskDemodRic = pskdemod(bpskRic_AWGN, M_BPSK); 
qpskDemodRic = pskdemod(qpskRic_AWGN, M_QPSK, pi/4); 
qamDemodRic = qamdemod(qamRic_AWGN, M_QAM, 
'UnitAveragePower', true); 
% BER Calculation for Rayleigh 
bpskBER_Rayleigh(i) = sum(bits_BPSK ~= bpskDemodRay) / numSymbols; 
qpskBER_Rayleigh(i) = sum(bits_QPSK(1:2:end) ~= qpskDemodRay) / 
numSymbols; 
qamBER_Rayleigh(i) = sum(bits_QAM(1:4:end) ~= qamDemodRay) / 
numSymbols; 
% BER Calculation for Rician 
bpskBER_Rician(i) = sum(bits_BPSK ~= bpskDemodRic) / numSymbols; 
qpskBER_Rician(i) = sum(bits_QPSK(1:2:end) ~= qpskDemodRic) / 
numSymbols; 
qamBER_Rician(i) = sum(bits_QAM(1:4:end) ~= qamDemodRic) / 
numSymbols; 
end 
% Plot BER for Rayleigh Fading 
figure; 
semilogy(SNR_dB, bpskBER_Rayleigh, 'ro-', 'LineWidth', 2); 
hold on; 
semilogy(SNR_dB, qpskBER_Rayleigh, 'bs-', 'LineWidth', 2); 
semilogy(SNR_dB, qamBER_Rayleigh, 'g*-', 'LineWidth', 2); 
grid on; 
xlabel('SNR (dB)'); 
ylabel('Bit Error Rate (BER)'); 
title('BER Performance in Rayleigh Fading'); 
legend('BPSK - Rayleigh', 'QPSK - Rayleigh', '16-QAM - Rayleigh'); 
% Plot BER for Rician Fading 
figure; 
semilogy(SNR_dB, bpskBER_Rician, 'ro-', 'LineWidth', 2); 
hold on; 
semilogy(SNR_dB, qpskBER_Rician, 'bs-', 'LineWidth', 2); 
semilogy(SNR_dB, qamBER_Rician, 'g*-', 'LineWidth', 2); 
grid on; 
xlabel('SNR (dB)'); 
ylabel('Bit Error Rate (BER)'); 
title('BER Performance in Rician Fading'); 
legend('BPSK - Rician', 'QPSK - Rician', '16-QAM - Rician'); 
