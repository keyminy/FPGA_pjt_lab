`timescale 1ns / 1ps

module debounce(
    input btnr,
    input clk,rst,
    output reg key
    );
    reg [15:0] cnt; // 5만 분주
    reg pls_1k0,pls_1k1;

    reg btn0,btn1;
    reg [4:0] btn_cnt; // 31분주
    
    always @(negedge rst or posedge clk) begin
        if(rst == 0) begin
            btn0 <= 0;
            btn1 <= 0;
            btn_cnt <= 0;
            key <= 0;
        end else if(pls_1k0 & ~pls_1k1) begin
            //rising edge검출
            btn0 <= btnr;
            btn1 <= btn0;
            if(btn0 ^ btn1)
                btn_cnt <= 0;
            else if(btn_cnt < 30)
                btn_cnt <= btn_cnt + 1;
            if(btn_cnt == 29)
                key <= btn1;
        end
    end

    always @(negedge rst or posedge clk) begin
        if(rst == 0) begin
            cnt <= 0;
            pls_1k0<=0;
            pls_1k1<=0;
        end
        else begin
            pls_1k1 <= pls_1k0;
            if(cnt < 50000-1)
                cnt <= cnt + 1;
            else begin
                cnt <= 0;
                pls_1k0 <= ~pls_1k0;
                // pls_1k1 <= pls_1k0; //err
            end
        end
    end
endmodule