# Projeto Semáforo

> Repositório contendo subprojetos e arquivos de simulação desenvolvidos para estudos com AVR (Atmel Studio) e SimulIDE.

---

## Visão geral
Os arquivos neste repositório correspondem à pasta de projetos do Atmel Studio no ambiente de desenvolvimento.
Ou seja, a raiz do repositório agrupa os subprojetos e os arquivos de simulação que estavam organizados em `Atmel Studio/7.0`.

## Estrutura do repositório (resumo)
- `CIRCUITOS_SIMULIDE/` — arquivos de simulação desenvolvidos no SimulIDE durante os estudos.  
- `estudo_cseg/`, `2x7seg_counter_BCD/`, ... — subprojetos AVR/Atmel Studio usados para estudo.
- `projeto_parte_display/` — projeto AVR/Atmel referente à parte de implementação do contador com display de 7 segmentos.

Árvore:

Atmel Studio/7.0/
├─ CIRCUITOS_SIMULIDE/
│ ├─ projeto_parte_display.sim1
│ └─ projeto_parte_semaforo.sim1
├─ estudo_cseg/
├─ 2x7seg_counter_BCD/
├─ projeto_parte_display
├─ projeto_parte_semaforo
└─ projeto_principal/

## Como abrir / executar
- **Projetos Atmel Studio**: abra o microchip studio > vá em `abrir projeto` > localize a pasta raiz dos projetos (Atmel Studio/7.0/) entre na pasta do subprojeto desejado e localize o `arquivo.atsln` > localize a janela `Solution Explorer` abra (duplo clique) orquivo `main.asm`.
- **SimulIDE**: abra o SimulIDE > localize o circuito desejado (`arquivo.sim1`) > arraste para a jenela do SimulIDE.
- **Executar scipt AVR no SimulIDE**: abra a pasta do projeto desejado > localize a pasta `Debug` ou `Release` > copie o caminho do arquivo `nome_do_projeto.hex` > duplo clique no mega328 > cole o caminho, sem aspas, no campo firmware.
