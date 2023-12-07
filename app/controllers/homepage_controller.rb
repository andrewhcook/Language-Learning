class HomepageController < ApplicationController


def index
  render("/homepage/homepage")
end

def show_instructions
  render("/homepage/instructions")
end

end
