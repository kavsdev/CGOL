`timescale 1ns/1ps
`default_nettype none

module cell_unit (
    input logic clock,
    input logic reset,
    input logic game,
    input logic [7:0] neighbours,
    input logic load,
    input logic state_in,
    output logic state_out
);

logic r_state, r_next_state;
logic [1:0] count_1, count_2, count_3, count_4;
logic [2:0] count_21,count_22;
logic [3:0] count_final;

always_ff @( posedge clock ) begin : blockName
    if(reset) 
    r_state <= '0;
    else if(load) 
    r_state <= state_in;
    else if(game)
    r_state <= r_next_state;
    else
    r_state <= r_state;
end


assign count_1 = neighbours[0] + neighbours [1];
assign count_2 = neighbours[2] + neighbours [3];
assign count_3 = neighbours[4] + neighbours [5];
assign count_4 = neighbours[6] + neighbours [7];
assign count_21 = count_1 + count_2;
assign count_22 = count_3 + count_4;
assign count_final = count_21 + count_22;


always_comb begin : set_next_state
    if (count_final==4'd3) 
    r_next_state = 1;
    else if(count_final ==2) 
    r_next_state = r_state ;        
    else 
    r_next_state = 0;
    
end

assign state_out = r_state;
endmodule