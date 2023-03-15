defmodule Test do

  def text do

    #Text size: 10019
    text = Bench.read("advsayed.txt")

    #Text size: 20839
    text1 = Bench.read("100west.txt")

    # Text size: 101404
    text2 = Bench.read("batlslau.txt")

    # Text size: 318997
    text3 = Bench.read("kallocain.txt")

     # Text size: 415872
     text4 = Bench.read("cybersla.txt")

    [text, text1, text2, text3, text4]
  end

  def testEncode do
    testEncode(text())
  end

  def bench do
    testEncode()
    IO.puts("----------------------\n")
    testDecode()
  end

  def testEncode([]) do [] end
  def testEncode([text | tail]) do
    length = length(text)

    x = Huffman.tree(text)
    table = Huffman.encode_table(x)

    {encode, _} = :timer.tc(fn() ->
          Huffman.encode(text, table)
        end)

    seq = Huffman.encode(text, table)

    Huffman.decode(seq, table)
    #:io.format("# Length of text ~w: Decode time: ~6w\n", [length, decode])
    :io.format("# Length of text ~w: \n", [length])
    :io.format("# Encode time: ~6.2f ms\n\n", [encode/1000])

    testEncode(tail)
  end

  def testDecode do
    testDecode(text())
  end

  def testDecode([]) do [] end
  def testDecode([text | tail]) do
    length = length(text)

    x = Huffman.tree(text)
    table = Huffman.encode_table(x)

    seq = Huffman.encode(text, table)

    {decode, _} = :timer.tc(fn() ->
          Huffman.decode(seq, table)
        end)
    #:io.format("# Length of text ~w: Decode time: ~6w\n", [length, decode])
    :io.format("# Length of text ~w: \n", [length])
    :io.format("# Decode time: ~6.2f ms\n\n", [decode/1000])

    testDecode(tail)
  end
end
