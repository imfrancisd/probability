using System;
using Probability;
using ProbabilityEp25 = Probability.Episode25;

namespace IMFaic.Probability
{
    public static class Episode25
    {
        public static void RunProbability()
        {
            Console.WriteLine("Probability");
            ProbabilityEp25.DoIt();
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

