require 'torch'
require 'nn'
require 'image'
require 'MyModules/MyRequ'
-- require 'MyModules/MyDropout'

------------------------------------------------------
print '==> Define dimensionalities, etc.'

D       = trainData.data:size()[2] * trainData.data:size()[3] * trainData.data:size()[4]
nhidden = model_opt['nhidden']
C       = #classes

------------------------------------------------------
print '==> Define the model'

model = nn.Sequential()
model:add(nn.Reshape(D))
model:add(nn.Linear(D, nhidden))
-- model:add(nn.MyRequ())
model:add(nn.Tanh())
-- model:add(nn.MyDropout())
model:add(nn.Linear(nhidden, C))
model:add(nn.LogSoftMax())

------------------------------------------------------
print '==> This is the model:'
print(model)

------------------------------------------------------
print '==> Define loss'

-- criterion = nn.MultiMarginCriterion()
criterion = nn.ClassNLLCriterion()
-- Other loss choices:
-- For classification: ClassNLLCriterion
-- For regression: MSECriterion
-- For more options: https://github.com/torch/nn/blob/master/doc/criterion.md

----------------------------------------------------------------------
print '==> This is the loss function:'
print(criterion)
