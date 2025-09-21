# Traffic Light Project  

> Repository with subprojects and simulation files developed for AVR studies (Microchip/Atmel Studio) and SimulIDE.  

---

## Overview  
This repository contains Atmel/Microchip Studio project files, originally organized under:  
`.../Atmel Studio/7.0`  

The root folder groups AVR subprojects and simulation projects used during development and testing.  

---

## Repository Structure  
- `CIRCUITOS_SIMULIDE/` — simulation files created in SimulIDE  
- `estudo_cseg/`, `2x7seg_counter_BCD/`, ... — AVR subprojects (Microchip/Atmel Studio) for study  
- `projeto_parte_display/` — AVR project implementing a **7-segment display counter**  

---

## How to Open / Run  

### Projects in Microchip (Atmel) Studio  
1. Open **Microchip Studio**  
2. Go to **File → Open → Project/Solution**  
3. Navigate to the desired subproject folder (e.g., `.../Atmel Studio/7.0/projeto_parte_display/`)  
4. Open the project solution file (`*.atsln` or similar)  
5. In **Solution Explorer**, double-click `main.asm` or the main source file to edit or run  

> Note: File names and extensions may vary. Look for solution (`*.atsln`) or project files.  

### SimulIDE Projects (`*.sim1`)  
1. Open **SimulIDE**  
2. Locate the desired `*.sim1` circuit file  
3. Drag the file into SimulIDE or use *File → Open* to load it  

---

## Running Firmware (`.hex`) in SimulIDE  
1. In Microchip Studio, build the project (Build → Build Solution). The `.hex` file is usually in `Debug/` or `Release/` inside the project folder.  
2. Locate the full path of the `.hex` file (e.g., `C:\...\<project>\Debug\<project_name.hex>`)  
3. In SimulIDE:  
   - Double-click the microcontroller component (e.g., mega328)  
   - In the **Firmware** field, paste the full `.hex` path and confirm  
   - Start the simulation  
