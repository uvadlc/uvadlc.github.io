require 'nn'
-- require 'MyModules/MyRequ'
require 'MyModules/MySin'

function define_model_wrapper(D, nhidden, C)
  ------------------------------------------------------------------------------
  -- MODEL
  ------------------------------------------------------------------------------
  
  -- OUR MODEL:
  --     linear -> sigmoid/requ -> linear -> softmax
  -- Practically copy paste your code from the script file

  ------------------------------------------------------------------------------
  -- LOSS FUNCTION
  ------------------------------------------------------------------------------

  -- Practically copy paste your code from the script file

  return model, criterion
end

return define_model_wrapper

