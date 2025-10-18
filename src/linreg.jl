struct LinearRegression
    α::Float64
    β::Float64
    σ::Float64
end

(m::LinearRegression)(x) = m.α + x * m.β

function amodel(::Type{LinearRegression})
    lm = LinearRegression(0.0, 1.0, 1.0)
    return AccessibleModel(
        lm, (
            (@o _.α) => -2 .. 2,
            (@o _.β) => -2 .. 2,
            (@o _.σ) => 0 .. 2,
        )
    )
end

description(::LinearRegression) = DOM.div(
    style = Styles("font-size" => "36pt", "font-weight" => 400, "color" => "hsl(0, 0%, 20%)"),
    DOM.p("y = α + xβ + ϵ"),
    DOM.p("ϵ ~ Normal(0, σ)"),
)

function simulate(m::LinearRegression)
    x = range(-2, 2; length = 100)
    y = [m(xi) + m.σ * randn() for xi in x]
    return x, y
end

function modelplot(::LinearRegression)
    return function (m, data)
        fig = Figure()
        ax = Axis(fig[1, 1]; xlabel = "x", ylabel = "y")

        lines!(ax, -2:0.1:2, @lift x -> $m(x))
        band!(ax, -2:0.1:2, @lift x -> ($m(x) - 2 * $m.σ .. $m(x) + 2 * $m.σ); alpha = 0.2)

        scatter_x = Observable(Float64[])
        scatter_y = Observable(Float64[])
        scatter!(ax, scatter_x, scatter_y; color = :black, markersize = 8)

        on(data) do d
            if isnothing(d)
                scatter_x[] = Float64[]
                scatter_y[] = Float64[]
            else
                x, y = d
                scatter_x[] = collect(x)
                scatter_y[] = y
            end
        end

        return fig
    end
end
