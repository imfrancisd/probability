using System;
using Probability;
using ProbabilityEp10 = Probability.Episode10;

namespace IMFaic.Probability
{
    public static class Episode10
    {
        public static void RunProbability()
        {
            Console.WriteLine("Probability");
            ProbabilityEp10.DoIt();
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

