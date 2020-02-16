# NumericalSoundSynthesis.jl
A framework for experimenting with sound generators in Julia

This is work in progress, may not work on your system yet. Especially it awaits for https://github.com/JuliaAudio/PortAudio.jl/pull/40 to be merged.

# Example

```julia
using NumericalSoundSynthesis
instruments = Instrument[];
push!(instruments, SineInstrument());
push!(instruments, PolySineInstrument(SineInstrument[]));
keyboard(instruments)
```
