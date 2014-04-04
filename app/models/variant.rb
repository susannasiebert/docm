class Variant < ActiveRecord::Base
  belongs_to :gene, inverse_of: :variants
  belongs_to :location, inverse_of: :variants
  belongs_to :amino_acid, inverse_of: :variants
  belongs_to :variant_type, inverse_of: :variants
  belongs_to :mutation_type, inverse_of: :variants
  has_many :disease_source_variants
  has_many :sources, through: :disease_source_variants
  has_many :diseases, through: :disease_source_variants

  def self.index_scope
    eager_load(:location, :gene, :amino_acid, :diseases, :sources, :mutation_type)
  end

  def self.show_scope
    eager_load(:location, :gene, :amino_acid, :mutation_type, disease_source_variants: [:disease, :source])
  end

  def self.permutation_scope
    eager_load(:location)
  end

  def is_permutation?
    !is_primary?
  end

  def related_variants
    Variant.permutation_scope
      .where(amino_acid: self.amino_acid)
      .where('variants.id != ?', self.id)
  end

end
