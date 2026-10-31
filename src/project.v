`default_nettype none

/* verilator lint_off WIDTHEXPAND */
/* verilator lint_off WIDTHTRUNC */

module tt_um_math_chip (
    input  wire [7:0] ui_in,    // Dedicated physical input pads
    output wire [7:0] uo_out,   // Dedicated physical output pads
    input  wire [7:0] uio_in,   // Bidirectional pads (inputs)
    output wire [7:0] uio_out,  
    output wire [7:0] uio_oe,   
    input  wire       ena,      // Core physical Enable Pad
    input  wire       clk,      // Physical Clock Pad
    input  wire       rst_n     // Physical Reset Pad (Active Low)
);

    reg [7:0] result;
    
    // Configure bidirectional pins as inputs
    assign uio_oe  = 8'b00000000; 
    assign uio_out = 8'b00000000;
    
    // Assign our 8-bit math result directly to the physical output pins
    assign uo_out  = result; 

    // Standard asynchronous active-low reset layout matching the foundry library
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 8'b0;
        end else if (ena) begin
            case (ui_in[7:6]) 
                2'b00:   result <= ui_in + uio_in; // 8-bit Addition
                2'b01:   result <= ui_in * uio_in; // 8-bit Multiplication
                2'b10:   result <= ui_in - uio_in; // 8-bit Subtraction
                default: result <= 8'b0;
            endcase
        end
    end

endmodule
