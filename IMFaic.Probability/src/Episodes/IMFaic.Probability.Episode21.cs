using System;
using Probability;
using ProbabilityEp21 = Probability.Episode21;

namespace IMFaic.Probability
{
    public static class Episode21
    {
        public static void RunProbability()
        {
            Console.WriteLine("Probability");
            ProbabilityEp21.DoIt();
            Console.WriteLine("Press Enter to finish");
            Console.ReadLine();
        }

        public static void RunIMFaicProbability()
        {
            Console.WriteLine("IMFaic.Probability");
            Console.WriteLine("Press Enter to finish");
            Console.ReadLine();
        }
    }
}

