# Generating reproducible random numbers
CustomRNG(seed) = StableRNG(seed);


"""
	$(SIGNATURES)

Copy a file, given by a relative path, from `srcDir` to `tgDir`.
Make `tgDir` if needed.
"""
function copy_file(fPath :: AbstractString, srcDir :: AbstractString, tgDir)
    srcPath = joinpath(srcDir, fPath);
    tgPath = joinpath(tgDir, fPath);
    if isfile(srcPath)
        make_dir(tgPath);
        cp(srcPath, tgPath; force = true);
    else
        @warn "Source file not found: $fPath"
    end
end



"""
	$(SIGNATURES)

Present value factor. Converts a constant stream into a present value.
First payoff is not discounted.
"""
pv_factor(R, T) = (((1/R) ^ T) - 1) / (1/R - 1);

"""
	$(SIGNATURES)

Present value of a stream. First entry not discounted.
"""
function present_value(xV, R)
    F = eltype(xV);
    pv = zero(F);
    discFactor = one(F);
    for x in xV
        pv += x / discFactor;
        discFactor *= R;
    end
    return pv
end


# Save anything that can be `print`ed to a text file.
function save_text_file(fPath, txtV :: AbstractVector; io = nothing)
    open(fPath, "w") do ioWrite
        for txt in txtV
            println(ioWrite, txt);
        end
    end
    showPath = fpath_to_show(fPath);
    isnothing(io)  ||  println(io, "Saved  $showPath");
end


"""
	$(SIGNATURES)

Legend for data versus model.
Small so that it does not cover graph.        
"""
data_model_labels() = ["D" "M"];


# Points to CollegeStratBase dir
pkg_dir() = normpath(joinpath(@__DIR__, ".."));

# For test files created by this package only.
test_file_dir() = joinpath(pkg_dir(), "test_files");


# ----------------