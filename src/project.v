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

    /* verilator lint_off UNUSEDSIGNAL */
    reg [15:0] result_reg;
    /* verilator lint_on UNUSEDSIGNAL */
    
    // Configure bidirectional pins as inputs
    assign uio_oe  = 8'b00000000; 
    assign uio_out = 8'b00000000;
    
    // Assign the lower 8 bits of our math calculation directly to the output pins
    assign uo_out  = result_reg[7:0]; 

    // Synchronous execution block aligned with the GF180 standard cell architectures
    always @(posedge clk) begin
        if (!rst_n) begin
            result_reg <= 16'b0;
        end else if (ena) begin
            case (ui_in[7:6]) 
                2'b00:   result_reg <= {8'b0, ui_in} + {8'b0, uio_in}; // Addition
                2'b01:   result_reg <= {8'b0, ui_in} * {8'b0, uio_in}; // Multiplication
                2'b10:   result_reg <= {8'b0, ui_in} - {8'b0, uio_in}; // Subtraction
                default: result_reg <= 16'b0;
            endcase
        end
    end

endmodule
