-- www = 'http://torch7.s3-website-us-east-1.amazonaws.com/data/housenumbers/'
train_file = 'mnist.t7/train_32x32.t7'
test_file = 'mnist.t7/test_32x32.t7'

if not paths.filep(opt.save .. train_file) then
    www = 'http://torch7.s3-website-us-east-1.amazonaws.com/data/housenumbers/'
    os.execute('wget ' .. www .. train_file)
end
if not paths.filep(opt.save .. test_file) then
    www = 'http://torch7.s3-website-us-east-1.amazonaws.com/data/housenumbers/'
    os.execute('wget ' .. www .. test_file)
end

------------------------------------------------------
print 'Loading data'

-- Small problem for now
if #opt.small > 0 then
    print '==> using reduced training data, for fast experiments'
 
    Ntr = opt.small[1]
    Nte = opt.small[2]
    loaded = torch.load(train_file,'ascii')
    trainData = {
       data = loaded.X:transpose(3,4)[{ {1, opt.small[1]}, {}, {}, {} }],
       labels = loaded.y[1][{ {1, opt.small[1]} }],
       size = function() return Ntr end
    }
 -- Torch complains when the line is completely empty (at least in my machine). Add one "empty space" or just delete the line.
    loaded = torch.load(test_file,'ascii')
    testData = {
       data = loaded.X:transpose(3,4)[{ {1, opt.small[2]}, {}, {}, {} }],
       labels = loaded.y[1][{ {1, opt.small[2]} }],
       size = function() return Nte end
    }

else
    loaded = torch.load(train_file,'ascii')
    Ntr = loaded.data:size()[1]
    trainData = {
       data = loaded.data:transpose(3,4),
       labels = loaded.labels,
       size = function() return Ntr end
    }
 
    loaded = torch.load(test_file,'ascii')
    Nte = loaded.data:size()[1]
    testData = {
       data = loaded.data:transpose(3,4),
       labels = loaded.labels,
       size = function() return Nte end
    }
end

classes = {'1','2','3','4','5','6','7','8','9','0'}
    