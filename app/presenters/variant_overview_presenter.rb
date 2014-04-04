class VariantOverviewPresenter < SimpleDelegator
  include LinkHelpers

  def initialize(variant, view_context)
    @variant = variant
    @view_context = view_context
    super(variant)
  end

  def gene_name
    gene_link(gene)
  end

  def disease_rows
    disease_source_variants.map do |dsv|
      DiseaseRow.new(
        dsv.disease.name,
        dsv.disease.doid,
        source_link(dsv.source)
      )
    end
  end

  def permutation_rows
    related_variants.map do |v|
      PermutationRow.new(
        variant_link(v),
        v.location.chromosome,
        v.location.start,
        v.location.stop,
        v.location.reference_read,
        v.variant
      )
    end
  end
end

DiseaseRow = Struct.new(:disease, :doid, :source)
PermutationRow = Struct.new(:hgvs, :chromosome, :start, :stop, :reference, :variant)