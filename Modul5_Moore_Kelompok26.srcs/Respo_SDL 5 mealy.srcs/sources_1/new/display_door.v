`timescale 1ns / 1ps
// ============================================================
// Module     : display_door
// Description: Driver 7-segment 8 digit untuk FSM Mealy
//              Format: w X y X  S Q1 Q0
//              Digit : [w][val_w][y][val_y][sp][S][Q1][Q0]
//
//              Contoh State0 w=0: "w 0 y 0  S 0 0"
//              Contoh State3 w=1: "w 1 y 1  S 1 1"  ? PINTU BUKA
//              Contoh State3 w=0: "w 0 y 0  S 1 1"  ? terkunci
//
// Perbedaan dengan Moore:
//   - y hanya 1 bit (0 atau 1), bukan 2 bit
//   - y=1 hanya muncul saat State3 DAN w=1 (sifat Mealy)
//
// Segment encoding active-low {ca,cb,cc,cd,ce,cf,cg}
//        a
//       ---
//    f |   | b
//       ---   <- g
//    e |   | c
//       ---
//        d
// ============================================================

module display_door(
    input        clock,
    input        reset,
    input        w,            // nilai input w (1 bit)
    input        y,            // nilai output y (1 bit Mealy)
    input  [1:0] state,        // current state Q1Q0 (2 bit)
    output reg [7:0] anode,    // active-low, 8 digit
    output reg [6:0] seg       // active-low, {ca,cb,cc,cd,ce,cf,cg}
);

    // ---- Clock Divider: 100MHz ? ~1kHz refresh multiplexing ----
    reg [16:0] clk_div;
    reg [2:0]  digit_sel;

    always @(posedge clock or posedge reset)
    begin
        if (reset) begin
            clk_div   <= 0;
            digit_sel <= 0;
        end else begin
            if (clk_div == 17'd99999) begin
                clk_div   <= 0;
                digit_sel <= digit_sel + 1;
            end else begin
                clk_div <= clk_div + 1;
            end
        end
    end

    // ---- Kode digit_val ----
    // 0-9   = angka
    // 10    = spasi (blank)
    // 11    = huruf 'S'
    // 13    = huruf 'w' (approx)
    // 14    = huruf 'y'
    //
    // Format 8 digit (digit 7=kiri, digit 0=kanan):
    // digit[7] = 'w'         (label huruf w)
    // digit[6] = nilai w     (0 atau 1)
    // digit[5] = 'y'         (label huruf y)
    // digit[4] = nilai y     (0 atau 1)  ? Mealy: 1 bit saja
    // digit[3] = spasi
    // digit[2] = 'S'         (mewakili 'St')
    // digit[1] = Q1          (bit1 state, biner)
    // digit[0] = Q0          (bit0 state, biner)

    reg [3:0] digit_val;

    always @(*)
    begin
        case (digit_sel)
            3'd7: digit_val = 4'd13;               // huruf 'w'
            3'd6: digit_val = {3'b000, w};         // nilai w (0 atau 1)
            3'd5: digit_val = 4'd14;               // huruf 'y'
            3'd4: digit_val = {3'b000, y};         // nilai y (0 atau 1)
            3'd3: digit_val = 4'd10;               // spasi
            3'd2: digit_val = 4'd11;               // huruf 'S'
            3'd1: digit_val = {3'b000, state[1]};  // Q1 (biner)
            3'd0: digit_val = {3'b000, state[0]};  // Q0 (biner)
            default: digit_val = 4'd10;
        endcase
    end

    // ---- Anode selector (active-low) ----
    always @(digit_sel)
    begin
        case (digit_sel)
            3'd0: anode = 8'b11111110;
            3'd1: anode = 8'b11111101;
            3'd2: anode = 8'b11111011;
            3'd3: anode = 8'b11110111;
            3'd4: anode = 8'b11101111;
            3'd5: anode = 8'b11011111;
            3'd6: anode = 8'b10111111;
            3'd7: anode = 8'b01111111;
            default: anode = 8'b11111111;
        endcase
    end

    // ---- Segment decoder (active-low) ----
    always @(digit_val)
    begin
        case (digit_val)
            4'd0:  seg = 7'b0000001; // '0': a,b,c,d,e,f
            4'd1:  seg = 7'b1001111; // '1': b,c
            4'd2:  seg = 7'b0010010; // '2': a,b,d,e,g
            4'd3:  seg = 7'b0000110; // '3': a,b,c,d,g
            4'd4:  seg = 7'b1001100; // '4': b,c,f,g
            4'd5:  seg = 7'b0100100; // '5': a,c,d,f,g
            4'd6:  seg = 7'b0100000; // '6': a,c,d,e,f,g
            4'd7:  seg = 7'b0001111; // '7': a,b,c
            4'd8:  seg = 7'b0000000; // '8': semua on
            4'd9:  seg = 7'b0000100; // '9': a,b,c,d,f,g
            4'd10: seg = 7'b1111111; // spasi: semua off
            4'd11: seg = 7'b0100100; // 'S': a,c,d,f,g
            4'd13: seg = 7'b1000001; // 'w' approx ? 'u': c,d,e,f
            4'd14: seg = 7'b1000100; // 'y': b,c,d,f,g
            default: seg = 7'b1111111;
        endcase
    end

endmodule