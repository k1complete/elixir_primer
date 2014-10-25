defmodule FileAppender do
  defstruct file: nil

  def empty(file) do
    File.rm(file)
    %FileAppender{file: file}
  end
end
defimpl Collectable, for: FileAppender do  
  def into(collectable) do
    {collectable, 
     fn
       fa, {:cont, term} -> 
         File.write(fa.file, "#{inspect term}\n", [:append])
         fa
       fa, :done -> fa
       _, :halt -> :ok
     end}
  end
end
    