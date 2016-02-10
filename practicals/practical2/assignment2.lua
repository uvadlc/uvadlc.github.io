----------------------------------------------------------------------
-- Section 2.1
----------------------------------------------------------------------
require 'torch'

------------------------------------------------------
print '=== I. ENVIRONMENT PARAMETERS ==='
torch.setdefaulttensortype('torch.FloatTensor')
torch.setnumthreads(1)
torch.manualSeed(1)

------------------------------------------------------
print '=== II. EXPERIMENT OPTIONS ==='
opt                 = {}
opt['loss']         = -- TODO
opt['save']         = ''
opt['optimization'] = -- TODO
opt['small']        = {} -- {10000, 5000}

------------------------------------------------------
print '=== III. MODEL OPTIONS ==='
model_opt                 = {}
model_opt['nhidden']      = -- TODO
model_opt['batchSize']    = -- TODO
model_opt['learningRate'] = -- TODO
model_opt['weightDecay']  = -- TODO
model_opt['momentum']     = -- TODO

----------------------------------------------------------------------
-- Section 2.1
----------------------------------------------------------------------
------------------------------------------------------
print '=== A. LOAD DATA ==='
dofile 'load_data_mnist.lua'

------------------------------------------------------
print '=== B. LOAD DATA ==='
dofile 'preprocess_data_mnist.lua'

------------------------------------------------------
print '=== C. DEFINE MODEL ==='
dofile 'define_model.lua'

------------------------------------------------------
print '=== D. DEFINE TRAINING ==='
dofile 'define_training.lua'

------------------------------------------------------
print '=== E. DEFINE TESTING ==='
dofile 'define_testing.lua'

----------------------------------------------------------------------
print '=== RUN THE EXPERIMENT ==='

while true do
   train()
   -- test()
end

