require_relative '../utils/zapping'

class ZappingInteractor
  attr_reader :aggregator

  def initialize
    @aggregator = ZAPPING
  end

  def call(today: nil)
    previous_results = aggregator.get_saved_results
    two_hours_ago = convert_string_to_iso_timestamp(Time.now.getlocal('+01:00') - 2 * 60 * 60)
    
    return use_updated_results(aggregator.get_updated_results) unless previous_results
    
    results = nil
    if previous_results[:last_updated] < two_hours_ago
      results = use_updated_results(aggregator.get_updated_results)
    else
      results = use_previous_results(previous_results)
    end

    results = get_todays_results_only(results) if today

    return results
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

  def get_todays_results_only(results)
    todays_results = {}
    todays_date = Time.parse(Time.now.getlocal('+01:00').to_s).strftime('%Y-%m-%d')

    results[:list].each do |sport, sport_results|
      sport_results.each do |result|
        result_date = Time.parse(result[:date]).strftime('%Y-%m-%d')
        if result_date == todays_date
          todays_results[sport] = [] if todays_results[sport].nil?

          todays_results[sport].push(result)
        else
          break
        end
      end
    end

    return todays_results
  end
end
