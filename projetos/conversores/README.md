<div align="center">
  
# **Conversores de Potência**

<div/>
  
---

<div align="justify">

## 📌 Visão Geral
Conversores de potência são circuitos eletrônicos que processam e controlam o fluxo de 
energia elétrica, modificando a forma de onda de entrada para uma saída específica. 

### Tipos de Conversores Implementados
* **CC-CA (Inversores):** Converte corrente contínua em alternada (ex: Ponte Completa em H).
* **CC-CC (Choppers):** Ajusta níveis de tensão contínua (ex: Buck, Boost).

---

## 🛠️ O Modelo Matemático
As simulações utilizam o método de integração ponto a ponto para modelar a dinâmica da carga RL. A relação fundamental é baseada na Lei de Kirchhoff para tensões:

$$V_{out}(t) = R \cdot i_o(t) + L \frac{di_o(t)}{dt}$$

Onde:
* **$V_{out}$:** Tensão de saída do conversor (onda quadrada).
* **$i_o$:** Corrente na carga (resposta exponencial).
* **$\tau = L/R$:** Constante de tempo da carga.


---

## 📂 Estrutura do Código
O projeto está organizado de forma modular para facilitar a manutenção e o aprendizado:

1.  **Parâmetros de Entrada:** Definição de $V_{cc}$, Frequência ($f$) e componentes ($R, L$).
2.  **Núcleo de Simulação:** Loop `while` para processamento temporal ponto a ponto.
3.  **Lógica de Chaveamento:** Identificação em tempo real de quais componentes estão em condução:
    * **Transistores (Q):** Condução ativa para transferência de potência.
    * **Diodos (D):** Condução para circulação de corrente indutiva (roda-livre).
4.  **Visualização:** Geração de gráficos de tensão, corrente e estados de condução.

---

## 🚀 Como Executar
Para rodar as simulações em Python, certifique-se de ter as bibliotecas necessárias instaladas:

```bash
pip install numpy matplotlib

```
<div/>
