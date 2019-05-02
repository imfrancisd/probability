using System;
using System.Threading;
using Probability;

namespace IMFaic.Probability
{
    public static class Episode2
    {
        public static void Run(string[] args)
        {
            RunProbability();
        }

        public static void RunProbability()
        {
            Console.WriteLine("Probability");
            PseudorandomIsGoodEnough.DoIt();
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

    static class PseudorandomIsGoodEnough
    {
        static string s = "";
        public static void DoIt()
        {

            Console.WriteLine(
@"Episode 2: Pseudorandom is good enough
Random is not thread safe, and its common failure mode
is to get into a state where it can only produce zero.
This bug has been fixed. If we don't have that problem with
Pseudorandom, then I suppose Pseudorandom is good enough.");

            for (int i = 0; i < 100; ++i)
            {
                new Thread(() => s += Pseudorandom.NextInt() + " ").Start();
            }

            // Yeah I should wait for those to finish. Oh well.
            Console.WriteLine(s);
        }
    }
}
