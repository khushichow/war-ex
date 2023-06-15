defmodule War do
  @moduledoc """
    Documentation for `War`.
  """

  @doc """
    Function stub for deal/1 is given below. Feel free to add
    as many additional helper functions as you want.

    The tests for the deal function can be found in test/war_test.exs.
    You can add your five test cases to this file.

    Run the tester by executing 'mix test' from the war directory
    (the one containing mix.exs)
  """

  def deal(deck) do
    # replaces every occurence of 1 with 14
    newDeck = replace(deck, 1, 14)
    # extracts player 1 and 2
    player1 = players(newDeck, 1)
    player2 = players(newDeck, 2)
    # replaces 14 back to 1
    replace(win(player1, player2), 14, 1)
  end

  # seperated the cards into 2 lists in a tuple
  def players(cards, pnum) do
    tup = {Enum.take_every(cards, 2), Enum.drop_every(cards, 2)}
    if pnum == 1 do
      pl1 = elem(tup, 0)
      x = Enum.reverse(pl1)
      x
    else
      pl2 = elem(tup, 1)
      y = Enum.reverse(pl2)
      y
    end
  end

  # function to replace a number with another number in the deck
  def replace(cards, from, to) do
    cards
    |> Enum.map(fn
      ^from -> to
      num -> num
    end)
  end

  # player wins if other player is empty
  def win(p1wins, []), do: p1wins
  def win([], p2wins), do: p2wins

  # if neither is empty, win function taker it in
  def win(p1, p2) do
    # if player 2 is greater, add cards to bottom of player 2 deck and remove from top
    if (hd(p1) < hd(p2)) do
      p2 = p2 ++ [hd(p2)]
      p2 = p2 ++ [hd(p1)]
      p2 = List.delete_at(p2, 0)
      p1 = List.delete_at(p1, 0)
      win(p1, p2)
      # if player 1 is greater, add cards to bottom of player 1 deck and remove from top
    else if (hd(p1) > hd(p2)) do
      p1 = p1 ++ [hd(p1)]
      p1 = p1 ++ [hd(p2)]
      p1 = List.delete_at(p1, 0)
      p2 = List.delete_at(p2, 0)
      win(p1, p2)
      # if both cars are equal, go to war
    else
      war(p1, p2, [])
    end
  end
end

  #tie if both players ran out
  def war([], [], tie), do: tie
  # add war cards to player 1 when player 2 is empty
  def war(p1, [], list), do: win(p1 ++ list, [])
  # add war cards to player 2 when player 1 is empty
  def war([], p2, list), do: win([], p2 ++ list)

  def war(p1, p2, list) do
    # one of the players has 1 card
    # determine tie or winner from empty deck posibilities above
    if (length(p1) == 1 or length(p2) == 1) and hd(p1) == hd(p2) do
      list = list ++ [hd(p1)]
      p1 = List.delete_at(p1, 0)
      list = list ++ [hd(p2)]
      p2 = List.delete_at(p2, 0)
      list = Enum.reverse(Enum.sort(list))
      war(p1, p2, list)
    # all players have more than 1
    else if  length(p1) >= 2 and length(p2) >= 2 and hd(p1) == hd(p2) do
      # make list of war cards and take aditional card for face down
      list = list ++ [hd(p1)]
      p1 = List.delete_at(p1, 0)
      list = list ++ [hd(p2)]
      p2 = List.delete_at(p2, 0)
      list = list ++ [hd(p1)]
      p1 = List.delete_at(p1, 0)
      list = list ++ [hd(p2)]
      p2 = List.delete_at(p2, 0)
      # make war list into descending order
      list = Enum.reverse(Enum.sort(list))
      war(p1, p2, list)

    else
      list = list ++ [hd(p1)]
      list = list ++ [hd(p2)]
      # determining winner of war and adding war cards to winner in descending order
        if (hd(p1) > hd(p2)) do
          p1 = p1 ++ Enum.reverse(Enum.sort(list))
          p1 = List.delete_at(p1, 0)
          p2 = List.delete_at(p2, 0)
          win(p1, p2)
        else
          p2 = p2 ++ Enum.reverse(Enum.sort(list))
          p2 = List.delete_at(p2, 0)
          p1 = List.delete_at(p1, 0)
          win(p1, p2)
        end
      end
    end
  end
end
