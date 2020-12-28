## -----------  Notation
#=
The notation is defined in a `numbers` spreadsheet. Everything else is generated from this.

Flow when modifying notation:
1. Edit the `numbers` file.
2. Export to `notation_table.csv`.
3. `write_notation_preamble()`
4. `write_notation_summary()`

Typeset `model_notation.lyx`
=#

# This holds a copy of the symbol table, so it need not be reloaded all the time.
const SymTable = SymbolTable();


"""
	$(SIGNATURES)

Returns `SymbolTable` with notation. If `SymTable` is populated, returns it. Otherwise reads a CSV file that is hand-written.

This will be used by `write_notation_preamble`.

Todo: Allow for recursive symbol definitions. This can already be done, but one needs to ensure that dependencies are in groups that come earlier than uses.
"""
function symbol_table(; forceReload :: Bool = false)
    if forceReload  ||  isempty(SymTable)
        reload_symbol_table();
    end
    return SymTable
end

function reload_symbol_table()
    LatexLH.erase!(SymTable);
    load_from_csv!(SymTable, joinpath(paper_dir(), "notation_table.csv"));
end

# Latex symbol by name
lsymbol(name :: Symbol) = latex(symbol_table(), name);
ldescription(name :: Symbol) = LatexLH.description(symbol_table(), name);


"""
	$(SIGNATURES)

Write preamble with newcommand statements that define notation for the paper.
Calls `symbol_table` to make code revisions easier.
"""
function write_notation_preamble(; fPath = notation_preamble_path())
    st = symbol_table(forceReload = true);
    # fPath = notation_preamble_path();
    println("Writing notation preamble to ", fpath_to_show(fPath));
    make_dir(fPath);
    open(fPath, "w") do io
        write_preamble(io, st);
    end
    println("Done");
end

notation_preamble_path() = joinpath(paper_dir(), "notation_preamble.tex");

"""
	$(SIGNATURES)

Write a tex file that lists notation. To be included in another document as a Section.
"""
function write_notation_summary(; fPath = notation_summary_path())
    println("Writing notation summary to ", fpath_to_show(fPath));
    make_dir(fPath);
    open(fPath, "w") do io
        write_notation_tex(io, symbol_table(forceReload = true));
    end
    println("Done");
end

notation_summary_path() = joinpath(paper_dir(), "notation_summary.tex");

# ------------