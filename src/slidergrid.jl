using AccessibleModels
using AccessibleModels: from_transformed, transformed_vec
using AccessibleModels.Printf
using AccessibleModels: @p, flatmap
using Makie

function model_from_sliders(sliders, amodel)
    observable_model = Observable{Any}(amodel.modelobj)
    slidervals = lift(tuple, map(s -> s.value, sliders)...)
    map!(observable_model, slidervals) do vals
        typeof(amodel.modelobj)(vals...)
    end
    return observable_model
end

function labels_from_model(amodel)
    return string.(fieldnames(typeof(amodel.modelobj)))
end

function sliders_from_model(amodel)
    labels = labels_from_model(amodel)
    ranges = amodel.distributions
    values = map(l -> getfield(amodel.modelobj, Symbol(l)), labels)
    @assert length(labels) == length(ranges) == length(values)
    sliders = map(labels, ranges, values) do l, r, v
        styledslider(range(r; step = 0.1), v)
    end
    return sliders, labels
end

# function liftT(f::Function, T::Type, args...)
#     # THIS IS FOR GETTING VALUE LABELS
#     res = Observable{T}(f(to_value.(args)...))
#     map!(f, res, args...)
#     return res
# end

# function Makie.SliderGrid(pos, m::AccessibleModel; title = "$(nameof(typeof(m.modelobj))):", fmt = x -> @sprintf("%.3f", x), rowgap = nothing, kwargs...)
#     result = Observable{Any}(m.modelobj)
#     tvec = transformed_vec(m)
#     i_tvec = 0
#     sliders = flatmap(enumerate(m.optics)) do (i, o)
#         curvals = liftT(result -> getall(result, o), Any, result)
#
#         labels = @p let
#             AccessorsExtra.flat_concatoptic(m.modelobj, o)
#             AccessorsExtra._optics
#             map(AccessorsExtra.barebones_string)
#         end
#
#         map(enumerate(labels)) do (j, label)
#             Label(pos[i, 1][j, 1], label)
#             Label(pos[i, 1][j, 3], @lift fmt($curvals[j]))
#             i_tvec += 1
#             sl = Slider(pos[i, 1][j, 2]; range = range(0, 1; length = 300), startvalue = tvec[i_tvec], kwargs...)
#         end
#     end
#     Label(pos[0, :], title, tellwidth = false)
#     if !isnothing(rowgap)
#         rowgap!(pos, rowgap)
#     end
#
#     slidervals = lift(tuple, map(s -> s.value, sliders)...)
#     map!(result, slidervals) do vals
#         from_transformed(vals, m)
#     end
#     return result, sliders
# end
