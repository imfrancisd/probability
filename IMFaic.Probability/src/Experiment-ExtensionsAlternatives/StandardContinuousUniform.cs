/* Code inspired from episode03
 * https://github.com/ericlippert/probability/tree/episode03
 *
 * Using default interface methods.
 *
 * Fair Use? I hope so.
 * - nonprofit, check
 * - educational, check
 * - transformative, check
 * - criticism/comment, hmmm...
 *   - staticstics is horrible (I'm sorry)
 *   - probability is horrible (I'm really sorry)
 *   - worse than System.Random (I'm obligated by fair use law!)
 */

using RNG = Probability.Pseudorandom;

namespace IMFaic.Probability
{
    public sealed class StandardContinuousUniform : IDistribution<double>
    {
        public double Sample()
        {
            return RNG.NextDouble();
        }
    }
}

