# Autor: Lucas Guilerme

# --------------------------------------------
# Simulação da máquina CC sem nenhum controle
# --------------------------------------------

import matplotlib.pyplot as plt
import numpy as np

t_max = 6.0
h = 5.0e-5
h_ctrl = h
npt = int(1.0e6) # numeros de pontos 
h_s = t_max/npt  # passo de calculo 
if(h_s < h):
    h_s = h
    npt = int(t_max/h_s)
    
fonte_ideal = 1
font_pr_ord = 0 # fonte primeira ordem

# Parâmetros do motor
ra = 0.06
la = 0.0018
ke = 0.8
fm = 0.01
jm = 1.5
re = 0.01
le = 0.5

# Constante de tempo
Te = le/re # constante de tempo de excitação
Ta = la/ra # constante de tempo de armadura
Tm = jm/fm # constante de tempo mecânica

Tv = 0.005 # aproximação de Ta/100

fe_nom = 1 # fluxo nominal de excitação

# Parametros analiticos - Não utilizados nessa versão
sa = -1/Ta
sm = -1/Tm
k1 = ke*fe_nom/la
k2 = -ke*fe_nom/jm
ka = ke*fe_nom/(ke*ke*fe_nom*fe_nom + ra*fm)
km = ra/(ke*ke*fe_nom*fe_nom + ra*fm)
polo1 = (sa + sm + np.sqrt((sa-sm)*(sa-sm) + 4*k1*k2))/2
polo2 = (sa + sm - np.sqrt((sa-sm)*(sa-sm) + 4*k1*k2))/2
T1 = -1/polo1  # constante de tempo dominante
T2 = -1/polo2  # constante de tempo rápida

# Condições  de controle
ve_nom = fe_nom/Te # Tensao nominal
va_ref = 1
wm_ref = 1

# Condições iniciais 
t  = 0
va = 0
ve = 0.
ia = 0
ie = fe_nom/le
fe = 0
wm = 0
cm = 0

# vetores para armazenamento
Va_s = np.zeros(npt)
Ve_s = np.zeros(npt)
Cm_s = np.zeros(npt)
Ie_s = np.zeros(npt)
Fe_s = np.zeros(npt)
Ia_s = np.zeros(npt)
Wm_s = np.zeros(npt)
Ce_s = np.zeros(npt)
Ea_s = np.zeros(npt)
T_s  = np.zeros(npt)
Va_ref_s = np.zeros(npt)
Ia_ref_s = np.zeros(npt)
Wm_ref_s = np.zeros(npt)
Pa_s = np.zeros(npt)
Pe_s = np.zeros(npt)

# Contadores
s = 0
t_s = 0

while t <= t_max and s < npt:
    t = t + h

    # Fonte de alimentação
    # ======================
    ve = ve_nom
    va_ref = 1

    if(fonte_ideal == 1):
        va = va_ref
    if(font_pr_ord == 1):
        dev_va = (va_ref - va)/Tv
        va = va + dev_va*h

    # Conjugado mecânico
    # ====================
    if(t < 0.3*t_max):
        cm = 0
    elif( 0.3*t_max < t < 0.5*t_max):
        cm = 0.5
    else:
        cm = -1
    # Maquina CC
    # ======================
    
    # Modelo eletrico de excitação
    dev_ie = (ve - re*ie)/le
    ie = ie + dev_ie*h
    fe = le*ie

    # Modelo eletrico de armadura
    ea = ke*fe*wm
    dev_ia = (va - ra*ia - ea)/la
    ia = ia + dev_ia*h

    ce = ke*fe*ia # Conjugado eletromagnético

    # Modelo mecânico
    dev_wm = (ce - cm - fm*wm)/jm
    wm = wm + dev_wm*h

    # Potencia da maquina 
    pe = ve*ie

    # Visualização - Amostragem
    if( t >= t_s):
        Va_s[s] = va
        Ve_s[s] = ve
        Cm_s[s] = cm
        Ie_s[s] = ie
        Fe_s[s] = fe
        Ia_s[s] = ia
        Wm_s[s] = wm
        Ce_s[s] = ce
        Ea_s[s] = ea
        Va_ref_s[s] = va_ref
        Wm_ref_s[s] = wm_ref
        Pe_s[s] = pe
        T_s[s] = t

        s+=1
        t_s += h_s

plt.figure(1, figsize=(15, 5))
plt.plot(T_s, Va_s, label='Tensão de armadura')
plt.plot(T_s, Va_ref_s, label='Referência')
plt.grid(True)
plt.title('Tensões de armadura atual e de referência')
plt.xlabel('t[seg]')
plt.legend()
plt.show()

plt.figure(2, figsize=(15, 5))
plt.plot(T_s, Cm_s)
plt.grid(True)
plt.title('Conjugado mecânico')
plt.xlabel('t[seg]')
plt.show()

plt.figure(3, figsize=(15, 5))
plt.plot(T_s, Ia_s)
plt.grid(True)
plt.title('Correntes de armadura')
plt.xlabel('t[seg]')
plt.show()

plt.figure(4, figsize=(15, 5))
plt.plot(T_s, Wm_s)
plt.grid(True)
plt.title('Velocidades mecânica')
plt.xlabel('t[seg]')
plt.show()

plt.figure(5, figsize=(15, 5))
plt.plot(T_s, Fe_s)
plt.grid(True)
plt.title('Fluxo de excitação')
plt.xlabel('t[seg]')
plt.show()

plt.figure(6, figsize=(15, 5))
plt.plot(T_s, Va_s, label='Tensão de armadura')
plt.plot(T_s, Ea_s, label='Força eletromotriz')
plt.grid(True)
plt.title('Tensão de armadura, Força eletromotriz')
plt.xlabel('t[seg]')
plt.legend()
plt.show()

plt.figure(7, figsize=(15, 5))
plt.plot(T_s, Ve_s, label='Tensão de excitação')
plt.plot(T_s, Fe_s, label='Fluxo de excitação')
plt.grid(True)
plt.title('Tensão de excitação, Fluxo de excitação')
plt.xlabel('t[seg]')
plt.legend()
plt.show()

plt.figure(8, figsize=(15, 5))
plt.plot(T_s, Va_s, label='Tensão de armadura')
plt.plot(T_s, Ia_s, label='Corrente de armadura')
plt.grid(True)
plt.title('Tensão de armadura, Corrente de armadura')
plt.xlabel('t[seg]')
plt.legend()
plt.show()

plt.figure(9, figsize=(15, 5))
plt.plot(T_s, Ce_s, label='Conjugado eletromagnético')
plt.plot(T_s, Wm_s, label='Velocidade mecânica')
plt.grid(True)
plt.title('Conjugado Eletromagnético, Velocidade mecânica')
plt.xlabel('t[seg]')
plt.legend()
plt.show()

plt.figure(10, figsize=(15, 5))
plt.plot(T_s, Cm_s, label='Conjugado mecânico')
plt.plot(T_s, Ce_s, label='Conjugado eletromagnético')
plt.grid(True)
plt.title('Conjugado mecânico, Conjugado Eletromagnético')
plt.xlabel('t[seg]')
plt.legend()
plt.show()

plt.figure(11, figsize=(15, 5))
plt.plot(T_s, Pe_s)
plt.grid(True)
plt.title('Potência de excitação')
plt.xlabel('t[seg]')
plt.show()