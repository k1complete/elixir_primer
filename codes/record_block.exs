defrecord FileInfo,  atime: nil, mtime: nil, access: 0  do
  def access_increment(m) when is_record(m, FileInfo) do
    m.update_access(fn(x) -> x+1 end)
  end
end
r1 = FileInfo[]
r2 = r1.access_increment
r2
FileInfo.access_increment(r2)
