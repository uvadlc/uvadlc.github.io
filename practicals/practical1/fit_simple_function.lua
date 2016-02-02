require 'torch'
require 'optim'
Plot = require 'itorch.Plot'
torch.setdefaulttensortype('torch.DoubleTensor')

-------------------------------------------------------------------------------
-- QUESTION 3.3

-- TODO. Load the points and plot them
data = ...

-- TODO
d = -- define the number of parameters, namely the dimensionality of your parameter vector
    -- Note that this is a global variable, so you can access it from everywhere
n = -- define the number of data points, which you want to fit, namely the number of entries in your data structure

function feval(theta)
    
    local f = function(theta)
        -- TODO. Implement the function that we want to fit
        -- Note that compared to the previous example, where the input to the function was x, namely the points, now the input is the parameter vector theta.
        -- The reason is that now are x inputs are already observed (given).
        -- What we do not observe, namely what we do not know but we want to find out by optimizing, are the parameters theta. 

        -- It's good here if you define ***by default*** all your variables to be local.
        -- It's alright if you mess it up, you will get a runtime error and you don't have access to a variable
        -- Then, you just drop the keyword local.
        -- It's much worse if you forget to add the keyword local and your variable changes values because of other, external functions.
        -- The problem in that case is that you will not get a runtime error, you will just get crazy numbers.
        -- Since the variable theta should be accessed by different parts of the script, you can keep it global.
        local loss = ...
        local fval = ...

        -- Compute fval

        -- Compute the loss from question 2.1
        -- Don't forget to average the loss by the number of data points.

        return loss, fval
    end

    local g = function(theta, fval)
	    -- TODO. Implement the gradient of the function that we want to fit
	    -- Here we have two inputs, theta and fval.
	    -- We could have dropped the second one by having it as a global variable.
	    -- In the spirit of code cleaniness and "no surprises" rule, it's better if we make it local and explicitly call it.

	    -- Note that here the function we finally want to optimize is not f, but the difference of the output f from the observed outputs y, namely the loss.
	    -- So, our final gradient is not just the gradient of function f, but of the total loss function, which by simple calculus includes also the gradients of function f.

    	return grad
	end
 
	-- Above we defined the functions locally.
	-- We could have defined them in another file for that matter, but this way is perhaps more compact and less cluttered.
	-- In any case suit yourself, pick your way.
	-- Here, you call the functions that you have implemented before.
	-- Their output is what feval should return in the end.
    local loss, fval = f(theta)
    local grad = g(theta, z)

    return loss, grad, fval
end

-------------------------------------------------------------------------------
-- QUESTION 3.4

-- TODO define your state variable
state = {
   ...
}

-- TODO define your initialization.
-- You can pick a random vector using torch.randn
-- Naturally, the parameters theta as well as the gradient wrt to the parameters should have the same dimensionality
theta = ...
grad = ...

-- TODO fill in the code for the optimization and run it
-- stop when the gradient is close to 0, or after many iterations
lossall = torch.Tensor(state.maxIter+1):zero()
iter = 1
while true do
    -- optim has multiple functions, such as adagrad, sgd, lbfgs, and others
    -- see documentation for more details
    theta, f_ = optim.cg(...
    lossall[iter] = f_[1]
    
    -- gradient norm is SOMETIMES a good measure of how close we are to the optimum, but often not.
    -- the issue is that we'd stop at points like x=0 for x^3
    if grad:norm() < 0.005 or iter > state.maxIter then 
        break 
    end
    iter = iter + 1
end

print('f optimal: ' .. f_[1])
print('Optimal parameters:')
print(theta)
print('[Targets, Predictions]:')

-- Run the feval once more if you want to get the outputs based on the final, optimal theta
loss, grad, z = feval(theta)
print(torch.cat(data.targets, z, 2))

-- Plot the curve and the points. Do they make sense?
Plot():line(torch.range(1, state.maxIter+1), fall_, 'green'):title('Training loss'):draw()
