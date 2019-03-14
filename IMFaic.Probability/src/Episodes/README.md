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

Agent _\<fill in your name here\>_, the _Episode04 Branch_ of _Impossible Missions Faic_ has become divergent. We cannot confirm what happened because the NOC (non-official cover) list has been compromised. (Yes, I know the plot is confusing, but the visuals are awesome, so just go with it).

We think there might be a mole at the _Impossible Missions Faic_ and we have just intercepted the following message below:

```
commit 29b5e08e2dbcf7844d4601b129ad5f53bb9b8c32
Author: Francis de la Cerna <imfrancisd@users.noreply.github.com>
Date:   Thu Mar 14 03:09:25 2019 -0500

    Message To: Max@Job 3:14
    Message From: Job

    Max,
     Branch "episode04" has diverged. Merged from
    unknown non-official cover "kimsey0". Consider
    EXTREMELY BENIGN. Do not use.
     Fate will be that of kings and counsellors of
    the earth, who built for themselves places now
    lying in ruins. Must revert merge a.s.a.p.
```


**The Mission**

The mission has not changed. For all episodes, you must still make version \<episode\>.0.0 (without library) or version \<episode\>.1.0 (with library).

However, _Impossible Missions Faic_ have lost sight of their goal of fixing Random. We think the mole is responsible. Because of this, you must now build the API of IMFaic.Probability.dll on your own. You cannot follow the API from Probability.dll. Probability.dll has shifted its focus towards Distribution and away from Random. You can use Distributions in your API, but Random must be the central focus.

I repeat, the central focus of your API must be Random, not Distribution.


**Random Begins**

Our original mission was to fix Random. That is still our mission. That will always be our mission.

We think the mole distributed Poisson at _Impossible Missions Faic_ which has far worse effects than Chimera. After one hour of exposure, the victims can no longer distinguish probability from reality. After two hours, they become numerologists! Be careful, and do not get taken in with the web of lies, damned lies, and statistics, that is so rampant in this line of work.


**Oh, by the way, you have been disavowed**

But it's cool.

Because what you do have are a very particular set of skills. Skills you have acquired over a very long career. If _Impossible Missions Faic_ fixes Random, that will be the end of it - You will not look for Random, You will not pursue Random... but if they don't, You will look for Random, You will find Random... and You will fix Random.

Good luck.

\<dial tone\>
