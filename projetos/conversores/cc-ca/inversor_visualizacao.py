# Autor: Lucas Guilherme

import numpy as np
import matplotlib.pyplot as plt

def simular_inversor_rl(v_cc, r, l, f, t_max, h):
    """Calcula a física do sistema ponto a ponto."""
    tal = l/r
    t_peri = 1/f
    qtd_pts = int(t_max/h)
    
    # Valores de regime permanente para Imax/Imin
    t_f_2_tal = t_peri/(2*tal)
    i_max_ss = (v_cc/r)*((1 - np.exp(-t_f_2_tal))/(1 + np.exp(-t_f_2_tal)))
    i_min_ss = -i_max_ss
    
    t_arr, v_arr, i_arr = np.zeros(qtd_pts), np.zeros(qtd_pts), np.zeros(qtd_pts)
    t, cont = 0.0, 0.0
    
    for idx in range(qtd_pts):
        if cont <= (t_peri/2):
            vo = v_cc
            # Solução analítica para o semiciclo positivo
            io = v_cc/r + (i_min_ss - v_cc/r) * np.exp(-cont/tal)
        else:
            vo = -v_cc
            # Solução analítica para o semiciclo negativo
            io = -v_cc/r + (i_max_ss + v_cc/r) * np.exp(-(cont - t_peri/2)/tal)
            
        t_arr[idx], v_arr[idx], i_arr[idx] = t, vo, io
        t += h
        cont += h
        if cont >= t_peri: cont = 0
            
    return t_arr, v_arr, i_arr

def plotar_conducao(t, v, i):
    """Cria a visualização dos componentes ativos."""
    # Lógica de condução (Booleanas)
    q1_q2 = (v > 0) & (i > 0)
    d1_d2 = (v > 0) & (i < 0)
    q3_q4 = (v < 0) & (i < 0)
    d3_d4 = (v < 0) & (i > 0)

    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 8), sharex=True)

    # Gráfico de Corrente e Tensão
    ax1.plot(t, i, 'b', label='Corrente $i_o$ [A]')
    ax1.step(t, v/10, 'm', where='post', label='Tensão $v_o/10$ [V]') # Escala reduzida para ver melhor
    ax1.grid(True, alpha=0.6)
    ax1.legend()
    ax1.set_title("Dinâmica do Inversor RL")

    # Gráfico de Condução (Barras Horizontais)
    ax2.fill_between(t, 0, 1, where=q1_q2, color='green', alpha=0.8, label='$Q_1$, $Q_2$')
    ax2.fill_between(t, 0, 1, where=d1_d2, color='red', alpha=0.5, label='$D_1$, $D_2$')
    ax2.fill_between(t, 1.1, 2.1, where=q3_q4, color='gray', alpha=0.8, label='$Q_3$, $Q_4$')
    ax2.fill_between(t, 1.1, 2.1, where=d3_d4, color='m', alpha=0.5, label='$D_3$, $D_4$')

    ax2.set_yticks([0.5, 1.6])
    ax2.set_yticklabels(['Braço A', 'Braço B'])
    ax2.set_xlabel("Tempo [s]")
    ax2.set_title("Componentes em Condução")
    ax2.legend(loc='upper right', fontsize='small')
    ax2.grid(True, alpha=0.3)
    
    plt.tight_layout()
    plt.show()

# --- EXECUÇÃO ---
parametros = {'v_cc': 100, 'r': 10, 'l': 0.025, 'f': 60, 't_max': 0.05, 'h': 1e-5}
t, v, i = simular_inversor_rl(**parametros)
plotar_conducao(t, v, i)