using System;
using System.Linq;

namespace IMFaic.Probability
{
    public static class EpisodeExperimentExtensionsAlternatives
    {
        public static void RunProbability()
        {
            RunIMFaicProbability();
        }

        public static void RunIMFaicProbability()
        {
            Console.WriteLine("IMFaic.Probability - Using Default Interface Methods");

            IDistribution<double> scu = new StandardContinuousUniform();

            Console.WriteLine("The sum of 12 random doubles:");
            Console.WriteLine(scu.Samples().Take(12).Sum());
            Console.WriteLine("A histogram of the SCU:");
            Console.WriteLine(scu.Histogram(0, 1));

            Console.WriteLine("Press Enter to finish");
            Console.ReadLine();
        }
    }
}
