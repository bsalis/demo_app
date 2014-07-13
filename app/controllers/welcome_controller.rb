class WelcomeController < ApplicationController
  
  def index
    @about = `aws ec2 describe-instances` || 'I seem to not be on AWS, hmmm'
  end
  
end
