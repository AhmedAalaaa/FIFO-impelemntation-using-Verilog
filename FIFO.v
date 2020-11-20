`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Ahmed Alaa
// 
// Create Date: 11/20/2020 06:51:17 PM
// Design Name: FIFO impelemntation using verilog with flags
// Module Name: FIFO
// Project Name: FIFO impelemntation using verilog with flags
// Description: Impelentaion of FIFO using verilog with flags to indicate the status of 
//              the FIFO, the FIFO has input port to accept the data of length f_DEPTH
//              WR_EN -> when high the FIFO can accept the data
//              RD_EN -> when high the FIFO can read the data
//              FULL_flag -> when high the FIFO is full
//              AF_flag -> when FIFO exceeds a limit this flag will raise (almost full)
//              EMPTY_flag -> when high the FIFO is empty
//              AE_flag -> when FIFO exceeds a limit this flag will raise (almost empty)
//              
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module FIFO #
    (
        parameter f_WIDTH       = 8,
        parameter f_DEPTH       = 16,
        parameter f_AF_LEVEL    = 12,
        parameter f_AE_LEVEL    = 4
    )
    (
        input                       clk,
        input                       asyn_rst,           // asynchrouns reset
        
        // input port
        input       [f_WIDTH-1:0]   f_in,
        input                       WR_EN,
        input                       RD_EN,
        
        // output port
        output reg  [f_WIDTH-1:0]   f_out,
        output      [f_WIDTH-1:0]   f_COUNTER_pin,
        output                      f_AF,
        output                      f_full,
        output                      f_AE,
        output                      f_empty    
    );
    
    // The FIFO definition
    reg             [f_WIDTH-1:0]   FIFO_buffer     [0:f_DEPTH-1];
    
    // The read and write indices
    reg             [f_DEPTH-1:0]   READ_INDEX;
    reg             [f_DEPTH-1:0]   WRITE_INDEX;
    
    // Counter to count the number of elements in the FIFO to asure it is not compeletly full nor compeletly empty 
    reg             [f_DEPTH-1:0]   f_COUNTER;
    
    // flags
    reg                             f_full_flag;
    reg                             f_empty_flag;      
    
    // define the module logic
    always @ (posedge clk or posedge asyn_rst) begin
        if(asyn_rst) begin
            f_out           <= 1'h0;
            f_COUNTER       <= 1'h0;
            READ_INDEX      <= 1'h0;
            WRITE_INDEX     <= 1'h0;
            f_full_flag     <= 1'h0;
            f_empty_flag    <= 1'h1;
        end
        else begin  
            // tracking the counter
            if(WR_EN == 1 && RD_EN == 0) begin
                f_COUNTER       <= f_COUNTER + 1;
                f_empty_flag    <= 0;
            end
            else if(WR_EN == 0 && RD_EN == 1) begin
                f_COUNTER <= f_COUNTER - 1;
                if(f_COUNTER <= 0) begin
                    f_empty_flag <= 1;
                    f_COUNTER <= 0;
                end
            end 
            
            // tracking the WRITE_INDEX
            if(WR_EN == 1 && f_full_flag == 0) begin
                if(WRITE_INDEX == f_DEPTH - 1) begin
                    WRITE_INDEX     <= 0;
                end
                else begin
                    WRITE_INDEX     <= WRITE_INDEX + 1;  
                end            
            end
            
            // tracking the READ_INDEX
            if(RD_EN == 1 && f_empty_flag == 0) begin
                if(READ_INDEX == f_DEPTH - 1) begin
                    READ_INDEX <= 0;    
                end
                else begin
                    READ_INDEX <= READ_INDEX + 1;
                end
            end
            
            // interface with the inputs
            if(WR_EN == 1) begin
                FIFO_buffer[WRITE_INDEX] <= f_in;
            end
            if(RD_EN == 1) begin
                f_out <= FIFO_buffer[READ_INDEX];
            end
            else begin
                f_out <= 1'hz;
            end
        end
    end
    
    // test pin
    assign f_COUNTER_pin    = f_COUNTER;
    
    assign f_AF             = (f_COUNTER >= f_AF_LEVEL) ? (1'h1) : (1'h0);
    assign f_full           = (f_full_flag)             ? (1'h1) : (1'h0);
    assign f_AE             = (f_COUNTER <= f_AE_LEVEL) ? (1'h1) : (1'h0);
    assign f_empty          = (f_empty_flag)            ? (1'h1) : (1'h0); 
    
endmodule
