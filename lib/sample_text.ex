defmodule SampleText do
  @moduledoc """
  Documentation for ImitateText.
  """

  @doc """


  """
def get(key) do
    case key do
      :js_code ->
        """
        /* Global constants */
const canvasId = "myCanvas";
const rounds = [new Round("red"), new Round("blue")]


/* Define round behavior */
function Round(canvasColor){
if(canvasColor){
  this.initialize = () => {
    const canvas = document.getElementById(canvasId);
    const ctx = canvas.getContext("2d");
    ctx.fillStyle = canvasColor;
    ctx.fillRect(0, 0, canvas.width, canvas.height);
  }
}
else{
  throw("invalid round!!!")
}
}


/* Define switching rounds behavior*/
function nextRound(rounds){
if(rounds.length){
  const round = rounds.shift();
  round.initialize();
}
else{
  alert('GAME OVER!!!')
}

}


/* Hook up "Next Round" button */
const nextRoundBtn = document.getElementById('next-round-btn');
nextRoundBtn.onclick = nextRound.bind(this, rounds)

/* Start Game */
nextRound(rounds);

        """
      :elixir_code ->
        """
        defmodule Imitate do
    def imitate_text(text, word_count) do
        word_list = get_word_list(text)
        words_to_followers = build_frequency_dictionary(word_list)
        a = generate_chain(words_to_followers, word_count)

       IO.inspect a

    end

    defp generate_chain(words_to_followers, remaining_word_count, prev_word \\ nil) do

        case remaining_word_count do
            0 ->
                ""
            _ ->
              random_word = Enum.at(Map.keys(words_to_followers),:rand.uniform(Enum.count(words_to_followers)))
              word =
                case prev_word do
                    nil ->
                        random_word #TODO: combine null cases???
                    _ ->
                      case words_to_followers[prev_word] do
                        nil ->
                            random_word
                        freq_map ->
                            {k, _} = Enum.max_by(freq_map, fn {_k,v} ->  v * :rand.uniform(10) end)
                            k

                      end

                end
              word <> " " <> generate_chain(words_to_followers, remaining_word_count-1, word)
        end

    end


    defp get_word_list(text) do
        String.split(text, ~r{[\n\r\s]+}) |> Enum.map(&(clean(&1)))
    end

    defp build_frequency_dictionary(word_list) do #TODO: strip punctuation. BETTER NAME!!! check line ends, e.g. o'er
        word_list
        |> Enum.with_index
        |> Enum.reduce(%{}, fn({word, idx}, dict) ->
            Map.update(dict, Enum.at(word_list, idx-1), %{word => 1}, &(Map.update(&1, word, 1, fn a -> a+1 end)))
        end)
    end

    defp clean(word) do
        word |> String.trim |> String.upcase |> String.replace(~r{[^a-zA-Z]}, "")
    end




end

Imitate.imitate_text(text, 20)

        """
      :queen_mab ->
        """
        O, then, I see Queen Mab hath been with you.
        She is the fairies' midwife, and she comes
        In shape no bigger than an agate-stone
        On the fore-finger of an alderman,
        Drawn with a team of little atomies
        Athwart men's noses as they lie asleep;
        Her wagon-spokes made of long spiders' legs,
        The cover of the wings of grasshoppers,
        The traces of the smallest spider's web,
        The collars of the moonshine's watery beams,
        Her whip of cricket's bone, the lash of film,
        Her wagoner a small grey-coated gnat,
        Not so big as a round little worm
        Prick'd from the lazy finger of a maid;
        Her chariot is an empty hazel-nut
        Made by the joiner squirrel or old grub,
        Time out o' mind the fairies' coachmakers.
        And in this state she gallops night by night
        Through lovers' brains, and then they dream of love;
        O'er courtiers' knees, that dream on court'sies straight,
        O'er lawyers' fingers, who straight dream on fees,
        O'er ladies' lips, who straight on kisses dream,
        Which oft the angry Mab with blisters plagues,
        Because their breaths with sweetmeats tainted are:
        Sometime she gallops o'er a courtier's nose,
        And then dreams he of smelling out a suit;
        And sometime comes she with a tithe-pig's tail
        Tickling a parson's nose as a' lies asleep,
        Then dreams, he of another benefice:
        Sometime she driveth o'er a soldier's neck,
        And then dreams he of cutting foreign throats,
        Of breaches, ambuscadoes, Spanish blades,
        Of healths five-fathom deep; and then anon
        Drums in his ear, at which he starts and wakes,
        And being thus frighted swears a prayer or two
        And sleeps again. This is that very Mab
        That plats the manes of horses in the night,
        And bakes the elflocks in foul sluttish hairs,
        Which once untangled, much misfortune bodes:
        This is the hag, when maids lie on their backs,
        That presses them and learns them first to bear,
        Making them women of good carriage:
        This is she -
        """
      _ ->
        ":/"
      end
  end
end
