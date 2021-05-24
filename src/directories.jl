# Basedir is expected at this location relative to home for file transfer
const relBaseDir = 
	joinpath("Documents", "projects", "p2019", "college_stratification");

"""
	$(SIGNATURES)

Points to `college_stratification`. All project files are in this directory.

Currently not relocatable.
"""
function base_dir(computer :: Union{Symbol, Computer} = :current)
	# if isequal(computer, :current)
	# 	# Can construct even if the computer is not known
	# 	# This points to `src`. But note that once the package is `add`ed, this resides in `.julia`.
	# 	progDir = dirname(@__DIR__);
	# 	# Two up from `src`
	# 	return dirname(progDir);
	# else
		return joinpath(home_dir(computer), relBaseDir)
	# end
end


"""
	$(SIGNATURES)

Directory for Julia shared code. Perhaps not needed?
"""
function julia_dir(computer :: Union{Symbol, Computer} = :current)
	return joinpath(home_dir(computer),  "Documents",  "julia")
end

"""
	$(SIGNATURES)

Code and other material that get synced to `github` are here.
"""
function project_dir(computer :: Union{Symbol, Computer} = :current)
    return joinpath(base_dir(computer),  "CollegeStrat");
end


# Files for the paper live here
paper_dir(computer :: Union{Symbol, Computer} = :current) = 
	joinpath(dropbox_dir(), "lutz", "paper");
	
"""
	$(SIGNATURES)

Base directory for all output files.
"""
function computer_out_dir(computer :: Union{Symbol, Computer} = :current)
    return joinpath(base_dir(computer), "out")
end


"""
	$(SIGNATURES)

Comparisons across cases are stored here.
"""
function global_comparison_dir(computer :: Union{Symbol, Computer} = :current)
    return joinpath(computer_out_dir(computer), "compare")
end


"""
	$(SIGNATURES)

Base directory for all `mat` files (binaries).
"""
function computer_mat_dir(computer :: Union{Symbol, Computer} = :current)
    return joinpath(base_dir(computer), "mat")
end

computer_json_dir(computer :: Union{Symbol, Computer} = :current) = 
	joinpath(base_dir(computer), "mat");


"""
	$(SIGNATURES)

Logs need to be outside of the directory that gets `rsync`ed to longleaf.
Otherwise logs of running jobs get overwritten.
"""
function computer_log_dir(computer :: Union{Symbol, Computer} = :current)
	return joinpath(base_dir(computer),  "log")
end


# Put files generated by tests here
function test_dir()
	return joinpath(computer_out_dir(), "test_files")
end


## -----------  Files needed for paper
# Live in Dropbox

dropbox_dir() = "/Users/lutz/Dropbox/Dropout Policies";

notation_dir() = joinpath(dropbox_dir(), "lutz", "notation");


# -------