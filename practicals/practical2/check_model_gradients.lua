-- If you implemented your "define_model" as a script, you might want to
-- reimplement it as function. That way you can call a local instance that
-- is impervious to changes on the variables
local define_model_wrapper = require 'define_model_wrapper'

-------------------------------------------------------
-- FUNCTIONS
-------------------------------------------------------

-- function that numerically checks gradient of the loss:
-- f is the scalar-valued function
-- g returns the true gradient (assumes input to f is a 1d tensor)
-- returns difference, true gradient, and estimated gradient
local function checkgrad(f, g, x, eps)

  -- compute true gradient
  local grad = g(x)
  
  -- compute numeric approximations to gradient
  local eps = eps or 1e-5
  local grad_est = -- Initialize variable

  for i = 1, grad:size(1) do
    -- TODO: do something with x[i] and evaluate f twice, and put your estimate of df/dx_i into grad_est[i]
    local xorig = -- Original value
    f_plus = -- Compute the network response, f(x+epsilon)
    f_minus =  -- Compute the network response at f(x-epsilon)
    grad_est[i] = -- Compute the numerical gradient ( f(x+epsilon)-f(x-epsilon) ) / (2*epsilon)
  end

  -- computes (symmetric) relative error of gradient
  local diff = -- Check the difference between the numerical and the explicit gradient
  return diff, grad, grad_est
end

function generate_fake_data(n)
    local data = {}
    data.inputs = torch.randn(4, n)                     -- random standard normal distribution for inputs
    data.targets = torch.rand(n):mul(3):add(1):floor()  -- random integers from {1,2,3}
    return data
end

-------------------------------------------------------
-- MAIN
-------------------------------------------------------

torch.manualSeed(1)
torch.setdefaulttensortype('torch.DoubleTensor')
precision = 1e-5
local data = -- Generate some data. You do not need to create too many samples, 5 or 10 is enough
local model, criterion = -- define your model, use the wrapper function
local parameters, gradParameters = get your model parameters

-- returns loss(params)
local f = function(x)
  if x ~= parameters then
    parameters:copy(x)
  end
  -- print(criterion:forward(model:forward(data.inputs), data.targets))
  return criterion:forward(model:forward(data.inputs), data.targets)
end

-- returns dloss(params)/dparams
local g = function(x)
  if x ~= parameters then
    parameters:copy(x)
  end
  gradParameters:zero()

  local outputs = model:forward(data.inputs)
  criterion:forward(outputs, data.targets)
  model:backward(data.inputs, criterion:backward(outputs, data.targets))

  return gradParameters
end

local err, grad, grad_est = checkgrad(f, g, parameters)

print('--------------------------------------')
print('==> Error per dimension:\n')
print(torch.cat(grad, grad_est, 2))
print('--------------------------------------')
print('==> Total error: ' .. err)
print('--------------------------------------')

if err<precision then
   print('==> The model is OK')
else
   print('==> The error too large, something is wrong...')
end
