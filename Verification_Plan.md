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

### VGA
Verify the correct properties of VGA, especially a checker for character display. Then inject bug for DLS check.
#### Properties
##### Character Display
Give a random HWDATA, set other parameter correctly
- HSYNC will give the a zero pulse to start the line
- Vertical sync will give a zero pulse to start a new frame
- all the text will display in the display region
##### DLS
When the ouput is different between AHBVGA and AHBVGA_redundant, will give a DLS_ERROR output.
Write a monitor to check the output information, whether it can output the correct signal, and display it.

#### Ways
##### Properties Check
- Give random 2 frame input to HWDATA, set other parameter(addr, sel...) correctly.
- check whether the VGA can give two frame output, 
- check when in the display region ,there will always be valid data.
- print the output to a file

##### Inject Bug
Deliberately set the the redundant AHBVGA with different input data, check whether the DLS_ERROR can give out successfully.s



