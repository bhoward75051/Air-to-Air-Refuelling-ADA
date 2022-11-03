pragma SPARK_Mode (On);

with AS_IO_Wrapper; use AS_IO_Wrapper;

package body refuelling is

   procedure help is
   begin
      AS_Put_Line("Possible commands:");
      AS_Put_Line("deploy - Deploy Drouge");
      AS_Put_Line("retract - Retract Drouge");
      AS_Put_Line("connect - Connect Drouge to recieving aircraft");
      AS_Put_Line("disconnect - Disconnect Drouge to recieving aircraft");
      AS_Put_Line("transfer - Begin fuel transfer");
      AS_Put_Line("pause - Pause fuel transfer");
      AS_Put_Line("halt - halt fuel transfer and disconnect drouge");

   end help;

   procedure deploy(tankerAltitude, recieverAltitude, airSpeed: in Positive; statusIndicator: Out statusIndicatorType) is
      altitudeCheckBool : Boolean;
   begin
      statusIndicator := Amber;
      if tankerAltitude not in 10000 .. 35000 then
         AS_Put_Line("Aircraft must fly between 10,000 and 35,000ft to deploy drouge");
         statusIndicator := Red;
      end if;

      if recieverAltitude not in 10000 .. 35000 then
         AS_Put_Line("Aircraft must fly between 10,000 and 35,000ft to deploy drouge");
         statusIndicator := Red;
      end if;

      if airSpeed not in 200 .. 400 then
         AS_Put_Line("Aircraft must fly at speeds between 200 and 400mph to deploy drouge");
         statusIndicator := Red;
      end if;

      if statusIndicator = Amber then
         altitudeCheck(tankerAltitude, recieverAltitude, altitudeCheckBool);
         if not altitudeCheckBool then
         AS_Put_Line("Too high of an altitude difference");
         statusIndicator := Red;
      end if;
      end if;

      if statusIndicator = Red then
         AS_Put_Line("Drouge deployment unsuccessful");
      else
         AS_Put_Line("Drouge deployment successful");
      end if;

   end deploy;


   procedure connect(length: in Positive; statusIndicator: out statusIndicatorType) is
   begin
      statusIndicator := Green;
      if length not in 5 .. 20 then
         AS_Put_Line("Hose must be in refuelling range (5 - 20m) to connect to drouge");
         AS_Put_Line("Cancelling connection");
         statusIndicator := Amber;
      end if;

      if statusIndicator = Amber then
         AS_Put_Line("Drouge connection unsuccessful");
      else
         AS_Put_Line("Drouge connection successful");
      end if;
   end connect;

   procedure transfer(pressure, hoseLength: in Positive; statusIndicator: out statusIndicatorType) is
      flowRate : Positive;
   begin
      statusIndicator := Flashing_Green;
      if pressure not in 45 .. 55 then
         AS_Put_Line("Hose must be between 45 and 55 psi in order to flow fuel");
         AS_Put_Line("Cancelling transfer");
         statusIndicator := Green;
      end if;

      if hoseLength not in 2 .. 10 then
         AS_Put_Line("Hose must be in refuelling range (2 - 10m) to connect to drouge");
         AS_Put_Line("Cancelling transfer");
         statusIndicator := Green;
      end if;
      if statusIndicator = Green then
         AS_Put_Line("Fuel transfer unsuccessful");
      else
         calculateFlowRate(hoseLength, pressure, flowRate);

         AS_Put("Calculated flow rate is: ");
         AS_Put_Line(Integer'Image(flowRate));
         AS_Put_Line("Fuel transfer is successful");
      end if;
   end transfer;

   procedure calculateFlowRate(length, pressure: in Positive; flowRate: out Positive) is
   begin
      flowRate := (pressure * 1963) / (120 * length);

   end calculateFlowRate;

   procedure altitudeCheck(tankerAltitude, recieverAltitude: in Positive; altitudeCheckBool: out Boolean) is
   begin
      if tankerAltitude = recieverAltitude then
         altitudeCheckBool := TRUE;
      else
         altitudeCheckBool := FALSE;
      end if;
   end altitudeCheck;




end refuelling;
