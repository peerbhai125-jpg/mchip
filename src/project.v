`default_nettype none

module tt_um_math_chip (
    input  wire [7:0] ui_in,    // Dedicated inputs (Input A)
    output wire [7:0] uo_out,   // Dedicated outputs (Math Result)
    input  wire [7:0] uio_in,   // Bidirectional inputs (Input B)
    output wire [7:0] uio_out,  // Bidirectional outputs
    output wire [7:0] uio_oe,   // Bidirectional output enables
    input  wire       ena,      // Core physical Enable Pad
    input  wire       clk,      // Physical Clock Pad
    input  wire       rst_n     // Physical Reset Pad (Active Low)
);

    reg [7:0] result;
    
    // Clean, standard tie-offs for bidirectional ports
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;
    assign uo_out  = result; 

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 8'b0;
        end else if (ena) begin
            case (ui_in[7:6]) 
                2'b00:   result <= ui_in[5:0] + uio_in; // 6-bit padded Addition
                2'b01:   result <= ui_in[5:0] * uio_in; // 6-bit padded Multiplication
                2'b10:   result <= ui_in[5:0] - uio_in; // 6-bit padded Subtraction
                default: result <= 8'b0;
            endcase
        end
    end

endmodule
