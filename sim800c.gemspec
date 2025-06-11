# frozen_string_literal: true

require_relative 'lib/sim800c/version'

Gem::Specification.new do |spec|
  spec.name = 'sim800c'
  spec.version = Sim800c::VERSION
  spec.authors = ['Nujian Den Mark Meralpis']
  spec.email = ['denmarkmeralpis@gmail.com']
  spec.summary = 'Easy serial communication with the SIM800C GSM module for sending and receiving SMS messages using Ruby.'
  spec.description = <<~DESCRIPTION
    A lightweight Ruby gem that simplifies communication with SIM800C GSM/GPRS modules
    over a serial connection. Built on top of the modern rubyserial library,
    it provides a simple and readable API for checking signal strength,
    sending SMS messages, and reading or parsing incoming SMS messages.
  DESCRIPTION
  spec.homepage = 'https://github.com/denmarkmeralpis/sim800c.git'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.5'
  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = spec.homepage
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_dependency 'rubyserial'
  spec.add_development_dependency 'debug'
end
