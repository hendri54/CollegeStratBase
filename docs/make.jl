using Documenter, CollegeStratBase

makedocs(
    modules = [CollegeStratBase],
    format = Documenter.HTML(; prettyurls = get(ENV, "CI", nothing) == "true"),
    authors = "hendri54",
    sitename = "CollegeStratBase.jl",
    pages = Any["index.md"]
    # strict = true,
    # clean = true,
    # checkdocs = :exports,
)

deploydocs(
    repo = "github.com/hendri54/CollegeStratBase.jl.git",
    push_preview = true
)
