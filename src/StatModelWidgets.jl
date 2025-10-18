module StatModelWidgets

using Bonito
using WGLMakie
using AccessibleModels

Bonito.browser_display()

include("model.jl")
include("linreg.jl")
include("logreg.jl")
include("linreg_interaction.jl")
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
            "/logistic-regression" => app(LogisticRegression; title = "Logistic Regression"),
            "/interaction" => app(LinearRegressionInteraction; title = "Interaction Effect"),
        )
    end
end

end # module StatModelWidgets
