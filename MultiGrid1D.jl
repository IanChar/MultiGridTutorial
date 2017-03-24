include("Grids.jl")
include("Smoothers.jl")
include("Interpolators.jl")

SIGMA = 1
ITERATIONS = 20

type Level
    A
    P
    R
    f
    v
end

function formLevel(level, f, v)
    A = ModelProblem1D(SIGMA, level)
    P = getInterpolationOperator(level - 1)
    R = getFullWeightingOperation(level)
    return Level(A, P, R, f, v)
end

function VCycle(f, v, levelNum)
   levelData = formLevel(levelNum, f, v)
   # Relaxation
   v = gaussSeidel(levelData.A, levelData.f, levelData.v, ITERATIONS)
   if levelNum > 1
       # Find the residual and restrict it to coarser grid
       residual = levelData.f - levelData.A * v
       residual = levelData.R * residual
       # Form blank error initial guess and recurse.
       error = zeros(2 ^ (levelNum - 1) - 1)
       error = VCycle(residual, error, levelNum - 1)
       # Use the error to correct the guess.
       v = v + levelData.P * error
   end
   # More relaxation with the new updated solution.
   v = gaussSeidel(levelData.A, levelData.f, v, ITERATIONS)
   return v
end

function MultiGrid1DMain()
    print(VCycle(zeros(2^4 -1), rand(2^4 - 1), 4))
    print("\n")
end

MultiGrid1DMain()
