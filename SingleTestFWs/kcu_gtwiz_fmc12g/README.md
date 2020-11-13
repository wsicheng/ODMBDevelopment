# Example design for gtwizard
To test using the customized protocol for gtwizard to transmit and receive data

## Configuration

Operation device: KCU105 test board, with FMC loopback card installed
Ports: 4 ports from bank 227, looped back using the FMC HPC ports
Encoding: Synchronize Gear Box 64B/66B 

## Hardware validation
Currently only VIO ports

### Init procedure
- Open Hardware Manager
- Load firmware
- Open the VIO dashboard, add all probes
- Change the output value of `hb_gtwiz_reset_all_vio_int` to 1 for a short time
- Change the value of `rxdata_errctr_reset_vio_int` to 1 for a short time
- Verify that the variable `rxdata_err_ctr_sync[15:0]` is set to 0 and stays 0
- The number of datapackets received after the reset can be monitored by the value in
  `rxdata_nml_ctr_s30_sync[15:0]` times 2^30
  - nml: normal, ctr: counter, s30: start with bit 30
