require_relative '../utils/zapping'

class ZappingInteractor
  attr_reader :aggregator

  def initialize
    @aggregator = ZAPPING
  end

  def call
      aggregator.get_results_list.to_json
  end
end