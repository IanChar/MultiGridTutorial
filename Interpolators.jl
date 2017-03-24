function getInterpolationOperator(level)
    num_intervals = 2 ^ level
    mat = spzeros(2 * num_intervals - 1, num_intervals - 1)
    for j = 1:(num_intervals - 1)
        for i = (2 * j - 1):(2 * j + 1)
            if i == 2 * j
                mat[i, j] = 1
            else
                mat[i, j] = 0.5
            end
        end
    end
    return mat
end

function getInjectionOperator(level)
    num_intervals = 2 ^ level
    mat = spzeros(div(num_intervals, 2) - 1, num_intervals - 1)
    for i = 1:(div(num_intervals, 2) - 1)
        mat[i, 2 * i] = 1
    end
    return mat
end

function getFullWeightingOperation(level)
    mat = transpose(getInterpolationOperator(level - 1))
    mat /= 2
    return mat
end

### Tests

function testInterpolationOperator()
    P = full(getInterpolationOperator(2))
    for i = 1:7
        for j = 1:3
            print(P[i, j])
            print(" ")
        end
        print("\n")
    end
end

function testInjectionOperator()
    P = full(getInjectionOperator(3))
    for i = 1:3
        for j = 1:7
            print(P[i, j])
            print(" ")
        end
        print("\n")
    end
end

function testFullWeightingOperator()
    P = full(getFullWeightingOperation(3))
    for i = 1:3
        for j = 1:7
            print(P[i, j])
            print(" ")
        end
        print("\n")
    end
end

function testOneAndTwo()
    print("----------------Interpolation-----------\n")
    testInterpolationOperator()
    print("\n--------------Injection---------------\n")
    testInjectionOperator()
    print("\n------------FullWeighting------------\n")
    testFullWeightingOperator()
end

function main()
    testOneAndTwo()
end

