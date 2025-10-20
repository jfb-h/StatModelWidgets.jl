struct LinearRegressionInteraction
    α::Float64
    β₁::Float64
    β₂::Float64
    β₃::Float64
    σ::Float64
end

(m::LinearRegressionInteraction)(x, d) = m.α + m.β₁ * x + m.β₂ * d + m.β₃ * x * d

function amodel(::Type{LinearRegressionInteraction})
    lm = LinearRegressionInteraction(0.0, 1.0, 0.5, 0.0, 1.0)
    return AccessibleModel(
        lm, (
            (@o _.α) => -3 .. 3,
            (@o _.β₁) => -3 .. 3,
            (@o _.β₂) => -3 .. 3,
            (@o _.β₃) => -3 .. 3,
            (@o _.σ) => 0 .. 2,
        )
    )
end

description(::LinearRegressionInteraction) = DOM.div(
    style = Styles("font-size" => "26pt", "font-weight" => 400, "color" => "hsl(0, 0%, 20%)"),
    DOM.p("\\[y = \\alpha + \\beta_1 x + \\beta_2 z + \\beta_3 (x \\times z) + \\epsilon\\]"),
    DOM.p("\\[\\epsilon \\sim \\text{Normal}(0, \\sigma)\\]"),
)

function simulate(m::LinearRegressionInteraction)
    x = range(-2, 2; length = 50)
    # Generate data for both d=0 and d=1
    x0 = x
    y0 = [m(xi, 0) + m.σ * randn() for xi in x0]
    x1 = x
    y1 = [m(xi, 1) + m.σ * randn() for xi in x1]
    return (x0, y0, x1, y1)
end

function modelplot(::LinearRegressionInteraction)
    return function (m, data)
        fig = Figure()
        ax = Axis(fig[1, 1]; xlabel = "x", ylabel = "y")

        lines!(ax, -2:0.1:2, @lift(x -> $m(x, 0)); label = "z = 0", color = :blue)
        lines!(ax, -2:0.1:2, @lift(x -> $m(x, 1)); label = "z = 1", color = :red)

        band!(ax, -2:0.1:2, @lift(x -> ($m(x, 0) - 2 * $m.σ .. $m(x, 0) + 2 * $m.σ)); alpha = 0.2, color = :blue)
        band!(ax, -2:0.1:2, @lift(x -> ($m(x, 1) - 2 * $m.σ .. $m(x, 1) + 2 * $m.σ)); alpha = 0.2, color = :red)

        scatter_x0 = Observable(Float64[])
        scatter_y0 = Observable(Float64[])
        scatter!(ax, scatter_x0, scatter_y0; color = :blue, markersize = 8, label = "z = 0")

        scatter_x1 = Observable(Float64[])
        scatter_y1 = Observable(Float64[])
        scatter!(ax, scatter_x1, scatter_y1; color = :red, markersize = 8, label = "z = 1")

        axislegend(ax; position = :lt, merge = true, backgroundcolor = :transparent, nbanks = 2)

        on(data) do d
            if isnothing(d)
                scatter_x0[] = Float64[]
                scatter_y0[] = Float64[]
                scatter_x1[] = Float64[]
                scatter_y1[] = Float64[]
            else
                x0, y0, x1, y1 = d
                scatter_x0[] = collect(x0)
                scatter_y0[] = y0
                scatter_x1[] = collect(x1)
                scatter_y1[] = y1
            end
        end

        return fig
    end
end
