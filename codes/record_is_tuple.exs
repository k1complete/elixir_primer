defrecord FileInfo, atime: nil, mtime: nil, access: 0
a = {FileInfo, nil, nil, 0}
bad = {:"FileInfo", nil, nil, 0}
defrecord :"user.info", user: nil, group: nil
u = :"user.info".new()
u2 = {:"user.info", nil, nil}
