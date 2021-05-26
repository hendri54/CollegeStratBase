"""
	$(SIGNATURES)

This is used to list settings for nested `ModelObject`s.
"""
settings_table(x) = Matrix{String}();

"""
	$(SIGNATURES)

This is used to write literals from nested objects into preambles. Objects return `Vector{Vector{String}}` or `Vector{Tuple}`. Each entry contains (description, newcommand name, value).
"""
settings_list(x, st) = Vector{Vector{String}}();



"""
$(SIGNATURES)

Display current time and date as "2020-Jan-10 at 10:35am".
"""
function current_time()
    x = Dates.now();
    return Dates.format(x, "Y-u-d") * " at " * Dates.format(x, "HH:MM")
end


# Given a vector of things that can be converted to string, return a string of the form "abc_def_dhi" with connector character `linkChar`
function chain_strings(v :: AbstractVector{T}, linkStr = "_") where T
    s = string(v[1]);
    if length(v) > 1
        for j = 2 : length(v)
            s = s * string(linkStr) * string(v[j])
        end
    end
    return s
end

chain_strings(v :: AbstractString, linkStr = "_") = v;


"""
$(SIGNATURES)

Format a vector of numbers with a header. Output is a string.
"""
function format_vector(headerStr, numberV, nDigits :: Integer)
    roundV = round.(numberV, digits = nDigits);
    if isempty(headerStr)
        return "$roundV"
    else
        return headerStr * ":  $roundV"
    end
end


"""
$(SIGNATURES)

Show a text table.
"""
function show_text_table(tbM; io = stdout)
    pretty_table(io, tbM, noheader = true);
    return nothing
end


function show_text_table(tbM, headerV, fPath :: T1) where T1 <: AbstractString
    open(fPath, "w") do io
        pretty_table(io,  tbM,  headerV);
        println("Saved  $(fpath_to_show(fPath))")
    end
end


function show_matrix(io :: IO, m :: Matrix{F1}, 
ndigits :: Integer) where F1 <: AbstractFloat

    nr, nc = size(m);
    for ir = 1 : nr
        for ic = 1 : nc
            print(io, round(m[ir, ic], digits = ndigits), "\t");
        end
        println(io, " ");
    end
    println(io, " ");
end


## Format a single number in easy to read format.
function format_number(x :: Number; format :: Symbol = :default)
    if format == :dollars
        return format_dollars(x);
    elseif format == :default
        return format_number_default(x);
    elseif format == :none
        return string(x);
    else
        error("Invalid format: $format")
    end
end


## Format a number for display in a table
function format_number_default(x :: Number)
    absX = abs(x);
    if absX > 1e3
        y = format(x, precision = 1, commas = true);
    elseif absX > 1
        y = format(x, precision = 2, commas = false);
    elseif absX > 0.01
        y = format(x, precision = 4);
    else
        y = format(x, precision = 6);
    end
    return y
end


## Format a dollar number
function format_dollars(x; decimals = 0)
    format(x, precision = decimals, commas = true);
end


# Show a file name with `n` last directories
function fpath_to_show(fPath :: String; nDirs :: Integer = 3)
    fDir, fName = splitdir(fPath);
    s = right_dirs(fDir, nDirs) * " - " * fName;
    return s
end


# Display calibrated if true and fixed if false
function calibrated_string(isCal :: Bool; fixedValue = nothing) 
    if isCal
        x = "calibrated"
    else
        if isnothing(fixedValue)
            valStr = "";
        else
            valStr = " with value $fixedValue";
        end
        x = "fixed" * valStr;
    end
    return x
end

# --------------