`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
// Engineer: Ahmed Alaa
// 
// Create Date: 11/20/2020 08:41:59 PM
// Module Name: FIFO_tb
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////


module FIFO_tb;
    parameter f_WIDTH       = 8;
    parameter f_DEPTH       = 16;
    parameter f_AF_LEVEL    = 12;
    parameter f_AE_LEVEL    = 4;
        
    reg                       clk;
    reg                       asyn_rst;           // asynchrouns reset
        
    // input port
    reg       [f_WIDTH-1:0]   f_in;
    reg                       WR_EN;
    reg                       RD_EN;
        
    // output port
    wire        [f_WIDTH-1:0]   f_out;
    wire        [f_WIDTH-1:0]   f_COUNTER_pin;
    wire                        f_AF;
    wire                        f_full;
    wire                        f_AE;
    wire                        f_empty; 
    
    // make the UUT
    FIFO uut
    (
        .clk(clk), 
        .asyn_rst(asyn_rst),
        .f_in(f_in),
        .WR_EN(WR_EN),
        .RD_EN(RD_EN),
        .f_out(f_out),
        .f_COUNTER_pin(f_COUNTER_pin),
        .f_AF(f_AF),
        .f_full(f_full),
        .f_AE(f_AE),
        .f_empty(f_empty)
    );
    
    // create the clk
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // create the stimulus
    initial begin
        // rise the  rst
        asyn_rst = 1;
    #10 
        asyn_rst = 0;
    #10
        f_in    = 8'haa;
        WR_EN   = 1'h1;
        RD_EN   = 1'h0;
    #10    
        f_in    = 8'hbb;
    #10    
        f_in    = 8'hcc;
    #10        
        f_in    = 8'hdd;
    #10
        f_in    = 8'hee;
        WR_EN   = 1'h1;
        RD_EN   = 1'h1;      
    #10 
        WR_EN   = 0;
        RD_EN   = 1'h0; 
    #10
        RD_EN   = 1'h1;
    #10
        RD_EN   = 1'h1;
    #50
        RD_EN   = 0;
        WR_EN   = 1;
        f_in    = 8'hff;   
    #20
        RD_EN   = 1;
        WR_EN   = 0;
    end
endmodule
