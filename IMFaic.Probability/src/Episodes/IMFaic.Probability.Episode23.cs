using System;
using Probability;
using ProbabilityEp23 = Probability.Episode23;

namespace IMFaic.Probability
{
    public static class Episode23
    {
        public static void Run(string[] args)
        {
            RunProbability();
        }

        public static void RunProbability()
        {
            Console.WriteLine("Probability");
            ProbabilityEp23.DoIt();
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

