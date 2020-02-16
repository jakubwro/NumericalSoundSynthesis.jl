
include("oscillators.jl")

export SineInstrument

mutable struct SineInstrument <: Instrument
    amplitude
    oscillator::SineOscillator
    function SineInstrument()
        sinewave = SineOscillator(440.0Hz, 1.0)
        return new(0.0, sinewave)
    end
end

function resound!(instrument::SineInstrument, tone)
    instrument.amplitude = 1.0
    instrument.oscillator = SineOscillator(tone * Hz, 1.0)
end

function next!(array, instrument::SineInstrument)

    for i in eachindex(array)
        array[i] = oscillate!(instrument.oscillator)
        instrument.amplitude *= 0.9998
        array[i] *= instrument.amplitude
    end

    return array
end
