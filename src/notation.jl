## -----------  Notation
#=
The notation is defined in a `numbers` spreadsheet. Everything else is generated from this.

Flow when modifying notation:
1. Edit the `numbers` file.
2. Export to `notation_table.csv`.
3. `write_notation_preamble()`
4. `write_notation_summary()`

Typeset `model_notation.lyx`

Since the notation material is also used in the paper (written by Oksana), all of these files live in Dropbox.
=#

const GpaLabel = "AFQT";

# This holds a copy of the symbol table, so it need not be reloaded all the time.
const SymTable = SymbolTable();


"""
	$(SIGNATURES)

Returns `SymbolTable` with notation. If `SymTable` is populated, returns it. Otherwise reads a CSV file.

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
    copy_symbol_table_from_dropbox();
    load_from_csv!(SymTable, sym_table_path());
end

sym_table_path(computer = :current) = 
    joinpath(notation_dir(computer), "notation_table.csv");

# Symbol table is hand-edited in a Dropbox dir. Needs to imported periodically.
function copy_symbol_table_from_dropbox()
    if !is_remote(get_computer(:current))
        tgDir = notation_dir();
        isdir(tgDir)  ||  mkpath(tgDir);
        srcPath = joinpath(dropbox_dir(), "lutz", "notation", "notation_table.csv");
        @assert isfile(srcPath)  "Not found: $srcPath";
        cp(srcPath, sym_table_path(); force = true);
    end
end

# Latex symbol by name
lsymbol(name :: Symbol) = latex(symbol_table(), name);
ldescription(name :: Symbol) = LatexLH.description(symbol_table(), name);


"""
	$(SIGNATURES)

Make an entry for a symbol. Returns a vector with (description, newcommand name, numerical value).

# Example
```
symbol_entry(st, :workTime, 1.2) == ("Work time", "workTimeV", 1.2)
```
"""
function symbol_entry(st :: SymbolTable, sName :: Symbol, value)
    si = st[sName];
    return LatexLH.description(si), "$(si.name)V", value
end


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
    return fPath
end

notation_preamble_path() = joinpath(notation_dir(), "notation_preamble.tex");

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

notation_summary_path() = joinpath(notation_dir(), "notation_summary.tex");

# ------------