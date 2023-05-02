class StaticController < ApplicationController
  def home
    render inertia: 'app'
  end
end
