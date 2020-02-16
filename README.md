# NumericalSoundSynthesis.jl
A framework for experimenting with sound generators in Julia

This is work in progress, may not work on your system yet.

# Example

```julia
using NumericalSoundSynthesis
instruments = Instrument[];
push!(instruments, SineInstrument());
keyboard(instruments)
```
