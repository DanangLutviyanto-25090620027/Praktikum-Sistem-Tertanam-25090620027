----------------------------------------------------------------------------------
-- Testbench untuk axi_lite_gpio_v1_0 (master AXI4-Lite dibuat manual)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_axi_lite_gpio is
end tb_axi_lite_gpio;

architecture sim of tb_axi_lite_gpio is

  constant CLK_PERIOD : time := 10 ns;  -- 100 MHz

  signal clk     : std_logic := '0';
  signal aresetn : std_logic := '0';
  signal done    : boolean   := false;

  signal awaddr  : std_logic_vector(3 downto 0)  := (others => '0');
  signal awvalid : std_logic := '0';
  signal awready : std_logic;
  signal wdata   : std_logic_vector(31 downto 0) := (others => '0');
  signal wvalid  : std_logic := '0';
  signal wready  : std_logic;
  signal bresp   : std_logic_vector(1 downto 0);
  signal bvalid  : std_logic;
  signal bready  : std_logic := '0';
  signal araddr  : std_logic_vector(3 downto 0)  := (others => '0');
  signal arvalid : std_logic := '0';
  signal arready : std_logic;
  signal rdata   : std_logic_vector(31 downto 0);
  signal rresp   : std_logic_vector(1 downto 0);
  signal rvalid  : std_logic;
  signal rready  : std_logic := '0';
  signal gpio_out : std_logic_vector(15 downto 0);

  signal error_count : integer := 0;

  -- fungsi bantu: std_logic_vector 32 bit -> string heksadesimal (kompatibel VHDL-93)
  function hex_str(v : std_logic_vector(31 downto 0)) return string is
    constant hexchars : string(1 to 16) := "0123456789ABCDEF";
    variable r : string(1 to 8);
    variable n : integer;
  begin
    for k in 0 to 7 loop
      n := to_integer(unsigned(v(31 - 4*k downto 28 - 4*k)));
      r(k+1) := hexchars(n+1);
    end loop;
    return r;
  end function;

begin

  -- Device Under Test
  dut : entity work.axi_lite_gpio_v1_0
    generic map ( C_S_AXI_ADDR_WIDTH => 4, C_S_AXI_DATA_WIDTH => 32 )
    port map (
      S_AXI_ACLK    => clk,
      S_AXI_ARESETN => aresetn,
      S_AXI_AWADDR  => awaddr,
      S_AXI_AWVALID => awvalid,
      S_AXI_AWREADY => awready,
      S_AXI_WDATA   => wdata,
      S_AXI_WVALID  => wvalid,
      S_AXI_WREADY  => wready,
      S_AXI_BRESP   => bresp,
      S_AXI_BVALID  => bvalid,
      S_AXI_BREADY  => bready,
      S_AXI_ARADDR  => araddr,
      S_AXI_ARVALID => arvalid,
      S_AXI_ARREADY => arready,
      S_AXI_RDATA   => rdata,
      S_AXI_RRESP   => rresp,
      S_AXI_RVALID  => rvalid,
      S_AXI_RREADY  => rready,
      gpio_out      => gpio_out
    );

  -- Pembangkit clock (berhenti saat 'done' = true)
  clk_proc : process
  begin
    while not done loop
      clk <= '0'; wait for CLK_PERIOD/2;
      clk <= '1'; wait for CLK_PERIOD/2;
    end loop;
    wait;
  end process;

  -- Stimulus: master AXI4-Lite
  stim_proc : process

    procedure axi_write(addr : in std_logic_vector(3 downto 0);
                        data : in std_logic_vector(31 downto 0)) is
    begin
      wait until rising_edge(clk);
      awaddr  <= addr;  awvalid <= '1';
      wdata   <= data;  wvalid  <= '1';
      bready  <= '0';
      -- tunggu handshake kanal alamat & data
      loop
        wait until rising_edge(clk);
        exit when awready = '1' and wready = '1';
      end loop;
      awvalid <= '0';  wvalid <= '0';
      bready  <= '1';
      -- tunggu respons tulis
      loop
        wait until rising_edge(clk);
        exit when bvalid = '1';
      end loop;
      if bresp /= "00" then
        report "ERROR: BRESP bukan OKAY" severity error;
        error_count <= error_count + 1;
      end if;
      bready <= '0';
    end procedure;

    procedure axi_read(addr : in  std_logic_vector(3 downto 0);
                       data : out std_logic_vector(31 downto 0)) is
    begin
      wait until rising_edge(clk);
      araddr  <= addr;  arvalid <= '1';
      rready  <= '0';
      loop
        wait until rising_edge(clk);
        exit when arready = '1';
      end loop;
      arvalid <= '0';
      rready  <= '1';
      loop
        wait until rising_edge(clk);
        exit when rvalid = '1';
      end loop;
      data := rdata;
      if rresp /= "00" then
        report "ERROR: RRESP bukan OKAY" severity error;
        error_count <= error_count + 1;
      end if;
      rready <= '0';
    end procedure;

    variable rd : std_logic_vector(31 downto 0);

    procedure check_reg(addr : in std_logic_vector(3 downto 0);
                        expected : in std_logic_vector(31 downto 0);
                        name : in string) is
    begin
      axi_read(addr, rd);
      if rd = expected then
        report "OK    : " & name & " terbaca = 0x" & hex_str(rd) severity note;
      else
        report "GAGAL : " & name & " terbaca 0x" & hex_str(rd) &
               ", seharusnya 0x" & hex_str(expected) severity error;
        error_count <= error_count + 1;
      end if;
    end procedure;

  begin
    -- Reset
    aresetn <= '0';
    wait for 5 * CLK_PERIOD;
    aresetn <= '1';
    wait for 3 * CLK_PERIOD;

    report "=== Tes 1: nilai awal setelah reset ===" severity note;
    check_reg(x"0", x"00000000", "reg0");

    report "=== Tes 2: tulis & baca reg0..reg3 ===" severity note;
    axi_write(x"0", x"0000A5A5");
    check_reg(x"0", x"0000A5A5", "reg0");
    assert gpio_out = x"A5A5" report "GAGAL: gpio_out tidak sama dengan reg0(15:0)" severity error;

    axi_write(x"4", x"11111111");
    axi_write(x"8", x"22222222");
    axi_write(x"C", x"33333333");
    check_reg(x"4", x"11111111", "reg1");
    check_reg(x"8", x"22222222", "reg2");
    check_reg(x"C", x"33333333", "reg3");
    check_reg(x"0", x"0000A5A5", "reg0 (tidak berubah)");

    report "=== Tes 3: pola LED berjalan (walking pattern) ===" severity note;
    for i in 0 to 15 loop
      axi_write(x"0", std_logic_vector(shift_left(to_unsigned(1, 32), i)));
      wait for 2 * CLK_PERIOD;
      assert gpio_out = std_logic_vector(shift_left(to_unsigned(1, 16), i))
        report "GAGAL: pola LED salah pada bit " & integer'image(i) severity error;
    end loop;

    wait for 5 * CLK_PERIOD;
    if error_count = 0 then
      report "*** SIMULASI SELESAI: SEMUA TES LULUS ***" severity note;
    else
      report "*** SIMULASI SELESAI: ADA " & integer'image(error_count) & " KESALAHAN ***" severity error;
    end if;
    done <= true;
    wait;
  end process;

end sim;