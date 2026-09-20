library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_alu4 is
end tb_alu4;

architecture Behavioral of tb_alu4 is

    component alu4
        Port (
            a      : in  STD_LOGIC_VECTOR (3 downto 0);
            b      : in  STD_LOGIC_VECTOR (3 downto 0);
            opcode : in  STD_LOGIC_VECTOR (1 downto 0);
            result : out STD_LOGIC_VECTOR (7 downto 0);
            carry  : out STD_LOGIC
        );
    end component;

    signal a      : STD_LOGIC_VECTOR (3 downto 0);
    signal b      : STD_LOGIC_VECTOR (3 downto 0);
    signal opcode : STD_LOGIC_VECTOR (1 downto 0);
    signal result : STD_LOGIC_VECTOR (7 downto 0);
    signal carry  : STD_LOGIC;

begin

    uut: alu4
        port map (
            a      => a,
            b      => b,
            opcode => opcode,
            result => result,
            carry  => carry
        );

    process
    begin

        -- =========================================
        -- TEST 1
        -- 7 + 1 = 8
        -- =========================================

        a      <= "0111";
        b      <= "0001";
        opcode <= "00";

        wait for 10 ns;

        assert (result = "00001000" and carry = '0')
            report "ERROR TEST 1: 7 + 1"
            severity error;


        -- =========================================
        -- TEST 2
        -- 15 + 1 = 16
        -- =========================================

        a      <= "1111";
        b      <= "0001";
        opcode <= "00";

        wait for 10 ns;

        assert (result = "00010000" and carry = '1')
            report "ERROR TEST 2: 15 + 1"
            severity error;


        -- =========================================
        -- TEST 3
        -- 8 - 3 = 5
        -- =========================================

        a      <= "1000";
        b      <= "0011";
        opcode <= "01";

        wait for 10 ns;

        assert (result = "00000101" and carry = '1')
            report "ERROR TEST 3: 8 - 3"
            severity error;


        -- =========================================
        -- TEST 4
        -- 7 - 2 = 5
        -- =========================================

        a      <= "0111";
        b      <= "0010";
        opcode <= "01";

        wait for 10 ns;

        assert (result = "00000101" and carry = '1')
            report "ERROR TEST 4: 7 - 2"
            severity error;


        -- =========================================
        -- TEST 5
        -- 3 - 6 = -3
        -- Two's complement 8-bit = 11111101
        -- =========================================

        a      <= "0011";
        b      <= "0110";
        opcode <= "01";

        wait for 10 ns;

        assert (result = "11111101" and carry = '0')
            report "ERROR TEST 5: 3 - 6"
            severity error;


        -- =========================================
        -- TEST 6
        -- 3 x 4 = 12
        -- =========================================

        a      <= "0011";
        b      <= "0100";
        opcode <= "10";

        wait for 10 ns;

        assert (result = "00001100" and carry = '0')
            report "ERROR TEST 6: 3 x 4"
            severity error;


        -- =========================================
        -- TEST 7
        -- 7 x 2 = 14
        -- =========================================

        a      <= "0111";
        b      <= "0010";
        opcode <= "10";

        wait for 10 ns;

        assert (result = "00001110" and carry = '0')
            report "ERROR TEST 7: 7 x 2"
            severity error;


        -- =========================================
        -- TEST 8
        -- 15 x 15 = 225
        -- =========================================

        a      <= "1111";
        b      <= "1111";
        opcode <= "10";

        wait for 10 ns;

        assert (result = "11100001" and carry = '0')
            report "ERROR TEST 8: 15 x 15"
            severity error;


        -- =========================================
        -- TEST 9
        -- 5 x 6 = 30
        -- =========================================

        a      <= "0101";
        b      <= "0110";
        opcode <= "10";

        wait for 10 ns;

        assert (result = "00011110" and carry = '0')
            report "ERROR TEST 9: 5 x 6"
            severity error;


        report "SEMUA TEST ALU4 BERHASIL."
            severity note;

        wait;

    end process;

end Behavioral;