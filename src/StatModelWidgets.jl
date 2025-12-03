module StatModelWidgets

using Bonito
using WGLMakie
using AccessibleModels

Bonito.browser_display()

include("model.jl")
include("slidergrid.jl")
include("models/linreg.jl")
include("models/logreg.jl")
include("models/linreg_interaction.jl")
include("models/linreg_multiple.jl")

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

function deploy()
    assets = [joinpath(@__DIR__, "../assets/styles.css")]
    server = Bonito.Server("127.0.0.1", 8082; proxy_url = "https://eggroup.geographie.uni-muenchen.de/statswidgets")
    route!(server, "/linear-regression" => app(LinearRegression; title = "Simple Linear Regression"))
    route!(server, "/logistic-regression" => app(LogisticRegression; title = "Logistic Regression"))
    route!(server, "/interaction-effect" => app(LinearRegressionInteraction; title = "Interaction Effect"))
    route!(server, "/multiple-linear-regression" => app(MultipleLinearRegression; title = "Multiple Linear Regression"))
end

function develop()
    assets = [joinpath(@__DIR__, "../assets/styles.css")]
    return routes, task, server = interactive_server(assets) do
        return Routes(
            "/" => app(LinearRegression; title = "Simple Linear Regression"),
            "/logistic-regression" => app(LogisticRegression; title = "Logistic Regression"),
            "/interaction-effect" => app(LinearRegressionInteraction; title = "Interaction Effect"),
            "/multiple-linear-regression" => app(MultipleLinearRegression; title = "Multiple Linear Regression"),
        )
    end
end

@main(ARGS) = begin
    set_theme!(theme)
    assets = [joinpath(@__DIR__, "../assets/styles.css")]
    return routes, task, server = interactive_server(assets) do
        return Routes(
            "/" => app(LinearRegression; title = "Simple Linear Regression"),
            "/logistic-regression" => app(LogisticRegression; title = "Logistic Regression"),
            "/interaction-effect" => app(LinearRegressionInteraction; title = "Interaction Effect"),
            "/multiple-linear-regression" => app(MultipleLinearRegression; title = "Multiple Linear Regression"),
        )
    end
end


end # module StatModelWidgets
