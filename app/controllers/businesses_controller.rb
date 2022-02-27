class BusinessesController < ApplicationController
    before_filter :authorised?
    
    private
        def authorised?
        end
    end
end
