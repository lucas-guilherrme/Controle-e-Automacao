/**
 * Simulação de um circuito RL série
*/

#include <stdio.h>

int main(void) {
    /* Parâmetros do circuito RL */
    double r = 200.0;          /* Resistência [Ohms] */
    double l = 1.0e-1;         /* Indutância [Henry] */
    double tal = l / r;        /* Constante de tempo tau = L/R */
    double v_in = 20.0;        /* Tensão inicial da fonte [V] */

    double t_max = 5.0 * tal;  /* Tempo total de simulação = 5*tau */
    double h = 1.0e-6;         /* Passo de integração [s] */

    /* Configuração do passo de saída */
    long npt = 1000000;                /* Número máximo de pontos */
    double hs = t_max / npt;           /* Passo de armazenamento calculado */
    if (hs < h) {
        hs = h;                       /* Garante hs >= h */
        npt = (long)(t_max / hs);     /* Recalcula npt com o novo hs */
    }

    /* Variáveis de estado e grandezas elétricas */
    double v_r = 0.0;   /* Tensão no resistor */
    double i_l = 0.0;   /* Corrente no indutor */
    double v_l = 0.0;   /* Tensão no indutor */
    double t_t = 0.0;   /* Tempo atual da simulação */
    double ts = 0.0;    /* Próximo instante de armazenamento */
    long index = 0;     /* Contador de pontos armazenados */

    /* Cabeçalho do arquivo CSV */
    printf("tempo_s,v_in_V,i_l_A,v_l_V,v_r_V\n");

    /* Loop principal – integração no tempo */
    while (t_t <= t_max && index < npt) {
        t_t += h;   /* Avança o tempo */

        /* di/dt = (v_in - R*i)/L */
        double di_l = (1.0 / l) * (v_in - r * i_l);
        i_l += di_l * h;  

        /*v_l = L * (di/dt)*/
        v_l = l * di_l / h; 
        v_r = r * i_l;

        if (t_t > 5.0e-4) {
            v_in = -10.0;
        }

        /* Armazenamento dos resultados com passo hs */
        if (t_t >= ts) {
            printf("%.9e,%.9e,%.9e,%.9e,%.9e\n",
                   t_t,       /* tempo real [s] */
                   v_in,      /* tensão da fonte */
                   i_l,       /* corrente no indutor */
                   v_l,       /* tensão no indutor */
                   v_r);      /* tensão no resistor */
            ts += hs;
            index++;
        }
    }

    return 0;
}