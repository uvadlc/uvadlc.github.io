require 'torch'
require 'image'
require 'nn'

trainData.data = trainData.data:float()
testData.data = testData.data:float()

------------------------------------------------------
print '==> Normalize data to uniform distribution.'

channels = {'r', 'g', 'b'} -- for binary

mean = {}
std = {}
for i,channel in ipairs(channels) do
   -- Normalize each channel globally:
   mean[i] = trainData.data[{ {},i,{},{} }]:mean()
   std[i] = trainData.data[{ {},i,{},{} }]:std()
   trainData.data[{ {},i,{},{} }]:add(-mean[i])
   trainData.data[{ {},i,{},{} }]:div(std[i])
end

-- Normalize test data, using the training means/stds
for i,channel in ipairs(channels) do
   -- normalize each channel globally:
   testData.data[{ {},i,{},{} }]:add(-mean[i])
   testData.data[{ {},i,{},{} }]:div(std[i])
end

------------------------------------------------------
print '==> Verifying the statistics of the data'

-- It's always good practice to verify that data is properly
-- normalized. Better be safe than sorry!

for i,channel in ipairs(channels) do
   trainMean = trainData.data[{ {},i }]:mean()
   trainStd = trainData.data[{ {},i }]:std()
 
   testMean = testData.data[{ {},i }]:mean()
   testStd = testData.data[{ {},i }]:std()
 
   print('training data, '..channel..'-channel, mean: ' .. trainMean)
   print('training data, '..channel..'-channel, standard deviation: ' .. trainStd)
 
   print('test data, '..channel..'-channel, mean: ' .. testMean)
   print('test data, '..channel..'-channel, standard deviation: ' .. testStd)
end

