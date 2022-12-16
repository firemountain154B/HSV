# Hardware and Software Acceleration Verification Plan
## Peripheral Part
### GPIO
#### Goal
Verify the properties of GPIO, especially when it operates at the AHB to GPIO and GPIO to AHB model. Test its parity check function. 
#### Properties
##### Receive Data
- HADDR = ADDR_DIR
- HADDR = ADDR_DATA, HWDATA = DIR_RECEIVE
- GPIOIN = DATA
##### Send Data
- send HADDR = ADDR_DIR
- HADDR = ADDR_DATA, HWDATA = DIR_SEND
- HWDATA = DATA
#### Parity Generate/Check
- when GPIO sends data to AHB, generate an additional parity bit
- when GPIO receive data from AHB, check if the parity bit matches with the data
#### Timing Verification

### Ways
#### Properties Check
Give random DATA input to the GPIOIN[15:0]/HWDATA, set other parameter(addr, sel...) correctly.

Checker part, used to check the correct Timing Specification, and the correct parity function.

#### Inject Bug

When checking the reciving function, deliberately set the parrity bit wrong, then check whether the GPIO can give bug.


is it required?
(#### Mode Changing
There should not be any bugs, when changing the transmission mode, between 3 stage, reset, send ,receive.
So test 2 different sets.
- reset - send - receive - reset
- reset - receive - send - reset)

### VGA
Verify the correct behavior of VGA, especially a checker for character display. Then inject bug for DLS check.
#### Character display
Write a monitor to check the output information, whether it can output the correct signal, and display it.

#### Timing check
check whether the HSYNC and YSYNC signal generate appropriately and thentext display in the correct region.

#### DLS error
giving random to DLS unit, then give a bug in another unit, can check the DLS error is correct or not output successfully. 




