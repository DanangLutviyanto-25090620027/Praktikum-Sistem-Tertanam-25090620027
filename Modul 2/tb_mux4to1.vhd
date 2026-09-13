library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_mux4to1 is
end tb_mux4to1;

architecture Behavioral of tb_mux4to1 is

    component mux4to1
        Port (
            sel : in STD_LOGIC_VECTOR (1 downto 0);
            in0 : in STD_LOGIC_VECTOR (3 downto 0);
            in1 : in STD_LOGIC_VECTOR (3 downto 0);
            in2 : in STD_LOGIC_VECTOR (3 downto 0);
            in3 : in STD_LOGIC_VECTOR (3 downto 0);
            y   : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    signal sel : STD_LOGIC_VECTOR (1 downto 0);
    signal in0 : STD_LOGIC_VECTOR (3 downto 0);
    signal in1 : STD_LOGIC_VECTOR (3 downto 0);
    signal in2 : STD_LOGIC_VECTOR (3 downto 0);
    signal in3 : STD_LOGIC_VECTOR (3 downto 0);
    signal y   : STD_LOGIC_VECTOR (3 downto 0);

begin

    uut: mux4to1
        port map (
            sel => sel,
            in0 => in0,
            in1 => in1,
            in2 => in2,
            in3 => in3,
            y   => y
        );

    stimulus: process
    begin
        in0 <= "0001";
        in1 <= "0010";
        in2 <= "0011";
        in3 <= "0100";

        sel <= "00";
        wait for 50 ns;
        assert y = in0
            report "Gagal: sel=00, y tidak sama dengan in0"
            severity error;

        sel <= "01";
        wait for 50 ns;
        assert y = in1
            report "Gagal: sel=01, y tidak sama dengan in1"
            severity error;

        sel <= "10";
        wait for 50 ns;
        assert y = in2
            report "Gagal: sel=10, y tidak sama dengan in2"
            severity error;

        sel <= "11";
        wait for 50 ns;
        assert y = in3
            report "Gagal: sel=11, y tidak sama dengan in3"
            severity error;

        wait;
    end process;

end Behavioral;