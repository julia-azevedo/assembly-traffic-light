# Projeto Semáforo

> Repositório com subprojetos e arquivos de simulação desenvolvidos para estudos com AVR (Microchip/Atmel Studio) e SimulIDE.

---

## Sumário
- [Visão geral](#visão-geral)  
- [Estrutura do repositório](#estrutura-do-repositório)  
- [Como abrir / executar](#como-abrir--executar)  
- [Executar firmware (.hex) no SimulIDE](#executar-firmware-hex-no-simulide)  
- [Boas práticas](#boas-práticas)  
- [Contribuições e contato](#contribuições-e-contato)

---

## Visão geral
Os arquivos deste repositório correspondem à pasta de projetos do Atmel/Microchip Studio do autor, organizada originalmente em:
.../Atmel Studio/7.0

A raiz do repositório agrupa os subprojetos AVR e os projetos de simulação usados durante o desenvolvimento e os testes.

---

## Estrutura do repositório
- `CIRCUITOS_SIMULIDE/` — arquivos de simulação criados no SimulIDE.  
- `estudo_cseg/`, `2x7seg_counter_BCD/`, ... — subprojetos AVR (Microchip/Atmel Studio) usados para estudo.  
- `projeto_parte_display/` — projeto AVR referente à implementação do **contador com display de 7 segmentos**.

---

## Como abrir / executar

### Projetos no Microchip (Atmel) Studio
1. Abra o **Microchip Studio**.  
2. Vá em **File → Open → Project/Solution** (ou *Abrir projeto*).  
3. Navegue até a pasta do subprojeto desejado dentro da raiz (ex.: `.../Atmel Studio/7.0/projeto_parte_display/`).  
4. Abra o arquivo de solução do projeto (`*.atsln` ou similar).  
5. Na janela **Solution Explorer**, abra (duplo clique) o arquivo `main.asm` ou o arquivo fonte principal para editar/inspecionar.

> Observação: dependendo de como o projeto foi salvo, a extensão e nomes de arquivos podem variar. Procure por arquivos de solução (`*.atsln`) ou projeto do Microchip/Atmel.

### Projetos SimulIDE (`*.sim1`)
1. Abra o **SimulIDE**.  
2. Em SimulIDE, arraste o arquivo `*.sim1` para a janela do simulador **ou** use *File → Open* para carregar o circuito.  
3. Configure e execute a simulação conforme necessário (play/pause, propriedades de componentes etc.).

---

## Executar firmware (`.hex`) no SimulIDE
Para testar o `.hex` compilado do projeto AVR dentro do SimulIDE (por exemplo, firmware do ATmega328):

1. No Microchip Studio, compile o projeto (Build → Build Solution). O arquivo `.hex` normalmente fica em `Debug/` ou `Release/` dentro da pasta do projeto.  
2. Localize o caminho completo do arquivo `.hex` (ex.: `C:\...\<projeto>\Debug\<nome_do_projeto.hex>`).  
3. No SimulIDE:
   - Adicione o microcontrolador correspondente (ex.: ATmega328P) ao circuito.  
   - Dê duplo clique no componente do microcontrolador para abrir as propriedades.  
   - No campo **Firmware** cole o caminho completo do `.hex` (sem aspas) e confirme.  
   - Inicie a simulação.
