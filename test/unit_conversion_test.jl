function courses_test()
    @testset "Courses" begin
        dCourses = 7.5;
        mCourses = data_to_model_courses(dCourses);
        @test isa(mCourses, Integer)
        dCourses2 = model_to_data_courses(mCourses);
        @test dCourses2 == dCourses;
    end
end

function dollars_test()
	@testset "Dollars" begin
		dDollars = 1000.0;
		mDollars = dollars_data_to_model(dDollars, :perYear);
        dDollars2 = dollars_model_to_data(mDollars, :perYear);
        @test isapprox(dDollars, dDollars2)

		mDollars3 = dollars_data_to_model(dDollars, :perDay);
		@test mDollars3 > 300 * mDollars
		dDollars3 = dollars_model_to_data(mDollars3, :perDay);
		@test dDollars3 ≈ dDollars
	end
end

function time_units_test()
    @testset "Time units" begin
        mtu = [0.7, 0.2];
        validate_mtu(mtu);
        hours = mtu_to_hours_per_week(mtu);
        mtu2 = hours_per_week_to_mtu(hours);
        @test mtu ≈ mtu2

        modelHours = [0.2, 0.7];
        for timeFactor ∈ [:weeksPerYear, :daysPerYear, :hoursPerYear, :hoursPerWeek]
            hd = hours_mtu_to_data(modelHours, timeFactor);
            @test all(hd .> 0.0)
            @test all(hd .< CollegeStratBase.hoursPerYear)
            hm = hours_data_to_mtu(hd, timeFactor);
            @test all(hm .≈ modelHours)
        end

        hd = hours_mtu_to_data(modelHours, :hoursPerWeek);
        hd2 = mtu_to_hours_per_week(modelHours);
        @test all(hd .≈ hd2)
    end
end




@testset "Unit conversion" begin
    courses_test();
    dollars_test();
    time_units_test();
end

# -------------