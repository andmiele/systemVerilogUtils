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

// rom.sv
// generic ROM

module rom
#(parameter SIZE = 16, parameter DATA_WIDTH = 4, parameter contentFile = "rom.mif", localparam ADDR_WIDTH = $size(SIZE))
(
 input logic [ADDR_WIDTH - 1 : 0] addr,
 output logic [DATA_WIDTH - 1 : 0] out
);
 logic [DATA_WIDTH - 1 : 0] mem [0 : SIZE - 1];
 
// read ROM content from file
initial 
begin
  $readmemh(contentFile, mem);
end

always_comb
 begin
  out = mem[addr];
 end
endmodule