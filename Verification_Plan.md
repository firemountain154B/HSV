# Hardware and Software Acceleration Verification Plan
## Peripheral Part
### GPIO
#### Goal
Verify the correct behavior of GPIO, specifically when it operates at the AHB to GPIO and GPIO to AHB model, it can work successfully. Test its parity check function. 
#### Properties
##### HWDATA to GPIOOUT
Give random input to the HWDATA, set other parameter(addr, sel...) correctly, test 
- the direction signal correctly set
- the GPIOOUT[15:0] signal is the same with input
- parity signal correctly generate
##### GPIOIN to HRDATA
Give random input to the GPIOIN[15:0], set other parameter(addr, sel...) correctly, test  
- the direction signal correctly set
- the HRDATA[15:0] signal is the same with input
- ParityERR signal can always detect the error(when deliberately set the wrong parity to input)
#### Timing Verification
After two cycles for start-up transmission. Output always appear at the next cycle of the input.
#### Exit criteria
It should not be any bug, when transfer the transmission mode, between 3 stage, reset, send ,receive.
So test 2 different sets.
- reset - send - receive - reset
- reset - receive - send - reset
