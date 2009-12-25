# We need to load devise here to ensure routes extensions are loaded.
require 'devise'

# +helper :all+ in the controller doesn’t find engine helpers,
# so we need to force this.
ActionController::Base.helper(DeviseHelper)