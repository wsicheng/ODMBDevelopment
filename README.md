# ODMB Development Codes

To store the individual user code for ODMB developments

## TestBenches

The module tests based on a common testbench template for KCU105

## OpticalTests

Optical test firmwares for KCU105 and ODMB7.

- **OpticalTests/kcu_ibert_gth**
  A VHDL rewrite of the example design, with different number of quads for MGT current recording.

- **OpticalTests/odmb7_ibert_gth**
  Holds several IBERT configs, with different number of quads and reference clock options.
  For more details see the `README.md` file inside the subfolder.

- **OpticalTests/kcu_gtwiz_fmc12g**
  A small extension of the example design in Verilog. Configured the 8 lines on the FMC loopback card to 12.48 Gb/s line rate.
  Featuring a possibility to do user data generation and a receiver error counter connected to the VIO.

- **OpticalTests/kcu_gtwiz_test**
  Tests in development for the transceiver wrappers.

