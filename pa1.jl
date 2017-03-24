function ModelProblem1D(sigma, L)
    num_intervals = 2 ^ L
    sigma_h_squared = sigma * (1 / num_intervals) ^ 2
    mat = spzeros(num_intervals - 1, num_intervals - 1)
    for j = 1:(num_intervals - 1)
        for i = (j - 1):(j + 1)
            if i < j && i > 0
                mat[i,j] = -1
            elseif i == j
                mat[i,j] = 2 + sigma_h_squared
            elseif i > j && i <= (num_intervals - 1)
                mat[i,j] = -1
            end
        end
    end
    return mat * num_intervals ^ 2
end

function TensorWithI(mat, n)
    mat_size = size(mat)[1]
    result = spzeros(n * mat_size, n * mat_size)
    for i=0:(n - 1)
        start_index = 1 + i * mat_size
        end_index = (i + 1) * mat_size
        result[start_index:end_index,start_index:end_index] = mat
    end
    return result
end

function ModelProblem2D(sigma, L_x, L_y)
    x_mat = ModelProblem1D(sigma, L_x)
    y_mat = ModelProblem1D(sigma, L_y)

    x_size = 2 ^ L_x - 1
    y_size = 2 ^ L_y - 1
    return TensorWithI(x_mat, y_size) + TensorWithI(y_mat, x_size)
end

function SparseMatVec(A, x)
    return A * x
end

function test1DModel()
    full_mat = full(ModelProblem1D(0, 3))
    for i=1:7
        for j=1:7
            print(full_mat[i,j])
            print(" ")
        end
        print("\n")
    end
end

function test2DModel()
    mat = ModelProblem2D(0, 3, 3)
    print(mat)
end

function main()
    test1DModel()
end

main()
