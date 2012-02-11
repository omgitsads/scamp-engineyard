require 'engineyard'
require 'engineyard/cli'
require 'engineyard/cli/ui'
require 'scamp/plugin'

require "scamp/engineyard/version"

class MockUI
  def error *args; end
  def warn *args; end
  def info *args; end
  def debug *args; end
end

EY.ui = MockUI.new

class Scamp
  class Engineyard < Scamp::Plugin
    include EY::UtilityMethods

    match /^deploy (?<app>[^\W]+) (?<environment>[^\W]+) (?<ref>[^\W]+)$/, :app_environment_ref
    match /^deploy (?<app>[^\W]+) (?<environment>[^\W]+)$/, :app_environment_default
    match /^deploy (?<app>[^\W]+)$/, :app_default
    match /^deploy$/, :default

    def default context, msg
      EM.defer do
        begin
          app, environment = fetch_app_and_environment
          environment.deploy  app, 
                              "HEAD", 
                              "extras"=> {}, 
                              "verbose"=> false

          context.say "#{app.name} deployed to #{environment.name}"
        rescue EY::MultipleMatchesError
          context.say "Sorry! I don't know which app/environment you want to deploy to"
        rescue EY::NoAppError
          context.say "Sorry! You have no apps!"
        rescue EY::NoEnvironmentError
          context.say "Sorry! You have no environments!"
        end        
      end
    end

    def app_default context, msg
      app_name = msg.matches.app

      EM.defer do
        begin
          app, environment = fetch_app_and_environment(app_name)
          environment.deploy  app, 
                              "HEAD", 
                              "extras"=> {}, 
                              "verbose"=> false

          context.say "#{app.name} deployed to #{environment.name}"
        rescue EY::MultipleMatchesError
          context.say "Sorry! I don't know which app/environment you want to deploy to"
        rescue EY::NoAppError
          context.say "Sorry! I couldn't find an app with that name!"
        rescue EY::NoEnvironmentError
          context.say "Sorry! You have no environments!"
        end
      end
    end

    def app_environment_default context, msg
      app_name, environment_name = [msg.matches.app, msg.matches.environment]

      EM.defer do
        begin
          app, environment = fetch_app_and_environment(app_name, environment_name)

          environment.deploy  app,
                              "HEAD",
                              "extras"=> {},
                              "verbose"=> false

          context.say "#{app.name} deployed to #{environment.name}"
        rescue EY::MultipleMatchesError
          context.say "Sorry! I don't know which app/environment you want to deploy to"
        rescue EY::NoAppError
          context.say "Sorry! I couldn't find an app with that name!"
        rescue EY::NoEnvironmentError
          context.say "Sorry! I couldn't find an environment with that name!"
        end
      end
    end

    def app_environment_ref context, msg
      app_name, environment_name = [msg.matches.app, msg.matches.environment]
      ref = msg.matches.ref

      EM.defer do
        begin
          app, environment = fetch_app_and_environment(app_name, environment_name)
          environment.deploy  app,
                              ref,
                              "extras"=> {},
                              "verbose"=> false
          context.say "#{app.name} deployed to #{environment.name}"
        rescue EY::MultipleMatchesError
          context.say "Sorry! I don't know which app/environment you want to deploy to"
        rescue EY::NoAppError
          context.say "Sorry! I couldn't find an app with that name!"
        rescue EY::NoEnvironmentError
          context.say "Sorry! I couldn't find an environment with that name!"
        end
      end
    end
  end
end
