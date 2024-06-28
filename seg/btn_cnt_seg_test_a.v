`timescale 1ns / 1ps

module btn_cnt_seg_test_a(
    input btnl, // High Active Reset
    input btnr, // Tact switch input 
    input clk, // 100MHz Clock Input
   input [3:0] sw, // segment자릿수 선택,an과 연결됨
   output [3:0] an,
   output dp, // all zero
   output [6:0] seg, //dp,g,~a
   output [3:0] led // counter값에따라 증가하여 led불
    );
    wire rst;
    wire key0;
    reg key1;
    reg [3:0] cnt;

    wire [7:0] seg_d; // seven_segment decoder의 출력
   
    wire [2:0] sel; // 외부의 sw입력을 받음
    wire [3:0] din;

    assign sel = (sw==4'b0111)?3'd0: // 맨왼쪽 digit일때, select값 0
                (sw==4'b1011)?3'd1: 
                (sw==4'b1101)?3'd2:
                (sw==4'b1110)?3'd3: 3'd7;
                //select값 0,1,2,3은 정상범위이고 7일때 값은 에러임

    hex2seg u_hex2seg_0(
        .sel(sel), // 변화준 부분
        .din(cnt),
        .seg_d(seg_d)
    );
    
    assign an = ~sw;// high active display 
    assign dp = ~seg_d[7]; // low active display
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