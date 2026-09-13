library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_mux8to1 is
end tb_mux8to1;

architecture Behavioral of tb_mux8to1 is

    component mux8to1
        Port (
            sel : in  STD_LOGIC_VECTOR (2 downto 0);
            in0 : in  STD_LOGIC_VECTOR (3 downto 0);
            in1 : in  STD_LOGIC_VECTOR (3 downto 0);
            in2 : in  STD_LOGIC_VECTOR (3 downto 0);
            in3 : in  STD_LOGIC_VECTOR (3 downto 0);
            in4 : in  STD_LOGIC_VECTOR (3 downto 0);
            in5 : in  STD_LOGIC_VECTOR (3 downto 0);
            in6 : in  STD_LOGIC_VECTOR (3 downto 0);
            in7 : in  STD_LOGIC_VECTOR (3 downto 0);
            y   : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    signal sel : STD_LOGIC_VECTOR (2 downto 0);
    signal in0 : STD_LOGIC_VECTOR (3 downto 0);
    signal in1 : STD_LOGIC_VECTOR (3 downto 0);
    signal in2 : STD_LOGIC_VECTOR (3 downto 0);
    signal in3 : STD_LOGIC_VECTOR (3 downto 0);
    signal in4 : STD_LOGIC_VECTOR (3 downto 0);
    signal in5 : STD_LOGIC_VECTOR (3 downto 0);
    signal in6 : STD_LOGIC_VECTOR (3 downto 0);
    signal in7 : STD_LOGIC_VECTOR (3 downto 0);
    signal y   : STD_LOGIC_VECTOR (3 downto 0);

begin

    uut: mux8to1
        port map (
            sel => sel,
            in0 => in0,
            in1 => in1,
            in2 => in2,
            in3 => in3,
            in4 => in4,
            in5 => in5,
            in6 => in6,
            in7 => in7,
            y   => y
        );

    stimulus: process
    begin

        in0 <= "0001";
        in1 <= "0010";
        in2 <= "0011";
        in3 <= "0100";
        in4 <= "0101";
        in5 <= "0110";
        in6 <= "0111";
        in7 <= "1000";

        sel <= "000";
        wait for 50 ns;

        sel <= "001";
        wait for 50 ns;

        sel <= "010";
        wait for 50 ns;

        sel <= "011";
        wait for 50 ns;

        sel <= "100";
        wait for 50 ns;

        sel <= "101";
        wait for 50 ns;

        sel <= "110";
        wait for 50 ns;

        sel <= "111";
        wait for 50 ns;

        wait;
    end process;

end Behavioral;