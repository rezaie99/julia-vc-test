using VegaLite, DataFrames, Query, VegaDatasets

cars = dataset("cars")
cars |> @select(:Acceleration, :Name) |> collect

function foo(data, origin)
    df = data |> @filter(_.Origin==origin) |> DataFrame
    return df |> @vlplot(:point, :Acceleration, :Miles_per_Gallon)
end
p = foo(cars, "USA")
p |> save("foo.png")

using DataFramesMeta, RCall, DataFrames
using Statistics
flights = rcopy(R"nycflights13::flights")
@linq flights |>
    where(:month .== 1, :day .< 5) |>
    orderby(:day, :distance) |>
    select(:month, :day, :distance, :air_time)  |>
    transform(speed = :distance ./ :air_time * 60) |>
    by(:day, avgspeed = mean(skipmissing(:speed)))

using StatsPlots
(@linq flights |> where((!ismissing).(:air_time))) |> @df histogram(:air_time)

flights[1:10^4, :] |> @df scatter(:air_time, :distance, group=:carrier)

using Optim
rosenbrock(x) = (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2
result = optimize(rosenbrock, zeros(2), BFGS())

using Roots
f(x) = exp(x) - x^4
find_zero(f, 3)
