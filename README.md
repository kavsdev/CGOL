# conways game of life implemented in system verilog and c


## sv
- block diagram
- review sv notes
- need a way to load data, take out data
    - serial
    - mem load



## USAGE
- run with iverilog:
```
iverilog -g2012 -DFANCY -DROWS=3 -DCOLS=3 -DHEX_FILE=\"init_state_3_3.hex\" tb_cell_grid.sv cell_grid.sv cell_unit.sv && ./a.out
```
