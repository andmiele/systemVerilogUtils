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

// regFile_tb.sv
// multi-ported register file testbench

module regFile_tb;

localparam period = 10ns;
localparam N_REGS = 32;
localparam DATA_WIDTH = 32;
localparam N_READ_PORTS = 3;
localparam N_WRITE_PORTS = 2;
localparam ADDR_WIDTH = $clog2(N_REGS);
logic passed;
logic clk;
logic rst;
logic en;
logic we [N_WRITE_PORTS - 1 : 0];
logic re [N_READ_PORTS - 1 : 0];
logic [ADDR_WIDTH - 1 : 0] rAddrs [N_READ_PORTS - 1 : 0];
logic [ADDR_WIDTH - 1 : 0] wAddrs [N_WRITE_PORTS - 1 : 0];
logic [DATA_WIDTH - 1 : 0] wPorts [N_WRITE_PORTS - 1 : 0];
logic [DATA_WIDTH - 1 : 0] rPorts [N_READ_PORTS - 1 : 0];

regFile #(.N_REGS(N_REGS), .DATA_WIDTH(DATA_WIDTH), .N_READ_PORTS(N_READ_PORTS), .N_WRITE_PORTS(N_WRITE_PORTS)) 
UUT(.clk(clk), .rst(rst), .en(en), .we(we), .re(re), .rAddrs(rAddrs), .wAddrs(wAddrs), .rPorts(rPorts), .wPorts(wPorts));


initial
begin
	passed = 1'b1;
	clk = 1'b0;
	for(int i = 0; i < N_READ_PORTS; i++)
	begin
		rAddrs[i] = '0;
		re[i] = 1'b0;
	end
	for(int i = 0; i < N_WRITE_PORTS; i++)
	begin
		wAddrs[i] = '0;
		we[i] = 1'b0;
	end
	rst = 1'b1;
	en = 1'b0;
	#period;
	for(int i = 0; i < N_READ_PORTS; i++)
	begin: resetTest
		if(rPorts[i] != 'b0)
			passed = 1'b0;
	end	
	if(!passed)
		$display("MULTI-PORTED REG FILE TEST 0 FAILED: rPorts != 0 after reset!\n");	
	rst = 1'b0;
	en  = 1'b1;
	we[0]  = 1'b1;
	we[1]  = 1'b1;
	wAddrs[0] = 0;
	wPorts[0] = 32'hFFFFFFFF;
	wAddrs[1] = 1;
	wPorts[1] = 32'hCCCCCCCC;
	#period;
	re[0] = 1'b1;
	re[1] = 1'b1;
	re[2] = 1'b1;
	rAddrs[0] = 0;
	rAddrs[1] = 1;
	rAddrs[2] = 2;
	we[0] = 0'b0;
	we[1] = 0'b0;
	#period
	re[0] = 1'b0;
	re[1] = 1'b0;
	re[2] = 1'b0;
	if(rPorts[0] != 32'hFFFFFFFF || rPorts[1] != 32'hCCCCCCCC || rPorts[2] != 0)
		passed = 1'b0; 
	if(!passed)
		$display("MULTI-PORTED REG FILE TEST 1 FAILED: rPorts[%d]: %H exp: %H, rPorts[%d]: %H exp: %H, rPorts[%d]: %H exp: %H  after reset!\n", 0, rPorts[0], wPorts[0], 1, rPorts[1], wPorts[1], 2, rPorts[2], wPorts[2]);	
	if (passed)
		$display("MULTI-PORTED REG FILE TEST PASSED!\n");
	else
		$display("MULTI-PORTED REG FILE TEST FAILED!\n");
	$stop;
end            
always
	#(period / 2) clk = !clk;
endmodule
