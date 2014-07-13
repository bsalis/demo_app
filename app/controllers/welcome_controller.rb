class WelcomeController < ApplicationController
  
  def index
    @unicorns = `ps -ef | grep unicorn` || 'No unicorns it seems'
    @about = `aws ec2 describe-instances` || 'I seem to not be on AWS, hmmm'
  end
  
end
