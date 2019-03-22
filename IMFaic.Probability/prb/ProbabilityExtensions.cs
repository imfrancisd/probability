using System;
using System.Collections.Generic;

namespace Probability
{
    internal static class IMFaicProbabilityExtensions
    {
        public static TValue GetValueOrDefault<TKey, TValue>(this IDictionary<TKey, TValue> dictionary, TKey key, TValue defaultValue)
        {
            if (dictionary.TryGetValue(key, out TValue value))
            {
                return value;
            }

            return defaultValue;
        }
    }
}
