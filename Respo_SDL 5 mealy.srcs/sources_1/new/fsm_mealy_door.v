`timescale 1ns / 1ps
// ============================================================
// Module     : fsm_mealy_door (versi final dengan state_out)
// ============================================================

module fsm_mealy_door(
    input        clock,
    input        reset,
    input        w,
    output reg        y,
    output     [1:0]  state_out   // expose current state ke top
);

    parameter [1:0]
        STATE0 = 2'b00,
        STATE1 = 2'b01,
        STATE2 = 2'b10,
        STATE3 = 2'b11;

    reg [1:0] current_state, next_state;

    // expose state
    assign state_out = current_state;

    // ---- Current State Logic ----
    always @(posedge clock or posedge reset)
    begin
        if (reset == 1) begin
            current_state = STATE0;
        end else begin
            current_state = next_state;
        end
    end

    // ---- Next State Logic ----
    always @(current_state or w)
    begin
        case (current_state)
            STATE0: next_state = w ? STATE1 : STATE0;
            STATE1: next_state = w ? STATE1 : STATE2;
            STATE2: next_state = w ? STATE3 : STATE2;
            STATE3: next_state = w ? STATE3 : STATE0;
            default: next_state = STATE0;
        endcase
    end

    // ---- Output Logic (Mealy) ----
    // y = w · Q2 · Q1
    always @(current_state or w)
    begin
        case (current_state)
            STATE0: y = 0;
            STATE1: y = 0;
            STATE2: y = 0;
            STATE3: y = w ? 1 : 0;
            default: y = 0;
        endcase
    end

endmodule