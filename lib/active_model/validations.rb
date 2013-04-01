# -*- encoding : utf-8 -*-

require './lib/active_model/validations/git_hub_organization_validator'

module ActiveModel
  module Validations
    module ClassMethods
      def validates_membership_in(*attr_names)
        validates_with GitHubOrganizationValidator, _merge_attributes(attr_names)
      end
    end
  end
end