require 'nn'

local MyRequ, Parent = torch.class('nn.MyRequ', 'nn.Module')

function MyRequ:__init(p)
   Parent.__init(self)
end

function MyRequ:updateOutput(input)
   self.output:resizeAs(input):copy(input)
   self.output:cmax(0):cmul(self.output)
   return self.output
end

function MyRequ:updateGradInput(input, gradOutput)
   self.gradInput:resizeAs(gradOutput):copy(gradOutput)
   self.gradInput:mul(2)
   self.gradInput:cmul(input:cmax(0):resizeAs(gradOutput)) -- simply mask the gradients with the noise vector
   return self.gradInput
end