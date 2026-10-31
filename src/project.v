`default_nettype none

module tt_um_math_chip (
    input  wire [7:0] ui_in,    // Dedicated physical input pads (Input A)
    output wire [7:0] uo_out,   // Dedicated physical output pads (Math Result)
    input  wire [7:0] uio_in,   // Bidirectional pads (Input B)
    output wire [7:0] uio_out,  // Bidirectional output paths
    output wire [7:0] uio_oe,   // Bidirectional output enables
    input  wire       ena,      // Core physical Enable Pad
    input  wire       clk,      // Physical Clock Pad
    input  wire       rst_n     // Physical Reset Pad (Active Low)
);

    reg [7:0] result;
    
    // Explicit vector array assignments to pass all foundry layout checks
    assign uio_oe  = 8'h00; 
    assign uio_out = 8'h00; 

    // Assign our 8-bit math result directly to the physical output pins
    assign uo_out  = result; 

    // Asynchronous reset logic fully matching the standard cells
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 8'b0;
        end else if (ena) begin
            case (ui_in[7:6]) 
                2'b00:   result <= ui_in + uio_in; // Addition
                2'b01:   result <= ui_in * uio_in; // Multiplication
                2'b10:   result <= ui_in - uio_in; // Subtraction
                default: result <= 8'b0;
            endcase
        end
    end

endmodule
