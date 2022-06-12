require 'will_paginate/array'

class ApplicationController < ActionController::Base
  protected

    def page
      params.fetch(:page, 1)
    end
end
