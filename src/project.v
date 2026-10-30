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

    reg [15:0] result;
    
    // Configure bidirectional pins as inputs
    assign uio_oe  = 8'b00000000; 
    assign uio_out = 8'b00000000;
    
    // Assign the lower 8 bits of the math result to the physical output pins
    assign uo_out  = result[7:0]; 

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 16'b0;
        end else if (ena) begin
            case (ui_in[7:6]) 
                // {8'b0, ...} explicitly pads the 8-bit registers to 16-bits safely
                2'b00:   result <= {8'b0, ui_in} + {8'b0, uio_in}; // Safe Addition
                2'b01:   result <= {8'b0, ui_in} * {8'b0, uio_in}; // Safe Multiplication
                2'b10:   result <= {8'b0, ui_in} - {8'b0, uio_in}; // Safe Subtraction
                default: result <= 16'b0;
            endcase
        end
    end

endmodule
