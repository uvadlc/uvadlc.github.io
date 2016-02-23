require 'torch'
require 'xlua'
require 'optim'
local c = require 'trepl.colorize'

function init_loggers(opt, model_opt)
    trainLogger = optim.Logger(paths.concat(opt.save, model_opt.model_name .. '_train.log'))
    testLogger = optim.Logger(paths.concat(opt.save, model_opt.model_name .. '_test.log'))
end

-- test function
function test(model, model_opt, testData)

    -- local vars
    local time = sys.clock()

    local confusion = optim.ConfusionMatrix(model_opt.nclasses)

    -- averaged param use?
    if average then
        cachedparams = parameters:clone()
        parameters:copy(average)
    end

    -- set model to evaluate mode (for modules that differ in training and testing, like Dropout)
    model:evaluate()

    local shuffle = torch.randperm(testData.size())

    -- test over test data
    local ti = 1
    local ftotal = 0
    for t = 1, testData:size(), model_opt.batchSize do
        -- disp progress
        -- xlua.progress(t, trainData:size())
        xlua.progress(ti, torch.ceil(testData:size() / model_opt.batchSize))
        ti = ti + 1 

        -- disp progress
        xlua.progress(t, testData:size())

        -- create mini batch like for the training set
        -- TODO A.2
        local batch_start = 
        local batch_end   = 
        local indices     = 
        local inputs      = 
        local actual_batch_size = 
        local targets     = 
        targets:copy -- ...

        -- test sample
        local preds = model:forward(inputs)
        confusion:batchAdd(preds, targets)
        -- confusion:add(preds, targets)
    end

   -- timing
   time = sys.clock() - time
   time = time / testData:size()
   print("\n==> time to test 1 sample = " .. (time*1000) .. 'ms')

   -- print confusion matrix
   confusion:updateValids()
   -- print(confusion)
   print(('Test accuracy: '..c.cyan'%.2f'..' %%\t time: %.2f ms'):format(confusion.totalValid * 100, time*1000))

   -- update log/plot
   testLogger:add{['% mean class accuracy (test set)'] = confusion.totalValid * 100}
   if opt.plot then
      testLogger:style{['% mean class accuracy (test set)'] = '-'}
      testLogger:plot()
   end

   -- averaged param use?
   if average then
      -- restore parameters
      parameters:copy(cachedparams)
   end
   
   -- next iteration:
   confusion:zero()
end


function train(model, opt, model_opt, trainData, testData)

    ----------------------------------------------------------------------
    print '==> Setting up general stuff'
    -- This matrix records the current confusion across classes
    local confusion = optim.ConfusionMatrix(model_opt.nclasses)
    -- Initialize the loggers that are going to record the performance
    init_loggers(opt, model_opt)

    ----------------------------------------------------------------------
    print '==> Setting up the model before training'
    local parameters, gradParameters = model:getParameters()
    print(model)

    ----------------------------------------------------------------------
    print '==> Setting up the optimizer and loss'
    optimState = {
      learningRate      = model_opt.learningRate,
      weightDecay       = model_opt.weightDecay,
      momentum          = model_opt.momentum,
     -- TODO: MORE IF YOU HAVE MORE OPTIONS
    }
    local optimize = optim.sgd
    local criterion = nn.CrossEntropyCriterion():cuda() -- HERE WE DEFINE THE OPERATIONS TO BE PERFORMED ON THE GPU
    -- Other optimization methods:
    -- ASGD (Good for very large datasets and training over multiple machines)
    -- CG (Compute full gradients, no mini-batch updates)
    -- LBFGS (Compute full gradients, no mini-batch updates)
    -- For more options: http://optim.readthedocs.org/en/latest/

    ----------------------------------------------------------------------
    print '==> Setting up the training module which will perform the per epoch training'

    function train_epoch(epoch)

        -- TODO A.4: ADD AN IF STATEMENT TO CHECK IF THE EPOCH HAS ARRIVED FOR
        -- CHANGING THE LEARNING RATE. IF YES, CHANGE THE LEARNING RATE ACCORDINGLY
    
        -- local vars
        local time = sys.clock()
        -- set model to training mode
        -- this is import for modules that differ in training and testing, like Dropout
        model:training()
        -- shuffle at each epoch
        local shuffle = torch.randperm(trainData.size())

        -- train one epoch
        print('==> doing epoch on training data:')
        print("==> online epoch # " .. epoch .. ' [batchSize = ' .. model_opt.batchSize .. ']')
        local ti = 1
        local ftotal = 0
        for t = 1, trainData:size(), model_opt.batchSize do
            -- disp progress
            -- xlua.progress(t, trainData:size())
            xlua.progress(ti, torch.ceil(trainData:size() / model_opt.batchSize))
            ti = ti + 1 

            -- TODO A.2 CREATE MINI BATCH
            local batch_start = -- TODO A.2
            local batch_end   = -- TODO A.2
            local indices     = -- TODO A.2
            local inputs      = trainData.data:index(1, indices)
            local actual_batch_size = inputs:size()[1]
            local targets     = torch.CudaTensor(actual_batch_size) -- HERE WE CONVERT THE DATA TO A CUDA TENSOR
            targets:copy(trainData.labels:index(1, indices))

            -- implement feval function that evaluates f(X) and df/dX
            local feval = function(theta)
                -- get new parameters
                if theta ~= parameters then parameters:copy(theta) end
                gradParameters:zero() -- reset gradients

                local outputs = model:forward(inputs)
                local f       = criterion:forward(outputs, targets)
                local df_do   = criterion:backward(outputs, targets)
                model:backward(inputs, df_do)
                ftotal = ftotal + f

                confusion:batchAdd(outputs, targets)
                return f, gradParameters
            end

            -- optimize on current mini-batch
            optimize(feval, parameters, optimState)
        end

        time = sys.clock() - time
        time = time / trainData:size()
        print("\n==> time to learn 1 sample = " .. (time*1000) .. 'ms')

        confusion:updateValids()
        print(('Epoch: ' .. c.cyan'%u) Train loss: ' .. c.cyan'%.2f ' .. ' | Train accuracy: '..c.cyan'%.2f'..' %% ' .. ' | Time: %.2f ms'):format(epoch, ftotal, confusion.totalValid * 100, time*1000))

        -- update logger/plot
        trainLogger:add{['% mean class accuracy (train set)'] = confusion.totalValid * 100}

        -- save/log current net
        local filename = paths.concat(opt.save, model_opt.model_name .. '.net')
        os.execute('mkdir -p ' .. sys.dirname(filename))
        print('==> saving model to '..filename)
        torch.save(filename, model)

        -- next epoch
        confusion:zero()
    end

    for epoch = 1, opt.max_epoch do
        train_epoch(epoch)
        test(model, model_opt, testData)
    end

end


