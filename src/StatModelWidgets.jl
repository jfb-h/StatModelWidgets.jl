module StatModelWidgets

using Bonito
using WGLMakie
using AccessibleModels
using AccessibleModels: AccessorsExtra, getall
using Printf

Bonito.browser_display()

include("model.jl")
include("linreg.jl")
include("slidergrid.jl")

const theme = Theme(
    size = (900, 700),
    backgroundcolor = :transparent,
    fonts = (; regular = "Roboto Mono"),
    fontsize = 20,
    textcolor = :grey20,
    Axis = (
        leftspinevisible = false,
        bottomspinevisible = false,
        rightspinevisible = false,
        topspinevisible = false,
        backgroundcolor = "#b3b3b3",
        xgridcolor = "white",
        ygridcolor = "white",
    ),
)

@main(ARGS) = begin
    set_theme!(theme)
    assets = [joinpath(@__DIR__, "../assets/styles.css")]
    return routes, task, server = interactive_server(assets) do
        return Routes(
            "/" => app(LinearRegression; title = "Simple Linear Regression"),
        )
    end
end

end # module StatModelWidgets
