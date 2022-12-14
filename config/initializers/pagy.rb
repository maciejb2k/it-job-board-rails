# frozen_string_literal: true

require 'pagy/extras/headers'
require 'pagy/extras/overflow'
require 'pagy/extras/items'

Pagy::DEFAULT[:items] = 25
Pagy::DEFAULT[:max_items] = 50
Pagy::DEFAULT[:overflow] = :empty_page
Pagy::DEFAULT.freeze
