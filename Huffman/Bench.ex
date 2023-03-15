defmodule Bench do

  def bench do
    text = read("kallocain.txt")
    list = Huffman.freq(text)

    IO.puts("Length of text: #{length(text)}")
    tree = Huffman.huffman(list)
    table = Huffman.encode_table(tree)

    #---Encode---
    #x0 = :os.system_time(:millisecond)
    seq = Huffman.encode(text, table)
    #x1 = :os.system_time(:millisecond)
    #IO.puts("Time for Encode: #{(x1-x0)}")

    {y,_} = :timer.tc(fn -> Huffman.encode(text, table) end)
    IO.inspect(y/1000)

    #---Decode---
    #x0 = :os.system_time(:millisecond)
    #textList= Huffman.decode(seq, table)
    #x1 = :os.system_time(:millisecond)
    #IO.puts("Time for Decode: #{(x1-x0)}")

    {x,_}= :timer.tc(fn -> Huffman.decode(seq, table) end)
    IO.inspect(x/1000)
  end

  def read(file) do
    {:ok, file} = File.open(file, [:read, :utf8])
    binary = IO.read(file, :all)
    File.close(file)
    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, list, _} ->
        list
      list ->
        list
    end
  end

end
