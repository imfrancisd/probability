using System;
using System.IO;
using Probability;
using ProbabilityEp25 = Probability.Episode25;

namespace IMFaic.Probability
{
    public static class Episode25
    {
        public static void Run(string[] args)
        {
            RunProbability();
        }

        public static void RunProbability()
        {
            Console.WriteLine("Probability");
            if (File.Exists("shakespeare.txt"))
            {
                ProbabilityEp25.DoIt();
            }
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

