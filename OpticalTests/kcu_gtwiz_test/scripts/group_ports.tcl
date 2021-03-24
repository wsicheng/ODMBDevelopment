
create_hw_probe -map {probe0[31:0]}   userdata_rx_0[31:0] [get_hw_ilas hw_ila_1]
create_hw_probe -map {probe0[63:32]}  userdata_rx_1[31:0] [get_hw_ilas hw_ila_1]
create_hw_probe -map {probe0[79:64]}  rxdata_ctr_0[15:0]  [get_hw_ilas hw_ila_1]
create_hw_probe -map {probe0[95:80]}  rxdata_ctr_1[15:0]  [get_hw_ilas hw_ila_1]
create_hw_probe -map {probe0[103:96]}   ch0_rxctrl2[7:0]   [get_hw_ilas hw_ila_1]
create_hw_probe -map {probe0[111:104]}  ch1_rxctrl2[7:0]   [get_hw_ilas hw_ila_1]
create_hw_probe -map {probe0[113:112]}  rxbyteisaligned_i[1:0] [get_hw_ilas hw_ila_1]
create_hw_probe -map {probe0[115:114]}  rxbyterealign_i[1:0]   [get_hw_ilas hw_ila_1]
create_hw_probe -map {probe0[117:116]}  rxcommadet_i[1:0]      [get_hw_ilas hw_ila_1]
create_hw_probe -map {probe0[119:118]}  prbs_match_i[1:0]      [get_hw_ilas hw_ila_1]
create_hw_probe -map {probe0[135:120]}  rxdata_errctr_0[15:0]      [get_hw_ilas hw_ila_1]
create_hw_probe -map {probe0[151:136]}  rxdata_errctr_1[15:0]      [get_hw_ilas hw_ila_1]
create_hw_probe -map {probe0[191:152]}  rxdata_nmlctr_i[39:0]      [get_hw_ilas hw_ila_1]

# add_wave -into {hw_ila_data_1.wcfg} -radix hex { {userdata_rx_0} }
# add_wave -into {hw_ila_data_1.wcfg} -radix hex { {userdata_rx_1} }
# add_wave -into {hw_ila_data_1.wcfg} -radix hex { {rxdata_ctr_0}  }
# add_wave -into {hw_ila_data_1.wcfg} -radix hex { {rxdata_ctr_1}  }

# add_wave -into {hw_ila_data_1.wcfg} -radix hex  { {ch0_rxctrl2} }
# add_wave -into {hw_ila_data_1.wcfg} -radix hex  { {ch1_rxctrl2} }
# add_wave -into {hw_ila_data_1.wcfg} -radix hex  { {rxbyteisaligned_i} }
# add_wave -into {hw_ila_data_1.wcfg} -radix hex  { {rxbyterealign_i} }
# add_wave -into {hw_ila_data_1.wcfg} -radix hex  { {rxcommadet_i} }
# add_wave -into {hw_ila_data_1.wcfg} -radix hex  { {prbs_match_i} }
# add_wave -into {hw_ila_data_1.wcfg} -radix hex  { {rxdata_errctr_0} }
# add_wave -into {hw_ila_data_1.wcfg} -radix hex  { {rxdata_errctr_1} }
# add_wave -into {hw_ila_data_1.wcfg} -radix hex  { {rxdata_nmlctr_i} }

# create_hw_probe -map {probe0[97:96]}  rxdata_valid_int[1:0]   [get_hw_ilas hw_ila_1]
# create_hw_probe -map {probe0[99:98]}  bad_rx_int[1:0]         [get_hw_ilas hw_ila_1]
# create_hw_probe -map {probe0[100]}    hb_gtwiz_reset_all_int  [get_hw_ilas hw_ila_1]

# add_wave -into {hw_ila_data_1.wcfg} -radix hex { {rxdata_valid_int} }
# add_wave -into {hw_ila_data_1.wcfg} -radix hex { {bad_rx_int} }
# add_wave -into {hw_ila_data_1.wcfg} -radix hex { {hb_gtwiz_reset_all_int} }

# # MGT_DDU
# create_hw_probe -map {probe0[15:0]}  rxdata_ddu_ch1[15:0] [get_hw_ilas hw_ila_4]
# create_hw_probe -map {probe0[31:16]} rxdata_ddu_ch2[15:0] [get_hw_ilas hw_ila_4]
# create_hw_probe -map {probe0[47:32]} rxdata_ddu_ch3[15:0] [get_hw_ilas hw_ila_4]
# create_hw_probe -map {probe0[63:48]} rxdata_ddu_ch4[15:0] [get_hw_ilas hw_ila_4]
# create_hw_probe -map {probe0[65:64]} codevalid_ch1[1:0] [get_hw_ilas hw_ila_4]
# create_hw_probe -map {probe0[69:68]} codevalid_ch3[1:0] [get_hw_ilas hw_ila_4]
# create_hw_probe -map {probe0[73:70]} rxbyteisaligned_int[3:0] [get_hw_ilas hw_ila_4]
# create_hw_probe -map {probe0[77:74]} rxbyterealign_int[3:0] [get_hw_ilas hw_ila_4]
# create_hw_probe -map {probe0[79:78]} rxnotintable_ch1[1:0] [get_hw_ilas hw_ila_4]
# create_hw_probe -map {probe0[81:80]} rxnotintable_ch3[1:0] [get_hw_ilas hw_ila_4]
# create_hw_probe -map {probe0[83:82]} rxdisperr_ch1[1:0] [get_hw_ilas hw_ila_4]
# create_hw_probe -map {probe0[85:84]} rxdisperr_ch3[1:0] [get_hw_ilas hw_ila_4]
# create_hw_probe -map {probe0[87:86]} rxcharisk_ch1[1:0] [get_hw_ilas hw_ila_4]
# create_hw_probe -map {probe0[89:88]} rxcharisk_ch3[1:0] [get_hw_ilas hw_ila_4]
# create_hw_probe -map {probe0[91:90]} rxchariscomma_ch1[1:0] [get_hw_ilas hw_ila_4]
# create_hw_probe -map {probe0[93:92]} rxchariscomma_ch3[1:0] [get_hw_ilas hw_ila_4]
# create_hw_probe -map {probe0[97:94]} bad_rx_int[3:0] [get_hw_ilas hw_ila_4]

# create_hw_probe -map {probe0[31:0]}  userdata_tx_0[31:0] [get_hw_ilas hw_ila_2]
# create_hw_probe -map {probe0[63:32]} userdata_tx_1[31:0] [get_hw_ilas hw_ila_2]
# create_hw_probe -map {probe0[71:64]} txctrl2_0[7:0]     [get_hw_ilas hw_ila_2]
# create_hw_probe -map {probe0[79:72]} txctrl2_1[7:0]     [get_hw_ilas hw_ila_2]
# create_hw_probe -map {probe0[80]} prbs_match_gen     [get_hw_ilas hw_ila_2]
# add_wave -into {hw_ila_data_2.wcfg} -radix hex { {userdata_tx_0} }
# add_wave -into {hw_ila_data_2.wcfg} -radix hex { {userdata_tx_1} }
# add_wave -into {hw_ila_data_2.wcfg} -radix hex { {txctrl2_0} }
# add_wave -into {hw_ila_data_2.wcfg} -radix hex { {txctrl2_1} }
# add_wave -into {hw_ila_data_2.wcfg} -radix hex { {prbs_match_gen} }
