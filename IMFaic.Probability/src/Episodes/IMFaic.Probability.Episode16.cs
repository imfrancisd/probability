using System;
using Probability;
using ProbabilityEp16 = Probability.Episode16;

namespace IMFaic.Probability
{
    public static class Episode16
    {
        public static void RunProbability()
        {
            Console.WriteLine("Probability");
            ProbabilityEp16.DoIt();
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

