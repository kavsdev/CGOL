`timescale 1ns/1ps

module tb_cell_unit();

// declarations
logic clock;
logic reset;
logic game;
logic [7:0] neighbours;
logic load;
logic state_in;
logic state_out;

// instantiate uut
cell_unit uut(.*);

// clock
initial begin
    clock = 0;
    forever #5 clock = ~clock;
end


// stimuli

initial begin
    reset = 1;
    load = 0;
    game = 0;
    neighbours = 0;
    state_in = 0;
    #17 reset = 0;

    @(posedge clock);
    load = 1;
    state_in = 1;
    @(posedge clock);
    load = 0;
    @(posedge clock);
    @(posedge clock);

    neighbours = 8'd0;
    @(posedge clock);

    game = 1;

    neighbours = 8'd5;
    @(posedge clock);

    neighbours = 8'd5;
    @(posedge clock);
    
    repeat (50) begin
        @(posedge clock);
        neighbours = $urandom_range(1<<8-1,0);
    end

    $finish;
end

initial begin
    $dumpfile("tb_cell_unit.vcd");
    $dumpvars(0, tb_cell_unit);
end
    
endmodule