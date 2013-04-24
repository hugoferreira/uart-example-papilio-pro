library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity UARTExample is
    Port (     rx : in  std_logic;
               tx : out std_logic;
			  extclk : in  std_logic);
end UARTExample;

architecture Behavioral of UARTExample is

component uart_tx6 is
	port (             data_in : in  std_logic_vector(7 downto 0);
					  buffer_write : in  std_logic;
					  buffer_reset : in  std_logic;
					  en_16_x_baud : in  std_logic;
			 buffer_data_present : out std_logic;
						 serial_out : out std_logic;
						buffer_full : out std_logic;
				 buffer_half_full : out std_logic;
								  clk : in  std_logic);
end component; 

component uart_rx6 is
  port (            serial_in : in  std_logic;
                  buffer_read : in  std_logic;
                 buffer_reset : in  std_logic;
				     en_16_x_baud : in  std_logic;
                          clk : in  std_logic;
                     data_out : out std_logic_vector(7 downto 0);
          buffer_data_present : out std_logic;
		       buffer_half_full : out std_logic;
                  buffer_full : out std_logic);
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
signal data_present, en_16_x_baud, clk : STD_LOGIC;
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

impl_uart_tx: uart_tx6
port map (
   data_in => dout,
   buffer_write => data_present,
   buffer_reset => '0',
   en_16_x_baud => en_16_x_baud,
   clk => clk,
   serial_out => tx,
	buffer_half_full => open,
   buffer_full => open
);

impl_uart_rx6 : uart_rx6
port map (
   serial_in => rx,
   buffer_read => '1',
   buffer_reset => '0',
   en_16_x_baud => en_16_x_baud,
   clk => clk,
   data_out => dout,
   buffer_data_present => data_present,
	buffer_half_full => open,
	buffer_full => open
);

Inst_dcm32to96: dcm32to96 PORT MAP(
	CLKIN_IN => extclk,
	CLKFX_OUT => clk,
	CLKIN_IBUFG_OUT => open,
	CLK0_OUT => open
);	

end Behavioral;

