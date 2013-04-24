*******************************************************************************
** ©2001—2008 Xilinx, Inc. All Rights Reserved.
** Confidential and proprietary information of Xilinx, Inc. 
*******************************************************************************
**   ____  ____ 
**  /   /\/   / 
** /___/  \  /   Vendor: Xilinx 
** \   \   \/    Version: 1.1
**  \   \        Filename: readme.txt
**  /   /        Date Last Modified: 4/23/08
** /___/   /\    Date Created: 1/18/01
** \   \  /  \ 
**  \___\/\___\ 
** 
**  Device: Virtex, Virtex-E, and Spartan-II FPGAs
**  Purpose: UART_TX and UART_RX macros
**  Reference: XAPP223
**  Revision History: Added recommended location for current macros in note.
**   
*******************************************************************************
**
**  Disclaimer: 
**
**		Xilinx licenses this Design to you “AS-IS” with no warranty of any kind.  
**		Xilinx does not warrant that the functions contained in the Design will 
**		meet your requirements,that the Design will operate uninterrupted or be 
**		error-free, or that errors or bugs in the Design will be corrected.  
**		Xilinx makes no warranties or representations in regard to the results 
**		obtained from your use of the Design with respect to accuracy, reliability, 
**		or otherwise.  
**
**		XILINX MAKES NO REPRESENTATIONS OR WARRANTIES, WHETHER EXPRESS OR IMPLIED, 
**		STATUTORY OR OTHERWISE, INCLUDING, WITHOUT LIMITATION, IMPLIED WARRANTIES 
**		OF MERCHANTABILITY, NONINFRINGEMENT, OR FITNESS FOR A PARTICULAR PURPOSE. 
**		IN NO EVENT WILL XILINX BE LIABLE FOR ANY LOSS OF DATA, LOST PROFITS, OR FOR 
**		ANY SPECIAL, INCIDENTAL, CONSEQUENTIAL, OR INDIRECT DAMAGES ARISING FROM 
**		YOUR USE OF THIS DESIGN. 

*******************************************************************************


                 UART_TX and UART_RX   version 1.1
                 ----------------------------------

              UART Receiver with internal 16-byte buffer

                               and

              UART Transmitter with internal 16-byte buffer

                               for 

                 Virtex, Virtex-E and Spartan-II FPGAs
                 -------------------------------------

Author
------

Ken Chapman
Xilinx UK
October 2000

email: chapman@xilinx.com



*********************************************************************************
NOTE: Refer to the PicoBlaze processor website at http://www.xilinx.com/picoblaze
for more up-to-date UART_TX and UART_RX macros in source VHDL and Verilog. These
macros are part of the PicoBlaze processor file bundle. The implementations of 
these macros are improved and now include a half-full flag in the FIFO buffer.

*********************************************************************************



Introduction
------------

These small UART transmitter and receiver macros of just 7 and 8 Virtex CLBs respectively
provides all the functionality of a standard UART together with internal 16-byte FIFO
buffers.


Macro Details  
-------------

Full details are provided in application note XAPP223.

The serial transmission conforms to 1 start bit, 8 data bits, 1 stop bit. The bit rate 
is determined by the user application of a reference timing source.


Applications
------------

Suitable for linking a Xilinx device to an external micro-controller or PC using standard
BAUD rates. 

Also possible to use in communicating between Xilinx devices in a system at over 10Mbit/sec.


Testing and Performance
-----------------------

The macros have been developed over a long period of time during which testing has included 
communication between a PC and PDA and a Virtex device with no errors being encountered.

The internal buffers are based on previous work available under the title BBFIFO which 
has also received a longer testing period without error.

The macros have also be used with an embedded micro-controller macro called KCPSM (see
XAPP223 for more details). 


Using UART_TX and UART_RX in designs
------------------------------------

The macros are in the form of a EDIF (.edn) files which can be used within any Virtex 
or Spartan-II design. The macro should be treated as a 'black box' in the design.

Examples of connectivity, and complete signal descriptions are provided in XAPP223.

In VHDL, the macros can be instantiated using the port definitions decribed

component uart_tx is
  port (            din : in STD_LOGIC_VECTOR (7 downto 0);
                  write : in  STD_LOGIC;
           reset_buffer : in  STD_LOGIC;
           en_16_x_baud : in  STD_LOGIC;
                    clk : in  STD_LOGIC;
             serial_out : out STD_LOGIC;
            buffer_full : out STD_LOGIC);
  end component; 

component uart_rx is
  port (      serial_in : in  STD_LOGIC;
                   read : in  STD_LOGIC;
           reset_buffer : in  STD_LOGIC;
           en_16_x_baud : in  STD_LOGIC;
                    clk : in  STD_LOGIC;
                   dout : out STD_LOGIC_VECTOR (7 downto 0);
           data_present : out STD_LOGIC;
            buffer_full : out STD_LOGIC);
  end component; 


Foundation users can use the Schematic feature 'create macro symbol from netlist' to be
found under the 'Hierarchy' menu.

The 'CLK' signal should be provided using one of the global clock buffers. 

Time specifications should be provided which must cover the use of 'FFS:TO:FFS'.

Example time specifications for 100MHz operation

   TS01=FROM:FFS:TO:FFS:10NS


Issues with brackets
--------------------

The EDIF netlist assumes that bus signals (the 'DIN' and 'DOUT' buses in this case)
are defined using <> type of brackets. Some tools may define the ports to a 'black box'
to be of a different type and this may prevent the correct inclusion of the macro into the
complete design.

Some tools allow the definition of the brackets to be specified, in which case define the 
use of <> type.

In the case where alternative brackets are required, a simple modification
can be performed using a text editor. Simply open the EDN files and 
replace all instances of '<' and '>' with the desired format. 


Future Plans
------------

To provide UARTs with built in parity checking.
To provide a Rx-Tx combination with automatic XON/XOFF handling.


Feedback
--------

Please inform the author if you have used these macros stating:-

1) Your name, Company name, and Location.
2) The version.
3) If the results were satisfactory.
4) Alternative implementations you would like to see (Please state the application).
6) In cases of difficulty, please supply version details and implementation
   tools. 


---------------------------------------------------------------------------------------
End of Readme.txt file
---------------------------------------------------------------------------------------
 