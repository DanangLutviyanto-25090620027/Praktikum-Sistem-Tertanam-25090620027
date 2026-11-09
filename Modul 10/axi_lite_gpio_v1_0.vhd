----------------------------------------------------------------------------------
-- Jobsheet 10 - Praktikum Sistem Tertanam
-- IP Custom AXI4-Lite Slave : axi_lite_gpio_v1_0
--
-- Peta register (offset alamat dari base address):
--   0x00 : reg0  (R/W)  reg0(15:0) -> gpio_out (LED)
--   0x04 : reg1  (R/W)  register cadangan (untuk Tugas 1: status switch)
--   0x08 : reg2  (R/W)  register cadangan
--   0x0C : reg3  (R/W)  register cadangan
--
-- Catatan: sesuai entity pada Kode 10.1 (tanpa WSTRB/AWPROT/ARPROT),
-- setiap penulisan selalu mengubah seluruh 32 bit register.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity axi_lite_gpio_v1_0 is
  Generic ( C_S_AXI_ADDR_WIDTH : integer := 4;  -- 4 register -> 2 bit indeks + 2 bit byte
            C_S_AXI_DATA_WIDTH : integer := 32 );
  Port (
    S_AXI_ACLK    : in  STD_LOGIC;
    S_AXI_ARESETN : in  STD_LOGIC;
    S_AXI_AWADDR  : in  STD_LOGIC_VECTOR(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_AWVALID : in  STD_LOGIC;
    S_AXI_AWREADY : out STD_LOGIC;
    S_AXI_WDATA   : in  STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_WVALID  : in  STD_LOGIC;
    S_AXI_WREADY  : out STD_LOGIC;
    S_AXI_BRESP   : out STD_LOGIC_VECTOR(1 downto 0);
    S_AXI_BVALID  : out STD_LOGIC;
    S_AXI_BREADY  : in  STD_LOGIC;
    S_AXI_ARADDR  : in  STD_LOGIC_VECTOR(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_ARVALID : in  STD_LOGIC;
    S_AXI_ARREADY : out STD_LOGIC;
    S_AXI_RDATA   : out STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_RRESP   : out STD_LOGIC_VECTOR(1 downto 0);
    S_AXI_RVALID  : out STD_LOGIC;
    S_AXI_RREADY  : in  STD_LOGIC;
    gpio_out      : out STD_LOGIC_VECTOR(15 downto 0)  -- dihubungkan ke LED
  );
end axi_lite_gpio_v1_0;

architecture rtl of axi_lite_gpio_v1_0 is

  type reg_array_t is array (0 to 3) of STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal regs : reg_array_t := (others => (others => '0'));

  -- sinyal internal untuk output port (agar dapat dibaca kembali di dalam arsitektur)
  signal awready_i : STD_LOGIC := '0';
  signal wready_i  : STD_LOGIC := '0';
  signal bvalid_i  : STD_LOGIC := '0';
  signal arready_i : STD_LOGIC := '0';
  signal rvalid_i  : STD_LOGIC := '0';
  signal rdata_i   : STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');

begin

  -- Koneksi output port
  S_AXI_AWREADY <= awready_i;
  S_AXI_WREADY  <= wready_i;
  S_AXI_BVALID  <= bvalid_i;
  S_AXI_BRESP   <= "00";          -- OKAY
  S_AXI_ARREADY <= arready_i;
  S_AXI_RVALID  <= rvalid_i;
  S_AXI_RDATA   <= rdata_i;
  S_AXI_RRESP   <= "00";          -- OKAY

  gpio_out <= regs(0)(15 downto 0);

  ----------------------------------------------------------------------------
  -- FSM TULIS: alamat & data diterima bersamaan, lalu respons BVALID
  ----------------------------------------------------------------------------
  write_proc : process(S_AXI_ACLK)
    variable idx : integer range 0 to 3;
  begin
    if rising_edge(S_AXI_ACLK) then
      if S_AXI_ARESETN = '0' then
        awready_i <= '0';
        wready_i  <= '0';
        bvalid_i  <= '0';
        regs      <= (others => (others => '0'));
      else
        -- Terima transaksi tulis bila AW dan W sama-sama valid
        if (awready_i = '0' and wready_i = '0' and
            S_AXI_AWVALID = '1' and S_AXI_WVALID = '1' and bvalid_i = '0') then
          awready_i <= '1';
          wready_i  <= '1';
          idx := to_integer(unsigned(S_AXI_AWADDR(C_S_AXI_ADDR_WIDTH-1 downto 2)));
          regs(idx) <= S_AXI_WDATA;
          bvalid_i  <= '1';
        else
          awready_i <= '0';
          wready_i  <= '0';
        end if;

        -- Respons tulis selesai saat master siap (BREADY)
        if bvalid_i = '1' and S_AXI_BREADY = '1' then
          bvalid_i <= '0';
        end if;
      end if;
    end if;
  end process write_proc;

  ----------------------------------------------------------------------------
  -- FSM BACA: terima alamat, kirim data + RVALID
  ----------------------------------------------------------------------------
  read_proc : process(S_AXI_ACLK)
    variable idx : integer range 0 to 3;
  begin
    if rising_edge(S_AXI_ACLK) then
      if S_AXI_ARESETN = '0' then
        arready_i <= '0';
        rvalid_i  <= '0';
        rdata_i   <= (others => '0');
      else
        if (arready_i = '0' and S_AXI_ARVALID = '1' and rvalid_i = '0') then
          arready_i <= '1';
          idx := to_integer(unsigned(S_AXI_ARADDR(C_S_AXI_ADDR_WIDTH-1 downto 2)));
          rdata_i   <= regs(idx);
          rvalid_i  <= '1';
        else
          arready_i <= '0';
        end if;

        if rvalid_i = '1' and S_AXI_RREADY = '1' then
          rvalid_i <= '0';
        end if;
      end if;
    end if;
  end process read_proc;

end rtl;