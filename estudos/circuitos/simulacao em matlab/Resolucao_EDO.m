% Autor: Lucas Guilherme

t_max = 3.0;
h = 1.0e-6;
qtd_pnt = fix(t_max/h);

%% Resolução de EDOs
% EDO de primeira ordem
% y' + 4y = 10
% y(0) = 2

% Condicao inicial
Y_OUT = zeros(qtd_pnt, 1);
T_OUT = zeros(qtd_pnt, 1);
IN_OU = zeros(qtd_pnt, 1);

%% Definindo a entrada senoidal
amp = 10;
fre = 1;
fas = 0;

%% Para uma entrada impulsiva
amp_imp = 500;
tem_imp = 2.0;

%% Para uma entrada ao degrau
amp_deg = 10.0;
temp_in = 1.0;
temp_ou = 2.0;

y = 2;
t = 0;
i = 1;
while t <= t_max && i <= qtd_pnt
    t = t + h;

    % Para um entrada senoidal
    % in = amp*t(2*pi*fre*t + fas); 

    % Para uma entrada de um impulso
    %if (t >= tem_imp) && (t < tem_imp+h)
    %    in = amp_imp;
    %else
    %    in = 0;
    %end

    % Para a entrada: uma porta
    if(t >= temp_in) && (t < temp_ou)
        in = amp_deg;
    else
        in = 0;
    end


    d_y = (in - 4*y)*h;
    y = y + d_y;

    Y_OUT(i) = y;
    T_OUT(i) = t;
    IN_OU(i) = in;

    i = i + 1;
end

%% Mostrar o resultado

figure(1);
plot(T_OUT, Y_OUT);
grid on;
title("Resposta do sistema");
xlabel("Tempo");
ylabel("Amplitude");
legend("saida");

figure(2);
plot(T_OUT, IN_OU);
grid on;
title("Entrada - Porta unitária");
xlabel("Tempo");
ylabel("Amplitude");
legend("in");
