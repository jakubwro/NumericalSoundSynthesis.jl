
include("oscillators.jl")

export SineInstrument, PolySineInstrument

mutable struct SineInstrument <: Instrument
    amplitude
    oscillator::SineOscillator
    function SineInstrument(f = 440.0, amp=0.0)
        sinewave = SineOscillator(f * Hz, amp)
        return new(amp, sinewave)
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

struct PolySineInstrument <: Instrument
    sines::Array{SineInstrument}
end

function resound!(instrument::PolySineInstrument, tone)
    push!(instrument.sines, SineInstrument(tone, 1.0))
    @show length(instrument.sines)
end

function next!(array, instrument::PolySineInstrument)
    for i in eachindex(array)
        v = 0.0
        for s in instrument.sines
            v += oscillate!(s.oscillator)
            s.amplitude *= 0.99995
            v *= s.amplitude
            deleteat!(instrument.sines, findall(s->s.amplitude < 0.01, instrument.sines))
        end
        array[i] = v
    end

    return array
end
