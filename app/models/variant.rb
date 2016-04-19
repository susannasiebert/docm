class Variant < ActiveRecord::Base
  belongs_to :gene, inverse_of: :variants
  belongs_to :location, inverse_of: :variants
  belongs_to :amino_acid, inverse_of: :variants
  belongs_to :variant_type, inverse_of: :variants
  belongs_to :mutation_type, inverse_of: :variants
  belongs_to :transcript, inverse_of: :variants
  belongs_to :version, inverse_of: :variants
  has_many :disease_source_variants
  has_many :disease_sources, through: :disease_source_variants, source: :source
  has_many :diseases, through: :disease_source_variants
  has_many :drug_interactions
  has_many :drug_sources, through: :drug_interactions, source: :source
  has_and_belongs_to_many :tags

  serialize :meta, JSON

  def self.index_scope
    eager_load(:location, :gene, :amino_acid, :diseases, :disease_sources, :mutation_type, :variant_type, :version)
  end

  def self.show_scope
    eager_load(:location, :gene, :variant_type, :amino_acid, :mutation_type, :drug_interactions, :transcript, :version, disease_source_variants: [:disease, :source], drug_interactions: [:source])
  end

  def is_indel?
    ['INS', 'DEL'].include?(variant_type.name)
  end

  def from_tim_ley?
    !tim_ley_annotation.blank?
  end

end
