# Episodes

This contains all the IMFaic.Probability.Episode*.cs files.

Each IMFaic.Probability.Episode*.cs will contain a Main() method which will be used as the Main() method for IMFaic.Probability.exe.

For example
```
    IMFaic.Probability.Episode04.cs
```
will contain the Main() method that will be used to build
```
    bin\IMFaic.Probability\4.0.0\IMFaic.Probability.exe
```

This allows us to build any episode of this particular fabulous adventure in coding without worrying about which diverging forks we have taken in the road.



## Episode01

https://ericlippert.com/2019/01/31/fixing-random-part-1/

Episode01 demonstrates System.Random.

No library functionality to add to IMFaic.Probability.

No challenges from the episode01 blog post.



## Episode02

https://ericlippert.com/2019/02/04/fixing-random-part-2/

Episode02 demonstrates two new random number generators (BetterRandom and PseudoRandom)

* BetterRandom - better than System.Random
* PseudoRandom - better than BetterRandom, but uses BetterRandom under the hood

No library functionality to add to IMFaic.Probability.

### Your mission should you choose to accept it
No code in episode02 demonstrates the use of BetterRandom or PseudoRandom.

Demonstrate the use of PseudoRandom.

### Your mission should you choose to accept it

From the episode02 blog post

> Exercise: An alternative, and possibly better solution, would be to build the double from bits directly, rather than doing an expensive division. I have not actually written the code or done the math here; as an exercise, does doing so produce a better distribution in any way?
