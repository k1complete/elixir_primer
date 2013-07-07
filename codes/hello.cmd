spawn bash -i 
expect "\$ "
send "iex \n"
expect  "iex*\> "
log_file hello.tmp
 send {defmodule ModuleName do
}
 expect "*> "

 send {  def method_name(arg1) do
}
 expect "*> "

 send {    {:body, arg1}
}
 expect "*> "

 send {  end
}
 expect "*> "

 send {  def short_method(arg1), do: {:body, arg1}
}
 expect "*> "

 send {end
}
 expect "*> "

 send {defmodule Hello do
}
 expect "*> "

 send {  def world do
}
 expect "*> "

 send {    IO.puts("Hello, world.")
}
 expect "*> "

 send {  end
}
 expect "*> "

 send {end
}
 expect "*> "

 send {Hello.world
}
 expect "*> "

