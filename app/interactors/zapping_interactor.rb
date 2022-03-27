require_relative '../utils/zapping'

class ZappingInteractor
  attr_reader :aggregator

  def initialize
    @aggregator = ZAPPING
  end

  def call
    previous_results = aggregator.get_saved_results
    two_hours_ago = convert_string_to_iso_timestamp(Time.now.getlocal('+01:00') - 2 * 60 * 60)

    return use_updated_results(aggregator.get_updated_results) unless previous_results

    if previous_results[:last_updated] < two_hours_ago
      use_updated_results(aggregator.get_updated_results)
    else
      use_previous_results(previous_results)
    end
  end

  private
  def use_previous_results(previous_results)
    {
      last_updated: previous_results[:last_updated],
      list: previous_results[:list]
    }
  end

  def use_updated_results(updated_results)
    {
      last_updated: updated_results[:last_updated],
      list: updated_results[:list]
    }
  end
end
