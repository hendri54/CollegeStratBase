module CollegeStratBase

using Dates, DocStringExtensions, Formatting, PrettyTables
using FilesLH, LatexLH

include("types.jl");
include("constants.jl");
include("directories.jl");
include("notation.jl");
include("time_units.jl");
include("unit_conversions.jl");
include("display.jl");
include("testing.jl");

# Types
export Double, TimeInt, ncInt, TypeInt, CollInt, SchoolInt, GridInt

# Directories
export relBaseDir, base_dir, julia_dir, project_dir, paper_dir, test_dir, parent_dirs
export computer_out_dir, computer_mat_dir, computer_log_dir, computer_json_dir, global_comparison_dir

# Notation
export SymTable, symbol_table, reload_symbol_table, lsymbol, ldescription, symbol_entry
export write_notation_preamble, notation_preamble_path, write_notation_summary

# Display
export format_number, format_dollars, format_vector, chain_strings
export current_time, show_text_table, show_matrix, fpath_to_show, calibrated_string
export settings_list, settings_table

# Unit conversions
export hours_per_week_to_mtu, hours_data_to_mtu, hours_mtu_to_data, validate_mtu, mtu_to_hours_per_week, per_year_to_per_week
export model_to_data_courses, data_to_model_courses
export dollars_data_to_model, dollars_model_to_data

# Debugging
export dbgLow, dbgMedium, dbgHigh

# Testing
export test_header, test_divider

end # module
