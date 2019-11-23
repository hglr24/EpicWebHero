onerror {exit -code 1}
vlib work
vlog -work work epic_web_hero.vo
vlog -work work random_num_gen_tester.vwf.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.random_num_gen_vlg_vec_tst -voptargs="+acc"
vcd file -direction epic_web_hero.msim.vcd
vcd add -internal random_num_gen_vlg_vec_tst/*
vcd add -internal random_num_gen_vlg_vec_tst/i1/*
run -all
quit -f
