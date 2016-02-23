
-- INITIALIZE WEIGHTS RANDOMLY FOLLOWING THE MSRA (MICROSOFT RESEARCH ASIA STYLE)
function initializeNetRandomly(net)
    local function initializeLayer(name)
        for k,v in pairs(net:findModules(name)) do
            local n = v.kW*v.kH*v.nOutputPlane
            v.weight:normal(0,math.sqrt(2/n))
            v.bias:zero()
        end
    end
    initializeLayer('nn.SpatialConvolution')

    -- GO THROUGH ALL THE LAYERS OF THE NETWORK
    -- FIND THE ONES THAT CONTAIN TRAINABLE PARAMETERS
    
    -- INITIALIZE THE WEIGHTS THEM WITH THE RESNET-LIKE INITIALIZTION.
    -- NAMELY, FROM SAMPLING RANDOMLY NUMBERS FROM A GAUSSIAN N(mu, sigma), WHERE:
    -- MU     = 0
    -- SIGMA0 = KERNEL_WIDTH * KERNEL_HEIGHT * NUM_OUTPUT_DIMS
    -- SIMGA  = SQUARE ROOT OF (2/SIGMA0)
    -- INITIALIZE THE BIASES TO 0

    -- THE MODULE VARIABLE FOR THE WEIGHTS IS: mymodule.weight
    -- THE MODULE VARIABLE FOR THE BIASES IS : mymodule.bias

    return net
end

-- INITIALIZE WEIGHTS FROM AN EXISTING NETWORK
-- THIS IS ALSO CALLED TRANSFER LEARNING, WHERE THE EXISTING LEARNING
-- FROM ANOTHER DATASET TO THE NEW ONE
function initializeNetWithNet(model, fromfile)

    -- IN THIS FILE WE ASSUME THAT THE PRETRAINED AND THE FINAL MODULE HAVE 
    -- A SIMILAR ARCHITECTURE, NAMELY n_C NUMBER OF CONVOLUTIONAL LAYERS AND 
    -- N_F NUMBER OF FULLY CONNECTED LAYERS

    -- TODO B.1: LOAD THE PRETRAINED MODEL FROM THE fromfile PATH
    init_model = --

    -- TODO B.1: RETRIEVE THE  WEIGHTS AND BIASES FROM THE PRETRAINED MODEL FROM
    -- THE MODULES THAT CONTAIN TRAINABLE PARAMETERS
    -- SET THE NEW MODEL MODULES WITH THE RESPECTIVE WEIGHTS
    
    -- START WITH THE SPATIAL CONVOLUTION MODULES
    init_modules = --
    modules      = --
    for i, md in pairs(modules) do
        md.weight = --
        md.bias = --
    end

    -- REPEAT FOR THE FULLY CONNECTED MODULES.
    -- THE LAST LAYER THAT DELIFERS THE CLASSIFICATION IS DIFFERENT,
    -- SINCE THE DATASETS ARE DIFFERENT. IGNORE THIS LAYER FROM THE PRETRAINED
    -- NETWORK. INSTEAD INTRODUCE A COMPLETELY NEW LAYER AND INITIALIZE IT
    -- RANDOMLY ACCORDING TO THE MSRA STYLE
    init_modules = --
    modules      = --
    for i, md in pairs(modules) do
        --
    end

    return model
end

-- SETUP DIFFERENT LEARNING RATES PER LAYER. THIS IS RELEVANT WHEN THE DIFFERENT
-- LAYERS ARE AT A DIFFERENT STATE OF OPTIMIZATION (E.G. WHEN LOADING A PRETRAINED
-- NETWORK AND ADDING ON TOP A COMPLETELY NEW MODULE)
function setupLearningRateVector(model, model_opt)
    local modules  = model:listModules()

    local weight_sizes = {} -- KEEP THE SIZE OF PARAMETERS PER LAYER
    local bias_sizes   = {} -- KEEP THE SIZE OF BIASES PER LAYER
    local total_size   = 0

    for mi, mod in pairs(modules) do
        -- CACHE THE NUMBER OF TRAINABLE PARAMETERS AND BIASES PER LAYER
    end

    -- IN total_size YOU STORE THE TOTAL SIZE OF TRAINABLE PARAMETERS, INCLUDING THE BIASES
    lrvector = torch.Tensor(total_size):fill(-1)
    local offset = --
    for -- TODO
        
        -- HERE YOU USE THE CACHED NUMBER OF TRAINABLE PARAMETES PER LAYER
        wsize = weight_sizes[id]
        bsize = bias_sizes[id] 

        -- HERE YOU NEED TO LOAD THE DESIRED INITIAL LEARNING RATE FOR THE
        -- THE WEIGHTS AND THE BIASES
        lrvector[{{offset, offset + wsize - 1}}] = --
        offset = offset + wsize
        lrvector[{{offset, offset + bsize - 1}}] = --
        offset = offset + bsize
    end

    -- HERE YOU CREATE A NEW FIELD IN THE model_opt structure to include the 
    -- LEARNING RATE VECTOR. THE OPTIMIZERS SEARCH FOR THE VARIABLE learningRates
    -- WHEN ONE DEFINES DIFFERENT LEARNING RATES PER LAYER
    model_opt['learningRates'] = lrvector    
end