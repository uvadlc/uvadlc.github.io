require 'torch'
require 'optim'
Plot = require 'itorch.Plot'
torch.setdefaulttensortype('torch.DoubleTensor')

-------------------------------------------------------------------------------
-- QUESTION 2.1
function f(x)
	-- TODO
    return fval
end

xrange = torch.linspace(-2, 2, 51)
frange = -- Compute the fval of the function for all the xrange points

Plot():line(xrange, frange):title('Function graph'):draw()

-------------------------------------------------------------------------------
-- QUESTION 2.2
function g(x)
    -- TODO
    return grad
end

grange = -- Compute the gradient for all the xrange points

Plot():line(xrange, dfrange):title('Gradient graph'):draw()

-------------------------------------------------------------------------------
-- QUESTION 2.3

function feval(x)
    
    local f = function(x)
    -- TODO
    -- You can add here the function you implmemented above
	end

	local g = function(x)
    -- TODO
    -- You can add here the gradient of the function you implemented above
	end

    return fval, grad
end

-- In the optim package your need to define a table with the state variable during the optimization.
-- The state variable contains various information about the current point of the optimization, like the learning rate etc.
state = {
   learningRate = 1e-1
}

-- Define here an initialization for x, e.g. 5
x = torch.Tensor{5}
-- Define a tensor to store all the gradients computed during the optimization
grad_all = torch.Tensor{100}


iter = 0
while true do
    -- optim has multiple functions, such as adagrad, sgd, lbfgs, and others
    -- see documentation for more details
    -- TODO. Call the optimization function here
    -- xoptim, foptim = optim.adagrad(...
 
    -- gradient norm is SOMETIMES a good measure of how close we are to the optimum, but often not.
    -- the issue is that we'd stop at points like x=0 for x^3

    -- stop when the gradient is close to 0, or after many iterations, e.g. 50000.
    -- You can add this in the state variable, so that everything is neat.
    if dfval:norm() < 0.005 or iter > 50000 then 
        break 
    end
    iter = iter + 1
end

Plot():line(xrange, frange, 'red'):circle(xoptim, foptim, 'blue'):title('Function plot and minimum point'):draw()
