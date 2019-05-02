using System;
using Probability;
using ProbabilityEp15 = Probability.Episode15;

namespace IMFaic.Probability
{
    public static class Episode15
    {
        public static void Run(string[] args)
        {
            RunProbability();
        }

        public static void RunProbability()
        {
            Console.WriteLine("Probability");
            ProbabilityEp15.DoIt();
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

