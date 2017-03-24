NUM_THREADS = Threads.nthreads()

testA = [5 2 1 1; 2 6 2 1; 1 2 7 2; 1 1 2 8]
testB = [29 31 26 19]
ANS = [4 3 2 1]

function weigthedJacobi(A, b, initGuess, iterations, w=1)
  n = size(A)[1]
  currSoln = initGuess
  nextSoln = zeros(n)
  for iter = 1:iterations
    # Iterate updating each x_i, split work between threads.
    Threads.@threads for i = 1:n
      for j = 1:n
        if i != j
          nextSoln[i] -= A[i, j] * currSoln[j]
        end
      end
      nextSoln[i] += b[i]
      nextSoln[i] *= (w / A[i, i])
      nextSoln[i] += (1 - w) * currSoln[i]
    end
    currSoln = nextSoln
    nextSoln = zeros(n)
  end
  return currSoln
end

function gaussSeidel(A, b, initGuess, iterations)
  n = size(A)[1]
  soln = initGuess
  for iter = 1:iterations
    # Iterate updating each x_i, cannot multithread w/o some control structure..
    for i = 1:n
      tmp = 0
      for j = 1:n
        if i != j
          tmp -= A[i, j] * soln[j]
        end
      end
      tmp += b[i]
      tmp /= A[i, i]
      soln[i] = tmp
    end
  end
  return soln
end

function redBlackGaussSeidel(A, b, initGuess, iterations)
    n = size(A)[1]
    redSoln = initGuess
    blackSoln = copy(initGuess)
    for iter = 1:iterations
        Threads.@threads for t = 1:2
           if t == 1
               toEdit = redSoln
           else
               toEdit = blackSoln
           end
           for i = t:2:n
              tmp = 0
               for j = 1:n
                   if i != j
                       tmp -= A[i, j] * toEdit[j]
                   end
               end
               tmp += b[i]
               tmp /= A[i, i]
               toEdit[i] = tmp
           end
        end
        # Copy information over from red and black
        Threads.@threads for t = 1:2
            if t == 1
                src = redSoln
                dest = blackSoln
            else
                src = blackSoln
                dest = redSoln
            end
            for i = t:2:n
                dest[i] = src[i]
            end
        end
    end
    return redSoln
end



function main()
  print(weigthedJacobi(testA, testB, zeros(4), 20, 2 / 3))
  print("\n")
  print(gaussSeidel(testA, testB, zeros(4), 100))
  print("\n")
  print(redBlackGaussSeidel(testA, testB, zeros(4), 20))
  print("\n")
end

main()
