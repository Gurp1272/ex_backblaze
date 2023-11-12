defmodule ExBackblazeTest do
  use ExUnit.Case
  doctest ExBackblaze

  alias ExBackblaze.Tokens
  alias ExBackblaze.Tokens.Token

  test "greets the world" do
    assert ExBackblaze.hello() == :world
  end

  setup_all do
    {:ok, application_key_id: "005e79a40da14a10000000001", application_key: "K005W+oZvVAIagPeUZy/wCLkq9j+OmY"}
  end

  @integration
  test "ExBackblaze.Tokens.authorize/2", state do
    assert Tokens.authorize(state[:application_key_id], state[:application_key]) == {:ok, %Token{}}
  end
end
