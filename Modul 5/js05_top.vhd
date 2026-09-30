library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity js05_top is
    Port ( clk  : in  STD_LOGIC;                      -- W5, 100 MHz
           btnU : in  STD_LOGIC;                       -- naik (+1)
           btnD : in  STD_LOGIC;                       -- turun (-1)
           btnC : in  STD_LOGIC;                       -- reset ke nol
           seg  : out STD_LOGIC_VECTOR (6 downto 0);
           dp   : out STD_LOGIC;
           an   : out STD_LOGIC_VECTOR (3 downto 0) );
end js05_top;

architecture Behavioral of js05_top is
    signal u_clean, d_clean, c_clean : STD_LOGIC;
    signal u_pulse, d_pulse          : STD_LOGIC;
    signal count                     : STD_LOGIC_VECTOR (15 downto 0);
begin
    -- Untuk Tugas 3: ubah STABLE_MS di 3 baris generic map di bawah (mis. 1)
    DB_U: entity work.debounce
        generic map ( CLK_FREQ_HZ => 100_000_000, STABLE_MS => 10 )
        port map ( clk => clk, btn_in => btnU, btn_out => u_clean );
    DB_D: entity work.debounce
        generic map ( CLK_FREQ_HZ => 100_000_000, STABLE_MS => 10 )
        port map ( clk => clk, btn_in => btnD, btn_out => d_clean );
    DB_C: entity work.debounce
        generic map ( CLK_FREQ_HZ => 100_000_000, STABLE_MS => 10 )
        port map ( clk => clk, btn_in => btnC, btn_out => c_clean );

    ED_U: entity work.edge_detect
        port map ( clk => clk, sig_in => u_clean, pulse => u_pulse );
    ED_D: entity work.edge_detect
        port map ( clk => clk, sig_in => d_clean, pulse => d_pulse );

    CNT: entity work.updown_counter
        port map ( clk => clk, up => u_pulse, down => d_pulse,
                   clr => c_clean, count => count );

    DRV: entity work.seven_seg_driver
        generic map ( DIGITS => 4 )
        port map ( clk => clk, value => count, seg => seg, dp => dp, an => an );
end Behavioral;
