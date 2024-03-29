defmodule ExBackblazeTest do
  use ExUnit.Case
  doctest ExBackblaze

  alias ExBackblaze.Tokens
  alias ExBackblaze.Tokens.Token

  test "greets the world" do
    assert ExBackblaze.hello() == :world
  end

  # setup_all do
  #   {:ok, application_key_id: "null", application_key: "null"}
  # end

  # @integration
  # test "ExBackblaze.Tokens.authorize/2", state do
  #   assert Tokens.authorize(state[:application_key_id], state[:application_key]) == {:ok, %Token{}}
  # end
end
