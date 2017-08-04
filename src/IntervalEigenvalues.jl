module IntervalEigenvalues

using IntervalArithmetic, IntervalRootFinding, Polynomials
using IntervalOptimisation


export characteristic_polynomial, eigenvalue_bounds


function characteristic_polynomial{T}(A::AbstractMatrix{T})

    n = size(A, 1)
    c = zeros(T, n+1)

    M_old = zeros(T, n, n)

    c[end] = 1

    for k = 1:n

        M_new = A*M_old + c[n+1-k+1]*eye(T, n, n)

        c[n+1-k] = -trace(A*M_new) / k  # `trace(A*M) / k` doesn't work for some reason

        M_old = M_new

        # should store product A*M for next step
    end

    return c
end


function eigenvalue_bounds(A::AbstractMatrix)
    AI = IntervalArithmetic.Interval.(A)  # interval version

    p = characteristic_polynomial(AI)
    P = Poly(p)

    X = Complex(-10..10, -10..10)
    eigvals = IntervalRootFinding.roots(P, X, 1e-5)
    root_intervals = [root.interval for root in eigvals]

    rts = [ IntervalBox(reim(λ)) for λ in root_intervals ]
    rts = unify(rts)

    complex_roots = [Complex(root...) for root in rts]
    return complex_roots

end


end
