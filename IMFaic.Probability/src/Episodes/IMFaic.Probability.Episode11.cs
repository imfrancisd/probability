using System;
using Probability;
using ProbabilityEp10 = Probability.Episode10;

namespace IMFaic.Probability
{
    public static class Episode11
    {
        public static void Run(string[] args)
        {
            RunProbability();
        }

        public static void RunProbability()
        {
            Console.WriteLine("Probability");
            //No Probability.Episode11.
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

