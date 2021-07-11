# frozen_string_literal: true

# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

#es-lint 
const { environment } = require('@rails/webpacker')
const vue =  require('./loaders/vue')
const eslint =  require('./loaders/eslint')

environment.loaders.append('vue', vue)
environment.loaders.append('eslint', eslint)
module.exports = environment
