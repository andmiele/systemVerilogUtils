//-----------------------------------------------------------------------------
// Copyright 2020 Andrea Miele
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//-----------------------------------------------------------------------------

// asyncFIFO.sv
// asynchronous FIFO for clock domain crossing, works for number of elements that is a power of 2
// Based on Cliff Cummings's paper (FIFO version 1): http://www.sunburst-design.com/papers/CummingsSNUG2002SJ_FIFO1.pdf

module asyncFIFO
#(parameter SIZE_AS_POWER_OF_2 = 4, parameter DATA_WIDTH = 4, localparam SIZE = (1 << SIZE_AS_POWER_OF_2), 
localparam ADDR_WIDTH = $size(SIZE))
(
    input logic wClk,
    input logic rClk,
    input logic wRst,
    input logic rRst,
    input logic wEn,
    input logic rEn,
    input logic[DATA_WIDTH - 1 : 0] wData,
    output logic [DATA_WIDTH - 1 : 0] rData,
    output logic full,
    output logic empty
);


logic [ADDR_WIDTH : 0] syncRPtr;
logic [ADDR_WIDTH : 0] syncWPtr;
logic [ADDR_WIDTH : 0] wPtrB;
logic [ADDR_WIDTH : 0] wPtrG;
logic [ADDR_WIDTH : 0] wPtrGNext;
logic [ADDR_WIDTH : 0] rPtrB;
logic [ADDR_WIDTH : 0] rPtrG;
logic [ADDR_WIDTH : 0] rPtrGNext;
logic wFull;
logic rEmpty;

// full and empty flip-flops

always_ff @(posedge wClk or posedge wRst)
begin
	if(wRst)
		full <= 1'b0;
	else
		full <= wFull;
end

always_ff @(posedge rClk or posedge rRst)
begin
	if(rRst)
		empty <= 1'b1;
	else
		empty <= rEmpty;
end


// the FIFO memory
sramRW
#(.SIZE(SIZE), .DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .FALL_THROUGH(1))
mem
(
	.clk(wClk),
	.rst(1'b0),
	.en(1'b1),
	.w(wEn && (!wFull)),
	.r(1'b1),
	.wAddr(wPtrB[ADDR_WIDTH - 1 : 0]),
	.rAddr(rPtrB[ADDR_WIDTH - 1 : 0]),
	.in(wData),
	.out(rData)
);

// Gray plus binary counter for write pointer (FIFO tail) and full, almost-full condition generation
GrayAndBinCounter
#(.N_AS_POWER_OF_2(SIZE_AS_POWER_OF_2 + 1))
wCounter
(
	.clk(wClk),
	.rst(wRst),
	.inc(wEn && (!wFull)),
	.b(wPtrB),
	.g(wPtrG),
	.gNext(wPtrGNext)
);

// full condition
assign wFull = wPtrGNext[ADDR_WIDTH] != syncRPtr[ADDR_WIDTH] 
&& wPtrGNext[ADDR_WIDTH - 1] != syncRPtr[ADDR_WIDTH - 1] 
&& wPtrGNext[ADDR_WIDTH - 2 : 0] == syncRPtr[ADDR_WIDTH - 2 : 0];

// Gray plus binary counter for read pointer (FIFO head) and empty, almost-empty condition generation
GrayAndBinCounter
#(.N_AS_POWER_OF_2(SIZE_AS_POWER_OF_2 + 1))
rCounter
(
	.clk(rClk),
	.rst(rRst),
	.inc(rEn && (!rEmpty)),
	.b(rPtrB),
	.g(rPtrG),
	.gNext(rPtrGNext)
);

// empty condition
assign rEmpty = rPtrGNext == syncWPtr;

// Synchronized wPtr
FF2Sync
#(.N(ADDR_WIDTH + 1))
wSync
(
	.clk(rClk),
	.rst(rRst),
	.in(wPtrG),
	.out(syncWPtr)
);

// Synchronized rPtr
FF2Sync
#(.N(ADDR_WIDTH + 1))
rSync
(
	.clk(wClk),
	.rst(wRst),
	.in(rPtrG),
	.out(syncRPtr)
);

endmodule
