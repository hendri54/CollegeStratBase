## --------  Unit conversions: courses

# Number of model courses per data course. Setting to 2 allows for half courses in the model, which helps with equally spaced grids.
const modelCoursesPerCourse = ncInt(2);

function model_to_data_courses(mCourses)
    return round.(mCourses ./ modelCoursesPerCourse; digits = 1)
end

# Always returns `ncInt`. Do not use to transform Floats (such as std errors).
function data_to_model_courses(dCourses :: I1) where I1 <: Number
    return round(ncInt, dCourses * modelCoursesPerCourse)
end


## ----------  Dollars

# Base year for prices
const baseYear = 2000
# Conversion factor for data dollars to model dollars
const dollarFactor = 1000.0
# Multiple a data dollar amount by this factor to make it annual
# Deprecated
const dTimeFactors = Dict{Symbol,Float64}([
    :perYear => 1.0,
    :perMonth => 12.0,
    :perWeek => weeksPerYear,
    :perDay => daysPerYear,
    :perHour => hoursPerYear
]);


"""
    $(SIGNATURES)

Conversions of data to model dollars.
"""
function dollars_data_to_model(dDollars, timeUnit :: Symbol)
    return dDollars ./ dollarFactor .* dTimeFactors[timeUnit]
end

# More efficient (static dispatch; no dicts)
dollars_data_to_model(dDollars, timeUnit :: AbstractTimeUnit) = 
    dDollars ./ dollarFactor .* time_factor(timeUnit);

function dollars_data_to_model!(dDollars :: AbstractArray, 
        timeUnit :: AbstractTimeUnit)
    dDollars .*= (time_factor(timeUnit) ./ dollarFactor);
end

function dollars_model_to_data(mDollars, timeUnit :: Symbol)
    return mDollars .* dollarFactor ./ dTimeFactors[timeUnit]
end

dollars_model_to_data(mDollars, timeUnit :: AbstractTimeUnit) = 
    mDollars .* dollarFactor ./ time_factor(timeUnit);

dollars_model_to_data!(mDollars :: AbstractArray, timeUnit :: AbstractTimeUnit) = 
    mDollars .*= (dollarFactor ./ time_factor(timeUnit));

dollars_to_data_units(::DataUnits, dollars, timeUnit) = dollars;
dollars_to_data_units(::ModelUnits, dollars, timeUnit) = 
    dollars_model_to_data(dollars, timeUnit);

dollars_to_model_units(::ModelUnits, dollars, timeUnit) = dollars;
dollars_to_model_units(::DataUnits, dollars, timeUnit) = 
    dollars_data_to_model(dollars, timeUnit);


"""
	$(SIGNATURES)

Check that dollar values are in bounds, which are given in data units.
"""
function check_dollar_values(::DataUnits, dollars, lb, ub)
    return check_dollar_values(1.0, dollars, lb, ub);
end

# Assumes per year
function check_dollar_values(::ModelUnits, dollars, lb, ub)
    dollarFactor = dollars_data_to_model(1.0, TuYear());
    return check_dollar_values(dollarFactor, dollars, lb, ub)
end

function check_dollar_values(modelUnits :: Bool, dollars, lb, ub)
    if modelUnits
        mUnits = ModelUnits();
    else
        mUnits = DataUnits();
    end
    check_dollar_values(mUnits, dollars, lb, ub);
end

# Bounds are in data units.
function check_dollar_values(dollarFactor :: Double, dollars, lb, ub)
    isValid =  all(lb * dollarFactor .<= dollars .<= ub * dollarFactor);
    if !isValid
        @info """
            Dollar values out of bounds.
            Required:
            $(lb * dollarFactor) <= $(minimum(dollars))
            $(ub * dollarFactor) >= $(maximum(dollars))
            """;
    end
    return isValid
end


dollar_factor(::ModelDollars{TU}, ::ModelDollars{TU}) where TU = 1.0;
dollar_factor(::DataDollars{TU}, ::DataDollars{TU}) where TU = 1.0;
dollar_factor(::DataDollars{TU}, ::ModelDollars{TU}) where TU = 1.0 / dollarFactor;
dollar_factor(::ModelDollars{TU}, ::DataDollars{TU}) where TU = dollarFactor;

d2m(x) = x ./ dollarFactor;
m2d(x) = x .* dollarFactor;

dollar_convert(x, d1 :: T, d2 :: T) where T <: AbstractDollars = x;

function dollar_convert(x, d1 :: T1, d2 :: T2) where 
        {T1 <: AbstractDollars, T2 <: AbstractDollars}
	return x .* dollar_factor(d1, d2);
end

dollar_convert!(x, d1 :: T, d2 :: T) where T <: AbstractDollars = nothing;

function dollar_convert!(x, d1 :: T1, d2 :: T2) where
        {T1 <: AbstractDollars, T2 <: AbstractDollars}
    x .*= dollar_factor(d1, d2);
end

# ----------------