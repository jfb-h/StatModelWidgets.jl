app(modeltype; title = "") = App(title = "StatModelWidgets") do session
    return DOM.div(
        id = "wrapper",
        Asset("assets/styles.css"),
        header(title),
        modelview(amodel(modeltype)),
        footer(),
    )
end

function header(title)
    return DOM.header(
        DOM.h1(title)
    )
end

function footer()
    name = "Jakob Hoffmann"
    class = "Quantitative Methods and Statistics"
    return DOM.footer(
        DOM.span(class), "|",
        DOM.span(name),
    )
end

styledslider(range, value) = Bonito.StylableSlider(
    range; value = value, slider_height = 20,
    track_color = "slategray", track_active_color = "lightblue", thumb_color = "#fff",
    track_style = Styles("border" => "1px solid black"),
    track_active_style = Styles("border" => "1px solid black"),
    thumb_style = Styles("border" => "1px solid black"),
)

function slidergrid(sliders, labels)
    sl = map(sliders, labels) do s, l
        DOM.div(
            class = "slider-row",
            DOM.div(class = "slider-label", l),
            s,
            DOM.div(class = "slider-value", s.value)
        )
    end
    return DOM.div(id = "slidergrid", sl...)
end

description(amodel::AccessibleModel) = description(amodel.modelobj)
modelplot(amodel::AccessibleModel) = modelplot(amodel.modelobj)

function modelview(amodel)
    sliders, labels = sliders_from_model(amodel)
    omodel = model_from_sliders(sliders, amodel)

    data = Observable{Any}(nothing)

    simulate_btn = Bonito.Button("Generate Data", id = "button-generate")
    on(simulate_btn.value) do _
        data[] = simulate(omodel[])
    end

    clear_btn = Bonito.Button("Clear", id = "button-clear")
    on(clear_btn.value) do _
        data[] = nothing
    end

    buttons = DOM.div(id = "button-container", simulate_btn, clear_btn)

    cont = DOM.div(slidergrid(sliders, labels), buttons)
    desc = description(amodel)
    figr = modelplot(amodel)(omodel, data)

    grid = Grid(
        DOM.div(desc, class = "content-container", style = Styles("grid-area" => "left-top")),
        DOM.div(cont, class = "content-container", style = Styles("grid-area" => "left-bot")),
        DOM.div(figr, class = "content-container", style = Styles("grid-area" => "right")),
        columns = "4fr 5fr",
        rows = "1fr 1fr",
        areas = """
            'left-top right'
            'left-bot right';
        """
    )
    return DOM.main(DOM.div(grid; style = Styles("padding-right" => "30px", "padding-left" => "30px")))
end
