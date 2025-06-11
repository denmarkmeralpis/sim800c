# frozen_string_literal: true

require_relative 'sim800c/version'
require_relative 'sim800c/port_scanner'
require_relative 'sim800c/client'
require_relative 'sim800c/helpers'

module Sim800c
  class Error < StandardError; end
  class InvalidIndex < Error; end
  class OperationNotAllowed < Error; end
  class SimNotFound < Error; end
end
