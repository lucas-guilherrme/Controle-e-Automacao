% Autor: Lucas Guilherme

clear; close all; clc;

% ----------------------------------------------------
% Simulação de uma EDO de 2ª ordem (Método de Euler)
% Exemplo: Sistema Massa-Mola ou Circuito RLC
% ----------------------------------------------------

%% Definição dos parâmetros de simulação
wn = 10;            % Frequência natural (ex: sqrt(k/m))
zeta = 0.2;         % Fator de amortecimento (0.2 = subamortecido)
f_ext = 0;          % Força externa ou entrada constante

t_max = 5;          % Tempo máximo de simulação (segundos)
h = 1.0e-4;         % Passo de cálculo (integração)
npt = 1.0e5;        % Quantidade de pontos para o gráfico
hs = t_max/npt;     % Passo de amostragem para salvar os dados

if hs < h
    hs = h;
    npt = fix(t_max / hs);
end

% Condições iniciais 
y = 1;              % Posição inicial (ou Tensão no capacitor)
v = 0;              % Velocidade inicial (ou Corrente)
t_t = 0;            % Tempo cronológico

% Pré-alocação de memória para performance
Y_OUT = zeros(npt, 1);
V_OUT = zeros(npt, 1);
A_OUT = zeros(npt, 1);
T_VEC = zeros(npt, 1);

index = 1;
ts = 0;

%% Loop de Integração Numérica
while t_t <= t_max && index <= npt
    t_t = t_t + h;

    % Resolvendo a EDO de 2ª ordem: y'' + 2*zeta*wn*y' + wn^2*y = f_ext
    % Isolamos a aceleração (a = y''):
    a = f_ext - 2*zeta*wn*v - (wn^2)*y;
    
    % Método de Euler para atualizar os estados
    v = v + a * h;  % Atualiza velocidade (v_n+1 = v_n + a*h)
    y = y + v * h;  % Atualiza posição (y_n+1 = y_n + v*h)

    % Lógica de amostragem (salva os dados conforme hs)
    if t_t > ts
        Y_OUT(index) = y;
        V_OUT(index) = v;
        A_OUT(index) = a;
        T_VEC(index) = t_t;

        index = index + 1;
        ts = ts + hs;
    end
end

%% Mostrando os resultados - gráficos

figure(1);
subplot(2,1,1);
plot(T_VEC, Y_OUT, '-b', 'LineWidth', 1.5);
grid on;
title("Posição (ou Tensão no Capacitor)");
ylabel('Amplitude [y]');

subplot(2,1,2);
plot(T_VEC, V_OUT, '-r', 'LineWidth', 1.5);
grid on;
title("Velocidade (ou Corrente)");
xlabel('Tempo [s]');
ylabel('Amplitude [v]');

figure(2);
plot(Y_OUT, V_OUT, '-g'); % Espaço de Fase
grid on;
title("Espaço de Fase (v vs y)");
xlabel("Posição (y)");
ylabel("Velocidade (v)");