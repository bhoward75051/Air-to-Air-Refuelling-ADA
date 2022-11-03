pragma SPARK_Mode (On);

with SPARK.Text_IO; use SPARK.Text_IO;

package refuelling is
   type statusIndicatorType is (Red, Amber, Green, Flashing_Green);

   procedure help;

   procedure deploy (tankerAltitude, recieverAltitude, airSpeed: in Positive; statusIndicator: Out statusIndicatorType) with
     Global => (In_Out => Standard_Output),
     Depends => (statusIndicator => (tankerAltitude, recieverAltitude, airSpeed),
                 Standard_Output => (Standard_Output, tankerAltitude, recieverAltitude, airSpeed)),
       Post => (if (airSpeed in 200 .. 400) and
                (tankerAltitude = recieverAltitude) and
                (tankerAltitude in 10000 .. 35000) and
                (recieverAltitude in 10000 .. 35000)
                then statusIndicator = Amber else statusIndicator = Red);

   procedure connect(length: in Positive; statusIndicator: out statusIndicatorType) with
     Global => (In_Out => Standard_Output),
     Depends => (statusIndicator => length,
                 Standard_Output => (Standard_Output, length)),
       Post => (if (length in 5 .. 20) then statusIndicator = Green else statusIndicator = Amber);

   procedure transfer(pressure, hoseLength: in Positive; statusIndicator: out statusIndicatorType) with
     Global => (In_Out => Standard_Output),
     Depends => (statusIndicator => (pressure, hoseLength),
                 Standard_Output => (Standard_Output, pressure, hoseLength)),
       Post => (if (pressure in 45 .. 55) and
                (hoseLength in 2 .. 10) then statusIndicator = Flashing_Green else statusIndicator = Green);


   procedure calculateFlowRate(length, pressure: in Positive; flowRate: out Positive) with
       Pre => ((pressure in 45 .. 55) and (length in 2 .. 10)),
       Depends => (flowRate => (length, pressure)),
       Post => (flowRate = ((pressure * 1963) / (120 * length)));

   procedure altitudeCheck(tankerAltitude, recieverAltitude: in Positive; altitudeCheckBool: out Boolean) with
       Pre => ((tankerAltitude in 10000 .. 35000) and (recieverAltitude in 10000 .. 35000)),
       Depends => (altitudeCheckBool => (tankerAltitude, recieverAltitude)),
       Post => (altitudeCheckBool = (tankerAltitude = recieverAltitude));

end refuelling;
