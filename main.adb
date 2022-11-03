pragma SPARK_Mode (On);

with AS_IO_Wrapper;  use AS_IO_Wrapper; 
with refuelling;  use refuelling;
use type refuelling.statusIndicatorType;

procedure Main is
   commandStr : String(1 .. 20);

   statusIndicator : statusIndicatorType; 
   last : Integer;
   tankerAltitude : Integer;
   recieverAltitude : Integer;
   airSpeed : Integer;
   length : Integer;
   hoseLength : Integer;
   pressure : Integer;
begin
   AS_Init_Standard_Output;
   AS_Init_Standard_Input;   
   statusIndicator := Red;
   help;
   loop  
      loop
         AS_Put(">> ");
         AS_Get_Line(commandStr, last);
         exit when Last in 1 .. 20;
         AS_Put_Line("Please enter a non-empty string");
      end loop;
      
      if commandStr(1 .. 6) = "deploy" then
         if statusIndicator = Amber or statusIndicator = Green or statusIndicator = Flashing_Green then
            AS_Put_Line("Drouge already deployed");
         else
            -- Get Tanker Altitude
            loop
              AS_Put_Line("Input tanker altitide (ft): ");
              AS_Put(">> ");
              AS_Get(tankerAltitude);
              exit when tankerAltitude in 1 .. 100000;
              AS_Put_Line("Please enter a positive integer no higher than 100,000");
            end loop;
            
            -- Get Recieving Aircraft altitude 
            loop
               AS_Put_Line("Input recieving aircraft altitide (ft): ");
               AS_Put(">> ");
               AS_Get(recieverAltitude);
               exit when recieverAltitude in 1 .. 100000;
               AS_Put_Line("Please enter a positive integer no higher than 100,000");
            end loop;
            
            -- Get air speed
            loop
               AS_Put_Line("Input air speed (mph): ");
               AS_Put(">> ");
               AS_Get(airSpeed);
               exit when airSpeed in 1 .. 2000;
               AS_Put_Line("Please enter a positive integer no higher than 2,000");
            end loop;
            
            deploy(tankerAltitude, recieverAltitude, airSpeed, statusIndicator);
         end if;
         
         
       elsif commandStr(1 .. 7) = "retract" then
         if statusIndicator = Red then
            AS_Put_Line("Drouge not deployed");
         elsif statusIndicator = Green or statusIndicator = Flashing_Green then
            AS_Put_Line("Drouge needs to disconnect first");
         else
            statusIndicator := Red;
         end if;
         
      elsif commandStr(1 .. 7) = "connect" then
         if statusIndicator = Red then
            AS_Put_Line("Drouge not deployed");
         elsif statusIndicator = Green or statusIndicator = Flashing_Green then
            AS_Put_Line("Drouge already connected");
         else
            loop
               -- Get distance between aircraft
               AS_Put_Line("Input distance between the two aircraft: ");
               AS_Put(">> ");
               AS_Get(length);
               exit when length in 1 .. 100;
               AS_Put_Line("Please enter a positive integer no higher than 100");
            end loop;
            
            connect(length, statusIndicator);
         end if;
         
      elsif commandStr(1 .. 10) = "disconnect" then
         if statusIndicator = Red then
            AS_Put_Line("Drouge not deployed");
         elsif statusIndicator = Amber then
            AS_Put_Line("Drouge already disconnected");
         elsif statusIndicator = Flashing_Green then
            AS_Put_Line("Drouge needs to stop transferring fuel first");
         else
            statusIndicator := Amber;
         end if;
         
      elsif commandStr(1 .. 8) = "transfer" then
         if statusIndicator = Red then
            AS_Put_Line("Drouge not deployed");
         elsif statusIndicator = Amber then
            AS_Put_Line("Drouge not connected");
         elsif statusIndicator = Flashing_Green then
            AS_Put_Line("Fuel already transferring");
         else
            loop
               AS_Put_Line("Input pressure in hose (psi): ");
               AS_Put(">> ");
               AS_Get(pressure);
               exit when pressure in 1 .. 1000;
               AS_Put_Line("Please enter a positive integer no higher than 1,000");
            end loop;
            
            loop
               AS_Put_Line("Input length of hose: ");
               AS_Put(">> ");
               AS_Get(hoseLength);
               exit when hoseLength in 1 .. 10;
               AS_Put_Line("Refuelling range needs to be within 10m");
            end loop;
            
            transfer(pressure, hoseLength, statusIndicator);
         end if;
         
      elsif commandStr(1 .. 5) = "pause" then
         if statusIndicator = Red then
            AS_Put_Line("Drouge not deployed");
         elsif statusIndicator = Amber then
            AS_Put_Line("Drouge not connected");
         elsif statusIndicator = Green then
            AS_Put_Line("Fuel not transferring");
         else
            statusIndicator := Green;
         end if;
         
      elsif commandStr(1 .. 4) = "halt" then
         if statusIndicator = Flashing_Green then
            AS_Put_Line("Fuelling halted");
            AS_Put_Line("Drouge disconnected");
            statusIndicator := Amber;
         elsif statusIndicator = Green then
            AS_Put_Line("Drouge disconnected");
            statusIndicator := Amber;
         else
            AS_Put_Line("Nothing to halt");
         end if;
         
      else
         AS_Put_Line("Please only set commands");
      end if;
   end loop;

end Main;
   

