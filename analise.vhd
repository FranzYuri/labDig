library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Analise is
    port(
        raposa : in std_logic;
        galinha : in std_logic;
        saco : in std_logic;
        jangada : in std_logic;
        resultado : out std_logic_vector(1 downto 0)
    );
end entity Analise;

architecture Behavioral of Analise is
begin
    process (raposa, galinha, saco, jangada)
    begin
        if (raposa xnor galinha and (NOT (jangada and galinha)) = '1') or
           (saco xnor galinha and (NOT (jangada and galinha))= '1') then
            resultado <= "01";                           --FALHA
        elsif raposa = '1' and galinha = '1' and saco = '1' and jangada = '1' then
            resultado <= "10";
        else
            resultado <= "00";    --prossiga
        end if;
    end process;
end architecture Behavioral;

