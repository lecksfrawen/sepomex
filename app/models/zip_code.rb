class ZipCode < ActiveRecord::Base
  default_scope { order(:id) }

  scope :find_by_zip_code, lambda { |cp|
    where("d_codigo ILIKE ?", "%#{cp}%")
  }

  scope :find_by_state, lambda { |state|
    unaccent("d_estado", state)
  }

  scope :find_by_city, lambda { |city|
    where("unaccent(d_ciudad) ILIKE unaccent(?)
          OR unaccent(d_mnpio) ILIKE unaccent(?)", "%#{city}%", "%#{city}%")
  }

  scope :find_by_colony, lambda { |colony|
    unaccent("d_asenta", colony)
  }

  def self.search(params = {})
    zip_codes = all

    zip_codes = zip_codes.find_by_zip_code(params[:cp] || params[:zip_code]) if params[:cp].present?  || params[:zip_code].present?
    zip_codes = zip_codes.find_by_state(params[:state]) if params[:state].present?
    zip_codes = zip_codes.find_by_city(params[:city]) if params[:city].present?
    zip_codes = zip_codes.find_by_colony(params[:colony]) if params[:colony].present?

    zip_codes
  end

  private

    def self.unaccent(column_name, value)
      where("unaccent(#{column_name}) ILIKE unaccent(?)", "%#{value}%")
    end

end
