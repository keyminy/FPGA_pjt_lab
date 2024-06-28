restart 
#high active reset
add_force btnl {0 0ns} {1 1ps} {0 10ns} 
add_force clk {0 0ns} {1 5ns} -repeat_every 10ns
# 1ms단위로 check하기때문에, glitch를 1ms보다 짧게주면 check못할 수 있다
add_force btnr 0
run 15ms
add_force btnr 1
run 2ms
add_force btnr 0
run 1ms
add_force btnr 1
run 35ms