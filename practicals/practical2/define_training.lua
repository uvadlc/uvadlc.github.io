require 'torch'
require 'xlua'
require 'optim'

----------------------------------------------------------------------
print '==> Setting up stuff'

-- This matrix records the current confusion across classes
confusion = optim.ConfusionMatrix(classes)

-- Log results to files
trainLogger = optim.Logger(paths.concat(opt.save, 'train.log'))
testLogger = optim.Logger(paths.concat(opt.save, 'test.log'))

----------------------------------------------------------------------
print '==> Get the model parameters'

parameters, gradParameters = model:getParameters()

----------------------------------------------------------------------
print '==> Configure optimizer'

optimState = {
  learningRate = opt.learningRate,
  weightDecay = opt.weightDecay,
  momentum = opt.momentum,
  learningRateDecay = 1e-7
}
optimMethod = optim.optimization

-- Other optimization methods:
-- ASGD (Good for very large datasets and training over multiple machines)
-- CG (Compute full gradients, no mini-batch updates)
-- LBFGS (Compute full gradients, no mini-batch updates)
-- For more options: http://optim.readthedocs.org/en/latest/

----------------------------------------------------------------------
print '==> Setup the training module'

function train()

   -- epoch tracker
   epoch = epoch or 1

   -- TODO If you want add a maximum number of epochs that you allow for the training.

   -- local vars
   local time = sys.clock()

   -- set model to training mode (for modules that differ in training and testing, like Dropout)
   model:training()

   -- shuffle at each epoch
   shuffle = torch.randperm(Ntr)

   -- do one epoch
   print('==> doing epoch on training data:')
   print("==> online epoch # " .. epoch .. ' [batchSize = ' .. model_opt.batchSize .. ']')

   -- Traverse through the shuffled training examples. Do so in mini-batches
   for t = 1,trainData:size(),model_opt.batchSize do
      -- disp progress
      xlua.progress(t, trainData:size())

      -- TODO1
      -- create mini batch
      local inputs = {} -- the X variables, namely the images
      local targets = {} -- the Y variables, namely the classes for the images
      for i = -- Load in inputs the next mini-batch inputs and targets
         local input -- load a new sample
         local target -- add the new sample to the tables: inputs and targets
         table.insert(inputs, input)
         table.insert(targets, target)
      end
      
      -- TODO1
      -- create closure (closure is how functions are called in Torch) to evaluate f(X) and df/dX
      local feval = function(x)
                       -- get new parameters
                       if x ~= parameters then
                          parameters:copy(x)
                       end
 
                       -- Reset gradients
                       -- This is a global variable and we have defined already from the outside
                       -- We need to set it to 0, as for each new round of updates we need to have the gradients variable clean
                       gradParameters:zero()
 
                       -- f is the average of all criterions
                       local f = 0
 
                       -- evaluate function for complete mini batch
                       for i = 1,#inputs do
                          
                          -- Step 1. Estimate f
                          local output = -- Perform the forward pass
                          
                          -- Step 2. Estimate error
                          local err = -- Compute the error based on the forward pass
                          f = f + err
 
                          -- Step 3. Estimate the gradients df/dW for the criterion and the model
                          local df_do = criterion: -- Estimate the gradients first for the loss function
                          model: -- Then estimate the gradients for the rest of the model

                          -- Step 4. Update the confusion to give you an estimate
                          output = torch.reshape(output, 10)
                          confusion:add(output, targets[i])

                       end
 
                       -- Step 5. The computed gradients are over the whole mini-batch
                       -- If the mini-batch contains more than 1 sample, then we need to
                       -- normalize the gradients and f(X) by the number of samples in the mini-batch.
                       gradParameters:div(#inputs)
                       f = f/#inputs
 
                       -- Return f and df/dX
                       return f,gradParameters
                    end

     -- Run the optimization on the current mini-batch
     optimMethod(feval, parameters, optimState)
   end

   -- time taken
   time = sys.clock() - time
   time = time / trainData:size()
   print("\n==> time to learn 1 sample = " .. (time*1000) .. 'ms')
 
   -- print confusion matrix
   print(confusion)
 
   -- update logger/plot
   trainLogger:add{['% mean class accuracy (train set)'] = confusion.totalValid * 100}
 
   -- save/log current net
   local filename = paths.concat(opt.save, 'model.net')
   os.execute('mkdir -p ' .. sys.dirname(filename))
   print('==> saving model to '..filename)
   torch.save(filename, model)
 
   -- next epoch
   confusion:zero()
   epoch = epoch + 1
end



