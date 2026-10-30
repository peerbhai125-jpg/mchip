module tt_um_math_chip (
    input  wire [7:0] ui_in,    // Dedicated physical input pads
    output wire [7:0] uo_out,   // Dedicated physical output pads
    input  wire [7:0] uio_in,   // Bidirectional pads (inputs)
    output wire [7:0] uio_out,  
    output wire [7:0] uio_oe,   
    input  wire       ena,      // Core physical Enable Pad (DO NOT REMOVE)
    input  wire       clk,      // Physical Clock Pad
    input  wire       rst_n     // Physical Reset Pad (Active Low)
);

    reg [15:0] result;
    
    // Configure bidirectional pins as inputs
    assign uio_oe  = 8'b00000000; 
    assign uio_out = 8'b00000000;
    
    // Assign the lower 8 bits of the math result to the physical output pins
    assign uo_out  = result[7:0]; 

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 16'b0;
        end else if (ena) begin // Only calculate when the chip layer is turned on
            case (ui_in[7:6]) 
                2'b00:   result <= ui_in + uio_in; // Addition
                2'b01:   result <= ui_in * uio_in; // Multiplication
                2'b10:   result <= ui_in - uio_in; // Subtraction
                default: result <= 16'b0;
            endcase
        end
    end

endmodule
