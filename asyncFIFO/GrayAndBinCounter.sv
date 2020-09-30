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

// GrayAndBinCounter.sv
// Gray and binary counter



module GrayAndBinCounter
#(parameter N_AS_POWER_OF_2 = 4, parameter N = N_AS_POWER_OF_2)
(
	input logic clk,
	input logic rst,
	input logic inc,
	output logic [N - 1 : 0] b,
	output logic [N - 1 : 0] g,
	output logic [N - 1 : 0] gNext
);

logic [N - 1 : 0] b_r;
logic [N - 1 : 0] g_r;
logic [N - 1 : 0] bNext;

assign b = b_r;
assign g = g_r;

assign bNext = b_r + 1;
binToGray #(.N(N)) b2g(.b(bNext), .g(gNext));

always_ff @(posedge clk or posedge rst)
begin
	if(rst)
	begin
		b_r <= 'b0;
		g_r <= 'b0;
	end
	else
	begin
		if(inc)
		begin
			b_r <= bNext;
			g_r <= gNext;
		end
	end
end

endmodule
