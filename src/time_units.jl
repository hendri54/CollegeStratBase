# Time units


## --------------  Endowments
# One model time unit is `hoursPerWeek = 112` data hours per week.
# This is also the time endowment.

# 7 * 16 hours per week
const weeksPerYear = 52
const daysPerYear = 365
const hoursPerWeek = 112
const hoursPerYear = hoursPerWeek * weeksPerYear;


## ------------  Convert data to model time units

# Convert model time units into hours per week
function mtu_to_hours_per_week(mtu)
    hoursPerWeek .* mtu;
end

function hours_per_week_to_mtu(hours)
    return hours ./ hoursPerWeek;
end

function time_factor(timeUnit :: Symbol)
    if timeUnit == :weeksPerYear
        tf = weeksPerYear;
    elseif timeUnit == :daysPerYear
        tf = daysPerYear;
    elseif timeUnit == :hoursPerYear
        tf = hoursPerYear;
    elseif timeUnit == :hoursPerWeek
        tf = hoursPerWeek;
    else
        error("Invalid timeUnit: $timeUnit")
    end
    return tf
end


"""
	$(SIGNATURES)

Convert arbitrary data hours into model time units.
"""
function hours_data_to_mtu(hours, timeUnit :: Symbol)
    tf = time_factor(timeUnit);
    return hours ./ tf
end

function hours_mtu_to_data(hours, timeUnit :: Symbol)
    tf = time_factor(timeUnit);
    return hours .* tf
end

# Convert hours per year to hours per week
per_year_to_per_week(hours) = 
    hours ./ time_factor(:weeksPerYear);


## -------------  Validate model time units

"""
	$(SIGNATURES)

Validate model time units
"""
function validate_mtu(mtu)
    if any(mtu .< 0.0)  ||  any(mtu .> 1.0)
        error("""
            Invalid time input: 
            $mtu
        """);
    end
    return nothing
end


# -----------
