defprotocol Blank do
  def blank?(data)
end
defimpl Blank, for: List do
  def blank?([]), do: true
  def blank?(_), do: false
end
Blank.blank?([])
Blank.blank?([1])
Blank.blank?(1)
defimpl Blank, for: Integer do
  def blank?(_), do: true
end
Blank.blank?(0)
Blank.blank?(1)
