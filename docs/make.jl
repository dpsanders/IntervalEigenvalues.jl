import Documenter

Documenter.deploydocs(
    repo = "github.com/dpsanders/IntervalEigenvalues.jl.git",
    target = "build",
    deps = nothing,
    make = nothing
)
