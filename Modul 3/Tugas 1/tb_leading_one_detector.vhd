library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_leading_one_detector is
end tb_leading_one_detector;

architecture Behavioral of tb_leading_one_detector is

    component leading_one_detector
        Port (
            input_data : in  STD_LOGIC_VECTOR (7 downto 0);
            pos        : out STD_LOGIC_VECTOR (2 downto 0);
            valid      : out STD_LOGIC
        );
    end component;

    signal input_data : STD_LOGIC_VECTOR (7 downto 0);
    signal pos        : STD_LOGIC_VECTOR (2 downto 0);
    signal valid      : STD_LOGIC;

begin

    uut: leading_one_detector
        port map (
            input_data => input_data,
            pos        => pos,
            valid      => valid
        );

    process
    begin

        input_data <= "00000000";
        wait for 10 ns;

        assert (pos = "000" and valid = '0')
            report "ERROR Test 1"
            severity error;


        input_data <= "00000001";
        wait for 10 ns;

        assert (pos = "000" and valid = '1')
            report "ERROR Test 2"
            severity error;


        input_data <= "00001000";
        wait for 10 ns;

        assert (pos = "011" and valid = '1')
            report "ERROR Test 3"
            severity error;


        input_data <= "00100000";
        wait for 10 ns;

        assert (pos = "101" and valid = '1')
            report "ERROR Test 4"
            severity error;


        input_data <= "10000000";
        wait for 10 ns;

        assert (pos = "111" and valid = '1')
            report "ERROR Test 5"
            severity error;


        input_data <= "11001010";
        wait for 10 ns;

        assert (pos = "111" and valid = '1')
            report "ERROR Test 6"
            severity error;


        input_data <= "00010100";
        wait for 10 ns;

        assert (pos = "100" and valid = '1')
            report "ERROR Test 7"
            severity error;


        report "SEMUA TEST LEADING ONE DETECTOR BERHASIL."
            severity note;

        wait;

    end process;

end Behavioral;