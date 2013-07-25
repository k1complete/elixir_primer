Stream.map([1,2,3,4,5], 
             fn(x) -> IO.puts("step1 #{x}+1"); x + 1 end) |>
Stream.take(3) |>
Stream.map(fn(x) -> IO.puts("step3 #{x} + 1"); x + 1 end) |> 
Enum.to_list

m = Stream.map([1,2,3,4,5], 
                 fn(x) -> IO.puts("step1 #{x}+1"); x + 1 end)
m2 = Stream.take(m, 3)
m3 = Stream.map(m2, fn(x) -> IO.puts("step3 #{x} + 1"); x + 1 end)
m3 |> Enum.to_list
