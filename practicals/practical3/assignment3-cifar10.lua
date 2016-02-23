require 'torch'
require 'cunn'

------------------------------------------------------
print '=== I. ENVIRONMENT PARAMETERS ==='
-- We will need the GPU implementation for this experiment.
-- We define the default tensor to be of CUDA type.
torch.setdefaulttensortype('torch.CudaTensor') 
torch.setnumthreads(1)
torch.manualSeed(1)

------------------------------------------------------
print '=== II. EXPERIMENT OPTIONS ==='
opt                 = {}
opt['save']         = ''
opt['max_epoch']    = 300

------------------------------------------------------
print '=== III. MODEL OPTIONS ==='
model_opt                   = {}
model_opt['batchSize']      = 128
model_opt['learningRate']   = 1.0
model_opt['weightDecay']    = 0.0005
model_opt['momentum']       = 0.9
model_opt['model_name']     = 'alexnet_cifar10.net'

------------------------------------------------------
print '=== A. LOAD DATA ==='
dofile 'load_data_cifar10.lua'
trainData, testData = load_data_cifar10()

------------------------------------------------------
print '=== B. PREPROCESS DATA ==='
dofile 'preprocess_data_cifar10.lua'
trainData, testData = preprocess_data_cifar10(trainData, testData)

------------------------------------------------------
print '=== C. DEFINE MODEL ==='
dofile 'define_alexnet_model_cifar10.lua'
model   = define_alexnet_model_cifar10()

------------------------------------------------------
print '=== D. INITIALIZE MODEL ==='
dofile 'setup_model.lua'
model   = initializeNetRandomly(model)

------------------------------------------------------
print '=== E. DEFINE TRAINING ==='
dofile 'define_training.lua'
train(model, opt, model_opt, trainData, testData)
