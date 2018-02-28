defmodule ImitateText do
  @moduledoc """
  Documentation for ImitateText.
  """

  @doc """


  """
  # # # EXPOSED # # #
  def imitate_text(text, word_count, options \\ []) do
    word_list = get_word_list(text, options)
    words_to_followers = build_frequency_dictionary(word_list)
    generate_chain(words_to_followers, word_count)
  end


  # # # PRIVATE # # #

  # word list
  defp get_word_list(text, options) do
    strip_punctuation? = Keyword.get(options, :strip_punctuation, false)
    text
    |> handle_punctuation(strip_punctuation?)
    |> String.split(~r{[^\S]}) |> Enum.map(&clean(&1))
  end

  defp handle_punctuation(text, strip_punctuation?) do
    if strip_punctuation? do
      text |> String.replace(~r{([^a-zA-Z])([\s\r])}, "\\g{2}", [global: true])
    else
      text
    end
  end

  defp clean(word) do
    word |> String.trim() |> String.upcase()
  end

  # frequency dictionary
  defp build_frequency_dictionary(word_list) do
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

  # build chain
  defp generate_chain(words_to_followers, remaining_word_count, prev_word \\ nil) do
    if remaining_word_count < 1 do
      ""
    else
      word = get_next_word(words_to_followers, prev_word)
      word <> " " <> generate_chain(words_to_followers, remaining_word_count - 1, word)
      |> String.trim
    end
  end

  defp get_next_word(words_to_followers, prev_word) do
    case words_to_followers[prev_word] do
      nil ->
        random_restart(words_to_followers)

      freq_map ->
        {k, _} = Enum.max_by(freq_map, fn {_k, v} -> v * :rand.uniform(10) end)
        k
    end
  end

  defp random_restart(words_to_followers) do
    Map.keys(words_to_followers)
    |> Enum.at(:rand.uniform(Enum.count(words_to_followers)))
  end

end
