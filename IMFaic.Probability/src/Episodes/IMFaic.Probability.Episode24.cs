using System;
using Probability;
using ProbabilityEp24 = Probability.Episode24;

namespace IMFaic.Probability
{
    public static class Episode24
    {
        public static void RunProbability()
        {
            Console.WriteLine("Probability");
            ProbabilityEp24.DoIt();
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

