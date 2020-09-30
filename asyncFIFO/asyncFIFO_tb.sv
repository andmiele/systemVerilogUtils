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

// asyncFIFO_tb.sv
// asynchronous FIFO module testbench

`timescale 1 ns / 10 ps

module asyncFIFO_tb;

localparam SIZE_AS_POWER_OF_2 = 3;
localparam DATA_WIDTH = 4;
localparam rPeriod = 10ns;
localparam wPeriod = 3ns;
logic wClk, rClk, wRst, rRst, wEn, rEn, empty, full, passed;
logic [DATA_WIDTH - 1 : 0] in;
logic [DATA_WIDTH - 1 : 0] out;

asyncFIFO #(.SIZE_AS_POWER_OF_2(SIZE_AS_POWER_OF_2), .DATA_WIDTH(DATA_WIDTH)) UUT(.wClk(wClk), .rClk(rClk), .wRst(wRst), .rRst(rRst), .wEn(wEn), .rEn(rEn), .wData(in), .rData(out), .empty(empty), .full(full) );


initial
begin
	passed = 1'b1;
	rClk = 1'b0;
	rRst = 1'b1;
	rEn  = 1'b0;
	#rPeriod;
	rRst = 1'b0;
	rEn = 1'b1;
	if (out != 'b0)
	begin
		$display("ASYNC FIFO TEST 0 FAILED: out != 0 after reset!\n");
		passed = 1'b0;
	end
	#rPeriod
	if (out != 1)
	begin
		$display("ASYNC FIFO TEST 1 FAILED: out != 1!\n");
		passed = 1'b0;
	end
	#rPeriod;
	if (out != 2)
	begin
		$display("ASYNC FIFO TEST 2 FAILED: out != 2!\n");
		passed = 1'b0;
	end
        #rPeriod;
	rEn = 1'b0;
	wait(full);
        wait(rClk);
        rEn = 1'b1;
	if (out != 0)
	begin
		$display("ASYNC FIFO TEST FULL FAILED: out != 0!\n");
		passed = 1'b0;
	end        
	if (passed)
		$display("ASYNC FIFO TEST PASSED!\n");
	else
		$display("ASYNC FIFO TEST FAILED!\n");
	$stop;
end

initial
begin
	wClk = 1'b0;
	wRst = 1'b1;
	wEn  = 1'b0;
	in = 0; 
	#wPeriod;
	wRst = 1'b0;
	wEn  = 1'b1;
	#wPeriod;
	in = 1;
	#wPeriod
	in = 2;
	#wPeriod;
	for(int i = 0; i < (1 << SIZE_AS_POWER_OF_2); i++)
	begin
		in = i;
		#wPeriod;
	end
end

always
	#(wPeriod / 2) wClk = !wClk;

always
	#(rPeriod / 2) rClk = !rClk;
endmodule
