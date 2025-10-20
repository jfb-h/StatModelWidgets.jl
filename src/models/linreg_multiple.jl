struct MultipleLinearRegression
    α::Float64
    β₁::Float64
    β₂::Float64
    σ::Float64
end

(m::MultipleLinearRegression)(x₁, x₂) = m.α + m.β₁ * x₁ + m.β₂ * x₂

function amodel(::Type{MultipleLinearRegression})
    lm = MultipleLinearRegression(0.0, 0.5, 0.0, 1.0)
    return AccessibleModel(
        lm, (
            (@o _.α) => -2 .. 2,
            (@o _.β₁) => -2 .. 2,
            (@o _.β₂) => -2 .. 2,
            (@o _.σ) => 0 .. 2,
        )
    )
end

description(::MultipleLinearRegression) = DOM.div(
    style = Styles("font-size" => "26pt", "font-weight" => 400, "color" => "hsl(0, 0%, 20%)"),
    DOM.p("\\[y = \\alpha + \\beta_1 x_1 + \\beta_2 x_2 + \\epsilon\\]"),
    DOM.p("\\[\\epsilon \\sim \\text{Normal}(0, \\sigma)\\]"),
)

function simulate(m::MultipleLinearRegression)
    n = 100
    x₁ = rand(n) .* 4 .- 2
    x₂ = rand(n) .* 4 .- 2
    y = [m(x₁i, x₂i) + m.σ * randn() for (x₁i, x₂i) in zip(x₁, x₂)]
    return (x₁, x₂, y)
end

function modelplot(::MultipleLinearRegression)
    return function (m, data)
        fig = Figure()
        ax = LScene(fig[1, 1]; width = 900, height = 800)

        x₁_range = -2:0.2:2
        x₂_range = -2:0.2:2

        plane_z = @lift [$(m)(x₁, x₂) for x₁ in x₁_range, x₂ in x₂_range]
        wireframe!(ax, x₁_range, x₂_range, plane_z; color = (:tomato, 0.5))

        scatter_x₁ = Observable(Float64[])
        scatter_x₂ = Observable(Float64[])
        scatter_y = Observable(Float64[])
        scatter!(ax, scatter_x₁, scatter_x₂, scatter_y; color = :black, markersize = 8)

        on(data) do d
            if isnothing(d)
                scatter_x₁[] = Float64[]
                scatter_x₂[] = Float64[]
                scatter_y[] = Float64[]
            else
                x₁, x₂, y = d
                scatter_x₁[] = x₁
                scatter_x₂[] = x₂
                scatter_y[] = y
            end
        end

        return fig
    end
end
