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

// sram.sv
// generic synchronous sram module

module sram
#(parameter SIZE = 16, parameter DATA_WIDTH = 4, localparam ADDR_WIDTH = $size(SIZE))
(
	input logic clk,
	input logic rst,
	input logic en,
	input logic rw,
	input logic[ADDR_WIDTH - 1 : 0] addr,
	input logic [DATA_WIDTH - 1 : 0] in,
	output logic[DATA_WIDTH - 1 : 0] out
);

logic [DATA_WIDTH - 1 : 0] mem [0 : SIZE - 1];

always_ff @(posedge clk or posedge rst)
begin
	if(rst)
	begin: reset // set all words to zero
	for(int i = 0; i < SIZE; i++)
		mem[i] <= 'b0;
        out <= 'b0;
        end
else
begin: run
	if(en)
	begin: enable
		if(rw)
		begin: write
			mem[addr] <= in;
		end
		else
		begin: read
			out <= mem[addr];
		end
	end
end
end

endmodule
