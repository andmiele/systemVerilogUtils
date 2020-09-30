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

// binToGray.sv
// convert regular binary code to Gray code

module binToGray
#(parameter N = 4)
(
    input logic [N - 1 : 0] b,
    output logic [N - 1 : 0] g
);
assign g = (b >> 1) ^ b;
endmodule
