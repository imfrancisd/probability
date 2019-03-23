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

using System.Collections.Generic;
using System.Linq;
using ProbabilityFuncs = Probability.Extensions;

namespace IMFaic.Probability
{
    public interface IDistribution<T>
    {
        T Sample();

        public IEnumerable<T> Samples()
        {
            while (true)
            {
                yield return this.Sample();
            }
        }

        public string Histogram(double low, double high)
        {
            var d = this as IDistribution<double>;

            if (d != null)
            {
                return ProbabilityFuncs.Histogram(d.Samples(), low, high);
            }

            return string.Empty;
        }
    }
}

