require 'torch'
require 'cunn'

------------------------------------------------------
print '=== I. ENVIRONMENT PARAMETERS ==='
torch.setdefaulttensortype('torch.CudaTensor')
torch.setnumthreads(1)
torch.manualSeed(1)

------------------------------------------------------
print '=== II. EXPERIMENT OPTIONS ==='
opt                 = {}
opt['save']         = ''
opt['optimization'] = 'SGD'
opt['max_epoch']    = 30

------------------------------------------------------
print '=== III. MODEL OPTIONS ==='
model_opt                   = {}
model_opt['batchSize']      = 128
model_opt['learningRate']   = 1.0
model_opt['lr_policy']      = 'step'
model_opt['lr_steps']       = {5, 10, 20} -- HERE WE ARE GOING TO USE FEWER EPOCHS
model_opt['lr_step_decay']  = 10.
model_opt['weightDecay']    = 0.0005
model_opt['momentum']       = 0.9
model_opt['model_name']     = 'alexnet-finetuning-from_cifar10_to_cifar100'
model_opt['nclasses']       = 100
model_opt['load_net']       = 'alexnet_cifar10.net'

----------------------------------------------------------------------
-- Section 2.1
----------------------------------------------------------------------
------------------------------------------------------
print '=== A. LOAD DATA ==='
dofile 'load_data_cifar100.lua'
trainData, testData = load_data_cifar100()

------------------------------------------------------
print '=== B. PREPROCESS DATA ==='
dofile 'preprocess_data_cifar100.lua'
trainData, testData = preprocess_data_cifar100(trainData, testData)

------------------------------------------------------
print '=== C. DEFINE MODEL ==='
dofile 'define_alexnet_model_cifar100.lua'
model   = define_alexnet_model_cifar100()

------------------------------------------------------
print '=== D. INITIALIZE MODEL ==='
dofile 'setup_model.lua'
model   = initializeNetWithNet(model, model_opt['load_net'])
setupLearningRateVector(model, model_opt)

------------------------------------------------------
print '=== E. DEFINE TRAINING ==='
dofile 'define_training.lua'
train(model, opt, model_opt, trainData, testData)

