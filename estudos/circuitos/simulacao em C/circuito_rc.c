/**
 * Simulação de um circuito RC série
*/

#include <stdio.h>

int main(void) {
    /* Parâmetros do circuito */
    double r = 100.0;          /* Resistência [Ohms]   */
    double c = 1.0e-6;         /* Capacitância [Farad] */
    double tal = c * r;        /* Constante de tempo tau */

    double v_in = 10.0;        /* Tensão inicial da fonte [V] */
    double t_max = 5.0 * tal;  /* Tempo total de simulação */
    double h = 1.0e-6;         /* Passo de integração [s] */

    /* Configuração da taxa de armazenamento */
    long npt = 1000000;                /* Número máximo de pontos inicial */
    double hs = t_max / npt;           /* Passo de saída calculado */
    if (hs < h) {
        hs = h;                       /* Garante hs >= h */
        npt = (long)(t_max / hs);     /* Recalcula npt com o novo hs */
    }

    /* Variáveis de estado e correntes */
    double v_c = 0.0;   /* Tensão no capacitor */
    double i_r = 0.0;   /* Corrente no resistor (não utilizada diretamente) */
    double i_c = 0.0;   /* Corrente no capacitor */
    double t_t = 0.0;   /* Tempo atual da simulação */
    double ts = 0.0;    /* Próximo instante de armazenamento */
    long index = 0;     /* Contador de pontos armazenados */

    /* Cabeçalho da saída (formato CSV) */
    printf("tempo_s,v_in_V,v_c_V,v_r_V,i_c_A\n");

    /* Loop principal – integração no tempo */
    while (t_t <= t_max && index < npt) {
        t_t += h;   /* Avança o tempo */

        /* dv_c/dt = (v_in - v_c)/tau */
        double dv_c = (1.0 / tal) * (v_in - v_c);
        v_c += dv_c * h;  

        /* i_c = c * dv_c / h) */
        i_c = c * dv_c / h;     

        if (t_t > 1.0e-4) {
            v_in = -400.0;
            i_c = i_c + 100.0;
        }

        /* Tensão no resistor (lei de Ohm) */
        double v_r = i_c * r;

        /* Armazenamento dos resultados com passo hs */
        if (t_t >= ts) {
            printf("%.9e,%.9e,%.9e,%.9e,%.9e\n", t_t, v_in, v_c, v_r, i_c);
            ts += hs;   /* Próximo instante de saída */
            index++;
        }
    }

    return 0;
}