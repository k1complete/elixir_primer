defprotocol Blank do
  def blank?(data)
end
## implstart
defimpl Blank, for: List do
  def blank?([]), do: true
  def blank?(_), do: false
end
