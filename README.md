# Traffic Light Project  

> Repository with subprojects and simulation files developed for AVR studies (Microchip/Atmel Studio) and SimulIDE.  

---


## Repository Structure  
- `assemble-control.asm` — build code created on Microchip Studio  
- `semaforos-circuito.sim1` — circuit simulation build on SimulIDE
- `simulide-executavel.hex` — hexdecimal code to upload on ATmega328p Firmware
- `state-machine.png` — image of the traffic lights behavior implemented as a state machine

---

## How to Open / Run  

### Projects in Microchip (Atmel) Studio  
1. Open **Microchip Studio**  
2. Go to **File → Open → Project/Solution**  
3. Navigate to the desired subproject folder (e.g., `.../Atmel Studio/7.0/projeto_parte_display/`)  
4. Open the project solution file (`*.atsln` or similar)  
5. In **Solution Explorer**, double-click `main.asm` or the main source file to edit or run  


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
