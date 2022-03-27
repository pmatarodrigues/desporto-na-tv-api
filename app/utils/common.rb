def convert_string_to_iso_timestamp(date_time_string)
    Time.parse(date_time_string).strftime('%Y-%m-%dT%H:%M:%S')
end

def get_translated_date(date)

    # get date day of the week
    day_of_week = date.split.first

    # translate day of the week
    translated_day_of_week = get_translated_day_of_the_week(day_of_week)

    # replace day of week
    date.gsub(day_of_week, translated_day_of_week)
    date
end

def get_translated_day_of_the_week(day)
    case day
    when 'Seg'
        'Mon'
    when 'Ter'
        'Tue'
    when 'Qua'
        'Wed'
    when 'Qui'
        'Thu'
    when 'Sex'
        'Fri'
    when 'Sáb'
        'Sat'
    when 'Dom'
        'Sun'
    else
        raise ArgumentError, 'Invalid Date'
    end
end