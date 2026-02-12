% Autor: Lucas Guilherme

clear; close all; clc;

% ------------------------------------
% Simulção de um circuito RC serie
% ------------------------------------

%% Definição dos paramentros de simulação
r = 100;    % Resistor de 100 Ohms
c = 1.0e-6; % capacitor de 1micro F
tal = c*r;
v_in = 10;

t_max = 5*tal; % Tempo máximo de simulação
h = 1.0e-6;    % Passo de calculo
npt = 1.0e6;   % Quantidade de pontos
hs = t_max/npt;

if hs < h
    hs = h;
    npt = fix(t_max / hs);
end

% Condições iniciais 
v_c = 0;
i_r = 0;
i_c = 0;
t_t = 0;

VA__IN = zeros(npt, 1);
VC_OUT = zeros(npt, 1);
IC_OUT = zeros(npt, 1);
VR_OUT = zeros(npt, 1);
V_TEMP = zeros(npt, 1);

index = 1;
ts = 0;

while t_t <= t_max && index <= npt
    t_t = t_t + h;

    % Resolvendo a EDO
    dv_c = (1/tal)*(v_in - v_c);
    v_c = v_c + dv_c*h;

    i_c = c*dv_c/h;
    v_r = i_c*r;

    if t_t > 1.0e-4
        v_in = -400;
        i_c = i_c + 100;
    end

    if t_t > ts
        VA__IN(index) = v_in;
        VC_OUT(index) = v_c;
        VR_OUT(index) = v_r;
        IC_OUT(index) = i_c;
        V_TEMP(index) = t_t;

        index = index + 1;
        ts = ts + hs;
    end
end

%% Mostrando os resultados - graficos

figure(1);
plot(V_TEMP, IC_OUT, '-b');
grid on;
title("Corrente no circuito");
xlabel('Tempo[s]');
ylabel('Corrente[A]');

figure(2);
plot(V_TEMP, VC_OUT, '-m', V_TEMP, VA__IN, '--r');
grid on;
title("Tensão no capacitor e tensao na fonte");
xlabel("Tempo[s]");
ylabel("Tensão[V]");

figure(3);
plot(V_TEMP, VR_OUT, '-g');
grid on;
title("Tensão no resistor");
xlabel("Tempo[s]");
ylabel("Tensão[V]");
legend("Tensão em R", "Tensão V_in");
