----------------------------------------------------------------------------------
-- Company: Gadget Factory
-- Engineer: Jack Gassett
-- 
-- Create Date:    22:31:30 11/27/2010 
-- Design Name: 
-- Module Name:    UARTExample - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Example code for implementing the Xilinx UART example on the Papilio One.
--               http://www.xilinx.com/support/documentation/application_notes/xapp223.pdf
-- Dependencies: 
--						Requires the latest Picoblaze source code. Xilinx EULA does not allow the redistribution of Source code so the source modules must be downloaded seperately.
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UARTExample is
    Port ( rx : in  STD_LOGIC;
           tx : out  STD_LOGIC;
			  extclk : in STD_LOGIC
			  );
end UARTExample;



architecture Behavioral of UARTExample is

component uart_tx is
  port (            data_in : in std_logic_vector(7 downto 0);
                 write_buffer : in std_logic;
                 reset_buffer : in std_logic;
                 en_16_x_baud : in std_logic;
                   serial_out : out std_logic;
                  buffer_full : out std_logic;
             buffer_half_full : out std_logic;
                          clk : in std_logic);
  end component; 

component uart_rx is
  port (      serial_in : in  STD_LOGIC;
                   read_buffer : in  STD_LOGIC;
           reset_buffer : in  STD_LOGIC;
           en_16_x_baud : in  STD_LOGIC;
                    clk : in  STD_LOGIC;
                   data_out : out STD_LOGIC_VECTOR (7 downto 0);
           buffer_data_present : out STD_LOGIC;
			  buffer_half_full : out STD_LOGIC;
            buffer_full : out STD_LOGIC);
  end component; 
  
	COMPONENT dcm32to96
	PORT(
		CLKIN_IN : IN std_logic;          
		CLKFX_OUT : OUT std_logic;
		CLKIN_IBUFG_OUT : OUT std_logic;
		CLK0_OUT : OUT std_logic
		);
	END COMPONENT;	

signal dout : STD_LOGIC_VECTOR (7 downto 0);
signal data_present, en_16_x_baud, clk, clk32 : STD_LOGIC;
signal baud_count : integer range 0 to 5 :=0;


begin

baud_timer: process(clk)
begin
	if clk'event and clk='1' then
		if baud_count=1 then
			baud_count <= 0;
			en_16_x_baud <= '1';
		else
			baud_count <= baud_count + 1;
			en_16_x_baud <= '0';
		end if;
	end if;
end process baud_timer;

	Inst_dcm32to96: dcm32to96 PORT MAP(
		CLKIN_IN => extclk,
		CLKFX_OUT => clk,
		CLKIN_IBUFG_OUT => open,
		CLK0_OUT => open
	);		

INST_UART_TX : uart_tx
port map (
   data_in => dout,
   write_buffer => data_present,
   reset_buffer => '0',
   en_16_x_baud => en_16_x_baud,
   clk => clk,
   serial_out => tx,
	buffer_half_full => open,
   buffer_full => open
);

INST_UART_RX : uart_rx
port map (
   serial_in => rx,
   read_buffer => '1',
   reset_buffer => '0',
   en_16_x_baud => en_16_x_baud,
   clk => clk,
   data_out => dout,
   buffer_data_present => data_present,
	buffer_half_full => open,
	buffer_full => open
);


end Behavioral;

