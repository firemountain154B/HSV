# Hardware and Software Acceleration Verification Plan
## Peripheral Part
### GPIO
#### Goal
Verify the correct behavior of GPIO, especially when it operates at the AHB to GPIO and GPIO to AHB model. Test its parity check function. 
#### Properties
##### Receive Data
Give random input to the HWDATA, set other parameter(addr, sel...) correctly, test 
- the direction signal correctly set
- the GPIOOUT[15:0] signal is the same with input
##### Send Data
Give random input to the GPIOIN[15:0], set other parameter(addr, sel...) correctly, test  
- the direction signal correctly set
- the HRDATA[15:0] signal is the same as input
#### Parity Generate/Check
- when GPIO sends data to AHB, generate an additional parity bit
- when GPIO receive data from AHB, check if the parity bit matches with the data
#### Timing Verification
After the start-up stage, output always appears at one cycles behind the input.

#### Constrained Randomisation


is it required?
#### Mode Changing
There should not be any bugs, when changing the transmission mode, between 3 stage, reset, send ,receive.
So test 2 different sets.
- reset - send - receive - reset
- reset - receive - send - reset
