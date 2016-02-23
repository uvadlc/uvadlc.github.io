require 'torch'
require 'image'
require 'nn'

-- IMPLEMENT THE PREPROCESSING FUNCTION FOR YOUR DATA.
-- FOR THE PREPROCESSING EACH CHANNEL SHOULD HAVE MEAN=0 AND ST DEV=1
-- YOU CAN REUSE THE CODE FROM THE 1ST LAB ASSIGNMENT

function preprocess_data_cifar100(trData, tsData)
   
   -- ADD YOUR CODE HERE. 

   ------------------------------------------------------
   print '==> Verifying the statistics of the data'

   -- It's always good practice to verify that data is properly
   -- normalized. Better be safe than sorry!

   for i,channel in ipairs(channels) do
      local trainMean = trainData.data[{ {},i,{},{} }]:mean()
      local trainStd = trainData.data[{ {},i,{},{} }]:std()
    
      local testMean = testData.data[{ {},i,{},{} }]:mean()
      local testStd = testData.data[{ {},i,{},{} }]:std()
    
      print('training data, '..channel..'-channel, mean: ' .. trainMean)
      print('training data, '..channel..'-channel, standard deviation: ' .. trainStd)
    
      print('test data, '..channel..'-channel, mean: ' .. testMean)
      print('test data, '..channel..'-channel, standard deviation: ' .. testStd)
   end
   return trainData, testData
end
