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

        -- Test 1: semua bit 0
        input_data <= "00000000";
        wait for 10 ns;

        assert (pos = "000" and valid = '0')
            report "ERROR Test 1: input 00000000"
            severity error;


        -- Test 2: bit 0 = 1
        input_data <= "00000001";
        wait for 10 ns;

        assert (pos = "000" and valid = '1')
            report "ERROR Test 2: input 00000001"
            severity error;


        -- Test 3: bit 3 = 1
        input_data <= "00001000";
        wait for 10 ns;

        assert (pos = "011" and valid = '1')
            report "ERROR Test 3: input 00001000"
            severity error;


        -- Test 4: bit 5 = 1
        input_data <= "00100000";
        wait for 10 ns;

        assert (pos = "101" and valid = '1')
            report "ERROR Test 4: input 00100000"
            severity error;


        -- Test 5: bit 7 = 1
        input_data <= "10000000";
        wait for 10 ns;

        assert (pos = "111" and valid = '1')
            report "ERROR Test 5: input 10000000"
            severity error;


        -- Test 6: beberapa bit 1
        -- Bit paling kiri adalah bit 6
        input_data <= "11001010";
        wait for 10 ns;

        assert (pos = "110" and valid = '1')
            report "ERROR Test 6: input 11001010"
            severity error;


        -- Test 7: bit 4 dan bit 2 bernilai 1
        -- Bit paling kiri adalah bit 4
        input_data <= "00010100";
        wait for 10 ns;

        assert (pos = "100" and valid = '1')
            report "ERROR Test 7: input 00010100"
            severity error;


        report "SEMUA TEST LEADING ONE DETECTOR BERHASIL."
            severity note;

        wait;

    end process;

end Behavioral;