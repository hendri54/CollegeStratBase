function notation_test()
    @testset "Notation" begin
        reload_symbol_table();
        st = symbol_table();
        @test lsymbol(:studyTime) isa String
        @test ldescription(:studyTime) isa String
        descr, cmd, v = symbol_entry(st, :studyTime, 0.55);
        @test descr == ldescription(:studyTime)
        @test cmd == "studyTimeV"
        @test v == 0.55

        fPath = joinpath(test_dir(), "notation_preamble_test.tex");
        isfile(fPath)  &&  rm(fPath);
        write_notation_preamble(fPath = fPath);
        @test isfile(fPath);

        fPath = joinpath(test_dir(), "notation_summary_test.tex");
        isfile(fPath)  &&  rm(fPath);
        write_notation_summary(fPath = fPath);
        @test isfile(fPath);
	end
end

@testset "Notation" begin
    notation_test();
end

# --------------