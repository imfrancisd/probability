using System;
using Probability;
using ProbabilityEp17 = Probability.Episode17;

namespace IMFaic.Probability
{
    public static class Episode17
    {
        public static void RunProbability()
        {
            Console.WriteLine("Probability");
            ProbabilityEp17.DoIt();
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

