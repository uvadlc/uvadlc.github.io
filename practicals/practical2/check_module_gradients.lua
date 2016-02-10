require 'torch'
require 'nn'
require 'MyModules/MyReq'

-- define inputs and module
-- parameters
precision = 1e-5
-- Call a Jacobian instance
jac = nn.Jacobian

input = torch.Tensor():ones(2, 1)
-- local module = nn.MyDropout(percentage)
module = nn.MySin(3, 2)
-- test backprop, with Jacobian
err = jac. -- test your module jacobians

print('==> Error: ' .. err)
if err<precision then
   print('==> The module is OK')
else
   print('==> The error too large, incorrect implementation')
end
 
