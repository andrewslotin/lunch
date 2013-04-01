# -*- encoding : utf-8 -*-

require 'active_model'

module ActiveModel
  module Validations
    class GitHubOrganizationValidator < ActiveModel::Validator
      def initialize(options)
        options.reverse_merge! organizations: options[:attributes]
        options.reverse_merge! message: "Must have membeship in one of GitHub organizations: #{[*options.fetch(:organizations)].join(', ')}"

        super(options)
      end

      def validate(record)
        organizations = [*options.fetch(:organizations)].map(&:to_s)
        github_organizations = github(record.login, record.token).organizations

        puts organizations.inspect

        unless organizations.empty? || organizations.any? { |org| github_organizations.include? org }
          record.errors.add(:base, options.fetch(:message))
        end
      end

      private

      def github(login, token)
        Octokit::Client.new(login: login, oauth_token: token)
      end
    end
  end
end