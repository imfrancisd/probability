# Episodes

This contains all the IMFaic.Probability.Episode*.cs files.



## Episode1

https://ericlippert.com/2019/01/31/fixing-random-part-1/

Episode1 demonstrates System.Random.

No library functionality to add to IMFaic.Probability.

No challenges from the episode01 blog post.



## Episode2

https://ericlippert.com/2019/02/04/fixing-random-part-2/

Episode2 demonstrates two new random number generators (BetterRandom and PseudoRandom)

* BetterRandom - better than System.Random
* PseudoRandom - better than BetterRandom, but uses BetterRandom under the hood

No library functionality to add to IMFaic.Probability.

### Your mission should you choose to accept it
No code in episode02 demonstrates the use of BetterRandom or PseudoRandom.

Demonstrate the use of PseudoRandom.

### Your mission should you choose to accept it

From the episode02 blog post

> Exercise: An alternative, and possibly better solution, would be to build the double from bits directly, rather than doing an expensive division. I have not actually written the code or done the math here; as an exercise, does doing so produce a better distribution in any way?



## Episode3

https://ericlippert.com/2019/02/07/fixing-random-part-3/

Episode03 "fixes" Random, not by making a new random number generator, but by using Distributions instead.

### Your mission should you choose to accept it

This episode introduced the following

* Probability.IDistribution
* Probability.Normal
* Probability.StandardContinuousUniform

and some extension methods.

Which of those should be made public in IMFaic.Probability? Should the names be kept the same or changed? How should they be exposed in IMFaic.Probability?

### Your mission should you choose to accept it

From the episode03 blog post

> Exercise: make this a non-singleton that takes a source of randomness as a parameter, and feel all fancy because now you’re doing “dependency injection”.

From the episode03 blog post

> Exercise: Rescue the above princess in a single LINQ expression without getting Jon to do it for you. (I haven’t actually tried this; I’d be interested to know if it is possible.  )

_These missions seem iffy._ DI (Die Hard?) and LINQ (Zelda?)? _That is not even the right movie!_

### Your mission should you choose to accept it

> Exercise: Try implementing the Irwin-Hall distribution (hint: it’s already written in this episode!)

> Exercise: Try implementing the Gamma distribution using the Ahrens-Dieter algorithm.

> Exercise: Try implementing the Poisson distribution as an IDistribution<int>.

_These missions are now really, really iffy._ A mission that is already completed and Poisson distribution?! What is going on at Impossible Missions Faic?

\<Cue suspenseful music\>



## Episode3.14

...
