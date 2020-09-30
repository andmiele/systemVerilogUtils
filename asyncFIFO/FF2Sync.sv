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

// FF2Sync.sv
// 2 cascaded D FlipFlops for cross clock domain synchronization

module FF2Sync
#(parameter N = 16)
(
	input logic clk,
	input logic rst,
	input logic [N - 1 : 0] in,
	output logic [N - 1 : 0] out
);

logic [N - 1 : 0] reg1;
logic [N - 1 : 0] reg2;

assign out = reg2;

always_ff @(posedge clk or posedge rst)
begin
	if(rst)
	begin
		reg1 <= 'b0;
		reg2 <= 'b0;
	end
	else
	begin
		reg1 <= in;
		reg2 <= reg1;
	end
end
endmodule
