module tt_um_math_chip (
    input  wire [7:0] ui_in,    // Dedicated physical input pads
    output wire [7:0] uo_out,   // Dedicated physical output pads
    input  wire [7:0] uio_in,   // Bidirectional pads (inputs)
    output wire [7:0] uio_out,  
    output wire [7:0] uio_oe,   
    input  wire       clk,      // Physical Clock Pad
    input  wire       rst_n     // Physical Reset Pad (Active Low)
);

    reg [15:0] result;
    
    assign uio_oe  = 8'b00000000; 
    assign uio_out = 8'b00000000;
    assign uo_out  = result[7:0]; 

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 16'b0;
        end else begin
            case (ui_in[7:6]) 
                2'b00:   result <= ui_in + uio_in; 
                2'b01:   result <= ui_in * uio_in; 
                2'b10:   result <= ui_in - uio_in; 
                default: result <= 16'b0;
            endcase
        end
    end

endmodule
