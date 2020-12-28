using CollegeStratBase
using Test

@testset "All" begin
    include("directories_test.jl");
    include("unit_conversion_test.jl");
    include("notation_test.jl");
    include("display_test.jl");
end

# ---------------