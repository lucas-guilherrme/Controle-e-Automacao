# Autor: Lucas Guilherme

import matplotlib.pyplot as plt
import numpy as np

r_c = 10        # [Homs]
l_c = 0.025     # [H]
v_cc = 100      # [V]
f_f = 60        # [Hz]
tal = l_c/r_c   # Constante de tempo da carga
t_f = 1/f_f     # [s]

# Definindo os valores 
t_max = 4*t_f     # Tempo de simulação
t_pas = 1.0e-6
qtd_p = int(t_max/t_pas)

# calculando a corrente minima e maxima
t_f_2_tal = t_f/(2*tal)
I_max = (v_cc/r_c)*((1 - np.exp(-t_f_2_tal))/((1 + np.exp(-t_f_2_tal))))
I_min = -I_max

# Condições iniciais
t_s = 0
cont = 0
index = 0

onda_quadrada = np.zeros(qtd_p)
tempo_segundo = np.zeros(qtd_p)
corrente_said = np.zeros(qtd_p)
corrente_ch12 = np.zeros(qtd_p)
corrente_ch34 = np.zeros(qtd_p)
corren_na_fon = np.zeros(qtd_p)

while index <= qtd_p:
    if(cont <= (t_f/2)):
        i_o = v_cc/r_c +(I_min - v_cc/r_c)*np.exp(-cont/tal)
        i_c_12 = i_o
        i_c_34 = 0
        out = v_cc
    else:
        i_o = -v_cc/r_c +(I_max + v_cc/r_c)*np.exp(-((cont - t_f/2)/tal))
        i_c_12 = 0
        i_c_34 = -i_o
        out = -v_cc

    i_font = i_c_12 + i_c_34
    t_s += t_pas
    cont += t_pas

    onda_quadrada[index - 1] = out
    tempo_segundo[index - 1] = t_s
    corrente_said[index - 1] = i_o
    corrente_ch12[index - 1] = i_c_12
    corrente_ch34[index - 1] = i_c_34
    corren_na_fon[index - 1] = i_font

    if(cont > t_f):
        cont = 0
    
    index +=1

plt.figure(figsize=(10, 6))

plt.subplot(2, 1, 1)
plt.title("Tensão de polo e corrente na carga")
plt.plot(tempo_segundo, onda_quadrada, label="tensão de polo")
plt.grid(True, 'both', color='m', alpha=0.2)
plt.legend()
plt.subplot(2, 1, 2)
plt.plot(tempo_segundo, corrente_said, '-r', label='corrente na carga')
plt.grid(True, 'both', color='m', alpha=0.2)
plt.xlabel('Tempo[s]')
plt.legend()
plt.show()

plt.subplot(3, 1, 1)
plt.title("Corrente na fonte e nas chaves")
plt.plot(tempo_segundo, corren_na_fon, label='corrente na fonte')
plt.axhline(0, color='gray', alpha=0.2)
plt.legend()
plt.subplot(3, 1, 2)
plt.plot(tempo_segundo, corrente_ch12, '-r', label='corrente na chave 12')
plt.axhline(0, color='gray', alpha=0.2)
plt.legend()
plt.subplot(3, 1, 3)
plt.plot(tempo_segundo, corrente_ch34, '-g', label='corrente na chave 34')
plt.axhline(0, color='gray', alpha=0.2)
plt.legend()

plt.tight_layout()
plt.show()