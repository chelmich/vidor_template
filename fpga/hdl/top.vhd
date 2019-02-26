library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity top is
    port (
        -- system signals
        iCLK        : in std_logic;
        iRESETn     : in std_logic;
        iSAM_INT    : in std_logic;
        oSAM_INT    : out std_logic;

        -- SDRAM
        oSDRAM_CLK  : out std_logic;
        oSDRAM_ADDR : out std_logic_vector (11 downto 0);
        oSDRAM_BA   : out std_logic_vector (1 downto 0);
        oSDRAM_CASn : out std_logic;
        oSDRAM_CKE  : out std_logic;
        oSDRAM_CSn  : out std_logic;
        bSDRAM_DQ   : inout std_logic_vector (15 downto 0);
        oSDRAM_DQM  : out std_logic_vector (1 downto 0);
        oSDRAM_RASn : out std_logic;
        oSDRAM_WEn  : out std_logic;

        -- SAM D21 PINS
        bMKR_AREF   : inout std_logic;
        bMKR_A      : inout std_logic_vector (6 downto 0);
        bMKR_D      : inout std_logic_vector (14 downto 0);

        -- Mini PCIe
        bPEX_RST     :  inout std_logic;
        bPEX_PIN6    :  inout std_logic;
        bPEX_PIN8    :  inout std_logic;
        bPEX_PIN10   :  inout std_logic;
        iPEX_PIN11   :  in std_logic;
        bPEX_PIN12   :  inout std_logic;
        iPEX_PIN13   :  in std_logic;
        bPEX_PIN14   :  inout std_logic;
        bPEX_PIN16   :  inout std_logic;
        bPEX_PIN20   :  inout std_logic;
        iPEX_PIN23   :  in std_logic;
        iPEX_PIN25   :  in std_logic;
        bPEX_PIN28   :  inout std_logic;
        bPEX_PIN30   :  inout std_logic;
        iPEX_PIN31   :  in std_logic;
        bPEX_PIN32   :  inout std_logic;
        iPEX_PIN33   :  in std_logic;
        bPEX_PIN42   :  inout std_logic;
        bPEX_PIN44   :  inout std_logic;
        bPEX_PIN45   :  inout std_logic;
        bPEX_PIN46   :  inout std_logic;
        bPEX_PIN47   :  inout std_logic;
        bPEX_PIN48   :  inout std_logic;
        bPEX_PIN49   :  inout std_logic;
        bPEX_PIN51   :  inout std_logic;

        -- NINA interface
        bWM_PIO1    : inout std_logic;
        bWM_PIO2    : inout std_logic;
        bWM_PIO3    : inout std_logic;
        bWM_PIO4    : inout std_logic;
        bWM_PIO5    : inout std_logic;
        bWM_PIO7    : inout std_logic;
        bWM_PIO8    : inout std_logic;
        bWM_PIO18   : inout std_logic;
        bWM_PIO20   : inout std_logic;
        bWM_PIO21   : inout std_logic;
        bWM_PIO27   : inout std_logic;
        bWM_PIO28   : inout std_logic;
        bWM_PIO29   : inout std_logic;
        bWM_PIO31   : inout std_logic;
        iWM_PIO32   : in std_logic;
        bWM_PIO34   : inout std_logic;
        bWM_PIO35   : inout std_logic;
        bWM_PIO36   : inout std_logic;
        iWM_TX      : in std_logic;
        oWM_RX      : inout std_logic;
        oWM_RESET   : inout std_logic;

        -- HDMI output
        oHDMI_TX    : out std_logic_vector (2 downto 0);
        oHDMI_CLK   : out std_logic;

        bHDMI_SDA   : inout std_logic;
        bHDMI_SCL   : inout std_logic;

        iHDMI_HPD   : in std_logic;

        -- MIPI input
        iMIPI_D     : in std_logic_vector (1 downto 0);
        iMIPI_CLK   : in std_logic;
        bMIPI_SDA   : inout std_logic;
        bMIPI_SCL   : inout std_logic;
        bMIPI_GP    : inout std_logic_vector (1 downto 0);

        -- Q-SPI Flash interface
        oFLASH_SCK  : out std_logic;
        oFLASH_CS   : out std_logic;
        oFLASH_MOSI : inout std_logic;
        iFLASH_MISO : inout std_logic;
        oFLASH_HOLD : inout std_logic;
        oFLASH_WP   : inout std_logic
    );
end entity;

architecture behavior of top is

    component SYSTEM_PLL
        port (
            areset  : in std_logic;
            inclk0  : in std_logic;
            c0      : out std_logic;
            c1      : out std_logic;
            c2      : out std_logic;
            c3      : out std_logic;
            c4      : out std_logic;
            locked  : out std_logic
        );
    end component;

    -- signal declaration
    signal wOSC_CLK : std_logic;

    signal wCLK8 : std_logic;
    signal wCLK24 : std_logic;
    signal wCLK64 : std_logic;
    signal wCLK120 : std_logic;

    signal wJTAG_ADDRESS : std_logic_vector (31 downto 0);
    signal wJTAG_READ_DATA : std_logic_vector (31 downto 0);
    signal wJTAG_WRITE_DATA : std_logic_vector (31 downto 0);
    signal wDPRAM_READ_DATA : std_logic_vector (31 downto 0);

    signal wJTAG_READ : std_logic;
    signal wJTAG_WRITE : std_logic;
    signal wJTAG_WAIT_REQUEST : std_logic;
    signal wJTAG_READ_DATAVALID : std_logic;
    signal wJTAG_BURST_COUNT : std_logic_vector (4 downto 0);
    signal wDPRAM_CS : std_logic;

    signal wDVI_RED : std_logic_vector (7 downto 0);
    signal wDVI_GRN : std_logic_vector (7 downto 0);
    signal wDVI_BLU : std_logic_vector (7 downto 0);

    signal wDVI_HS : std_logic;
    signal wDVI_VS : std_logic;
    signal wDVI_DE : std_logic;

    signal wVID_CLK : std_logic;
    signal wVID_CLKx5 : std_logic;
    signal wMEM_CLK : std_logic;

begin

    wCLK8 <= iCLK;

    -- system PLL
    u1 : component SYSTEM_PLL
    port map (
        areset => '0' ,
        inclk0 => wCLK8,
        c0 => wCLK24,
        c1 => wCLK120,
        c2 => wMEM_CLK,
        c3 => oSDRAM_CLK,
        c4 => open,

        locked => open
    );

end architecture;

