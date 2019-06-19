# ConstrainedMDPCounterexample.jl

This package contains an implementation of the counterexample in Section IV.A of

[Undurti, A., & How, J. P. (2010). An Online Algorithm for Constrained POMDPs. In International Conference on Robotics and Automation.](https://ieeexplore.ieee.org/document/5509743)

[scripts/reproduce.jl](/scripts/reproduce.jl) should convince you that, when the discount factor is strictly less than one, there is no value for M that yields the optimal policy.
