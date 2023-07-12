library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Main is
    port(
        raposa : in std_logic;
        galinha : in std_logic;
        saco : in std_logic;
        jangada : in std_logic;
        button : in std_logic;
        led : out std_logic
    );
end entity Main;

architecture Behavioral of Main is
    signal move_resultado : std_logic_vector(1 downto 0);
    type state_type is (start, progresso, falha, fim);
    signal current_state, next_state : state_type;
begin
    Analise_inst : Analise
        port map (
            raposa => raposa,
            galinha => galinha,
            saco => saco,
            jangada => jangada,
            resultado => move_resultado
        );

    process (current_state, move_resultado, button)
    begin
        case current_state is
            when start =>
                if raposa = '0' and galinha = '0' and saco = '0' and jangada = '0' then
                    if button = '1' then
                        next_state <= progresso;
                    else
                        next_state <= start;
                    end if;
                else
                    next_state <= start;
                end if;

            when progresso =>
                if button = '1' then
                    if move_resultado = "10" then
                        next_state <= fim;
                    elsif move_resultado = "00" then
                        next_state <= progresso;
                    else
                        next_state <= falha;
                    end if;
                else
                    next_state <= progresso;
                end if;

            when falha =>
                if button = '1' then
                    next_state <= start;
                else
                    next_state <= falha;
                end if;

            when fim =>
                if button = '1' then
                    next_state <= start;
                else
                    next_state <= fim;
                end if;

            when others =>
                next_state <= start;
        end case;
    end process;

    process (next_state)
    begin
        current_state <= next_state;
        if current_state = fim then
            led <= '1';
        else
            led <= '0';
        end if;
    end process;
end architecture Behavioral;