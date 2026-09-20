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

        -- TEST 1
        -- Tidak ada bit aktif
        input_data <= "00000000";
        wait for 10 ns;

        assert (pos = "000" and valid = '0')
            report "ERROR TEST 1: 00000000"
            severity error;


        -- TEST 2
        -- Hanya bit 0 aktif
        input_data <= "00000001";
        wait for 10 ns;

        assert (pos = "000" and valid = '1')
            report "ERROR TEST 2: 00000001"
            severity error;


        -- TEST 3
        -- Hanya bit 3 aktif
        input_data <= "00001000";
        wait for 10 ns;

        assert (pos = "011" and valid = '1')
            report "ERROR TEST 3: 00001000"
            severity error;


        -- TEST 4
        -- Hanya bit 5 aktif
        input_data <= "00100000";
        wait for 10 ns;

        assert (pos = "101" and valid = '1')
            report "ERROR TEST 4: 00100000"
            severity error;


        -- TEST 5
        -- Hanya bit 7 aktif
        input_data <= "10000000";
        wait for 10 ns;

        assert (pos = "111" and valid = '1')
            report "ERROR TEST 5: 10000000"
            severity error;


        -- TEST 6
        -- Bit 7 dan 3 aktif
        -- Prioritas harus bit 7
        input_data <= "10001000";
        wait for 10 ns;

        assert (pos = "111" and valid = '1')
            report "ERROR TEST 6: 10001000"
            severity error;


        -- TEST 7
        -- Bit 6 dan 2 aktif
        -- Prioritas harus bit 6
        input_data <= "01000100";
        wait for 10 ns;

        assert (pos = "110" and valid = '1')
            report "ERROR TEST 7: 01000100"
            severity error;


        -- TEST 8
        -- Bit 5, 3 dan 1 aktif
        -- Prioritas harus bit 5
        input_data <= "00101010";
        wait for 10 ns;

        assert (pos = "101" and valid = '1')
            report "ERROR TEST 8: 00101010"
            severity error;


        -- TEST 9
        -- Bit 4 dan 0 aktif
        -- Prioritas harus bit 4
        input_data <= "00010001";
        wait for 10 ns;

        assert (pos = "100" and valid = '1')
            report "ERROR TEST 9: 00010001"
            severity error;


        -- TEST 10
        -- Semua bit aktif
        -- Prioritas harus bit 7
        input_data <= "11111111";
        wait for 10 ns;

        assert (pos = "111" and valid = '1')
            report "ERROR TEST 10: 11111111"
            severity error;


        report "SEMUA TEST PRIORITY ENCODER BERHASIL."
            severity note;

        wait;

    end process;

end Behavioral;