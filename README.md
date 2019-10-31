# sISPC
analysis of sIPSC charge

Original data was recorded in Igor, using 1-min long sweeps; each sweep has a seal test.
First truncate each sweep to remove the seal test, then export each truncated sweep as a text file into a unique folder for that cell.  We use 4 sweeps per cell, which will give 4 sIPSC values as output that are averaged together.
For the folder for each cell, run the code; sIPSC charge for each text file is written into a column in the output excel file
