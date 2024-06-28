`timescale 1ns / 1ps

module btn_cnt_test(
    input btnl, // High Active Reset
    input btnr, // Tact switch input 
    input clk, // 100MHz Clock Input
    output [15:0] led
    );
    wire rst;
    wire key0;
    reg key1;
    reg [15:0] cnt;
    
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