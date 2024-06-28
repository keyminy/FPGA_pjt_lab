`timescale 1ns / 1ps

module btn_cnt_seg_test_a(
    input btnl, // High Active Reset
    input btnr, // Tact switch input 
    input clk, // 100MHz Clock Input
   input [3:0] sw,
   output [3:0] an,
   output dp,
   output [6:0] seg, //dp,g,~a
   output [3:0] led
    );
    wire rst;
    wire key0;
    reg key1;
    reg [3:0] cnt;

    wire [7:0] seg_d;
   
    wire [2:0] sel;
    wire [3:0] din;

    assign sel = (sw==4'h7)?3'd0:
                (sw==4'hb)?3'd1:
                (sw==4'hd)?3'd2:
                (sw==4'he)?3'd3: 3'd7;


    hex2seg u_hex2seg_0(
        .sel(sel),
        .din(cnt),
        .seg_d(seg_d)
    );
    
    assign an = sw;
    assign dp = ~seg_d[7];
    assign seg = ~seg_d[6:0];

    // btn은 누를때 high
    // negedge를 reset으로 써야함
    assign rst = ~btnl;
    assign led = cnt;
    
    debounce u_debounce_0(
        .rst(rst),
        .clk(clk),
        .btnr(btnr),
        .key(key0)
    );

    always @(negedge rst,posedge clk) begin
        if(rst == 0) begin
            cnt <= 0;
            key1 <= 0;
        end
        else begin
            key1 <= key0;
            if(key0 & ~key1)
                cnt <= cnt + 1;
        end
    end
endmodule