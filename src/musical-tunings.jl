
abstract type MusicalTuning end

struct EqualTemperedTuning <: MusicalTuning
    steps::Int
end

function interval(tuning::EqualTemperedTuning, i) where N
    return 2^(i/tuning.steps)
end

function is12tone(tuning::EqualTemperedTuning) where N
    return tuning.steps == 12
end

function keymap(tuning::EqualTemperedTuning)
    if !is12tone(tuning)
        error("Not implemented for non 12 tone yet")
    end

    return Dict(zip("zsxdcvgbhnjm,l.;/q2w3er5t6y7ui9o0p[=]", [0:16;12:31]))
end
