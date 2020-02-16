
export Instrument

abstract type Instrument end

function Base.getproperty(instrument::Instrument, sym::Symbol)
    if sym === :tuning && !hasfield(typeof(instrument), sym)
        return EqualTemperedTuning(12)
    else # fallback to getfield
        return getfield(instrument, sym)
    end
end
