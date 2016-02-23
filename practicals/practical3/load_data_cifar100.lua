----------------------------------------------------------------------
-- This script downloads and loads the CIFAR-10 dataset
-- http://www.cs.toronto.edu/~kriz/cifar.html
----------------------------------------------------------------------

-- Here we download the CIFAR dataset
-- You can clone repository https://github.com/soumith/cifar.torch 
-- You will find the data in Torch-friendly format to get started right aways
-- The color dimension should be the first.
-- Hence the dataset will be a four dimensional tensor:
-- [dataset_size, nchannels, height, width]
-- The implementation of this file should be straightforward, as it is essentially
-- the same like in the previous lab assignment.


function load_data_cifar100()

   -- ADD CODE HERE

   print('Training Data:')
   print(trainData)
   print()

   print('Test Data:')
   print(testData)
   print()

   ----------------------------------------------------------------------
   print '==> visualizing data'

   -- Visualization is quite easy, using itorch.image().
   if itorch then
      print('training data:')
      itorch.image(trainData.data[{ {1,256} }])
      print('test data:')
      itorch.image(testData.data[{ {1,256} }])
   end
   return trainData, testData
   
end