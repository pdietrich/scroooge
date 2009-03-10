class Numeric
  def round_to( number_of_decimal_places )
    mult = 10.0**number_of_decimal_places
    return (self * mult).round/mult
  end
end