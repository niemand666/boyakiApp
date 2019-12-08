module Paginate
  extend ActiveSupport::Concern
  include Kaminari::PageScopeMethods

  included do
    scope :paginate, ->(p) { page(p[:page]).per(5) }
  end
end
