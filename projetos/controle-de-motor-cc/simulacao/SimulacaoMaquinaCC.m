% Autor: Lucas Guilerme
% --------------------------------------------
% Simulação da máquina CC sem nenhum controle
% --------------------------------------------

clear; close all; clc;

t_max = 6.0;
h = 5.0e-5;
h_ctrl = h;
npt = 1e6;               % número de pontos
h_s = t_max / npt;       % passo de cálculo
if h_s < h
    h_s = h;
    npt = fix(t_max / h_s);
end

fonte_ideal = 1;
font_pr_ord = 0;         % fonte primeira ordem

% Parâmetros do motor
ra = 0.06;
la = 0.0018;
ke = 0.8;
fm = 0.01;
jm = 1.5;
re = 0.01;
le = 0.5;

% Constantes de tempo
Te = le / re;            % constante de tempo de excitação
Ta = la / ra;            % constante de tempo de armadura
Tm = jm / fm;            % constante de tempo mecânica

Tv = 0.005;              % aproximação de Ta/100

fe_nom = 1;              % fluxo nominal de excitação

% Parâmetros analíticos - Não utilizados nessa versão
sa = -1/Ta;
sm = -1/Tm;
k1 = ke*fe_nom/la;
k2 = -ke*fe_nom/jm;
ka = ke*fe_nom/(ke*ke*fe_nom*fe_nom + ra*fm);
km = ra/(ke*ke*fe_nom*fe_nom + ra*fm);
polo1 = (sa + sm + sqrt((sa-sm)*(sa-sm) + 4*k1*k2))/2;
polo2 = (sa + sm - sqrt((sa-sm)*(sa-sm) + 4*k1*k2))/2;
T1 = -1/polo1;           % constante de tempo dominante
T2 = -1/polo2;           % constante de tempo rápida

% Condições de controle
ve_nom = fe_nom/Te;      % tensão nominal
va_ref = 1;
wm_ref = 1;

% Condições iniciais
t = 0;
va = 0;
ve = 0;
ia = 0;
ie = fe_nom/le;
fe = 0;
wm = 0;
cm = 0;

% Vetores para armazenamento
Va_s = zeros(npt, 1);
Ve_s = zeros(npt, 1);
Cm_s = zeros(npt, 1);
Ie_s = zeros(npt, 1);
Fe_s = zeros(npt, 1);
Ia_s = zeros(npt, 1);
Wm_s = zeros(npt, 1);
Ce_s = zeros(npt, 1);
Ea_s = zeros(npt, 1);
T_s = zeros(npt, 1);
Va_ref_s = zeros(npt, 1);
Ia_ref_s = zeros(npt, 1);
Wm_ref_s = zeros(npt, 1);
Pa_s = zeros(npt, 1);
Pe_s = zeros(npt, 1);

% Contadores
s = 1;                   % índice em MATLAB começa em 1
t_s = 0;

while t <= t_max && s <= npt
    t = t + h;

    % Fonte de alimentação
    % ======================
    ve = ve_nom;
    va_ref = 1;

    if fonte_ideal == 1
        va = va_ref;
    end
    if font_pr_ord == 1
        dev_va = (va_ref - va)/Tv;
        va = va + dev_va*h;
    end

    % Conjugado mecânico
    % ====================
    if t < 0.3*t_max
        cm = 0;
    elseif t > 0.3*t_max && t < 0.5*t_max
        cm = 0.5;
    else
        cm = -1;
    end

    % Máquina CC
    % ======================
    
    % Modelo elétrico de excitação
    dev_ie = (ve - re*ie)/le;
    ie = ie + dev_ie*h;
    fe = le*ie;

    % Modelo elétrico de armadura
    ea = ke*fe*wm;
    dev_ia = (va - ra*ia - ea)/la;
    ia = ia + dev_ia*h;

    ce = ke*fe*ia;       % conjugado eletromagnético

    % Modelo mecânico
    dev_wm = (ce - cm - fm*wm)/jm;
    wm = wm + dev_wm*h;

    % Potência da máquina
    pe = ve*ie;

    % Visualização - Amostragem
    if t >= t_s
        Va_s(s) = va;
        Ve_s(s) = ve;
        Cm_s(s) = cm;
        Ie_s(s) = ie;
        Fe_s(s) = fe;
        Ia_s(s) = ia;
        Wm_s(s) = wm;
        Ce_s(s) = ce;
        Ea_s(s) = ea;
        Va_ref_s(s) = va_ref;
        Wm_ref_s(s) = wm_ref;
        Pe_s(s) = pe;
        T_s(s) = t;

        s = s + 1;
        t_s = t_s + h_s;
    end
end

% Remove valores não preenchidos caso o laço termine antes de npt
if s <= npt
    Va_s = Va_s(1:s-1);
    Ve_s = Ve_s(1:s-1);
    Cm_s = Cm_s(1:s-1);
    Ie_s = Ie_s(1:s-1);
    Fe_s = Fe_s(1:s-1);
    Ia_s = Ia_s(1:s-1);
    Wm_s = Wm_s(1:s-1);
    Ce_s = Ce_s(1:s-1);
    Ea_s = Ea_s(1:s-1);
    Va_ref_s = Va_ref_s(1:s-1);
    Wm_ref_s = Wm_ref_s(1:s-1);
    Pe_s = Pe_s(1:s-1);
    T_s = T_s(1:s-1);
end

% Gráficos
figure(1);
plot(T_s, Va_s, 'b', T_s, Va_ref_s, 'r');
grid on;
title('Tensões de armadura atual e de referência');
xlabel('t[seg]');
legend('Tensão de armadura', 'Referência');

figure(2);
plot(T_s, Cm_s);
grid on;
title('Conjugado mecânico');
xlabel('t[seg]');

figure(3);
plot(T_s, Ia_s);
grid on;
title('Correntes de armadura');
xlabel('t[seg]');

figure(4);
plot(T_s, Wm_s);
grid on;
title('Velocidades mecânica');
xlabel('t[seg]');

figure(5);
plot(T_s, Fe_s);
grid on;
title('Fluxo de excitação');
xlabel('t[seg]');

figure(6);
plot(T_s, Va_s, 'b', T_s, Ea_s, 'r');
grid on;
title('Tensão de armadura, Força eletromotriz');
xlabel('t[seg]');
legend('Tensão de armadura', 'Força eletromotriz');

figure(7);
plot(T_s, Ve_s, 'b', T_s, Fe_s, 'r');
grid on;
title('Tensão de excitação, Fluxo de excitação');
xlabel('t[seg]');
legend('Tensão de excitação', 'Fluxo de excitação');

figure(8);
plot(T_s, Va_s, 'b', T_s, Ia_s, 'r');
grid on;
title('Tensão de armadura, Corrente de armadura');
xlabel('t[seg]');
legend('Tensão de armadura', 'Corrente de armadura');

figure(9);
plot(T_s, Ce_s, 'b', T_s, Wm_s, 'r');
grid on;
title('Conjugado Eletromagnético, Velocidade mecânica');
xlabel('t[seg]');
legend('Conjugado eletromagnético', 'Velocidade mecânica');

figure(10);
plot(T_s, Cm_s, 'b', T_s, Ce_s, 'r');
grid on;
title('Conjugado mecânico, Conjugado Eletromagnético');
xlabel('t[seg]');
legend('Conjugado mecânico', 'Conjugado eletromagnético');

figure(11);
plot(T_s, Pe_s);
grid on;
title('Potência de excitação');
xlabel('t[seg]');