defmodule ImitateText do
  @moduledoc """
  Uses Markov Chain to generate imitations of input text
  """

  @doc """
  Generates imitations of input text. Takes
  * text - a string to be imitated
  * word_count - integer representing the desired length of the imitation
  * options - array of configurable options
    - :strip_punctuation - boolean determining whether the function should
      strip punctuation before processing the text. Default false.

  ### Examples
  iex> text = "I love her but I don't think she knows that I love her. I think she loves me, but does she know she loves me?"
  iex> ImitateText.generate(text, 5)
  "HER. I LOVE HER. I LOVE HER BUT I LOVE"

  """
  # # # EXPOSED # # #
  def generate(text, word_count, options \\ []) do
    word_list = get_word_list(text, options)
    frequency_table = build_frequency_table(word_list)
    generate_chain(frequency_table, word_count)
  end


  # # # PRIVATE # # #

  # - word list -

  # Helper function:
  # Splits a text on whitespace and newlines. Strips punctuation if
  # specified in options.
  defp get_word_list(text, options) do
    strip_punctuation? = Keyword.get(options, :strip_punctuation, false)
    text
    |> handle_punctuation(strip_punctuation?)
    |> String.split(~r{[^\S]}) |> Enum.map(&clean(&1))
  end

  # Helper function:
  # Takes a text and boolean strip_punctuation?
  # If strip_punctuation? is true, returns text without punctuation
  # Otherwise returns text unaltered
  defp handle_punctuation(text, strip_punctuation?) do
    if strip_punctuation? do
      text |> String.replace(~r{([^a-zA-Z])([\s\r])}, "\\g{2}", [global: true])
    else
      text
    end
  end

  # Helper function:
  # Trims and upcases a word
  defp clean(word) do
    word |> String.trim() |> String.upcase()
  end

  #  - frequency table -
  # Helper function:
  # Takes a list of word and produces a map whose keys are the words
  # and whose values are maps, mapping the words that follow the original
  # word to their frequencies
  # e.g.
  #  %{
  #   "BUT" => %{"DOES" => 1, "I" => 2},
  #   "DOES" => %{"SHE" => 1} ...}
  # indicates that "BUT" is followed once by "DOES" and twice by "I"
  defp build_frequency_table(word_list) do
    word_list
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {word, idx}, dict ->
      Map.update(
        dict,
        Enum.at(word_list, idx - 1),
        %{word => 1},
        &Map.update(&1, word, 1, fn a -> a + 1 end)
      )
    end)
  end

  # - build chain -

  # Helper function:
  # Recursively builds a chain of words. To select a follower for a given word,
  # assigns probablities to words observed to follow that word in the original
  # text, based on their frequency.
  defp generate_chain(frequency_table, remaining_word_count, prev_word \\ nil) do
    if remaining_word_count < 1 do
      ""
    else
      word = get_next_word(frequency_table, prev_word)
      word <> " " <> generate_chain(frequency_table, remaining_word_count - 1, word)
      |> String.trim
    end
  end

  # Helper function:
  # Chooses the next using the frequency table. If no candidate words can be
  # found, randomly chooses a word from the text.
  defp get_next_word(frequency_table, prev_word) do
    case frequency_table[prev_word] do
      nil ->
        random_restart(frequency_table)

      freq_map ->
        {k, _} = Enum.max_by(freq_map, fn {_k, v} -> v * :rand.uniform(10) end)
        k
    end
  end

  # Helper function:
  # Chooses a random key from the frequency table, i.e. a random word from
  # the original text
  defp random_restart(frequency_table) do
    Map.keys(frequency_table)
    |> Enum.at(:rand.uniform(Enum.count(frequency_table)-1))
  end

end
