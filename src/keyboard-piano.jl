
using PortAudio
import Base.Threads.@spawn

export keyboard

function getchar()
    ret = ccall(:jl_tty_set_mode, Int32, (Ptr{Cvoid},Int32), stdin.handle, true)
    ret == 0 || error("unable to switch to raw mode")
    c = read(stdin, Char)
    ccall(:jl_tty_set_mode, Int32, (Ptr{Cvoid},Int32), stdin.handle, false)
    return c
end

function keyboard(instruments::AbstractArray{Instrument})
    @assert length(instruments) > 0

    instr = 1
    instrument() = instruments[instr]

    isrunning = true
    audio_task = @spawn begin
        buf = zeros(Float64, 128)
        stream = PortAudioStream(0, 1; latency = 0.009, blocksize=16)
        try
            while isrunning
                write(stream, next!(buf, instrument()))
            end
        finally
            close(stream)
            println("audio stream is closed")
        end
    end
    
    while true
        c = getchar()

        tuning = instrument().tuning
        dict = keymap(tuning)
        if haskey(dict, c)
            tone = dict[c]
            resound!(instrument(), 440.0 * interval(tuning, tone))
        end
        val = UInt(c)
        if val == 3 || val == 27
            break
        end

        if c == '+' || c == '_'
            N = length(instruments)
            instr += ifelse(
                        c=='+',
                        ifelse(instr < N, 1, -N+1),
                        ifelse(instr > 1, -1, N-1))

            println("Now using instrument $instr: $(instrument()) with $tuning")

            @show instr
        end        
    end

    isrunning = false
    wait(audio_task)
end
