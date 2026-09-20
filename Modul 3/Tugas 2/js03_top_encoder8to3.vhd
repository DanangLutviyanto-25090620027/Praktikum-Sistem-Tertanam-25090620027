library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity js03_top is
    Port (
        sw  : in  STD_LOGIC_VECTOR (15 downto 0);
        led : out STD_LOGIC_VECTOR (3 downto 0)
    );
end js03_top;

architecture Behavioral of js03_top is

    component leading_one_detector
        Port (
            input_data : in  STD_LOGIC_VECTOR (7 downto 0);
            pos        : out STD_LOGIC_VECTOR (2 downto 0);
            valid      : out STD_LOGIC
        );
    end component;

    signal pos_signal   : STD_LOGIC_VECTOR (2 downto 0);
    signal valid_signal : STD_LOGIC;

begin

    ENCODER_INSTANCE : leading_one_detector
        port map (
            input_data => sw(7 downto 0),
            pos        => pos_signal,
            valid      => valid_signal
        );

    -- LED2..LED0 = posisi bit
    led(2 downto 0) <= pos_signal;

    -- LED3 = valid
    led(3) <= valid_signal;

end Behavioral;