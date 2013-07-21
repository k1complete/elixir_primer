r = defrecord FileInfo, atime: nil, mtime: nil, access: 0
m1 = FileInfo.new
m1.access
m2 = m1.update_access(fn(x) -> x+1 end)
m2.access
m3 = m1.update(access: m1.access+1)
m3.access

defrecord FileInfo2, FileInfo: nil, update: nil
