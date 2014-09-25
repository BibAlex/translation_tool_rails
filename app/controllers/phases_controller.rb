require 'will_paginate/array'
class PhasesController < ApplicationController
  layout 'list'
  
  before_filter :restrict_login
  
  def search
    
  end
  
  def pending_species
    
  end
  
  def completed_species
    
  end
end
  