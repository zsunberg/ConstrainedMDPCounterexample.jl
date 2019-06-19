module ConstrainedMDPCounterexample

using POMDPs
using POMDPModelTools

export
    WalkHop,
    cost

struct WalkHop <: MDP{Int,Symbol}
    M::Float64
    discount::Float64
end

WalkHop(M) = WalkHop(M, 1.0)

POMDPs.states(::WalkHop) = 1:4
POMDPs.actions(::WalkHop) = [:walk, :hop]

POMDPs.n_states(::WalkHop) = 4
POMDPs.n_actions(::WalkHop) = 2

POMDPs.stateindex(::WalkHop, s::Int) = s
POMDPs.actionindex(::WalkHop, a::Symbol) = a == :walk ? 1 : 2

POMDPs.discount(m::WalkHop) = m.discount

function POMDPs.transition(m::WalkHop, s::Int, a::Symbol)
    if s == 1
        if a == :walk
            return Deterministic(2)
        else
            @assert a == :hop
            return SparseCat([2,4], [0.9, 0.1])
        end
    else
        @assert s == 2
        if a == :walk
            return Deterministic(3)
        else
            return SparseCat([3, 4], [0.99, 0.01])
        end
    end
end

POMDPs.isterminal(m::WalkHop, s::Int) = s in (3, 4)

function POMDPs.reward(m::WalkHop, s, a, sp)
    r = 0.0
    if a == :hop # guess
        r += 100.0
    end
    return r - m.M * cost(m, s, a, sp)
end

function cost(m::WalkHop, s, a, sp)
    if sp == 4
        return 1.0
    else
        return 0.0
    end
end

horizon(::WalkHop) = 2

end # module
