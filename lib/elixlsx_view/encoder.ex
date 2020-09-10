defmodule ElixlsxView.Encoder do
  @moduledoc """
  Module is used as data encoder for Phoenix views with `Elixlsx`
  library as backend.
  """

  alias Elixlsx.Workbook

  @doc false
  def encode_to_iodata!(%Workbook{} = data) do
    {:ok, {_, iodata}} = Elixlsx.write_to_memory(data, "response.xlsx")
    iodata
  end
end
