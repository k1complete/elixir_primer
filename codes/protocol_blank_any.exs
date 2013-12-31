defprotocol Blank do
  @fallback_to_any true
  def blank?(data)
end
defimpl Blank, for: Any do
  def blank?(_), do: false
end
