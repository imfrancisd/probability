using System;
using Probability;

namespace IMFaic.Probability
{
    public static class Episode6
    {
        public static void Run(string[] args)
        {
            RunProbability();
        }

        public static void RunProbability()
        {
            Console.WriteLine("Probability");
            Episode06.DoIt();
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

