% Autor: Lucas Guilherme

%--------------------------------------------------------
% Simulação de um circuito RL serie
%--------------------------------------------------------

clear; close all; clc;

%% Definição do tempo de simulação
r = 200;
l = 1.0e-1;
tal = l/r;

t_max = 5*tal;
h = 1.0e-6;
npt = 1.0e6;
hs = t_max/npt;

if hs < h
    hs = h;
    npt = fix(t_max / hs);
end

%% Definindo os parametros da simulação
v_in = 20;  % Tensão da fonte de 10 V

% Condições iniciais 
v_r = 0; % Tensao no resistor é nula
i_l = 0; % Corrente no indutor é nula
v_l = 0;
t_t = 0;

% Definição dos vetores para plotar os graficos
VA__IN = zeros(npt, 1);
VL_OUT = zeros(npt, 1);
VR_OUT = zeros(npt, 1);
IL_OUT = zeros(npt, 1);
V_TEMP = zeros(npt, 1);

index = 1;
ts = 0;

while t_t <= t_max && index <= npt
    t_t = t_t + h;

    % Resolução da EDO
    % ------------------------------------
    di_l = (1/l)*(v_in - r*i_l);
    i_l = i_l + di_l*h;

    % Tensao no indutor/resistor
    % ------------------------------------
    v_l = l*di_l/h;
    v_r = r*i_l;

    if t_t > 5.0e-4
        v_in = -10;
    end

    if t_t > ts
        IL_OUT(index) = i_l;
        VA__IN(index) = v_in;
        VL_OUT(index) = v_l;
        VR_OUT(index) = v_r;
        V_TEMP(index) = t_t*1.0e4;

        index = index + 1;
        ts = ts + hs;
    end
end

%% Mostrando os resultados - graficos

figure(1);
plot(V_TEMP, IL_OUT, '-b');
grid on;
title("Corrente no circuito");
xlabel('Tempo[s]');
ylabel('Corrente[A]');

figure(2);
plot(V_TEMP, VL_OUT, '-m');
grid on;
title("Tensão no indutor");
xlabel("Tempo[s]");
ylabel("Tensão[V]");

figure(3);
plot(V_TEMP, VR_OUT, '-g', V_TEMP, VA__IN, '--r');
grid on;
title("Tensão no resistor");
xlabel("Tempo[s]");
ylabel("Tensão[V]");
legend("Tensão em R", "Tensão V_in");
