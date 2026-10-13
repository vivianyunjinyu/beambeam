% variables
c = 343; %speed of sound 343 m/s
N = 8; %num of drivers
d = 0.05; %space between drivers in m
f = 19600; %frequency in question in Hertz
freqs = 500:100:16900; %frequency sweep from 500 hz to 8k hz
pos = 0:d:d*(N-1); %position of each driver

lambda = c/f; %wavelength of the freq
f_max = c/(2*d); %maximum steerable freq 
ok = f < f_max; %check whether freq is steerable

%steering configurations
theta = 30; %degree the beam is towards
tau = pos * sind(theta) / c; %calculate the delay for each driver
phi = 0; %1 test spot
phis = -90:1:90; %sweep angles from -90 to 90
p_dB = zeros(size(phis)); %empty array to later hold resultant power
map_dB = zeros(numel(freqs), numel(phis)); %matrix of freqs x phis

%sweep for one freq -> p_dB stores the amplitude of angles we swept
for k = 1:numel(phis)
    phi = phis(k); %set the current angle to phi
    t = tau - pos * sind(phi)/c; %calculating the delay time to each driver (for test spots)
    phasor = exp(-1i*2*pi*f*t); %turning per driver delay time into phasor
    p = abs(sum(phasor)) / N; %calculate the power at the test spot
    p_dB(k) = 20*log10(p); %converting power to dB
end

%HUGE sweep frequency & angles
for i=1:numel(freqs)
    for j=1:numel(phis)
        t = tau - pos * sind(phis(j)) / c;
        phasor = exp(-1i * 2 * pi * freqs(i) * t);
        map_dB(i, j) = 20 * log10(abs(sum(phasor)) / N);
    end
end

p_dB = max(p_dB, -60); %limit the displayed dynamic range
plot(phis, p_dB, 'LineWidth', 1.5);
xline(theta); %where you're aiming at
xlabel('Angle (degrees)');
ylabel('Normalized amplitude (dB)');
grid on;

figure; %put it on another figure
map_dB = max(map_dB, -60);
imagesc(phis, freqs, map_dB); %heatmap
axis xy; %put lowest freq on bottom highest on top
xlabel('Angle (degrees)');
ylabel('Frequency (Hz)');
colorbar;
clim([-60 0]);




