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

// syncFIFO.sv
// generic synchronous FIFO module

module syncFIFO
#(parameter SIZE = 16, parameter DATA_WIDTH = 4, parameter FALL_THROUGH = 1, localparam ADDR_WIDTH = $size(SIZE))
(
	input logic clk,
	input logic rst,
	input logic en,
	input logic rw,
	input logic[ADDR_WIDTH - 1 : 0] addr,
	input logic [DATA_WIDTH - 1 : 0] in,
	output logic empty,
	output logic full,
	output logic[DATA_WIDTH - 1 : 0] out
);


logic [DATA_WIDTH - 1 : 0] mem [0 : SIZE - 1];

logic [ADDR_WIDTH : 0] tailPtr;
logic [ADDR_WIDTH : 0] headPtr;

logic[DATA_WIDTH - 1 : 0] out_r;
logic[DATA_WIDTH - 1 : 0] out_t;

assign empty = tailPtr == headPtr;
assign full = tailPtr[ADDR_WIDTH - 1 : 0] == headPtr[ADDR_WIDTH - 1 : 0] && tailPtr[ADDR_WIDTH] != headPtr[ADDR_WIDTH];

// for FALL THROUGH
assign out_t = empty ? 'b0 : mem[headPtr];
assign out = FALL_THROUGH ? out_t : out_r;

always_ff @(posedge clk or posedge rst)

begin
	if(rst)
	begin // set all words to zero
	for(int i = 0; i < SIZE; i++)
		mem[i] <= 'b0;
	tailPtr <= 0;
	headPtr <= 0;
	out_r <= 'b0;
        end
else
begin: run
	if(en)
	begin: enable
		if(rw)
		begin: write
			if(!full)
			begin 
			mem[tailPtr] <= in;
			tailPtr <= tailPtr + 1;
		end
	end
	else
	begin: read
		if(!empty)
		begin                          
		out_r <= mem[headPtr];
		headPtr <= headPtr + 1;
	end
end
	end
end
end

endmodule
