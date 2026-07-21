# Traction e-Motor Control Software Architecture - The Story of a Digital Thread
*Built using MATLAB R2026a, Copyright 2026 The MathWorks, Inc.*  
<img width="1008" height="604" alt="EMotorSoftwareArchitecture" src="https://github.com/user-attachments/assets/49592399-bd14-4f8a-8271-52c573c48a63" />


## Overview

A key challenge in the automotive industry is developing subsystem control software while maintaining continuity across the entire development process. From early requirements through model development and testing phases, valuable information is often lost during handoffs between different teams or tools. Using an example of developing traction e-motor control application software, this talk demonstrates how creating a single, integrated digital thread can help eliminate those information gaps, ensuring consistent data flow and traceability throughout the development lifecycle.
This workflow example is built on System Composer™. It reconstructs an EV traction e-motor control software architecture from a complex Visio diagram. The software architecture model serves as a single source of truth for requirements tracing, component design, interface definition, system analysis, and functional (behavioral) model testing. The example also demonstrates key capabilities from Simulink Test™ and CI/CD automation with Simulink Check™. Through this demonstration, engineers will learn how to establish a consistent digital thread across the entire application software development process.

## Highlights
- Tracing requirements from architecture to model, test, and code
- Capturing component meta-data using stereotypes
- Bridging architecture model with Simulink behavior 
- Creating CI pipeline using process advisor


## Setup Instructions
Clone the repository:
- On GitHub, navigate to the repository you want to clone.
- Click the green "Code" button and copy the HTTPS
- In MATLAB, right-click in the Files or Project panel.
- Select Source Control > Clone Git Repository.

## Relevant Products (Release R2025b and later)

- MATLAB&reg;
- Simulink&reg;
- System Composer&trade;
- Requirements Toolbox&trade;
- Simulink&reg; Test&trade;
- Simulink&reg; Check&trade;
- MATLAB&reg; Coder&reg;
- Simulink&reg; Coder&reg;
- Embedded Coder&reg;
- Powertrain Blockset&trade;(for running test harnesses)
- CI/CD Automation for Simulink Check (as support package)

## License

See the licence.txt file in the project directory.
