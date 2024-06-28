`timescale 1ns / 1ps

module btn_led_test(
    input btnl,
    input btnr,
    output ld0,
    output ld15
    );
    assign ld0 = btnr;
    assign ld15 = btnl;
endmodule
