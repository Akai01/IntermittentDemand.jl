using IntermittentDemand
using Documenter

DocMeta.setdocmeta!(IntermittentDemand, :DocTestSetup, :(using IntermittentDemand); recursive=true)

makedocs(;
    modules=[IntermittentDemand],
    authors="Resul Akay <resulakay1@gmail.com> and contributors",
    repo="https://github.com/akai01/IntermittentDemand.jl/blob/{commit}{path}#{line}",
    sitename="IntermittentDemand.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://akai01.github.io/IntermittentDemand.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/akai01/IntermittentDemand.jl",
    devbranch="main",
)
