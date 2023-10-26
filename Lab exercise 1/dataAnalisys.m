n = 20; %%periods
m = 10000; %%dots per period
%%total of n*m dots

%%Similink simulation 

slx1 = 'notch_filter';
slx2 = 'rlc_notch_filter_differential_eq';
slx3 = 'rlc_notch_electrical';

%%For RLC
R = 1;
L = 1000*1e-3;
C = 1000*1e-6;

%%Filter data
w0 = 60;
wz = 60;
A = 1;
Q = 1;

%%frequency
%%TO run slx1
%%omega = [1: 10: 60, 60:10: 120];
%%TO run slx2 and slx3
omega = [1:5:1/sqrt(L*C), 1/sqrt(L*C):5:2.5/sqrt(L*C)]

Amp = zeros(1, length(omega));
phase = zeros(1, length(omega));

for i = 1 : 1 : length(omega)
    w = omega(i);
    deltaT = 2*pi/(w*m);
    duration = n*2*pi/w;

    sim(slx2);
    
    output = ans.yOut((n-3)*m: end);
    Amp(i) = max(output);
    %%We are looking fot the min of the function around the point (n-3)*m +
    %%1, cause we know that the input signal has a zero there and the
    %%output sholud also have a zero around that point in a range of -45 and + 45
    %%which is equal to from -m/4 to m/4
    points = ans.yOut((n-3)*m - m/4 + 1: (n-3)*m + m/4 + 1);
    
    min_index = find(abs(points) == min(abs(points)));
    if abs(Amp(i)) < 1e-4
        phase(i) = 0;
    else
        phase(i) = w * (m/2 - min_index) * deltaT * 180/pi - 90;
    end
end
figure
plot(omega, Amp);
xlabel("Frequency ($\frac{rad}{s}$)", "Interpreter", "latex");
ylabel("Amplitude", "Interpreter", "latex");
title("Amplitude vs Frequency", "Interpreter", "latex");
grid on;

figure
plot(omega, phase);
xlabel("Frequency ($\frac{rad}{s}$)", "Interpreter", "latex");
ylabel("Phase (°)", "Interpreter", "latex");
title("Phase vs Frequency", "Interpreter", "latex");
grid on;

figure
plot(phase, Amp);
xlabel("Phase (°)", "Interpreter", "latex"); 
ylabel("Amplitude", "Interpreter", "latex");
title("Amplitude vs Phase", "Interpreter", "latex");
grid on;

