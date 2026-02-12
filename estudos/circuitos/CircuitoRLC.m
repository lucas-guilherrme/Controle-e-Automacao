% Autor: Lucas Guilherme

% ------------------------------------
% Simulção de um circuito RLC serie
% ------------------------------------

clear; close all; clc;

%% Definição dos parametros

t_max = 0.8; % Tempo máximo de simulação
npt = 1.0e6; % Numero de pontos
h = 1.0e-6;  % Tamanho do passo
hs = t_max/npt;

if hs < h
    hs = h;
    npt = fix(t_max/hs);
end

r_s = 10;  % R = 10 Ohms
l_s = 0.1;  % L = 50mH
c_s = 1.0e-3; % C = 1micF

v_in = 10;

% Condições iniciais
v_r = 0;
v_l = 0;
v_c = 0;
i_l = 0;
t_t = 0;

VC_OUT = zeros(npt, 1);
VL_OUT = zeros(npt, 1);
VR_OUT = zeros(npt, 1);
IL_OUT = zeros(npt, 1);
TEMPO_ = zeros(npt, 1);

%% Simulação do circuito

index = 1;
tem_s = 0;

while t_t < t_max && index <= npt
    t_t = t_t + h;
    % Resolucao da EDOs
    % v_in = v_r + v_c + v_l
    % v_in = r*i_l + v_c + l*di_l/dt
    % di_l/dt = v_in -[r*i_l + v_c]/[l]
    di_l_dt = (v_in - r_s*i_l - v_c)/l_s;

    % i_c = c*dv_c/dt
    % dv_c/dt = i_c/c
    % dv_c/dt = i_l/c
    dv_c_dt = (i_l/c_s);

    % i_l = i_l + di_l*dt
    % v_c = v_c + dv_c*dt
    i_l = i_l + di_l_dt*h;
    v_c = v_c + dv_c_dt*h;

    v_r = i_l*r_s;
    v_l = l_s*di_l_dt/h;

    if t_t > tem_s
        VC_OUT(index) = v_c;
        VL_OUT(index) = v_l;
        VR_OUT(index) = v_r;
        IL_OUT(index) = i_l;
        TEMPO_(index) = t_t;

        index = index + 1;
        tem_s = tem_s + hs;
    end
end

%% Mostrando os gráficos

figure(1);
plot(TEMPO_, VC_OUT, '-b');
grid on;
title("Tensão no capacitro");
xlabel('Tempo[s]');
ylabel('Tensão[V]');

figure(2);
plot(TEMPO_, VR_OUT, '-m');
grid on;
title("Tensão no resistro");
xlabel("Tempo[s]");
ylabel("Tensão[V]");

figure(3);
plot(TEMPO_, VL_OUT, '-g');
grid on;
title("Tensão no indutor");
xlabel("Tempo[s]");
ylabel("Tensão[V]");

figure(4);
plot(TEMPO_, IL_OUT, '-g');
grid on;
title("Corrente no indutor");
xlabel("Tempo[s]");
ylabel("Tensão[V]");