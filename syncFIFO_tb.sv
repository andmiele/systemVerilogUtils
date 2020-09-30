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

// syncFIFO_tb.sv
// generic synchronous FIFO module testbench

`timescale 1 ns / 10 ps

module syncFIFO_tb;

localparam SIZE = 16;
localparam DATA_WIDTH = 4;
localparam period = 10ns;
localparam FALL_THROUGH = 1;
logic clk, rst, en, rw, empty, full, passed;
logic [$clog2(SIZE) - 1 : 0] addr;
logic [DATA_WIDTH - 1 : 0] in;
logic [DATA_WIDTH - 1 : 0] out;

syncFIFO #(.SIZE(SIZE), .DATA_WIDTH(DATA_WIDTH), .FALL_THROUGH(FALL_THROUGH)) UUT(.clk(clk), .rst(rst), .en(en), .rw(rw), .addr(addr), .in(in), .out(out), .empty(empty), .full(full));


initial
begin
    passed = 1'b1;
    addr = 'b0;
    in = 'b0;
    clk = 1'b0;
    rst = 1'b1;
    en  = 1'b0;
    rw  = 1'b0;
    #period;
    rst = 1'b0;
    en = 1'b1;
    #period
    if (out != 'b0)
    begin
        $display("SYNC FIFO TEST 0 FAILED: out != 0 after reset!\n");
        passed = 1'b0;
    end
    rw = 1'b1;
    in = 1;
    if (out != 1)
    begin
        $display("SYNC FIFO TEST 1 FAILED: out != 1!\n");
        passed = 1'b0;
    end
    #period;
    rw = 1'b0;
    #period;
    if (out != 0)
    begin
        $display("SYNC FIFO TEST 2 FAILED: out != 0!\n");
        passed = 1'b0;
    end
    if (passed)
        $display("SYNC FIFO TEST PASSED!\n");
    else
        $display("SYNC FIFO TEST FAILED!\n");
    $stop;
end

always
    #(period / 2) clk = !clk;
endmodule
