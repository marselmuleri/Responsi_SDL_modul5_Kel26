`timescale 1ns / 1ps

module top_mealy_door(
    input        clk,
    input        reset,
    input        w,
    output [6:0] seg,
    output [7:0] anode
);

    wire        y_wire;
    wire [1:0]  state_wire;

    fsm_mealy_door U_FSM (
        .clock     (clk),
        .reset     (reset),
        .w         (w),
        .y         (y_wire),
        .state_out (state_wire)
    );

    display_door U_DISPLAY (
        .clock  (clk),
        .reset  (reset),
        .w      (w),
        .y      (y_wire),
        .state  (state_wire),
        .anode  (anode),
        .seg    (seg)
    );

endmodule