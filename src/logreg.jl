struct LogisticRegression
    α::Float64
    β::Float64
end

(m::LogisticRegression)(x) = 1 / (1 + exp(-(m.α + x * m.β)))

function amodel(::Type{LogisticRegression})
    lm = LogisticRegression(0.0, 1.0)
    return AccessibleModel(
        lm, (
            (@o _.α) => -4 .. 4,
            (@o _.β) => -4 .. 4,
        )
    )
end

description(::LogisticRegression) = DOM.div(
    style = Styles("font-size" => "30pt", "font-weight" => 400, "color" => "hsl(0, 0%, 20%)"),
    DOM.p("\\[p = \\frac{1}{e^{-(\\alpha + x\\beta)}}\\]"),
    DOM.p("\\[y \\sim \\textrm{Bernoulli}\\big(p\\big)\\]"),
)

function simulate(m::LogisticRegression)
    x = range(-2, 2; length = 100)
    y = [rand() < m(xi) ? 1.0 : 0.0 for xi in x]
    return x, y
end

function modelplot(::LogisticRegression)
    return function (m, data)
        fig = Figure()
        ax = Axis(fig[1, 1]; xlabel = "x", ylabel = "p(y = 1)")

        ylims!(ax, 0, 1)

        lines!(ax, -2:0.1:2, @lift x -> $m(x))

        scatter_x = Observable(Float64[])
        scatter_y = Observable(Float64[])
        scatter!(ax, scatter_x, scatter_y; color = :black, marker = '|', markersize = 22)

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
