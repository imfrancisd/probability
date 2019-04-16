using System;
using Probability;
using ProbabilityEp22 = Probability.Episode22;

namespace IMFaic.Probability
{
    public static class Episode22
    {
        public static void RunProbability()
        {
            Console.WriteLine("Probability");
            ProbabilityEp22.DoIt();
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

