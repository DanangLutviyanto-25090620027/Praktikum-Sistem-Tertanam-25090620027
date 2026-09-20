library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_alu4 is
end tb_alu4;

architecture Behavioral of tb_alu4 is

    component alu4
        Port (
            a      : in  STD_LOGIC_VECTOR (3 downto 0);
            b      : in  STD_LOGIC_VECTOR (3 downto 0);
            opcode : in  STD_LOGIC;
            result : out STD_LOGIC_VECTOR (3 downto 0);
            carry  : out STD_LOGIC
        );
    end component;

    signal a      : STD_LOGIC_VECTOR (3 downto 0);
    signal b      : STD_LOGIC_VECTOR (3 downto 0);
    signal opcode : STD_LOGIC;
    signal result : STD_LOGIC_VECTOR (3 downto 0);
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
        -- 0111 + 0001 = 1000
        -- =========================================

        a      <= "0111";
        b      <= "0001";
        opcode <= '0';

        wait for 10 ns;

        assert (result = "1000" and carry = '0')
            report "ERROR TEST 1: 7 + 1"
            severity error;


        -- =========================================
        -- TEST 2
        -- 0011 + 0010 = 0101
        -- =========================================

        a      <= "0011";
        b      <= "0010";
        opcode <= '0';

        wait for 10 ns;

        assert (result = "0101" and carry = '0')
            report "ERROR TEST 2: 3 + 2"
            severity error;


        -- =========================================
        -- TEST 3
        -- 1111 + 0001 = 0000 carry 1
        -- =========================================

        a      <= "1111";
        b      <= "0001";
        opcode <= '0';

        wait for 10 ns;

        assert (result = "0000" and carry = '1')
            report "ERROR TEST 3: 15 + 1"
            severity error;


        -- =========================================
        -- TEST 4
        -- 0101 + 0011 = 1000
        -- =========================================

        a      <= "0101";
        b      <= "0011";
        opcode <= '0';

        wait for 10 ns;

        assert (result = "1000" and carry = '0')
            report "ERROR TEST 4: 5 + 3"
            severity error;


        -- =========================================
        -- TEST 5
        -- 1001 + 0110 = 1111
        -- =========================================

        a      <= "1001";
        b      <= "0110";
        opcode <= '0';

        wait for 10 ns;

        assert (result = "1111" and carry = '0')
            report "ERROR TEST 5: 9 + 6"
            severity error;


        -- =========================================
        -- TEST 6
        -- 1000 - 0011 = 0101
        -- =========================================

        a      <= "1000";
        b      <= "0011";
        opcode <= '1';

        wait for 10 ns;

        assert (result = "0101" and carry = '1')
            report "ERROR TEST 6: 8 - 3"
            severity error;


        -- =========================================
        -- TEST 7
        -- 0111 - 0010 = 0101
        -- =========================================

        a      <= "0111";
        b      <= "0010";
        opcode <= '1';

        wait for 10 ns;

        assert (result = "0101" and carry = '1')
            report "ERROR TEST 7: 7 - 2"
            severity error;


        -- =========================================
        -- TEST 8
        -- 0011 - 0011 = 0000
        -- =========================================

        a      <= "0011";
        b      <= "0011";
        opcode <= '1';

        wait for 10 ns;

        assert (result = "0000" and carry = '1')
            report "ERROR TEST 8: 3 - 3"
            severity error;


        report "SEMUA TEST ALU4 BERHASIL."
            severity note;

        wait;

    end process;

end Behavioral;