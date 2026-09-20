library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu4 is
    Port (
        a      : in  STD_LOGIC_VECTOR (3 downto 0);
        b      : in  STD_LOGIC_VECTOR (3 downto 0);
        opcode : in  STD_LOGIC_VECTOR (1 downto 0);
        result : out STD_LOGIC_VECTOR (7 downto 0);
        carry  : out STD_LOGIC
    );
end alu4;

architecture Behavioral of alu4 is

begin

    process(a, b, opcode)

        variable temp : UNSIGNED(7 downto 0);

    begin

        -- Nilai awal
        temp := (others => '0');
        carry <= '0';

        case opcode is

            -- =====================================
            -- OPCODE 00 : PENJUMLAHAN
            -- =====================================
            when "00" =>

                temp := resize(unsigned(a), 8) +
                        resize(unsigned(b), 8);

                result <= std_logic_vector(temp);

                -- Carry dari penjumlahan 4-bit
                if (unsigned(a) + unsigned(b)) > 15 then
                    carry <= '1';
                else
                    carry <= '0';
                end if;


            -- =====================================
            -- OPCODE 01 : PENGURANGAN
            -- =====================================
            when "01" =>

                if unsigned(a) >= unsigned(b) then

                    temp := resize(unsigned(a), 8) -
                            resize(unsigned(b), 8);

                    carry <= '1';

                else

                    -- Hasil negatif menggunakan
                    -- representasi two's complement 8-bit
                    temp := resize(unsigned(a), 8) -
                            resize(unsigned(b), 8);

                    carry <= '0';

                end if;

                result <= std_logic_vector(temp);


            -- =====================================
            -- OPCODE 10 : PERKALIAN
            -- =====================================
            when "10" =>

                temp := unsigned(a) * unsigned(b);

                result <= std_logic_vector(temp);

                -- Perkalian 4-bit x 4-bit maksimal 225,
                -- sehingga tidak membutuhkan carry tambahan.
                carry <= '0';


            -- =====================================
            -- OPCODE 11 : TIDAK DIGUNAKAN
            -- =====================================
            when others =>

                result <= (others => '0');
                carry  <= '0';

        end case;

    end process;

end Behavioral;