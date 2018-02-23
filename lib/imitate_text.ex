defmodule ImitateText do
  @moduledoc """
  Documentation for ImitateText.
  """

  @doc """

    OPTIONS:
      :strip_punctuation

  """
  def display(text) do #TODO: delete
     text |> String.split("\n") |> Enum.map(&(IO.inspect(&1)))
     ""
  end
  def imitate_text(text, word_count, options \\ []) do
        word_list = get_word_list(text, options)
        words_to_followers = build_frequency_dictionary(word_list)
        generate_chain(words_to_followers, word_count)
    end

    defp generate_chain(words_to_followers, remaining_word_count, prev_word \\ nil) do

        case remaining_word_count do
            0 ->
                ""
            _ ->
              word =
                  case words_to_followers[prev_word] do
                    nil ->
                        Enum.at(Map.keys(words_to_followers),:rand.uniform(Enum.count(words_to_followers)))
                    freq_map ->
                        {k, _} = Enum.max_by(freq_map, fn {_k,v} ->  v * :rand.uniform(10) end)
                        k

                  end

              word <> " " <> generate_chain(words_to_followers, remaining_word_count-1, word) |> String.trim
        end

    end


    defp get_word_list(text, options) do
        text |> String.split(~r{[^\S\n]}) |> Enum.map(&(clean(&1)))
    end

    defp handle_punctuation(text, options) do
      strip_punctuation = Keyword.get(options, :strip_punctuation, false)
      if strip_punctuation do
        text |> String.replace(~r{[^a-zA-Z]}, "")
      else
        text |> String.replace(~r{([^a-zA-Z])\s}, "\\g{1} ")
      end
    end

    defp build_frequency_dictionary(word_list) do #TODO: strip punctuation. BETTER NAME!!! check line ends, e.g. o'er
        word_list
        |> Enum.with_index
        |> Enum.reduce(%{}, fn({word, idx}, dict) ->
            Map.update(dict, Enum.at(word_list, idx-1), %{word => 1}, &(Map.update(&1, word, 1, fn a -> a+1 end)))
        end)
    end

    defp clean(word) do
        word |> String.trim #|> String.upcase
    end


end
