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

function dollars_model_to_data(mDollars, timeUnit :: Symbol)
    return mDollars .* dollarFactor ./ dTimeFactors[timeUnit]
end


# ----------------