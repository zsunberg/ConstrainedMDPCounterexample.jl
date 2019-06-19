using Revise
using ConstrainedMDPCounterexample
using POMDPModelTools
using POMDPs
using POMDPPolicies
using DiscreteValueIteration
using Base.Iterators

# Undurti and How 2010

# By inspection, the optimal policy π∗ corresponding to a risk level α = 0.1 is to hop in state s1 but walk in state s2.

m = WalkHop(0.0, 0.95)

best = FunctionPolicy() do s
    if s == 1
        return :hop
    else
        return :walk
    end
end

vr = evaluate(m, best)
vc = evaluate(m, best, rewardfunction=cost)

@show vr(1)
@show vc(1)
println()

# exhaustively search for best policy
A = actions(m)
best = Pair[nothing => 0.0] # set of all the best ones
for tpl in product(A, A, A, A)
    p = VectorPolicy(m, [tpl...])
    vc = evaluate(m, p, rewardfunction=cost)
    if vc(1) <= 0.1
        vr = evaluate(m, p)
        if vr(1) == last(first(best))
            push!(best, p => vr(1))
        elseif vr(1) > last(first(best))
            global best = [p => vr(1)]
        end
    end
end
display(best)

# It can be shown that hop is chosen as the best action from state s2 for M < 900 but walk is chosen as the best action in state s1 for M ≥ 990. There is no value of M for which the optimal policy is obtained

# binary search for suitable M
m = WalkHop(0.0, 0.95)
solver = ValueIterationSolver()
bounds = [0.0, 1000.0]
tol = 1e-10
while bounds[2]-bounds[1] > tol
    M = mean(bounds)
    mm = WalkHop(M, discount(m))
    p = solve(solver, mm)
    vc = evaluate(m, p, rewardfunction=cost)
    if vc(1) > 0.1
        bounds[1] = M
    else
        bounds[2] = M
    end
    @show bounds
end
@show mm = WalkHop(bounds[1], discount(m))
p = solve(solver, mm)
display(p)
println()
@show evaluate(m, p, rewardfunction=cost)(1)
@show evaluate(m, p)(1)
println()

@show mm = WalkHop(bounds[2], discount(m))
p = solve(solver, mm)
display(p)
println()
@show evaluate(m, p, rewardfunction=cost)(1)
@show evaluate(m, p)(1)
println()
