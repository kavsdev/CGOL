`timescale 1ns/1ps
`default_nettype none

module cell_grid #(
    parameter ROWS = 8,
    parameter COLS = 8
) (
    input logic clock, reset, game, load,
    input logic [COLS*ROWS-1:0] data_in,
    output logic [COLS*ROWS-1:0] data_out
);

genvar i,j;

generate
        for (i = 0; i < ROWS; i++) begin : row_loop
            for (j = 0; j < COLS; j++) begin : col_loop
                
                logic [7:0] nb;

                assign nb[0] = (j > 0) ? data_out[i*COLS + j - 1] : 1'b0;
                assign nb[1] = (j > 0 && i < ROWS-1) ? data_out[(i+1)*COLS + j - 1] : 1'b0;
                assign nb[2] = (i < ROWS-1) ? data_out[(i+1)*COLS + j] : 1'b0;
                assign nb[3] = (i < ROWS-1 && j < COLS-1) ? data_out[(i+1)*COLS + j + 1] : 1'b0;
                assign nb[4] = (j < COLS-1) ? data_out[i*COLS + j+1] : 1'b0;
                assign nb[5] = (j < COLS-1 && i > 0) ? data_out[(i-1)*COLS + j + 1] : 1'b0;
                assign nb[6] = (i > 0) ? data_out[(i-1)*COLS + j] : 1'b0;
                assign nb[7] = (i > 0 && j > 0) ? data_out[(i-1)*COLS + j-1] : 1'b0;

                cell_unit gen_unit (
                    .clock      (clock), 
                    .reset      (reset), 
                    .game       (game), 
                    .load       (load),
                    .state_in   (data_in[i*COLS +j]), 
                    .state_out  (data_out[i*COLS +j]),
                    .neighbours (nb)
                );
            end
        end
endgenerate
    
endmodule