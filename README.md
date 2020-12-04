# System Verilog implementation of memory units and other utility modules
## Disclaimer
**The code provided in this repository is something I worked on in my free time to learn System Verilog and brush up on digital design from the point of view of someone who was a VHDL (research) digital designer in a previous life.
The code is not production-level and was neither thoroughly tested nor formally verified.**
## Content
* Various SRAMs and FIFOs, a generic synchronous Register File
* **asyncFIFO** - Dual-clock asynchronous FIFO for clock domain crossing based on Clifford E. Cummings' article (FIFO version 1): http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
