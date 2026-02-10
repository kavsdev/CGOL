`timescale 1ns/1ps

module tb_cell_grid();

// declarations
localparam ROWS = 3;
localparam COLS = 3;

logic clock, reset, load, game;
logic [COLS-1:0] data_in [0:ROWS-1];
logic [COLS-1:0] data_out [0:ROWS-1];

// instantiate uut
cell_grid #(.ROWS(ROWS),.COLS(COLS)) uut(.*);

// clock
initial begin
    clock = 0;
    forever #5 clock = ~clock;
end

//procedures
// task automatic print_grid();
//     $display("\n--- Grid State at %t ---", $time);
//             for (int i = 0; i < ROWS; i++) begin
//                 for (int j = 0; j < COLS; j++) begin
//                     $write("%s ", data_out[i][j] ? "x" : "o");
//                 end
//                 $display(""); // New line after each row
//             end
// endtask

task automatic print_grid();
    $display("\n--- Grid State at %0t ---", $time);
    for (int i = 0; i < ROWS; i++) begin
        for (int j = 0; j < COLS; j++) begin
            if (data_out[i][j] === 1'b1)      $write("x ");
            else if (data_out[i][j] === 1'b0) $write("o ");
            else                              $write("? "); // Will print '?' if bit is x or z
        end
        $display(""); 
    end
endtask

// stimuli

initial begin
    reset = 1;
    load = 0;
    game = 0;
    foreach (data_in[i]) data_in[i] = '0;

    // data_in[0][1] = 1'b1;
    // data_in[1][2] = 1'b1;
    // data_in[2][0] = 1'b1;
    // data_in[2][1] = 1'b1;
    // data_in[2][2] = 1'b1;

    data_in[1] = 3'b111;

    #17 reset = 0;

    @(posedge clock);
    load = 1;

    @(posedge clock);
    load = 0;

    print_grid();

    game = 1;
    repeat (10) begin
        @(posedge clock);
        #1;
        print_grid();

    end

    $finish;
end

initial begin
    $dumpfile("tb_cell_grif.vcd");
    $dumpvars(0, tb_cell_grid);
    for (int i = 0; i < ROWS; i++) begin
        $dumpvars(0, data_in[i]);
        $dumpvars(0, data_out[i]);
    end
end
    


endmodule