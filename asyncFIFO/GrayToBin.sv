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

// GrayToBin.sv
// convert Gray code to regular binary representation

module GrayToBin
#(parameter N = 4)
(
    input logic [N - 1 : 0] g,
    output logic [N - 1 : 0] b
);
always_comb
begin
    for(int i = 0; i < N; i++)
        b[i] = b[i] ^ (g >> i);
end
endmodule
