//+------------------------------------------------------------------+
//|                                              Harez Indicator.mq4 |
//|                                        Copyright 2021, Harezian. |
//|                                            ahadiyan.hr@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Harezian."
#property link      "ahadiyan.hr@gmail.com"
#property indicator_chart_window

int i;
int j;
int shift1 = 1;
int shift2 = 2;
int shift3 = 3;
string Alerts = "";
string Notif = "";
int Periods[7] = { 15, 30, 60, 240, 1440, 10080, 43200 };
string PeriodsName[7] = { "M15", "M30", "H1", "H4", "D1", "W1", "MN"};
double multiple[7] = { 1.5, 1.3, 1.1, 1.05, 1.0, 0.95, 0.9 };
datetime NewCandleTime[7] = { D'2015.01.01 00:00', D'2015.01.01 00:00', D'2015.01.01 00:00', D'2015.01.01 00:00', D'2015.01.01 00:00', D'2015.01.01 00:00', D'2015.01.01 00:00' };
   
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
  int init()
  {
   Comment("Harez LSH Alert is Running...");
   for(i=0 ; i < ArraySize(Periods); i++)
      {
      NewCandleTime[i]=iTime(Symbol(),Periods[i],0);
      }
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
  int deinit()
  {
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
  int start()
  {
//----
   


//----
   for(i=0 ; i < ArraySize(Periods); i++)
      {
      if ((NewCandleTime[i] != iTime(Symbol(),Periods[i],0)) && (Seconds() >= 15))
         {
         
         // Check for a Long Shadow pattern
         if (((iHigh(Symbol(), Periods[i], shift1)-iLow(Symbol(), Periods[i], shift1)) > multiple[i] * iATR(Symbol(), Periods[i], 63, shift1)) // Bigger than Master Candle
            && (MathAbs(iClose(Symbol(), Periods[i], shift1) - iOpen(Symbol(), Periods[i], shift1)) <= 0.3*(iHigh(Symbol(), Periods[i], shift1)-iLow(Symbol(), Periods[i], shift1)))) // Have a Big Shadows and Little Body
            {
            if ((iClose(Symbol(), Periods[i], shift1) > iOpen(Symbol(), Periods[i], shift1)) // Is a Bull
               && ((iOpen(Symbol(), Periods[i], shift1)-iLow(Symbol(), Periods[i], shift1)) >= 0.6*(iHigh(Symbol(), Periods[i], shift1)-iLow(Symbol(), Periods[i], shift1)))) // Have a Long Lower Shadow
               {
               Alerts = "LSH-Buy";
               }
            else if ((iClose(Symbol(), Periods[i], shift1) < iOpen(Symbol(), Periods[i], shift1)) // Is a Bear
                    && ((iClose(Symbol(), Periods[i], shift1)-iLow(Symbol(), Periods[i], shift1)) >= 0.6*(iHigh(Symbol(), Periods[i], shift1)-iLow(Symbol(), Periods[i], shift1)))) // Have a Long Lower Shadow
               {
               Alerts = "LSH-Buy";
               }
            else if ((iClose(Symbol(), Periods[i], shift1) > iOpen(Symbol(), Periods[i], shift1)) // Is a Bull
                    && ((iHigh(Symbol(), Periods[i], shift1)-iClose(Symbol(), Periods[i], shift1)) >= 0.6*(iHigh(Symbol(), Periods[i], shift1)-iLow(Symbol(), Periods[i], shift1)))) // Have a Long Upper Shadow
               {
               Alerts = "LSH-Sell";
               }
            else if ((iClose(Symbol(), Periods[i], shift1) < iOpen(Symbol(), Periods[i], shift1)) // Is a Bear
                    && ((iHigh(Symbol(), Periods[i], shift1)-iOpen(Symbol(), Periods[i], shift1)) >= 0.6*(iHigh(Symbol(), Periods[i], shift1)-iLow(Symbol(), Periods[i], shift1)))) // Have a Long Upper Shadow
               {
               Alerts = "LSH-Sell";
               }
            }
            
            // Check for a Persian Gulf pattern
            if (((iHigh(Symbol(), Periods[i], shift1) - iLow(Symbol(), Periods[i], shift1)) > multiple[i] * iATR(Symbol(), Periods[i], 63, shift1))
               && (MathAbs(iClose(Symbol(), Periods[i], shift1) - iOpen(Symbol(), Periods[i], shift1))/(iHigh(Symbol(), Periods[i], shift1) - iLow(Symbol(), Periods[i], shift1)) > 0.75) // LongBar 1
               && (MathAbs(iHigh(Symbol(), Periods[i], shift2) - iLow(Symbol(), Periods[i], shift2)) > 0.33 * multiple[i] * iATR(Symbol(), Periods[i], 63, shift1))
               && (MathAbs(iClose(Symbol(), Periods[i], shift2) - iOpen(Symbol(), Periods[i], shift2))/(iHigh(Symbol(), Periods[i], shift2) - iLow(Symbol(), Periods[i], shift2)) > 0.75) // LongBar 2
               && ((iClose(Symbol(), Periods[i], shift1) - iOpen(Symbol(), Periods[i], shift1))*(iClose(Symbol(), Periods[i], shift2) - iOpen(Symbol(), Periods[i], shift2)) < 0)) // Opposite LongBars
               {
               if ((iClose(Symbol(), Periods[i], shift1) > iOpen(Symbol(), Periods[i], shift1))) // Is a Bull
                  {
                  if( Alerts != "")
                     {
                     Alerts = Alerts+"/PG-Buy";
                     }
                  else
                     {
                     Alerts = "PG-Buy";
                     }
                  }
               if ((iClose(Symbol(), Periods[i], shift1) < iOpen(Symbol(), Periods[i], shift1))) // Is a Bear
                  {
                  if( Alerts != "")
                     {
                     Alerts = Alerts+"/PG-Sell";
                     }
                  else
                     {
                     Alerts = "PG-Sell";
                     }
                  }
               }
               
            // Check for Star pattern
            if (((iHigh(Symbol(), Periods[i], shift1) - iLow(Symbol(), Periods[i], shift1)) > multiple[i] * iATR(Symbol(), Periods[i], 63, shift1))
               && (MathAbs(iClose(Symbol(), Periods[i], shift1) - iOpen(Symbol(), Periods[i], shift1))/(iHigh(Symbol(), Periods[i], shift1) - iLow(Symbol(), Periods[i], shift1)) > 0.75) // LongBar 1
               && ((iHigh(Symbol(), Periods[i], shift2) - iLow(Symbol(), Periods[i], shift2)) < (multiple[i]/3) * iATR(Symbol(), Periods[i], 63, shift1)) // Star
               && (MathAbs(iHigh(Symbol(), Periods[i], shift3) - iLow(Symbol(), Periods[i], shift3)) > 0.6 * multiple[i] * iATR(Symbol(), Periods[i], 63, shift1))
               && (MathAbs(iClose(Symbol(), Periods[i], shift3) - iOpen(Symbol(), Periods[i], shift3))/(iHigh(Symbol(), Periods[i], shift3) - iLow(Symbol(), Periods[i], shift3)) > 0.75) // LongBar 2
               && ((iClose(Symbol(), Periods[i], shift1) - iOpen(Symbol(), Periods[i], shift1))*(iClose(Symbol(), Periods[i], shift3) - iOpen(Symbol(), Periods[i], shift3)) < 0)) // Opposite LongBars
               {
               if ((iClose(Symbol(), Periods[i], shift1) > iOpen(Symbol(), Periods[i], shift1))) // Is a Bull
                  {
                  if( Alerts != "")
                     {
                     Alerts = Alerts+"/Star-Buy";
                     }
                  else
                     {
                     Alerts = "Star-Buy";
                     }
                  }
               if ((iClose(Symbol(), Periods[i], shift1) < iOpen(Symbol(), Periods[i], shift1))) // Is a Bear
                  {
                  if( Alerts != "")
                     {
                     Alerts = Alerts+"/Star-Sell";
                     }
                  else
                     {
                     Alerts = "Star-Sell";
                     }
                  }
               }
               
            // Alert Notification
         if ( Alerts != "" )
            {
            if( Notif == "" )
               {
               Notif = Alerts+" in "+PeriodsName[i];
               }
            else if( Notif != "" )
               {
               Notif = Notif+" - "+Alerts+" in "+PeriodsName[i];
               }   
            Alerts = "";
            }
            NewCandleTime[i]=iTime(Symbol(),Periods[i],0);
         }
      if( (i == (ArraySize(Periods)-1)) && (Notif != "") )
         {
         Print(Symbol()+": "+Notif);
         bool Mail =  SendMail( Symbol()+": "+Notif , Symbol()+": "+Notif );
         Notif = "";
         }
      }  // End of for loop 1
   return(0);
  }
//+------------------------------------------------------------------+