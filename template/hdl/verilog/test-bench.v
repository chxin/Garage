`timescale 1ns/100ps
`include "counter.v"

module test_bench;
   reg clk;
   reg reset;
   wire [3:0] q;

   ripple_carry_counter r1(q, clk, reset);

   initial begin
      $dumpfile("counter.vcd");
      $dumpvars(0, test_bench);
   end

   initial
     clk = 1'b0;

   always
     #5 clk = ~clk;

   initial begin
      reset = 1'b1;
      #15 reset = 1'b0;
      #180 reset = 1'b1;
      #10 reset = 1'b0;
      #20 $finish;
   end

   initial
     $monitor($time, " clk, output q = %d", q);
endmodule // test
