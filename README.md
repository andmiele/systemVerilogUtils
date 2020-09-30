# System Verilog implementation of memory units and other utility modules
## Disclaimer
**The code provided in this repository is something I worked on in my free time to learn System Verilog and brush up on digital design from the point of view of someone who was a VHDL RTL research engineer in a previous life.
The code is not production level, not thoroughly tested or verified and most importantly was not written with any commercial intent in mind but purely as a self-learning experience.
I am sharing it with the hope that it could be a useful starting point or reference for folks who do research or self-learning in computer hardware.**
## Content
* Various SRAMs and FIFOs, a generic synchronous Register File
* **asyncFIFO** - Dual-clock asynchronous FIFO for clock domain crossing based on Clifford E. Cummings' article (FIFO version 1): http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf
