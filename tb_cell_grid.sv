`timescale 1ns/1ps

// declarations
`ifdef ROWS
    localparam ROWS = `ROWS;
`else
    localparam ROWS = 8;
`endif

`ifdef COLS
    localparam COLS = `COLS;
`else
    localparam COLS = 8;
`endif

`ifndef HEX_FILE
    `define HEX_FILE "init_state.hex"
`endif

module tb_cell_grid();

logic clock, reset, load, game;
logic [COLS*ROWS-1:0] data_in;
logic [COLS*ROWS-1:0] data_out;

// instantiate uut
cell_grid #(.ROWS(ROWS),.COLS(COLS)) uut(.*);

// clock
initial begin
    clock = 0;
    forever #5 clock = ~clock;
end

//procedures
task automatic send_initial_data(input string fn);

    reg [COLS-1:0] init_state [0:ROWS-1];

    $readmemb(fn, init_state);
    $display("------- INIT_STATE------");

        for (int i = 0; i < ROWS; i++) begin
        for (int j = 0; j < COLS; j++) begin
            if (init_state[i][COLS-1-j] === 1'b1)      begin

                `ifdef FANCY
                    $write("🟩");
                `else
                    $write("X ");
                `endif
            end
            else if (init_state[i][COLS-1-j] === 1'b0) begin

                `ifdef FANCY
                    $write("⬛");
                `else
                    $write("O ");
                `endif
            end
            else $write("? "); // Will print ? if bit is x or z
        end
        $display(""); 
    end

    @(negedge clock)
    for (int i=0; i<ROWS ;i++ ) begin
        // $display("%b",init_state[i]);  
        data_in[i*COLS +: COLS] = init_state[i];
    end

    load = 1;
    game = 0;

    @(negedge clock)
    load = 0;
    data_in = '0;

endtask

task automatic print_current_state();
    $display("\n--- Grid State at %0t ---", $time);

    for (int i = 0; i < ROWS; i++) begin
        for (int j = 0; j < COLS; j++) begin
            if (data_out[i*COLS + COLS-1-j] === 1'b1) begin

                `ifdef FANCY
                    $write("🟩");
                `else
                    $write("X ");
                `endif
            end   
            else if (data_out[i*COLS + COLS-1-j] === 1'b0) begin

                `ifdef FANCY
                    $write("⬛");
                `else
                    $write("O ");
                `endif
            end 
        else $write("? "); // Will print ? if bit is x or z
        end
        $display("");
    end
endtask

// stimuli
initial begin
    reset = 1;
    load = 0;
    game = 0;
    data_in = '0;

    repeat(2) @(posedge clock);
    @(negedge clock) reset = 0;

    @(posedge clock);
    send_initial_data(`HEX_FILE);

    game = 1;

    repeat (25) begin
        @(posedge clock);
        print_current_state();

    end

    $finish;
end

initial begin
    $dumpfile("tb_cell_grid.vcd");
    $dumpvars(0, tb_cell_grid);
end
    


endmodule