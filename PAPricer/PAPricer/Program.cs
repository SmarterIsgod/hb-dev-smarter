using System;

namespace PAPricer
{
    static class Program
    {
        static void Main()
        {
            // x = Base Unit Price 
            // y = Percentage of Discount

            // y = undercutPrice / x 
            // z = y * 100 (Percentage) - Round to Whole Number
            // n = b * z
            Console.WriteLine("Please Enter a Price For 10,000g");
            Console.WriteLine();
            Console.Write("$");
            double curPrice = Convert.ToDouble(Console.ReadLine())/10; // curPrice = 1.529 / 1000g
            double undercutPrice = curPrice - 0.001;
            double bestN = 0d;
            double bestX = 0d;
            double bestZ = 0d;

            // EXAMPLE:
            // y = 1.528 / 5 = 0.3056
            // z = 0.3056 * 100 = 30.56 - Rounded = 30 / 100 = 0.30
            // n = 5 * 0.30 = 1.5
           
            for (double x = 5; x < 1000; x = x + 0.01)
            {
                x = Math.Round(x, 2);
                var y = undercutPrice / x;
                var z = Math.Floor(y * 100) / 100;
                var n = x*z;

                if (n > bestN && (1 - z) <= 0.80)
                {
                    bestN = n;
                    bestX = x;
                    bestZ = z;
                }

            }
            Console.WriteLine();
            Console.WriteLine("Best Unit Price: " + bestX);
            Console.WriteLine("Best Undercut Percentage: " + (1 - bestZ) * 100);
            Console.WriteLine((2*bestX) - ((2*bestX)*bestZ));
            Console.ReadLine();
            Console.Clear();
            const string multi = "<b>US > ILLIDAN > HORDE</b>\n" +
                                 "</br></br>\n" +
                                 "<b>UNDER ${0}:</br></b>\n" +
                                 "1000g = ${2}\n" +
                                 "</br></br>\n" +
                                 "<b>-[ Over ${0} Receive a {1}% Discount! ]- </b></br>\n" +
                                 "> 2000g = ${3}!</br>\n" +
                                 "> 10000g = ${4}!</br>\n" +
                                 "> 20000g = ${5}!</br>\n" +
                                 "> 40000g = ${6}!</br>\n" +
                                 "> 50000g = ${7}!</br>";
            // 0 = Unit Price, Rounded up to Dollar
            // 1 = bestZ
            // 2 = bestX
            // 3 = 2x Unit Price * Undercut
            // 4 = 10 x Unit Price * Undercut
            // 5 = 20 x Unit Price * Undercut
            // 6 = 40 x Unit Price * Undercut [int myInt = myInt * -1]
            double zero = Math.Round(bestX, 0) + 1;
            double one = (1 - bestZ)*100;
            double three = Math.Abs((bestX * 2) * (1 - bestZ));
            Console.WriteLine(three + " - WHAT THE FUCK1?");
            double four = Math.Abs((bestX * 10 - bestX * 10 * bestZ));
            double five = Math.Abs((bestX * 20 - bestX * 20 * bestZ));
            double six = Math.Abs((bestX * 40 - bestX * 40 * bestZ));
            double seven = Math.Abs((bestX * 50 - bestX * 50 * bestZ));
            Console.Write(multi, Math.Round(zero, 2), Math.Round(one, 2), Math.Round(bestX, 2),
                Math.Round(three, 2), Math.Round(four, 2), Math.Round(five, 2), Math.Round(six, 2), Math.Round(seven, 2));
            Console.ReadLine();
        }
    }
}
