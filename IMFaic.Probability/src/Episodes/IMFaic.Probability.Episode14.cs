using System;
using Probability;
using ProbabilityEp14 = Probability.Episode14;

namespace IMFaic.Probability
{
    public static class Episode14
    {
        public static void RunProbability()
        {
            Console.WriteLine("Probability");
            ProbabilityEp14.DoIt();
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

