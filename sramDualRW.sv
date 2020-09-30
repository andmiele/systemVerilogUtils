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

// sramDualRW.sv
// generic synchronous sram module with two read ports and one write port

module sramDualRW
#(parameter SIZE = 16, parameter WIDTH = 4, localparam ADDR_WIDTH = $size(SIZE))
(
	input logic clk,
	input logic rst,
	input logic en,
	input logic r1,
	input logic r2,
	input logic w,
	input logic[ADDR_WIDTH - 1 : 0] r1Addr,
	input logic[ADDR_WIDTH - 1 : 0] r2Addr,
	input logic[ADDR_WIDTH - 1 : 0] wAddr,
	input logic [WIDTH - 1 : 0] in,
	output logic[WIDTH - 1 : 0] out1,
	output logic[WIDTH - 1 : 0] out2
);

logic [WIDTH - 1 : 0] mem [0 : SIZE - 1];

always_ff @(posedge clk)
begin
	if(rst)
	begin: reset // set all words to zero
	for(int i = 0; i < SIZE; i++)
		mem[i] <= 'b0;
        out1 <= 'b0;
        out2 <= 'b0;
        end
else
begin: run
	if(en)
	begin: enable
		if(w)
		begin: write
			mem[wAddr] <= in;
		end
		if(r1)
		begin: read1
			out1 <= mem[r1Addr];
		end
		if(r2)
		begin: read2
			out2 <= mem[r2Addr];
		end
	end
end
end

endmodule
