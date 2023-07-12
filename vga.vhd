library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Display is
	Port (CLK : in STD_LOGIC;
	      RST : in STD_LOGIC;
          posicoes : in std_logic_vector(3 downto 0); -- raposa, galinha, saco e jangada
         HSYNC : out STD_LOGIC;
	      VSYNC : out STD_LOGIC;
	      RED : out STD_LOGIC_VECTOR (3 downto 0);
			GREEN : out STD_LOGIC_VECTOR (3 downto 0);
			BLUE : out STD_LOGIC_VECTOR (3 downto 0));
end Display;

architecture final of Display is
	signal clk25 : std_logic := '0';

	constant HD : integer := 639;
	constant HFP : integer := 16;
	constant HSP : integer := 96;
	constant HBP : integer := 48;

	constant VD : integer := 479;
	constant VFP : integer := 10;
	constant VSP : integer := 2;
	constant VBP : integer := 33;

	signal hPos : integer := 0;
	signal vPos : integer := 0;
	
	signal videoOn : std_logic := '0';

begin

clk_div : process(CLK)
begin
	if(CLK'event AND clk = '1') then
		clk25 <= not clk25;
	end if;
end process;

Horizontal_position_counter:process(clk25, RST)
begin
	if(RST = '1') then
		hPos <= 0;
	elsif(clk25'event and clk25 = '1') then
		if(hPos = (HD + HFP + HSP + HBP)) then
			hPos <= 0;
		else
			hPos <= hPos + 1;
		end if;
	end if;
	
end process;

Vertical_position_counter : process(clk25, RST, hPos)
begin
	if(RST = '1') then
		vPos <= 0;
	elsif(clk25'event and clk25 = '1') then
		if(hPos = (HD + HFP + HSP + HBP)) then
			if(vPos = (VD + VFP + VSP + VBP)) then
				vPos <= 0;
		   else
			   vPos <= vPos + 1;
		   end if;
	   end if;
	end if;
	
end process;

Horizontal_Synchronization : process(clk25, RST, hPos)
begin
	if(RST = '1') then
		HSYNC <= '0';
	elsif(clk25'event and clk25 = '1') then
		if((hPos <= (HD + HFP)) or (hPos > HD + HFP + HSP)) then
			HSYNC <= '1';
		else
			HSYNC <= '0';
		end if;
	end if;
end process; 

Vertical_Synchronization : process(clk25, RST, vPos)
begin
	if(RST = '1') then
		VSYNC <= '0';
	elsif(clk25'event and clk25 = '1') then
		if((vPos <= (VD + VFP)) or (vPos > VD + VFP + VSP)) then
			VSYNC <= '1';
		else
			VSYNC <= '0';
		end if;
	end if;
end process; 
 
video_on : process(clk25, RST, hPos, vPos)
begin 
	if(RST = '1') then
		videoOn <= '0';
	elsif(clk25'event and clk25 = '1') then
		if(hPos <= HD and vPos <= VD) then
			videoOn <= '1';
		else
			videoOn <= '0';
		end if;
	end if;
end process;

draw : process(clk25, RST, hPos, vPos, videoOn)
begin
	if(RST = '1') then
		RED <= "0000";
		GREEN <= "0000";
		BLUE <= "0000";
	elsif(clk25'event and clk25 = '1') then
		if(videoOn = '1') then
			if(hPos >= 299 and hPos <= 357) then
				RED <= "0010";
				GREEN <= "1111";
				BLUE <= "1111";
			elsif((hPos >= 224 and hPos <= 299) and (vPos >= 285 or vPos <= 195)) then
				RED <= "0010";
				GREEN <= "1111";
				BLUE <= "1111";

			elsif((hPos >= 357 and hPos <= 432) and (vPos >= 285 or vPos <= 195)) then
				RED <= "0010";
				GREEN <= "1111";
				BLUE <= "1111";

                --JANGADA

			elsif(posicoes(3) = '0' and (hPos >= 357 and hPos <= 432) and (vPos <= 285 and vPos >= 195)) then
				RED <= "0010";
				GREEN <= "1111";
				BLUE <= "1111";



			elsif(posicoes(3) = '0' and (hPos >= 224 and hPos <= 299) and (vPos <= 285 and vPos >= 195)) then    --CANOA NA POSICAO 0
				RED <= "0100";
				GREEN <= "0010";
				BLUE <= "0000";



			elsif(posicoes(3) = '1' and (hPos >= 357 and hPos <= 432) and (vPos <= 285 and vPos >= 195)) then
				RED <= "0100";
				GREEN <= "0010";
				BLUE <= "0000";


			elsif(posicoes(3) = '1' and (hPos >= 224 and hPos <= 299) and (vPos <= 285 and vPos >= 195)) then    --CANOA NA POSICAO 1

				RED <= "0010";
				GREEN <= "1111";
				BLUE <= "1111";


                --RAPOSA



            elsif(posicoes(0) = '0' and (hPos >= 108 and hPos <= 180) and (vPos <= 300 and vPos >= 260)) then
                RED <="1111";
				GREEN <= "0000";
				BLUE <= "0000";
            
            elsif(posicoes(0) = '0' and (hPos >= 459 and hPos <= 531) and (vPos <= 300 and vPos >= 260)) then
                RED <="0000";
				GREEN <= "1111";
				BLUE <= "0000";



            elsif(posicoes(0) = '1' and (hPos >= 108 and hPos <= 180) and (vPos <= 300 and vPos >= 260)) then
                RED <="0000";
				GREEN <= "1111";
				BLUE <= "0000";

            elsif(posicoes(0) = '1' and (hPos >= 459 and hPos <= 531) and (vPos <= 300 and vPos >= 260)) then

                RED <="1111";
				GREEN <= "0000";
				BLUE <= "0000";
            



            --GALINHA



            elsif(posicoes(1) = '0' and (hPos >= 185 and hPos <= 200) and (vPos <= 140 and vPos >= 280)) then
                RED <="1111";
				GREEN <= "1111";
				BLUE <= "1111";

            elsif(posicoes(1) = '0' and (hPos >= 439 and hPos <= 454) and (vPos <= 140 and vPos >= 280)) then   -- galinha 0

                RED <="0000";
				GREEN <= "1111";
				BLUE <= "0000";




            elsif(posicoes(1) = '1' and (hPos >= 185 and hPos <= 200) and (vPos <= 140 and vPos >= 280)) then
                RED <="0000";
				GREEN <= "1111";
				BLUE <= "0000";

            elsif(posicoes(1) = '1' and (hPos >= 439 and hPos <= 454) and (vPos <= 140 and vPos >= 280)) then   -- galinha 1

                RED <="1111";
				GREEN <= "1111";
				BLUE <= "1111";




            -- SACO



            elsif(posicoes(2) = '0' and (hPos >= 70 and hPos <= 130) and (vPos <= 100 and vPos >= 150)) then
                RED <="1110";
				GREEN <= "1110";
				BLUE <= "0000";

            elsif(posicoes(2) = '0' and (hPos >= 509 and hPos <= 569) and (vPos <= 100 and vPos >= 150)) then   -- galinha 0

                RED <="0000";
				GREEN <= "1111";
				BLUE <= "0000";





            elsif(posicoes(2) = '1' and (hPos >= 70 and hPos <= 130) and (vPos <= 100 and vPos >= 150)) then
                RED <="0000";
				GREEN <= "1111";
				BLUE <= "0000";

            elsif(posicoes(2) = '1' and (hPos >= 509 and hPos <= 569) and (vPos <= 100 and vPos >= 150)) then   -- galinha 0


                RED <="1110";
				GREEN <= "1110";
				BLUE <= "0000";


			else
				RED <= "0000";
				GREEN <= "1111";
				BLUE <= "0000";
			end if;
		else
			RED <= "0000";
			GREEN <= "0000";
			BLUE <= "0000";
		end if;
	end if;
end process;
	
end final; 