using System;
using Probability;
using ProbabilityEp13 = Probability.Episode13;

namespace IMFaic.Probability
{
    public static class Episode13
    {
        public static void RunProbability()
        {
            Console.WriteLine("Probability");
            ProbabilityEp13.DoIt();
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

